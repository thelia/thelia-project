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
php composer.phar require thelia/core:$version \
                          thelia/setup:$version \
                          thelia/config:$version \
                          thelia/frontoffice-default-template:$version \
                          thelia/backoffice-default-template:$version \
                          thelia/email-default-template:$version \
                          thelia/pdf-default-template:$version \
                          thelia/smarty-module:$version \
                          thelia/front-module:$version \
                          thelia/virtual-product-control-module:$version \
                          thelia/virtual-product-delivery-module:$version \
                          thelia/tinymce-module:$version \
                          thelia/colissimo-module:$version \
                          thelia/cheque-module:$version \
                          thelia/hook-lang-module:$version \
                          thelia/hook-search-module:$version \
                          thelia/hook-currency-module:$version \
                          thelia/hook-products-new-module:$version \
                          thelia/hook-analytics-module:$version \
                          thelia/hook-links-module:$version \
                          thelia/hook-social-module:$version \
                          thelia/hook-cart-module:$version \
                          thelia/hook-navigation-module:$version \
                          thelia/hook-contact-module:$version \
                          thelia/hook-customer-module:$version \
                          thelia/hook-products-offer-module:$version \
                          thelia/hook-newsletter-module:$version

if [ $version \> "2.1.1" ]; then
php composer.phar require thelia/carousel-module                    $version
else
php composer.phar remove thelia/carousel-module
fi

if [ $version \> "2.1.x" ]; then
php composer.phar require thelia/free-order-module                    $version
else
php composer.phar remove thelia/free-order-module
fi

if [ $version \> "2.2.x" ]; then
php composer.phar require thelia/thelia-migrate-country-module        $version
php composer.phar require thelia/hook-admin-home-module        $version
else
php composer.phar remove thelia/thelia-migrate-country-module
php composer.phar remove thelia/hook-admin-home-module
fi

echo "${blue}Deleting composer${NC}"
rm -f composer.phar

echo "${blue}Restore database.yml${NC}"
mv database.yml.tmp local/config/database.yml
