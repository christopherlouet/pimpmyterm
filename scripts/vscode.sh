#!/usr/bin/env bash

function head() {
	echo -e "\033[0;32m$*\033[0m"
}

head "install the apt repository"
sudo apt update -qq 2> /dev/null && sudo apt install -qy wget gpg && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    rm -f packages.microsoft.gpg

head "install vscode"
sudo apt install -qy apt-transport-https && \
    sudo apt update -qq 2> /dev/null && \
    sudo apt install -qy code
