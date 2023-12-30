#!/usr/bin/env bash

CURRENT_FOLDER=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CONFIG_FOLDER=$(cd -- "$CURRENT_FOLDER/config" &>/dev/null && pwd)
AUTO_INSTALL=0
DEBUG_INSTALL=0

function head() {
	echo -e "\033[0;32m$*\033[0m"
}

function info() {
	echo -e "\033[0;33m$*\033[0m"
}

function die() {
	echo -e "\033[0;31m$*\033[0m" >/dev/stderr
}

# Detect operating system
function detect_os() {
	local os=""
	local dist=""
	local release=""
	os="$(command uname)"
	case "$os" in
	'Darwin') os="macos" ;;
	'Linux')
		dist="$(command lsb_release -i | awk '{print $NF}')"
		case "$dist" in
		"Ubuntu")
			release="$(command lsb_release -r | awk '{print $NF}')"
			case "$release" in
			"22.04") ;;
			*)
				die "Not available for $os $dist $release"
				exit 1
				;;
			esac
			;;
		*)
			die "Not available for $os $dist"
			exit 1
			;;
		esac
		;;
	*)
		die "Not available for $os"
		exit 1
		;;
	esac
}

# Check the prerequisites
function check_prerequisites() {
    local packages="gawk perl sed curl git gpg wget gcc-x86-64-linux-gnu"
    local install_packages=""
    local install_continue=0

    for package in $packages ; do
        check_package=$package
        [[ "$package" =~ ^gcc-.* ]] && check_package="gcc"
        ! [[ -x "$(command -v $check_package)" ]] && install_packages+="$package "
    done
    [[ -n "$install_packages" ]] && install_packages="${install_packages::-1}"

    if [[ -n $install_packages ]]; then
        if [[ $AUTO_INSTALL -eq 0 ]]; then
            read -r -p "To continue, you must install [ $install_packages]. Proceed with installation? [Y/n] " answer
            case "$answer" in
            "")
                install_continue=1 ;;
            [yY][eE][sS]|[yY])
                install_continue=1 ;;
            *)
                die "Please install $install_packages" && exit 1 ;;
            esac
        else
            install_continue=1
        fi
        if [ $install_continue -eq 1 ]; then
            sudo apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update
            sudo apt install -qqy "$install_packages"
        fi
    fi
}

# Check environment
function check_env() {
	head "Check environment"
	[[ $DEBUG_INSTALL -eq 1 ]] && return 0
	[ "$USER" = "root" ] && die "Unable to continue installation with root user" && exit 1
	detect_os
    check_prerequisites
}

# Install and configure zsh
function setup_zsh() {
	head "Setup zsh"
	[[ $DEBUG_INSTALL -eq 1 ]] && return 0

	local oh_my_zsh_custom="$HOME/.oh-my-zsh/custom"

	info "Install zsh and fzf"
	sudo apt update -qq -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false 2> /dev/null && \
	    sudo DEBIAN_FRONTEND=noninteractive apt install -y zsh fzf

    info "Changing the Default Shell"
	sudo usermod --shell /usr/bin/zsh "$USER" 1> /dev/null

	info "Install oh-my-zsh"
	if [[ -d "$HOME/.oh-my-zsh" ]]; then
        info "oh-my-zsh is already installed"
	else
	    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	fi

    info "Configure zsh"
    [[ -f "$HOME/.zshrc" ]] && mv "$HOME/.zshrc" "$HOME/.zshrc.$(date '+%Y%m%d%H%M%S').bak"
    cp "$CONFIG_FOLDER/zsh/zshrc" "$HOME/.zshrc"

	info "Install and configure powerlevel10k"
	[[ -f ~/.p10k.zsh ]] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.$(date '+%Y%m%d%H%M%S').bak"
	! [[ -d "$oh_my_zsh_custom/themes/powerlevel10k" ]] && \
	    git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git "$oh_my_zsh_custom/themes/powerlevel10k"
	cp "$CONFIG_FOLDER/zsh/p10k.zsh" "$HOME/.p10k.zsh"

	info "Install plugin zsh-autosuggestions"
    ! [[ -d "$oh_my_zsh_custom/plugins/zsh-autosuggestions" ]] && \
	    git clone -q https://github.com/zsh-users/zsh-autosuggestions.git "$oh_my_zsh_custom/plugins/zsh-autosuggestions"

	info "Install plugin zsh-syntax-highlighting"
	! [[ -d "$oh_my_zsh_custom/plugins/zsh-syntax-highlighting" ]] && \
	    git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git "$oh_my_zsh_custom/plugins/zsh-syntax-highlighting"

	info "Install plugin fzf-tab-completion"
	! [[ -d "$oh_my_zsh_custom/plugins/fzf-tab-completion" ]] && \
  	    git clone -q https://github.com/lincheney/fzf-tab-completion "$oh_my_zsh_custom/plugins/fzf-tab-completion"
}

# Install and configure utilities
function setup_zsh_extras() {
	head "Setup utilities"
	[[ $DEBUG_INSTALL -eq 1 ]] && return 0

	info "Install extra packages"
	sudo apt update -qq 2> /dev/null && sudo apt install -qqy shfmt fd-find ripgrep htop net-tools

	info "Configure fd"
	! [[ -d "$HOME/.local/bin" ]] && mkdir -p "$HOME/.local/bin"
	! [[ -f "$HOME/.local/bin/fd" ]] && ln -s "$(which fdfind)" "$HOME/.local/bin/fd"

	info "Install batcat"
	if [[ -x "$(command -v batcat)" ]]; then
        info "batcat is already installed"
    else
        $CURRENT_FOLDER/scripts/batcat.sh --clean
    fi

	info "Install bat-extras"
	if [[ -x "$(command -v batgrep)" ]]; then
        info "extras are already installed"
    else
        git clone -q https://github.com/eth-p/bat-extras/ /tmp/bat-extras
        sudo /tmp/bat-extras/build.sh --install && sudo rm -rf /tmp/bat-extras
    fi

	info "Install eza"
	if [[ -x "$(command -v eza)" ]]; then
        info "eza is already installed"
    else
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt update -qq 2> /dev/null && sudo apt install -qqy eza
    fi
}

# Install and configure neovim
function setup_neovim() {
	head "Setup neovim"
	[[ $DEBUG_INSTALL -eq 1 ]] && return 0

    info "Install neovim"
    if [[ -x "$(command -v nvim)" ]]; then
        info "nvim is already installed"
    else
        sudo add-apt-repository ppa:neovim-ppa/unstable -y && \
            sudo apt update -qq 2> /dev/null && sudo apt install -qqy neovim
    fi

    info "backup nvim configuration files"
    [[ -d "$HOME/.config/nvim" ]] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.$(date '+%Y%m%d%H%M%S').bak"
    [[ -d "$HOME/.local/share/nvim" ]] && mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.$(date '+%Y%m%d%H%M%S').bak"

	info "Install oh-my-nvim from hardhackerlabs"
	git clone -q https://github.com/hardhackerlabs/oh-my-nvim.git "$HOME/.config/nvim"

	info "Copy custom configuration files"
	cp "$CONFIG_FOLDER/neovim/colorschemes.lua" "$HOME/.config/nvim/lua/plugins/colorschemes.lua"
	cp "$CONFIG_FOLDER/neovim/custom_opts.lua" "$HOME/.config/nvim/lua/custom_opts.lua"
}

# Install and configure tmux
function setup_tmux() {
	head "Setup tmux"
	[[ $DEBUG_INSTALL -eq 1 ]] && return 0

	info "Install tmux"
	sudo apt update -qq 2> /dev/null && sudo apt install -qqy tmux

	info "Backup tmux configuration files"
	[[ -d "$HOME/.tmux" ]] && mv "$HOME/.tmux" "$HOME/.tmux.$(date '+%Y%m%d%H%M%S').bak"
	[[ -f "$HOME/.tmux.conf.local" ]] && mv "$HOME/.tmux.conf.local" "$HOME/.tmux.conf.local.$(date '+%Y%m%d%H%M%S').bak"

	info "Install Oh my tmux!"
    git clone -q https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
    ln -sf "$HOME/.tmux.conf" "$HOME/.tmux/.tmux.conf"

    info "Copy tmux custom files"
    cp "$CONFIG_FOLDER/tmux/tmux.conf.local" "$HOME/.tmux.conf.local"
}

# Install Meslo Nerd Font
function setup_fonts() {
    head "Setup fonts"
    [[ $DEBUG_INSTALL -eq 1 ]] && return 0

    local fonts_dest="$HOME/.local/share/fonts/NerdFonts"
    ! [[ -d $fonts_dest ]] && mkdir -p "$fonts_dest"
    ! [[ -f "$fonts_dest/MesloLGSNerdFont-Regular.ttf" ]] && \
        wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -O "$fonts_dest/MesloLGSNerdFont-Regular.ttf" \
            -q --show-progress > /dev/null
    ! [[ -f "$fonts_dest/MesloLGSNerdFont-Bold.ttf" ]] && \
            wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -O "$fonts_dest/MesloLGSNerdFont-Bold.ttf" \
                -q --show-progress > /dev/null
    ! [[ -f "$fonts_dest/MesloLGSNerdFont-Italic.ttf" ]] && \
            wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -O "$fonts_dest/MesloLGSNerdFont-Italic.ttf" \
                -q --show-progress > /dev/null
    ! [[ -f "$fonts_dest/MesloLGSNerdFont-BoldItalic.ttf" ]] && \
            wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -O "$fonts_dest/MesloLGSNerdFont-BoldItalic.ttf" \
                -q --show-progress > /dev/null
}

# Apply the gnome terminal theme
function setup_gnome_terminal() {
    head "Setup gnome terminal theme"
    [[ $DEBUG_INSTALL -eq 1 ]] && return 0

    # Install dconf-cli if necessary
    ! [[ -x "$(command -v dconf)" ]] && sudo apt update -qq 2> /dev/null && sudo apt install -qqy dconf-cli
    # Get the current profiles
    local profile_id=""
    local profile_ids_old=""
    local profile_name="catppuccin-mocha-custom"
    local dconfdir=/org/gnome/terminal/legacy/profiles:
    local profile_ids=($(dconf list $dconfdir/ | grep ^: |sed 's/\///g' | sed 's/://g'))
    # Check if the profile exists
    for i in ${!profile_ids[*]}; do
        if [[ "$(dconf read $dconfdir/:${profile_ids[i]}/visible-name)" == "'Catppuccin Mocha'" ]]; then
            echo "The Catppuccin Mocha profile already exists"
            return 0
        fi
    done
    # Duplicate a profile, and load the profile
    profile_ids_old="$(dconf read "$dconfdir"/list | tr -d "]")"
    profile_id="$(uuidgen)"
    [ -z "$profile_ids_old" ] && local profile_ids_old="["  # if there's no `list` key
    [ ${#profile_ids[@]} -gt 0 ] && local delimiter=,  # if the list is empty
    dconf write $dconfdir/list "${profile_ids_old}${delimiter} '$profile_id']"
    dconf write "$dconfdir/:$profile_id"/visible-name "'$profile_name'"
    dconf load "/org/gnome/terminal/legacy/profiles:/:$profile_id/" < "$CONFIG_FOLDER/gnome_terminal/catppuccin-mocha-theme-profile.dconf"
    # Set the profile as default
    dconf write $dconfdir/default "'$profile_id'"
    info "Launch a new terminal to apply the theme"
}

function show_usage() {
    info "Usage installer.sh [--all] [--zsh|--neovim|--tmux] [--fonts] [--gnome-terminal] [--auto]"
}

function main() {

	local install_zsh=0
	local install_neovim=0
	local install_tmux=0
	local install_fonts=0
    local install_gnome_terminal=0

    if [[ $# -eq 0 ]]; then
        show_usage
        exit 1
    fi

	while [[ $# -gt 0 ]]; do
		opt="$1"
		shift
		case "$opt" in
		"--") break 2 ;;
        "--check-env") ;;
		"--all")
			install_zsh=1
			install_neovim=1
			install_tmux=1
			;;
        "--auto")
            AUTO_INSTALL=1
            ;;
        "--debug")
            DEBUG_INSTALL=1
            ;;
        "--neovim")
            install_neovim=1
            ;;
		"--zsh")
			install_zsh=1
			;;
        "--tmux")
            install_tmux=1
            ;;
        "--fonts")
            install_fonts=1
            ;;
        "--gnome-terminal")
            install_gnome_terminal=1
            ;;
		*)
			die "Invalid option: $opt"
			show_usage
			exit 1
			;;
		esac
	done

	check_env

	if [[ $install_zsh -eq 1 ]]; then
	    setup_zsh
	    setup_zsh_extras
	fi

	[[ $install_neovim -eq 1 ]] && setup_neovim
	[[ $install_tmux -eq 1 ]] && setup_tmux
	[[ $install_fonts -eq 1 ]] && setup_fonts
	[[ $install_gnome_terminal -eq 1 ]] && setup_gnome_terminal

	[[ $install_zsh -eq 1 ]] && info "Launch a new terminal to apply the changes"
	[[ $install_neovim -eq 1 ]] && info "Launch nvim to install and setup all plugins"

	return 0
}

main "$@"
