<?php

// Here you can override thelia directories constants.
// Please see vendor/thelia/core/bootstrap.php

if(!defined('DS')) {
    define('DS', DIRECTORY_SEPARATOR);
}
if(!defined('THELIA_ROOT')) {
    define ("THELIA_ROOT", __DIR__ . DS);
}
if(!defined('THELIA_VENDOR')) {
    define ('THELIA_VENDOR', __DIR__ . DS . 'vendor' . DS);
}
if(!defined('THELIA_LOCAL_DIR')) {
    define('THELIA_LOCAL_DIR', THELIA_ROOT.'local'.DS);
}
if(!defined('THELIA_LIB')) {
    define ('THELIA_LIB', THELIA_VENDOR . 'thelia' . DS . 'core' . DS . 'lib' . DS . 'Thelia' . DS);
}

if(!defined('THELIA_SETUP_DIRECTORY')) {
    if (is_dir(THELIA_VENDOR . 'thelia' . DS . 'setup' . DS)) {
        define('THELIA_SETUP_DIRECTORY', THELIA_VENDOR . 'thelia' . DS . 'setup' . DS);
    } elseif (is_dir(THELIA_ROOT . 'setup' . DS)) {
        define('THELIA_SETUP_DIRECTORY', THELIA_ROOT . 'setup' . DS);
    } else {
        define('THELIA_SETUP_DIRECTORY', THELIA_LOCAL_DIR . 'setup' . DS);
    }
}

// --------------------------------------------------

return require "vendor/autoload_runtime.php";
