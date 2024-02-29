#!/usr/bin/env bash
# @name Common
# @brief Common functions.
# @description
#   This library contains the application's common functions.

# GLOBAL VARIABLES ####################################################################################################

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
THEMES_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../themes" &>/dev/null && pwd)
LIB_COMMON="$LIBS_PATH/src/common.sh"

OPTS=()
MENU_DISPLAY=0
LIST=0
UPDATE=0
INSTALL=0
PRE_INSTALL=0
REMOVE=0
PROFILE=""
SEARCH_PACKAGES=()
SEARCH_CATEGORY=""
YES=0
SILENT=0
SHOW_ALL=0
DEBUG=0
HELP=0
NO_BANNER=0

# COLORS ##############################################################################################################

declare -A COLORS
declare -A BG_COLORS

COLORS=(
    [BLACK]='\033[1;30m'
    [RED]='\033[1;31m'
    [GREEN]='\033[1;32m'
    [YELLOW]='\033[1;33m'
    [BLUE]='\033[1;34m'
    [PINK]='\033[1;35m'
    [CYAN]='\033[1;36m'
    [WHITE]='\033[1;37m'
    [NOCOLOR]='\033[1;0m'
    [DISABLED]='\033[1;2m'
    [UNDERLINE]="\033[1;4m"
)

BG_COLORS=(
    [BLACK]='\033[40;7;30m'
    [RED]='\033[41;7;30m'
    [GREEN]='\033[42;7;30m'
    [YELLOW]='\033[43;7;30m'
    [BLUE]='\033[44;7;30m'
    [PINK]='\033[45;7;30m'
    [CYAN]='\033[46;7;30m'
    [WHITE]='\033[47;7;30m'
    [NOCOLOR]='\033[;7;30m'
)

# @description Reading options passed to the script.
# @arg $@ any Options passed as script parameters.
# @set OPTS array Options passed as arguments.
# @set LIST integer Display packages.
# @set HELP integer Show help.
# @set UPDATE integer Update packages.
# @set INSTALL integer Installing packages.
# @set REMOVE integer Delete packages.
# @set SHOW_ALL integer View package details.
# @set SEARCH_CATEGORY integer Search by category name.
# @set SEARCH_PACKAGES integer Search by package name.
# @set DEBUG integer 1 if debug mode is enabled.
# @set YES integer No confirmation before installation.
# @set SILENT integer Do not display installation details.
# @set NO_BANNER integer Do not display banner.
# @exitcode 0 If successful.
function init_opts() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Get options passed as arguments in functions.
# @noargs
# @set OPTS array Options passed as arguments.
# @set LIST integer Display packages.
# @set HELP integer Show help.
# @set UPDATE integer Update packages.
# @set INSTALL integer Installing packages.
# @set REMOVE integer Delete packages.
# @set SHOW_ALL integer View package details.
# @set SEARCH_CATEGORY integer Search by category name.
# @set SEARCH_PACKAGES integer Search by package name.
# @set DEBUG integer 1 if debug mode is enabled.
# @set YES integer No confirmation before installation.
# @set SILENT integer Do not display installation details.
# @set NO_BANNER integer Do not display banner.
# @exitcode 0 If successful.
function get_opts() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Display options passed as arguments in functions.
# @noargs
# @exitcode 0 If successful.
function display_opts() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Check if a URL exists.
# @arg $1 string URL.
# @exitcode 0 If URL exists.
# @exitcode 1 If no URL passed as parameter.
# @exitcode 2 If URL not exists.
function check_url() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Download a file.
# @arg $1 string URL.
# @arg $2 string Destination path.
# @exitcode 0 If the download was successful.
# @exitcode 1 If no URL passed as parameter.
# @exitcode 2 If no destination path passed as parameter.
# @exitcode 3 If an error was encountered while downloading in silent mode.
# @exitcode 4 If an error was encountered during the download with the progress bar.
function download_file() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Display a success message.
# @arg $1 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function success() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display an error message.
# @arg $1 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function die() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display a error message starting with a line break.
# @arg $1 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function die_line_break() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display a warning message.
# @arg $1 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function warning() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display a warning message starting with a line break.
# @arg $1 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function warning_line_break() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display an information message.
# @arg $1 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function info() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display a information message starting with a line break.
# @arg $1 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function info_line_break() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display an information message without adding a new line at the end.
# @arg $1 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function info_no_newline() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display an information message by adding OK at the end.
# @arg $1 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function info_success() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Used by unit tests to display a message
# @arg $1 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function test() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display a debug message.
# @arg $1 string Script path.
# @arg $2 string Message to display.
# @stdout Message displayed in standard output.
# @exitcode 0 If successful.
function debug_script() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Prompt a confirm message.
# @arg $1 string Confirmation message to display.
# @set answer string Answer entered by user.
# @set confirm_answer string Checks that the user has validated.
# @exitcode 0 If successful.
function confirm_message() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Request a confirmation message every half-second.
# @arg $1 string Confirmation message to display.
# @set answer string Answer entered by user.
# @exitcode 0 If successful.
function confirm_prompt() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display a message and wait for user keystroke.
# @arg $1 string Message to display.
# @exitcode 0 If successful.
function confirm_continue() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Display an error message and wait for user keystroke.
# @arg $1 string Error message to display.
# @exitcode 0 If successful.
function die_and_continue() { eval "$(bash "$LIB_COMMON" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} '$*'" ; }

# @description Main function.
# @arg $@ any Options passed as script parameters.
# @exitcode 0 If successful.
# @exitcode 1 No function to call.
# @exitcode 2 Function name does not exist.
function main() {
    [[ -n "${FUNCNAME[2]}" ]] && return 0
    local args=()
    for opt in "$@"; do
        case "$opt" in
            --debug|-d) DEBUG=1 ;;
            --help|-h) HELP=1 ;;
            --update|-u) UPDATE=1 ;;
            --install|-i) INSTALL=1 ;;
            --remove|-r) REMOVE=1 ;;
            --all|-a) SHOW_ALL=1 ;;
            --yes|-y) YES=1 ;;
            --silent|-s) SILENT=1 ;;
            --no-banner) NO_BANNER=1 ;;
            --profile|-p) PROFILE=1 ;;
            --category=*|-c=*) SEARCH_CATEGORY=$(echo "$opt"|awk -F= '{print $2}') ;;
            --packages=*) SEARCH_PACKAGES=("$(echo "$opt"|awk -F= '{print $2}')") ;;
            *) args+=("$opt") ;;
        esac
    done
    [[ -z "${args[0]}" ]] && die "No function to call" && return 1
    ! [[ $(type -t "${args[0]}") == function ]] && die "Function with name '${args[0]}' does not exist" && return 2
    eval "${args[@]}"
}

main "$@"
