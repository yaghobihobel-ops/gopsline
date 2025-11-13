<?php
interface MapProviderInterface
{
    public function search($query);
    public function geocode($address);
    public function reverseGeocode($latitude, $longitude);
}
