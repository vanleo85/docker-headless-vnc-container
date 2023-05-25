#!/bin/bash
set -e

ONESCRIPT_VERSION=$1
ONESCRIPT_PACKAGES=$2

apt-get install -qqy \
    dirmngr  \
    ca-certificates \
    gnupg

gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list
apt update

apt install -qqy \
    mono-runtime \
    ca-certificates-mono \
    libmono-i18n4.0-all \
    libmono-i18n-cjk4.0-cil \
    libmono-i18n-mideast4.0-cil \
    libmono-i18n-other4.0-cil \
    libmono-i18n-rare4.0-cil

wget -O /tmp/onescript-engine-all.deb https://github.com/EvilBeaver/OneScript/releases/download/v"$ONESCRIPT_VERSION"/onescript-engine_"$ONESCRIPT_VERSION"_all.deb
dpkg -i /tmp/onescript-engine-all.deb
rm -f /tmp/onescript-engine-all.deb
opm update --all
opm install "$ONESCRIPT_PACKAGES"