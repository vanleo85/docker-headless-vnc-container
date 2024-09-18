#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb -y

last_row=$(tail -n 1 /usr/bin/google-chrome)
head -n -1 /usr/bin/google-chrome > google-chrome-temp
mv google-chrome-temp /usr/bin/google-chrome
echo "$last_row --no-sandbox" >> /usr/bin/google-chrome
rm google-chrome-stable_current_amd64.deb
