#!/usr/bin/env bash

# GLOBAL VARIABLES ####################################################################################################

PID_PARENT=$(ps -o args= $PPID|grep "bash "|head -n1|awk '{ print $2 }')

# CONFIG ##############################################################################################################

function config_read() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_config "${FUNCNAME[0]} $CONFIG_FILE_PATH"
    ! [[ -f $CONFIG_FILE_PATH ]] && die "Configuration file not found! ($CONFIG_FILE_PATH)" && return 1
    ! [[ -d $PROFILES_PATH ]] && die "Profile path not found! ($PROFILES_PATH)" && return 2
    # Global section
    local global=0 section_global="global" key_profile="profile"
    # Read the config file
    while read -r line; do
        # Skip comments
        [[ "$line" =~ ^(\#|\;) ]] && continue
        # Read global section
        if [[ "$line" =~ ^\[${section_global}\]$ ]]; then
            global=1 && continue
        fi
        # Read the content of the global section
        if [[ $global -gt 0 ]]; then
            [[ "$line" =~ ^${key_profile}=.* ]] && PROFILE=$(echo "${line//\"/}"|awk -F= '{print $2}') && continue
        fi
    done <"$CONFIG_FILE_PATH"
    # Check profile
    [[ -z $PROFILE ]] && die "Profile not found!" && return 3
    # Check profile configuration file
    PROFILE_CONFIG_FILE="$PROFILES_PATH/${PROFILE}.ini"
    ! [[ -f "$PROFILE_CONFIG_FILE" ]] && die "Profile configuration file not found! ($PROFILE_CONFIG_FILE)" && return 4
    debug_config "${COLORS[CYAN]}PROFILE: ${COLORS[PINK]}$PROFILE"
    debug_config "${COLORS[CYAN]}PROFILE_CONFIG_FILE: ${COLORS[PINK]}$PROFILE_CONFIG_FILE"
    test "CONFIG_FILE_PATH $CONFIG_FILE_PATH"
    test "PROFILE $PROFILE"
    test "PROFILE_CONFIG_FILE $PROFILE_CONFIG_FILE"
    return 0
}

# PROFILE #############################################################################################################

function config_profile_list() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_config "${FUNCNAME[0]} $CONFIG_FILE_PATH"
    ! [[ -d $PROFILES_PATH ]] && die "Profile path not found! ($PROFILES_PATH)" && return 1
    PROFILE_LIST=()
    local profile_file_path="" profile_file_name="" profile=""
    for profile_file_path in "$PROFILES_PATH"/*; do
        ! [[ -f $profile_file_path ]] && continue
        profile_file_name=${profile_file_path##*/}
        profile="${profile_file_name%.ini}"
        [[ -n $profile ]] && PROFILE_LIST+=("$profile")
    done
    [[ ${#PROFILE_LIST[@]} -eq 0 ]] && die "No profile found!" && return 2
    test "${#PROFILE_LIST[@]}"
    return 0
}

function config_profile_update() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_config "${FUNCNAME[0]} $CONFIG_FILE_PATH $PROFILE"
    ! [[ -f $CONFIG_FILE_PATH ]] && die "Configuration file not found! ($CONFIG_FILE_PATH)" && return 1
    [[ -z $PROFILE ]] && die "Profile not found!" && return 2
    # Section
    local global=0 section_global="global" key_profile="profile"
    # Read the config file
    local line_replace_num=0 line_num=0
    while read -r line; do
        line_num=$((line_num+1))
        # Skip comments
        [[ "$line" =~ ^(\#|\;) ]] && continue
        # Read this global section
        [[ "$line" =~ ^\[${section_global}\]$ ]] && global=1 && continue
        # Read the content of the global section
        if [[ $global -gt 0 ]] && [[ "$line" =~ ^${key_profile}=.* ]]; then
            line_replace_num=$line_num && break
        fi
    done <"$CONFIG_FILE_PATH"
    # The old profile was not found
    if [ $line_replace_num -eq 0 ]; then
        die "The $key_profile field was not found in the $section_global section" && return 3
    fi
    # Display line number to be modified for unit tests
    if [[ $TEST -gt 0 ]]; then
        echo $line_replace_num
        return 0
    fi
    # Replace value by the current profile
    sed -i "${line_replace_num}s/^${key_profile}=.*/${key_profile}=${PROFILE}/g" "$CONFIG_FILE_PATH"
    return 0
}

# THEME ###############################################################################################################

function config_theme_list() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_config "${FUNCNAME[0]} $THEMES_PATH"
    ! [[ -d $THEMES_PATH ]] && die "Theme path not found! ($THEMES_PATH)" && return 1
    THEME_LIST=()
    local theme_file_path="" theme_file_name="" theme=""
    for theme_file_path in "$THEMES_PATH"/*; do
        ! [[ -f $theme_file_path ]] && continue
        theme_file_name=${theme_file_path##*/}
        theme="${theme_file_name%.sh}"
        [[ -n $theme ]] && THEME_LIST+=("$theme")
    done
    [[ ${#THEME_LIST} -eq 0 ]] && die "No theme found!" && return 2
    test "${#THEME_LIST[@]}"
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
