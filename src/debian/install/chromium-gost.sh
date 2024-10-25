#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Chromium Gost"
wget -O chromium-gost.deb https://github.com/deemru/Chromium-Gost/releases/download/130.0.6723.58/chromium-gost-130.0.6723.58-linux-amd64.deb
dpkg -i chromium-gost.deb
apt-get clean -y





