#!/usr/bin/env bash

# GLOBAL VARIABLES ####################################################################################################

PID_PARENT=$(ps -o args= $PPID|grep "bash "|head -n1|awk '{ print $2 }')

# OPTS ################################################################################################################

# shellcheck disable=SC2167
function init_opts() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    read -ra opts <<< "$@"
    local action=""
    local skip_next=0
    for i in "${!opts[@]}"; do
        [[ $skip_next -gt 0 ]] && skip_next=0 && continue
        opt="${opts[$i]}"
        #  Remove first and last quote if necessary
        opt=$(echo "$opt"|sed -e "s/^'//" -e "s/'$//")
        case "$opt" in
            # Updating/installing packages
            --update|-u) UPDATE=1 ;;
            --install|-i) INSTALL=1 ;;
            --preinstall|-I) PRE_INSTALL=1 ;;
            --remove|-r) REMOVE=1 ;;
            --yes|-y) YES=1 ;;
            --silent|-s) SILENT=1 ;;
            # List packages
            --list|-l) LIST=1 ;;
            --all|-a) SHOW_ALL=1 ;;
            # Filter packages
            --category=*|-c=*) SEARCH_CATEGORY=$(echo "$opt"|awk -F= '{print $2}') ;;
            --category|-c) SEARCH_CATEGORY="${opts[$((i+1))]}" ; skip_next=1 ;;
            # Miscellaneous
            --no-banner) NO_BANNER=1 ;;
            --debug|-d) DEBUG=1 ;;
            --help|-h) HELP=1 ;;
            # Other options
            -*)
                # shellcheck disable=SC2165
                for ((i = 0; i < ${#opt}; i++)); do
                    [[ "${opt:i:1}" = "-" ]] && continue
                    [[ "${opt:i:1}" = "u" ]] && UPDATE=1 && continue
                    [[ "${opt:i:1}" = "i" ]] && INSTALL=1 && continue
                    [[ "${opt:i:1}" = "I" ]] && PRE_INSTALL=1 && continue
                    [[ "${opt:i:1}" = "r" ]] && REMOVE=1 && continue
                    [[ "${opt:i:1}" = "y" ]] && YES=1 && continue
                    [[ "${opt:i:1}" = "s" ]] && SILENT=1 && continue
                    [[ "${opt:i:1}" = "l" ]] && LIST=1 && continue
                    [[ "${opt:i:1}" = "a" ]] && SHOW_ALL=1 && continue
                    [[ "${opt:i:1}" = "d" ]] && DEBUG=1 && continue
                    die "Option $opt does not exist!" && HELP=1 && break
                done
                ;;
            *) SEARCH_PACKAGES+=("$opt") ;;
        esac
    done
    [[ $((HELP+LIST+UPDATE+PRE_INSTALL+INSTALL+REMOVE)) -eq 0 ]] && MENU_DISPLAY=1
    return 0
}

function get_opts() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    OPTS=()
    local search_packages="" search_packages_lower=""
    local script_parent=${FUNCNAME[2]}
    # Adding options
    [[ $HELP -gt 0 ]] && OPTS+=("--help")
    [[ $UPDATE -gt 0 ]] && OPTS+=("--update")
    [[ $INSTALL -gt 0 ]] && OPTS+=("--install")
    [[ $REMOVE -gt 0 ]] && OPTS+=("--remove")
    [[ $LIST -gt 0 ]] && OPTS+=("--list")
    [[ $SHOW_ALL -gt 0 ]] && OPTS+=("--all")
    [[ $DEBUG -gt 0 ]] && OPTS+=("--debug")
    [[ $YES -gt 0 ]] && OPTS+=("--yes")
    [[ $SILENT -gt 0 ]] && OPTS+=("--silent")
    [[ $NO_BANNER -gt 0 ]] && OPTS+=("--no-banner")
    [[ -n $SEARCH_CATEGORY ]] && OPTS+=("--category=$SEARCH_CATEGORY")
    [[ -n $PROFILE ]] && OPTS+=("--profile=$PROFILE")
    [[ -n $THEME ]] && OPTS+=("--theme=$THEME")
    # Search package
    if [[ ${#SEARCH_PACKAGES[@]} -gt 0 ]]; then
        for i in "${!SEARCH_PACKAGES[@]}"; do
            [[ -z ${SEARCH_PACKAGES[$i]} ]] && continue
            search_packages_lower=$(echo "${SEARCH_PACKAGES[$i]}" | awk '{print tolower($0)}')
            [[ $i -eq 0 ]] && search_packages="$search_packages_lower" && continue
            search_packages+="|$search_packages_lower"
        done
        OPTS+=("--packages=\"$search_packages\"")
    fi
    return 0
}

function display_opts() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local display_opts="" opt="" opt_clean="" tmp_opts=()
    # Reload the options list
    get_opts
    # Get the options to display
    for i in "${!OPTS[@]}"; do
        opt="${OPTS[$i]}"
        opt_clean=${opt//\'/}
        [[ $i -eq 0 ]] && display_opts="$opt_clean" && continue
        [[ -n $opt_clean ]] && display_opts+=" $opt_clean"
    done
    echo "$display_opts"
    return 0
}

function check_url() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local url=$1
    [[ -z $url ]] && return 1
    if ! wget -q --method=HEAD "$url"; then
        return 2
    fi
    return 0
}

function download_file() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local url=$1
    local destination_path=$2
    [[ -z $url ]] && return 1
    [[ -z $destination_path ]] && return 2
    # Silent download
    if [[ $SILENT -gt 0 ]]; then
        if ! wget "$url" -O "$destination_path" -q > /dev/null; then
            return 3
        fi
    # Download with progress bar
    else
        if ! wget "$url" -O "$destination_path" -q --show-progress > /dev/null; then
            return 4
        fi
    fi
    return 0
}

# MESSAGES ############################################################################################################

function success() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local message=${1//\'/}
    [[ -z $message ]] && return 1
    if [[ -n ${BADGE_SUCCESS} ]]; then
        echo -e "${BADGE_SUCCESS} $message ${COLORS[NOCOLOR]}"
    else
        echo -e "\033[0;32m$message\033[0;0m"
    fi
    return 0
}

function die() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local message=${1//\'/}
    [[ -z $message ]] && return 1
    if [[ -n ${BADGE_DIE} ]]; then
        echo -e "${BADGE_DIE} $message ${COLORS[NOCOLOR]}"
    else
        echo -e "\033[0;31m$message\033[0;0m"
    fi
    return 0
}

function die_line_break() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local message=${1//\'/}
    [[ -z $message ]] && return 1
    if [[ -n ${BADGE_DIE} ]]; then
        echo -e "\n${BADGE_DIE} $message ${COLORS[NOCOLOR]}"
    else
        echo -e "\n\033[0;31m$message\033[0;0m"
    fi
    return 0
}

function warning() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local message=${1//\'/}
    [[ -z $message ]] && return 1
    if [[ -n ${BADGE_WARNING} ]]; then
        echo -e "${BADGE_WARNING} $message ${COLORS[NOCOLOR]}"
    else
        echo -e "\033[0;33m$message\033[0;0m"
    fi
    return 0
}

function warning_line_break() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local message=${1//\'/}
    [[ -z $message ]] && return 1
    if [[ -n ${BADGE_DIE} ]]; then
        echo -e "\n${BADGE_DIE} $message ${COLORS[NOCOLOR]}"
    else
        echo -e "\n\033[0;33m$message\033[0;0m"
    fi
    return 0
}

function info() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local message=${1//\'/}
    [[ -z $message ]] && return 1
    if [[ -n ${BADGE_INFO} ]]; then
        echo -e "${BADGE_INFO} $message ${COLORS[NOCOLOR]}"
    else
        echo -e "\033[0;37m$message\033[0;0m"
    fi
    return 0
}

function info_line_break() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local message=${1//\'/}
    [[ -z $message ]] && return 1

    if [[ -n ${BADGE_INFO} ]]; then
        echo -e "\n${BADGE_INFO} $message ${COLORS[NOCOLOR]}"
    else
        echo -e "\n\033[0;37m$message\033[0;0m"
    fi
    return 0
}

function info_no_newline() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local message=${1//\'/}
    [[ -z $message ]] && return 1
    [[ $MENU_PROMPT -eq 0 ]] && info "$message" && return 0
    if [[ -n ${BADGE_INFO} ]]; then
        echo -ne "${BADGE_INFO} $message ${COLORS[NOCOLOR]}\r"
    else
        echo -ne "\033[0;37m$message\033[0;0m\r"
    fi
    return 0
}

function info_success() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local message=${1//\'/}
    [[ -z $message ]] && return 1
    [[ $MENU_PROMPT -eq 0 ]] && info "$message" && return 0
    # CLear current line
    echo -ne "\033[2K\r"
    if [[ -n ${BADGE_INFO} ]]; then
        echo -e "${BADGE_INFO} $message ${BADGE_SUCCESS}OK${COLORS[NOCOLOR]}"
    else
        echo -e "\033[0;37m$message \033[0;32mOK\033[0;0m"
    fi
    return 0
}

function debug_script() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    [[ ${DEBUG:-0} -eq 0 ]] && return 0
    local debug_path="$1"
    local output=""
    read -ra words <<< "${@:2}"
    for i in "${!words[@]}"; do
        word="${words[$i]}"
        [[ $i -eq 0 ]] && word="${COLORS[GREEN]}$word"
        [[ $i -gt 0 ]] && word="${COLORS[WHITE]}$word"
        output+="$word "
    done
    printf "${COLORS[BLUE]}%s %-20s $output${COLORS[NOCOLOR]}\n" "[$(date "+%y/%m/%d %H:%M:%S")]" "[$debug_path]"
    return 0
}

function test() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local message=${1//\'/}
    [[ ${TEST:-0} -gt 0 ]] && echo "$message"
    return 0
}

function confirm_message() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    answer="" confirm_answer=""
    local message=${1//\'/}
    # Prompt a confirm message
    if [[ -n ${BADGE_CONFIRM} ]]; then
        read -rp "$(echo -e "${BADGE_CONFIRM} ${message} ${BADGE_PROMPT_ANSWER} ")" answer
        echo -ne "${COLORS[NOCOLOR]}"
    else
        read -rp "$(echo -e "${message} ")" answer
    fi
    # Check answer
    [[ -z $answer ]] && confirm_answer="y" && return 0
    case "$answer" in
        [yY][eE][sS]|[yY]) confirm_answer="y" ;;
        *) confirm_answer="" ;;
    esac
    return 0
}

function confirm_prompt() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    answer=""
    local message=${1//\'/}
    # Prompt a confirm message
    read -t0.5 -n1 -rp "$(echo -e "${BADGE_PROMPT} ${message} ${BADGE_PROMPT_ANSWER} ")" answer
    echo -e "${COLORS[NOCOLOR]}"
    return 0
}

function confirm_continue() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local answer=""
    local message=${1//\'/}
    # Continues when a key is pressed
    read -n1 -rp "$(echo -e "${BADGE_PROMPT} ${message} ${BADGE_PROMPT_ANSWER} ")" answer
    echo -e "${COLORS[NOCOLOR]}"
    return 0
}

function die_and_continue() {
    [[ -n $PID_PARENT ]] && declare -f "${FUNCNAME[0]}" && return 0
    local answer=""
    local message=${1//\'/}
    # Continues when a key is pressed
    read -n1 -rp "$(echo -e "${BADGE_DIE} ${message} ")" answer
    echo -e "${COLORS[NOCOLOR]}"
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
