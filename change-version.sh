#!/bin/sh
if [ $# -ne 1 ]; then
    echo "Usage: $0 thelia-version"
    exit
fi

version=$1
blue='\033[0;34m'
NC='\033[0m'

echo "${blue}Backup database.yml${NC}"
mv local/config/database.yml ./database.yml.tmp

echo "${blue}Downloading composer${NC}"
curl -sS https://getcomposer.org/installer | php > /dev/null

echo "${blue}Upgrading to $version${NC}"
php composer.phar require thelia/core $version
php composer.phar require thelia/setup $version
php composer.phar require thelia/config $version
php composer.phar require thelia/frontoffice-default-template $version
php composer.phar require thelia/backoffice-default-template $version
php composer.phar require thelia/email-default-template $version
php composer.phar require thelia/pdf-default-template $version

echo "${blue}Deleting composer${NC}"
rm -f composer.phar

echo "${blue}Restore database.yml${NC}"
mv database.yml.tmp local/config/database.yml
