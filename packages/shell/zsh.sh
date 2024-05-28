#!/usr/bin/env bash
# @name zsh
# @brief Script to install zsh.
# @description
#   The library lets you install zsh without user interaction.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

ZSH_CONF="$HOME/.zshrc"

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/shell/zsh.sh" "$*" ; }

# @description Get package information.
# @noargs
# @exitcode 0 If successful.
function package_information() {
    debug "${FUNCNAME[0]}"
    INFO="dist"
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
  ${COLORS[GREEN]}-i, --install${COLORS[WHITE]}     Installing zsh
  ${COLORS[GREEN]}-r, --remove${COLORS[WHITE]}      Removing zsh
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Check if zsh is installed.
# @noargs
# @exitcode 0 If zsh is not installed.
# @exitcode 1 If zsh is already installed.
function check_install() {
    if which zsh 1> /dev/null; then
        warning "zsh is already installed"
        return 1
    fi
    return 0
}

# @description Installing zsh with apt.
# @noargs
# @exitcode 0 If zsh is successfully installed.
# @exitcode 1 If error updating the apt index.
# @exitcode 2 If zsh was not installed correctly.
function install_apt() {
    debug "${FUNCNAME[0]}"

    info_no_newline "Updating the apt index"
    if ! package_apt_update; then
        die_line_break "Error updating the apt index"
        return 1
    fi
    info_success "Updating the apt index"

    info_no_newline "Proceed with the installation"
    if [[ $SILENT -gt 0 ]]; then
        sudo DEBIAN_FRONTEND=noninteractive apt -qqy  install zsh 2>/dev/null 1>/dev/null

    else
        sudo DEBIAN_FRONTEND=noninteractive apt -qqy install zsh
    fi
    info_success "Proceed with the installation"

    info_no_newline "Check if zsh was installed correctly"
    if check_install; then
        die_line_break "zsh was not installed correctly"
        return 2
    fi
    info_success "Check if zsh was installed correctly"

    return 0
}

# @description Removing zsh with apt.
# @noargs
# @exitcode 0 If zsh is successfully removed.
# @exitcode 1 If an error was encountered when deleting zsh.
# @exitcode 2 If the zsh configuration file could not be saved.
# @exitcode 3 If zsh was not removed correctly.
function remove_apt() {
    debug "${FUNCNAME[0]}"

    info_no_newline "Delete zsh"
    if ! package_apt_remove "zsh"; then
        warning_line_break "Error when deleting zsh"
        return 1
    fi
    info_success "Delete zsh"

    info_no_newline "Backup and remove .zshrc file"
    if [[ -f "$ZSH_CONF" ]]; then
        if ! mv "$ZSH_CONF" "$ZSH_CONF.$(date '+%Y%m%d%H%M%S').bak"; then
            warning_line_break "Error copying $ZSH_CONF file"
            return 2
        fi
    fi
    info_success "Backup and remove .zshrc file"

    info_no_newline "Changing the Default Shell"
    sudo usermod --shell /usr/bin/bash "$USER" 1>/dev/null
    info_success "Changing the Default Shell"

    if ! check_install; then
        die "zsh was not removed correctly"
        return 3
    fi

    return 0
}

# @description Installing zsh.
# @noargs
# @exitcode 0 If zsh is successfully installed.
# @exitcode 1 If zsh is already installed.
# @exitcode 2 If default package manager was not found.
# @exitcode 3 If errors were encountered during zsh installation.
function install() {
    debug "${FUNCNAME[0]}"
    # Check if the installation has already been done
    ! check_install && return 1
    # Determine the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 2
    # Proceed to install
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        ! install_apt && return 3
    fi

    info_no_newline "Changing the Default Shell"
    sudo usermod --shell /usr/bin/zsh "$USER" 1>/dev/null
    info_success "Changing the Default Shell"

    success "zsh is installed successfully!"
    info "Restarting a user session to configure the shell and generate the .zshrc file."
    return 0
}

# @description Removing zsh.
# @noargs
# @exitcode 0 If zsh is successfully removed.
# @exitcode 1 If zsh is already installed.
# @exitcode 2 If default package manager was not found.
# @exitcode 3 If errors were encountered when deleting zsh.
function remove() {
    debug "${FUNCNAME[0]}"
    # Check if the installation has already been done
    check_install && return 1
    # Determine the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 2
    # Proceed to remove
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        ! remove_apt && return 3
    fi
    success "zsh is removed successfully!"
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
main "$@"
