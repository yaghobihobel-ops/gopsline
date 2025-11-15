<?php
class ZarinpalController extends CController
{
    public function actionRequest()
    {
        $order_uuid = $_POST['order_uuid'];
        $order = FunctionsV3::getOrderByUUID($order_uuid);

        if (!$order) {
            throw new CHttpException(404, 'Order not found.');
        }

        $merchant_id = Yii::app()->params['zarinpal_merchant_id'];
        if (empty($merchant_id)) {
            throw new CHttpException(500, 'Zarinpal Merchant ID is not configured.');
        }
        $amount = $order['total_w_tax']; // Use the actual order amount from the database
        $callback_url = Yii::app()->createAbsoluteUrl('zarinpal/verify', ['order_uuid' => $order_uuid]);
        $description = "Payment for order #" . $order_uuid;

        $data = array(
            "merchant_id" => $merchant_id,
            "amount" => $amount,
            "callback_url" => $callback_url,
            "description" => $description,
        );

        $jsonData = json_encode($data);
        $ch = curl_init('https://api.zarinpal.com/pg/v4/payment/request.json');
        curl_setopt($ch, CURLOPT_USERAGENT, 'ZarinPal Rest Api v1');
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
        curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonData);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
            'Content-Length: ' . strlen($jsonData)
        ));

        $result = curl_exec($ch);
        $err = curl_error($ch);
        $result = json_decode($result, true, JSON_PRETTY_PRINT);
        curl_close($ch);

        if ($err) {
            echo "cURL Error #:" . $err;
        } else {
            if (empty($result['errors'])) {
                if ($result['data']['code'] == 100) {
                    header('Location: https://www.zarinpal.com/pg/StartPay/' . $result['data']["authority"]);
                }
            } else {
                echo'Error Code: ' . $result['errors']['code'];
                echo'message: ' .  $result['errors']['message'];
            }
        }
    }

    public function actionVerify()
    {
        $order_uuid = $_GET['order_uuid'];
        $order = FunctionsV3::getOrderByUUID($order_uuid);

        if (!$order) {
            throw new CHttpException(404, 'Order not found.');
        }

        $merchant_id = Yii::app()->params['zarinpal_merchant_id'];
        if (empty($merchant_id)) {
            throw new CHttpException(500, 'Zarinpal Merchant ID is not configured.');
        }
        $authority = $_GET['Authority'];
        $amount = $order['total_w_tax']; // Use the actual order amount from the database for security

        $data = array("merchant_id" => $merchant_id, "authority" => $authority, "amount" => $amount);
        $jsonData = json_encode($data);
        $ch = curl_init('https://api.zarinpal.com/pg/v4/payment/verify.json');
        curl_setopt($ch, CURLOPT_USERAGENT, 'ZarinPal Rest Api v1');
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
        curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonData);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
            'Content-Length: ' . strlen($jsonData)
        ));

        $result = curl_exec($ch);
        $err = curl_error($ch);
        curl_close($ch);
        $result = json_decode($result, true);

        if ($err) {
            echo "cURL Error #:" . $err;
        } else {
            if ($result['data']['code'] == 100) {
                // Payment was successful
                $order_id = $order['order_id'];
                $model = AR_ordernew::model()->findByPk($order_id);
                if ($model) {
                    $model->status = 'paid';
                    $model->save();

                    $params = array(
                        'order_id' => $order_id,
                        'transaction_type' => 'credit',
                        'transaction_name' => 'zarinpal',
                        'transaction_amount' => $amount,
                        'transaction_id' => $result['data']['ref_id'],
                        'status' => 'paid',
                        'date_created' => CommonUtility::dateNow(),
                        'ip_address' => CommonUtility::userIp()
                    );
                    Yii::app()->db->createCommand()->insert("{{ordernew_transaction}}", $params);

                    echo 'Transaction success. RefID:' . $result['data']['ref_id'];
                } else {
                    echo 'Error: Order not found in database.';
                }
            } else {
                echo'message: ' .  $result['errors']['message'];
                echo'Error Code: ' . $result['errors']['code'];
            }
        }
    }
}
