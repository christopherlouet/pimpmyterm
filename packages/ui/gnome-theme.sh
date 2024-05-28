#!/usr/bin/env bash
# @name Gnome Theme
# @brief Script to install a theme in the gnome terminal.
# @description
#   The library lets you install a theme in the gnome terminal.

CURRENT_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../libs" &>/dev/null && pwd)
source "$LIBS_PATH/script.sh"

GNOME_CONFIG_PATH="$CURRENT_PATH/conf/gnome-theme"
GNOME_DCONF_PATH="/org/gnome/terminal/legacy/profiles:"
GNOME_DEFAULT_THEME="catppuccin_mocha"

# @description Displays debug information.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug() { debug_script "./packages/ui/gnome-theme.sh" "$*" ; }

# @description Get package information.
# @noargs
# @exitcode 0 If successful.
function package_information() {
    debug "${FUNCNAME[0]}"
    VERSION=1.0.0
    MAINTAINER="Christopher LOUËT"
    DESCRIPTION="A simple utility to change the gnome terminal theme"
    return 0
}

# @description Display the help.
# @noargs
# @exitcode 0 If successful.
function help() {
    debug "${FUNCNAME[0]}"
    local output=""
    output="
${COLORS[YELLOW]}Usage:\n${COLORS[WHITE]}  ./$(basename -- "$0") [options] <theme>
${COLORS[YELLOW]}\nOptions:${COLORS[NOCOLOR]}
  ${COLORS[GREEN]}-i, --install${COLORS[WHITE]}     Installing a theme in the gnome terminal
  ${COLORS[GREEN]}-r, --remove${COLORS[WHITE]}      Removing a theme in the gnome terminal
${COLORS[YELLOW]}\nExamples:${COLORS[NOCOLOR]}
  ${COLORS[GREEN]}./$(basename -- "$0") install${COLORS[WHITE]} Installing theme
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Duplicate and load a gnome profile.
# @arg $1 string Gnome profile path.
# @exitcode 0 If successful.
# @exitcode 1 If no gnome profile path passed as parameter.
# @exitcode 2 If no profile name passed as parameter.
function load_profile() {
    debug "${FUNCNAME[0]}"

    local gnome_conf_path=$1
    local profile_name=$2

    [[ -z $gnome_conf_path ]] && warning "No gnome profile file passed as parameter" && return 1
    [[ -z $profile_name ]] && warning "No profile name passed as parameter" && return 2

    local profile_ids_old="" delimiter=""
    profile_ids_old="$(dconf read "$GNOME_DCONF_PATH"/list | tr -d "]")"
    profile_id="$(uuidgen)"
    # if there's no `list` key
    [[ -z "$profile_ids_old" ]] && profile_ids_old="["
    # if the list is empty
    [[ ${#profile_ids[@]} -gt 0 ]] && delimiter=","
    dconf write $GNOME_DCONF_PATH/list "${profile_ids_old}${delimiter} '$profile_id']"
    dconf write "$GNOME_DCONF_PATH/:$profile_id"/visible-name "'$profile_name'"
    dconf load "$GNOME_DCONF_PATH/:$profile_id/" < "$gnome_conf_path"
    return 0
}

# @description Apply theme in the gnome terminal.
# @arg $1 string Gnome theme name.
# @exitcode 0 If successful.
# @exitcode 1 If configuration file not found.
# @exitcode 2 If profile loading failed.
function apply_theme() {
    debug "${FUNCNAME[0]}"
    local gnome_theme=$1

    # Get the default theme if no theme passed as parameter
    [[ -z $gnome_theme ]] && gnome_theme="$GNOME_DEFAULT_THEME"

    # Get the gnome configuration file
    local gnome_conf_path="$GNOME_CONFIG_PATH/$gnome_theme.dconf"
    if ! [[ -f "$gnome_conf_path" ]]; then
        warning "Config file $gnome_conf_path not found!"
        return 1
    fi

    info "Duplicate and load a profile"
    ! load_profile "$gnome_conf_path" "$profile_name" && return 2

    info "Set the new profile as default"
    dconf write "$GNOME_DCONF_PATH/default" "'$profile_id'"

    info "Launch a new terminal to apply the theme"
    return 0
}

# @description Installation of prerequisites.
# @noargs
# @set DEFAULT_PACKAGE_MANAGER string Default package manager.
# @exitcode 0 If successful.
# @exitcode 1 If the default package manager has not been found.
# @exitcode 2 If dconf-cli installation failed.
function install_prerequisites() {
    debug "${FUNCNAME[0]}"
    # Checking prerequisites
    if command -v dconf &> /dev/null; then
        return 0
    fi
    info "Get the default package manager"
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1
    info "Installed dconf-cli"
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        ! package_apt_install "dconf-cli" && return 2
    fi
    return 0
}

# @description Check if the gnome theme is installed.
# @noargs
# @exitcode 0 If gnome theme is not installed.
# @exitcode 1 If gnome theme is already installed or Gnome is not installed.
# @exitcode 2 If the configuration file was not found.
# @exitcode 3 If dconf is not installed.
# @exitcode 4 If font is not installed.
function check_install() {
    debug "${FUNCNAME[0]}"

    local gnome_theme=$1
    profile_name="" profile_font="" gnome_conf_path="" profile_ids=()

    # Get the default theme if no theme passed as parameter
    [[ -z $gnome_theme ]] && gnome_theme="$GNOME_DEFAULT_THEME"

    # Check if gnome is installed
    # shellcheck disable=SC2010
    if ! ls /usr/bin/*session|grep "gnome" 1> /dev/null; then
        warning "Gnome is not installed"
        return 1
    fi

    # Get the gnome configuration file
    gnome_conf_path="$GNOME_CONFIG_PATH/$gnome_theme.dconf"
    if ! [[ -f "$gnome_conf_path" ]]; then
        warning "Config file $gnome_conf_path not found"
        return 2
    fi

    # Get the profile name
    profile_name=$(grep "^visible-name=" "$gnome_conf_path"|awk -F  '=' '{print $2}'|tr -d "'")

    # Get the theme font
    profile_font=$(grep "^font=" "$gnome_conf_path"|awk -F  '=' '{print $2}'|tr -d "'")
    profile_font=$(echo "$profile_font" | rev |cut -d " " -f2- | rev)

    [[ -z $profile_name ]] && die "Profile name not found in the config file $gnome_conf_path" && return 3
    [[ -z $profile_font ]] && die "Profile font not found in the config file $gnome_conf_path" && return 4

    # Checking prerequisites
    if ! command -v dconf &> /dev/null; then
        warning "dconf is not installed"
        return 3
    fi

    # Check if the font is installed
    if ! fc-list|grep "$profile_font" 1> /dev/null; then
        warning "$profile_font is not installed"
        return 4
    fi

    # Get the gnome terminal profiles
    profile_ids=($(dconf list $GNOME_DCONF_PATH/ | grep ^: | sed 's/\///g' | sed 's/://g'))

    # Check if this profile already exists
    local profile_id=""
    if [[ ${#profile_ids[@]} -gt 0 ]]; then
        profile_id="" profile_tmp=""
        for profile_id in "${profile_ids[@]}"; do
            profile_tmp=$(dconf read "$GNOME_DCONF_PATH/:$profile_id/visible-name")
            debug "Check profile: $profile_id - Visible name: $profile_tmp"
            if [[ "$profile_tmp" == "'$profile_name'" ]]; then
                warning "$profile_name is already installed"
                return 1
            fi
        done
    fi

    return 0
}

# @description Installing a theme in the gnome terminal.
# @arg $1 string Gnome theme name.
# @exitcode 0 If successful.
# @exitcode 1 If theme is already installed.
# @exitcode 2 If prerequisite installation has failed.
# @exitcode 3 If theme installation failed.
function install() {
    debug "${FUNCNAME[0]}"
    local gnome_theme=$1 profile_name=""
    # Check if the theme can be installed and get profile name
    ! check_install "$gnome_theme" && return 1
    # Installing prerequisites
    ! install_prerequisites && return 2
    # Apply the theme to the gnome terminal
    ! apply_theme "$gnome_theme" && return 3
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
main "$@"
