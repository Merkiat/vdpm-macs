#!/bin/bash

get_download_link () {
  case "$(uname -s)" in
    Darwin*)
      SUPPORTED=11
      OSVERSION=$(sw_vers -productVersion)
      if [ ${OSVERSION:0:2} -lt $SUPPORTED ]; then
          wget -qO- https://github.com/vitasdk/vita-headers/raw/master/.travis.d/last_built_toolchain.py --no-check-certificate | $(which python||which python3) - $@
      else
        wget -qO- https://github.com/vitasdk/vita-headers/raw/master/.travis.d/last_built_toolchain.py | python3 - $@
      fi
    ;;

    *)
      wget -qO- https://github.com/vitasdk/vita-headers/raw/master/.travis.d/last_built_toolchain.py | python3 - $@
    ;;
  esac
}

install_vitasdk () {
  INSTALLDIR=$1

  case "$(uname -s)" in
     Darwin*)
      mkdir -p $INSTALLDIR
      if [ ${OSVERSION:0:2} -lt $SUPPORTED ]; then
          wget -O- "$(get_download_link master osx)" --no-check-certificate | tar xj -C $INSTALLDIR --strip-components=1
      else
        wget -O- "$(get_download_link master osx)" | tar xj -C $INSTALLDIR --strip-components=1
      fi
     ;;

     Linux*)
      if [ -n "${TRAVIS}" ]; then
          sudo apt-get install libc6-i386 lib32stdc++6 lib32gcc1 patch
      fi
      command -v curl || { echo "curl missing (install using: apt install curl)" ; exit 1; }
      if [ ! -d "$INSTALLDIR" ]; then
        sudo mkdir -p $INSTALLDIR
        sudo chown $USER:$(id -gn $USER) $INSTALLDIR
      fi
      wget -O- "$(get_download_link master linux)" | tar xj -C $INSTALLDIR --strip-components=1
     ;;

     MSYS*|MINGW64*)
      UNIX=false
      mkdir -p $INSTALLDIR
      wget -O- "$(get_download_link master win)" | tar xj -C $INSTALLDIR --strip-components=1
     ;;

     CYGWIN*|MINGW32*)
      echo "Please use msys2. Exiting..."
      exit 1
     ;;

     *)
       echo "Unknown OS"
       exit 1
     ;;
  esac

}
