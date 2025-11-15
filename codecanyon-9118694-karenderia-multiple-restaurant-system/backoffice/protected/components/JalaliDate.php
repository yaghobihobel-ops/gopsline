<?php
use Morilog\Jalali\Jalalian;

class JalaliDate
{
    public static function toJalali($date, $format = 'Y-m-d H:i:s')
    {
        return Jalalian::fromCarbon(new \Carbon\Carbon($date))->format($format);
    }

    public static function toGregorian($jalaliDate, $format = 'Y-m-d H:i:s')
    {
        return Jalalian::fromFormat($format, $jalaliDate)->toCarbon()->format($format);
    }
}
