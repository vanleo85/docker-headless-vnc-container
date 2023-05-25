#!/bin/bash

# Источник для дистрибутивов:
# 1. папка dist
# 2. users.v8.1c.ru через утилиту oneget

# 1. Использование папки dist. 
# Рекомендуется использовать такой способ при разовом запуске docker build.
# Для этого в onec/dist положить архивы:
    # 1. Для платформы ниже 8.3.20:
    #     INSTALLER_TYPE=server
    #         deb64_8_3_xx_xxxx.tar.gz
    #     INSTALLER_TYPE=client
    #         deb64_8_3_xx_xxxx.tar.gz
    #         client_8_3_xx_xxxx.deb64.tar.gz
    # 2. Для платформы 8.3.20 и выше:
    #     INSTALLER_TYPE=server
    #         server64_8_3_2x_xxxx.tar.gz
    #     INSTALLER_TYPE=client
    #         server64_8_3_2x_xxxx.tar.gz

# Запустить ./onec/scripts/build-images.sh 8.3.xx.xx

ONEC_VERSION=$1
ONEC_USERNAME=$2
ONEC_PASSWORD=$3

docker build \
    -f ./onec/onec-base/onec-base.Dockerfile \
    --no-cache \
    -t onec-base .

docker build \
    --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
    --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
    --build-arg ONEC_VERSION=${ONEC_VERSION} \
    -f ./onec/onec-vnc/onec-client-vnc.Dockerfile \
    --no-cache \
    -t onec-client-vnc:${ONEC_VERSION} .

docker build \
    --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
    --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
    --build-arg ONEC_VERSION=${ONEC_VERSION} \
    -f ./onec/onec-dbgs/onec-dbgs.Dockerfile \
    --no-cache \
    -t onec-dbgs:${ONEC_VERSION} .