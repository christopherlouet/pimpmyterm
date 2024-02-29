#!/usr/bin/env bash
# @file profile.sh
# @brief Profile configuration.
# @description
#   This library manages application profiles.

# GLOBAL VARIABLES ####################################################################################################

PID_PARENT=$(ps -o args= $PPID|grep "bash "|head -n1|awk '{ print $2 }')

# PROFILE #############################################################################################################

function profile_read_config() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_profile "${FUNCNAME[0]}"
    ! [[ -f "$PROFILE_CONFIG_FILE" ]] && die "Profile configuration file not found!" && return 1
    # Global section
    local global=0 section_global="global"
    local key_last_update="last_update" key_banner="banner" key_theme="theme"
    local last_update="" read_banner=0 banner="" theme=""
    # Read the profile config file
    while read -r line; do
        # Skip comments
        [[ "$line" =~ ^(\#|\;) ]] && continue
        # Read this global section
        [[ "$line" =~ ^\[${section_global}\]$ ]] && global=1 && continue
        # Do not read other sections
        [[ "$line" =~ ^\[.* ]] && [[ $global -gt 0 ]] && break
         # Read the content of the global section
        if [[ $global -gt 0 ]]; then
            # Last update
            [[ "$line" =~ ^${key_last_update}=.* ]] && last_update=$(echo "$line"|awk -F= '{print $2}') && continue
            # Theme
            [[ "$line" =~ ^${key_theme}=.* ]] && theme=$(echo "$line"|awk -F= '{print $2}') && continue
            # Prompt header
            if [[ "$line" =~ ^${key_banner}=.* ]]; then
                read_banner=1
                banner="$(echo "$line"|awk -F= '{print $2}')"
                banner="$(echo "$banner"|tr -d '"'|sed -e 's/^[[:blank:]]*//' -e 's/[[:blank:]]*$//')$"
                continue
            fi
            if [[ $read_banner -gt 0 ]] && [[ -n ${line//[[:blank:]]*/} ]]; then
                banner+="$(echo "$line"|tr -d '"'|sed -e 's/^[[:blank:]]*//' -e 's/[[:blank:]]*$//')$"
                continue
            fi
        fi
    done <"$PROFILE_CONFIG_FILE"
    # Set the global variables
    [[ -n $last_update ]] && LAST_UPDATE=${last_update//\"/}
    [[ -n $theme ]] && THEME=${theme//\"/}
    [[ -n $banner ]] && BANNER=$banner
    # Debug the global variables
    debug_profile "${COLORS[CYAN]}LAST_UPDATE: ${COLORS[PINK]}$LAST_UPDATE"
    debug_profile "${COLORS[CYAN]}THEME: ${COLORS[PINK]}$THEME"
    [[ -n $BANNER ]] && debug_profile "${COLORS[CYAN]}BANNER: ${COLORS[PINK]}true"
    [[ -z $BANNER ]] && debug_profile "${COLORS[CYAN]}BANNER: ${COLORS[PINK]}false"
    return 0
}

function profile_read_packages() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_profile "${FUNCNAME[0]} $(display_opts)"
    local section="" category="" category_search="" title="" title_search="" source="" name="" enabled=""
    local section_global="global" line="" skip_read_section=1
    # Check profile config file
    ! [[ -f $PROFILE_CONFIG_FILE ]] && die "Profile configuration file not found!" && return 1
    # Reset the packages list
    PROFILE_PACKAGES=()
    # Search a package
    local search_packages="" search_packages_lower=""
    if [[ ${#SEARCH_PACKAGES[@]} -gt 0 ]]; then
        for i in "${!SEARCH_PACKAGES[@]}"; do
            [[ -z ${SEARCH_PACKAGES[$i]} ]] && continue
            search_packages_lower=$(echo "${SEARCH_PACKAGES[$i]}" | awk '{print tolower($0)}')
            [[ $i -eq 0 ]] && search_packages="$search_packages_lower" && continue
            search_packages+="|$search_packages_lower"
        done
        search_packages=("($search_packages)")
    fi
    # Read the profile config file
    while read -r line; do
        # Skip comments
        [[ "$line" =~ ^(\#|\;) ]] && continue
        # Skip empty line
        [[ -z "${line// /}" ]] && continue
        # Skip the global section
        [[ "$line" =~ ^\[${section_global}\]$ ]] && skip_read_section=1 && continue
        # Read a section
        if [[ "$line" =~ ^\[.* ]]; then
            # Skip global section line
            [[ "$line" =~ ^\[global]$ ]] && continue
            # Adding the previous section if it exist
            [[ $skip_read_section -eq 0 ]] && profile_add_package
            # To check if this package is found in the profile file
            skip_read_section=0
            section=$(echo "$line"|tr -d '[]"')
            category=$(echo "$section"|awk '{print $1}'|sed -e 's/^[[:blank:]]*//' -e 's/[[:blank:]]*$//')
            title=$(echo "$section"|awk '{$1=""; print $0}'|sed -e 's/^[[:blank:]]*//' -e 's/[[:blank:]]*$//')
            # Search a package by category
            category_search=$(echo "$category" | awk '{print tolower($0)}')
            # Search a package by title
            title_search=$(echo "$title" | awk '{print tolower($0)}')
            title_search=${title_search// /}
            source="" name="" enabled=""
            # Do not search if packages are reset
            [[ "$PACKAGES_INIT" -gt 0 ]] && continue
            ! [[ $category_search =~ ${SEARCH_CATEGORY} ]] && skip_read_section=1 && continue
            # shellcheck disable=SC2128
            ! [[ $title_search =~ $search_packages ]] && skip_read_section=1 && continue
            continue
        fi
        # Getting the attributes if necessary
        if [[ $skip_read_section -eq 0 ]]; then
            [[ "$line" =~ ^source=.* ]] && source=$(echo "$line"|awk -F= '{print $2}') && continue
            [[ "$line" =~ ^name=.* ]] && name=$(echo "$line"|awk -F= '{print $2}') && continue
            [[ "$line" =~ ^enabled=.* ]] && enabled=$(echo "$line"|awk -F= '{print $2}') && continue
        fi
    done <"$PROFILE_CONFIG_FILE"
    # Adding the last found section
    [[ $skip_read_section -eq 0 ]] && profile_add_package
    [[ ${#PROFILE_PACKAGES} -eq 0 ]] && die "No package found!" && return 2
    debug_profile "${COLORS[CYAN]}PROFILE_PACKAGES: ${COLORS[PINK]}${#PROFILE_PACKAGES[@]}"
    return 0
}

function profile_add_package() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    # Check enabled value
    [[ ${enabled:-1} =~ ^(1|true|True|yes|Yes) ]] && enabled=1 || enabled=0
     # Default source
    [[ -z $source ]] && source="dist"
    # Default name
    [[ -z $name ]] && name="$title"
    PROFILE_PACKAGES+=("$enabled;$category;$title;$name;$source")
    return 0
}

function profile_update_packages() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_profile "${FUNCNAME[0]}"
    ! [[ -f $PROFILE_CONFIG_FILE ]] && die "Profile configuration file not found!" && return 1
    [[ ${#PACKAGES_DISPLAY} -eq 0 ]] && die "No package found!" && return 2
    info "Update package information"
    # Declare variables
    local package_update="" enabled="" category="" title="" name="" source=""
    local line_section="" line_category="" line_name=""
    local current_line=0 section_line=0 section_last_line=0
    local update_section=0 update_source=0 update_name=0 update_enabled=0
    local profile_tmp_file="/tmp/$PROFILE" last_line_empty=0
    # Read updated package information
    for package_update in "${PACKAGES_DISPLAY[@]}"; do
        # Create a copy of the profile file
        cp "$PROFILE_CONFIG_FILE" "$profile_tmp_file"
        last_line_empty=$(awk 'END{print ($0=="" ? "1" : "0")}' "$profile_tmp_file")
        [[ $last_line_empty -eq 0 ]] && echo "">>"$profile_tmp_file"
        # Read columns
        IFS=$";" read -ra columns <<< "$package_update"; unset IFS
        enabled=${columns[0]} category=${columns[1]} title=${columns[2]} name=${columns[3]} source=${columns[4]}
        # Initialize variables
        current_line=0 update_enabled=0
        update_section=0 update_source=0 update_name=0
        # Read the profile config file
        while read -r line; do
            current_line=$((current_line+1))
            # Skip comments
            [[ "$line" =~ ^(\#|\;) ]] && continue
            # Skip empty line
            [[ -z "${line// /}" ]] && continue
            # Read a new section
            if [[ "$line" =~ ^\[.* ]]; then
                # If the section has been read in its entirety, complete with the remaining information
                if [[ $update_section -gt 0 ]]; then
                    profile_merge_section
                    update_section=0 section_line=$current_line section_last_line=$current_line
                    break
                fi
                line_section=$(echo "$line"|tr -d '[]"')
                line_category=$(echo "$line_section"|awk '{print $1}'|sed -e 's/^[[:blank:]]*//' -e 's/[[:blank:]]*$//')
                line_name=$(echo "$line_section"|awk '{$1=""; print $0}'|sed -e 's/^[[:blank:]]*//' -e 's/[[:blank:]]*$//')
                if [[ "$line_category" = "$category" ]] && [[ "$line_name" = "$title" ]]; then
                    section_line=$current_line && section_last_line=$current_line && update_section=1 && continue
                fi
            fi
            # Replace values by the new infos
            [[ $update_section -gt 0 ]] && profile_update_section
        done <"$PROFILE_CONFIG_FILE"
        # At the end of the file, complete with the remaining information
        [[ $update_section -gt 0 ]] && profile_merge_section
        # Replace the current profile file
        last_line_empty=$(awk 'END{print ($0=="" ? "1" : "0")}' "$profile_tmp_file")
        [[ $last_line_empty -gt 0 ]] && sed -i '$ d' "$profile_tmp_file"
        cp "$profile_tmp_file" "$PROFILE_CONFIG_FILE"
    done
    return 0
}

function profile_update_section() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    if [[ "$line" =~ ^source=.* ]]; then
        sed -i "${current_line}s/^source=.*/source=$source/g" "$profile_tmp_file"
        update_source=1
    fi
    if [[ "$line" =~ ^name=.* ]]; then
        sed -i "${current_line}s/^name=.*/name=$name/g" "$profile_tmp_file"
        update_name=1
    fi
    if [[ "$line" =~ ^enabled=.* ]]; then
        sed -i "${current_line}s/^enabled=.*/enabled=$enabled/g" "$profile_tmp_file"
        update_enabled=1
    fi
    section_last_line=$current_line
    return 0
}

function profile_merge_section() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local section_update_line=$((section_last_line+1))
    if [[ $update_source -eq 0 ]]; then
        sed -i "$((section_line+1)) i source=$source" "$profile_tmp_file"
    fi
    if [[ $update_name -eq 0 ]]; then
        sed -i "$((section_line+2)) i name=$name" "$profile_tmp_file"
    fi
    if [[ $update_enabled -eq 0 ]] && [[ $enabled -eq 0 ]]; then
        sed -i "$((section_line+3)) i enabled=0" "$profile_tmp_file"
    fi
    return 0
}

function profile_update_theme() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_profile "${FUNCNAME[0]} $PROFILE_CONFIG_FILE $THEME"
    ! [[ -f $PROFILE_CONFIG_FILE ]] && die "Profile configuration file not found!" && return 1
    [[ -z $THEME ]] && die "Theme not found!" && return 2
    local current_line=0 theme_line=0 global_section_line=0
    # Global section
    local section_global="global" key_theme="theme"
    while read -r line; do
        current_line=$((current_line+1))
        # Skip comments
        [[ "$line" =~ ^(\#|\;) ]] && continue
        # Read global section
        if [[ "$line" =~ ^\[${section_global}]$ ]]; then
            global_section_line=$current_line
            continue
        fi
        # Read the global section
        if [[ $global_section_line -gt 0 ]]; then
            [[ "$line" =~ ^${key_theme}=.* ]] && theme_line=$current_line && break
        fi
    done <"$PROFILE_CONFIG_FILE"
    # Create the global section if necessary
    if [[ $global_section_line -eq 0 ]]; then
        sed -i "1 i [${section_global}]" "$PROFILE_CONFIG_FILE"
        sed -i "2 i ${key_theme}=$THEME\n" "$PROFILE_CONFIG_FILE"
        return 0
    fi
    # Create the attribute if necessary
    if [[ $theme_line -eq 0 ]]; then
        theme_line=$((global_section_line+2))
        sed -i "$theme_line i ${key_theme}=$THEME\n" "$PROFILE_CONFIG_FILE"
        return 0
    fi
    # Updating the attribute
    sed -i "${theme_line}s/^${key_theme}=.*/${key_theme}=$THEME/g" "$PROFILE_CONFIG_FILE"
    return 0
}

function profile_update_last_update() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_profile "${FUNCNAME[0]}"
    ! [[ -f $PROFILE_CONFIG_FILE ]] && die "Profile configuration file not found!" && return 1
    local last_update="" current_line=0 last_update_line=0 global_section_line=0
    # Global section
    local section_global="global" key_last_update="last_update"
    # Last update value
    last_update=$(date '+%Y%m%d')
    # Read the profile config file
    while read -r line; do
        current_line=$((current_line+1))
        # Skip comments
        [[ "$line" =~ ^(\#|\;) ]] && continue
        # Skip empty line
        [[ -z "${line// /}" ]] && continue
        # Read global section
        if [[ "$line" =~ ^\[${section_global}]$ ]]; then
            global_section_line=$current_line
            continue
        fi
        # Read the global section
        if [[ $global_section_line -gt 0 ]]; then
            [[ "$line" =~ ^${key_last_update}=.* ]] && last_update_line=$current_line && break
        fi
    done <"$PROFILE_CONFIG_FILE"
    # Create the global section if necessary
    if [[ $global_section_line -eq 0 ]]; then
        sed -i "1 i [${section_global}]" "$PROFILE_CONFIG_FILE"
        sed -i "2 i ${key_last_update}=$last_update\n" "$PROFILE_CONFIG_FILE"
        return 0
    fi
    # Create the attribute if necessary
    if [[ $last_update_line -eq 0 ]]; then
        last_update_line=$((global_section_line+1))
        sed -i "$last_update_line i ${key_last_update}=$last_update\n" "$PROFILE_CONFIG_FILE"
        return 0
    fi
    # Updating the attribute
    sed -i "${last_update_line}s/^${key_last_update}=.*/${key_last_update}=$last_update/g" "$PROFILE_CONFIG_FILE"
    LAST_UPDATE=$last_update
    return 0
}

function profile_create() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    ! [[ -f $CONFIG_FILE_PATH ]] && die "Configuration file not found! ($CONFIG_FILE_PATH)" && return 1
    debug_profile "${FUNCNAME[0]}"
    local answer="" check_profile_name=0 check_profile_exists=0
    while [[ $check_profile_name -eq 0 ]]; do
        confirm_message "Enter a name of profile"
        read -ra answer_profile_name <<< "$answer"
        # Check answer
        if [[ "${#answer_profile_name[@]}" -eq 0 ]]; then
            die "Profile name cannot be empty" && continue
            profile_create
        fi
        if [[ "${#answer_profile_name[@]}" -gt 1 ]]; then
            die "Profile name must not contain spaces" && continue
        fi
        local profile_name=${answer_profile_name[0]}
        if [[ $profile_name =~ ['|!@#$;%^&*()+'] ]]; then
            die "The profile name must not contain special characters"  && continue
        fi
        # Check if the profile already exists
        ! config_profile_list && return 1
        check_profile_exists=0
        for profile in "${PROFILE_LIST[@]}"; do
            if [[ $check_profile_exists -eq 0 ]] && [[ "$profile" = "$profile_name" ]]; then
                die "This profile name already exists"
                check_profile_exists=1
            fi
        done
        [[ $check_profile_exists -gt 0 ]] && continue
        check_profile_name=1
    done
    # Set global variables
    local profile_config_file="${profile_name}.ini"
    PROFILE=$profile_name
    PROFILE_CONFIG_FILE="$PROFILES_PATH/$profile_config_file"
    info "Updating the configuration file"
    {
        echo -e "\n[profile \"$profile_name\"]"
        echo "config_file=$profile_config_file"
    } >> "$CONFIG_FILE_PATH"
    info "Create the new profile configuration file"
    ! [[ -f $profile_config_file ]] && touch "$PROFILE_CONFIG_FILE"
    success "The new profile $PROFILE has been created successfully!"
    info "Edit the $PROFILE_CONFIG_FILE file to add new packages"
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
