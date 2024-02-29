#!/usr/bin/env bash
# @name Package apt
# @brief Managing apt packages.
# @description
#   This library contains a list of functions for managing apt packages.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LIB_PACKAGE_APT="$LIBS_PATH/src/package_apt.sh"

# @description Displays debug information for package_apt library.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug_package_apt() { debug_script "./libs/package_apt.sh" "$*" ; }

# @description Read information from the apt package.
# @arg $1 string Package name.
# @stdout Package information in the standard output.
# @exitcode 0 If successful.
# @exitcode 1 If no package passed as parameter.
# @exitcode 2 If no package information is available.
# @exitcode 3 If no package version has been found.
function package_apt_info() { eval "$(bash "$LIB_PACKAGE_APT" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Update package manager index.
# @noargs
# @exitcode 0 If successful.
function package_apt_update() { eval "$(bash "$LIB_PACKAGE_APT" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Installing a package from the package manager.
# @arg $1 string Packages name.
# @set SILENT integer If 1, do not display installation details.
# @exitcode 0 If successful.
function package_apt_install() { eval "$(bash "$LIB_PACKAGE_APT" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Remove a package from the package manager.
# @arg $1 string Packages name.
# @set SILENT integer If 1, do not display package deletion details.
# @exitcode 0 If successful.
function package_apt_remove() { eval "$(bash "$LIB_PACKAGE_APT" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

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
