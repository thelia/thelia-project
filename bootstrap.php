<?php

// Here you can override thelia directories constants.
// Please see vendor/thelia/core/bootstrap.php

define('DS', DIRECTORY_SEPARATOR);
define ("THELIA_ROOT", __DIR__ . DS);
define ('THELIA_VENDOR', __DIR__ . DS . 'vendor' . DS);
define ('THELIA_LIB', THELIA_VENDOR . 'thelia' . DS . 'core' . DS . 'lib' . DS . 'Thelia' . DS);
define ("THELIA_SETUP_DIRECTORY", __DIR__ . DS . "local" . DS . "setup" . DS);

// --------------------------------------------------

$loader = require "vendor/autoload.php";

return $loader;