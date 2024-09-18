#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Google Chrome"
#apt update
#apt install software-properties-common apt-transport-https ca-certificates curl -y
#curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
#echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | tee /etc/apt/sources.list.d/google-chrome.list
#apt update
#apt install google-chrome-stable -y


wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
#ln -sfn /usr/bin/chromium /usr/bin/chromium-browser
#apt-get clean -y