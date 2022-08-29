Readme
======

#### This is the project creation repository of Thelia. If you want to contribute, please take a look at [thelia/thelia](https://github.com/thelia/thelia)

Thelia
------
[![Actions Status: test](https://github.com/thelia/thelia/workflows/test/badge.svg)](https://github.com/thelia/thelia/actions?query=workflow%3A"test") [![License](https://poser.pugx.org/thelia/thelia/license.png)](https://packagist.org/packages/thelia/thelia) [![Scrutinizer Quality Score](https://scrutinizer-ci.com/g/thelia/thelia/badges/quality-score.png?s=61e3e04a69bffd71c29b08e5392080317a546716)](https://scrutinizer-ci.com/g/thelia/thelia/)

[Thelia](http://thelia.net/) is an open source tool for creating e-business websites and managing online content. This software is published under LGPL.

This is the new major version of Thelia.

You can download this version and have a try or take a look at the source code (or anything you wish, respecting LGPL).  See http://thelia.net/ web site for more information.

A repository containing all thelia modules is available at this address : https://github.com/thelia-modules


Compatibility
------------

|         |   Thelia 2.3    |      Thelia 2.4 |  Thelia 2.5 |
|---------|:---------------:|----------------:|------------:|
| PHP     | 5.5 5.6 7.0 7.1 | 7.0 7.1 7.2 7.3 |     8.0.2 8.1 |
| MySQL   |     5.5 5.6     |     5.5 5.6 5.7 | 5.6 5.7 8.0 |
| Symfony |       2.8       |             2.8 |     6.0 6.1 |

Requirements
------------

* PHP
    * Required extensions :
        * PDO_Mysql
        * openssl
        * intl
        * gd
        * curl
        * dom
    * safe_mode off
    * memory_limit at least 128M, preferably 256.
    * post\_max\_size 20M
    * upload\_max\_filesize 2M
    * date.timezone must be defined
* Web Server Apache 2 or Nginx
* MySQL 5 or 8

## Create a Thelia project

``` bash
$ curl -sS https://getcomposer.org/installer | php
$ php composer.phar create-project thelia/thelia-project path/ 2.5.0 (or 2.4.5)
```

## Install it with your own environment

You can install Thelia using the cli tool and the scripts provided by thelia/setup

``` bash
$ php Thelia thelia:install
```

Consult the page : http://localhost/thelia/web

You can create a virtual host and choose web folder for root directory.

## Quick install with docker-compose

This repo contains all the configuration needed to run Thelia with docker and docker-compose.    
Warning, this docker configuration is not ready for production.

It requires obviously [docker](https://docker.com/) and [docker-compose](https://docs.docker.com/compose/)

To install Thelia within Docker, run :

``` bash
./start-docker.sh
```

It will ask you for a template name (usually your project name) if you don't have a .env file but you can create the .env by yourself, take a look at .env.docker to make your own.

If your folder template does not exist it will copy the "modern" template.

Next just go to http://localhost:8080 and you should see your Thelia installed !

And run the same command everytime you want launch your Thelia.

If you want add some sample data just add the option `-demo`
``` bash
./start-docker.sh -demo
```

If you want to access your database from your computer (with DBeaver, Sequel Pro or anything else) by default the host is `localhost` and the port is `8086`

Documentation
-------------

Thelia documentation is available at http://doc.thelia.net


Contribute
----------

See the documentation : http://doc.thelia.net/en/documentation/contribute.html

### Mac OSX

If you use Mac OSX, it still doesn't use php 5.4 as default php version... There are many solutions for you :

* use [phpbrew](https://github.com/c9s/phpbrew)
* use last MAMP version and put the php bin directory in your path:

```bash
export PATH=/Applications/MAMP/bin/php/php5.5.x/bin/:$PATH
```

* configure a complete development environment : http://php-osx.liip.ch/
* use a virtual machine with vagrant and puppet : https://puphpet.com/

### MySQL 5.6

As of MySQL 5.6, default configuration sets the sql_mode value to

```
STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION
```

This 'STRICT_TRANS_TABLES' configuration results in SQL errors when no default value is defined on NOT NULL columns and the value is empty or invalid.

You can edit this default config in ` /etc/my.cnf ` and change the sql_mode to remove the STRICT_TRANS_TABLES part

```
[mysqld]
sql_mode=NO_ENGINE_SUBSTITUTION
```

Assuming your sql_mode is the default one, you can change the value directly on the run by running the following SQL Command

```sql
SET @@GLOBAL.sql_mode='NO_ENGINE_SUBSTITUTION', @@SESSION.sql_mode='NO_ENGINE_SUBSTITUTION'
```

For more information on sql_mode you can consult the [MySQL doc](http://dev.mysql.com/doc/refman/5.0/fr/server-sql-mode.html "sql Mode")

## Archive builders
Thelia's archive builder's needs external libraries.
For zip archives, you need PECL zip. See [PHP Doc](http://php.net/manual/en/zip.installation.php)

For tar archives, you need PECL phar. Moreover, you need to deactivate php.ini option "phar.readonly":
```ini
phar.readonly = Off
```

For tar.bz2 archives, you need tar's dependencies and the extension "bzip2". See [PHP Doc](http://php.net/manual/fr/book.bzip2.php)

For tar.gz archives, you need tar's dependencies and the extension "zlib". See [PHP Doc](http://fr2.php.net/manual/fr/book.zlib.php)
