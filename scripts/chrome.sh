#!/bin/sh

sudo bash -c 'cat << EOF > /etc/yum.repos.d/google-chrome.repo1
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF'

# sudo dnf install google-chrome-stable -y
