#!/bin/bash
set -e

case "$(uname -s)" in
  Darwin*)
    SUPPORTED=11
    OSVERSION=$(sw_vers -productVersion)
    if [ ${OSVERSION:0:2} -lt $SUPPORTED ]; then
      echo "You are running an older Mac OS version, you will need to connect to github insecurely. A bad actor will be able to pretend to be github and serve you malware. Do you wish to continue? (y/n)"
      read -r RESPONSE
      if [[ $RESPONSE =~ ^[Yy]$ ]]; then
        echo "Continue insecurely..."
      else
        echo "Aborting..."
        exit 0
      fi
    fi
  ;;

  *)
    echo "Continue..."
  ;;
esac

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INSTALLDIR="${VITASDK:-/usr/local/vitasdk}"

. "$DIR/include/install-vitasdk.sh"

if [ -d "$INSTALLDIR" ]; then
  echo "$INSTALLDIR already exists. Remove it first (e.g. 'sudo rm -rf $INSTALLDIR' or 'rm -rf $INSTALLDIR') and then restart this script"
  exit 1
fi

echo "==> Installing vitasdk to $INSTALLDIR"
install_vitasdk $INSTALLDIR

echo "Please add the following to the bottom of your .bashrc:"
printf "\033[0;36m""export VITASDK=${INSTALLDIR}""\033[0m\n"
printf "\033[0;36m"'export PATH=$VITASDK/bin:$PATH'"\033[0m\n"
echo "and then restart your terminal"
