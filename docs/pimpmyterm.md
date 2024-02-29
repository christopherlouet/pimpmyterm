# PimpMyTerm

**pimpmyterm.sh** is a utility to help you customize your terminal and manage the installation

## Overview

This utility enables you to perform the following actions:

* Updating packages
* Installing prerequisites
* Installing packages
* Removing packages
* Search a package by name or category
* Change profile
* Change theme

## Index

* [debug_pmt](#debugpmt)
* [menu_print_banner](#menuprintbanner)
* [menu_print_options](#menuprintoptions)
* [menu_configure_options](#menuconfigureoptions)
* [menu_print_infos](#menuprintinfos)
* [menu_cursor_save](#menucursorsave)
* [menu_prompt_cursor_init](#menupromptcursorinit)
* [menu_cursor_top_save](#menucursortopsave)
* [menu_cursor_prompt_save](#menucursorpromptsave)
* [menu_cursor_top_refresh](#menucursortoprefresh)
* [menu_cursor_prompt_refresh](#menucursorpromptrefresh)
* [menu_cursor_prompt_top_refresh](#menucursorprompttoprefresh)
* [menu_cursor_prompt_bottom_refresh](#menucursorpromptbottomrefresh)
* [menu_profile_update](#menuprofileupdate)
* [menu_theme_update](#menuthemeupdate)
* [menu_print](#menuprint)
* [menu_display_options](#menudisplayoptions)
* [menu_display_packages](#menudisplaypackages)
* [menu_display_update_packages](#menudisplayupdatepackages)
* [menu_display_install_packages](#menudisplayinstallpackages)
* [menu_display_install_prerequisites](#menudisplayinstallprerequisites)
* [menu_display_remove_packages](#menudisplayremovepackages)
* [menu_display_change_profile](#menudisplaychangeprofile)
* [menu_display_change_theme](#menudisplaychangetheme)
* [menu_display_preview_theme](#menudisplaypreviewtheme)
* [menu_display_help](#menudisplayhelp)
* [menu_action](#menuaction)
* [menu_prompt](#menuprompt)
* [menu_prompt_init](#menupromptinit)
* [menu_list_packages](#menulistpackages)
* [menu_update_packages](#menuupdatepackages)
* [menu_preinstall_packages](#menupreinstallpackages)
* [menu_install_packages](#menuinstallpackages)
* [menu_remove_packages](#menuremovepackages)
* [menu_help](#menuhelp)
* [load_menu](#loadmenu)
* [main](#main)

### debug_pmt

Debug the library.

_Function has no arguments._

#### Variables set

* **DEBUG_PATH** (string): Path to library to be debugged.

#### Exit codes

* **0**: If successful.

### menu_print_banner

Display the banner.

_Function has no arguments._

#### Variables set

* **DEBUG** (integer): If 1, do not display the banner.
* **BANNER_LINES** (array): Contains the banner content.
* **BANNER_COLUMNS** (integer): Banner width.
* **MENU_PROMPT_COLORS** (array): Contains the banner colour settings.

#### Exit codes

* **0**: If successful.

### menu_print_options

Display menu options.

_Function has no arguments._

#### Variables set

* **DISPLAY_MODE** (integer): Display mode.
* **OPTIONS_LINES** (array): Contains menu items.
* **MENU_HEADER_LEFT** (array): Contains the colours of the left-hand part of a column header.
* **MENU_HEADER_RIGHT** (array): Contains the colours of the right-hand part of a column header.
* **MENU_COLUMN_LEFT** (array): Contains the colours of the left-hand side of a column.
* **MENU_COLUMN_RIGHT** (array): Contains the colours of the right-hand side of a column.
* **MENU_COLUMN_RIGHT_ENABLED** (array): Contains the colours on the right-hand side of a deactivated column.

#### Exit codes

* **0**: If successful.
* **1**: If an error has been encountered when configuring the options.

### menu_configure_options

Configure menu options.

_Function has no arguments._

#### Variables set

* **OPTIONS_LINES** (array): Contains menu items.
* **DISPLAY_MODE** (integer): Display mode.

#### Exit codes

* **0**: If successful.

### menu_print_infos

Display various information in the menu header.

_Function has no arguments._

#### Variables set

* **PROFILE** (string): Current profile.
* **THEME** (string): Current theme.
* **SEARCH_CATEGORY** (string): Category to search.
* **SEARCH_PACKAGES** (string): Packages to search.
* **PACKAGES** (array): List of packages.
* **PACKAGES_DISPLAY** (array): List of packages to display.
* **PACKAGES_INSTALL** (array): List of packages to install.
* **PACKAGES_REMOVE** (array): List of packages to be deleted.
* **MENU_BADGE_LEFT** (string): Color of the left side of the menu badge.
* **MENU_BADGE_RIGHT** (string): Color of the right side of the menu badge.
* **MENU_BADGE_SEARCH_LEFT** (string): Color of the left side of the search badge.
* **MENU_BADGE_SEARCH_RIGHT** (string): Color of the right side of the search badge.

#### Exit codes

* **0**: If successful.

### menu_cursor_save

Saves the current cursor position in an array.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### menu_prompt_cursor_init

Initializes cursor position at menu launch.

_Function has no arguments._

#### Variables set

* **MENU_PROMPT** (integer): 1 if display the menu.
* **DEBUG** (integer): 1 if debug mode is enabled.

#### Exit codes

* **0**: If successful.

### menu_cursor_top_save

Saves the position at the top of the menu.

_Function has no arguments._

#### Variables set

* **MENU_PROMPT** (integer): 1 if display the menu.
* **DEBUG** (integer): 1 if debug mode is enabled.
* **CURSOR_TOP** (array): Contains the position at the top of the menu.

#### Exit codes

* **0**: If successful.

### menu_cursor_prompt_save

Saves prompt position.

_Function has no arguments._

#### Variables set

* **MENU_PROMPT** (integer): 1 if display the menu.
* **DEBUG** (integer): 1 if debug mode is enabled.
* **CURSOR_PROMPT** (array): Contains prompt position.
* **CURSOR_PROMPT_TOP** (array): Contains the position above the prompt.
* **CURSOR_PROMPT_BOTTOM** (array): Contains the position below the prompt.

#### Exit codes

* **0**: If successful.

### menu_cursor_top_refresh

Loads the position at the top of the menu.

_Function has no arguments._

#### Variables set

* **MENU_PROMPT** (integer): 1 if display the menu.
* **DEBUG** (integer): 1 if debug mode is enabled.
* **CURSOR_TOP** (array): Contains the position at the top of the menu.

#### Exit codes

* **0**: If successful.

### menu_cursor_prompt_refresh

Loads prompt position.

_Function has no arguments._

#### Variables set

* **MENU_PROMPT** (integer): 1 if display the menu.
* **DEBUG** (integer): 1 if debug mode is enabled.
* **CURSOR_PROMPT** (array): Contains prompt position.

#### Exit codes

* **0**: If successful.

### menu_cursor_prompt_top_refresh

Loads the position above the prompt.

_Function has no arguments._

#### Variables set

* **MENU_PROMPT** (integer): 1 if display the menu.
* **DEBUG** (integer): 1 if debug mode is enabled.
* **CURSOR_PROMPT_TOP** (array): Contains the position above the prompt.

#### Exit codes

* **0**: If successful.

### menu_cursor_prompt_bottom_refresh

Loads the position below the prompt.

_Function has no arguments._

#### Variables set

* **MENU_PROMPT** (integer): 1 if display the menu.
* **DEBUG** (integer): 1 if debug mode is enabled.
* **CURSOR_PROMPT_BOTTOM** (array): Contains the position below the prompt.

#### Exit codes

* **0**: If successful.

### menu_profile_update

Change profile.

_Function has no arguments._

#### Variables set

* **PROFILE_LIST** (array): List of available profiles.
* **PROFILE** (string): Current profile.
* **DISPLAY_ACTION** (string): Action to be performed in the menu.

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading the configuration file.
* **2**: If an error occurs when reading the list of profiles.
* **3**: If profile could not be updated.
* **4**: If an error occurs when reading the profile configuration.
* **5**: If an error occurs when reading packages.

### menu_theme_update

Change theme.

_Function has no arguments._

#### Variables set

* **PROFILE** (string): Current profile.
* **PROFILE_CONFIG_FILE** (string): Profile configuration file.
* **THEME** (string): Current theme.
* **THEME_LIST** (array): List of available themes.
* **DISPLAY_ACTION** (string): Action to be performed in the menu.

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading the configuration file.
* **2**: If an error occurs when reading the profile configuration file.
* **3**: If an error occurs when reading the list of themes.
* **4**: If the theme cannot be updated in the profile.

### menu_print

Perform an action in the menu.

_Function has no arguments._

#### Variables set

* **ACTION** (string): Used to clear to end of screen if resize the screen.
* **DISPLAY_ACTION** (string): Action to be performed in the menu.
* **CURSOR_PROMPT_BOTTOM** (array): Contains the position below the prompt.

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs while loading the menu cursor.
* **2**: If an error occurs when display the menu options.
* **3**: If an error occurs when display the packages.
* **4**: If an error occurs when updating the packages.
* **5**: If an error occurs when installing the packages.
* **6**: If an error occurs when installing the prerequisites.
* **7**: If an error occurs when removing the packages.
* **8**: If an error occurs when change the profile.
* **9**: If an error occurs when change the theme.
* **10**: If an error occurs when previewing the theme.
* **11**: If an error occurs when display the help.

### menu_display_options

Display the menu options.

_Function has no arguments._

#### Variables set

* **DISPLAY_MODE** (integer): Display mode.
* **NO_BANNER** (integer): Do not display banner.

#### Exit codes

* **0**: If successful.
* **1**: If unable to initialize cursor position.
* **2**: If an error has occurred while displaying the banner.
* **3**: If an error has occurred while displaying menu options.
* **4**: If an error has occurred while displaying additional information.
* **5**: If error occurred when saving cursor position.

### menu_display_packages

Display the packages.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If error occurred while loading cursor.
* **2**: If an error has occurred while displaying packages.

### menu_display_update_packages

Updating packages.

_Function has no arguments._

#### Variables set

* **DISPLAY_ACTION** (string): Action to be performed in the menu.

#### Exit codes

* **0**: If successful.
* **1**: If error occurred while loading cursor.
* **2**: If unable to initialize cursor position.

### menu_display_install_packages

Installing packages.

_Function has no arguments._

#### Variables set

* **DISPLAY_ACTION** (string): Action to be performed in the menu.

#### Exit codes

* **0**: If successful.
* **1**: If error occurred while loading cursor.
* **2**: If unable to initialize cursor position.

### menu_display_install_prerequisites

Installing prerequisites.

_Function has no arguments._

#### Variables set

* **DISPLAY_ACTION** (string): Action to be performed in the menu.

#### Exit codes

* **0**: If successful.
* **1**: If error occurred while loading cursor.
* **2**: If unable to initialize cursor position.

### menu_display_remove_packages

Removing prerequisites.

_Function has no arguments._

#### Variables set

* **DISPLAY_ACTION** (string): Action to be performed in the menu.

#### Exit codes

* **0**: If successful.
* **1**: If error occurred while loading cursor.
* **2**: If unable to initialize cursor position.

### menu_display_change_profile

Change profile.

_Function has no arguments._

#### Variables set

* **DISPLAY_ACTION** (string): Action to be performed in the menu.

#### Exit codes

* **0**: If successful.
* **1**: If error occurred while loading cursor.
* **2**: If unable to initialize cursor position.

### menu_display_change_theme

Change theme.

_Function has no arguments._

#### Variables set

* **DISPLAY_ACTION** (string): Action to be performed in the menu.

#### Exit codes

* **0**: If successful.
* **1**: If error occurred while loading cursor.
* **2**: If unable to initialize cursor position.

### menu_display_preview_theme

Theme preview.

_Function has no arguments._

#### Variables set

* **DISPLAY_ACTION** (string): Action to be performed in the menu.

#### Exit codes

* **0**: If successful.
* **1**: If unable to initialize cursor position.
* **2**: If an error has occurred while displaying the banner.
* **3**: If an error has occurred while displaying menu options.
* **4**: If an error has occurred while displaying additional information.
* **5**: If an error has occurred while displaying packages.

### menu_display_help

Display help.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If error occurred while loading cursor.

### menu_action

Determine the action to be taken if an option is selected.

_Function has no arguments._

#### Variables set

* **ACTION** (string): User-selected action.
* **DISPLAY_ACTION** (string): Action to be performed in the menu.
* **SEARCH_PACKAGES** (string): Name of package to search.
* **SEARCH_CATEGORY** (integer): Search by category name.
* **SHOW_ALL** (integer): View package details.
* **SILENT** (integer): Do not display installation details.
* **YES** (integer): No confirmation before installation.
* **INSTALL** (integer): Installing package if set to 1.

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading packages.

### menu_prompt

Display menu prompt.

_Function has no arguments._

#### Variables set

* **ACTION** (string): User-selected action.
* **DEBUG** (integer): 1 if debug mode is enabled.

#### Exit codes

* **0**: If successful.
* **1**: If error occurred while loading cursor.

### menu_prompt_init

Display menu and prompt.

_Function has no arguments._

#### Variables set

* **MENU_PROMPT** (integer): 1 if display the menu.
* **DISPLAY_ACTION** (string): Action to be performed in the menu.
* **DEBUG** (integer): 1 if debug mode is enabled.

#### Exit codes

* **0**: If successful.
* **1**: If unable to initialize cursor position.

### menu_list_packages

Display packages.

_Function has no arguments._

#### Variables set

* **MENU_PROMPT** (integer): 1 if display the menu.
* **CURSOR_PROMPT_BOTTOM** (array): Contains the position below the prompt.
* **PACKAGES** (array): List of packages.
* **LINES** (integer): Terminal height.

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading packages.
* **2**: If unable to initialize cursor position.
* **3**: If error occurred while loading cursor.
* **4**: If an error has occurred while displaying the packages.
* **5**: If error occurred when saving cursor position.

### menu_update_packages

Updating packages.

_Function has no arguments._

#### Variables set

* **PACKAGES** (array): List of packages.

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading packages.
* **2**: If unable to initialize cursor position.
* **3**: If an error has occurred while displaying the packages.

### menu_preinstall_packages

Installing prerequisites.

_Function has no arguments._

#### Variables set

* **PACKAGES** (array): List of packages.

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading packages.
* **2**: If unable to initialize cursor position.
* **3**: If an error has occurred while installing the prerequisites.
* **4**: If an error has occurred while updating the packages.
* **5**: If an error has occurred while displaying the packages.

### menu_install_packages

Installing packages.

_Function has no arguments._

#### Variables set

* **PACKAGES** (array): List of packages.

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading packages.
* **2**: If unable to initialize cursor position.
* **3**: If an error has occurred while installing the packages.
* **4**: If an error has occurred while displaying the packages.

### menu_remove_packages

Removing packages.

_Function has no arguments._

#### Variables set

* **PACKAGES** (array): List of packages.
* **PACKAGES_REMOVE** (array): List of packages to be deleted.
* **REMOVE** (integer): Removing package if set to 1.

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading packages.
* **2**: If no packages can be removed.
* **3**: If unable to initialize cursor position.
* **4**: If an error has occurred while displaying the packages.
* **5**: If an error has occurred while removing the packages.

### menu_help

Display the help.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### load_menu

Trigger an action based on options passed to the script.

_Function has no arguments._

#### Variables set

* **THEMES_PATH** (string): Theme path.
* **THEME** (string): Current theme.
* **HELP** (integer): Show help.
* **MENU_DISPLAY** (integer): Display menu.
* **LIST** (integer): Display packages.
* **UPDATE** (integer): Update packages.
* **INSTALL** (integer): Installing packages.
* **PRE_INSTALL** (integer): Installing the prerequisites.
* **REMOVE** (integer): Delete packages.

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading the configuration file.
* **2**: If an error occurs when reading the profile configuration file.
* **3**: If an error has occurred while displaying help.
* **4**: If an error has occurred while displaying menu.
* **5**: If an error has occurred while displaying packages.
* **6**: If an error has occurred while updating packages.
* **7**: If an error has occurred while installing the prerequisites.
* **8**: If an error has occurred while installing packages.
* **9**: If an error has occurred while removing packages.

### main

Main function of pimpmyterm.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If an error occurs when reading options passed to the script.
* **2**: If an error occurs during initialization of the OPTS variable.
* **3**: If an error has occurred when triggering an action.

