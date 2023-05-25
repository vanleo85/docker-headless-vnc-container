FROM ubuntu:20.04

ENV DEBIAN_FRONTEND         noninteractive
ENV TZ                      Europe/Moscow
ENV LANGUAGE                ru_RU.UTF-8
ENV LANG                    ru_RU.UTF-8
ENV LC_ALL                  ru_RU.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Установим поддержку русского языка, часовые пояса, java
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt update -qq && apt upgrade -qqy \
    && apt install -yqq --no-install-recommends \
        ca-certificates \
        locales  \
        language-pack-ru  \
        wget \
        unzip \
        tzdata \
        apt-transport-https \
        iproute2 \
        inetutils-ping \
        net-tools \
        openjdk-11-jre \
    && dpkg-reconfigure --frontend noninteractive tzdata

RUN locale-gen ru_RU.UTF-8 && dpkg-reconfigure locales

# + Установка шрифтов - альтернативный способ
RUN apt-get -qqy install -yqq --no-install-recommends \
        fontconfig \
    && mkdir -p /usr/share/fonts/truetype/msttcorefonts
COPY onec/configs/msttcorefonts /usr/share/fonts/truetype/msttcorefonts
RUN fc-cache –fv
# - Установка шрифтов

# + Установка OSCRIPT
ARG ONESCRIPT_VERSION="1.8.3"
ARG ONESCRIPT_PACKAGES="add 1connector cmdline messenger v8metadata-reader v8storage v8unpack vanessa-runner"

RUN apt-get update -qq && apt-get upgrade -qqy \
    && apt-get install --no-install-recommends -yqq \
      apt-utils \
      gnupg \
      dirmngr \
      build-essential \
      file \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb http://download.mono-project.com/repo/debian stable-buster main" > /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -yqq \
      mono-runtime \
      ca-certificates-mono \
      libmono-i18n4.0-all \
      libmono-system-runtime-serialization4.0-cil

RUN cd /tmp \
    && wget https://github.com/EvilBeaver/OneScript/releases/download/v${ONESCRIPT_VERSION}/onescript-engine_${ONESCRIPT_VERSION}_all.deb \
    && dpkg -i /tmp/onescript-engine_${ONESCRIPT_VERSION}_all.deb \
    && rm -f /tmp/onescript-engine_${ONESCRIPT_VERSION}_all.deb

RUN opm update --all \
    && opm install ${ONESCRIPT_PACKAGES}

RUN apt-get autoremove -yqq --purge \
    && apt-get clean -qq \
    && rm -rf /var/lib/apt/lists/*