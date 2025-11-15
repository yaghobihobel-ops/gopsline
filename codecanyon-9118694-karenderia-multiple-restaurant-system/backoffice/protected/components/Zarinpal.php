<?php
class Zarinpal
{
    private $merchantId;

    public function __construct($merchantId)
    {
        $this->merchantId = $merchantId;
    }

    public function request($amount, $description, $callbackUrl)
    {
        // Placeholder for Zarinpal payment request
        return null;
    }

    public function verify($authority, $amount)
    {
        // Placeholder for Zarinpal payment verification
        return null;
    }
}
