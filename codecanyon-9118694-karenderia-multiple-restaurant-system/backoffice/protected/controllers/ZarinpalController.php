<?php
class ZarinpalController extends CController
{
    public function actionRequest()
    {
        Yii::import('application.components.Zarinpal');
        $merchantId = CMerchants::getOption(Yii::app()->user->merchant_id, 'zarinpal_merchant_id');
        $zarinpal = new Zarinpal($merchantId);

        $orderId = Yii::app()->request->getParam('order_id');
        $order = COrders::get($orderId);

        $amount = $order['total'];
        $description = "Payment for order #" . $order['order_id'];
        $callbackUrl = Yii::app()->createAbsoluteUrl('zarinpal/verify');

        $result = $zarinpal->request($amount, $description, $callbackUrl);

        if ($result && isset($result['Authority'])) {
            $this->redirect('https://www.zarinpal.com/pg/StartPay/' . $result['Authority']);
        } else {
            // Handle error
        }
    }

    public function actionVerify()
    {
        Yii::import('application.components.Zarinpal');
        $merchantId = CMerchants::getOption(Yii::app()->user->merchant_id, 'zarinpal_merchant_id');
        $zarinpal = new Zarinpal($merchantId);

        $authority = Yii::app()->request->getParam('Authority');
        $status = Yii::app()->request->getParam('Status');

        $orderId = Yii::app()->request->getParam('order_id');
        $order = COrders::get($orderId);

        $amount = $order['total'];

        $result = $zarinpal->verify($authority, $amount);

        if ($result && isset($result['Status']) && $result['Status'] == 100) {
            // Payment is successful
            COrders::updateStatus($orderId, 'paid');
            $this->redirect(Yii::app()->createUrl('store/order-confirmation', array('order_id' => $orderId)));
        } else {
            // Payment failed
            COrders::updateStatus($orderId, 'failed');
            $this->redirect(Yii::app()->createUrl('store/payment-failed', array('order_id' => $orderId)));
        }
    }
}
