#!/usr/bin/env bash
# @name oh-my-tmux
# @brief Script to install oh-my-tmux.
# @description
#   The library lets you install the tmux theme from Gregory Pakosz.

CURRENT_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

OHMYTMUX_CUSTOM_INSTALL=1
OHMYTMUX_CUSTOM_CONF="$CURRENT_PATH/conf/oh-my-tmux/tmux.conf.local"

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/editor/oh-my-tmux.sh" "$*" ; }

# @description Get package information.
# @noargs
# @exitcode 0 If successful.
function package_information() {
    debug "${FUNCNAME[0]}"
    VERSION=1.0.0
    MAINTAINER="Gregory Pakosz"
    DESCRIPTION="Self-contained, pretty and versatile .tmux.conf configuration file."
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
  ${COLORS[GREEN]}-i, --install${COLORS[WHITE]}     Installing oh-my-tmux
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Check if oh-my-tmux is installed.
# @noargs
# @exitcode 0 If oh-my-tmux is not installed.
# @exitcode 1 If oh-my-tmux is already installed.
function check_install() {
    debug "${BASH_SOURCE[0]}" "${FUNCNAME[0]}"
    [[ -f "$HOME/.tmux.conf.local" ]] && return 1
    return 0
}

# @description Installing the tmux theme from Gregory Pakosz.
# @noargs
# @set OHMYTMUX_CUSTOM_INSTALL integer Customized installation.
# @set OHMYTMUX_CUSTOM_CONF string Custom configuration file path.
# @set DEFAULT_PACKAGE_MANAGER string Distribution package manager.
# @exitcode 0 If oh-my-tmux is successfully installed.
# @exitcode 1 If oh-my-tmux is already installed.
# @exitcode 2 If tmux is not installed.
# @exitcode 3 If default package manager was not found.
# @exitcode 4 If there's a xsel package installation error.
# @exitcode 5 If unable to find project url.
# @exitcode 6 If configuration file not found.
function install() {
    debug "${BASH_SOURCE[0]}" "${FUNCNAME[0]}"
    local config_path=""
    local project_url="https://github.com/gpakosz/.tmux.git"
    local conf_tmux_path="$HOME/.tmux"
    local conf_tmux_local="$HOME/.tmux.conf.local"
    local config_path=""

    if ! check_install; then
        warning "oh-my-tmux is already installed"
        return 1
    fi

    # Check if tmux is installed
    if ! command -v tmux &> /dev/null; then
        info "tmux is not installed" && return 1
        return 2
    fi

    if ! command -v xsel &> /dev/null; then
        info "Installing xsel To copy the selection to the operating system clipboard"
        [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
        [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 3
        if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
            if ! package_apt_install "xsel"; then
                warning "Error installing the xsel package" && return 4
            fi
        fi
    fi

    if ! check_url "$project_url"; then
        warning "Unable to find project url" && return 5
    fi

    info "Backup the current tmux configuration files"
    [[ -d "$conf_tmux_path" ]] && mv "$conf_tmux_path" "$conf_tmux_path.$(date '+%Y%m%d%H%M%S').bak"
    [[ -f "$conf_tmux_local" ]] && mv "$conf_tmux_local" "$conf_tmux_local.$(date '+%Y%m%d%H%M%S').bak"

    info "Clone the project and copy config files"
    git clone --depth=1 -q "$project_url" "$conf_tmux_path"
    ln -sf "$conf_tmux_path/.tmux.conf" "$HOME/.tmux.conf"

    if [[ $OHMYTMUX_CUSTOM_INSTALL -gt 0 ]]; then
        info "Copy custom configuration file"
        if ! [[ -f "$OHMYTMUX_CUSTOM_CONF" ]]; then
            warning "Custom config file $OHMYTMUX_CUSTOM_CONF not found!"
            return 6
        fi
        cp "$OHMYTMUX_CUSTOM_CONF" "$conf_tmux_local"
    else
        cp "$conf_tmux_path/.tmux.conf.local" "$conf_tmux_local"
    fi

    success "Installed successfully"
    return 0
}

# @description Removing the tmux theme from Gregory Pakosz.
# @exitcode 0 If oh-my-tmux was successfully deleted.
# @exitcode 1 If oh-my-tmux is not installed.
# @exitcode 2 If oh-my-tmux has not been successfully removed.
function remove() {
    debug "${FUNCNAME[0]}"
    local conf_tmux_local="$HOME/.tmux.conf.local"

    if check_install; then
        warning "oh-my-tmux is not installed" && return 1
    fi

    info "Removing oh-my-tmux"
    [[ -f $conf_tmux_local ]] && sudo rm -f "$conf_tmux_local"

    info "Check that oh-my-tmux has been removed"
    if ! check_install; then
        warning "oh-my-tmux has not been successfully removed" && return 2
    fi

    success "oh-my-tmux was successfully deleted!"
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
main "$@"
