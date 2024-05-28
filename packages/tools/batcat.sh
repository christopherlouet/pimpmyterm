#!/usr/bin/env bash
# @name Batcat
# @brief Script to install Batcat.
# @description
#   The library lets you install the latest version of Batcat.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

BATCAT_EXTRAS_URL="https://github.com/eth-p/bat-extras/"

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/tools/batcat.sh" "$*" ; }

# @description Get package information.
# @noargs
# @exitcode 0 If successful.
function package_information() {
    debug "${FUNCNAME[0]}"
    INFO="dist"
    PACKAGE="bat"
    VERSION="0.24.0"
    return 0
}

# @description Display the help.
# @noargs
# @exitcode 0 If successful.
function help() {
    debug "${FUNCNAME[0]}"
    local output=""
    output="
${COLORS[YELLOW]}Usage:\n${COLORS[WHITE]}  ./$(basename -- "$0") [options]
${COLORS[YELLOW]}\nOptions:${COLORS[NOCOLOR]}
  ${COLORS[GREEN]}-i, --install${COLORS[WHITE]}     Installing Batcat
  ${COLORS[GREEN]}-r, --remove${COLORS[WHITE]}      Removing Batcat
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Check if Batcat is installed.
# @noargs
# @exitcode 0 If Batcat is not installed.
# @exitcode 1 If Batcat is already installed.
function check_install() {
    debug "${FUNCNAME[0]}"
    # Batcat is already installed.
    if command -v batcat &> /dev/null; then
        return 1
    fi
    # Batcat is not installed
    return 0
}

# @description Installing Batcat.
# @noargs
# @exitcode 0 If batcat is successfully installed.
# @exitcode 1 If Batcat is already installed.
# @exitcode 2 If can't find the version to install.
# @exitcode 3 If default package manager was not found.
# @exitcode 4 If error updating the apt index.
# @exitcode 5 If there's a package installation error.
# @exitcode 6 If Batcat archive was not found.
# @exitcode 7 If curl is not installed.
# @exitcode 8 If there's a cargo package installation error.
# @exitcode 9 If if Batcat archive url not exists.
# @exitcode 10 if Batcat archive could not be downloaded.
# @exitcode 11 If the archive could not be extracted.
# @exitcode 12 If an error was encountered during build.
# @exitcode 13 If the Batcat binary was not found.
# @exitcode 14 If Batcat not successfully installed.
# @exitcode 15 If unable to find Batcat extras url.
function install() {
    debug "${FUNCNAME[0]}"

    if ! check_install; then
        warning "Batcat is already installed" && return 1
    fi

    if [[ -z $VERSION ]]; then
        die "Can't find the version to install!" && return 2
    fi

    local archive="" archive_url="" target=""
    local batcat_tmp_path="/tmp/bat-$VERSION"

    info "Get the default package manager"
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 3

    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        archive="rust-bat_$VERSION.orig.tar.gz"
        archive_url="http://archive.ubuntu.com/ubuntu/pool/universe/r/rust-bat/$archive"
        target="x86_64-unknown-linux-gnu"
        local install_gcc=0 install_shfmt=0 install_curl=0
        if ! command -v gcc &> /dev/null; then
            install_gcc=1
        fi
        if ! command -v shfmt &> /dev/null; then
            install_shfmt=1
        fi
        if ! command -v curl &> /dev/null; then
            install_curl=1
        fi
        if [[ $((install_gcc+install_shfmt+install_curl)) -gt 0 ]]; then
            if ! package_apt_update; then
                warning "Error updating the apt index"
                return 4
            fi
            if [[ $install_gcc -gt 0 ]]; then
                info "Installing dependencies"
                if ! package_apt_install "gcc"; then
                    warning "Error installing the gcc package" && return 5
                fi
            fi
            if [[ $install_shfmt -gt 0 ]]; then
                if ! package_apt_install "shfmt"; then
                    warning "Error installing the shfmt package" && return 5
                fi
            fi
            if [[ $install_curl -gt 0 ]]; then
                if ! package_apt_install "curl"; then
                    warning "Error installing the curl package" && return 5
                fi
            fi
        fi
    fi

    if [[ -z "$archive" ]]; then
        warning "Batcat archive not found" && return 6
    fi

    if ! command -v curl &> /dev/null; then
        warning "Please install curl" && return 7
    fi

    info "Installation of batcat"
    # Cargo required to continue installation
    info "Installed rust/cargo"
    if ! [[ -f $HOME/.cargo/env ]]; then
        if [[ $SILENT -gt 0 ]]; then
            if ! curl https://sh.rustup.rs -sSf | sh -s -- -y 2>/dev/null 1>/dev/null; then
                warning "Error installing cargo" && return 8
            fi
        else
            if ! curl https://sh.rustup.rs -sSf | sh -s -- -y; then
                warning "Unable to download cargo" && return 8
            fi
        fi
    else
        info "Cargo is already installed"
    fi
    source "$HOME/.cargo/env"

    info "Check if archive url exists"
    if ! check_url "$archive_url"; then
        warning "Unable to find archive url" && return 9
    fi

    info "Download the Batcat package"
    if ! download_file "$archive_url" "/tmp/$archive" "$(display_opts)"; then
        warning "Unable to download Batcat package" && return 10
    fi

    info "Extract the $archive archive"
    [[ -d "$batcat_tmp_path" ]] && rm -rf "$batcat_tmp_path"
    local i=0
    if [[ $SILENT -gt 0 ]]; then
        tar xpf "/tmp/$archive" -C "/tmp" 2>&1
    else
        tar xvpf "/tmp/$archive" -C "/tmp" 2>&1 |
        while read -r line; do
            i=$((i+1))
            echo -en "$i files extracted\r"
        done
        echo ""
    fi
    if ! [[ -d "$batcat_tmp_path" ]]; then
        warning "Error when extracting archive" && return 11
    fi

    info "Build Batcat with Cargo"
    local manifest_path="$batcat_tmp_path/Cargo.toml"
    if [[ $SILENT -gt 0 ]]; then
        if ! cargo build --locked --release --target=$target --manifest-path="$manifest_path" 2>/dev/null 1>/dev/null; then
            warning "Error encountered during build" && return 12
        fi
    else
        if ! cargo build --locked --release --target=$target --manifest-path="$manifest_path"; then
            warning "Error encountered during build" && return 12
        fi
    fi

    if ! [[ -f $batcat_tmp_path/target/$target/release/bat ]]; then
        warning "The Batcat binary was not found" && return 13
    fi

    info "Copy Batcat binary and create symbolic link"
    [[ -f /usr/bin/bat ]] && sudo rm -f /usr/bin/bat
    [[ -f /usr/local/bin/batcat ]] && sudo rm -f /usr/local/bin/batcat
    sudo cp -f "$batcat_tmp_path/target/$target/release/bat" /usr/bin/bat
    sudo ln -s /usr/bin/bat /usr/local/bin/batcat 2> /dev/null

    info "Clean files"
    rm -rf "/tmp/$archive" "$batcat_tmp_path"

    info "Check that installation has been completed successfully"
    if check_install; then
        die "Batcat not successfully installed" && return 14
    fi

    info "Check if Batcat extras package url exists"
    if ! check_url "$BATCAT_EXTRAS_URL"; then
        warning "Unable to find Batcat extras url" && return 15
    fi

    info "Cloning Batcat extras package"
    [[ -d /tmp/bat-extras ]] && sudo rm -rf /tmp/bat-extras
    git clone --depth=1 -q "$BATCAT_EXTRAS_URL" /tmp/bat-extras
    info "Installing Batcat extras package"
    if [[ $SILENT -gt 0 ]]; then
        sudo /tmp/bat-extras/build.sh --install 2>/dev/null 1>/dev/null
    else
        sudo /tmp/bat-extras/build.sh --install 2>/dev/null
    fi

    success "Batcat $VERSION is installed successfully!"
    return 0
}

# @description Removing Batcat.
# @exitcode 0 If Batcat was successfully deleted.
# @exitcode 1 If Batcat is not installed.
# @exitcode 2 If Batcat has not been successfully removed.
function remove() {
    debug "${FUNCNAME[0]}"

    if check_install; then
        warning "Batcat is not installed" && return 1
    fi

    info "Removing Batcat"
    [[ -f /usr/bin/bat ]] && sudo rm -f /usr/bin/bat
    [[ -f /usr/local/bin/batcat ]] && sudo rm -f /usr/local/bin/batcat

    info "Check that Batcat has been removed"
    if ! check_install; then
        warning "Batcat has not been successfully removed" && return 2
    fi

    success "Batcat was successfully deleted!"
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
main "$@"
