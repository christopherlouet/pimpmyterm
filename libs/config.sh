#!/usr/bin/env bash
# @name Config
# @brief Global application configuration.
# @description
#   This library manages the application's global configuration.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LIB_CONFIG="$LIBS_PATH/src/config.sh"
DEBUG_PATH="./libs/config.sh"
CONFIG_FILE_PATH="$(dirname -- "$LIBS_PATH")/config.ini"
PROFILES_PATH="$(dirname -- "$LIBS_PATH")/profiles"
PROFILE=""
PROFILE_CONFIG_FILE=""

# @description Displays debug information for config library.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug_config() { debug_script "./libs/config.sh" "$*" ; }

# @description Read the configuration file.
# @noargs
# @set CONFIG_FILE_PATH string Configuration file.
# @set PROFILES_PATH string Profile path.
# @set PROFILE string Profile name.
# @set PROFILE_CONFIG_FILE string Profile configuration file.
# @exitcode 0 If successful.
# @exitcode 1 If configuration file not found.
# @exitcode 2 If profile path not found.
# @exitcode 3 If profile not found.
# @exitcode 4 If profile configuration file not found.
function config_read() { eval "$(bash "$LIB_CONFIG" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Get profile list.
# @noargs
# @set PROFILES_PATH string Profile path.
# @set PROFILE_LIST array Profile list.
# @exitcode 0 If successful.
# @exitcode 1 Profile path not found.
# @exitcode 2 No profile found.
function config_profile_list() { eval "$(bash "$LIB_CONFIG" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Update profile in configuration file.
# @noargs
# @set CONFIG_FILE_PATH string Configuration file.
# @set PROFILE string Profile name.
# @exitcode 0 If successful.
# @exitcode 1 Configuration file not found.
# @exitcode 2 Profile not found.
# @exitcode 3 Profile field not found in configuration file.
function config_profile_update() { eval "$(bash "$LIB_CONFIG" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Get theme list.
# @noargs
# @set THEMES_PATH string Theme path.
# @set THEME_LIST array Theme list.
# @exitcode 0 If successful.
# @exitcode 1 Theme path not found.
# @exitcode 2 No theme found.
function config_theme_list() { eval "$(bash "$LIB_CONFIG" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Setting up unit tests.
# @noargs
# @exitcode 0 If successful.
function setup_unit_tests() {
    # Profile and theme ok
    if [[ $TEST -eq 1 ]]; then
        CONFIG_FILE_PATH="$(dirname -- "$LIBS_PATH")/tests/config/config_profile.ini"
        PROFILES_PATH="$(dirname -- "$LIBS_PATH")/tests/profiles"
        THEMES_PATH="$(dirname -- "$LIBS_PATH")/tests/themes"
        PROFILE="test"
    fi
    # Config path not exists
    if [[ $TEST -eq 2 ]]; then
        CONFIG_FILE_PATH="test"
    fi
    # Profile path not exists
    if [[ $TEST -eq 3 ]]; then
        PROFILES_PATH="test"
    fi
    # Config empty
    if [[ $TEST -eq 4 ]]; then
        CONFIG_FILE_PATH="$(dirname -- "$LIBS_PATH")/tests/config/config_empty.ini"
    fi
    # Profile not exists
    if [[ $TEST -eq 5 ]]; then
        CONFIG_FILE_PATH="$(dirname -- "$LIBS_PATH")/tests/config/config_profile_not_exists.ini"
        PROFILES_PATH="$(dirname -- "$LIBS_PATH")/tests/profiles"
    fi
    # Profile empty
    if [[ $TEST -eq 6 ]]; then
        CONFIG_FILE_PATH="$(dirname -- "$LIBS_PATH")/tests/config/config_profile_empty.ini"
        PROFILE="test"
        PROFILES_PATH="$(dirname -- "$LIBS_PATH")/tests/profiles"
    fi
    # Profile path empty
    if [[ $TEST -eq 7 ]]; then
        CONFIG_FILE_PATH="$(dirname -- "$LIBS_PATH")/tests/config/config_profile.ini"
        PROFILE="test"
        PROFILES_PATH="$(dirname -- "$LIBS_PATH")/tests/profiles_empty"
    fi
    # Theme path not exists
    if [[ $TEST -eq 8 ]]; then
        THEMES_PATH="test"
    fi
    # Theme path empty
    if [[ $TEST -eq 9 ]]; then
        CONFIG_FILE_PATH="$(dirname -- "$LIBS_PATH")/tests/config/config_profile.ini"
        THEMES_PATH="$(dirname -- "$LIBS_PATH")/tests/themes_empty"
    fi
    return 0
}

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
            --test=*) TEST=("$(echo "$opt"|awk -F= '{print $2}')") ;;
            *) args+=("$opt") ;;
        esac
    done
    [[ -z "${args[0]}" ]] && die "No function to call" && return 1
    ! [[ $(type -t "${args[0]}") == function ]] && die "Function with name '${args[0]}' does not exist" && return 2
    setup_unit_tests
    eval "${args[@]}"
}

main "$@"
