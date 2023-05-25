#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install some common tools for further installation"
apt-get update
apt-get install -y vim wget net-tools locales bzip2 procps \
    python3-numpy #used for websockify/novnc
apt-get clean -y

echo "generate locales für en_US.UTF-8"
#locale-gen en_US.UTF-8
#locale-gen ru_RU.UTF-8
#dpkg-reconfigure locales
sed -i -e \
  's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen \
   && locale-gen

ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone