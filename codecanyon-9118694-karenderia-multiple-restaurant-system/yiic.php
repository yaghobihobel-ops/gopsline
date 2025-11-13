#!/usr/bin/env php
<?php
// Path to Yii framework bootstrap file
$yii = dirname(__FILE__).'/framework/yii.php';
require_once dirname(__FILE__).'/k-config.php';
// Configuration file for console application
$config = dirname(__FILE__).'/protected/config/console.php';

// Include Yii framework bootstrap file
require_once($yii);

// Create console application instance and run
Yii::createConsoleApplication($config)->run();
