#!/usr/bin/env bash

# GLOBAL VARIABLES ####################################################################################################

PID_PARENT=$(ps -o args= $PPID|grep "bash "|head -n1|awk '{ print $2 }')

# APT #################################################################################################################

# shellcheck disable=SC2001
function package_apt_info() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local package="$1"
    [[ -z $package ]] && echo "No package passed as parameter" && return 1
    # Initialize variables
    local apt_info="" package_remove="" package_install="" version_candidate="" version_installed=""
    local version_installed_number="" version_candidate_number="" maintainer="" description=""
    # Read information from apt-cache
    apt_info=$(apt-cache show "^$package$" 2>/dev/null)
    [[ -z $apt_info ]] && echo "Package $package not found" && return 2
    version_candidate=$(echo "$apt_info"|grep "Version"|head -n1|awk '{print $2}')
    # Maintainer
    maintainer=$(echo "$apt_info"|grep "Original-Maintainer"|head -n1|awk '{for(i=2;i<=NF;i++) printf $i" "; print ""}')
    # Remove mail address
    maintainer=$(echo "$maintainer"|sed -E 's/[^[:space:]]+@[^[:space:]]+//g')
    if [[ -z $maintainer ]]; then
        maintainer=$(echo "$apt_info"|grep "Maintainer"|head -n1|awk '{for(i=2;i<=NF;i++) printf $i" "; print ""}')
        # Remove mail address
        maintainer=$(echo "$maintainer"|sed -E 's/[^[:space:]]+@[^[:space:]]+//g')
        # Delete special characters
        maintainer=$(echo "$maintainer"|iconv -f utf8 -t ascii//TRANSLIT)
    fi
    # Whitespace Trimming
    maintainer=$(echo "$maintainer"|sed 's/^[   ]*//;s/[    ]*$//')
    description=$(echo "$apt_info"|grep "Description"|head -n1|awk '{for(i=2;i<=NF;i++) printf $i" "; print ""}')
    # remove " and ; in the description
    description="${description//\"/}" && description="${description//\;/}"
    # Delete special characters
    description=$(echo "$description"|iconv -f utf8 -t ascii//TRANSLIT)
    # Whitespace Trimming
    description=$(echo "$description"|sed 's/^[   ]*//;s/[    ]*$//')
    # Installed version
    if dpkg -s "$package" 2>/dev/null 1>/dev/null; then
        if ! dpkg -s "$package"|grep "^Status: deinstall" 1> /dev/null; then
            version_installed=$(dpkg -s "$package"|grep "^Version"|awk '{print $2}')
        fi
    fi
    [[ -z $version_candidate ]] && PACKAGE_ERROR="Candidate version for $package not found" && return 3
    # Extract the version value to display
    version_candidate=$(echo "$version_candidate"|sed -E 's/(\-|\+|\~).*//')
    version_installed=$(echo "$version_installed"|sed -E 's/(\-|\+|\~).*//')
    version_installed_number=$(echo "${version_installed//[^0-9]/}"|sed 's/^0*//')
    version_candidate_number=$(echo "${version_candidate//[^0-9]/}"|sed 's/^0*//')
    # Check if the package can be removed
    package_install=0 package_remove=0
    [[ -n $version_installed_number ]] && package_remove=1
    # Check if the package can be installed
    if [[ -z $version_installed_number ]] || [[ $version_installed_number -lt version_candidate_number ]]; then
        package_install=1
    fi
    echo "$package;$package_install;$package_remove;$version_candidate;$version_installed;$maintainer;$description;;;"
    return 0
}

function package_apt_update() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_package_apt "${FUNCNAME[0]}"
    # We do not continue in debug mode
    sudo apt update -qq 1>/dev/null 2>/dev/null
    return 0
}

function package_apt_install() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_package_apt "${FUNCNAME[0]} $*"
    local packages="${*:1}"
    [[ -z $packages ]] && die "No packages passed as parameter" && return 1
    # Trim to remove the whitespaces
    packages=$(echo "$packages"|sed -e 's/^[[:blank:]]*//' -e 's/[[:blank:]]*$//')
    # Install packages
    if [[ $SILENT -gt 0 ]]; then
        sudo apt install -qqy "$packages" 2>/dev/null 1>/dev/null
    else
        sudo apt install -qqy "$packages"
    fi
    return 0
}

function package_apt_remove() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_package_apt "${FUNCNAME[0]} $*"
    local packages="${*:1}"
    [[ -z $packages ]] && die "No packages passed as parameter" && return 1
    # Trim to remove the whitespaces
    packages=$(echo "$packages"|sed -e 's/^[[:blank:]]*//' -e 's/[[:blank:]]*$//')
    # Remove packages
    if [[ $SILENT -gt 0 ]]; then
        sudo apt remove -qqy "$packages" 2>/dev/null 1>/dev/null
    else
        sudo apt remove -qqy "$packages"
    fi
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
