<?php
require 'php-jwt/vendor/autoload.php';
require 'stripe2/vendor/autoload.php';
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Symfony\Component\Translation\Dumper\DumperInterface;

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
                    'StripeCreateCustomer','StripeSavePayment','StripePaymentIntent','StripeProcesspayment'
                 ), 
				 'expression' => array('AppIdentity','verifyCustomer')
			 ), 
		 );
	}

	public function actionStripeCreateCustomer()
	{
		try {
						
			$merchant_id = isset($this->data['merchant_id'])?$this->data['merchant_id']:0;		
			$payment_code = isset($this->data['payment_code'])?$this->data['payment_code']:'';		
			$merchant_type = isset($this->data['merchant_type'])?$this->data['merchant_type']:'';
			$reference = isset($this->data['reference'])?$this->data['reference']:'';
			$merchant_id = intval($merchant_id);	
			
			$credentials = CPayments::getPaymentCredentials($merchant_id,$payment_code,$merchant_type);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';
			$is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;		
			
			$full_name = Yii::app()->user->first_name." ".Yii::app()->user->last_name;			

			$model = AR_client_meta::model()->find('client_id=:client_id AND meta1=:meta1 AND meta2=:meta2 
			AND meta3=:meta3 ', 
		    array( 
		      ':client_id'=>intval(Yii::app()->user->id),
		      ':meta1'=>$payment_code,
		      ':meta2'=>$is_live,
		      ':meta3'=>isset($credentials['merchant_id'])?$credentials['merchant_id']:'',
		    )); 			    

			\Stripe\Stripe::setApiKey( isset($credentials['attr1'])?$credentials['attr1']:'' );

			$create = false; $customer_id='';
		    if($model){
		    	if(empty($model->meta4)){
		    		$create = true;
		    	} else $customer_id = $model->meta4;
		    } else $create = true;

			if($create){
		    	$customer = \Stripe\Customer::create([
				  'email'=>Yii::app()->user->email_address,
				  'name'=>$full_name
				]);						    
				$customer_id = $customer->id;
				$model = new AR_client_meta;
		    	$model->client_id = intval(Yii::app()->user->id);
		    	$model->meta1 = $payment_code;
		    	$model->meta2 = $is_live;
		    	$model->meta3 = $credentials['merchant_id'];
		    	$model->meta4 = $customer_id;
		    	$model->save();					
		    }

			$client_secret = '';
		    
		    $intent = \Stripe\SetupIntent::create([
			    'customer' => $customer_id
			]);
			
			$client_secret = $intent->client_secret;
			
		    $this->code = 1;
		    $this->msg = "OK";
		    $this->details = array(
		      'client_secret'=>$client_secret,
		      'customer_id'=>$customer_id,
		      'test_card'=>false
		    );
		    
		    if(DEMO_MODE){
				$this->details['test_card'] = array(
				  'card_number'=>'4242424242424242',
				  'expiry'=>'Future date',
				  'cvv'=>'123',
				  'zip'=>'12345',				  
				);
			}
		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actionStripeSavePayment()
	{
		try {
			
			$payment_method_id = isset($this->data['payment_method_id'])?$this->data['payment_method_id']:'';				
			$merchant_id = isset($this->data['merchant_id'])?$this->data['merchant_id']:0;
			$payment_code = isset($this->data['payment_code'])?$this->data['payment_code']:'';
			$merchant_type = isset($this->data['merchant_type'])?$this->data['merchant_type']:2;
            $merchant_id = intval($merchant_id);

			$credentials = CPayments::getPaymentCredentials($merchant_id,$payment_code,$merchant_type);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';
			$is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;

			$model = AR_client_meta::model()->find('client_id=:client_id AND meta1=:meta1 AND meta2=:meta2 
			AND meta3=:meta3 ', 
		    array( 
		      ':client_id'=>intval(Yii::app()->user->id),
		      ':meta1'=>$payment_code,
		      ':meta2'=>$is_live,
		      ':meta3'=>$credentials['merchant_id'],
		    )); 	

			if($model){
                \Stripe\Stripe::setApiKey($credentials['attr1']);
		    	$payment = \Stripe\PaymentMethod::retrieve($payment_method_id,[]);
                $mask_card = CommonUtility::mask("111111111111".$payment->card->last4);

                $gateway =  AR_payment_gateway::model()->find('payment_code=:payment_code', 
			    array(':payment_code'=>$payment_code)); 

                $model_method = new AR_client_payment_method;
			    $model_method->client_id = intval(Yii::app()->user->id);
			    $model_method->payment_code = $payment_code;
			    $model_method->as_default = 1;
			    $model_method->attr1 = $gateway?$gateway->payment_name:'';
			    $model_method->attr2 = $mask_card;			
			    $model_method->merchant_id = isset($credentials['merchant_id'])? intval($credentials['merchant_id']) :0;

                $model_method->method_meta = array(
                array(
                    'meta_name'=>'payment_customer_id',
                    'meta_value'=>$model->meta4,
                    'date_created'=>CommonUtility::dateNow(),
                ),
                array(
                    'meta_name'=>'payment_method_id',
                    'meta_value'=>$payment_method_id,
                    'date_created'=>CommonUtility::dateNow(),
                ),
                array(
                    'meta_name'=>'is_live',
                    'meta_value'=>$is_live,
                    'date_created'=>CommonUtility::dateNow(),
                ),
                );
                
                if($model_method->save()){
                    $this->code = 1; 
                    $this->msg = "OK";	
					$this->details = [
						'id'=>Yii::app()->user->id
					];
                } else $this->msg = CommonUtility::parseError( $model_method->getErrors());	

            } else $this->msg = t("Customer payment details not found");        

		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actionStripePaymentIntent()
	{
		try {
						
			$order_uuid = isset($this->data['order_uuid'])?$this->data['order_uuid']:'';
		    $cart_uuid = isset($this->data['cart_uuid'])?$this->data['cart_uuid']:'';
		    $payment_uuid = isset($this->data['payment_uuid'])?$this->data['payment_uuid']:'';
			$payment_code = isset($this->data['payment_code'])?$this->data['payment_code']:'';

			$data = AR_ordernew::model()->find('order_uuid=:order_uuid',array(':order_uuid'=>$order_uuid));
			if($data){
				$merchant = CMerchantListingV1::getMerchant($data->merchant_id);		    	
		        $credentials = CPayments::getPaymentCredentials($data->merchant_id,$data->payment_code,
		        $merchant->merchant_type);
			    $credentials = isset($credentials[$data->payment_code])?$credentials[$data->payment_code]:'';
			    $is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;   
				
				$payment_method = CPayments::getPaymentMethodMeta($payment_uuid, Yii::app()->user->id );

				$payment_description = t("Payment to merchant [merchant]. Order#[order_id]",
		        array('[merchant]'=>$merchant->restaurant_name,'[order_id]'=>$data->order_id ));	

				$exchange_rate = $data->exchange_rate>0?$data->exchange_rate:1;			  
				if($data->amount_due>0){
					$total = floatval(Price_Formatter::convertToRaw( ($data->amount_due*$exchange_rate) ));	
				} else $total = floatval(Price_Formatter::convertToRaw( ($data->total*$exchange_rate) ));						 
				
				$multicurrency_enabled = isset(Yii::app()->params['settings']['multicurrency_enabled'])?Yii::app()->params['settings']['multicurrency_enabled']:false;
				$multicurrency_enabled = $multicurrency_enabled==1?true:false;		   	
				$enabled_checkout_currency = isset(Yii::app()->params['settings']['multicurrency_enabled_checkout_currency'])?Yii::app()->params['settings']['multicurrency_enabled_checkout_currency']:false;
				$enabled_force = $multicurrency_enabled==true? ($enabled_checkout_currency==1?true:false) :false;

				$use_currency_code = $data->use_currency_code;					  
				if($enabled_force){
					if($force_result = CMulticurrency::getForceCheckoutCurrency($data->payment_code,$use_currency_code)){					 					 
						$use_currency_code = $force_result['to_currency'];
						$total = Price_Formatter::convertToRaw($total*$force_result['exchange_rate'],2);
					}
				}			  		

				\Stripe\Stripe::setApiKey($credentials['attr1']);					  

				$payment_intent = \Stripe\PaymentIntent::create([
					'amount' => ($total*100),
					'currency' => $use_currency_code,
					'customer' =>  isset($payment_method['payment_customer_id'])?$payment_method['payment_customer_id']:'' ,
					'payment_method' => isset($payment_method['payment_method_id'])?$payment_method['payment_method_id']:'' ,
					'off_session' => true,
					'confirm' => true,
					'description'=> $payment_description
				]);

				$transaction_id = $payment_intent->id;		      	  
		      
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
				$model->reason = '';
				$model->payment_uuid = $payment_uuid;
				$model->save();			  
				
				$this->code = 1;
				$this->msg = t("Payment successful. please wait while we redirect you.");

				$this->details = array(  					  
					'order_uuid'=>$data->order_uuid
				);
			} else $this->msg = t("Order id not found");

		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actionStripeProcesspayment()
	{
		try {

			$data = isset($this->data['data'])?$this->data['data']:'';
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
			$apikey = isset($credentials['attr1'])?$credentials['attr1']:'';

			\Stripe\Stripe::setApiKey($apikey);				      
			$payment_intent = \Stripe\PaymentIntent::create([
			 'amount' => ($amount*100),
			 'currency' => $currency_code,
			 'customer' =>  $payment_customer_id,
			 'payment_method' => $payment_method_id ,
			 'off_session' => true,
			 'confirm' => true,
			 'description'=> $payment_description,	
			 'metadata'=>[
				'payment_type'=>$payment_type,
				'reference_id'=>$reference_id,
			 ]
		   ]);      

		   $transaction_id = $payment_intent->id;

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

    public function actioncreateIntent()
    {
        try {
            
			$key = isset($this->data['key'])?trim($this->data['key']):'';
			$payment_code = isset($this->data['payment_code'])?trim($this->data['payment_code']):'';
            $total = isset($this->data['total'])?$this->data['total']:0;
			$amount = $total;
            $payment_description = isset($this->data['payment_description'])?$this->data['payment_description']:'';
            $currency_code = isset($this->data['currency_code'])?$this->data['currency_code']:'';
			$payment_reference = isset($this->data['payment_reference'])?$this->data['payment_reference']:'';						
			$payment_type = isset($this->data['payment_type'])?$this->data['payment_type']:'';						

			$options = OptionsTools::find([
				'multicurrency_enabled','multicurrency_enabled_checkout_currency'
			]);			
			$multicurrency_enabled = $options['multicurrency_enabled']?$options['multicurrency_enabled']:false;
			$multicurrency_enabled = $multicurrency_enabled==1?true:false;		   	
			$enabled_checkout_currency = $options['multicurrency_enabled_checkout_currency']?$options['multicurrency_enabled_checkout_currency']:false;
			$enabled_force = $multicurrency_enabled==true? ($enabled_checkout_currency==1?true:false) :false;
			
			if($enabled_force){
				if($force_result = CMulticurrency::getForceCheckoutCurrency($payment_code,$currency_code)){					 					 				   
				   $currency_code = $force_result['to_currency'];
				   $amount = Price_Formatter::convertToRaw($total*$force_result['exchange_rate'],2);
				}
		    } 

            $stripe = new \Stripe\StripeClient($key);
			$paymentIntent = $stripe->paymentIntents->create([
				'amount'=>($amount*100),
				'currency' => $currency_code,				
				'description'=>$payment_description,
				'automatic_payment_methods' => [
					'enabled' => true,
				],
				'metadata'=>[
					'payment_reference'=>$payment_reference,					
					'payment_type'=>$payment_type
				 ]
			]);
			$this->code = 1;
			$this->msg = "Ok";		
			$this->details =[
				'client_secret'=>$paymentIntent->client_secret
			];
        } catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
    }

	public function actioncreatesubscriptions()
	{
		try {
			
			$payment_code = StripeModule::paymentCode();			
			$payment_id = Yii::app()->input->post('payment_id');			
			$payment = Cplans::getPaymentCreated($payment_id);				
			$package_id = $payment->package_id;	
			$subscriber_id = $payment->subscriber_id;
			$subscriber_type = $payment->subscriber_type;			

			$customer = Cplans::getSubscriberInformation($subscriber_id,$subscriber_type);			

			$meta_name = "plan_price_$payment_code";						
			$price = Cplans::planPriceID($meta_name,$package_id);
			$price_id = $price->meta_value;	
			
			//$success_url = Yii::app()->createAbsoluteUrl($payment_code."/apiv2/subscription_callback?payment_id=".$payment_id);
			$success_url = $payment->success_url;
			$cancel_url = Yii::app()->createAbsoluteUrl("/paymentplan?payment_id=".$payment_id);
			
			$credentials = CPayments::getPaymentCredentials(0,$payment_code);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';									
			$secret = isset($credentials['attr1'])?$credentials['attr1']:'';
			$is_live = isset($credentials['is_live'])?$credentials['is_live']:0;

			$customer_id = null;			
			
			// CREATE CUSTOMER
			if($customer_data = Cplans::getCustomerID($payment_code,$subscriber_id,$subscriber_type,$is_live)){				
				$customer_id = $customer_data->customer_id;
			} else {				
				$stripe = new \Stripe\StripeClient($secret);							
				$resp_customer  = $stripe->customers->create([
					'name' => $customer['full_name'],
					'email' => $customer['contact_email'],
				]);						
				$customer_id = $resp_customer->id;
				$livemode = $resp_customer->livemode?1:0;
				$model_customer = new AR_plans_customer();
				$model_customer->payment_code = $payment_code;
				$model_customer->subscriber_id = $subscriber_id;
				$model_customer->subscriber_type = $subscriber_type;
				$model_customer->customer_id = $customer_id;
				$model_customer->livemode = $livemode;
				$model_customer->save();
			}			
						

			//https://stackoverflow.com/questions/64732447/trial-period-in-checkout-session-in-stripe

			$plans = Cplans::get($package_id);
			$trial_period = $plans->trial_period;

			$params = [
				'success_url' => $success_url,
				'cancel_url' => $cancel_url,
				'customer'=>$customer_id,
				'mode' => 'subscription',
				'metadata'=>[
					'payment_id'=>$payment_id
				],
				'line_items' => [[
				  'price' => $price_id,				  
				  'quantity' => 1,
				]],				
			];			
			if($trial_period>0){
				$params['subscription_data'] = [
					'trial_period_days'=>$trial_period
				];
			}

			\Stripe\Stripe::setApiKey($secret);
			$session = \Stripe\Checkout\Session::create($params);


			try {
				$subscriber_model =  Cplans::getSubscriberRecords($subscriber_id,$subscriber_type,'model');
				$subscriber_model->package_id = $package_id;
				$subscriber_model->package_payment_code = $payment_code;
				$subscriber_model->save();
			} catch (Exception $e) {}	

			$this->code = 1;
			$this->msg = "Ok";			
			$this->details = [
				'checkout_url'=>$session->url
			];

		} catch (Exception $e) {
			$this->msg = t($e->getMessage());					
		}		
		$this->responseJson();
	}

	public function actioncancelsubscriptions()
	{
		try {

			$subscription_id = Yii::app()->input->get('subscription_id');

			$payment_code = StripeModule::paymentCode();
		    $credentials = CPayments::getPaymentCredentials(0,$payment_code);
		    $credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';											   
		    $secret = isset($credentials['attr1'])?$credentials['attr1']:'';
		    $is_live = isset($credentials['is_live'])?$credentials['is_live']:0;		    
			
			$stripe = new \Stripe\StripeClient($secret);
			$resp = $stripe->subscriptions->cancel($subscription_id, []);			

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

			//https://docs.stripe.com/billing/subscriptions/upgrade-downgrade?lang=php#see-also

			$payment_id = Yii::app()->input->post('payment_id');
			$payment_code = StripeModule::paymentCode();

			$payment = Cplans::getPaymentCreated($payment_id);				
			$package_id = $payment->package_id;		
			$subscriber_id = $payment->subscriber_id;
			$subscriber_type = $payment->subscriber_type;
			$sucess_url = $payment->success_url;
			$failed_url = $payment->failed_url;	

			$meta_name = "plan_price_$payment_code";						
			$price = Cplans::planPriceID($meta_name,$package_id);
			$price_id = $price->meta_value;						
			
			$credentials = CPayments::getPaymentCredentials(0,$payment_code);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';			
			$secret = isset($credentials['attr1'])?$credentials['attr1']:'';			
			$is_live = isset($credentials['is_live'])?$credentials['is_live']:0;

			$next_actions = '';
			$subscription_id = '';
			$active_plan = null;

			try {
				$active_plan =  Cplans::getActiveSubscriptions2($subscriber_id,$subscriber_type,$payment_code);				
				$subscription_id = $active_plan->subscription_id;						    
			} catch (Exception $e) {	
				$next_actions = 'subscribe';
			}				
			
			$stripe = new \Stripe\StripeClient($secret);		

			$subscription_item_id = null;

			if($active_plan){	
				$customer = Cplans::getCustomerID($payment_code,$subscriber_id,$subscriber_type,$is_live);
				if($customer){
					$customer_id = $customer->customer_id;				
					$resp_customer = $stripe->subscriptions->all(['customer' => $customer_id]);				
					$data = isset($resp_customer['data']) ? $resp_customer['data'] : null;
					if(is_array($data) && count($data)>=1){
						$data = isset($data[0]) ? $data[0] : null;
						$items = isset($data['items']) ? $data['items']['data'][0] : null;
						$subscription_item_id = $items['id'];
					} else {					
						$items = isset($data['items'])?$data['items']:null;
						$subscription_item_id = isset($items['data'])? (isset($items['data']['id'])?$items['data']['id']:null) :null;
					}			
				} else {
					$this->msg = t("Invalid Customer Id");
					$this->responseJson();
				}				
		    }			

			if($active_plan){				
				$resp = $stripe->subscriptions->update(
					$subscription_id,
					[
					  'items' => [
						[
						  //'id' => 'si_QTbhHMD8WNwbvN',
						  'id'=>$subscription_item_id,
						  'price' => $price_id,
						],
					  ],
					  'metadata'=>[
						'payment_id'=>$payment_id
					  ]
					],					
				);			
				$active_plan->status = "active";
				$active_plan->package_id = $package_id;
				$active_plan->save();				
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
			
		   $logs = [];
		   $payment_code = StripeModule::paymentCode();
		   $credentials = CPayments::getPaymentCredentials(0,$payment_code);
		   $credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';											   
		   $secret = isset($credentials['attr1'])?$credentials['attr1']:'';
		   $is_live = isset($credentials['is_live'])?$credentials['is_live']:0;
		   $webhook_secret = isset($credentials['attr3'])?$credentials['attr3']:'';

		   $sig_header = isset($_SERVER['HTTP_STRIPE_SIGNATURE'])?$_SERVER['HTTP_STRIPE_SIGNATURE']:null;
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
		
		   		   
		   $event = isset($payload['type'])?$payload['type']:null;
		   $webhook_id = isset($payload['id'])?$payload['id']:null;		   		   
		   		
		   if(Cplans::isWebhookFound($webhook_id)){
			    Yii::log( "Webook even already exist $webhook_id" , CLogger::LEVEL_INFO);
				http_response_code(200);
				Yii::app()->end();
		   }
		   
		   switch ($event) {
			 case "checkout.session.completed":

					$data = isset($payload['data'])?  (isset($payload['data']['object']) ?$payload['data']['object'] :null )  :null;		   		   
					$payment_id = isset($data['metadata'])? (isset($data['metadata'])?$data['metadata']['payment_id']:'') : null;
					$subscription_id = isset($data['subscription'])?$data['subscription']:'';
					$currency_code = isset($data['currency'])?$data['currency']:'';
					$amount = isset($data['amount_total'])?$data['amount_total']:'';
					$amount = $amount>0? ($amount/100) : 0;
					
					$payment = Cplans::getPaymentCreated($payment_id);	
					$package_id = $payment->package_id;		
					$subscriber_id = $payment->subscriber_id;
					$subscriber_type = $payment->subscriber_type;	
					$jobs =	$payment->jobs;

					$stripe = new \Stripe\StripeClient($secret);
					$resp = $stripe->subscriptions->retrieve($subscription_id, []);				
					$created_at = date("Y-m-d",$resp->created);
					$current_start = date("Y-m-d",$resp->current_period_start);
					$current_end = date("Y-m-d",$resp->current_period_end);
					$next_due = date("Y-m-d",$resp->current_period_end);							

					$new_item_limit  = 0; $new_order_limit =0;
					$remaining_items = 0; $remaining_orders =0;
					
					$plans = Cplans::get($package_id);				
					$new_item_limit = $plans->item_limit;
					$new_order_limit = $plans->order_limit;
									
					$model = new AR_plan_subscriptions();
					$model->payment_id = $payment_id;
					$model->payment_code = $payment_code;
					$model->subscriber_id = $subscriber_id;
					$model->package_id = $package_id;
					$model->plan_name = $plans->title;
					$model->billing_cycle = $plans->package_period;
					$model->amount = floatval($amount);
					$model->currency_code = strtoupper($currency_code);
					$model->subscriber_type = $subscriber_type;
					$model->subscription_id = $subscription_id;		
					$model->status = 'active';				
					$model->created_at = $created_at;				
					$model->next_due = $next_due;			
					$model->expiration = $next_due;
					$model->current_start = $current_start;
					$model->current_end = $current_end;	
					$model->jobs = $jobs;
					$model->save();						
					
					$jobs = $model->jobs;
					$jobs_data = [
						'subscription_id'=>$subscription_id,
						'package_id'=>$model->package_id,
						'subscriber_type'=>$model->subscriber_type,
						'subscriber_id'=>$model->subscriber_id,		
						'is_new'=>1
					];					
					if (!class_exists($jobs)) {				
						Yii::log( "Job class $jobs does not exist." , CLogger::LEVEL_INFO);
						http_response_code(200);
						Yii::app()->end();										
					}
					$jobInstance = new $jobs($jobs_data);
					$jobInstance->execute();	

					// CANCEL OLD SUBSCRIPTIONS
					Cplans::cancelPaymentSubscriptions($subscriber_type,$subscriber_id,$payment_code);

					$logs[] = "STRIPE SUCCESS SESSION COMPLETED";
				break;
				
				case "invoice.paid":					
					$data = isset($payload['data'])?  (isset($payload['data']['object']) ?$payload['data']['object'] :null )  :null;		   		   					
					$amount = isset($data['amount_paid']) ? $data['amount_paid'] : 0;
					$amount = $amount>0? ($amount/100) : 0;			
					$currency_code = isset($data['currency'])?$data['currency']:'';
					
					$subscription_details = isset($data['subscription_details'])?$data['subscription_details']:null;
					$metadata = isset($subscription_details['metadata'])?$subscription_details['metadata']:null;
					$payment_id = isset($metadata['payment_id'])?$metadata['payment_id']:null;
					$subscription_id = isset($data['subscription'])?$data['subscription']:null;
															
					$payment = Cplans::getSubscriptionByID($subscription_id);
					$package_id = $payment->package_id;		
					$subscriber_id = $payment->subscriber_id;
					$subscriber_type = $payment->subscriber_type;			
					$jobs = $payment->jobs;
					
					$subscriber_model =  Cplans::getSubscriberRecords($subscriber_id,$subscriber_type,'model');
					if($subscriber_model){
												
						$title = ''; $billing_cycle='';
						try {
							$plan_model = Cplans::get($package_id);		
							$title = $plan_model->title;
							$billing_cycle = $plan_model->package_period;																										
						} catch (Exception $e) {}
						
						try {
							$model = Cplans::getSubscriptionByID($subscription_id);
						} catch (Exception $e) {
							$model = new AR_plan_subscriptions();
						}												
						
						$stripe = new \Stripe\StripeClient($secret);
						$resp = $stripe->subscriptions->retrieve($subscription_id, []);										
						$created_at = date("Y-m-d",$resp->created);
						$current_start = date("Y-m-d",$resp->current_period_start);
						$current_end = date("Y-m-d",$resp->current_period_end);
						$next_due = date("Y-m-d",$resp->current_period_end);	
												
						$model->package_id = $package_id;
						$model->plan_name = $title;
						$model->billing_cycle = $billing_cycle;
						$model->amount = floatval($amount);
						$model->currency_code = strtoupper($currency_code);
						$model->status = 'active';				
						$model->created_at = $created_at;				
						$model->next_due = $next_due;			
						$model->expiration = $next_due;
						$model->current_start = $current_start;
						$model->current_end = $current_end;	
						$model->save();			
												
						$jobs_data = [
							'subscription_id'=>$subscription_id,
							'package_id'=>$package_id,
							'subscriber_type'=>$subscriber_type,
							'subscriber_id'=>$subscriber_id,
							'is_new'=>false
						];
						if (!class_exists($jobs)) {				
							Yii::log( "Job class $jobs does not exist." , CLogger::LEVEL_INFO);
							http_response_code(200);
							Yii::app()->end();										
						}
						$jobInstance = new $jobs($jobs_data);
                        $jobInstance->execute();	
						
						$logs[] = "STRIPE SUCCESS INVOICE PAID";

					} else $logs[] = "Susbcriptions id not found";									
					break;

				 case "invoice.payment_failed":
					$data = isset($payload['data'])?  (isset($payload['data']['object']) ?$payload['data']['object'] :null )  :null;					
					$subscription_details = isset($data['subscription_details'])?$data['subscription_details']:null;
					$subscription_id = isset($data['subscription'])?$data['subscription']:null;					
					$model = Cplans::getSubscriptionByID($subscription_id);
					$model->status = 'payment failed';
					$model->save();
					$logs[] = "STRIPE PAYMENT FAILED";	
					CommonUtility::pushJobs("SubscriptionsPaymentFailed",[
						'id'=>$model->id,
						'language'=>Yii::app()->language
					]);	
					break;

				case "customer.subscription.deleted":
				case "subscription_schedule.canceled":
					$data = isset($payload['data'])?  (isset($payload['data']['object']) ?$payload['data']['object'] :null )  :null;					
					$subscription_id = isset($data['id'])?$data['id']:null;					
					$model = Cplans::getSubscriptionByID($subscription_id);
					$model->status = 'cancelled';
					$model->save();

					CommonUtility::pushJobs("SubscriptionsCancelled",[
						'id'=>$model->id,								
						'language'=>Yii::app()->language
					]);

					$logs[] = "STRIPE SUBSCRIPTIONS DELETED";					
					break;					
		   }

		   if(!empty($webhook_id)){
				$model_webhooks = new AR_plans_webhooks();
				$model_webhooks->id	 = $webhook_id;
				$model_webhooks->event_type	 = $event;			
				$model_webhooks->save();			
		   }

		} catch (Exception $e) {
			$logs[] = $e->getMessage();
		}
		
		Yii::log( json_encode($logs) , CLogger::LEVEL_INFO);
		http_response_code(200);
	}
	

} 
// end class