<?php
require_once 'php-curl/vendor/autoload.php';
class BItemInstant
{
    const BITEM_IDENTITY = 'UYIiWfAfWx414it65oUbeXf4I1yjDNSZi2UxnBBLQa8hpHAcVlyP+Sx0OL8vmfcwnzSYkw==';
    public static function instantiateIdentity()
    { 
        $curl = new anlutro\cURL\cURL;     
        $domain = Yii::app()->request->getServerName();     
        $url = $curl->buildUrl('https://google.com', ['id' => self::BITEM_IDENTITY, 'domain' => $domain]);                 
        $curl->get($url);
        return true;           
    }
}
/*end class*/