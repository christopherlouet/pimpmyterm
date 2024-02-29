#!/usr/bin/env bash

# GLOBAL VARIABLES ####################################################################################################

PID_PARENT=$(ps -o args= $PPID|grep "bash "|head -n1|awk '{ print $2 }')

# OS ##################################################################################################################

function os_package_manager() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_os "${FUNCNAME[0]}"

    local dist=""
    DEFAULT_PACKAGE_MANAGER=""
    dist=$( (lsb_release -ds || cat /etc/*release || uname -om) 2>/dev/null | awk '{ print $1 }')

    case "$dist" in
        'Ubuntu') DEFAULT_PACKAGE_MANAGER="apt"
    esac

    debug_os "${COLORS[CYAN]}PACKAGE_MANAGER: ${COLORS[PINK]}$DEFAULT_PACKAGE_MANAGER"
    return 0
}

# MAIN ################################################################################################################

function main() {
    local args=()
    read -ra opts <<< "$@"
    for opt in "$@"; do
        case "$opt" in
            *) args+=("$opt") ;;
        esac
    done
    [[ -z "${args[0]}" ]] && die "No function to call" && return 1
    ! [[ $(type -t "${args[0]}") == function ]] && die "Function with name '${args[0]}' does not exist" && return 2
    eval "${args[@]}"
}

main "$@"
