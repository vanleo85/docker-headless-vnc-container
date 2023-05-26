#!/bin/bash
set -e

echo "Установка шрифтов Microsoft"

cp /etc/apt/sources.list /etc/apt/sources.list.default

echo "deb http://ftp.ru.debian.org/debian bullseye main" >> /etc/apt/sources.list \
  && echo "deb http://ftp.ru.debian.org/debian bullseye contrib" >> /etc/apt/sources.list \
  && apt update \
  && apt install ttf-mscore* -qqy \
  && fc-cache -fv

cp /etc/apt/sources.list.default /etc/apt/sources.list
rm -f /etc/apt/sources.list.default
rm -rf /var/lib/apt/lists/*