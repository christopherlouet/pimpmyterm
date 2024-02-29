#!/usr/bin/env bash
# @name Eza
# @brief Script to install Eza prerequisites.
# @description
#   The library lets you add the Gierens repository to install Eza.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/tools/eza.sh" "$*" ; }

# @description Display the help.
# @noargs
# @exitcode 0 If successful.
function help() {
    debug "${FUNCNAME[0]}"
    local output=""
    output="
${COLORS[YELLOW]}Usage:\n${COLORS[WHITE]}  ./$(basename -- "$0") [options]
${COLORS[YELLOW]}\nOptions:${COLORS[NOCOLOR]}
  ${COLORS[GREEN]}-I, --preinstall${COLORS[WHITE]}     Install Eza prerequisites
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Installing Eza prerequisites with apt.
# @noargs
# @exitcode 0 If Eza prerequisites are successfully installed.
# @exitcode 1 If the Gierens apt repository already exists.
# @exitcode 2 If the pgp public key url was not found.
# @exitcode 3 If error updating the apt index.
function pre_install_apt() {
    debug "${FUNCNAME[0]}"

    local pgp_public_key="https://raw.githubusercontent.com/eza-community/eza/main/deb.asc"
    local keyring_path="/etc/apt/keyrings"
    local keyring_file="$keyring_path/gierens.gpg"
    local apt_deb_url="http://deb.gierens.de"
    local apt_source="deb [signed-by=/etc/apt/keyrings/gierens.gpg] $apt_deb_url stable main"
    local apt_source_file="/etc/apt/sources.list.d/gierens.list"

    info "Check the Gierens repository"
    if grep -rhE ^deb /etc/apt/sources.list*|grep "$apt_deb_url stable main" &> /dev/null ; then
      warning "The Gierens apt repository already exists"
      return 1
    fi

    info "Check if PGP public key url exists"
    if ! check_url "$pgp_public_key"; then
        warning "Unable to find PGP public key url" && return 2
    fi

    info "Adding the Gierens repository"
    sudo mkdir -p $keyring_path

    wget -qO- $pgp_public_key | sudo gpg --dearmor -o $keyring_file 1>/dev/null
    echo "$apt_source" | sudo tee $apt_source_file 1>/dev/null
    sudo chmod 644 $keyring_file $apt_source_file

    info "Retrieves the latest version of the package list"
    if ! package_apt_update; then
        warning "Error updating the apt index"
        return 3
    fi

    return 0
}

# @description Installing Eza prerequisites.
# @noargs
# @exitcode 0 If Eza prerequisites are successfully installed.
# @exitcode 1 If default package manager was not found.
# @exitcode 2 If an error occurred during installation of Eza prerequisites.
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
