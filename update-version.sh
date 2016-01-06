#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 thelia-version"
    exit
fi

version=$1
blue='\033[0;34m'
NC='\033[0m'

if [ command -v curl >/dev/null 2>&1 ]; then
    echo -e "${blue}curl${NC} is required. Please install it before proceeding"
    exit
fi

if [ $version \> "2.2.x" ]; then
    # download the last list of requirements
    URL="https://raw.githubusercontent.com/thelia/thelia-project/${version}/requirements.lst"
    curl -sS $URL -o "requirements-new.lst"
    if [ $? -ne 0 ]; then
        echo -e "The file ${blue}${URL}${NC} has not been downloaded correctly."
        exit
    fi

    grep -q "Not Found" requirements-new.lst
    if [ $? -ne 0 ]; then
        echo -e "The file ${blue}${URL}${NC} has not been found."
        exit
    fi
else
    # call the old version
    `change-version.sh ${version}`
    exit
fi

echo -e "${blue}Backup database.yml${NC}"
mv local/config/database.yml ./database.yml.tmp

echo -e "${blue}Downloading composer${NC}"
curl -sS https://getcomposer.org/installer | php > /dev/null

REQUIREMENTS=""
UPDATES=( `cat "requirements-new.lst"` )

# get the current list of vendor
php composer.phar info --installed --name-only >requirements-current.lst

echo -e "${blue}Upgrading to $version${NC}"
echo "===================================="
for LINE in "${UPDATES[@]}"
do
    if [ -n "${LINE}" ]; then
        # Check if requirement exists
        REQUIREMENT=${LINE%:*}

        grep -q "${REQUIREMENT}" requirements-current.lst
        if [ $? -eq 0 ]; then
            echo -e "${blue}${REQUIREMENT}${NC} will be updated"
            REQUIREMENTS="${REQUIREMENTS} $LINE"
        else
            while true; do
                read -p "Do you wish to install '${REQUIREMENT}' (yes or no) ? " yn
                case $yn in
                    [Yy]* )
                        echo -e "${blue}${REQUIREMENT}${NC} will be updated"
                        REQUIREMENTS="${REQUIREMENTS} $LINE"
                        break
                        ;;
                    [Nn]* ) break;;
                    * ) echo "Please answer yes or no.";;
                esac
            done
        fi
    fi
done
echo "===================================="

while true; do
    read -p "Do you really want to update (yes or no) ? " yn
    case $yn in
        #[Yy]* ) composer require "${REQUIREMENTS}"; break;;
        [Yy]* ) echo "composer require ${REQUIREMENTS}"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo -e "${blue}Restore database.yml${NC}"
mv database.yml.tmp local/config/database.yml

echo -e "${blue}Deleting temporary files${NC}"
rm -f composer.phar
