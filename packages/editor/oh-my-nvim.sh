#!/usr/bin/env bash
# @name oh-my-nvim
# @brief Script to install oh-my-nvim.
# @description
#   The library lets you install the neovim theme from hardhackerlabs.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

OHMYNEOVIM_README="$HOME/.config/nvim/README.md"

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/editor/oh-my-nvim.sh" "$*" ; }

# @description Get package information.
# @noargs
# @exitcode 0 If successful.
function package_information() {
    debug "${FUNCNAME[0]}"
    VERSION=1.0.0
    MAINTAINER="hardhackerlabs"
    DESCRIPTION="A theme-driven, out-of-the-box modern configuration of neovim."
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
  ${COLORS[GREEN]}-i, --install${COLORS[WHITE]}     Installing oh-my-nvim
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Check if oh-my-nvim is installed.
# @noargs
# @exitcode 0 If oh-my-nvim is not installed.
# @exitcode 1 If oh-my-nvim is already installed.
function check_install() {
    debug "${FUNCNAME[0]}"
    # If the README not exist, oh-my-nvim is not installed
    if ! [[ -f $OHMYNEOVIM_README ]]; then
        return 0
    fi
    # Check author in the readme file
    if grep -i "$MAINTAINER" "$HOME/.config/nvim/README.md" 1>/dev/null; then
        return 1
    fi
    return 0
}

# @description Installing the neovim theme from hardhackerlabs.
# @noargs
# @exitcode 0 If oh-my-nvim is successfully installed.
# @exitcode 1 If oh-my-nvim is already installed.
# @exitcode 2 If Neovim is not installed.
# @exitcode 3 If unable to find project url.
function install() {
    debug "${FUNCNAME[0]}"

    local install_path="$HOME/.config/nvim"
    local share_path="$HOME/.local/share/nvim"
    local project_url="https://github.com/hardhackerlabs/oh-my-nvim.git"

    if ! check_install; then
        warning "oh-my-nvim is already installed" && return 1
    fi

    info "Check if Neovim is installed"
    if ! command -v nvim &> /dev/null; then
        warning "Neovim is not installed" && return 2
    fi

    info "Backup the current Neovim configuration files"
    [[ -d "$install_path" ]] && mv "$install_path" "$install_path.$(date '+%Y%m%d%H%M%S').bak"
    [[ -d "$share_path" ]] && mv "$share_path" "$share_path.$(date '+%Y%m%d%H%M%S').bak"

    if ! check_url "$project_url"; then
        warning "Unable to find project url" && return 3
    fi

    info "Clone the project in the  $install_path folder"
    git clone --depth=1 -q "$project_url" "$install_path"

    success "Installed successfully"
    info "Run nvim once to install plugins"
    return 0
}

# @description Removing the neovim theme from hardhackerlabs.
# @exitcode 0 If oh-my-nvim was successfully deleted.
# @exitcode 1 If oh-my-nvim is not installed.
# @exitcode 2 If oh-my-nvim has not been successfully removed.
function remove() {
    debug "${FUNCNAME[0]}"
    local install_path="$HOME/.config/nvim"

    if check_install; then
        warning "oh-my-nvim is not installed" && return 1
    fi

    info "Removing oh-my-nvim"
    [[ -d $install_path ]] && sudo rm -rf "$install_path"

    info "Check that oh-my-nvim has been removed"
    if ! check_install; then
        warning "oh-my-nvim has not been successfully removed" && return 2
    fi

    success "oh-my-nvim was successfully deleted!"
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
main "$@"
