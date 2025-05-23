<?php

// Here you can override thelia directories constants.
// Please see vendor/thelia/core/bootstrap.php

define('DS', DIRECTORY_SEPARATOR);
define ("THELIA_ROOT", __DIR__ . DS);
define ('THELIA_VENDOR', __DIR__ . DS . 'vendor' . DS);
define('THELIA_LOCAL_DIR', THELIA_ROOT.'local'.DS);
define ('THELIA_LIB', THELIA_VENDOR . 'thelia' . DS . 'core' . DS . 'lib' . DS . 'Thelia' . DS);
if (is_dir(THELIA_VENDOR.'thelia'.DS.'setup'.DS) ) {
    define('THELIA_SETUP_DIRECTORY', THELIA_VENDOR.'thelia'.DS.'setup'.DS);
} elseif(is_dir(THELIA_ROOT.'setup'.DS)) {
    define('THELIA_SETUP_DIRECTORY', THELIA_ROOT.'setup'.DS);
} else {
    define('THELIA_SETUP_DIRECTORY', THELIA_LOCAL_DIR.'setup'.DS);
}

// --------------------------------------------------

$loader = require "vendor/autoload.php";

return $loader;
