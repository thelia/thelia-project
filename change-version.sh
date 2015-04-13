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
php composer.phar require thelia/core                               $version
php composer.phar require thelia/setup                              $version
php composer.phar require thelia/config                             $version
php composer.phar require thelia/frontoffice-default-template       $version
php composer.phar require thelia/backoffice-default-template        $version
php composer.phar require thelia/email-default-template             $version
php composer.phar require thelia/smarty-module                      $version
php composer.phar require thelia/front-module                       $version
php composer.phar require thelia/virtual-product-control-module     $version
php composer.phar require thelia/virtual-product-delivery-module    $version
php composer.phar require thelia/tinymce-module                     $version
php composer.phar require thelia/colissimo-module                   $version
php composer.phar require thelia/cheque-module                      $version
php composer.phar require thelia/thelia-debug-bar-module            $version
php composer.phar require thelia/hook-lang-module                   $version
php composer.phar require thelia/hook-search-module                 $version
php composer.phar require thelia/hook-currency-module               $version
php composer.phar require thelia/hook-products-new-module           $version
php composer.phar require thelia/hook-analytics-module              $version
php composer.phar require thelia/hook-links-module                  $version
php composer.phar require thelia/hook-social-module                 $version
php composer.phar require thelia/hook-cart-module                   $version
php composer.phar require thelia/hook-navigation-module             $version
php composer.phar require thelia/hook-contact-module                $version
php composer.phar require thelia/hook-customer-module               $version
php composer.phar require thelia/hook-products-offer-module         $version
php composer.phar require thelia/hook-newsletter-module             $version

if [ $version -ge "2.1.2" ]; then
php composer.phar require thelia/carousel-module                    $version
else
php composer.phar remove thelia/carousel-module
fi

echo "${blue}Deleting composer${NC}"
rm -f composer.phar

echo "${blue}Restore database.yml${NC}"
mv database.yml.tmp local/config/database.yml
