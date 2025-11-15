<?php
class NeshanMapProvider
{
    public static function findPlace($query, $apiKey, $lat, $lng)
    {
        $api_url = "https://api.neshan.org/v1/search?term=" . urlencode($query) . "&lat=$lat&lng=$lng";
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $api_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Api-Key: ' . $apiKey
        ));
        $result = curl_exec($ch);
        curl_close($ch);
        return json_decode($result, true);
    }

    public static function placeDetails($place_id, $apiKey)
    {
        // For Neshan, place_id is the location coordinates
        $coords = explode(',', $place_id);
        $api_url = "https://api.neshan.org/v1/reverse?lat=" . $coords[0] . "&lng=" . $coords[1];
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $api_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Api-Key: ' . $apiKey
        ));
        $result = curl_exec($ch);
        curl_close($ch);
        return json_decode($result, true);
    }

    public static function reverseGeocoding($lat, $lng, $apiKey)
    {
        $api_url = "https://api.neshan.org/v1/reverse?lat=$lat&lng=$lng";
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $api_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Api-Key: ' . $apiKey
        ));
        $result = curl_exec($ch);
        curl_close($ch);
        return json_decode($result, true);
    }
}
