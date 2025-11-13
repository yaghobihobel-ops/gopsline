<components-mercadopago
ref="<?php echo $payment_code?>"
title="<?php echo t("Add mercadopago")?>"	 	  
payment_code="<?php echo $payment_code?>"
merchant_id="<?php echo isset($credentials['merchant_id'])?$credentials['merchant_id']:0;?>"
merchant_type="<?php echo isset($credentials['merchant_type'])?$credentials['merchant_type']:2;?>"
public_key="<?php echo isset($credentials['attr1'])?$credentials['attr1']:''; ?>"
:amount="amount_to_pay"
:cart_uuid="cart_uuid"
currency_code="<?php echo Price_Formatter::$number_format['currency_code'];?>"
ajax_url = "<?php echo Yii::app()->createAbsoluteUrl("$payment_code/api")?>"

@set-paymentlist="SavedPaymentList"	 	
@after-cancel-payment="AfterCancelPayment"	
@after-successfulpayment="afterSuccessfulpayment"	
@after-failedpayment="afterFailedpayment"	
@close-topup="closeTopup"
@alert="Alert"	
@show-loader="showLoadingBox"	
@close-loader="closeLoadingBox"

:label="{		    
submit: '<?php echo CJavaScript::quote(t("Submit"))?>',
cancel: '<?php echo CJavaScript::quote(t("Cancel"))?>',
notes: '<?php echo CJavaScript::quote(t("Pay using your mercadopago account"))?>',
first_name: '<?php echo CJavaScript::quote(t("First name"))?>',
last_name: '<?php echo CJavaScript::quote(t("Last name"))?>',
email_address: '<?php echo CJavaScript::quote(t("Email address"))?>',
identification_type: '<?php echo CJavaScript::quote(t("Identification type"))?>',
identification_number: '<?php echo CJavaScript::quote(t("Identification number"))?>',
}"  
:on_error="{		    
error: '<?php echo CJavaScript::quote(t("An error has occured"))?>',
}"  
>
</components-mercadopago>