# Packages

Package management.

## Overview

This library contains a list of functions for managing packages.

## Index

* [debug_packages](#debugpackages)
* [packages_read_init](#packagesreadinit)
* [packages_read](#packagesread)
* [packages_read_search](#packagesreadsearch)
* [packages_display](#packagesdisplay)
* [packages_display_install](#packagesdisplayinstall)
* [packages_display_header](#packagesdisplayheader)
* [packages_display_packages](#packagesdisplaypackages)
* [packages_calculate_width](#packagescalculatewidth)
* [packages_display_package](#packagesdisplaypackage)
* [packages_update](#packagesupdate)
* [packages_resynchronize](#packagesresynchronize)
* [packages_reset_list](#packagesresetlist)
* [packages_show_progress_bar](#packagesshowprogressbar)
* [packages_read_failed_packages](#packagesreadfailedpackages)
* [packages_cache_update](#packagescacheupdate)
* [packages_dist_update](#packagesdistupdate)
* [packages_preinstall](#packagespreinstall)
* [packages_install](#packagesinstall)
* [packages_install_package](#packagesinstallpackage)
* [packages_remove](#packagesremove)
* [packages_remove_package](#packagesremovepackage)
* [main](#main)

### debug_packages

Displays debug information for packages library.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Displays debug information with date and script name.

### packages_read_init

Reinitialize package information from the cache.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading packages.

### packages_read

Read package information from the cache.

_Function has no arguments._

#### Variables set

* **PACKAGES** (array): List of packages.
* **PACKAGES_DISPLAY** (array): List of packages to display.
* **PACKAGES_INSTALL** (array): List of packages to install.
* **PACKAGES_REMOVE** (array): List of packages to be deleted.
* **PACKAGES_INIT** (init): If 1, resets package list.
* **CACHE_PATH** (string): Path to cache folder.
* **PROFILE** (string): Profile name.
* **LAST_UPDATE** (string): Date of last update.
* **SEARCH_PACKAGES** (string): Name of package to search.
* **SEARCH_CATEGORY** (string): Name of category to search.

#### Exit codes

* **0**: If successful.
* **1**: If profile not found.
* **2**: If the package update was not successful.
* **3**: If the cache file has not been successfully created.

### packages_read_search

Check if the package is to be displayed.

_Function has no arguments._

#### Variables set

* **SEARCH_PACKAGES** (string): Name of package to search.
* **SEARCH_CATEGORY** (string): Name of category to search.

#### Exit codes

* **0**: If successful.
* **1**: If the package name does not match the one you are looking for.
* **2**: If the package category does not match the one you are looking for.

### packages_display

Display the list of packages, depending on the display settings.

_Function has no arguments._

#### Variables set

* **DEFAULT_PACKAGE_MANAGER** (string): Distribution package manager.
* **PACKAGES_DISPLAY** (array): List of packages to display.
* **PACKAGES_INSTALL** (array): List of packages to install.
* **PACKAGES_REMOVE** (array): List of packages to be deleted.

#### Exit codes

* **0**: If successful.
* **1**: Unable to determine default package manager.
* **2**: Unable to display column headers for packages to be installed.
* **3**: Unable to display packages to be installed.
* **4**: Unable to display column headers for packages to be deleted.
* **5**: Unable to display packages to be deleted.
* **6**: Unable to display column headers for packages to be displayed.
* **7**: Unable to display packages.

#### Output on stdout

* Displaying the list of packages.

### packages_display_install

Display the list of packages to be installed.

_Function has no arguments._

#### Variables set

* **PACKAGES_INSTALL** (array): List of packages to install.

#### Exit codes

* **0**: If successful.
* **1**: Unable to display column headers for packages to be installed.
* **2**: Unable to display packages to be installed.

### packages_display_header

Display column headers.

_Function has no arguments._

#### Variables set

* **SHOW_ALL** (integer): If 1 display all columns.

#### Exit codes

* **0**: If successful.
* **1**: Error when calculating column widths.

#### Output on stdout

* Column headers to be displayed.

### packages_display_packages

Display the list of packages to display, install or remove.

#### Arguments

* **$1** (string): target, P: packages to display, I: packages to install, R: packages to remove.

#### Variables set

* **PACKAGES_DISPLAY** (array): List of packages to display.
* **PACKAGES_INSTALL** (array): List of packages to install.
* **PACKAGES_REMOVE** (array): List of packages to be deleted.

#### Exit codes

* **0**: If successful.
* **1**: Unable to display packages.
* **2**: Unable to display packages to be installed.
* **3**: Unable to display packages to be removed.

#### Output on stdout

* Displaying the list of packages.

### packages_calculate_width

Calculate column width.

_Function has no arguments._

#### Variables set

* **PACKAGES_DISPLAY** (array): List of packages to display.
* **PACKAGES_INSTALL** (array): List of packages to install.
* **PACKAGES_REMOVE** (array): List of packages to be deleted.
* **COLUMNS** (string): Terminal width.
* **SHOW_ALL** (integer): If 1 display all columns.

#### Exit codes

* **0**: If successful.
* **1**: Terminal width too small to display packages.

### packages_display_package

Display a package.

_Function has no arguments._

#### Variables set

* **DEFAULT_PACKAGE_MANAGER** (string): Distribution package manager.
* **PACKAGES_COLUMN** (array): Color settings for the line to be displayed.
* **SHOW_ALL** (integer): If 1 display all columns.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Package information to display.

### packages_update

Resynchronize package information and update cache.

_Function has no arguments._

#### Variables set

* **DEFAULT_PACKAGE_MANAGER** (string): Distribution package manager.
* **PROFILE_PACKAGES** (array): List of packages retrieved from the profile configuration file.
* **PACKAGES** (array): List of packages.
* **PACKAGES_DISPLAY** (array): List of packages to display.
* **PACKAGES_INSTALL** (array): List of packages to install.
* **PACKAGES_REMOVE** (array): List of packages to be deleted.
* **PACKAGES_INIT** (init): If 1, resets package list.

#### Exit codes

* **0**: If successful.
* **1**: Unable to retrieve package information from profile configuration file.
* **2**: Unable to retrieve package information.
* **3**: Unable to display errors.
* **4**: Error updating profile configuration file.
* **5**: Error updating date in profile configuration file.
* **6**: Cache reset error.

### packages_resynchronize

Resynchronize package information.

_Function has no arguments._

#### Variables set

* **DEFAULT_PACKAGE_MANAGER** (string): Distribution package manager.
* **PROFILE_PACKAGES** (array): List of packages retrieved from the profile configuration file.

#### Exit codes

* **0**: If successful.
* **1**: Unable to determine default package manager.
* **2**: Error displaying progress bar.
* **3**: Error updating package list.

### packages_reset_list

Reinitialize the list of packages using the information retrieved.

_Function has no arguments._

#### Variables set

* **PACKAGES** (array): List of packages.
* **PACKAGES_DISPLAY** (array): List of packages to display.
* **PACKAGES_INSTALL** (array): List of packages to install.
* **PACKAGES_REMOVE** (array): List of packages to be deleted.
* **PACKAGES_INIT** (init): If 1, resets package list.

#### Exit codes

* **0**: If successful.

### packages_show_progress_bar

Show progress bar.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### packages_read_failed_packages

Display list of packages whose information could not be found.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### packages_cache_update

Cache index reset.

_Function has no arguments._

#### Variables set

* **PACKAGES** (array): List of packages.
* **CACHE_PATH** (string): Path to cache folder.
* **PROFILE** (string): Profile name.

#### Exit codes

* **0**: If successful.
* **1**: No packages found to write to cache.

### packages_dist_update

Updating the package manager index.

_Function has no arguments._

#### Variables set

* **DEFAULT_PACKAGE_MANAGER** (string): Distribution package manager.

#### Exit codes

* **0**: If successful.
* **1**: Unable to determine default package manager.
* **2**: Error updating index with apt.

### packages_preinstall

Installation of prerequisites.

_Function has no arguments._

#### Variables set

* **PACKAGES_INSTALL** (array): List of packages to install.

#### Exit codes

* **0**: If successful.
* **1**: Unable to retrieve prerequisites.
* **2**: No prerequisites to install.
* **3**: Installation canceled.
* **4**: No prerequisites installed.

### packages_install

Packages installation.

_Function has no arguments._

#### Variables set

* **PACKAGES_INSTALL** (array): List of packages to install.
* **INSTALL** (integer): Use to display the packages to be installed.

#### Exit codes

* **0**: If successful.
* **1**: Error updating package manager index.
* **2**: No packages to install.
* **3**: Error displaying packages to install.
* **4**: Installation canceled.
* **5**: Package installation error.
* **6**: Error when reading packages.
* **7**: Error when updating packages.

### packages_install_package

Package installation.

_Function has no arguments._

#### Variables set

* **DEFAULT_PACKAGE_MANAGER** (string): Distribution package manager.

#### Exit codes

* **0**: If successful.
* **1**: Unable to determine default package manager.
* **2**: Error when installing package with apt.
* **3**: Error when installing package from script.

### packages_remove

Packages deletion.

_Function has no arguments._

#### Variables set

* **PACKAGES_REMOVE** (array): List of packages to remove.

#### Exit codes

* **0**: If successful.
* **1**: No packages to remove.
* **2**: Remove packages canceled.
* **3**: Package remove error.
* **4**: Error when reading packages.
* **5**: Error when updating packages.

### packages_remove_package

Delete package.

_Function has no arguments._

#### Variables set

* **DEFAULT_PACKAGE_MANAGER** (string): Distribution package manager.

#### Exit codes

* **0**: If successful.
* **1**: Unable to determine default package manager.
* **2**: Error when removing package with apt.
* **3**: Error when removing package from script.

### main

Main function.

#### Arguments

* **...** (any): Options passed as script parameters.

#### Exit codes

* **0**: If successful.
* **1**: No function to call.
* **2**: Function name does not exist.

