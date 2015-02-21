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

use Composer\Script\Event;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Output\ConsoleOutput;
use Thelia\Command\Install;
use Thelia\Core\Application;
use Thelia\Core\Thelia;

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

            $kernel = new Thelia("install", true);
            $kernel->boot();

            $cmd = new Install();
            $cmd->setApplication(new Application($kernel));

            $cmd->run(new ArrayInput(["command" => "thelia:install"]), new ConsoleOutput());
        }
    }
}
