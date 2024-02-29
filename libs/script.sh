#!/usr/bin/env bash
# @name Script
# @brief Script file configuration.
# @description
#   Utility library used by package scripts to facilitate installation.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LIB_PACKAGE_FILE="$LIBS_PATH/package_file.sh"
PACKAGES_PATH="$(dirname -- "$LIBS_PATH")/packages"

# shellcheck source=./libs/common.sh
source "$LIBS_PATH/common.sh"
# shellcheck source=./libs/os.sh
source "$LIBS_PATH/os.sh"
# shellcheck source=./libs/packages.sh
source "$LIBS_PATH/packages.sh"
# shellcheck source=./libs/package_apt.sh
source "$LIBS_PATH/package_apt.sh"

# @description Main function called by the package script to determine the action to be performed.
# @arg $@ any Options passed as script parameters.
# @set HELP integer Displays help if set to 1.
# @set INSTALL integer Installing package if set to 1.
# @set PRE_INSTALL integer Installing prerequisites if set to 1.
# @set REMOVE integer Removing package if set to 1.
# @set SILENT integer Do not display installation details if set to 1.
# @set CHECK integer Check if the package is installed if set to 1.
# @set DEBUG integer 1 if debug mode is enabled.
# @exitcode 0 If successful.
# @exitcode 1 If the script not has the function check_install.
# @exitcode 2 If function passed as parameter does not exist
# @exitcode 3 If function with name help does not exist.
# @exitcode 4 If Function with name install does not exist.
# @exitcode 5 If function with name pre_install does not exist.
# @exitcode 6 If function with name remove does not exist.
# @exitcode 7 If function with name check_install does not exist.
function main() {
    local args=()
    HELP=0 INSTALL=0 PRE_INSTALL=0 REMOVE=0 SILENT=0 CHECK=0 DEBUG=0 THEME=""
    for opt in "$@"; do
        case "$opt" in
            --help|-h) HELP=1 ;;
            --install|-i) INSTALL=1 ;;
            --preinstall|-I) PRE_INSTALL=1 ;;
            --remove|-r) REMOVE=1 ;;
            --silent|-s) SILENT=1 ;;
            --check) CHECK=1 ;;
            --debug|-d) DEBUG=1 ;;
            --theme=*|-t=*) THEME=$(echo "$opt"|awk -F= '{print $2}') ;;
            *) args+=("$opt") ;;
        esac
    done
    # Apply the theme if necessary
    # shellcheck source=./themes/$THEME.sh
    [[ -f "$THEMES_PATH/$THEME.sh" ]] && source "$THEMES_PATH/$THEME.sh"
    # Display the help menu if no function is passed as a parameter and no option is recognized
    if [[ -z "${args[0]}" ]] && [[ $((HELP+INSTALL+PRE_INSTALL+REMOVE+CHECK)) -eq 0 ]]; then
        HELP=1
    fi
    # Display the help menu
    if [[ $HELP -gt 0 ]]; then
        if ! [[ $(type -t "help") == function ]]; then
            warning "Function with name help does not exist"
            return 3
        fi
        eval "help"
        return $?
    fi
    # Get package information
    if [[ $(type -t "package_information") == function ]]; then
        eval "package_information"
    fi
    # Install the package
    if [[ $INSTALL -gt 0 ]]; then
        if ! [[ $(type -t "install") == function ]]; then
            warning "Function with name install does not exist"
            return 4
        fi
        eval "install" "${args[@]}"
        return $?
    fi
    # Installing prerequisites
    if [[ $PRE_INSTALL -gt 0 ]]; then
        if ! [[ $(type -t "pre_install") == function ]]; then
            warning "Function with name pre_install does not exist"
            return 5
        fi
        eval "pre_install" "${args[@]}"
        return $?
    fi
    # Remove the package
    if [[ $REMOVE -gt 0 ]]; then
        if ! [[ $(type -t "remove") == function ]]; then
            warning "Function with name remove does not exist"
            return 6
        fi
        eval "remove" "${args[@]}"
        return $?
    fi
    # Check the package is installed
    if [[ $CHECK -gt 0 ]]; then
        if ! [[ $(type -t "check_install") == function ]]; then
            warning "Function with name check_install does not exist"
            return 7
        fi
        eval "check_install"
        return $?
    fi
    # Check function name if not present in script
    if ! [[ $(type -t "${args[0]}") == function ]]; then
        # Read package information from script
        if [[ "${args[0]}" = "package_info" ]]; then
            local package="" && package=$(basename "$0") && package="${package%.*}"
            local pre_install=0
            [[ -n $PACKAGE ]] && package="$PACKAGE"
            MAINTAINER=$(echo "$MAINTAINER"|sed -E 's/[^[:space:]]+@[^[:space:]]+//g')
            [[ $(type -t "pre_install") == function ]] && pre_install=1
            local package_file_info="$package;$INFO;$VERSION;$MAINTAINER;$DESCRIPTION;$pre_install"
            echo "$package_file_info"
            return 0
        fi
        # Check if the script has the function 'check_install'
        [[ "${args[0]}" = "check_install" ]] && return 1
        # Function name does not exist
        die "Function with name ${args[0]} does not exist" && return 2
    fi
    # Execution function with arguments
    eval "${args[@]}"
    return $?
}
