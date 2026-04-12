<?php

declare(strict_types=1);

/*
 * This file is part of the Thelia package.
 * http://www.thelia.net
 *
 * (c) OpenStudio <info@thelia.net>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

use App\Kernel;

// Define Thelia directory constants BEFORE the Composer autoloader runs
// core/bootstrap.php (which assumes core/ is at the project root).
// This must happen before require autoload_runtime.php loads the autoloader.
require_once dirname(__DIR__).'/bootstrap.php';
require_once dirname(__DIR__).'/vendor/autoload_runtime.php';

return fn (array $context) => new Kernel($context['APP_ENV'], (bool) $context['APP_DEBUG']);
