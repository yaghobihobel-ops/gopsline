<?php
require 'php-jwt/vendor/autoload.php';
use Firebase\JWT\JWT;
use Firebase\JWT\Key;


class Apiv2Controller extends CController
{
    public $code=2,$msg,$details,$data;

    public function __construct($id,$module=null){
		parent::__construct($id,$module);				
		// Set the application language if provided by GET, session or cookie
		if(isset($_GET['language'])) {
			Yii::app()->language = $_GET['language'];
			Yii::app()->user->setState('language', $_GET['language']); 
			$cookie = new CHttpCookie('language', $_GET['language']);
			$cookie->expire = time() + (60*60*24*365); // (1 year)
			Yii::app()->request->cookies['language'] = $cookie; 
		} else if (Yii::app()->user->hasState('language')){
			Yii::app()->language = Yii::app()->user->getState('language');			
		} else if(isset(Yii::app()->request->cookies['language'])){
			Yii::app()->language = Yii::app()->request->cookies['language']->value;			
			if(!empty(Yii::app()->language) && strlen(Yii::app()->language)>=10){
				Yii::app()->language = KMRS_DEFAULT_LANGUAGE;
			}
		} else {
			$options = OptionsTools::find(['default_language']);
			$default_language = isset($options['default_language'])?$options['default_language']:'';			
			if(!empty($default_language)){
				Yii::app()->language = $default_language;
			} else Yii::app()->language = KMRS_DEFAULT_LANGUAGE;
		}		
	}

    public function beforeAction($action)
	{							
		$method = Yii::app()->getRequest()->getRequestType();    		
		if($method=="POST"){
			$this->data = Yii::app()->input->xssClean(json_decode(file_get_contents('php://input'), true));
		} else if($method=="GET"){
		   $this->data = Yii::app()->input->xssClean($_GET);				
		} elseif ($method=="OPTIONS" ){
			$this->responseJson();
		} else $this->data = Yii::app()->input->xssClean($_POST);		
		
		return true;
	}

	public function init()
	{
		$settings = OptionsTools::find(array(
			'website_date_format_new','website_time_format_new','home_search_unit_type','website_timezone_new',	
			'multicurrency_enabled','multicurrency_enabled_checkout_currency'
		));		
		
		Yii::app()->params['settings'] = $settings;

		/*SET TIMEZONE*/
		$timezone = Yii::app()->params['settings']['website_timezone_new'];		
		if (is_string($timezone) && strlen($timezone) > 0){
		Yii::app()->timeZone=$timezone;		   
		}
		Price_Formatter::init();		
	}

    public function responseJson()
    {
		header("Access-Control-Allow-Origin: *");          
        header("Access-Control-Allow-Methods: OPTIONS,GET,POST,PUT,DELETE");
        header("Access-Control-Max-Age: 3600");
        header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    	header('Content-type: application/json'); 
		$resp=array('code'=>$this->code,'msg'=>$this->msg,'details'=>$this->details);
		echo CJSON::encode($resp);
		Yii::app()->end();
    } 

	public function filters()
    {
        return array(
            'accessControl',
        );
    }

	public function accessRules()
	{						
		return array(			
             array('deny',				
                  'actions'=>array(
                    'Paypalprocesspayment','PaypalVerifyPayment'
                 ), 
				 'expression' => array('AppIdentity','verifyCustomer')
			 ), 
		 );
	}

	public function actionPaypalprocesspayment()
	{
		try {
			
			$data = isset($this->data['data'])?$this->data['data']:'';		
			$transaction_id = isset($this->data['transaction_id'])?$this->data['transaction_id']:'';
			$order_id = isset($this->data['order_id'])?$this->data['order_id']:'';		

			$jwt_key = new Key(CRON_KEY, 'HS256');
			$decoded = (array) JWT::decode($data, $jwt_key); 
			
			$payment_code = isset($decoded['payment_code'])?$decoded['payment_code']:'';
			$payment_name = isset($decoded['payment_name'])?$decoded['payment_name']:'';
			$merchant_id = isset($decoded['merchant_id'])?$decoded['merchant_id']:'';
			$merchant_type = isset($decoded['merchant_type'])?$decoded['merchant_type']:'';
			$payment_description = isset($decoded['payment_description'])?$decoded['payment_description']:'';
			$payment_description_raw = isset($decoded['payment_description_raw'])?$decoded['payment_description_raw']:'';
			$transaction_description_parameters = isset($decoded['transaction_description_parameters'])?$decoded['transaction_description_parameters']:'';
			$amount = isset($decoded['amount'])?$decoded['amount']:'';			
			$transaction_amount = isset($decoded['transaction_amount'])?$decoded['transaction_amount']:0;			
			$currency_code = isset($decoded['currency_code'])?$decoded['currency_code']:'';
			$payment_type = isset($decoded['payment_type'])?$decoded['payment_type']:'';		
			$reference_id = isset($decoded['reference_id'])?$decoded['reference_id']:'';		

			$payment_details = isset($decoded['payment_details'])?(array)$decoded['payment_details']:'';
			$payment_customer_id = isset($payment_details['payment_customer_id'])?$payment_details['payment_customer_id']:'';
			$payment_method_id = isset($payment_details['payment_method_id'])?$payment_details['payment_method_id']:'';					
			
			$credentials = CPayments::getPaymentCredentials($merchant_id,$payment_code,$merchant_type);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';		
			
			$is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;

			CPaypalTokens::setProduction($is_live);
			CPaypalTokens::setCredentials($credentials,$payment_code);
			$token = CPaypalTokens::getToken(date("c"));

			CPaypal::setProduction($is_live);
		    CPaypal::setToken($token);		    	
		    $resp = CPaypal::getOrders($order_id);

			if($payment_type=="add_funds"){
                $card_id = CWallet::createCard( Yii::app()->params->account_type['digital_wallet'],Yii::app()->user->id);				   
                $meta_array = [];
                try {
                   $date_now = date("Y-m-d");
                   $bonus = AttributesTools::getDiscountToApply($transaction_amount,CDigitalWallet::transactionName(),$date_now);
                   $transaction_amount = floatval($transaction_amount)+floatval($bonus);				  
                   $meta_array[]=[
                     'meta_name'=>'topup_bonus',
                     'meta_value'=>floatval($bonus)
                   ];
                   $payment_description_raw = "Funds Added via {payment_name} with {bonus} Bonus";
                   $transaction_description_parameters = [
                     '{payment_name}'=>$payment_name,
                     '{bonus}'=>Price_Formatter::formatNumber($bonus),
                   ];
                 } catch (Exception $e) {}
 
                 CPaymentLogger::afterAdddFunds($card_id,[				    
                     'transaction_description'=>$payment_description_raw,
                     'transaction_description_parameters'=>$transaction_description_parameters,
                     'transaction_type'=>'credit',
                     'transaction_amount'=>$transaction_amount,
                     'status'=>CPayments::paidStatus(),
                     'reference_id'=>$reference_id,
                     'reference_id1'=>CDigitalWallet::transactionName(),
                     'merchant_base_currency'=>$currency_code,
                     'admin_base_currency'=>$currency_code,
                     'meta_name'=>'topup',
                     'meta_value'=>$card_id,
                     'meta_array'=>$meta_array,			
                ]);
             } elseif ($payment_type=="file_storage") {
                 # code...
             }

            Price_Formatter::init($currency_code);

			$this->code = 1;
			$this->msg = t("Payment successful. please wait while we redirect you.");
			$this->details = array(  					  
				'payment_name'=>$payment_name,
				'transaction_id'=>$transaction_id,
				'amount'=>Price_Formatter::formatNumber($amount),
				'amount_raw'=>$amount,
				'transaction_date'=>Date_Formatter::dateTime(date('c'))
			);
		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}
  
	public function actionPaypalVerifyPayment()
	{
		try {
			
			Yii::import('application.modules.paypal.components.*');

			$transaction_id = isset($this->data['transaction_id'])?$this->data['transaction_id']:'';
			$order_id = isset($this->data['order_id'])?$this->data['order_id']:'';
			$order_uuid = isset($this->data['order_uuid'])?$this->data['order_uuid']:'';
			$cart_uuid = isset($this->data['cart_uuid'])?$this->data['cart_uuid']:'';

			$data = AR_ordernew::model()->find('order_uuid=:order_uuid',array(':order_uuid'=>$order_uuid));
			if($data){
				$merchant = CMerchantListingV1::getMerchant($data->merchant_id);
				$credentials = CPayments::getPaymentCredentials($data->merchant_id,$data->payment_code,
		    	$merchant->merchant_type);
			    $credentials = isset($credentials[$data->payment_code])?$credentials[$data->payment_code]:'';
				$is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;

				CPaypalTokens::setProduction($is_live);
			    CPaypalTokens::setCredentials($credentials,$data->payment_code);
			    $token = CPaypalTokens::getToken(date("c"));

				CPaypal::setProduction($is_live);
		    	CPaypal::setToken($token);		    	
		    	$resp = CPaypal::getOrders($order_id);

				$data->scenario = "new_order";
		    	$data->status = COrders::newOrderStatus();
		    	$data->payment_status = CPayments::paidStatus();
		    	$data->cart_uuid = $cart_uuid;
		    	$data->save();
				
				$model = new AR_ordernew_transaction;
				$model->order_id = $data->order_id;
				$model->merchant_id = $data->merchant_id;
				$model->client_id = $data->client_id;
				$model->payment_code = $data->payment_code;				
				$model->trans_amount = $data->amount_due>0? $data->amount_due: $data->total;
				$model->currency_code = $data->use_currency_code;
				$model->payment_reference = $transaction_id;
				$model->status = CPayments::paidStatus();
				$model->reason = isset($resp['status'])?$resp['status']:'';

				if($model->save()){					
					$params = array(  
						array('transaction_id'=>$model->transaction_id,'order_id'=>$data->order_id, 
						'meta_name'=>'order_id', 'meta_value'=>$order_uuid ),
											   
						array('transaction_id'=>$model->transaction_id,'order_id'=>$data->order_id, 
						'meta_name'=>'transaction_id', 'meta_value'=>$transaction_id ),
						 
					 );                    
					 $builder=Yii::app()->db->schema->commandBuilder;
					 $command=$builder->createMultipleInsertCommand('{{ordernew_trans_meta}}',$params);
					 $command->execute();		
 
					 $this->code = 1;
					 $this->msg = t("Payment successful. please wait while we redirect you.");
									 
					 $this->details = array(  					  
					   'order_uuid'=>$data->order_uuid
					 );
				} else $this->msg = $model->getErrors();
			} else $this->msg = t("Order id not found");
		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actioncreatesubscriptions()
	{
		try {

			$payment_code = PaypalModule::paymentCode();			
			$payment_id = Yii::app()->input->post('payment_id');			
			$payment = Cplans::getPaymentCreated($payment_id);	
			$package_id = $payment->package_id;	
			$subscriber_id = $payment->subscriber_id;
			$subscriber_type = $payment->subscriber_type;

			$meta_name = "plan_price_$payment_code";						
			$price = Cplans::planPriceID($meta_name,$package_id);
			$price_id = $price->meta_value;	

			
			$callback_url = Yii::app()->createAbsoluteUrl($payment_code."/apiv2/subscription_callback?payment_id=".$payment_id);	

			try {
				$subscriber_model =  Cplans::getSubscriberRecords($subscriber_id,$subscriber_type,'model');
				$subscriber_model->package_id = $package_id;
				$subscriber_model->package_payment_code = $payment_code;
				$subscriber_model->save();
			} catch (Exception $e) {}	

			$this->code = 1;
			$this->msg = "Ok";
			$this->details = [
				'price_id'=>$price_id,
				'callback_url'=>$callback_url
			];
		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actionsubscription_callback()
	{
		try {
						
			$payment_id = Yii::app()->input->get('payment_id');			
			$subscription_id = Yii::app()->input->get('subscription_id');
			$payment_code = PaypalModule::paymentCode();

			$payment = Cplans::getPaymentCreated($payment_id);	
			$package_id = $payment->package_id;		
			$subscriber_id = $payment->subscriber_id;
			$subscriber_type = $payment->subscriber_type;
			$sucess_url = $payment->success_url;
			$failed_url = $payment->failed_url;		
			$jobs = $payment->jobs;		
			
			$plans = Cplans::get($package_id);			

			$credentials = CPayments::getPaymentCredentials(0,$payment_code);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';			
			$is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;
			
			CPaypalTokens::setProduction($is_live);
			CPaypalTokens::setCredentials($credentials,$payment_code);
			$token = CPaypalTokens::getToken(date("c"));			
			
			CPaypal::setProduction($is_live);
			CPaypal::setToken($token);		
			
			$resp = CPaypal::getSubscriptionDetails($subscription_id);
			$start_time = isset($resp['start_time'])?  date("Y-m-d",strtotime($resp['start_time']))  :'';			
			$create_time = isset($resp['create_time'])?  date("Y-m-d",strtotime($resp['create_time']))  :'';			
			$billing_info = isset($resp['billing_info'])?$resp['billing_info']:null;
			$next_due = isset($billing_info['next_billing_time'])?   date("Y-m-d",strtotime($billing_info['next_billing_time'])):null;
			$last_payment = isset($billing_info['last_payment'])?$billing_info['last_payment']:null;
			$data_amount = isset($last_payment['amount'])?$last_payment['amount']:null;
			$amount = isset($data_amount['value'])?$data_amount['value']:0;
			$currency_code = isset($data_amount['currency_code'])?$data_amount['currency_code']:0;
						
			$model = new AR_plan_subscriptions();
			$model->payment_id = $payment_id;
			$model->payment_code = $payment_code;
			$model->subscriber_id = $subscriber_id;
			$model->package_id = $package_id;
			$model->plan_name = $plans->title;
			$model->billing_cycle = $plans->package_period;
			$model->amount = floatval($amount);
			$model->currency_code = $currency_code;
			$model->subscriber_type = $subscriber_type;
			$model->subscription_id = $subscription_id;		
			$model->status = 'active';
			$model->jobs = $jobs;
			$model->sucess_url = $sucess_url;
			$model->failed_url = $failed_url;		
			$model->created_at = $create_time;				
			$model->next_due = $next_due;			
			$model->expiration = $next_due;
			$model->current_start = $start_time;
			$model->current_end = $next_due;			
			if($model->save()){				
				$this->redirect($sucess_url);
			} else $this->msg = CommonUtility::parseModelErrorToString($model->getErrors());			
		} catch (Exception $e) {
			$this->msg = $e->getMessage();			
		}			
		$this->redirect($failed_url);
	}

	public function actioncancelsubscriptions()
	{
		try {

			$subscription_id = Yii::app()->input->get('subscription_id');
			$payment_code = PaypalModule::paymentCode();
			$credentials = CPayments::getPaymentCredentials(0,$payment_code);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';			
			$is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;
			
			CPaypalTokens::setProduction($is_live);
			CPaypalTokens::setCredentials($credentials,$payment_code);
			$token = CPaypalTokens::getToken(date("c"));			
			
			CPaypal::setProduction($is_live);
			CPaypal::setToken($token);	
			
			$resp = CPaypal::CancelSubscriptions($subscription_id);

			$model = Cplans::getSubscriptionByID($subscription_id);				
			$model->status = 'cancelled';
			$model->save();

			$this->code = 1;
			$this->msg = "Ok";		

		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actionupdatesubscriptions()
	{
		try {

			$payment_id = Yii::app()->input->post('payment_id');
			$payment_code = PaypalModule::paymentCode();

			$payment = Cplans::getPaymentCreated($payment_id);	
			$package_id = $payment->package_id;		
			$subscriber_id = $payment->subscriber_id;
			$subscriber_type = $payment->subscriber_type;
			$sucess_url = $payment->success_url;
			$failed_url = $payment->failed_url;	
			$jobs = $payment->jobs;	
						
			$meta_name = "plan_price_$payment_code";						
			$price = Cplans::planPriceID($meta_name,$package_id);
			$price_id = $price->meta_value;						
			
			$credentials = CPayments::getPaymentCredentials(0,$payment_code);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';			
			$is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;
			
			CPaypalTokens::setProduction($is_live);
			CPaypalTokens::setCredentials($credentials,$payment_code);
			$token = CPaypalTokens::getToken(date("c"));			
			
			CPaypal::setProduction($is_live);
			CPaypal::setToken($token);	

			$next_actions = '';
			$subscription_id = '';
			$active_plan = null;

			try {
				$active_plan =  Cplans::getActiveSubscriptions2($subscriber_id,$subscriber_type,$payment_code);				
				$subscription_id = $active_plan->subscription_id;						    
			} catch (Exception $e) {	
				$next_actions = 'subscribe';
			}						

			if($active_plan){								
				CPaypal::UpdateSubscriptions($subscription_id,$price_id);		
				$active_plan->status = "active";
				$active_plan->package_id = $package_id;
				$active_plan->save();		
				
				// $jobs_data = [
				// 	'subscription_id'=>$subscription_id,
				// 	'package_id'=>$package_id,
				// 	'subscriber_type'=>$subscriber_type,
				// 	'subscriber_id'=>$subscriber_id
				// ];
				// if (class_exists($jobs)) {						
				// 	$jobInstance = new $jobs($jobs_data);
				//     $jobInstance->execute();		
				// }
			}
			
						
			$this->code = 1;
			$this->msg = "Ok";
			$this->details = [
				'next_actions'=>$next_actions,
				'redirect_url'=>$sucess_url
			];

		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actionWebhooksplans()
	{
		try {

			$logs = '';
			$payment_code = PaypalModule::paymentCode();			
			
			$payload = file_get_contents("php://input");			
			$payload = json_decode($payload,true);			

			if (is_array($payload) && !empty($payload)) {
				//echo "The response is a non-empty array.";
			} elseif (is_array($payload)) {				
				Yii::log( "The response is an empty array." , CLogger::LEVEL_INFO);
				http_response_code(200);
				Yii::app()->end();
			} else {				
				Yii::log( "The response is not an array." , CLogger::LEVEL_INFO);
				http_response_code(200);
				Yii::app()->end();
			}            
									
			$event = isset($payload['event_type'])?$payload['event_type']:null;						
			$webhook_id = isset($payload['id'])?$payload['id']:null;
			
			if(Cplans::isWebhookFound($webhook_id)){
				Yii::log( "Webhook even already exist $webhook_id" , CLogger::LEVEL_INFO);
				http_response_code(200);
				Yii::app()->end();
			}			
		
			switch ($event) {
				case "BILLING.SUBSCRIPTION.ACTIVATED":
					$resource = isset($payload['resource'])?$payload['resource']:'';
					$subscription_id = isset($resource['id'])?$resource['id']:null;
					$model = Cplans::getSubscriptionByID($subscription_id);	
					CommonUtility::pushJobs("MerchantRegWelcome",[
						'merchant_id'=>$model->subscriber_id,
						'language'=>Yii::app()->language
					]);
					break;

				case "BILLING.SUBSCRIPTION.CREATED":
					$resource = isset($payload['resource'])?$payload['resource']:'';
					$subscription_id = isset($resource['id'])?$resource['id']:null;
					$start_time = isset($resource['start_time'])?  date("Y-m-d",strtotime($resource['start_time']))  :'';			
			        $create_time = isset($resource['create_time'])?  date("Y-m-d",strtotime($resource['create_time']))  :'';			
					
					$billing_info = isset($resource['billing_info'])?$resource['billing_info']:null;
					$next_due = isset($billing_info['next_billing_time'])?   date("Y-m-d",strtotime($billing_info['next_billing_time'])):null;
					$last_payment = isset($billing_info['last_payment'])?$billing_info['last_payment']:null;
					$data_amount = isset($last_payment['amount'])?$last_payment['amount']:null;
					$amount = isset($data_amount['value'])?$data_amount['value']:0;
					$currency_code = isset($data_amount['currency_code'])?$data_amount['currency_code']:0;
					
					$model = Cplans::getSubscriptionByID($subscription_id);					
					if($model){						
						$jobs = $model->jobs;
						$jobs_data = [
							'subscription_id'=>$subscription_id,
							'package_id'=>$model->package_id,
							'subscriber_type'=>$model->subscriber_type,
							'subscriber_id'=>$model->subscriber_id,		
							'is_new'=>false
						];
						if (!class_exists($jobs)) {				
							Yii::log( "Job class $jobs does not exist." , CLogger::LEVEL_INFO);
							http_response_code(200);
							Yii::app()->end();										
						}
						$jobInstance = new $jobs($jobs_data);
                        $jobInstance->execute();	
						
						// CANCEL OLD SUBSCRIPTIONS
						Cplans::cancelPaymentSubscriptions($model->subscriber_type,$model->subscriber_id,$model->payment_code);

					}
					break;
					
					case "BILLING.SUBSCRIPTION.CANCELLED":
						$resource = isset($payload['resource'])?$payload['resource']:'';
					    $subscription_id = isset($resource['id'])?$resource['id']:null;						
						$model = Cplans::getSubscriptionByID($subscription_id);							
						$model->status = 'cancelled';
					    $model->save();						

						CommonUtility::pushJobs("SubscriptionsCancelled",[
							'id'=>$model->id,								
							'language'=>Yii::app()->language
						]);

						$logs = "Paypal subscription cancelled $subscription_id";						
						break;

					case "BILLING.SUBSCRIPTION.PAYMENT.FAILED":
						$resource = isset($payload['resource'])?$payload['resource']:'';
					    $subscription_id = isset($resource['id'])?$resource['id']:null;						
						$model = Cplans::getSubscriptionByID($subscription_id);							
						$model->status = 'payment failed';
					    $model->save();						
						$logs = "Paypal subscription payment failed $subscription_id";
						CommonUtility::pushJobs("SubscriptionsPaymentFailed",[
							'id'=>$model->id,								
							'language'=>Yii::app()->language
						]);								
						break;

					default:
					break;
			}			

			if(!empty($webhook_id)){
				$model_webhooks = new AR_plans_webhooks();
				$model_webhooks->id	 = $webhook_id;
				$model_webhooks->event_type	 = $event;			
				$model_webhooks->save();			
			}

		} catch (Exception $e) {
			$logs =  $e->getMessage();
		}			
		    		
		Yii::log( json_encode($logs) , CLogger::LEVEL_ERROR);
		http_response_code(200);
	}	

} 
// end class