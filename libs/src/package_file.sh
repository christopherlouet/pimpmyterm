#!/usr/bin/env bash

# GLOBAL VARIABLES ####################################################################################################

PID_PARENT=$(ps -o args= $PPID|grep "bash "|head -n1|awk '{ print $2 }')

# PACKAGES ############################################################################################################

# shellcheck disable=SC2181
# shellcheck disable=SC2001
function package_file_info() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local source="$1" category="$2" package="$3"
    local version_candidate="" version_installed="" maintainer="" description=""
    local package_install="" package_remove="" pre_install=""
    local package_info="" package_path="" category_lower=""
    [[ -z $source ]] && echo "No source passed as parameter" && return 1
    [[ -z $category ]] && echo "No category passed as parameter" && return 2
    [[ -z $package ]] && echo "No package passed as parameter" && return 3
    [[ ! -d "$PACKAGES_PATH" ]] && echo "No package folders found" && return 4
    # Path to script file
    category_lower=$(echo "$category" | awk '{print tolower($0)}')
    package_path="$PACKAGES_PATH/$category_lower/${package}.sh"
    # Do not continue if the package file does not exist, if the source is dist
    if [[ "$source" = "dist" ]]; then
        ! [[ -f "$package_path" ]] && return 0
    fi
    # Check if the package file exists, if the source is file
    if [[ "$source" = "file" ]]; then
        if ! [[ -f "$package_path" ]]; then
            echo "Script $package_path does not exist"
            return 5
        fi
    fi
    # Read information from the script
    local package_file_result=""
    package_file_result=$(bash "${package_path}" package_info 2> /dev/null)
    [[ $? -gt 0 ]] && echo "$package_file_result" && return 6
    IFS=$";" read -ra package_file_infos <<< "${package_file_result}"; unset IFS
    # INFO="dist" => Check information from package manager
    if [[ "${package_file_infos[1]}" = "dist" ]]; then
        if package_apt_infos_result=$(package_apt_info "${package_file_infos[0]}"); then
            IFS=$";" read -ra package_apt_infos <<< "${package_apt_infos_result}"; unset IFS
            version_installed=${package_apt_infos[4]}
            version_installed=$(echo "$version_installed"|sed -E 's/(\-|\+|\~).*//')
            # If the package script does not contain the candidate version, it can be retrieved with apt
            if [[ -z ${package_file_infos[2]} ]]; then
                version_candidate=${package_apt_infos[3]}
                version_candidate=$(echo "$version_candidate"|sed -E 's/(\-|\+|\~).*//')
            else
                version_candidate=${package_file_infos[2]}
                version_candidate=$(echo "$version_candidate"|sed -E 's/(\-|\+|\~).*//')
                if [[ -z $version_installed ]]; then
                    if ! bash "${package_path}" check_install 2> /dev/null > /dev/null; then
                        version_installed=$version_candidate
                    fi
                fi
            fi
            maintainer=${package_apt_infos[5]}
            description=${package_apt_infos[6]}
        fi
    # Check information from package file
    else
        [[ -n ${package_file_infos[2]} ]] && version_candidate=${package_file_infos[2]}
        [[ -n ${package_file_infos[3]} ]] && maintainer=${package_file_infos[3]}
        [[ -n ${package_file_infos[4]} ]] && description=${package_file_infos[4]}
        # Check if the package is installed
        if ! bash "${package_path}" check_install 2> /dev/null > /dev/null; then
            [[ -z $version_installed ]] && version_installed=$version_candidate
        fi
    fi
    # Clean maintainer
    if [[ -n $maintainer ]]; then
        maintainer=$(echo "$maintainer"|iconv -f utf8 -t ascii//TRANSLIT)
    fi
    # Clean description
    if [[ -n $description ]]; then
        # remove " and ; in the description
        description="${description//\"/}" && description="${description//\;/}"
        # Delete special characters
        description=$(echo "$description"|iconv -f utf8 -t ascii//TRANSLIT)
    fi
    # Read preinstall information
    pre_install=${package_file_infos[5]}
    # Check if the package can be removed or installed
    version_installed_number=$(echo "${version_installed//[^0-9]/}"|sed 's/^0*//')
    version_candidate_number=$(echo "${version_candidate//[^0-9]/}"|sed 's/^0*//')
    [[ -n $version_installed_number ]] && package_remove=1
    package_install=0
    if [[ -n $version_candidate_number ]]; then
        if [[ -z $version_installed_number ]] || [[ $version_installed_number -lt version_candidate_number ]]; then
            package_install=1
        fi
    fi
    [[ -z $package_install ]] && package_install=0
    [[ -z $package_remove ]] && package_remove=0
    # Updating package information
    package_info="$package;$package_install;$package_remove;$version_candidate;$version_installed;"
    # Infos from script file
    package_info+="$maintainer;$description;$pre_install"
    echo "$package_info"
    return 0
}

function package_file_preinstall() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_package_file "${FUNCNAME[0]} $*"
    local category="$1" package="$2"
    [[ -z $category ]] && die "No category passed as parameter!" && return 1
    [[ -z $package ]] && die "No package passed as parameter!" && return 2
    ! [[ -d "$PACKAGES_PATH" ]] && die "No package folders found!" && return 3
    local package_path="$PACKAGES_PATH/$category/${package}.sh"
    # No script found
    ! [[ -f "$package_path" ]] && return 4
    # Install prerequisites
    if ! bash "${package_path}" pre_install; then
        return 5
    fi
    return 0
}

# shellcheck disable=SC2181
function package_file_install() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_package_file "${FUNCNAME[0]} $*"
    local category="$1" package="$2"
    [[ -z $category ]] && die "No category passed as parameter!" && return 1
    [[ -z $package ]] && die "No package passed as parameter!" && return 2
    ! [[ -d "$PACKAGES_PATH" ]] && die "No package folders found!" && return 3
    local package_path="$PACKAGES_PATH/$category/${package}.sh"
    ! [[ -f "$package_path" ]] && die "No package script found!" && return 4
    # Proceed to install
    if [[ $SILENT -gt 0 ]]; then
        bash "${package_path}" install --theme="$THEME" --silent
    else
        bash "${package_path}" install --theme="$THEME"
    fi
    return 0
}

# shellcheck disable=SC2181
function package_file_remove() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_package_file "${FUNCNAME[0]} $*"
    local category="$1" package="$2"
    [[ -z $category ]] && die "No category passed as parameter!" && return 1
    [[ -z $package ]] && die "No package passed as parameter!" && return 2
    ! [[ -d "$PACKAGES_PATH" ]] && die "No package folders found!" && return 3
    local package_path="$PACKAGES_PATH/$category/${package}.sh"
    ! [[ -f "$package_path" ]] && die "No package script found!" && return 4
    # Proceed to remove
    if [[ $SILENT -gt 0 ]]; then
        bash "${package_path}" remove --theme="$THEME" --silent
    else
        bash "${package_path}" remove --theme="$THEME"
    fi
    return 0
}

# @description Main function.
# @arg $@ any Function name and options.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
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
