<?php
spl_autoload_unregister(array('YiiBase','autoload'));
require 'razorpay/vendor/autoload.php';
require 'php-jwt/vendor/autoload.php';
use Razorpay\Api\Api;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
spl_autoload_register(array('YiiBase','autoload'));

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
                    'RazorpayCreateCustomer','RazorpayCreateOrder','RazorpayVerifyPayment','Razorpaycreateneworder','Razorpayprocesspayment'
                 ), 
				 'expression' => array('AppIdentity','verifyCustomer')
			 ), 
		 );
	}

	public function actionRazorpayCreateCustomer()
	{
		try {

			$merchant_id = isset($this->data['merchant_id'])?$this->data['merchant_id']:0;		
			$payment_code = isset($this->data['payment_code'])?$this->data['payment_code']:'';		
			$merchant_type = isset($this->data['merchant_type'])?$this->data['merchant_type']:'';

			$credentials = CPayments::getPaymentCredentials($merchant_id,$payment_code,$merchant_type);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';
			$is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;		

			$full_name = Yii::app()->user->first_name." ".Yii::app()->user->last_name;            			
			$api = new Api($credentials['attr1'], $credentials['attr2']);           

			$model = AR_client_meta::model()->find('client_id=:client_id AND meta1=:meta1 AND meta2=:meta2 
			AND meta3=:meta3 ', 
		    array( 
		      ':client_id'=>intval(Yii::app()->user->id),
		      ':meta1'=>$payment_code,
		      ':meta2'=>$is_live,
		      ':meta3'=>isset($credentials['merchant_id'])?$credentials['merchant_id']:'',
		    )); 

			$create = false; $customer_id='';
		    if($model){
		    	if(empty($model->meta4)){
		    		$create = true;
		    	} else $customer_id = $model->meta4;
		    } else $create = true;

			if($create){
				try {
					
					$client = AR_client::model()->findbyPk(intval(Yii::app()->user->id));
					
					$customer = $api->customer->create(array(
					   'name' => $full_name,
					   'email' => $client? $client->email_address : Yii::app()->user->email_address,
					   'contact'=>$client? $client->contact_phone : Yii::app()->user->contact_number,
					   'fail_existing'=>0,
					   'notes'=> array(
					          'client_id'=> Yii::app()->user->id
					       )
					));					
					$customer_id = $customer->id;
				} catch (Exception $e) {
					$this->msg = $e->getMessage();
					$this->responseJson();						
				}
								
				if(!empty($customer_id)){			    
					$model = new AR_client_meta;
			    	$model->client_id = intval(Yii::app()->user->id);
			    	$model->meta1 = $payment_code;
			    	$model->meta2 = $is_live;
			    	$model->meta3 = $credentials['merchant_id'];
			    	$model->meta4 = $customer_id;
			    	$model->save();			
				} 							
			}			

			$payment = AR_payment_gateway::model()->find('payment_code=:payment_code', 
		    array(':payment_code'=>$payment_code)); 		

			if($payment){
                $model = new AR_client_payment_method;
				$model->scenario = "insert";
				$model->client_id = Yii::app()->user->id;
				$model->payment_code = $payment_code;
				$model->as_default = intval(1);
				$model->attr1 = $payment?$payment->payment_name:'unknown';	
				$model->merchant_id = intval($merchant_id);
				if($model->save()){
					$this->code = 1;
		    		$this->msg = t("Succesful");
				} else $this->msg = CommonUtility::parseError($model->getErrors());
            } else $this->msg = t("Payment provider not found");

		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actionRazorpayCreateOrder()
	{
		try {
			
			$merchant_id = isset($this->data['merchant_id'])?$this->data['merchant_id']:0;		
			$payment_code = isset($this->data['payment_code'])?$this->data['payment_code']:'';		
			$merchant_type = isset($this->data['merchant_type'])?$this->data['merchant_type']:'';
			$cart_uuid = isset($this->data['cart_uuid'])?$this->data['cart_uuid']:'';
			$order_uuid = isset($this->data['order_uuid'])?$this->data['order_uuid']:'';

			$merchant_id = CCart::getMerchantId($cart_uuid);	
			$merchant = CMerchants::get($merchant_id);
			$merchant_type = $merchant->merchant_type;

			$credentials = CPayments::getPaymentCredentials($merchant_id,$payment_code,$merchant_type);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';
			$is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;	

			$data = AR_ordernew::model()->find('order_uuid=:order_uuid',array(':order_uuid'=>$order_uuid));
			if($data){
				$exchange_rate = $data->exchange_rate>0?$data->exchange_rate:1;			  		        
				if($data->amount_due>0){
					$total = floatval(Price_Formatter::convertToRaw( ($data->amount_due*$exchange_rate) ));	
				 } else $total = floatval(Price_Formatter::convertToRaw( ($data->total*$exchange_rate) ));			  

				$merchant = CMerchantListingV1::getMerchant($data->merchant_id);
				
				$payment_description = t("Payment to merchant [merchant]. Order#[order_id]",
		         array('[merchant]'=>$merchant->restaurant_name,'[order_id]'=>$data->order_id ));	

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
				
				 		        
		        $api = new Api($credentials['attr1'], $credentials['attr2']);		        
				$amount_in_paise = intval(round($total * 100));
		        
		        $order  = $api->order->create([
		          'receipt'=>$order_uuid,
		          'amount'=>$amount_in_paise,
		          'currency'=>$use_currency_code,
		          'notes'=>array(
		            'order_uuid'=>$order_uuid,	            
		          )
				]);
				
				$model = AR_client_meta::model()->find('client_id=:client_id AND meta1=:meta1 AND meta2=:meta2 
				AND meta3=:meta3 ', 
			    array( 
			      ':client_id'=>intval(Yii::app()->user->id),
			      ':meta1'=>$payment_code,
			      ':meta2'=>$is_live,
			      ':meta3'=>isset($credentials['merchant_id'])?$credentials['merchant_id']:'',
			    )); 				    
				
				$options = array(				  
				   'amount'=>($total*100),
				  'currency'=>$data->use_currency_code,
				  'name'=>$merchant->restaurant_name,
				  'description'=>$payment_description,
				  'order_id'=>$order->id,				  
				  'customer_id'=>$model?$model->meta4:''
				);
				
				$this->code = 1;
				$this->msg = "ok";
				$this->details = $options;				
			} else $this->msg = t("Order id not found");
		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actionRazorpayVerifyPayment()
	{
		try {

			$merchant_id = isset($this->data['merchant_id'])?$this->data['merchant_id']:0;		
            $payment_code = isset($this->data['payment_code'])?$this->data['payment_code']:'';		
            $merchant_type = isset($this->data['merchant_type'])?$this->data['merchant_type']:'';
            $cart_uuid = isset($this->data['cart_uuid'])?$this->data['cart_uuid']:'';
            $order_uuid = isset($this->data['order_uuid'])?$this->data['order_uuid']:'';
            $razorpay_payment_id = isset($this->data['razorpay_payment_id'])?$this->data['razorpay_payment_id']:'';
            $razorpay_order_id = isset($this->data['razorpay_order_id'])?$this->data['razorpay_order_id']:'';
            $razorpay_signature = isset($this->data['razorpay_signature'])?$this->data['razorpay_signature']:'';

			if($data = AR_ordernew::model()->find('order_uuid=:order_uuid',array(':order_uuid'=>$order_uuid))){
				$credentials = CPayments::getPaymentCredentials($merchant_id,$payment_code,$merchant_type);
                $credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';
                $is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;

				$api = new Api($credentials['attr1'], $credentials['attr2']);			   			   			 
                $attributes  = array(
                    'razorpay_signature'  => $razorpay_signature,
                    'razorpay_payment_id'  => $razorpay_payment_id,
                    'razorpay_order_id' => $razorpay_order_id
                );			   
                $api->utility->verifyPaymentSignature($attributes);

				$exchange_rate = $data->exchange_rate>0?$data->exchange_rate:1;			  
		        $total = Price_Formatter::convertToRaw( ($data->total*$exchange_rate) );

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

				/*CAPTURE PAYMENT*/
                $capture = $api->payment->fetch($razorpay_payment_id)->capture(array(
                    'amount'=>($total*100),
                    'currency' => $use_currency_code
                ));
				
				$transaction_id = $razorpay_payment_id;
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
				if($model->save()){
					$params = array(  
                        array('transaction_id'=>$model->transaction_id,'order_id'=>$data->order_id, 
                        'meta_name'=>'razorpay_payment_id', 'meta_value'=>$razorpay_payment_id ),
                                               
                        array('transaction_id'=>$model->transaction_id,'order_id'=>$data->order_id, 
                        'meta_name'=>'razorpay_order_id', 'meta_value'=>$razorpay_order_id ),
                        
                        array('transaction_id'=>$model->transaction_id,'order_id'=>$data->order_id, 
                        'meta_name'=>'razorpay_signature', 'meta_value'=>$razorpay_signature ),
                         
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

	public function actionRazorpaycreateneworder()
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
			$amount = isset($decoded['amount'])?$decoded['amount']:'';			
			$currency_code = isset($decoded['currency_code'])?$decoded['currency_code']:'';
			$payment_type = isset($decoded['payment_type'])?$decoded['payment_type']:'';		
			$reference_id = isset($decoded['reference_id'])?$decoded['reference_id']:'';		

			$payment_details = isset($decoded['payment_details'])?(array)$decoded['payment_details']:'';
			$payment_customer_id = isset($payment_details['payment_customer_id'])?$payment_details['payment_customer_id']:'';
			$payment_method_id = isset($payment_details['payment_method_id'])?$payment_details['payment_method_id']:'';					
			
			$credentials = CPayments::getPaymentCredentials($merchant_id,$payment_code,$merchant_type);
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';
			$is_live = isset($credentials['is_live'])?intval($credentials['is_live']):0;
			
			$api = new Api($credentials['attr1'], $credentials['attr2']);

			$order = $api->order->create([
				'receipt'=>$reference_id,
				'amount'=>($amount*100),
				'currency'=>$currency_code,
				'notes'=>array(
				  'order_uuid'=>$reference_id,	            
				)
			]);

			$model = AR_client_meta::model()->find('client_id=:client_id AND meta1=:meta1 AND meta2=:meta2 
				AND meta3=:meta3 ', 
			    array( 
			      ':client_id'=>intval(Yii::app()->user->id),
			      ':meta1'=>$payment_code,
			      ':meta2'=>$is_live,
			      ':meta3'=>isset($credentials['merchant_id'])?$credentials['merchant_id']:'',
			)); 	

			$options = array(				  
				'amount'=>($amount*100),
				'currency'=>$currency_code,
				'name'=>t("Digital wallet"),
				'description'=>$payment_description,
				'order_id'=>$order->id,				  
				'customer_id'=>$model?$model->meta4:''
			);
					
			$this->code = 1;
			$this->msg = "ok";
			$this->details = $options;

		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actionRazorpayprocesspayment()
	{
		try {

			$data = isset($this->data['data'])?$this->data['data']:'';      
            $razorpay_payment_id = isset($this->data['razorpay_payment_id'])?$this->data['razorpay_payment_id']:'';
		    $razorpay_order_id = isset($this->data['razorpay_order_id'])?$this->data['razorpay_order_id']:'';
		    $razorpay_signature = isset($this->data['razorpay_signature'])?$this->data['razorpay_signature']:'';

			$jwt_key = new Key(CRON_KEY, 'HS256');
			$decoded = (array) JWT::decode($data, $jwt_key);  

			$payment_code = isset($decoded['payment_code'])?$decoded['payment_code']:'';
			$payment_name = isset($decoded['payment_name'])?$decoded['payment_name']:'';
			$merchant_id = isset($decoded['merchant_id'])?$decoded['merchant_id']:'';
			$merchant_type = isset($decoded['merchant_type'])?$decoded['merchant_type']:'';
			$payment_description = isset($decoded['payment_description'])?$decoded['payment_description']:'';
			$payment_description_raw = isset($decoded['payment_description_raw'])?$decoded['payment_description_raw']:'';
			$transaction_description_parameters = isset($decoded['transaction_description_parameters'])?$decoded['transaction_description_parameters']:'';
			$amount = isset($decoded['amount'])?$decoded['amount']:0;						
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

			$api = new Api($credentials['attr1'], $credentials['attr2']);			   			   			 
			   $attributes  = array(
			       'razorpay_signature'  => $razorpay_signature,
			       'razorpay_payment_id'  => $razorpay_payment_id,
			       'razorpay_order_id' => $razorpay_order_id
			);			   
			$api->utility->verifyPaymentSignature($attributes);

			$capture = $api->payment->fetch($razorpay_payment_id)->capture(array(
				'amount'=>($amount*100),
				'currency' => $currency_code
			));

			$transaction_id = $razorpay_payment_id;

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

    public function actioncreateorder()
    {
        try {
            			
			$key = isset($this->data['key'])?trim($this->data['key']):'';
			$secret = isset($this->data['secret'])?trim($this->data['secret']):'';
			$payment_code = isset($this->data['payment_code'])?trim($this->data['payment_code']):'';

            $total = isset($this->data['total'])?floatval($this->data['total']):0;
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
            						
			$api = new Api($key, $secret);             
			$order = $api->order->create([
				'receipt'=>$payment_reference,
				'amount'=>($amount*100),
				'currency'=>$currency_code,
				'notes'=>array(
					'order_uuid'=>$payment_reference,
					'payment_type'=>$payment_type
				)
			]);
			$this->code = 1;
			$this->msg = "Ok";			
			$this->details = [
				'order_id'=>$order->id,
				'amount'=>($amount*100),
				'currency_code'=>$currency_code,				
			];
        } catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
    }

	public function actioncreatesubscriptions($cancel_subscription_id='')
	{
		try {
						
			$payment_id = Yii::app()->input->post('payment_id');			
			$payment_code = RazorpayModule::paymentCode();			

			$credentials = CPayments::getPaymentCredentials(0,$payment_code);			
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';	
			
			$api = new Api($credentials['attr1'], $credentials['attr2']);
			
			$payment = Cplans::getPaymentCreated($payment_id);	
			$package_id = $payment->package_id;		
			$subscriber_id = $payment->subscriber_id;
			$subscriber_type = $payment->subscriber_type;
			$sucess_url = $payment->success_url;
			$failed_url = $payment->failed_url;			
			$jobs = $payment->jobs;		
			
			$rz_customer_id = '';

			try {
				$customer = Cplans::getSubscriberInformation($subscriber_id,$subscriber_type);				
				$customer_resp = $api->customer->create([
					'name'=>$customer['full_name'],
					'email'=>$customer['contact_email'],
					'contact'=>$customer['contact_number'],
					'fail_existing'=>0
				]);				
				$rz_customer_id = $customer_resp->id;			
			} catch (Exception $e) {}						


			$plans = Cplans::get($package_id);						
			$meta_name = "plan_price_$payment_code";						
			$price = Cplans::planPriceID($meta_name,$plans->package_id);
			$price_id = $price->meta_value;			
			
			$plan_description = $plans->title;
			$options = OptionsTools::find(['website_title','website_logo']);			
			$website_title = isset($options['website_title'])?$options['website_title']:'';
			$website_logo = isset($options['website_logo'])?  CMedia::getImage($options['website_logo'],"/upload/all"):'';
			
			try {		

				$subscriptions = Cplans::getSubscriptionPlans($subscriber_id,$plans->package_id);
				$subscriptions->sucess_url = $sucess_url;
				$subscriptions->failed_url = $failed_url;
				$subscriptions->save();

				$callback_url = Yii::app()->createAbsoluteUrl($payment_code."/apiv2/subscription_callback",[
					'id'=>$subscriptions->id
				]);	
				$this->code = 1;
				$this->details = [
					'subscription_id'=>$subscriptions->subscription_id,
					'name'=>$website_title,
					'description'=>$plan_description,
					'image'=>$website_logo,
					'callback_url'=>$callback_url
				];
				$this->responseJson();
			} catch (Exception $e) {}						
			
			$package_period = $plans->package_period;
			$trial_period = $plans->trial_period;			
				
			$total_count = 12;
			if($package_period=="anually"){
				$total_count = 1;
			} else if ( $package_period=="monthly" ){
				$total_count = 12;
			} else if ( $package_period=="weekly" ){
				$total_count = 52;
			} else if ( $package_period=="daily" ){
				$total_count = 30;
			}

			$start_at = date("Y-m-d G:i:s");			
			$add_days = $trial_period>0 ? $trial_period : 0;
			$start_at = date('Y-m-d G:i:s', strtotime($start_at . " + $add_days day"));			
						
			$params = [
				'plan_id'=>$price_id,
				'total_count' => $total_count, 				
				'customer_notify'=>1,
				'quantity'=>1,				
			];	
			if(!empty($rz_customer_id)){
				$params['customer_id'] = $rz_customer_id;
			}
			if($trial_period>0){
				$params['start_at'] = strtotime($start_at);
			}

			$resp = $api->subscription->create($params);			
						
			$model = new AR_plan_subscriptions();
			$model->payment_id = $payment_id;
			$model->payment_code = $payment_code;
			$model->subscriber_id = $subscriber_id;
			$model->package_id = $plans->package_id;
			$model->plan_name = $plans->title;
			$model->billing_cycle = $plans->package_period;
			$model->amount = $plans->promo_price>0?$plans->promo_price:$plans->price;
			$model->subscriber_type = $subscriber_type;
			$model->subscription_id = $resp->id;						
			$model->status = $resp->status;
			$model->jobs= $jobs;
			$model->sucess_url = $sucess_url;
			$model->failed_url = $failed_url;						
			$model->save();

			$callback_url = Yii::app()->createAbsoluteUrl($payment_code."/apiv2/subscription_callback",[
				'id'=>$model->id
			]);	

			try {
				$subscriber_model =  Cplans::getSubscriberRecords($subscriber_id,$subscriber_type,'model');
				$subscriber_model->package_id = $package_id;
				$subscriber_model->package_payment_code = $payment_code;
				$subscriber_model->save();
			} catch (Exception $e) {}	
			
			$this->code = 1;
			$this->msg = "Ok";
			$this->details = [
				'subscription_id'=>$resp->id,
				'name'=>$website_title,
				'description'=>$plan_description,
				'image'=>$website_logo,
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
						
			$razorpay_payment_id = Yii::app()->input->post('razorpay_payment_id');
			$razorpay_subscription_id = Yii::app()->input->post('razorpay_subscription_id');
			$razorpay_signature = Yii::app()->input->post('razorpay_signature');
			$id = Yii::app()->input->get('id');			
						
			$payment_code = 'razorpay';
			$model = Cplans::getSubscriptionID($id);			
			$subscription_id = $model->subscription_id;
			$subscriber_type = $model->subscriber_type;	
			$subscriber_id = $model->subscriber_id;		
			$package_id = $model->package_id;		
			$sucess_url = $model->sucess_url;
			$failed_url = $model->failed_url;

			$credentials = CPayments::getPaymentCredentials(0,$payment_code);			
			$credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';			
			$secret = isset($credentials['attr2'])?$credentials['attr2']:'';
			$data = $razorpay_payment_id . "|" . $subscription_id;

			$generated_signature = hash_hmac('sha256', $data, $secret);			
			if (hash_equals($generated_signature, $razorpay_signature)) {														
				$model->status = 'active';
				$model->save();
				$this->redirect($sucess_url);
			} else {				
				$this->redirect($failed_url);
			}			
		} catch (Exception $e) {
			echo t($e->getMessage());
		}		
	}

	public function actionupdatesubscriptions()
	{		
		try {
			
			$payment_id = Yii::app()->input->post('payment_id');
			$payment_code = RazorpayModule::paymentCode();			

			$next_actions = '';

			$payment = Cplans::getPaymentCreated($payment_id);	
			$package_id = $payment->package_id;		
			$subscriber_id = $payment->subscriber_id;
			$subscriber_type = $payment->subscriber_type;
			$sucess_url = $payment->success_url;
			$failed_url = $payment->failed_url;	
			$jobs = $payment->jobs;	

			$plans = Cplans::get($package_id);					
			$package_period = $plans->package_period;
			$meta_name = "plan_price_$payment_code";						
			$price = Cplans::planPriceID($meta_name,$plans->package_id);
			$price_id = $price->meta_value;			

			try {

				$active_plan =  Cplans::getActiveSubscriptions2($subscriber_id,$subscriber_type,$payment_code);				
				$subscription_id = $active_plan->subscription_id;
				
				$credentials = CPayments::getPaymentCredentials(0,$payment_code);			
			    $credentials = isset($credentials[$payment_code])?$credentials[$payment_code]:'';

				$remaining_count = 12;
				if($package_period=="anually"){
					$remaining_count = 1;
				} else if ( $package_period=="monthly" ){
					$remaining_count = 12;
				} else if ( $package_period=="weekly" ){
					$remaining_count = 52;
				} else if ( $package_period=="daily" ){
					$remaining_count = 30;
				}

				$params = [
					'plan_id'=>$price_id,
					'schedule_change_at'=>'now',
					'remaining_count'=>$remaining_count
				];				
				
				$api = new Api($credentials['attr1'], $credentials['attr2']);
			    $resp = $api->subscription->fetch($subscription_id)->update($params);		
				
				$current_start = $resp->current_start;			
				$current_end = $resp->current_end;			
				$current_start = date("Y-m-d",$current_start);
				$current_end = date("Y-m-d",$current_end);

				$start_at = $resp->start_at;		
				$start_at = date("Y-m-d",$start_at);	
				$end_at = $resp->end_at;		
				$end_at = date("Y-m-d",$end_at);	

				$charge_at = $resp->charge_at;		
				$charge_at = date("Y-m-d",$charge_at);	

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

			} catch (Exception $e) {	
				$next_actions = 'subscribe';
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
	
	public function actioncancelsubscriptions()
	{
		try {
						
			$payment_code = RazorpayModule::paymentCode();
			$subscription_id = Yii::app()->input->get('subscription_id');

			$model = CPayments::getPaymentByCode($payment_code);
			$key_id = $model->attr1;
			$secret = $model->attr2;	
			$api = new Api($key_id, $secret);		
			$resp = $api->subscription->fetch($subscription_id)->cancel(array('cancel_at_cycle_end' => 0));

			$model = Cplans::getSubscriptionByID($subscription_id);				
			$model->status = 'cancelled';
			$model->save();

			$this->code = 1;
			$this->msg = t("Subscription cancelled");			

		} catch (Exception $e) {
			$this->msg = t($e->getMessage());		
		}		
		$this->responseJson();
	}

	public function actionrewewsubscriptions()
	{
		try {

			$payment_id = Yii::app()->input->get('payment_id');
			$payment_code = RazorpayModule::paymentCode();			
			
			$payment = Cplans::getPaymentCreated($payment_id);				
			$package_id = $payment->package_id;		
			$subscriber_id = $payment->subscriber_id;
			$subscriber_type = $payment->subscriber_type;
			$sucess_url = $payment->success_url;
			$failed_url = $payment->failed_url;		

			$plans = Cplans::get($package_id);						
			$meta_name = "plan_price_$payment_code";		
			$plan_description = $plans->title;

			$options = OptionsTools::find(['website_title','website_logo']);			
			$website_title = isset($options['website_title'])?$options['website_title']:'';
			$website_logo = isset($options['website_logo'])?  CMedia::getImage($options['website_logo'],"/upload/all"):'';

			$subscriptions = Cplans::getSubscriptionPlans($subscriber_id,$plans->package_id,'pending',$subscriber_type);
			$subscriptions->sucess_url = $sucess_url;
			$subscriptions->failed_url = $failed_url;
			$subscriptions->save();

			$callback_url = Yii::app()->createAbsoluteUrl($payment_code."/apiv2/subscription_callback",[
				'id'=>$subscriptions->id
			]);	

			$this->code = 1;
			$this->msg = "Ok";
			$this->details = [
				'subscription_id'=>$subscriptions->subscription_id,
				'name'=>$website_title,
				'description'=>$plan_description,
				'image'=>$website_logo,
				'callback_url'=>$callback_url
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
			$payment_code = RazorpayModule::paymentCode();			

			$payload = file_get_contents("php://input");
			//$payload = '{"entity":"event","account_id":"acc_66wvKjFzL95tdB","event":"subscription.cancelled","contains":["subscription"],"payload":{"subscription":{"entity":{"id":"sub_OijgqS4TgASx0l","entity":"subscription","plan_id":"plan_OU9U5FPWdNStxQ","customer_id":"cust_Oijgoxu0Hw4omN","status":"cancelled","type":1,"current_start":1724401974,"current_end":1725006774,"ended_at":1723193615,"quantity":1,"notes":[],"charge_at":null,"start_at":1723192374,"end_at":1740731574,"auth_attempts":0,"total_count":30,"paid_count":2,"customer_notify":true,"created_at":1723192348,"expire_by":null,"short_url":null,"has_scheduled_changes":false,"change_scheduled_at":null,"source":"api","payment_method":"card","offer_id":null,"remaining_count":27}}},"created_at":1723193618}';
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

			$event = isset($payload['event'])?$payload['event']:null;			
			
			switch ($event) {
				case 'subscription.charged':
				case "subscription.updated":
					$payload = isset($payload['payload'])?$payload['payload']:'';
					$subscription = isset($payload['subscription'])?$payload['subscription']:'';
					$entity = isset($subscription['entity'])?$subscription['entity']:'';
					$id = isset($entity['id'])?$entity['id']:'';					
					$status = isset($entity['status'])?$entity['status']:'';

					$start_at = isset($entity['start_at'])?  date("Y-m-d",$entity['start_at']) :null;					
					$charge_at = isset($entity['charge_at'])?  date("Y-m-d",$entity['charge_at']) :null;
					$end_at = isset($entity['end_at'])?  date("Y-m-d",$entity['end_at']) :null;
					$current_start = isset($entity['current_start'])?  date("Y-m-d",$entity['current_start']) :null;
					$current_end = isset($entity['current_end'])?  date("Y-m-d",$entity['current_end']) :null;
												
					if(!empty($id)){
						$model = Cplans::getSubscriptionByID($id);												
						$model->created_at = $start_at;
						$model->next_due = $charge_at;
						$model->expiration = $end_at;
						$model->current_start = $current_start;
						$model->current_end = $current_end;
						$model->status = $status;
						$model->save();


						$jobs = $model->jobs;
						$jobs_data = [
							'subscription_id'=>$id,
							'package_id'=>$model->package_id,
							'subscriber_type'=>$model->subscriber_type,
							'subscriber_id'=>$model->subscriber_id,		
							'is_new'=>$event=='subscription.charged'?1:false
						];
						if (!class_exists($jobs)) {				
							Yii::log( "Job class $jobs does not exist." , CLogger::LEVEL_INFO);
							http_response_code(200);
							Yii::app()->end();										
						}
						$jobInstance = new $jobs($jobs_data);
                        $jobInstance->execute();	
						
						// CANCEL OLD SUBSCRIPTIONS
						Cplans::cancelPaymentSubscriptions($model->subscriber_type,$model->subscriber_id,$payment_code);

					}						
					break;

				case "subscription.cancelled":
						$payload = isset($payload['payload'])?$payload['payload']:'';
						$subscription = isset($payload['subscription'])?$payload['subscription']:'';
						$entity = isset($subscription['entity'])?$subscription['entity']:'';
						$id = isset($entity['id'])?$entity['id']:'';						
						$status = 'cancelled';
						$model = Cplans::getSubscriptionByID($id);
						$model->status = $status;
						$model->save();									
						CommonUtility::pushJobs("SubscriptionsCancelled",[
							'id'=>$model->id,								
							'language'=>Yii::app()->language
						]);								
					break;

				case "subscription.pending":
				case "subscription.halted":	
						$payload = isset($payload['payload'])?$payload['payload']:'';
						$subscription = isset($payload['subscription'])?$payload['subscription']:'';
						$entity = isset($subscription['entity'])?$subscription['entity']:'';
						$id = isset($entity['id'])?$entity['id']:'';						
						$status = 'payment failed';
						
						$start_at = isset($entity['start_at'])?  date("Y-m-d",$entity['start_at']) :null;					
						$charge_at = isset($entity['charge_at'])?  date("Y-m-d",$entity['charge_at']) :null;
						$end_at = isset($entity['end_at'])?  date("Y-m-d",$entity['end_at']) :null;
						$current_start = isset($entity['current_start'])?  date("Y-m-d",$entity['current_start']) :null;
						$current_end = isset($entity['current_end'])?  date("Y-m-d",$entity['current_end']) :null;						

						if(!empty($id)){							
							$model = Cplans::getSubscriptionByID($id);												
							$model->created_at = $start_at;
							$model->next_due = $charge_at;
							$model->expiration = $end_at;
							$model->current_start = $current_start;
							$model->current_end = $current_end;
							$model->status = $status;
							$model->save();

							CommonUtility::pushJobs("SubscriptionsPaymentFailed",[
								'id'=>$model->id,								
								'language'=>Yii::app()->language
							]);								

							$logs = "Razorpay pending webhooks succesful";
						}
					break;					
			}			
		} catch (Exception $e) {
			$logs =  $e->getMessage();
		}
		
		Yii::log( json_encode($logs) , CLogger::LEVEL_ERROR);
		http_response_code(200);
	}

} 
// end class