#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb -y

last_row=$(tail -n 1 /opt/google/chrome/google-chrome)
head -n -1 /opt/google/chrome/google-chrome > google-chrome-temp
mv google-chrome-temp /opt/google/chrome/google-chrome
echo "$last_row --no-sandbox" >> /opt/google/chrome/google-chrome
chmod +x /opt/google/chrome/google-chrome
rm google-chrome-stable_current_amd64.deb
