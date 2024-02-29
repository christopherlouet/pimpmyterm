#!/usr/bin/env bash
# @name PimpMyTerm
# @brief Script to install a customized terminal and shell configuration.
# @description
#   This library can be used to install the following packages:
#       * Meslo Nerd fonts
#       * Catppuccin Mocha gnome theme
#       * zsh and oh-my-zsh plugins and theme
#       * tmux and themes
#       * neovim and themes
#       * VSCode
#       * fzf, fd-find, Batcat and Eza

CURRENT_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
PACKAGES_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../packages" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

PMT_NERD_FONTS_SCRIPT="$PACKAGES_PATH/ui/nerd-fonts.sh"
PMT_GNOME_THEME_SCRIPT="$PACKAGES_PATH/ui/gnome-theme.sh"
PMT_BATCAT_SCRIPT="$PACKAGES_PATH/tools/batcat.sh"
PMT_EZA_SCRIPT="$PACKAGES_PATH/tools/eza.sh"
PMT_ZSH_SCRIPT="$PACKAGES_PATH/shell/zsh.sh"
PMT_OHMYZSH_SCRIPT="$PACKAGES_PATH/shell/oh-my-zsh.sh"
PMT_OHMYTMUX_SCRIPT="$PACKAGES_PATH/multiplexer/oh-my-tmux.sh"
PMT_NEOVIM_SCRIPT="$PACKAGES_PATH/editor/neovim.sh"
PMT_OHMYNEOVIM_SCRIPT="$PACKAGES_PATH/editor/oh-my-nvim.sh"
PMT_VSCODE_SCRIPT="$PACKAGES_PATH/editor/code.sh"

PMT_ZSH_CONF_PATH="$HOME/.zshrc"
PMT_OHMYZSH_CONF_PATH="$HOME/.oh-my-zsh"
PMT_POWERLEVEL10K_URL="https://github.com/romkatv/powerlevel10k.git"
PMT_ZSH_AUTOSUGGESTIONS_URL="https://github.com/zsh-users/zsh-autosuggestions.git"
PMT_ZSH_SYNTAX_HIGHLIGHTING_URL="https://github.com/zsh-users/zsh-syntax-highlighting.git"
PMT_ZSH_EXTRA_PLUGINS=(emoji git fd fzf tmux web-search)

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/custom/pimpmyterm.sh" "$*" ; }

# @description Get package information.
# @noargs
# @exitcode 0 If successful.
function package_information() {
    debug "${FUNCNAME[0]}"
    VERSION=1.0.0
    MAINTAINER="Christopher LOUËT"
    DESCRIPTION="A script to install a customized terminal and shell configuration"
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
  ${COLORS[GREEN]}-i, --install${COLORS[WHITE]}     Installing customized terminal PimpMyTerm
  ${COLORS[GREEN]}-r, --remove${COLORS[WHITE]}      Removing customized terminal PimpMyTerm
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Installing MesloLGS Nerd font.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the package script does not exist.
# @exitcode 2 If an error was encountered during installation.
function install_nerd_fonts() {
    debug "${FUNCNAME[0]}"
    info "Installing nerd-fonts"
    # Check if the script exists
    if ! [[ -f $PMT_NERD_FONTS_SCRIPT ]]; then
        warning "$PMT_NERD_FONTS_SCRIPT not exists"
        return 1
    fi
    # Installing nerd fond
    if [[ $SILENT -gt 0 ]]; then
        bash "$PMT_NERD_FONTS_SCRIPT" --install --theme="$THEME" --silent
    else
        bash "$PMT_NERD_FONTS_SCRIPT" --install --theme="$THEME"
    fi
    [[ $? -gt 1 ]] && return 2
    return 0
}

# @description Installing Catppuccin Mocha gnome theme.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the package script does not exist.
# @exitcode 2 If an error was encountered during installation.
function install_gnome_theme() {
    debug "${FUNCNAME[0]}"
    info "Installing gnome-theme"
    # Check if the script exists
    if ! [[ -f $PMT_GNOME_THEME_SCRIPT ]]; then
        warning "$PMT_GNOME_THEME_SCRIPT not exists"
        return 1
    fi
    # Installing the gnome theme
    if [[ $SILENT -gt 0 ]]; then
        bash "$PMT_GNOME_THEME_SCRIPT" --install --theme="$THEME" --silent
    else
        bash "$PMT_GNOME_THEME_SCRIPT" --install --theme="$THEME"
    fi
    [[ $? -gt 2 ]] && return 2
    return 0
}

# @description Installing fzf.
# @noargs
# @exitcode 0 If fzf is successfully or already installed.
# @exitcode 1 If default package manager was not found.
# @exitcode 2 If an error was encountered during installation with apt.
function install_fzf() {
    debug "${FUNCNAME[0]}"
    info "Installing fzf"
    # Check if fzf is installed
    if command -v fzf &> /dev/null; then
        warning "fzf is already installed"
        return 0
    fi
    # Get the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        info "Installing fzf with apt"
        ! package_apt_install "fzf" && return 2
    fi
    return 0
}

# @description Installing fd-find.
# @noargs
# @exitcode 0 If fd-find is successfully or already installed.
# @exitcode 1 If default package manager was not found.
# @exitcode 2 If an error was encountered during installation with apt.
function install_fdfind() {
    debug "${FUNCNAME[0]}"
    info "Installing fd-find"
    # Check if fd-find is installed
    if command -v fdfind &> /dev/null; then
        warning "fd-find is already installed"
        return 0
    fi
    # Get the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        info "Installing fd-find with apt"
        ! package_apt_install "fd-find" && return 2
    fi
    info "Adding symbolic links"
    ! [[ -d "$HOME/.local/bin" ]] && mkdir -p "$HOME/.local/bin"
    ! [[ -f "$HOME/.local/bin/fd" ]] && ln -s "$(which fdfind)" "$HOME/.local/bin/fd"
    return 0
}

# @description Installing Batcat.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the package script does not exist.
# @exitcode 2 If an error was encountered during installation.
function install_batcat() {
    debug "${FUNCNAME[0]}"
    info "Installing Batcat"
    # Check if the script exists
    if ! [[ -f $PMT_BATCAT_SCRIPT ]]; then
        warning "$PMT_BATCAT_SCRIPT not exists"
        return 1
    fi
    # Installing Batcat
    if [[ $SILENT -gt 0 ]]; then
        bash "$PMT_BATCAT_SCRIPT" --install --theme="$THEME" --silent
    else
        bash "$PMT_BATCAT_SCRIPT" --install --theme="$THEME"
    fi
    [[ $? -gt 1 ]] && return 2
    return 0
}

# @description Installing Eza.
# @noargs
# @exitcode 0 If Eza is successfully or already installed.
# @exitcode 1 If the package script does not exist.
# @exitcode 2 If an error was encountered during prerequisite installation.
# @exitcode 3 If default package manager was not found.
# @exitcode 4 If an error was encountered during installation with apt.
function install_eza() {
    debug "${FUNCNAME[0]}"
    info "Installing Eza"
    # Check if Eza is installed
    if command -v eza &> /dev/null; then
        warning "Eza is already installed"
        return 0
    fi
    # Check if the script exists
    if ! [[ -f $PMT_EZA_SCRIPT ]]; then
        warning "$PMT_EZA_SCRIPT not exists"
        return 1
    fi
    # Installing VSCode prerequisites.
    if [[ $SILENT -gt 0 ]]; then
        if ! bash "$PMT_EZA_SCRIPT" --preinstall --theme="$THEME" --silent; then
            # exitcode 1 ff The VSCode apt repository already exists.
            [[ $? -gt 1 ]] && return 2
        fi
    else
        if ! bash "$PMT_EZA_SCRIPT" --preinstall --theme="$THEME"; then
            # exitcode 1 ff The VSCode apt repository already exists.
            [[ $? -gt 1 ]] && return 2
        fi
    fi
    # Get the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 3
    # Install eza with apt
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        info "Installing Eza with apt"
        ! package_apt_install "eza" && return 4
    fi
    return 0
}

# @description Installing zsh.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the package script does not exist.
# @exitcode 2 If an error was encountered during installation.
function install_zsh() {
    debug "${FUNCNAME[0]}"
    info "Installing zsh"
    # Check if the script exists
    if ! [[ -f $PMT_ZSH_SCRIPT ]]; then
        warning "$PMT_ZSH_SCRIPT not exists"
        return 1
    fi
    # Installing zsh
    if [[ $SILENT -gt 0 ]]; then
        bash "$PMT_ZSH_SCRIPT" --install --theme="$THEME" --silent
    else
        bash "$PMT_BATCAT_SCRIPT" --install --theme="$THEME"
    fi
    [[ $? -gt 1 ]] && return 2
    return 0
}

# @description Installing oh-my-zsh.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the package script does not exist.
# @exitcode 2 If an error was encountered during installation.
function install_oh_my_zsh() {
    debug "${FUNCNAME[0]}"
    info "Installing oh-my-zsh"
    # Check if the script exists
    if ! [[ -f $PMT_OHMYZSH_SCRIPT ]]; then
        warning "$PMT_OHMYZSH_SCRIPT not exists"
        return 1
    fi
    # Installing oh-my-zsh
    if [[ $SILENT -gt 0 ]]; then
        bash "$PMT_OHMYZSH_SCRIPT" --install --theme="$THEME" --silent
    else
        bash "$PMT_OHMYZSH_SCRIPT" --install --theme="$THEME"
    fi
    [[ $? -gt 1 ]] && return 2
    return 0
}

# @description Installing and configure powerlevel10k theme.
# @noargs
# @exitcode 0 If powerlevel10k is successfully or already installed.
# @exitcode 1 If an error was encountered when copying the configuration file.
function install_ohmyzsh_powerlevel10k() {
    debug "${FUNCNAME[0]}"
    info "Install and configure powerlevel10k"
    local ohmyzsh_custom_path="$PMT_OHMYZSH_CONF_PATH/custom"
    local powerlevel10k_path="$ohmyzsh_custom_path/themes/powerlevel10k"
    local powerlevel10k_conf="$HOME/.p10k.zsh"
    local powerlevel10k_custom_conf="$CURRENT_PATH/conf/powerlevel10k/p10k.zsh"
    local zshrc_conf_begin="$CURRENT_PATH/conf/powerlevel10k/zshrc_begin"
    local zshrc_conf_end="$CURRENT_PATH/conf/powerlevel10k/zshrc_end"
    # Check if the theme is already installed
    if [[ -f $powerlevel10k_conf ]] && [[ -d $powerlevel10k_path ]]; then
        warning "powerlevel10k theme is already installed"
        return 0
    fi
    # Backup the powerlevel10k configuration file if necessary
    if [[ -f "$powerlevel10k_conf" ]]; then
        if ! mv "$powerlevel10k_conf" "$powerlevel10k_conf.$(date '+%Y%m%d%H%M%S').bak"; then
            warning "Error copying $powerlevel10k_conf file"
            return 1
        fi
    fi
    # Clone the powerlevel10k project
    if ! [[ -d "$powerlevel10k_path" ]]; then
        git clone -q --depth=1 $PMT_POWERLEVEL10K_URL "$powerlevel10k_path"
    fi
    # Copy the powerlevel10k configuration file
    cp "$powerlevel10k_custom_conf" "$powerlevel10k_conf"
    # Check the zsh configuration file
    local check_zshrc_conf_begin="" check_zshrc_conf_end="" zshrc_conf_tmp=0
    check_zshrc_conf_begin=$(< "$zshrc_conf_begin" head -n1)
    check_zshrc_conf_end=$(< "$zshrc_conf_end" head -n1)
    if ! grep "$check_zshrc_conf_begin" "$PMT_ZSH_CONF_PATH" 1> /dev/null; then
        zshrc_conf_tmp=1
    fi
    if ! grep "$check_zshrc_conf_end" "$PMT_ZSH_CONF_PATH" 1> /dev/null; then
        zshrc_conf_tmp=1
    fi
    # Change the configuration if necessary
    if [[ $zshrc_conf_tmp -gt 0 ]]; then
        cat "$zshrc_conf_begin" > "$PMT_ZSH_CONF_PATH.tmp"
        cat "$PMT_ZSH_CONF_PATH" >> "$PMT_ZSH_CONF_PATH.tmp"
        cat "$zshrc_conf_end" >> "$PMT_ZSH_CONF_PATH.tmp"
        cp "$PMT_ZSH_CONF_PATH.tmp" "$PMT_ZSH_CONF_PATH"
        rm -f "$PMT_ZSH_CONF_PATH.tmp"
    fi
    # Change the theme in the zsh configuration file
    if ! grep "ZSH_THEME=powerlevel10k" "$PMT_ZSH_CONF_PATH" 1> /dev/null; then
        sed -i "s/^ZSH_THEME=.*/ZSH_THEME=powerlevel10k\/powerlevel10k/" "$PMT_ZSH_CONF_PATH"
    fi

    success "powerlevel10k is installed successfully!"
    return 0
}

# @description Installing oh-my-zsh plugins.
# @noargs
# @exitcode 0 If successful.
function install_ohmyzsh_plugins() {
    debug "${FUNCNAME[0]}"
    info "Installing oh-my-zsh plugins"
    local ohmyzsh_plugins_path="$PMT_OHMYZSH_CONF_PATH/custom/plugins"
    local plugin_install=0 line_plugins="" line_plugins_replace=""
    # Create the plugins path if necessary
    ! [[ -d $ohmyzsh_plugins_path ]] && mkdir "$ohmyzsh_plugins_path"
    # Installing zsh-autosuggestions plugin
    if ! [[ -d "$ohmyzsh_plugins_path/zsh-autosuggestions" ]]; then
        info "Installing zsh-autosuggestions plugin"
        # Clone the project in the plugins path
        git clone -q "$PMT_ZSH_AUTOSUGGESTIONS_URL" "$ohmyzsh_plugins_path/zsh-autosuggestions"
        # Adding the plugin in the zsh configuration file
        line_plugins=$(grep "^plugins=(" "$PMT_ZSH_CONF_PATH")
        if ! echo "$line_plugins" | grep "zsh-autosuggestions" 1> /dev/null; then
            line_plugins_replace="${line_plugins/)/ zsh-autosuggestions)}"
            sed -i "s/^plugins=.*/$line_plugins_replace/" "$PMT_ZSH_CONF_PATH"
        fi
        plugin_install=1
    fi
    # Installing zsh-syntax-highlighting plugin
    if ! [[ -d "$ohmyzsh_plugins_path/zsh-syntax-highlighting" ]]; then
        info "Installing zsh-syntax-highlighting plugin"
        # Clone the project in the plugins path
        git clone -q "$PMT_ZSH_SYNTAX_HIGHLIGHTING_URL" "$ohmyzsh_plugins_path/zsh-syntax-highlighting"
        # Adding the plugin in the zsh configuration file
        line_plugins=$(grep "^plugins=(" "$PMT_ZSH_CONF_PATH")
        if ! echo "$line_plugins" | grep "zsh-syntax-highlighting" 1> /dev/null; then
            line_plugins_replace="${line_plugins/)/ zsh-syntax-highlighting)}"
            sed -i "s/^plugins=.*/$line_plugins_replace/" "$PMT_ZSH_CONF_PATH"
        fi
        plugin_install=1
    fi
    if [[ $plugin_install -eq 0 ]] ; then
        warning "oh-my-zsh plugins are already installed" && return 0
    fi
    success "oh-my-zsh plugins are installed successfully!"
    return 0
}

# @description Installing oh-my-zsh custom configuration.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If the custom fzf configuration file does not exist.
# @exitcode 2 If the custom eza configuration file does not exist.
function install_ohmyzsh_custom() {
    debug "${FUNCNAME[0]}"
    info "Customize oh-my-zsh configuration"
    # Adding custom fzf configuration to zshrc file
    local custom_fzf_path="$CURRENT_PATH/conf/oh-my-zsh/fzf" custom_install=0
    if ! [[ -f $custom_fzf_path ]]; then
        warning "$custom_fzf_path not exists"
        return 1
    fi
    # Check if fzf configuration exists
    local check_fzf_conf=""
    check_fzf_conf=$(< "$custom_fzf_path" head -n1)
    # Adding the configuration if necessary
    if ! grep "$check_fzf_conf" "$PMT_ZSH_CONF_PATH" 1> /dev/null; then
        info "Adding the fzf configuration in the zshrc file"
        local content_custom_fzf_path="" joined_custom_fzf_path=""
        content_custom_fzf_path=$(cat "$custom_fzf_path")
        joined_custom_fzf_path=${content_custom_fzf_path//$'\n'/\\n}
        sed -i "/^plugins=.*/a \\\n$joined_custom_fzf_path" "$PMT_ZSH_CONF_PATH"
        custom_install=1
    fi
    # Adding the alias
    local custom_eza_path="$CURRENT_PATH/conf/oh-my-zsh/eza"
    if ! [[ -f $custom_eza_path ]]; then
        warning "$custom_eza_path not exists"
        return 2
    fi
    # Check if eza configuration exists
    local check_eza_conf=""
    check_eza_conf=$(< "$custom_eza_path" head -n1)
    # Adding the configuration if necessary
    if ! grep "$check_eza_conf" "$PMT_ZSH_CONF_PATH" 1> /dev/null; then
        info "Adding the eza aliases in the zshrc file"
        local content_custom_eza_path="" joined_custom_eza_path=""
        content_custom_eza_path=$(cat "$custom_eza_path")
        joined_custom_eza_path=${content_custom_eza_path//$'\n'/\\n}
        sed -i "/^# Example aliases/i $joined_custom_eza_path" "$PMT_ZSH_CONF_PATH"
        custom_install=1
    fi
    # Installation of all plugins
    local plugin="" line_plugins="" line_plugins_replace=""
    for plugin in "${PMT_ZSH_EXTRA_PLUGINS[@]}"; do
        line_plugins=$(grep "^plugins=(" "$PMT_ZSH_CONF_PATH")
        if ! echo "$line_plugins" | grep "$plugin" 1> /dev/null; then
            info "Adding $plugin plugin"
            line_plugins_replace="${line_plugins/)/ $plugin)}"
            sed -i "s/^plugins=.*/$line_plugins_replace/" "$PMT_ZSH_CONF_PATH"
        fi
        custom_install=1
    done
    if [[ $custom_install -eq 0 ]] ; then
        warning "Customize oh-my-zsh configuration is already installed" && return 0
    fi
    success "Customize oh-my-zsh configuration is installed successfully!"
    return 0
}

# @description Installing tmux multiplexer.
# @noargs
# @exitcode 0 If tmux is successfully or already installed.
# @exitcode 1 If default package manager was not found.
# @exitcode 2 If an error was encountered during installation with apt.
function install_tmux() {
    debug "${FUNCNAME[0]}"
    info "Installing tmux"
    # Check if tmux is installed
    if command -v tmux &> /dev/null; then
        warning "tmux is already installed"
        return 0
    fi
    # Get the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        info "Installing tmux with apt"
        ! package_apt_install "tmux" && return 2
    fi
    return 0
}

# @description Installing oh-my-tmux tmux theme.
# @noargs
# @exitcode 0 If tmux is successfully or already installed.
# @exitcode 1 If the package script does not exist.
# @exitcode 2 If an error was encountered during installation.
function install_ohmytmux() {
    info "Installing oh-my-tmux"
    # Check if the script exists
    if ! [[ -f $PMT_OHMYTMUX_SCRIPT ]]; then
        warning "$PMT_OHMYTMUX_SCRIPT not exists"
        return 1
    fi
    # Installing oh-my-tmux
    if [[ $SILENT -gt 0 ]]; then
        bash "$PMT_OHMYTMUX_SCRIPT" --install --theme="$THEME" --silent
    else
        bash "$PMT_OHMYTMUX_SCRIPT" --install --theme="$THEME"
    fi
    [[ $? -gt 1 ]] && return 2
    return 0
}

# @description Installing neovim editor.
# @noargs
# @exitcode 0 If neovim is successfully or already installed.
# @exitcode 1 If the package script does not exist.
# @exitcode 2 If an error was encountered during installation.
# @exitcode 3 If default package manager was not found.
# @exitcode 4 If an error was encountered during installation with apt.
function install_neovim() {
    debug "${FUNCNAME[0]}"
    info "Installing Neovim"
    # Check if Neovim is installed
    if command -v nvim &> /dev/null; then
        warning "Neovim is already installed"
        return 0
    fi
    # Check if the script exists
    if ! [[ -f $PMT_NEOVIM_SCRIPT ]]; then
        warning "$PMT_NEOVIM_SCRIPT not exists"
        return 1
    fi
    # Installing Neovim prerequisites.
    if [[ $SILENT -gt 0 ]]; then
        if ! bash "$PMT_NEOVIM_SCRIPT" --preinstall --theme="$THEME" --silent; then
            return 2
        fi
    else
        if ! bash "$PMT_NEOVIM_SCRIPT" --preinstall --theme="$THEME"; then
            return 2
        fi
    fi
    # Get the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 3
    # Install neovim with apt
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        info "Installing Neovim with apt"
        ! package_apt_install "neovim" && return 4
    fi
    return 0
}

# @description Installing oh-my-neovim neovim theme.
# @noargs
# @exitcode 0 If oh-my-neovim is successfully or already installed.
# @exitcode 1 If the package script does not exist.
# @exitcode 2 If an error was encountered during installation.
function install_ohmyneovim() {
    debug "${FUNCNAME[0]}"
    info "Installing oh-my-neovim"
    # Check if the script exists
    if ! [[ -f $PMT_OHMYNEOVIM_SCRIPT ]]; then
        warning "$PMT_OHMYNEOVIM_SCRIPT not exists"
        return 1
    fi
    # Installing oh-my-neovim
    if [[ $SILENT -gt 0 ]]; then
        bash "$PMT_OHMYNEOVIM_SCRIPT" --install --theme="$THEME" --silent
    else
        bash "$PMT_OHMYNEOVIM_SCRIPT" --install --theme="$THEME"
    fi
    [[ $? -gt 1 ]] && return 1
    return 0
}

# @description Installing VSCode editor.
# @noargs
# @exitcode 0 If oh-my-neovim is successfully installed, already installed, or no display manager exists.
# @exitcode 1 If the package script does not exist.
# @exitcode 2 If an error was encountered during prerequisite installation.
# @exitcode 3 If default package manager was not found.
# @exitcode 4 If an error was encountered during installation with apt.
# shellcheck disable=SC2010
function install_vscode() {
    debug "${FUNCNAME[0]}"
    info "Installing VSCode"
    # Check if VSCode is installed
    if command -v code &> /dev/null; then
        warning "VSCode is already installed"
        return 0
    fi
    # Check if a display manager is installed
    if ! ls /usr/bin/*session|grep -E "gnome|kde|xfce|lxde" 1> /dev/null; then
        warning "No display manager installed"
        return 0
    fi
    # Check if the script exists
    if ! [[ -f $PMT_VSCODE_SCRIPT ]]; then
        warning "$PMT_VSCODE_SCRIPT not exists"
        return 1
    fi
    # Installing VSCode prerequisites.
    if ! bash "$PMT_VSCODE_SCRIPT" --preinstall --theme="$THEME"; then
        # exitcode 1 ff The VSCode apt repository already exists.
        [[ $? -gt 1 ]] && return 2
    fi
    # Get the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 3
    # Install VSCode with apt
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        info "Installing VSCode with apt"
        ! package_apt_install "code" && return 4
    fi
    return 0
}

# @description Check if pimpmyterm packages are installed.
# @noargs
# @exitcode 0 If pimpmyterm is not installed.
# @exitcode 1 If pimpmyterm is already installed.
function check_install() {
    debug "${BASH_SOURCE[0]}" "${FUNCNAME[0]}"
    # MesloLGS Nerd font
    if bash "$PMT_NERD_FONTS_SCRIPT" --check --theme="$THEME"; then
        return 0
    fi
    # Catppuccin Mocha gnome theme
    if bash "$PMT_GNOME_THEME_SCRIPT" --check --theme="$THEME"; then
        return 0
    fi
    # fzf
    if ! command -v fzf &> /dev/null; then
        return 0
    fi
    # fd-find
    if ! command -v fdfind &> /dev/null; then
        return 0
    fi
    # Batcat
    if bash "$PMT_BATCAT_SCRIPT" --check --theme="$THEME"; then
        return 0
    fi
    # Eza
    if bash "$PMT_EZA_SCRIPT" --check --theme="$THEME"; then
        return 0
    fi
    # zsh
    if bash "$PMT_ZSH_SCRIPT" --check --theme="$THEME"; then
        return 0
    fi
    # oh-my-zsh
    if bash "$PMT_OHMYZSH_SCRIPT" --check --theme="$THEME"; then
        return 0
    fi
    # powerlevel10k
    if ! [[ -f $HOME/.p10k.zsh ]]; then
        return 0
    fi
    # tmux
    if ! command -v tmux &> /dev/null; then
        return 0
    fi
    # oh-my-tmux
    if bash "$PMT_OHMYTMUX_SCRIPT" --check --theme="$THEME"; then
        return 0
    fi
    # Neovim
    if ! command -v nvim &> /dev/null; then
        return 0
    fi
    # oh-my-neovim
    if bash "$PMT_OHMYNEOVIM_SCRIPT" --check --theme="$THEME"; then
        return 0
    fi
    # VSCode
    if ! command -v code &> /dev/null; then
        # shellcheck disable=SC2010
        if ls /usr/bin/*session|grep -E "gnome|kde|xfce|lxde" 1> /dev/null; then
            return 0
        fi
    fi
    # Pimpmyterm is already installed
    return 1
}

# @description Installing customized terminal and shell configuration.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If an error was encountered during font installation.
# @exitcode 2 If an error was encountered during gnome theme installation.
# @exitcode 3 If an error was encountered during fzf installation.
# @exitcode 4 If an error was encountered during fd-find installation.
# @exitcode 5 If an error was encountered during Batcat installation.
# @exitcode 6 If an error was encountered during Eza installation.
# @exitcode 7 If an error was encountered during Zsh installation.
# @exitcode 8 If an error was encountered during oh-my-zsh installation.
# @exitcode 9 If an error was encountered during powerlevel10k theme installation.
# @exitcode 10 If an error was encountered during oh-my-zsh plugins installation.
# @exitcode 11 If an error was encountered during oh-my-zsh custom configuration installation.
# @exitcode 12 If an error was encountered during tmux installation.
# @exitcode 13 If an error was encountered during oh-my-tmux installation.
# @exitcode 14 If an error was encountered during Neovim installation.
# @exitcode 15 If an error was encountered during oh-my-neovim installation.
# @exitcode 16 If an error was encountered during VSCode installation.
function install() {
    debug "${FUNCNAME[0]}"

    ! install_nerd_fonts && return 1
    ! install_gnome_theme && return 2
    ! install_fzf && return 3
    ! install_fdfind && return 4
    ! install_batcat && return 5
    ! install_eza && return 6
    ! install_zsh && return 7
    ! install_oh_my_zsh && return 8
    ! install_ohmyzsh_powerlevel10k && return 9
    ! install_ohmyzsh_plugins && return 10
    ! install_ohmyzsh_custom && return 11
    ! install_tmux && return 12
    ! install_ohmytmux && return 13
    ! install_neovim && return 14
    ! install_ohmyneovim && return 15
    ! install_vscode && return 16

    success "PimpMyTerm is installed successfully!"
    info "Launch a new terminal to apply the update"
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
main "$@"
