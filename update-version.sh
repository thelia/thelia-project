#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 thelia-version"
  exit
fi

version=$1
blue='\033[0;34m'
NC='\033[0m'

# Ask a question function
ask() {
  # http://djm.me/ask
  local prompt default REPLY

  while true; do
    if [ "${2:-}" = "Y" ]; then
      prompt="Y/n"
      default=Y
    elif [ "${2:-}" = "N" ]; then
      prompt="y/N"
      default=N
    else
      prompt="y/n"
      default=
    fi

    # Ask the question (not using "read -p" as it uses stderr not stdout)
    echo -e -n "$1 [$prompt] "

    # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
    read REPLY </dev/tty

    # Default?
    if [ -z "$REPLY" ]; then
      REPLY=$default
    fi

    # Check if the reply is valid
    case "$REPLY" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac
  done
}

download() {
  curl -sS $1 -o "requirements-new.lst"

  if [ $? -ne 0 ]; then
    echo -e "The file ${blue}${1}${NC} has not been downloaded correctly."
    return 1
  fi

  grep -q "Not Found" requirements-new.lst
  if [ $? -eq 0 ]; then
    echo -e "The file ${blue}${1}${NC} has not been found."
    return 1
  fi

  return 0
}

if [ command -v curl >/dev/null 2>&1 ]; then
  echo -e "${blue}curl${NC} is required. Please install it before proceeding"
  exit
fi

# download the last list of requirements
URL="https://raw.githubusercontent.com/bibich/thelia-project/${version}/requirements/${version}.lst"
if ! download ${URL}; then
  # try to download from the master repository
  URL="https://raw.githubusercontent.com/bibich/thelia-project/master/requirements/${version}.lst"
  if ! download ${URL}; then
    if ask "No valid requirements file found for version ${blue}${version}${NC}. Do you want to use the legacy script ?"; then
      # call the old version
      `change-version.sh ${version}`
    else
      exit 1
    fi
  fi
fi

if [ -e database.yml.tmp ]; then
  echo -e "${blue}Backing up database.yml${NC}"
  mv local/config/database.yml ./database.yml.tmp
fi

echo -e "${blue}Downloading composer${NC}"
curl -sS https://getcomposer.org/installer | php > /dev/null

REQUIREMENTS=""
UPDATES=( `cat "requirements-new.lst"` )

# get the current list of vendor
php composer.phar info --name-only >requirements-current.lst

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
      if ask "Do you wish to install '${REQUIREMENT}' ? "; then
        echo -e "${blue}${REQUIREMENT}${NC} will be updated"
        REQUIREMENTS="${REQUIREMENTS} $LINE"
      fi
    fi
  fi
done
echo "===================================="

echo "List of requirements that will be updated/installed : "
echo "${REQUIREMENTS}"

if ask "Do you really want to update to ${blue}${version}${NC}? "; then
  echo "composer require ${REQUIREMENTS}"

  if [ $? -eq 0 ]; then
    echo -e "Your Thelia has been updated to version ${blue}${version}${NC}."
    echo -e "You have to upgrade your database now."
    echo -e "Use this command : ${blue}php local/setup/update.php${NC}."
  else
    echo -e "An error occured, your Thelia has not been updated !"
  fi
fi

echo -e "${blue}Restoring database.yml${NC}"
[ -e database.yml.tmp ] && mv database.yml.tmp local/config/database.yml

echo -e "${blue}Deleting temporary files${NC}"
rm -f composer.phar
rm -f requirements-current.lst
rm -f requirements-new.lst
