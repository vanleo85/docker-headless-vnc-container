#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Chromium Gost"
wget -O chromium-gost.deb https://github.com/deemru/Chromium-Gost/releases/download/130.0.6723.58/chromium-gost-130.0.6723.58-linux-amd64.deb
apt install -qqy ./chromium-gost.deb

last_row=$(tail -n 1 /opt/chromium-gost/chromium-gost)
head -n -1 /opt/chromium-gost/chromium-gost > chromium-gost-temp
mv chromium-gost-temp /opt/chromium-gost/chromium-gost
echo "$last_row --no-sandbox --no-default-browser-check --no-first-run" >> /opt/chromium-gost/chromium-gost
chmod +x /opt/chromium-gost/chromium-gost
rm ./chromium-gost.deb
apt-get clean -y





