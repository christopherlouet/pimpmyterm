#!/usr/bin/env bash

CLEAN_FILES=0
[[ "$1" = "--clean" ]] && CLEAN_FILES=1
CURRENT_FOLDER=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
BAT_VERSION=0.24.0
PACKAGE_NAME="rust-bat_$BAT_VERSION.orig.tar.gz"
TARGET_FOLDER="$CURRENT_FOLDER/bat-$BAT_VERSION"

function head() {
	echo -e "\033[0;32m$*\033[0m"
}

head "install dependancies"
sudo apt update -qq 2> /dev/null && sudo apt install -qy gcc-x86-64-linux-gnu libgit2-1.1 libhttp-parser2.9 \
    libmbedcrypto7 libmbedtls14 libmbedx509-1 libssh2-1

head "install rust/cargo"
curl https://sh.rustup.rs -sSf | sh -s -- -y
source "$HOME/.cargo/env"

head "Download and untar rust-bat package"
wget "http://archive.ubuntu.com/ubuntu/pool/universe/r/rust-bat/$PACKAGE_NAME" \
    -P "$CURRENT_FOLDER" \
    -q --show-progress > /dev/null
tar -zxf "$CURRENT_FOLDER/$PACKAGE_NAME" -C "$CURRENT_FOLDER"

head "Build batcat package"
cargo build --locked --release --target=x86_64-unknown-linux-gnu --manifest-path=$TARGET_FOLDER/Cargo.toml

head "Install batcat"
[[ -f /usr/bin/bat ]] && sudo rm -f /usr/bin/bat
sudo cp -f "$TARGET_FOLDER/target/x86_64-unknown-linux-gnu/release/bat" /usr/bin/bat
[[ -f /usr/local/bin/batcat ]] && sudo rm -f /usr/local/bin/batcat
sudo ln -s /usr/bin/bat /usr/local/bin/batcat

if [[ "$CLEAN_FILES" -eq 1 ]]; then
    head "Clean files"
    rm -rf $CURRENT_FOLDER/$PACKAGE_NAME $TARGET_FOLDER
fi

head "Check version"
[[ "$(command batcat --version | awk '{print $2}')" = "$BAT_VERSION" ]] && echo "batcat $BAT_VERSION is installed"
