<?php
/*************************************************************************************/
/* This file is part of the Thelia package.                                          */
/*                                                                                   */
/* Copyright (c) OpenStudio                                                          */
/* email : dev@thelia.net                                                            */
/* web : http://www.thelia.net                                                       */
/*                                                                                   */
/* For the full copyright and license information, please view the LICENSE.txt       */
/* file that was distributed with this source code.                                  */
/*************************************************************************************/

namespace Thelia\Project;

use App\Kernel;
use Composer\Script\Event;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Output\ConsoleOutput;
use Thelia\Command\Install;
use Thelia\Core\Application;
use Symfony\Bundle\FrameworkBundle\Kernel\MicroKernelTrait;

/**
 * Class ScriptHandler
 * @package Thelia\Project
 * @author Benjamin Perche <benjamin@thelia.net>
 */
class ScriptHandler
{
    public static function installThelia(Event $event)
    {
        if ($event->getIO()->askConfirmation('Would you like to install Thelia now ? [Y/n] ', true)) {
            require __DIR__ . "/../../../bootstrap.php";

            $kernel = new class($env = "prod", true) extends Kernel {
                use MicroKernelTrait;

                public function getCacheDir()
                {
                    if (\defined('THELIA_ROOT')) {
                        return THELIA_CACHE_DIR . $this->environment;
                    }

                    return parent::getCacheDir();
                }

                public function getLogDir()
                {
                    if (\defined('THELIA_ROOT')) {
                        return THELIA_LOG_DIR;
                    } else {
                        return parent::getLogDir();
                    }
                }

                public function registerBundles(): array
                {
                    return [
                        new Symfony\Bundle\FrameworkBundle\FrameworkBundle()
                    ];
                }
            };



            $cmd = new Install();
            $cmd->setApplication(new Application($kernel));

            $cmd->run(new ArrayInput(["command" => "thelia:install"]), new ConsoleOutput());
        }
    }
}
