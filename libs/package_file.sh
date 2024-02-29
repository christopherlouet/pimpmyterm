#!/usr/bin/env bash
# @name Package file
# @brief Managing package scripts.
# @description
#   This library contains a list of functions for managing package scripts.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LIB_PACKAGE_FILE="$LIBS_PATH/src/package_file.sh"
PACKAGES_PATH="$(dirname -- "$LIBS_PATH")/packages"

# @description Displays debug information for package_file library.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug_package_file() { debug_script "./libs/package_file.sh" "$*" ; }

# @description Read information from the package script.
# @arg $1 string Source name.
# @arg $2 string Category name.
# @arg $3 string Package name.
# @stdout Package information in the standard output.
# @exitcode 0 If successful.
# @exitcode 1 If no source passed as parameter.
# @exitcode 2 If no category passed as parameter.
# @exitcode 3 If no package passed as parameter.
# @exitcode 4 If no package folders found.
# @exitcode 5 If the package script is not found.
# @exitcode 6 If an error was found retrieving information from the script.
function package_file_info() { eval "$(bash "$LIB_PACKAGE_FILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Install prerequisites from the package script.
# @arg $1 string Category name.
# @arg $2 string Package name.
# @exitcode 0 If successful.
# @exitcode 1 If no category passed as parameter.
# @exitcode 2 If no package passed as parameter.
# @exitcode 3 If no package folders found.
# @exitcode 4 If the package script is not found.
function package_file_preinstall() { eval "$(bash "$LIB_PACKAGE_FILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Installing the package from the script.
# @arg $1 string Category name.
# @arg $2 string Package name.
# @exitcode 0 If successful.
# @exitcode 1 If no category passed as parameter.
# @exitcode 2 If no package passed as parameter.
# @exitcode 3 If no package folders found.
# @exitcode 4 If the package script is not found.
function package_file_install() { eval "$(bash "$LIB_PACKAGE_FILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Delete package from script.
# @arg $1 string Category name.
# @arg $2 string Package name.
# @exitcode 0 If successful.
# @exitcode 1 If no category passed as parameter.
# @exitcode 2 If no package passed as parameter.
# @exitcode 3 If no package folders found.
# @exitcode 4 If the package script is not found.
function package_file_remove() { eval "$(bash "$LIB_PACKAGE_FILE" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Main function.
# @arg $@ any Options passed as script parameters.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
function main() {
    [[ -n "${FUNCNAME[2]}" ]] && return 0
    source "$LIBS_PATH/common.sh"
    source "$LIBS_PATH/package_apt.sh"
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
