#!/usr/bin/env bash
# @name Packages
# @brief Package management.
# @description
#   This library contains a list of functions for managing packages.

LIBS_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
LIB_PACKAGES="$LIBS_PATH/src/packages.sh"
CACHE_PATH="$(dirname -- "$LIBS_PATH")/.cache"

# @description Displays debug information for packages library.
# @noargs
# @stdout Displays debug information with date and script name.
# @exitcode 0 If successful.
function debug_packages() { debug_script "./libs/packages.sh" "$*" ; }

# @description Reinitialize package information from the cache.
# @noargs
# @exitcode 0 If successful.
# @exitcode 1 If an error occurs when reading packages.
function packages_read_init() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Read package information from the cache.
# @noargs
# @set PACKAGES array List of packages.
# @set PACKAGES_DISPLAY array List of packages to display.
# @set PACKAGES_INSTALL array List of packages to install.
# @set PACKAGES_REMOVE array List of packages to be deleted.
# @set PACKAGES_INIT init If 1, resets package list.
# @set CACHE_PATH string Path to cache folder.
# @set PROFILE string Profile name.
# @set LAST_UPDATE string Date of last update.
# @set SEARCH_PACKAGES string Name of package to search.
# @set SEARCH_CATEGORY string Name of category to search.
# @exitcode 0 If successful.
# @exitcode 1 If profile not found.
# @exitcode 2 If the package update was not successful.
# @exitcode 3 If the cache file has not been successfully created.
function packages_read() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Check if the package is to be displayed.
# @noargs
# @set SEARCH_PACKAGES string Name of package to search.
# @set SEARCH_CATEGORY string Name of category to search.
# @exitcode 0 If successful.
# @exitcode 1 If the package name does not match the one you are looking for.
# @exitcode 2 If the package category does not match the one you are looking for.
function packages_read_search() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Display the list of packages, depending on the display settings.
# @noargs
# @stdout Displaying the list of packages.
# @set DEFAULT_PACKAGE_MANAGER string Distribution package manager.
# @set PACKAGES_DISPLAY array List of packages to display.
# @set PACKAGES_INSTALL array List of packages to install.
# @set PACKAGES_REMOVE array List of packages to be deleted.
# @exitcode 0 If successful.
# @exitcode 1 Unable to determine default package manager.
# @exitcode 2 Unable to display column headers for packages to be installed.
# @exitcode 3 Unable to display packages to be installed.
# @exitcode 4 Unable to display column headers for packages to be deleted.
# @exitcode 5 Unable to display packages to be deleted.
# @exitcode 6 Unable to display column headers for packages to be displayed.
# @exitcode 7 Unable to display packages.
function packages_display() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Display the list of packages to be installed.
# @noargs
# @set PACKAGES_INSTALL array List of packages to install.
# @exitcode 0 If successful.
# @exitcode 1 Unable to display column headers for packages to be installed.
# @exitcode 2 Unable to display packages to be installed.
function packages_display_install() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Display column headers.
# @noargs
# @stdout Column headers to be displayed.
# @set SHOW_ALL integer If 1 display all columns.
# @exitcode 0 If successful.
# @exitcode 1 Error when calculating column widths.
function packages_display_header() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Display the list of packages to display, install or remove.
# @arg $1 string target, P: packages to display, I: packages to install, R: packages to remove.
# @stdout Displaying the list of packages.
# @set PACKAGES_DISPLAY array List of packages to display.
# @set PACKAGES_INSTALL array List of packages to install.
# @set PACKAGES_REMOVE array List of packages to be deleted.
# @exitcode 0 If successful.
# @exitcode 1 Unable to display packages.
# @exitcode 2 Unable to display packages to be installed.
# @exitcode 3 Unable to display packages to be removed.
function packages_display_packages() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]} $*" ; }

# @description Calculate column width.
# @noargs
# @set PACKAGES_DISPLAY array List of packages to display.
# @set PACKAGES_INSTALL array List of packages to install.
# @set PACKAGES_REMOVE array List of packages to be deleted.
# @set COLUMNS string Terminal width.
# @set SHOW_ALL integer If 1 display all columns.
# @exitcode 0 If successful.
# @exitcode 1 Terminal width too small to display packages.
function packages_calculate_width() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Display a package.
# @noargs
# @stdout Package information to display.
# @set DEFAULT_PACKAGE_MANAGER string Distribution package manager.
# @set PACKAGES_COLUMN array Color settings for the line to be displayed.
# @set SHOW_ALL integer If 1 display all columns.
# @exitcode 0 If successful.
function packages_display_package() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Resynchronize package information and update cache.
# @noargs
# @set DEFAULT_PACKAGE_MANAGER string Distribution package manager.
# @set PROFILE_PACKAGES array List of packages retrieved from the profile configuration file.
# @set PACKAGES array List of packages.
# @set PACKAGES_DISPLAY array List of packages to display.
# @set PACKAGES_INSTALL array List of packages to install.
# @set PACKAGES_REMOVE array List of packages to be deleted.
# @set PACKAGES_INIT init If 1, resets package list.
# @exitcode 0 If successful.
# @exitcode 1 Unable to retrieve package information from profile configuration file.
# @exitcode 2 Unable to retrieve package information.
# @exitcode 3 Unable to display errors.
# @exitcode 4 Error updating profile configuration file.
# @exitcode 5 Error updating date in profile configuration file.
# @exitcode 6 Cache reset error.
function packages_update() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Resynchronize package information.
# @noargs
# @set DEFAULT_PACKAGE_MANAGER string Distribution package manager.
# @set PROFILE_PACKAGES array List of packages retrieved from the profile configuration file.
# @exitcode 0 If successful.
# @exitcode 1 Unable to determine default package manager.
# @exitcode 2 Error displaying progress bar.
# @exitcode 3 Error updating package list.
function packages_resynchronize() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Reinitialize the list of packages using the information retrieved.
# @noargs
# @set PACKAGES array List of packages.
# @set PACKAGES_DISPLAY array List of packages to display.
# @set PACKAGES_INSTALL array List of packages to install.
# @set PACKAGES_REMOVE array List of packages to be deleted.
# @set PACKAGES_INIT init If 1, resets package list.
# @exitcode 0 If successful.
function packages_reset_list() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Show progress bar.
# @noargs
# @exitcode 0 If successful.
function packages_show_progress_bar() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Display list of packages whose information could not be found.
# @noargs
# @exitcode 0 If successful.
function packages_read_failed_packages() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Cache index reset.
# @noargs
# @set PACKAGES array List of packages.
# @set CACHE_PATH string Path to cache folder.
# @set PROFILE string Profile name.
# @exitcode 0 If successful.
# @exitcode 1 No packages found to write to cache.
function packages_cache_update() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Updating the package manager index.
# @noargs
# @set DEFAULT_PACKAGE_MANAGER string Distribution package manager.
# @exitcode 0 If successful.
# @exitcode 1 Unable to determine default package manager.
# @exitcode 2 Error updating index with apt.
function packages_dist_update() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Installation of prerequisites.
# @noargs
# @set PACKAGES_INSTALL array List of packages to install.
# @exitcode 0 If successful.
# @exitcode 1 Unable to retrieve prerequisites.
# @exitcode 2 No prerequisites to install.
# @exitcode 3 Installation canceled.
# @exitcode 4 No prerequisites installed.
function packages_preinstall() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Packages installation.
# @noargs
# @set PACKAGES_INSTALL array List of packages to install.
# @set INSTALL integer Use to display the packages to be installed.
# @exitcode 0 If successful.
# @exitcode 1 Error updating package manager index.
# @exitcode 2 No packages to install.
# @exitcode 3 Error displaying packages to install.
# @exitcode 4 Installation canceled.
# @exitcode 5 Package installation error.
# @exitcode 6 Error when reading packages.
# @exitcode 7 Error when updating packages.
function packages_install() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Package installation.
# @noargs
# @set DEFAULT_PACKAGE_MANAGER string Distribution package manager.
# @exitcode 0 If successful.
# @exitcode 1 Unable to determine default package manager.
# @exitcode 2 Error when installing package with apt.
# @exitcode 3 Error when installing package from script.
function packages_install_package() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Packages deletion.
# @noargs
# @set PACKAGES_REMOVE array List of packages to remove.
# @exitcode 0 If successful.
# @exitcode 1 No packages to remove.
# @exitcode 2 Remove packages canceled.
# @exitcode 3 Package remove error.
# @exitcode 4 Error when reading packages.
# @exitcode 5 Error when updating packages.
function packages_remove() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

# @description Delete package.
# @noargs
# @set DEFAULT_PACKAGE_MANAGER string Distribution package manager.
# @exitcode 0 If successful.
# @exitcode 1 Unable to determine default package manager.
# @exitcode 2 Error when removing package with apt.
# @exitcode 3 Error when removing package from script.
function packages_remove_package() { eval "$(bash "$LIB_PACKAGES" "${FUNCNAME[0]}") ; ${FUNCNAME[0]}" ; }

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
            --packages=*) SEARCH_PACKAGES=$(echo "$opt"|awk -F= '{print $2}') ;;
            --category=*) SEARCH_CATEGORY=$(echo "$opt"|awk -F= '{print $2}') ;;
            --all) SHOW_ALL=1 ;;
            --yes) YES=1 ;;
            # A list of packages to debug
            --debug-packages=*) mapfile -t PACKAGES < <(echo "$opt"|awk -F= '{print $2}') ;;
            *) args+=("$opt") ;;
        esac
    done
    [[ -z "${args[0]}" ]] && die "No function to call" && return 1
    ! [[ $(type -t "${args[0]}") == function ]] && die "Function with name '${args[0]}' does not exist" && return 2
    eval "${args[@]}"
}

main "$@"
