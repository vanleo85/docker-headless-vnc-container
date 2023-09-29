#!/bin/bash
set -e

ONEC_USERNAME=$1
ONEC_PASSWORD=$2

if [ -z "$ONEC_USERNAME" ]
then
    echo "ONEC_USERNAME not set"
    exit 1
fi

if [ -z "$ONEC_PASSWORD" ]
then
    echo "ONEC_PASSWORD not set"
    exit 1
fi

if [ -z "$ONEC_VERSION" ]
then
    echo "ONEC_VERSION not set"
    exit 1
fi

ONEC_RELEASE=`echo $ONEC_VERSION | cut -d . -f 3`
echo "Release: "$ONEC_RELEASE

if [ "$ONEC_VERSION" = "8.3.20.2290" ]; then
    echo "Downloading over yandex cloud"
    mkdir -p /tmp/downloads/platform83/8.3.20.2290
    wget --no-check-certificate -q -x -O /tmp/downloads/platform83/8.3.20.2290/server64_8_3_20_2290.tar.gz https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/RkrfuDNnhV1MjQ
    exit 0
elif [ "$ONEC_VERSION" = "8.3.22.1923" ]; then
    echo "Downloading over yandex cloud"
    mkdir -p /tmp/downloads/platform83/8.3.22.1923
    wget --no-check-certificate -q -x -O /tmp/downloads/platform83/8.3.22.1923/server64_8_3_22_1923.tar.gz https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/lwQyAuEH2G7Rdg
    exit 0
elif [ "$ONEC_VERSION" = "8.3.21.1607" ]; then
    echo "Downloading over yandex cloud"
    mkdir -p /tmp/downloads/platform83/8.3.21.1607
    wget --no-check-certificate -q -x -O /tmp/downloads/platform83/8.3.21.1607/server64_8_3_21_1607.tar.gz https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/uY_bWX9atFawYw
    exit 0
elif [ "$ONEC_VERSION" = "8.3.20.1710" ]; then
    echo "Downloading over yandex cloud"
    mkdir -p /tmp/downloads/platform83/8.3.20.1710
    wget --no-check-certificate -q -x -O /tmp/downloads/platform83/8.3.20.1710/server64_8_3_20_1710.tar.gz https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/YSUIBCX17iOeFg
    exit 0
elif [ "$ONEC_VERSION" = "8.3.20.2180" ]; then
    echo "Downloading over yandex cloud"
    mkdir -p /tmp/downloads/platform83/8.3.20.2180
    wget --no-check-certificate -q -x -O /tmp/downloads/platform83/8.3.20.2180/server64_8_3_20_2180.tar.gz https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/2otIvnPsjXD-qQ
    exit 0
elif [ "$ONEC_VERSION" = "8.3.20.2257" ]; then
    echo "Downloading over yandex cloud"
    mkdir -p /tmp/downloads/platform83/8.3.20.2257
    wget --no-check-certificate -q -x -O /tmp/downloads/platform83/8.3.20.2257/server64_8_3_20_2257.tar.gz https://getfile.dokpub.com/yandex/get/https://disk.yandex.ru/d/GWpdPWsXl7qINg
    exit 0
fi

echo "Downloading Oneget tool from https://github.com/v8platform/oneget"
wget --no-check-certificate -O oneget.tar.gz https://github.com/v8platform/oneget/releases/download/v0.5.3/oneget_Linux_x86_64.tar.gz \
    && mkdir oneget_tool \
    && tar xzf oneget.tar.gz -C oneget_tool \
    && rm oneget.tar.gz

if [ ! -f /tmp/oneget_tool/oneget ]; then
    echo "Oneget not found!"
    exit 1
fi

if [[ "$ONEC_RELEASE" -lt "20" ]]; then
    package="deb"
    package_installer_type="."$INSTALLER_TYPE
else
    package="linux"
    package_installer_type=".full"
fi

case "$INSTALLER_TYPE" in
  server)
      /tmp/oneget_tool/oneget get "platform:"$package$package_installer_type".x64@"$ONEC_VERSION
      ;;
  client)
      if [[ "$ONEC_RELEASE" -lt "20" ]]; then
      /tmp/oneget_tool/oneget get "platform:"$package".server.x64@"$ONEC_VERSION
      fi
      /tmp/oneget_tool/oneget get "platform:"$package$package_installer_type".x64@"$ONEC_VERSION
esac
