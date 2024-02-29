#!/usr/bin/env bash
# @name Profile
# @brief Profile configuration.
# @description
#   This library manages application profiles.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LIB_PROFILE="$LIBS_PATH/src/profile.sh"
PROFILE_CONFIG_FILE=""
LAST_UPDATE=""
BANNER=""

# @description Displays debug information for profile library.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug_profile() { debug_script "./libs/profile.sh" "$*" ; }

# @description Read the profile configuration file.
# @noargs
# @set PROFILE_CONFIG_FILE string Profile configuration file.
# @set LAST_UPDATE string Date of last update.
# @set THEME string Theme applied to profile.
# @set BANNER string Banner applied to profile.
# @exitcode 0 If successful.
# @exitcode 1 Profile configuration file not found.
function profile_read_config() { eval "$(bash "$LIB_PROFILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Get a list of packages in the profile configuration file.
# @noargs
# @set PROFILE_CONFIG_FILE string Profile configuration file.
# @set PACKAGES_INIT integer Search all packages in the profile.
# @set SEARCH_CATEGORY string Search by category name.
# @set SEARCH_PACKAGES string Search by package name.
# @set PROFILE_PACKAGES string array List of profile packages.
# @exitcode 0 If successful.
# @exitcode 1 Profile configuration file not found.
# @exitcode 2 No package found.
function profile_read_packages() { eval "$(bash "$LIB_PROFILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Add a package to the current list.
# @noargs
# @set PROFILE_PACKAGES string array List of profile packages.
# @exitcode 0 If successful.
function profile_add_package() { eval "$(bash "$LIB_PROFILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Update packages in the profile configuration file.
# @noargs
# @set PROFILE_CONFIG_FILE string Profile configuration file.
# @set PACKAGES_DISPLAY array List of packages to be updated in the profile configuration file.
# @exitcode 0 If successful.
# @exitcode 1 Profile configuration file not found.
# @exitcode 2 No package found.
function profile_update_packages() { eval "$(bash "$LIB_PROFILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Update a line in the profile configuration file.
# @noargs
# @exitcode 0 If successful.
function profile_update_section() { eval "$(bash "$LIB_PROFILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Merge a line in the profile configuration file.
# @noargs
# @exitcode 0 If successful.
function profile_merge_section() { eval "$(bash "$LIB_PROFILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Update theme in the profile configuration file.
# @noargs
# @set PROFILE_CONFIG_FILE string Profile configuration file.
# @set THEME string Theme to be applied in profile configuration file.
# @exitcode 0 If successful.
# @exitcode 1 Profile configuration file not found.
# @exitcode 2 Theme not found.
function profile_update_theme() { eval "$(bash "$LIB_PROFILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Update date in profile configuration file.
# @noargs
# @set PROFILE_CONFIG_FILE string Profile configuration file.
# @set LAST_UPDATE string Date of last update applied to profile configuration file.
# @exitcode 0 If successful.
# @exitcode 1 Profile configuration file not found.
function profile_update_last_update() { eval "$(bash "$LIB_PROFILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Create a new profile.
# @noargs
# @set CONFIG_FILE_PATH string Configuration file.
# @exitcode 0 If successful.
# @exitcode 1 Configuration file not found.
# @exitcode 2 Profile not found.
# @exitcode 3 Profile field not found in configuration file.
function profile_create() { eval "$(bash "$LIB_PROFILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Main function.
# @arg $@ any Options passed as script parameters.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
function main() {
    [[ -n "${FUNCNAME[2]}" ]] && return 0
    source "$LIBS_PATH/common.sh"
    local args=()
    for opt in "$@"; do
        case "$opt" in
            --debug|-d) DEBUG=1 ;;
            --packages=*) SEARCH_PACKAGES=$(echo "$opt"|awk -F= '{print $2}') ;;
            --category=*) SEARCH_CATEGORY=$(echo "$opt"|awk -F= '{print $2}') ;;
            *) args+=("$opt") ;;
        esac
    done
    [[ -z "${args[0]}" ]] && die "No function to call" && return 1
    ! [[ $(type -t "${args[0]}") == function ]] && die "Function with name '${args[0]}' does not exist" && return 2
    eval "${args[@]}"
}

main "$@"
