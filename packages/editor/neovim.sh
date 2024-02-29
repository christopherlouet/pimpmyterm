#!/usr/bin/env bash
# @name Neovim
# @brief Script to install Neovim prerequisites.
# @description
#   The library lets you add the Neovim repository.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/tools/neovim.sh" "$*" ; }

# @description Display the help.
# @noargs
# @exitcode 0 If successful.
function help() {
    debug "${FUNCNAME[0]}"
    local output=""
    output="
${COLORS[YELLOW]}Usage:\n${COLORS[WHITE]}  ./$(basename -- "$0") [options]
${COLORS[YELLOW]}\nOptions:${COLORS[NOCOLOR]}
  ${COLORS[GREEN]}-I, --preinstall${COLORS[WHITE]}     Install Neovim prerequisites
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Installing Neovim prerequisites with apt.
# @noargs
# @exitcode 0 If Neovim prerequisites are successfully installed.
# @exitcode 1 The neovim PPA already exists.
function pre_install_apt() {
    debug "${BASH_SOURCE[0]}" "${FUNCNAME[0]}"
    local ppa="neovim-ppa/unstable"

    info "Check the Neovim PPA"
    if grep -rhE ^deb /etc/apt/sources.list*|grep "$ppa" &> /dev/null ; then
      warning "The Neovim PPA already exists"
      return 1
    fi

    info "Added unstable repository to get the latest version of Neovim"
    if [[ $SILENT -gt 0 ]]; then
        sudo add-apt-repository ppa:$ppa -y 1>/dev/null
    else
        sudo add-apt-repository ppa:$ppa -y
    fi

    success "Prerequisites installed successfully"
    return 0
}

# @description Installing Neovim prerequisites.
# @noargs
# @exitcode 0 If Neovim prerequisites are successfully installed.
# @exitcode 1 If default package manager was not found.
# @exitcode 2 If an error occurred during installation of Neovim prerequisites.
function pre_install() {
    debug "${BASH_SOURCE[0]}" "${FUNCNAME[0]}"
    # Determine the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1
    # Proceed to preinstall
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        pre_install_apt && return 2
    fi
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
main "$@"
