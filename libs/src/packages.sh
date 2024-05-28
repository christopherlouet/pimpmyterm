#!/usr/bin/env bash

PID_PARENT=$(ps -o args= $PPID|grep "bash "|head -n1|awk '{ print $2 }')
CACHE_PATH=""


function packages_read_init() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    PACKAGES_INIT=1
    ! packages_read && return 1
    return 0
}

function packages_read() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]} $(display_opts)"
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
    [[ -z $PROFILE ]] && die "Profile not found!" && return 1
    # Removing the cache path if necessary
    PACKAGES_INIT=${PACKAGES_INIT:-0}
    # Check the cache path
    [[ ! -d "$CACHE_PATH" ]] && mkdir -p "$CACHE_PATH"
    [[ ! -f "$CACHE_PATH/$PROFILE" ]] && PACKAGES_INIT=1
    # Check the last update
    [[ -z $LAST_UPDATE ]] && PACKAGES_INIT=1
    # Cache update if necessary
    if [[ $PACKAGES_INIT -gt 0 ]]; then
        ! packages_update && return 2
        confirm_continue "Press a key to continue"
        return 0
    fi
    ! [[ -f "$CACHE_PATH/$PROFILE" ]] && die "Check that the cache file exists" && return 3
    # Initialize the packages
    PACKAGES_DISPLAY=() PACKAGES_INSTALL=() PACKAGES_REMOVE=()
    local search=0
    if [[ -n $SEARCH_PACKAGES ]] || [[ -n $SEARCH_CATEGORY ]]; then
        search=1
    fi
    # Read all packages from the cache file
    local package="" package_fields=() enabled="" package_install="" package_remove=""
    PACKAGES=()
    while read -r package; do
        PACKAGES+=("$package")
        [[ $search -gt 0 ]] && ! packages_read_search && continue
        PACKAGES_DISPLAY+=("$package")
        IFS=$";" read -ra package_fields <<< "${package}"; unset IFS
        enabled=${package_fields[2]}
        package_install=${package_fields[3]}
        package_remove=${package_fields[4]}
        if [[ $enabled -gt 0 ]]; then
            [[ $package_install -gt 0 ]] && PACKAGES_INSTALL+=("$package")
            [[ $package_remove -gt 0 ]] && PACKAGES_REMOVE+=("$package")
        fi
    done <"$CACHE_PATH/$PROFILE"
    return 0
}

function packages_read_search() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local fields=()
    local category="" category_search="" title="" title_search=""
    IFS=$";" read -ra fields <<< "${package}"; unset IFS
    # Search a package by category
    category=${fields[0]}
    category_search=$(echo "$category" | awk '{print tolower($0)}')
    # Search a package by title
    title=${fields[1]}
    title_search=$(echo "$title" | awk '{print tolower($0)}')
    title_search=${title_search// /}
    ! [[ $category_search =~ ${SEARCH_CATEGORY} ]] && return 1
    # shellcheck disable=SC2128
    ! [[ $title_search =~ $search_packages ]] && return 2
    return 0
}

function packages_display() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]} $(display_opts)"
    local package="" headers=()
    # Width
    local width=0 width_category=0 width_title=0 width_source=0
    local width_version_installed=0 width_version_candidate=0 width_maintainer=0 width_description=0
    # Determine the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1
    # Display packages
    if [[ $INSTALL -gt 0 ]]; then
        # Check if the list is empty
        [[ ${#PACKAGES_INSTALL[@]} -eq 0 ]] && warning "No package to install" && return 0
        # Display header
        ! packages_display_header && return 2
        ! packages_display_packages "I" && return 3
    elif [[ $REMOVE -gt 0 ]]; then
        # Check if the list is empty
        [[ ${#PACKAGES_REMOVE[@]} -eq 0 ]] && warning "No package to remove" && return 0
        # Display header
        ! packages_display_header && return 4
        ! packages_display_packages "R" && return 5
    else
        # Check if the list is empty
        [[ ${#PACKAGES_DISPLAY[@]} -eq 0 ]] && warning "No package to display" && return 0
        # Display header
        ! packages_display_header && return 6
        ! packages_display_packages "P" && return 7
    fi
    echo -e "\033[0m"
    return 0
}

function packages_display_install() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    local package="" headers=()
    # Fields
    local pre_install="" category="" title="" source="" version_installed="" version_candidate=""
    # Width
    local width=0 width_category=0 width_title=0 width_source=0
    local width_version_installed=0 width_version_candidate=0 width_maintainer=0 width_description=0
    # Check if the list is empty
    [[ ${#PACKAGES_INSTALL[@]} -eq 0 ]] && warning "No package to install" && return 0
    # Display header
    ! packages_display_header && return 1
    # Display packages to install
    ! packages_display_packages "I" && return 2
    echo -e "\033[0m"
    return 0
}

function packages_display_header() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    local header=""
    # Calculate width
    headers=("Category" "Name" "Source" "Installed" "Candidate" "Maintainer" "Description")
    ! packages_calculate_width && return 1
    # Display headers
    echo ""
    printf "${PACKAGES_HEADER_LEFT}${PACKAGES_HEADER_RIGHT[0]} %-${width_category}s " "${headers[0]}"
    printf "${PACKAGES_HEADER_RIGHT[1]} %-${width_title}s " "${headers[1]}"
    printf "${PACKAGES_HEADER_RIGHT[2]} %-${width_source}s " "${headers[2]}"
    printf "${PACKAGES_HEADER_RIGHT[3]} %-${width_version_installed}s " "${headers[3]}"
    printf "${PACKAGES_HEADER_RIGHT[4]} %-${width_version_candidate}s " "${headers[4]}"
    if [[ $SHOW_ALL -gt 0 ]]; then
        if [[ $width_maintainer -gt 0 ]]; then
            printf "${PACKAGES_HEADER_RIGHT[5]} %-${width_maintainer}s " "${headers[5]}"
        fi
        if [[ $width_description -gt 0 ]]; then
            printf "${PACKAGES_HEADER_RIGHT[6]} %-${width_description}s " "${headers[6]}"
        fi
    fi
    echo ""
    return 0
}

function packages_display_packages() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local packages_target=$1
    # Display packages
    if [[ $packages_target = "P" ]]; then
        for package in "${PACKAGES_DISPLAY[@]}"; do
            ! packages_display_package && return 1
        done
    fi
    # Display packages to install
    if [[ $packages_target = "I" ]]; then
        for package in "${PACKAGES_INSTALL[@]}"; do
            ! packages_display_package && return 2
        done
    fi
    # Display packages to remove
    if [[ $packages_target = "R" ]]; then
        for package in "${PACKAGES_REMOVE[@]}"; do
            ! packages_display_package && return 3
        done
    fi
    return 0
}

function packages_calculate_width() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    # Read the size of column headers
    width_category=${#headers[0]} width_title=${#headers[1]} width_source=${#headers[2]}
    width_version_installed=${#headers[3]} width_version_candidate=${#headers[4]}
    if [[ $SHOW_ALL -gt 0 ]]; then
        width_maintainer=${#headers[5]} width_description=${#headers[6]}
    fi
    # Calculate column sizes
    for package in "${PACKAGES_DISPLAY[@]}"; do
        IFS=$";" read -ra package_fields <<< "${package}"; unset IFS
        package_install=${package_fields[3]}
        package_remove=${package_fields[4]}
        if [[ $INSTALL -gt 0 ]] && [[ ${#PACKAGES_INSTALL[@]} -gt 0 ]] && [[ $package_install -eq 0 ]]; then
            continue
        fi
        if [[ $REMOVE -gt 0 ]] && [[ ${#PACKAGES_REMOVE[@]} -gt 0 ]] && [[ $package_remove -eq 0 ]]; then
            continue
        fi
        category=${package_fields[0]} title=${package_fields[1]} source=${package_fields[5]}
        version_installed=${package_fields[7]} version_candidate=${package_fields[8]}
        [[ ${#category} -gt $width_category ]] && width_category=${#category}
        [[ ${#title} -gt $width_title ]] && width_title=${#title}
        [[ ${#source} -gt $width_source ]] && width_source=${#source}
        [[ ${#version_installed} -gt $width_version_installed ]] && width_version_installed=${#version_installed}
        [[ ${#version_candidate} -gt $width_version_candidate ]] && width_version_candidate=${#version_candidate}
        if [[ $SHOW_ALL -gt 0 ]]; then
            maintainer=${package_fields[9]} description=${package_fields[10]}
            [[ ${#maintainer} -gt $width_maintainer ]] && width_maintainer=${#maintainer}
            [[ ${#description} -gt $width_description ]] && width_description=${#description}
        fi
    done
    category=""
    # Update the global width
    width=$((width_category+width_title+width_source+width_version_installed+width_version_candidate+5*2))
    [[ $width -gt $COLUMNS ]] && die "Unable to display packages" && return 1
    # Width update with detailed view
    if [[ $SHOW_ALL -gt 0 ]]; then
        if [[ $COLUMNS -lt $((width+width_description+2)) ]]; then
            width_description=0
        else
            width=$((width+width_description+2))
        fi
        if [[ $COLUMNS -lt $((width+width_maintainer+2)) ]]; then
            width_maintainer=0
        else
            width=$((width+width_maintainer+2))
        fi
    fi
    width=$((width+1))
    return 0
}

# shellcheck disable=SC2001
function packages_display_package() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    # Columns
    local enabled=1 category="" title="" source="" maintainer="" description=""
    local version_installed="" version_installed_number="" version_candidate="" version_candidate_number=""
    # Configure columns
    badge_left_header="${COLORS[NOCOLOR]}"
    badge_left_header_disabled="${BG_COLORS[RED]}${COLORS[RED]}"
    # Read the package’s columns
    IFS=$";" read -ra columns <<< "$package"; unset IFS
    category=${columns[0]} title=${columns[1]} enabled=${columns[2]}
    package_install=${columns[3]} package_remove=${columns[4]}
    source=${columns[5]} name=${columns[6]}
    version_installed=${columns[7]} version_candidate=${columns[8]}
    # Read columns
    version_installed_number=$(echo "${version_installed//[^0-9]/}"|sed 's/^0*//')
    version_candidate_number=$(echo "${version_candidate//[^0-9]/}"|sed 's/^0*//')
    # Update source with default package manager
    [[ "$source" = "dist" ]] && source="$DEFAULT_PACKAGE_MANAGER"
    # Display the disabled line if necessary
    echo -ne "${COLORS[NOCOLOR]}"
    if [[ $enabled -eq 0 ]]; then
        echo -ne "$badge_left_header_disabled"
    else
        echo -ne "$badge_left_header"
    fi
    # Display the raws
    printf "${PACKAGES_COLUMN[0]} %-${width_category}s " "${category^}"
    printf "${PACKAGES_COLUMN[1]} %-${width_title}s " "${title}"
    printf "${PACKAGES_COLUMN[2]} %-${width_source}s " "${source}"
    if [[ -z $version_installed_number ]] || [[ -z $version_candidate_number ]]; then
        printf "${PACKAGES_COLUMN[3]} %-${width_version_installed}s " "${version_installed}"
    else
        if [[ ${version_installed_number:-0} -lt ${version_candidate_number:-0} ]]; then
            printf "${PACKAGES_COLUMN[1]} %-${width_version_installed}s " "${version_installed}"
        else
            printf "${PACKAGES_COLUMN[3]} %-${width_version_installed}s " "${version_installed}"
        fi
    fi
    printf "${PACKAGES_COLUMN[4]} %-${width_version_candidate}s ${COLORS[NOCOLOR]}" "${version_candidate}"
    # View details
    if [[ $SHOW_ALL -gt 0 ]]; then
        maintainer=${columns[9]} description=${columns[10]}
        # Display maintainer
        if [[ $width_maintainer -gt 0 ]]; then
            printf "${PACKAGES_COLUMN[5]} %-${width_maintainer}s ${COLORS[NOCOLOR]}" "${maintainer}"
        fi
        # Display description
        if [[ $width_description -gt 0 ]]; then
            printf "${PACKAGES_COLUMN[6]} %-${width_description}s ${COLORS[NOCOLOR]}" "${description}"
        fi
    fi
    echo -e ""
    return 0
}

function packages_update() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    local packages_update_success=0 packages_update_errors=()
    # Read package information from the profile file
    ! profile_read_packages && return 1
    # Resynchronize package information
    ! packages_resynchronize && return 2
    # Display errors if necessary
    ! packages_read_failed_packages && return 3
    # Update packages in the profile file
    ! profile_update_packages && return 4
    # Update sync date
    ! profile_update_last_update && return 5
    # Reinitialize the cache files
    ! packages_cache_update && return 6
    # Operation completed
    PACKAGES_INIT=0
    success "Updating packages completed"
    return 0
}

function packages_resynchronize() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    # Determine the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1
    # Starting synchronization
    info "Starting package synchronization"
    info "Number of packages to synchronize ${BG_COLORS[NOCOLOR]}${COLORS[WHITE]} ${#PROFILE_PACKAGES[@]}"
    local profile_enabled="" profile_category="" profile_title="" profile_name=""
    local profile_source="" profile_version_installed="" profile_version_candidate=""
    local package_dist_info="" package_file_info=""
    local enabled="" package_install="" package_remove="" version_candidate="" version_installed=""
    local pre_install="" maintainer="" description=""
    local package_info="" package_dist_info="" package_file_info="" package_infos=()
    local progress=0 package_error=0
    local package="" package_fields=() packages=() packages_size=${#PROFILE_PACKAGES[@]}
    # Read package information
    for i in "${!PROFILE_PACKAGES[@]}"; do
        profile_package="${PROFILE_PACKAGES[$i]}"
        package_error=0
        package_info=""
        package_info_error=""
        # Read the package’s columns
        IFS=$";" read -ra profile_fields <<< "$profile_package"; unset IFS
        profile_enabled=${profile_fields[0]} profile_category=${profile_fields[1]}
        profile_title=${profile_fields[2]} profile_name=${profile_fields[3]} profile_source=${profile_fields[4]}
        enabled="" version_candidate="" version_installed="" description="" pre_install=""
        package_dist_info="" package_file_info=""
        if [[ $DEBUG -gt 0 ]]; then
            debug_packages "Synchronizing $profile_category $profile_title"
        else
            ! packages_show_progress_bar && return 2
        fi
        # Read package information from the distribution's package manager
        if [[ "$profile_source" = "dist" ]]; then
            if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
                if ! package_dist_info=$(package_apt_info "$profile_name"); then
                    package_error=1
                    package_info_error="$package_dist_info"
                    packages_update_errors+=("$profile_category;$profile_name;apt;$package_dist_info")
                fi
            fi
        fi
        # Read information from the packages folder
        if [[ $package_error -eq 0 ]]; then
            if ! package_file_info=$(package_file_info "$profile_source" "$profile_category" "$profile_name"); then
                package_error=1
                package_info_error="$package_file_info"
                packages_update_errors+=("$profile_category;$profile_name;file;$package_file_info")
            fi
        fi
        # Updating package information
        enabled=1
        if [[ $package_error -gt 0 ]]; then
            enabled=0
            version_candidate=""
            version_installed=""
            description="$package_info_error"
            maintainer=""
        else
            # Read information from the packages folder
            IFS=$";" read -ra package_infos <<< "${package_file_info}"; unset IFS
            package_install=${package_infos[1]} package_remove=${package_infos[2]}
            version_candidate=${package_infos[3]} version_installed=${package_infos[4]}
            maintainer=${package_infos[5]} description=${package_infos[6]} pre_install=${package_infos[7]}
            # Read package information from the distribution's package manager
            if [[ -n $package_dist_info ]]; then
                IFS=$";" read -ra package_infos <<< "${package_dist_info}"; unset IFS
                dist_package_install=${package_infos[1]}
                dist_package_remove=${package_infos[2]}
                dist_version_candidate=${package_infos[3]}
                dist_version_installed=${package_infos[4]}
                dist_maintainer=${package_infos[5]} dist_description=${package_infos[6]}
                [[ $package_install -eq 0 ]] && [[ $dist_package_install -gt 0 ]] && package_install=$dist_package_install
                [[ $package_remove -eq 0 ]] && [[ $dist_package_remove -gt 0 ]] && package_remove=$dist_package_remove
                [[ -z $version_candidate ]] && [[ -n $dist_version_candidate ]] && version_candidate=$dist_version_candidate
                [[ -z $version_installed ]] && [[ -n $dist_version_installed ]] && version_installed=$dist_version_installed
                [[ -z $maintainer ]] && [[ -n $dist_maintainer ]] && maintainer=$dist_maintainer
                [[ -z $description ]] && [[ -n $dist_description ]] && description=$dist_description
            fi
            packages_update_success=$((packages_update_success+1))
        fi
        [[ -z $pre_install ]] && pre_install=0
        # Update package info
        package_info="$profile_category;$profile_title;$enabled;$package_install;$package_remove;"
        package_info+="$profile_source;$profile_name;$version_installed;$version_candidate;"
        package_info+="$maintainer;$description;$pre_install"
        packages+=("$package_info")
    done
    ! packages_reset_list && return 3
    # Clean color
    echo -en "${BG_COLORS[NOCOLOR]}${COLORS[NOCOLOR]}"
    [[ $DEBUG -eq 0 ]] && echo ""
    return 0
}

function packages_reset_list() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local enabled="" category="" package_install="" title="" package_remove="" package_found=0
    # Update the list of packages to display, install and remove
    PACKAGES_DISPLAY=() PACKAGES_INSTALL=() PACKAGES_REMOVE=()
    PACKAGES_INIT=${PACKAGES_INIT:-0}
    [[ $PACKAGES_INIT -gt 0 ]] && PACKAGES=()
    for package in "${packages[@]}"; do
        [[ "$PACKAGES_INIT" -gt 0 ]] && PACKAGES+=("$package")
        PACKAGES_DISPLAY+=("$package")
        IFS=$";" read -ra package_fields <<< "${package}"; unset IFS
        enabled=${package_fields[2]}
        package_install=${package_fields[3]}
        package_remove=${package_fields[4]}
        # The package can be installed
        if [[ $enabled -gt 0 ]] && [[ $package_install -gt 0 ]]; then
            PACKAGES_INSTALL+=("$package")
        fi
        # The package can be removed
        if [[ $enabled -gt 0 ]] && [[ $package_remove -gt 0 ]]; then
            PACKAGES_REMOVE+=("$package")
        fi
    done
    # We don't continue if it's a package reset
    [[ "$PACKAGES_INIT" -gt 0 ]] && return 0
    # Update current package list
    local package_display="" package_display_fields=() category_display="" title_display=""
    packages=()
    for package in "${PACKAGES[@]}"; do
        IFS=$";" read -ra package_fields <<< "$package"; unset IFS
        category=${package_fields[0]}
        title=${package_fields[1]}
        package_found=0
        for package_display in "${PACKAGES_DISPLAY[@]}"; do
            IFS=$";" read -ra package_display_fields <<< "$package_display"; unset IFS
            category_display=${package_display_fields[0]}
            title_display=${package_display_fields[1]}
            if [[ "$category" = "$category_display" ]] && [[ "$title" = "$title_display" ]]; then
                packages+=("$package_display")
                package_found=1
                break
            fi
        done
        [[ $package_found -eq 0 ]] && packages+=("$package")
    done
    # Reset package list
    PACKAGES=()
    for package in "${packages[@]}"; do
        PACKAGES+=("$package")
    done
    return 0
}

function packages_show_progress_bar() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local progress_counter=0 progress_bar="" display_progress_bar="" display_name=""
    # Configure progress bar
    progress=$((i+1)) && progress=$((progress*100/packages_size))
    progress_counter=$((progress/10))
    progress_counter=$((progress_counter*2)) && progress_counter=${progress_counter%.*}
    progress_bar="" && for j in $(seq 1 $progress_counter); do progress_bar+="░" ; done
    for j in $(seq $((progress_counter+1)) 20); do progress_bar+=" " ; done
    # Configure progress bar color
    [[ $progress -lt 75 ]] && \
        display_progress_bar="${BG_COLORS[NOCOLOR]}${COLORS[CYAN]}"
    [[ $progress -gt 74 ]] && \
        display_progress_bar="${BG_COLORS[NOCOLOR]}${COLORS[GREEN]}"
    display_name="${COLORS[WHITE]}$profile_title                                   ${COLORS[NOCOLOR]}"
    # Configure progress bar width
    [[ $progress -lt 10 ]] && display_progress_bar+="$progress_bar  ${COLORS[NOCOLOR]}"
    [[ $progress -gt 9 && $progress -lt 100 ]] && \
                display_progress_bar+="$progress_bar ${COLORS[NOCOLOR]}"
    [[ $progress -eq 100 ]] && display_progress_bar+="$progress_bar${COLORS[NOCOLOR]}"
    # Display the progress bar
    echo -ne "${BADGE_SUCCESS} Progress $progress% $display_progress_bar $display_name\r"
    return 0
}

function packages_read_failed_packages() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    local packages_size=${#PACKAGES[@]}
    # Show packages that failed to sync
    if [[ ${#packages_update_errors[@]} -gt 0 ]]; then
        warning "Unable to synchronize ${#packages_update_errors[@]} packages"
        # Calculate column sizes
        local packages_error=""
        local width_source=0
        for packages_error in "${packages_update_errors[@]}"; do
            IFS=$";" read -ra error_columns <<< "$packages_error"; unset IFS
            [[ ${#error_columns[2]} -gt $width_source ]] && width_source=${#error_columns[2]}
        done
        # Display errors found
        local packages_error=""
        for packages_error in "${packages_update_errors[@]}"; do
            IFS=$";" read -ra error_columns <<< "$packages_error"; unset IFS
            printf "${BADGE_WARNING} %s %s" "${error_columns[0]^}" "${error_columns[1]} "
            printf "${BG_COLORS[NOCOLOR]}${COLORS[GREEN]} %-${width_source}s ${COLORS[RED]} %s " \
                "${error_columns[2]}" "${error_columns[3]}"
            echo -e "${BG_COLORS[NOCOLOR]}${COLORS[NOCOLOR]}"
        done
    fi
    return 0
}

function packages_cache_update() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    # Check if the cache can be updated
    [[ ${#PACKAGES[@]} -eq 0 ]] && warning "No packages found to write to cache" && return 1
    local cache_path="$CACHE_PATH/$PROFILE"
    # Create the cache files if necessary
    local package=""
    [[ -f "$cache_path" ]] && rm -f "$cache_path"
    touch "$cache_path"
    for package in "${PACKAGES[@]}"; do
        echo "$package">>"$cache_path"
    done
    return 0
}

function packages_dist_update() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    # Determine the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1
    # Updating index with the package manager
    if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
        info "Updating apt packages"
        ! package_apt_update && return 2
    fi
    return 0
}

function packages_preinstall() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    [[ ${#PACKAGES_INSTALL[@]} -eq 0 ]] && warning "Unable to retrieve prerequisites" && return 1
    # Check prerequisites
    local category="" title="" name="" package="" pre_install=0
    local packages_preinstall_update=0 packages_preinstall=()
    for package in "${PACKAGES_INSTALL[@]}"; do
        IFS=$";" read -ra columns <<< "$package"; unset IFS
        # Check if the package file contains a prerequisite
        pre_install="${columns[11]}"
        if [[ $pre_install -gt 0 ]]; then
            packages_preinstall+=("$package")
        fi
    done
    # Check for prerequisites
    [[ ${#packages_preinstall[@]} -eq 0 ]] && warning "No prerequisites to install" && return 2
    # Confirm before installation
    if [[ $YES -eq 0 ]]; then
        # Display the prerequisites
        for package in "${packages_preinstall[@]}"; do
            IFS=$";" read -ra columns <<< "$package"; unset IFS
            category=${columns[0]}
            title=${columns[1]}
            name=${columns[6]}
            info "${BG_COLORS[GREEN]}${category^} ${BG_COLORS[YELLOW]}${title}"
        done
        local confirm_answer && confirm_message "Do you want to install these prerequisites? [Y/n]"
        if ! [[ "$confirm_answer" = "y" ]]; then
            warning "Installation canceled" && return 3
        fi
    fi
    # Installing prerequisites
    for package in "${packages_preinstall[@]}"; do
        IFS=$";" read -ra columns <<< "$package"; unset IFS
        category=${columns[0]}
        title=${columns[1]}
        name=${columns[6]}
        info "Install prerequisites of ${BG_COLORS[GREEN]}${category^} ${BG_COLORS[YELLOW]}${title}"
        ! package_file_preinstall "$category" "$name" && continue
        packages_preinstall_update=$((packages_preinstall_update+1))
    done
    # Installation completed
    if [[ $packages_preinstall_update -eq 0 ]]; then
        warning "No prerequisites installed" && return 4
    fi
    success "Installation of prerequisites successfully completed"
    return 0
}

function packages_install() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    local package="" category="" title="" name="" source=""
    # Resynchronize package manager index
    ! packages_dist_update && return 1
    # Resynchronize packages
    ! packages_update 1> /dev/null
    [[ ${#PACKAGES_INSTALL[@]} -eq 0 ]] && warning "No packages to install" && return 2
    INSTALL=1
    # Display packages to install
    ! packages_display_install && return 3
    # Confirm before installation
    if [[ $YES -eq 0 ]]; then
        local confirm_answer && confirm_message "Do you want to install these packages? [Y/n]"
        if ! [[ "$confirm_answer" = "y" ]]; then
            warning "Installation canceled" && return 4
        fi
    fi
    # Installing packages
    for package in "${PACKAGES_INSTALL[@]}"; do
        ! packages_install_package && return 5
    done
    INSTALL=0
    # Resynchronize after install
    ! packages_read && return 6
    ! packages_update && return 7
    # Installation completed
    success "Installation completed successfully!"
    return 0
}

function packages_install_package() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    # Determine the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1
    IFS=$";" read -ra package_fields <<< "$package"; unset IFS
    category=${package_fields[0]}
    title=${package_fields[1]}
    source=${package_fields[5]}
    name=${package_fields[6]}
    info "Installation of ${BG_COLORS[GREEN]}${category^} ${BG_COLORS[YELLOW]}${title}"
    # Installation from the package manager
    if [[ "$source" = "dist" ]]; then
        if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
            ! package_apt_install "$name" && return 2
        fi
    fi
    # Installation from package file
    if [[ $source = "file" ]]; then
        ! package_file_install "$category" "$name" && return 3
    fi
    return 0
}

function packages_remove() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    [[ ${#PACKAGES_REMOVE[@]} -eq 0 ]] && warning "No packages to remove" && return 1
    # Confirm before remove
    if [[ $YES -eq 0 ]]; then
        local confirm_answer && confirm_message "Do you want to remove these packages? [Y/n]"
        if ! [[ "$confirm_answer" = "y" ]]; then
            warning "Remove packages canceled" && return 2
        fi
    fi
    # Removing packages
    local package="" category="" title="" name="" source=""
    for package in "${PACKAGES_REMOVE[@]}"; do
        ! packages_remove_package && return 3
    done
    # Resynchronize after install
    ! packages_read && return 4
    ! packages_update && return 5
    # Remove completed
    success "Remove completed successfully!"
    return 0
}

function packages_remove_package() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    debug_packages "${FUNCNAME[0]}"
    # Determine the default package manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && os_package_manager
    [[ -z $DEFAULT_PACKAGE_MANAGER ]] && die "Unable to determine default package manager!" && return 1
    # Read the package’s fields
    IFS=$";" read -ra columns <<< "$package"; unset IFS
    category=${columns[0]}
    title=${columns[1]}
    source=${columns[5]}
    name=${columns[6]}
    info "Remove of ${BG_COLORS[GREEN]}${category^} ${BG_COLORS[YELLOW]}${title}"
    # Read package information from the distribution's package manager
    if [[ "$source" = "dist" ]]; then
        if [[ "$DEFAULT_PACKAGE_MANAGER" = "apt" ]]; then
            ! package_apt_remove "$name" && return 2
        fi
    fi
    # Read information from the packages folder
    if [[ $source = "file" ]]; then
        ! package_file_remove "$category" "$name" && return 3
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
