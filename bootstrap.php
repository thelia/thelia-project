<?php

// Here you can override thelia directories constants.
// Please see vendor/thelia/core/bootstrap.php

define ("THELIA_ROOT", __DIR__ . DIRECTORY_SEPARATOR);
define ("THELIA_SETUP_DIRECTORY", __DIR__ . DIRECTORY_SEPARATOR . "local" . DIRECTORY_SEPARATOR . "setup" . DIRECTORY_SEPARATOR);

// --------------------------------------------------

$loader = require "vendor/autoload.php";

return $loader;