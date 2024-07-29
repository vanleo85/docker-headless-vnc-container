#!/bin/bash
set -e

ONEC_RELEASE=`echo $ONEC_VERSION | cut -d . -f 3`
echo "Release: "$ONEC_RELEASE

# Опциональные зависимости Linux (см. ИТС)
# Разработка и администрирование - 1С:Предприятие <версия> документация 
# Руководство администратора - Требования к аппаратуре и программному обеспечению - Прочие требования - Для ОС Linux https://its.1c.ru/db/v8318doc#bookmark:adm:TI000000022
# Руководство пользователя - Глава 2. Установка и обновление системы -  Особенности установки системы в ОС Linux https://its.1c.ru/db/v8318doc#bookmark:usr:TI000000019
apt update && apt install -qqy --no-install-recommends \
    libmagickwand-6.q16-6 \
    libfontconfig1 \
    libfreetype6 \
    libgsf-1-114 \
    libglib2.0-0 \
    libodbc1 \
    unixodbc \
    libkrb5-3 \
    libgssapi-krb5-2

cp /etc/apt/sources.list /etc/apt/sources.list.default
echo "deb http://mirror.yandex.ru/debian buster main" >> /etc/apt/sources.list
apt update

if [[ "$ONEC_RELEASE" -lt "20" ]]; then
    apt install -qqy --no-install-recommends libwebkitgtk-3.0-0
else
    apt install -qqy --no-install-recommends \
        libgtk-3-0 \
        libenchant1c2a \
        libharfbuzz-icu0 \
        libgstreamer1.0-0 \
        libgstreamer-plugins-base1.0-0 \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        libsecret-1-0 \
        libsoup2.4-1 \
        libgl1 \
        libegl1 \
        libxrender1 \
        libxfixes3 \
        libxslt1.1 \
        geoclue-2.0
fi

if [[ "$ONEC_RELEASE" -ge "24" ]]; then
    # Иначе не работает на платформе 8.3.24
    apt install -qqy --no-install-recommends libwebkit2gtk-4.0-dev
fi

cp /etc/apt/sources.list.default /etc/apt/sources.list
rm -f /etc/apt/sources.list.default
rm -rf /var/lib/apt/lists/*