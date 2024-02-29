#!/usr/bin/env bash
# @name VSCode
# @brief Script to install VSCode prerequisites.
# @description
#   The library lets you add the VSCode repository.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/tools/code.sh" "$*" ; }

# @description Display the help.
# @noargs
# @exitcode 0 If successful.
function help() {
    debug "${FUNCNAME[0]}"
    local output=""
    output="
${COLORS[YELLOW]}Usage:\n${COLORS[WHITE]}  ./$(basename -- "$0") [options]
${COLORS[YELLOW]}\nOptions:${COLORS[NOCOLOR]}
  ${COLORS[GREEN]}-I, --preinstall${COLORS[WHITE]}     Install VSCode prerequisites
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Installing VSCode prerequisites with apt.
# @noargs
# @exitcode 0 If VSCode prerequisites are successfully installed.
# @exitcode 1 If the VSCode apt repository already exists.
# @exitcode 2 If the PGP public key url was not found.
function pre_install_apt() {
    debug "${FUNCNAME[0]}"

    local pgp_public_key="https://packages.microsoft.com/keys/microsoft.asc" pgp_file="packages.microsoft.gpg"
    local keyring_path="/etc/apt/keyrings" keyring_file="$keyring_path/packages.microsoft.gpg"
    local apt_deb_url="https://packages.microsoft.com/repos/code"
    local apt_source="deb [arch=amd64,arm64,armhf signed-by=$keyring_file] $apt_deb_url stable main"
    local apt_source_file="/etc/apt/sources.list.d/vscode.list"

    info "Check the VSCode repository"
    if grep -rhE ^deb /etc/apt/sources.list*|grep "$apt_deb_url stable main" &> /dev/null ; then
      warning "The VSCode apt repository already exists"
      return 1
    fi

    info "Check if PGP public key url exists"
    if ! check_url "$pgp_public_key"; then
        warning "Unable to find PGP public key url" && return 2
    fi

    info "Adding the VSCode repository"
    sudo mkdir -p $keyring_path
    wget -qO- $pgp_public_key | gpg --dearmor > $pgp_file
    if [[ $SILENT -gt 0 ]]; then
        sudo install -D -o root -g root -m 644 $pgp_file $keyring_file 1>/dev/null
    else
        sudo install -D -o root -g root -m 644 $pgp_file $keyring_file
    fi
    echo "$apt_source" | sudo tee $apt_source_file
    rm -f $pgp_file

    info "Retrieves the latest version of the package list"
    package_apt_update

    success "Prerequisites installed successfully"
    return 0
}

# @description Installing VSCode prerequisites.
# @noargs
# @exitcode 0 If VSCode prerequisites are successfully installed.
# @exitcode 1 If default package manager was not found.
# @exitcode 2 If an error occurred during installation of VSCode prerequisites.
function pre_install() {
    debug "${FUNCNAME[0]}"

    # Determine the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1

    # Proceed to preinstall
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        ! pre_install_apt && return 2
    fi

    success "Prerequisites installed successfully"
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
main "$@"
