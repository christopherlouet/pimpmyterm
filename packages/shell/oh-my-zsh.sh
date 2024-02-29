#!/usr/bin/env bash
# @name oh-my-zsh
# @brief Script to install oh-my-zsh.
# @description
#   The library lets you install oh-my-zsh.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

OH_MY_ZSH_PROJECT_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
OH_MY_ZSH_CONF_LOCAL="$HOME/.oh-my-zsh"
OH_MY_ZSH_CONF_ZSH="$HOME/.zshrc"
OH_MY_ZSH_CONF_ZSH_ORIGIN="$HOME/.zshrc.origin"

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/shell/oh-my-zsh.sh" "$*" ; }

# @description Get package information.
# @noargs
# @exitcode 0 If successful.
function package_information() {
    debug "${FUNCNAME[0]}"
    VERSION=1.0.0
    MAINTAINER="oh-my-zsh"
    DESCRIPTION="A delightful community-driven framework for managing your zsh configuration."
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
  ${COLORS[GREEN]}-i, --install${COLORS[WHITE]}     Installing oh-my-zsh
  ${COLORS[GREEN]}-r, --remove${COLORS[WHITE]}      Removing oh-my-zsh
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Check if oh-my-zsh is installed.
# @noargs
# @exitcode 0 If oh-my-zsh is not installed.
# @exitcode 1 If oh-my-zsh is already installed.
function check_install() {
    debug "${FUNCNAME[0]}"
    if [[ -f "$OH_MY_ZSH_CONF_ZSH" ]]; then
        warning "oh-my-zsh is already installed"
        return 1
    fi
    return 0
}

# @description Installing oh-my-zsh.
# @noargs
# @exitcode 0 If oh-my-zsh is successfully installed or already installed.
# @exitcode 1 If oh-my-zsh is already installed.
# @exitcode 2 If oh-my-zsh url was not found.
# @exitcode 3 If curl was not found.
# @exitcode 4 If the .zshrc file cannot be saved.
# @exitcode 5 If an error was encountered during oh-my-zsh installation.
function install() {
    debug "${FUNCNAME[0]}"

    # Check if the installation has already been done
    ! check_install && return 1

    info_no_newline "Check if oh-my-zsh url exists"
    if ! check_url "$OH_MY_ZSH_PROJECT_URL"; then
        warning_line_break "Unable to find oh-my-zsh url" && return 2
    fi
    info_success "Check if oh-my-zsh url exists"

    if ! command -v curl &> /dev/null; then
        warning "Please install curl"
        return 3
    fi

    info_no_newline "Backup the current .zshrc file"
    if [[ -f "$OH_MY_ZSH_CONF_ZSH" ]]; then
        if ! cp "$OH_MY_ZSH_CONF_ZSH" "$OH_MY_ZSH_CONF_ZSH_ORIGIN"; then
            warning_line_break "Error copying $OH_MY_ZSH_CONF_ZSH file"
            return 4
        fi
    fi
    info_success "Backup the current .zshrc file"

    info "Proceed to oh-my-zsh installation"
    if [[ $SILENT -gt 0 ]]; then
        if ! sh -c "$(curl -fsSL $OH_MY_ZSH_PROJECT_URL)" "" --unattended 1> /dev/null 2>&1; then
            return 5
        fi
    else
        if ! sh -c "$(curl -fsSL $OH_MY_ZSH_PROJECT_URL)" "" --unattended; then
            return 5
        fi
    fi

    success "oh-my-zsh is installed successfully!"
    return 0
}

# @description Removing oh-my-zsh.
# @noargs
# @exitcode 0 If oh-my-zsh is successfully removed.
# @exitcode 1 If oh-my-zsh is not installed.
# @exitcode 2 If the .oh-my-zsh folder cannot be saved.
# @exitcode 3 If the .zshrc file cannot be saved.
# @exitcode 4 If the origin .zshrc file cannot be copied.
function remove() {
    debug "${FUNCNAME[0]}"

    # Check if the installation has already been done
    check_install && return 1

    info_no_newline "Backup and remove .oh-my-zsh folder"
    if [[ -d "$OH_MY_ZSH_CONF_LOCAL" ]]; then
        if ! mv "$OH_MY_ZSH_CONF_LOCAL" "$OH_MY_ZSH_CONF_LOCAL.$(date '+%Y%m%d%H%M%S').bak"; then
            warning_line_break "Error copying $OH_MY_ZSH_CONF_LOCAL folder"
            return 2
        fi
    fi
    info_success "Backup and remove .oh-my-zsh folder"

    info_no_newline "Backup and remove .zshrc file"
    if [[ -f "$OH_MY_ZSH_CONF_ZSH" ]]; then
        if ! mv "$OH_MY_ZSH_CONF_ZSH" "$OH_MY_ZSH_CONF_ZSH.$(date '+%Y%m%d%H%M%S').bak"; then
            warning_line_break "Error copying $OH_MY_ZSH_CONF_ZSH file"
            return 3
        fi
    fi
    info_success "Backup and remove .zshrc file"

    info_no_newline "Copy the original .zshrc file, if the file exists"
    if [[ -f "$OH_MY_ZSH_CONF_ZSH_ORIGIN" ]]; then
        if ! cp "$OH_MY_ZSH_CONF_ZSH_ORIGIN" "$OH_MY_ZSH_CONF_ZSH"; then
            warning_line_break "Error copying $OH_MY_ZSH_CONF_ZSH_ORIGIN file"
            return 4
        fi
    fi
    info_success "Copy the .zshrc file, if the original file exists"

    success "oh-my-zsh is removed successfully!"
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
main "$@"
