#!/usr/bin/env bash
# @name PimpMyTerm
# @brief **pimpmyterm.sh** is a utility to help you customize your terminal and manage the installation
# of your favorite packages.
# @description
#   This utility enables you to perform the following actions:
#
#       * Updating packages
#       * Installing prerequisites
#       * Installing packages
#       * Removing packages
#       * Search a package by name or category
#       * Change profile
#       * Change theme

LIBS_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/libs"

MENU_PROMPT=0
CURSOR_TOP=()
CURSOR_PROMPT=()
CURSOR_PROMPT_TOP=()
CURSOR_PROMPT_BOTTOM=()
BANNER_COLUMNS=0
BANNER_LINES=()
OPTIONS_LINES=()
DISPLAY_MODE=""
DISPLAY_ACTION=""
ACTION=""

# shellcheck source=./libs/common.sh
source "$LIBS_PATH/common.sh"
# shellcheck source=./libs/config.sh
source "$LIBS_PATH/config.sh"
# shellcheck source=./libs/os.sh
source "$LIBS_PATH/os.sh"
# shellcheck source=./libs/packages.sh
source "$LIBS_PATH/packages.sh"
# shellcheck source=./libs/package_file.sh
source "$LIBS_PATH/package_file.sh"
# shellcheck source=./libs/package_apt.sh
source "$LIBS_PATH/package_apt.sh"
# shellcheck source=./libs/profile.sh
source "$LIBS_PATH/profile.sh"

# @description Debug the library.
# @noargs
# @set DEBUG_PATH string Path to library to be debugged.
# @exitcode 0 If successful.
function debug_pmt() { debug_script "./pimpmyterm.sh" "$*" ; }

# @description Display the banner.
# @noargs
# @set DEBUG integer If 1, do not display the banner.
# @set BANNER_LINES array Contains the banner content.
# @set BANNER_COLUMNS integer Banner width.
# @set MENU_PROMPT_COLORS array Contains the banner colour settings.
# @exitcode 0 If successful.
function menu_print_banner() {
    [[ $DEBUG -gt 0 ]] && return 0
    local banner_line=""
    if [[ ${#BANNER_LINES[*]} -eq 0 ]]; then
        local line="" color_index=0 color=""
        local left_banner="${BG_COLORS[NOCOLOR]}${COLORS[NOCOLOR]}   "
        IFS=$"$" read -ra lines <<< "$BANNER"; unset IFS
        # Configure the banner
        for line in "${lines[@]}"; do
            size_line=${#line}
            [[ size_line -gt $BANNER_COLUMNS ]] && BANNER_COLUMNS=$size_line
            banner_row="${left_banner}"
            for (( i=0; i<size_line; i++ )); do
                color="WHITE"
                if [[ ${#MENU_PROMPT_COLORS[@]} -gt 0 ]]; then
                    color_index=$((RANDOM % ${#MENU_PROMPT_COLORS[@]}))
                    color=${MENU_PROMPT_COLORS[$color_index]}
                fi
                banner_row+="${BG_COLORS[$color]}${COLORS[BLACK]}${line:$i:1}${COLORS[NOCOLOR]}"
            done
            BANNER_LINES+=("$banner_row")
        done
    fi
    # Do not display banner size if width is too small
    [[ $((BANNER_COLUMNS+3)) -gt $COLUMNS ]] && return 0
    # Show the banner
    echo ""
    for banner_line in "${BANNER_LINES[@]}"; do
        echo -e "$banner_line"
    done
    echo -ne "${BG_COLORS[NOCOLOR]}${COLORS[NOCOLOR]}"
    [[ $COLUMNS -gt $((26*4)) ]] && echo ""
    return 0
}

# @description Display menu options.
# @noargs
# @set DISPLAY_MODE integer Display mode.
# @set OPTIONS_LINES array Contains menu items.
# @set MENU_HEADER_LEFT array Contains the colours of the left-hand part of a column header.
# @set MENU_HEADER_RIGHT array Contains the colours of the right-hand part of a column header.
# @set MENU_COLUMN_LEFT array Contains the colours of the left-hand side of a column.
# @set MENU_COLUMN_RIGHT array Contains the colours of the right-hand side of a column.
# @set MENU_COLUMN_RIGHT_ENABLED array Contains the colours on the right-hand side of a deactivated column.
# @exitcode 0 If successful.
# @exitcode 1 If an error has been encountered when configuring the options.
function menu_print_options() {
    # Menu Options
    local options_line="" options="" option=""
    local badge_left_header="" badge_right_header="" badge="" badge_left="" badge_right="" badge_enabled=0
    local column_left_color="" column_right_color="" width_column=21
    # Configure the options to display
    local options_line_index=0 color_index=0 color_increment_index=0
    local width=$((width_column+2+3+1)) && width=$((width*4))
    # Calculate the display
    local display_mode=1
    if [[ $COLUMNS -lt $((width)) ]]; then
        display_mode=2
    fi
    if [[ $COLUMNS -lt $((width/2)) ]]; then
        display_mode=3
    fi
    # Configure the options
    if ! [[ $DISPLAY_MODE -eq $display_mode ]]; then
        DISPLAY_MODE=$display_mode
        ! menu_configure_options && return 1
    fi
    # Print the options
    for options_line in "${OPTIONS_LINES[@]}"; do
        IFS=$";" read -ra options <<< "${options_line}"; unset IFS
        for i in "${!options[@]}"; do
            option=${options[$i]}
            color_index=$((i+color_increment_index))
            # Badge
            IFS=$"|" read -ra badge <<< "${option}"; unset IFS
            badge_left="${badge[0]}"
            badge_right="${badge[1]}"
            badge_enabled=0
            # print the header
            if [[ -z "$badge_left" ]]; then
                # Increment the color index if necessary
                if [[ $DISPLAY_MODE -eq 2 ]] && [[ $i -eq 0 ]]; then
                    options_line_index=$((options_line_index+1))
                    [[ $options_line_index -eq 2 ]] && color_increment_index=2
                    color_index=$((i + color_increment_index))
                    echo ""
                fi
                badge_left_header=${MENU_HEADER_LEFT[$color_index]}
                badge_right_header=${MENU_HEADER_RIGHT[$color_index]}
                printf "$badge_left_header   $badge_right_header %-${width_column}s ${COLORS[NOCOLOR]} " "$badge_right"
                continue
            fi
            # Badges to activate
            [[ "$badge_left" = "n" ]] && [[ $INSTALL -gt 0 ]] && badge_enabled=1
            [[ "$badge_left" = "a" ]] && [[ $SHOW_ALL -gt 0 ]] && badge_enabled=1
            [[ "$badge_left" = "s" ]] && [[ $SILENT -gt 0 ]] && badge_enabled=1
            [[ "$badge_left" = "y" ]] && [[ $YES -gt 0 ]] && badge_enabled=1
            [[ "$badge_left" = "d" ]] && [[ $DEBUG -gt 0 ]] && badge_enabled=1
            # Print the option
            column_left_color=${MENU_COLUMN_LEFT[$color_index]}
            column_right_color=${MENU_COLUMN_RIGHT[$color_index]}
            [[ $badge_enabled -gt 0 ]] && column_right_color="${MENU_COLUMN_RIGHT_ENABLED[$i]}"
            printf "$column_left_color %s $column_right_color %-${width_column}s ${COLORS[NOCOLOR]} " \
                "$badge_left" "$badge_right"
        done
        echo -e "${COLORS[NOCOLOR]}"
    done
    echo ""
    return 0
}

# @description Configure menu options.
# @noargs
# @set OPTIONS_LINES array Contains menu items.
# @set DISPLAY_MODE integer Display mode.
# @exitcode 0 If successful.
function menu_configure_options() {
    # Option headers
    local options_headers=("Search" "Package management" "Options" "Miscellaneous")
    local options_one=() options_two=() options_three=() options_four=()
    # Search
    options_one+=("|${options_headers[0]}")
    options_one+=("l|List packages")
    options_one+=("/|Search by name")
    options_one+=("c|Search by category")
    options_one+=("f|Reset filters")
    # Manage packages
    options_two+=("|${options_headers[1]}")
    options_two+=("u|Updating packages")
    options_two+=("i|Install packages")
    options_two+=("I|Install prerequisites")
    options_two+=("r|Remove packages")
    # Display options
    options_three+=("|${options_headers[2]}")
    options_three+=("a|View details")
    options_three+=("n|View non-installed")
    options_three+=("s|Silent installation")
    options_three+=("y|No confirm to install")
    # Miscellaneous
    options_four+=("|${options_headers[3]}")
    options_four+=("p|Change profile")
    options_four+=("t|Change theme")
    options_four+=("h|Show help")
    options_four+=("q|Quit")
    OPTIONS_LINES=()
    # Display 4 columns
    if [[ $DISPLAY_MODE -eq 1 ]]; then
        for i in "${!options_one[@]}"; do
          OPTIONS_LINES+=("${options_one[$i]};${options_two[$i]};${options_three[$i]};${options_four[$i]}")
        done
    fi
    # Display 2 columns
    if [[ $DISPLAY_MODE -eq 2 ]]; then
        for i in "${!options_one[@]}"; do
          OPTIONS_LINES+=("${options_one[$i]};${options_two[$i]}")
        done
        for i in "${!options_one[@]}"; do
          OPTIONS_LINES+=("${options_three[$i]};${options_four[$i]}")
        done
    fi
    # Not display rhe options with display 3
    [[ $DISPLAY_MODE -eq 3 ]] && return 0
    return 0
}

# @description Display various information in the menu header.
# @noargs
# @set PROFILE string Current profile.
# @set THEME string Current theme.
# @set SEARCH_CATEGORY string Category to search.
# @set SEARCH_PACKAGES string Packages to search.
# @set PACKAGES array List of packages.
# @set PACKAGES_DISPLAY array List of packages to display.
# @set PACKAGES_INSTALL array List of packages to install.
# @set PACKAGES_REMOVE array List of packages to be deleted.
# @set MENU_BADGE_LEFT string Color of the left side of the menu badge.
# @set MENU_BADGE_RIGHT string Color of the right side of the menu badge.
# @set MENU_BADGE_SEARCH_LEFT string Color of the left side of the search badge.
# @set MENU_BADGE_SEARCH_RIGHT string Color of the right side of the search badge.
# @exitcode 0 If successful.
function menu_print_infos() {
    local menu_header=""
    # Profile
    menu_header+="$MENU_BADGE_LEFT Profile $MENU_BADGE_RIGHT $PROFILE ${COLORS[NOCOLOR]} "
    # Theme
    menu_header+="$MENU_BADGE_LEFT Theme $MENU_BADGE_RIGHT $THEME ${COLORS[NOCOLOR]} "
    # Category
    if [[ -n "${SEARCH_CATEGORY}" ]]; then
        menu_header+="$MENU_BADGE_SEARCH_LEFT Category $MENU_BADGE_SEARCH_RIGHT ${SEARCH_CATEGORY} ${COLORS[NOCOLOR]} "
    fi
    # Reading packages to search
    local search_packages="" search_packages_lower=""
    if [[ ${#SEARCH_PACKAGES[@]} -gt 0 ]]; then
        for i in "${!SEARCH_PACKAGES[@]}"; do
            [[ -z ${SEARCH_PACKAGES[$i]} ]] && continue
            search_packages_lower=$(echo "${SEARCH_PACKAGES[$i]}" | awk '{print tolower($0)}')
            [[ $i -eq 0 ]] && search_packages="$search_packages_lower" && continue
            search_packages+=" $search_packages_lower"
        done
        if [[ -n $search_packages ]]; then
            menu_header+="$MENU_BADGE_SEARCH_LEFT Packages $MENU_BADGE_SEARCH_RIGHT $search_packages ${COLORS[NOCOLOR]} "
        fi
    fi
    if [[ $DEBUG -gt 0 ]]; then
        debug_pmt "${COLORS[CYAN]}PACKAGES: ${COLORS[PINK]}${#PACKAGES[@]}"
        debug_pmt "${COLORS[CYAN]}PACKAGES_DISPLAY: ${COLORS[PINK]}${#PACKAGES_DISPLAY[@]}"
        debug_pmt "${COLORS[CYAN]}PACKAGES_INSTALL: ${COLORS[PINK]}${#PACKAGES_INSTALL[@]}"
        debug_pmt "${COLORS[CYAN]}PACKAGES_REMOVE: ${COLORS[PINK]}${#PACKAGES_REMOVE[@]}"
    fi
    tput el && echo -e "${menu_header}"
    echo ""
    return 0
}

# @description Saves the current cursor position in an array.
# @noargs
# @exitcode 0 If successful.
# based on a script from http://invisible-island.net/xterm/xterm.faq.html
# shellcheck disable=SC2004
function menu_cursor_save() {
    local old_stty
    cursor_row=0 cursor_col=0
    exec < /dev/tty
    old_stty=$(stty -g)
    stty raw -echo min 0
    echo -en "\033[6n" > /dev/tty
    IFS=';' read -r -d R -a pos
    stty "$old_stty"
    local re='^[0-9]+$'
    ! [[ ${pos[0]:2} =~ $re ]] && return 0
    cursor_row=$((${pos[0]:2} - 1))
    cursor_col=$((${pos[1]} - 1))
    return 0
}

# @description Initializes cursor position at menu launch.
# @noargs
# @set MENU_PROMPT integer 1 if display the menu.
# @set DEBUG integer 1 if debug mode is enabled.
# @exitcode 0 If successful.
function menu_prompt_cursor_init() {
    tput sc
    [[ $MENU_PROMPT -eq 0 ]] && return 0
    [[ $DEBUG -gt 0 ]] && return 0
    tput cup 0 0 && tput ed
    menu_cursor_top_save
    return 0
}

# @description Saves the position at the top of the menu.
# @noargs
# @set MENU_PROMPT integer 1 if display the menu.
# @set DEBUG integer 1 if debug mode is enabled.
# @set CURSOR_TOP array Contains the position at the top of the menu.
# @exitcode 0 If successful.
function menu_cursor_top_save () {
    [[ $MENU_PROMPT -eq 0 ]] && return 0
    [[ $DEBUG -gt 0 ]] && return 0
    local cursor_row cursor_col
    ! menu_cursor_save && return 1
    CURSOR_TOP=("$cursor_row" "$cursor_col")
    return 0
}

# @description Saves prompt position.
# @noargs
# @set MENU_PROMPT integer 1 if display the menu.
# @set DEBUG integer 1 if debug mode is enabled.
# @set CURSOR_PROMPT array Contains prompt position.
# @set CURSOR_PROMPT_TOP array Contains the position above the prompt.
# @set CURSOR_PROMPT_BOTTOM array Contains the position below the prompt.
# @exitcode 0 If successful.
function menu_cursor_prompt_save () {
    [[ $MENU_PROMPT -eq 0 ]] && return 0
    [[ $DEBUG -gt 0 ]] && return 0
    local cursor_row cursor_col
    ! menu_cursor_save && return 1
    CURSOR_PROMPT=("$cursor_row" "$cursor_col")
    CURSOR_PROMPT_TOP=("$((cursor_row-1))" "$cursor_col")
    CURSOR_PROMPT_BOTTOM=("$((cursor_row+1))" "$cursor_col")
    return 0
}

# @description Loads the position at the top of the menu.
# @noargs
# @set MENU_PROMPT integer 1 if display the menu.
# @set DEBUG integer 1 if debug mode is enabled.
# @set CURSOR_TOP array Contains the position at the top of the menu.
# @exitcode 0 If successful.
function menu_cursor_top_refresh() {
    [[ $MENU_PROMPT -eq 0 ]] && return 0
    [[ $DEBUG -gt 0 ]] && return 0
    tput cup "${CURSOR_TOP[0]}" "${CURSOR_TOP[1]}"
    tput el
    return 0
}

# @description Loads prompt position.
# @noargs
# @set MENU_PROMPT integer 1 if display the menu.
# @set DEBUG integer 1 if debug mode is enabled.
# @set CURSOR_PROMPT array Contains prompt position.
# @exitcode 0 If successful.
function menu_cursor_prompt_refresh() {
    [[ $MENU_PROMPT -eq 0 ]] && return 0
    [[ $DEBUG -gt 0 ]] && return 0
    tput cup "${CURSOR_PROMPT[0]}" "${CURSOR_PROMPT[1]}"
    tput el
    return 0
}

# @description Loads the position above the prompt.
# @noargs
# @set MENU_PROMPT integer 1 if display the menu.
# @set DEBUG integer 1 if debug mode is enabled.
# @set CURSOR_PROMPT_TOP array Contains the position above the prompt.
# @exitcode 0 If successful.
function menu_cursor_prompt_top_refresh() {
    [[ $MENU_PROMPT -eq 0 ]] && return 0
    [[ $DEBUG -gt 0 ]] && return 0
    tput cup "${CURSOR_PROMPT_TOP[0]}" "${CURSOR_PROMPT_TOP[1]}"
    return 0
}

# @description Loads the position below the prompt.
# @noargs
# @set MENU_PROMPT integer 1 if display the menu.
# @set DEBUG integer 1 if debug mode is enabled.
# @set CURSOR_PROMPT_BOTTOM array Contains the position below the prompt.
# @exitcode 0 If successful.
function menu_cursor_prompt_bottom_refresh() {
    [[ $MENU_PROMPT -eq 0 ]] && return 0
    [[ $DEBUG -gt 0 ]] && return 0
    tput cup "${CURSOR_PROMPT_BOTTOM[0]}" "${CURSOR_PROMPT_BOTTOM[1]}"
    return 0
}

# @description Change profile.
# @noargs
# @set PROFILE_LIST array List of available profiles.
# @set PROFILE string Current profile.
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading the configuration file.
# @exitcode 2 If an error occurs when reading the list of profiles.
# @exitcode 3 If profile could not be updated.
# @exitcode 4 If an error occurs when reading the profile configuration.
# @exitcode 5 If an error occurs when reading packages.
function menu_profile_update() {
    debug_pmt "${FUNCNAME[0]}"
    [[ -z $PROFILE ]] && ! config_read && return 1
    # Get the list of profiles
    ! config_profile_list && return 2
    # Print the profiles
    local badge_left="" badge_right=""
    for i in "${!PROFILE_LIST[@]}"; do
        if [[ "${PROFILE_LIST[$i]}" = "$PROFILE" ]]; then
            badge_left="${BG_COLORS[NOCOLOR]}${COLORS[BLUE]} $((i+1)) "
            badge_right="${BG_COLORS[BLUE]}${COLORS[BLACK]}"
        else
            badge_left="${BG_COLORS[NOCOLOR]}${COLORS[WHITE]} $((i+1)) "
            badge_right="${BG_COLORS[WHITE]}${COLORS[BLACK]}"
        fi
        echo -e "${badge_left}${badge_right} ${PROFILE_LIST[$i]} ${COLORS[NOCOLOR]}"
    done
    badge_left="${BG_COLORS[NOCOLOR]}${COLORS[RED]} q "
    badge_right="${BG_COLORS[RED]}${COLORS[BLACK]}"
    echo -e "${badge_left}${badge_right} Quit ${COLORS[NOCOLOR]}"
    # Profile selection
    local profile_list_size=${#PROFILE_LIST[@]}
    local answer && confirm_message "Choose a profile"
    case "$answer" in
        # Set the profile
        [1-"$profile_list_size"]) PROFILE=${PROFILE_LIST[$((answer-1))]} ;;
        q) DISPLAY_ACTION="L" ; return 0 ;;
        *) die_and_continue "Invalid profile" && return 0 ;;
    esac
    PROFILE_CONFIG_FILE="$PROFILES_PATH/${PROFILE}.ini"
    # Updating current profile in config file
    ! config_profile_update && return 3
    # Read the profile settings
    ! profile_read_config && return 4
    ! packages_read && return 5
    DISPLAY_ACTION="L"
    return 0
}

# @description Change theme.
# @noargs
# @set PROFILE string Current profile.
# @set PROFILE_CONFIG_FILE string Profile configuration file.
# @set THEME string Current theme.
# @set THEME_LIST array List of available themes.
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading the configuration file.
# @exitcode 2 If an error occurs when reading the profile configuration file.
# @exitcode 3 If an error occurs when reading the list of themes.
# @exitcode 4 If the theme cannot be updated in the profile.
# shellcheck disable=SC1090
function menu_theme_update() {
    debug_pmt "${FUNCNAME[0]}"
    [[ -z $PROFILE ]] && ! config_read && return 1
    [[ -z $PROFILE_CONFIG_FILE ]] && ! profile_read_config && return 2
    # Get the list of theme
    ! config_theme_list && return 3
    # Print the profiles
    local badge_left="" badge_right=""
    for i in "${!THEME_LIST[@]}"; do
        if [[ "${THEME_LIST[$i]}" = "$THEME" ]]; then
            badge_left="${BG_COLORS[NOCOLOR]}${COLORS[BLUE]} $((i+1)) "
            badge_right="${BG_COLORS[BLUE]}${COLORS[BLACK]}"
        else
            badge_left="${BG_COLORS[NOCOLOR]}${COLORS[WHITE]} $((i+1)) "
            badge_right="${BG_COLORS[WHITE]}${COLORS[BLACK]}"
        fi
        echo -e "${badge_left}${badge_right} ${THEME_LIST[$i]} ${COLORS[NOCOLOR]}"
    done
    badge_left="${BG_COLORS[NOCOLOR]}${COLORS[RED]} q "
    badge_right="${BG_COLORS[RED]}${COLORS[BLACK]}"
    echo -e "${badge_left}${badge_right} Quit ${COLORS[NOCOLOR]}"
    # Profile selection
    local theme="" theme_list_size=${#THEME_LIST[@]}
    local answer && confirm_message "Choose a theme"
    case "$answer" in
        # Set the theme
        [1-"$theme_list_size"]) theme=${THEME_LIST[$((answer-1))]} ;;
        q) DISPLAY_ACTION="L" ; return 0 ;;
        *) die_and_continue "Invalid theme" && return 0 ;;
    esac
    # Show theme preview
    source "$THEMES_PATH/$theme.sh"
    DISPLAY_ACTION="PREVIEW"
    menu_print
    # Apply the theme
    local confirm_answer && confirm_message "Would you like to use this theme? [Y/n]"
    if ! [[ "$confirm_answer" = "y" ]]; then
        # Restore the current theme
        source "$THEMES_PATH/$THEME.sh"
        DISPLAY_ACTION="PREVIEW"
        menu_print
        return 0
    fi
    THEME=$theme
    # Updating current theme in profile file
    ! profile_update_theme && return 4
    DISPLAY_ACTION="L"
    return 0
}

# @description Perform an action in the menu.
# @noargs
# @set ACTION string Used to clear to end of screen if resize the screen.
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @set CURSOR_PROMPT_BOTTOM array Contains the position below the prompt.
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs while loading the menu cursor.
# @exitcode 2 If an error occurs when display the menu options.
# @exitcode 3 If an error occurs when display the packages.
# @exitcode 4 If an error occurs when updating the packages.
# @exitcode 5 If an error occurs when installing the packages.
# @exitcode 6 If an error occurs when installing the prerequisites.
# @exitcode 7 If an error occurs when removing the packages.
# @exitcode 8 If an error occurs when change the profile.
# @exitcode 9 If an error occurs when change the theme.
# @exitcode 10 If an error occurs when previewing the theme.
# @exitcode 11 If an error occurs when display the help.
function menu_print() {
    # Restore the menu cursor
    ! menu_cursor_top_refresh && return 1
    # Clear to end of screen if resize the screen
    if [[ $ACTION = "RESIZE_SCREEN" ]]; then
        sleep 0.2
        [[ $DISPLAY_ACTION = "O" ]] && DISPLAY_ACTION="P"
        tput ed
        ACTION=""
    fi
    # Check that the prompt is at the bottom of the screen
    local prompt_bottom=0
    [[ ${CURSOR_PROMPT_BOTTOM[0]} -gt $((LINES-2)) ]] && prompt_bottom=1
    # Display the options
    if [[ $DISPLAY_ACTION = "O" ]] || [[ $DISPLAY_ACTION = "L" ]]; then
        ! menu_display_options && return 2
    fi
    # Display the packages
    if [[ $DISPLAY_ACTION = "L" ]]; then
        ! menu_display_packages && return 3
    fi
    # Updating packages
    if [[ $DISPLAY_ACTION = "U" ]]; then
        ! menu_display_update_packages && return 4
    fi
    # Installing packages
    if [[ $DISPLAY_ACTION = "I" ]]; then
        ! menu_display_install_packages && return 5
    fi
    # Install prerequisites
    if [[ $DISPLAY_ACTION = "PI" ]]; then
        ! menu_display_install_prerequisites && return 6
    fi
    # Removing packages
    if [[ $DISPLAY_ACTION = "R" ]]; then
        ! menu_display_remove_packages && return 7
    fi
    # Change profile
    if [[ $DISPLAY_ACTION = "P" ]]; then
        ! menu_display_change_profile && return 8
    fi
    # Change theme
    if [[ $DISPLAY_ACTION = "T" ]]; then
        ! menu_display_change_theme && return 9
    fi
    # Preview a theme
    if [[ $DISPLAY_ACTION = "PREVIEW" ]]; then
        ! menu_display_preview_theme && return 10
    fi
    # Display help
    if [[ $DISPLAY_ACTION = "H" ]]; then
        ! menu_display_help && return 11
    fi
    return 0
}

# @description Display the menu options.
# @noargs
# @set DISPLAY_MODE integer Display mode.
# @set NO_BANNER integer Do not display banner.
# @exitcode 0 If successful.
# @exitcode 1 If unable to initialize cursor position.
# @exitcode 2 If an error has occurred while displaying the banner.
# @exitcode 3 If an error has occurred while displaying menu options.
# @exitcode 4 If an error has occurred while displaying additional information.
# @exitcode 5 If error occurred when saving cursor position.
function menu_display_options() {
    # Reset cursor in display mode 2
    if [[ $DISPLAY_MODE -eq 2 ]]; then
        ! menu_prompt_cursor_init && return 1
    fi
    # Print the banner
    [[ $NO_BANNER -eq 0 ]] && ! menu_print_banner && return 2
    # Display options
    ! menu_print_options && return 3
    # Display additional information
    ! menu_print_infos && return 4
    # Save the prompt cursor
    ! menu_cursor_prompt_save && return 5
    return 0
}

# @description Display the packages.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If error occurred while loading cursor.
# @exitcode 2 If an error has occurred while displaying packages.
function menu_display_packages() {
    [[ $prompt_bottom -gt 0 ]] && tput ed
#        [[ $DISPLAY_MODE -eq 2 ]] && tput ed
    # Move under the prompt
    ! menu_cursor_prompt_bottom_refresh && return 1
#        # Clear to end of screen
    tput ed
    ! menu_list_packages && return 2
    return 0
}

# @description Updating packages.
# @noargs
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @exitcode 0 If successful.
# @exitcode 1 If error occurred while loading cursor.
# @exitcode 2 If unable to initialize cursor position.
function menu_display_update_packages() {
    # Move under the prompt
    ! menu_cursor_prompt_bottom_refresh && return 1
    # Clear to end of screen
    tput ed
    menu_update_packages
    DISPLAY_ACTION="L"
    confirm_continue "Press a key to continue"
    # Reset menu
    ! menu_prompt_cursor_init && return 2
    menu_print
    return 0
}

# @description Installing packages.
# @noargs
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @exitcode 0 If successful.
# @exitcode 1 If error occurred while loading cursor.
# @exitcode 2 If unable to initialize cursor position.
function menu_display_install_packages() {
    # Move under the prompt
    ! menu_cursor_prompt_bottom_refresh && return 1
    # Clear to end of screen
    tput ed
    menu_install_packages
    DISPLAY_ACTION="L"
    confirm_continue "Press a key to continue"
    # Reset menu
    ! menu_prompt_cursor_init && return 2
    menu_print
    return 0
}

# @description Installing prerequisites.
# @noargs
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @exitcode 0 If successful.
# @exitcode 1 If error occurred while loading cursor.
# @exitcode 2 If unable to initialize cursor position.
function menu_display_install_prerequisites() {
    # Move under the prompt
    ! menu_cursor_prompt_bottom_refresh && return 1
    # Clear to end of screen
    tput ed
    menu_preinstall_packages
    DISPLAY_ACTION="L"
    confirm_continue "Press a key to continue"
    # Reset menu
    ! menu_prompt_cursor_init && return 2
    menu_print
    return 0
}

# @description Removing prerequisites.
# @noargs
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @exitcode 0 If successful.
# @exitcode 1 If error occurred while loading cursor.
# @exitcode 2 If unable to initialize cursor position.
function menu_display_remove_packages() {
    # Move under the prompt
    ! menu_cursor_prompt_bottom_refresh && return 1
    # Clear to end of screen
    tput ed
    menu_remove_packages
    DISPLAY_ACTION="L"
    confirm_continue "Press a key to continue"
    # Reset menu
    ! menu_prompt_cursor_init && return 2
    menu_print
    return 0
}

# @description Change profile.
# @noargs
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @exitcode 0 If successful.
# @exitcode 1 If error occurred while loading cursor.
# @exitcode 2 If unable to initialize cursor position.
function menu_display_change_profile() {
    while ! [[ $DISPLAY_ACTION = "L" ]]; do
        # Move under the prompt
        ! menu_cursor_prompt_bottom_refresh && return 1
        # Clear to end of screen
        tput ed
        menu_profile_update
    done
    # Reset menu
    ! menu_prompt_cursor_init && return 2
    menu_print
    return 0
}

# @description Change theme.
# @noargs
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @exitcode 0 If successful.
# @exitcode 1 If error occurred while loading cursor.
# @exitcode 2 If unable to initialize cursor position.
function menu_display_change_theme() {
    while ! [[ $DISPLAY_ACTION = "L" ]]; do
        # Move under the prompt
        ! menu_cursor_prompt_bottom_refresh && return 1
        # Clear to end of screen
        tput ed
        menu_theme_update
    done
    # Reset menu
    ! menu_prompt_cursor_init && return 2
    menu_print
    return 0
}

# @description Theme preview.
# @noargs
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @exitcode 0 If successful.
# @exitcode 1 If unable to initialize cursor position.
# @exitcode 2 If an error has occurred while displaying the banner.
# @exitcode 3 If an error has occurred while displaying menu options.
# @exitcode 4 If an error has occurred while displaying additional information.
# @exitcode 5 If an error has occurred while displaying packages.
function menu_display_preview_theme() {
    ! menu_prompt_cursor_init && return 1
    BANNER_LINES=()
    # Print the banner
    [[ $NO_BANNER -eq 0 ]] && ! menu_print_banner && return 2
    # Display options
    ! menu_print_options && return 3
    # Display additional information
    ! menu_print_infos && return 4
    echo -e "${BADGE_PROMPT} Pick an option ${BADGE_PROMPT_ANSWER} "
    # Display packages
    ! packages_print && return 5
    DISPLAY_ACTION="T"
    return 0
}

# @description Display help.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If error occurred while loading cursor.
function menu_display_help() {
    # Move under the prompt
    ! menu_cursor_prompt_bottom_refresh && return 1
    tput ed
    menu_help
    return 0
}

# @description Determine the action to be taken if an option is selected.
# @noargs
# @set ACTION string User-selected action.
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @set SEARCH_PACKAGES string Name of package to search.
# @set SEARCH_CATEGORY integer Search by category name.
# @set SHOW_ALL integer View package details.
# @set SILENT integer Do not display installation details.
# @set YES integer No confirmation before installation.
# @set INSTALL integer Installing package if set to 1.
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading packages.
function menu_action() {

    DISPLAY_ACTION=""

    # List packages
    if [[ $ACTION = "list_packages" ]]; then
        DISPLAY_ACTION="L"
    fi

    # Search by package
    if [[ $ACTION = "search_packages" ]]; then
        tput ed
        answer="" && confirm_message "Enter a package name"
        SEARCH_PACKAGES=$answer
        ! packages_read && return 1
        DISPLAY_ACTION="L"
    fi

    # Search by category
    if [[ $ACTION = "search_category" ]]; then
        tput ed
        answer="" && confirm_message "Enter a package category"
        SEARCH_CATEGORY=$answer
        ! packages_read && return 1
        DISPLAY_ACTION="L"
    fi

    # Reset filters
    if [[ $ACTION = "reset_filters" ]]; then
        tput ed
        SEARCH_PACKAGES=""
        SEARCH_CATEGORY=""
        INSTALL=0
        ! packages_read && return 1
        DISPLAY_ACTION="L"
    fi

    # Switch info details
    if [[ $ACTION = "show_details" ]]; then
        [[ $SHOW_ALL -eq 0 ]] && SHOW_ALL=1 || SHOW_ALL=0
        DISPLAY_ACTION="L"
    fi

    # Show/Hide installed
    if [[ $ACTION = "show_hide_installed" ]]; then
        [[ $INSTALL -eq 0 ]] && INSTALL=1 || INSTALL=0
        DISPLAY_ACTION="L"
    fi

    # Silent mode
    if [[ $ACTION = "mode_silence" ]]; then
        [[ $SILENT -eq 0 ]] && SILENT=1 || SILENT=0
        DISPLAY_ACTION="O"
    fi

    # No confirmation message
    if [[ $ACTION = "confirmation_message" ]]; then
        [[ $YES -eq 0 ]] && YES=1 || YES=0
        DISPLAY_ACTION="O"
    fi

    # Updating packages
    if [[ $ACTION = "update_packages" ]]; then
        DISPLAY_ACTION="U"
    fi

    # Installing packages
    if [[ $ACTION = "install_packages" ]]; then
        DISPLAY_ACTION="I"
    fi

    # Installing prerequisites
    if [[ $ACTION = "preinstall_packages" ]]; then
        DISPLAY_ACTION="PI"
    fi

    # Remove packages
    if [[ $ACTION = "remove_packages" ]]; then
        DISPLAY_ACTION="R"
    fi

    # Change profile
    if [[ $ACTION = "change_profile" ]]; then
        DISPLAY_ACTION="P"
    fi

    # Change theme
    if [[ $ACTION = "change_theme" ]]; then
        DISPLAY_ACTION="T"
    fi

    # Display help
    if [[ $ACTION = "help" ]]; then
        DISPLAY_ACTION="H"
    fi

    return 0
}

# @description Display menu prompt.
# @noargs
# @set ACTION string User-selected action.
# @set DEBUG integer 1 if debug mode is enabled.
# @exitcode 0 If successful.
# @exitcode 1 If error occurred while loading cursor.
function menu_prompt() {
    debug_pmt "${FUNCNAME[0]}"
    # Prompt
    local answer=""
    if [[ $DEBUG -gt 0 ]]; then
        confirm_message "Pick an option"
    else
        while [[ -z $answer ]]; do
            # Restore the prompt cursor position
            if [[ ${CURSOR_PROMPT_BOTTOM[0]} -lt $LINES ]]; then
                ! menu_cursor_prompt_refresh && return 1
            else
                ! menu_cursor_prompt_top_refresh && return 1
            fi
            # Display the prompt
            confirm_prompt "Pick an option"
        done
    fi
    # Display infos
    case "$answer" in
        # Search
        l) ACTION="list_packages" ;;
        /) ACTION="search_packages" ;;
        c) ACTION="search_category" ;;
        f) ACTION="reset_filters" ;;
        # Package management
        u) ACTION="update_packages" ;;
        i) ACTION="install_packages" ;;
        I) ACTION="preinstall_packages" ;;
        r) ACTION="remove_packages" ;;
        # Options
        n) ACTION="show_hide_installed" ;;
        a) ACTION="show_details" ;;
        s) ACTION="mode_silence" ;;
        y) ACTION="confirmation_message" ;;
        # Miscellaneous
        p) ACTION="change_profile" ;;
        t) ACTION="change_theme" ;;
        h) ACTION="help" ;;
        q) tput ed ; info "Good bye!" && exit ;;
        *) tput ed ; die "Invalid option" ;;
    esac
    menu_action
    menu_print
    menu_prompt
    return 0
}

# @description Display menu and prompt.
# @noargs
# @set MENU_PROMPT integer 1 if display the menu.
# @set DISPLAY_ACTION string Action to be performed in the menu.
# @set DEBUG integer 1 if debug mode is enabled.
# @exitcode 0 If successful.
# @exitcode 1 If unable to initialize cursor position.
# shellcheck disable=SC1090
function menu_prompt_init() {
    debug_pmt "${FUNCNAME[0]} $(display_opts)"
    MENU_PROMPT=1
    # Read packages
    ! packages_read && return 0
    # Initialize and save the top cursor
    ! menu_prompt_cursor_init && return 1
    # To trap terminal resizing
    if [[ $DEBUG -eq 0 ]]; then
        trap 'ACTION="RESIZE_SCREEN" ; menu_print' SIGWINCH
    fi
    # Display the packages by default
    DISPLAY_ACTION="L"
    menu_print
    menu_prompt
    return 0
}

# @description Display packages.
# @noargs
# @set MENU_PROMPT integer 1 if display the menu.
# @set CURSOR_PROMPT_BOTTOM array Contains the position below the prompt.
# @set PACKAGES array List of packages.
# @set LINES integer Terminal height.
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading packages.
# @exitcode 2 If unable to initialize cursor position.
# @exitcode 3 If error occurred while loading cursor.
# @exitcode 4 If an error has occurred while displaying the packages.
# @exitcode 5 If error occurred when saving cursor position.
function menu_list_packages() {
    debug_pmt "${FUNCNAME[0]}"
    [[ ${#PACKAGES[@]} -eq 0 ]] && ! packages_read && return 1
    # Initialize and save the top cursor
    [[ $MENU_PROMPT -eq 0 ]] && ! menu_prompt_cursor_init && return 2
    local prompt_save=0
    if [[ $MENU_PROMPT -gt 0 ]]; then
        local cursor_bottom_lines=${CURSOR_PROMPT_BOTTOM[0]}
        local packages_size=${#PACKAGES[@]}
        # Display packages under the prompt
        if [[ $((cursor_bottom_lines+packages_size+1)) -lt $LINES ]]; then
            ! menu_cursor_prompt_bottom_refresh && return 3
        # Display packages above the prompt
        else
            ! menu_cursor_prompt_top_refresh && return 3
            prompt_save=1
        fi
    fi
    ! packages_print && return 4
    if [[ $prompt_save -gt 0 ]]; then
        echo ""
        ! menu_cursor_prompt_save && return 5
    fi
    return 0
}

# @description Updating packages.
# @noargs
# @set PACKAGES array List of packages.
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading packages.
# @exitcode 2 If unable to initialize cursor position.
# @exitcode 3 If an error has occurred while displaying the packages.
function menu_update_packages() {
    debug_pmt "${FUNCNAME[0]}"
    # Resynchronize packages
    ! packages_read_init && return 1
    # Initialize and save the top cursor
    [[ $MENU_PROMPT -eq 0 ]] && ! menu_prompt_cursor_init && return 2
    # Display packages
    ! packages_print && return 3
    return 0
}

# @description Installing prerequisites.
# @noargs
# @set PACKAGES array List of packages.
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading packages.
# @exitcode 2 If unable to initialize cursor position.
# @exitcode 3 If an error has occurred while installing the prerequisites.
# @exitcode 4 If an error has occurred while updating the packages.
# @exitcode 5 If an error has occurred while displaying the packages.
function menu_preinstall_packages() {
    debug_pmt "${FUNCNAME[0]}"
    if [[ ${#PACKAGES[@]} -eq 0 ]]; then
        ! packages_read && return 1
    fi
    # Initialize and save the top cursor
    [[ $MENU_PROMPT -eq 0 ]] && ! menu_prompt_cursor_init && return 2
    # Installing prerequisites
    ! packages_preinstall && return 3
    # Resynchronize packages
    ! packages_update && return 4
    # Display packages
    ! packages_print && return 5
    return 0
}

# @description Installing packages.
# @noargs
# @set PACKAGES array List of packages.
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading packages.
# @exitcode 2 If unable to initialize cursor position.
# @exitcode 3 If an error has occurred while installing the packages.
# @exitcode 4 If an error has occurred while displaying the packages.
function menu_install_packages() {
    debug_pmt "${FUNCNAME[0]}"
    if [[ ${#PACKAGES[@]} -eq 0 ]]; then
        ! packages_read && return 1
    fi
    # Initialize and save the top cursor
    [[ $MENU_PROMPT -eq 0 ]] && ! menu_prompt_cursor_init && return 2
    ! packages_install && return 3
    # Display packages after install
    ! packages_print && return 4
    return 0
}

# @description Removing packages.
# @noargs
# @set PACKAGES array List of packages.
# @set PACKAGES_REMOVE array List of packages to be deleted.
# @set REMOVE integer Removing package if set to 1.
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading packages.
# @exitcode 2 If no packages can be removed.
# @exitcode 3 If unable to initialize cursor position.
# @exitcode 4 If an error has occurred while displaying the packages.
# @exitcode 5 If an error has occurred while removing the packages.
function menu_remove_packages() {
    debug_pmt "${FUNCNAME[0]}"
    if [[ ${#PACKAGES[@]} -eq 0 ]]; then
        ! packages_read && return 1
    fi
    # Initialize and save the top cursor
    [[ $MENU_PROMPT -eq 0 ]] && ! menu_prompt_cursor_init && return 3
    # Resynchronize packages
    ! packages_update 1> /dev/null
    # Check if there are packages to remove
    if [[ ${#PACKAGES_REMOVE[@]} -eq 0 ]]; then
        warning "No packages to remove" && return 2
    fi
    # Display packages to remove
    REMOVE=1
    # Display the packages to remove
    ! packages_print && return 4
    # Removing packages
    ! packages_remove && return 5
    # Resynchronize after remove
    REMOVE=0
    ! packages_read && return 1
    # Display packages
    ! packages_print && return 4
    return 0
}

# @description Display the help.
# @noargs
# @exitcode 0 If successful.
function menu_help() {
    echo ""
    local output="
${COLORS[YELLOW]}Usage:\n${COLORS[WHITE]}  ./pimpmyterm.sh [options] <packages>\n
${COLORS[YELLOW]}Options:${COLORS[NOCOLOR]}
  ${COLORS[GREEN]}-u, --update${COLORS[WHITE]}              Updating the package index files
  ${COLORS[GREEN]}-i, --install${COLORS[WHITE]}             Installing packages
  ${COLORS[GREEN]}-I, --preinstall${COLORS[WHITE]}          Installing prerequisites
  ${COLORS[GREEN]}-r, --remove${COLORS[WHITE]}              Remove packages
  ${COLORS[GREEN]}-y, --yes${COLORS[WHITE]}                 No confirmation for installation
  ${COLORS[GREEN]}-s, --silent${COLORS[WHITE]}              Do not display installation details
  ${COLORS[GREEN]}-l, --list${COLORS[WHITE]}                List packages
  ${COLORS[GREEN]}-a, --all${COLORS[WHITE]}                 List packages with details
  ${COLORS[GREEN]}-c, --category ${COLORS[RED]}<pattern>${COLORS[WHITE]}  Filter by Category
  ${COLORS[GREEN]}-d, --debug${COLORS[WHITE]}               Show debugging information
  ${COLORS[GREEN]}-h, --help${COLORS[WHITE]}                Print help
  ${COLORS[GREEN]}--no-banner${COLORS[WHITE]}               Do not display the banner
    "
    echo -e "$output\n"|sed '1d; $d'
    return 0
}

# @description Trigger an action based on options passed to the script.
# @noargs
# @set THEMES_PATH string Theme path.
# @set THEME string Current theme.
# @set HELP integer Show help.
# @set MENU_DISPLAY integer Display menu.
# @set LIST integer Display packages.
# @set UPDATE integer Update packages.
# @set INSTALL integer Installing packages.
# @set PRE_INSTALL integer Installing the prerequisites.
# @set REMOVE integer Delete packages.
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading the configuration file.
# @exitcode 2 If an error occurs when reading the profile configuration file.
# @exitcode 3 If an error has occurred while displaying help.
# @exitcode 4 If an error has occurred while displaying menu.
# @exitcode 5 If an error has occurred while displaying packages.
# @exitcode 6 If an error has occurred while updating packages.
# @exitcode 7 If an error has occurred while installing the prerequisites.
# @exitcode 8 If an error has occurred while installing packages.
# @exitcode 9 If an error has occurred while removing packages.
# shellcheck disable=SC1090
function load_menu() {
    debug_pmt "${FUNCNAME[0]} $(display_opts)"
    # Read the configuration file
    ! config_read && return 1
    # Read the profile settings
    ! profile_read_config && return 2
    # Apply the theme
    [[ -f "$THEMES_PATH/$THEME.sh" ]] && source "$THEMES_PATH/$THEME.sh"
    # Display help
    if [[ $HELP -gt 0 ]]; then
        ! menu_help && return 3
        return 0
    fi
    # Display menu
    if [[ $MENU_DISPLAY -gt 0 ]]; then
        ! menu_prompt_init && return 4
        return 0
    fi
    # Display packages
    if [[ $LIST -gt 0 ]]; then
        ! menu_list_packages && return 5
        return 0
    fi
    # Updating packages
    if [[ $UPDATE -gt 0 ]]; then
        ! menu_update_packages && return 6
        return 0
    fi
    # Installing prerequisites
    if [[ $PRE_INSTALL -gt 0 ]]; then
        ! menu_preinstall_packages && return 7
        return 0
    fi
    # Installing packages
    if [[ $INSTALL -gt 0 ]]; then
        ! menu_install_packages && return 8
        return 0
    fi
    # Deleting packages
    if [[ $REMOVE -gt 0 ]]; then
        ! menu_remove_packages && return 9
        return 0
    fi
    return 0
}

# @description Main function of pimpmyterm.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading options passed to the script.
# @exitcode 2 If an error occurs during initialization of the OPTS variable.
# @exitcode 3 If an error has occurred when triggering an action.
function main() {
    ! init_opts "$@" && return 1
    ! get_opts && return 2
    ! load_menu && return 3
    return 0
}

main "$@"
