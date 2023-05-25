FROM onec-base:latest

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION="8.3.20.2180"
ARG NH_SERVER_ADDR
ARG NH_PORT_NUMBER

ENV ONEC_VERSION=$ONEC_VERSION
ENV INSTALLER_TYPE=all

EXPOSE 5900

ENV DISPLAY=:0
ENV DISPLAY_WIDTH=1440
ENV DISPLAY_HEIGHT=900

ENV VIDEO_RECORDING=false
ENV VIDEO_FILENAME=''
ENV VIDEO_DIRPATH=''

ENV DBGS=false
ENV CVRG=false

ENV S6_STAGE2_HOOK="/etc/s6-overlay/scripts/CustomizeDaemonSet.sh"

#SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /tmp

# Установка 1С
COPY ./onec/scripts/download-onec-packages.sh /download-onec-packages.sh

COPY ./onec/dist/ downloads/platform83/${ONEC_VERSION}/
RUN rm downloads/platform83/${ONEC_VERSION}/.gitkeep \
  && rm -rf downloads/platform83/${ONEC_VERSION}/thin.client*.tar.gz \
  && rm -rf downloads/platform83/${ONEC_VERSION}/1c_edt*.tar.gz \
  && if [ -z "$(ls -A downloads/platform83/${ONEC_VERSION})" ] ; then \
      chmod +x /download-onec-packages.sh \
      && /download-onec-packages.sh $ONEC_USERNAME $ONEC_PASSWORD; \
    fi \
  && rm -rf downloads/platform83/${ONEC_VERSION}/*thin*.tar.gz \
  && for file in downloads/platform83/${ONEC_VERSION}/*.tar.gz; do tar -xzvf "$file"; done \
  && rm -rf *thin*.deb \
  && rm /download-onec-packages.sh

# До 8.3.20 требуется установить libwebkitgtk-3.0-0, иначе - библиотеки по списку
COPY ./onec/scripts/install-additional-libs-for-1c.sh /install-additional-libs-for-1c.sh
RUN chmod +x /install-additional-libs-for-1c.sh \
    && /install-additional-libs-for-1c.sh \
    && rm /install-additional-libs-for-1c.sh

# Установка платформы 1С
COPY ./onec/scripts/install-onec-packages.sh /install-onec-packages.sh
RUN chmod +x /install-onec-packages.sh \
  && /install-onec-packages.sh \
  && rm /install-onec-packages.sh \
  && rm -rf /tmp/*

COPY ./onec/scripts/create-symlink-to-current-1cv8.sh /create-symlink-to-current-1cv8.sh
RUN chmod +x /create-symlink-to-current-1cv8.sh \
  && /create-symlink-to-current-1cv8.sh \
  && rm /create-symlink-to-current-1cv8.sh

COPY ./onec/configs/client/conf /opt/1cv8/current/conf
RUN sed -i "s/NH_SERVER_ADDR =/NH_SERVER_ADDR = $NH_SERVER_ADDR/g" "/opt/1cv8/current/conf/nethasp.ini" \
    && sed -i "s/NH_PORT_NUMBER =/NH_PORT_NUMBER = $NH_PORT_NUMBER/g" "/opt/1cv8/current/conf/nethasp.ini"

RUN echo 'DisableUnsafeActionProtection=.*' >> /opt/1cv8/conf/conf.cfg

# x11
RUN apt update \
    && apt install -qqy --no-install-recommends \
      dbus-x11 \
      psmisc \
      xdg-utils \
      x11-xserver-utils \
      x11-utils \
      xvfb \
      xfce4 \
      xfce4-goodies \
      dirmngr \
      gnupg \
      libgtk2.0-0 \
      libtcmalloc-minimal4 \
      at-spi2-core \
      procps \
      x11vnc \
      elementary-xfce-icon-theme \
      adwaita-icon-theme-full \
      git

# coverage
ARG COVERAGE_VERSION=2.7.2
ARG EDT_VERSION=2022.2.5
ENV EDT_LOCATION="/EDTCoverageLibs"

COPY ./onec/configs/EDTCoverageLibs/${EDT_VERSION}/* /${EDT_LOCATION}/
RUN wget -q -O Coverage41C.tar https://github.com/1c-syntax/Coverage41C/releases/download/v${COVERAGE_VERSION}/Coverage41C-${COVERAGE_VERSION}.tar \
    && tar -xf /tmp/Coverage41C.tar \
    && mkdir /Coverage41C \
    && cp -r /tmp/Coverage41C*/* /Coverage41C/ \
    && rm -r /tmp/* \
    && ln -s /Coverage41C/bin/Coverage41C /usr/bin/Coverage41C

# websockify and novnc

RUN \
    apt-get install python3 python3-setuptools -y

RUN \
    wget https://github.com/novnc/websockify/archive/refs/tags/v0.11.0.tar.gz -O websockify.tar.gz \
    && mkdir websockify \
    && tar xfz websockify.tar.gz -C websockify --strip 1

RUN \
    wget https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz -O novnc.tar.gz \
    && mkdir novnc \
    && tar xfz novnc.tar.gz -C novnc --strip 1 \
    && ln -s /tmp/novnc/vnc.html /tmp/novnc/index.html 

# s6 overlay
ARG S6_OVERLAY_VERSION=3.1.5.0

RUN apt-get install -yqq \
    xz-utils
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

#COPY /onec/configs/etc /etc/
#RUN rm -rf /etc/fix-attrs.d
#RUN \
#   chmod 755 /etc/services.d -R
#COPY /onec/configs/xorg.conf /usr/share/X11/xorg.conf.d/10-dummy.conf

COPY ./onec/configs/s6-overlay-v3/s6-rc.d /etc/s6-overlay/s6-rc.d
COPY ./onec/configs/s6-overlay-v3/scripts /etc/s6-overlay/scripts
COPY ./onec/configs/s6-overlay-v3/user/contents.d /etc/s6-overlay/s6-rc.d/user/contents.d
RUN chmod 755 /etc/s6-overlay -R
COPY /onec/configs/xorg.conf /usr/share/X11/xorg.conf.d/10-dummy.conf

RUN \
  apt-get -qq autoremove \
  && apt-get -qq autoclean \
  && apt-get -qq clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/* \
  && rm -rf /usr/share/locale/* \
  && rm -rf /usr/share/man/* \
  && rm -rf /usr/share/doc/*

WORKDIR /

ENTRYPOINT ["/init"]


