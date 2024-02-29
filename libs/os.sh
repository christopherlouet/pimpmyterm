#!/usr/bin/env bash
# @name OS
# @brief Utility library for distribution information.
# @description
#   This library contains a list of functions for obtaining distribution information.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LIB_OS="$LIBS_PATH/src/os.sh"
DEFAULT_PACKAGE_MANAGER=""

# @description Displays debug information for os library.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug_os() { debug_script "./libs/os.sh" "$*" ; }

# @description Get the package manager.
# @noargs
# @set DEFAULT_PACKAGE_MANAGER string Name of the package manager.
# @exitcode 0 If successful.
function os_package_manager() { eval "$(bash "$LIB_OS" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

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
            *) args+=("$opt") ;;
        esac
    done
    [[ -z "${args[0]}" ]] && die "No function to call" && return 1
    ! [[ $(type -t "${args[0]}") == function ]] && die "Function with name '${args[0]}' does not exist" && return 2
    eval "${args[@]}"
}

main "$@"
