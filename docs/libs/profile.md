# Profile

Profile configuration.

## Overview

This library manages application profiles.

## Index

* [debug_profile](#debugprofile)
* [profile_read_config](#profilereadconfig)
* [profile_read_packages](#profilereadpackages)
* [profile_add_package](#profileaddpackage)
* [profile_update_packages](#profileupdatepackages)
* [profile_update_section](#profileupdatesection)
* [profile_merge_section](#profilemergesection)
* [profile_update_theme](#profileupdatetheme)
* [profile_update_last_update](#profileupdatelastupdate)
* [profile_create](#profilecreate)
* [main](#main)

### debug_profile

Displays debug information for profile library.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Displays debug information with date and script name.

### profile_read_config

Read the profile configuration file.

_Function has no arguments._

#### Variables set

* **PROFILE_CONFIG_FILE** (string): Profile configuration file.
* **LAST_UPDATE** (string): Date of last update.
* **THEME** (string): Theme applied to profile.
* **BANNER** (string): Banner applied to profile.

#### Exit codes

* **0**: If successful.
* **1**: Profile configuration file not found.

### profile_read_packages

Get a list of packages in the profile configuration file.

_Function has no arguments._

#### Variables set

* **PROFILE_CONFIG_FILE** (string): Profile configuration file.
* **PACKAGES_INIT** (integer): Search all packages in the profile.
* **SEARCH_CATEGORY** (string): Search by category name.
* **SEARCH_PACKAGES** (string): Search by package name.
* **PROFILE_PACKAGES** (string): array List of profile packages.

#### Exit codes

* **0**: If successful.
* **1**: Profile configuration file not found.
* **2**: No package found.

### profile_add_package

Add a package to the current list.

_Function has no arguments._

#### Variables set

* **PROFILE_PACKAGES** (string): array List of profile packages.

#### Exit codes

* **0**: If successful.

### profile_update_packages

Update packages in the profile configuration file.

_Function has no arguments._

#### Variables set

* **PROFILE_CONFIG_FILE** (string): Profile configuration file.
* **PACKAGES_DISPLAY** (array): List of packages to be updated in the profile configuration file.

#### Exit codes

* **0**: If successful.
* **1**: Profile configuration file not found.
* **2**: No package found.

### profile_update_section

Update a line in the profile configuration file.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### profile_merge_section

Merge a line in the profile configuration file.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### profile_update_theme

Update theme in the profile configuration file.

_Function has no arguments._

#### Variables set

* **PROFILE_CONFIG_FILE** (string): Profile configuration file.
* **THEME** (string): Theme to be applied in profile configuration file.

#### Exit codes

* **0**: If successful.
* **1**: Profile configuration file not found.
* **2**: Theme not found.

### profile_update_last_update

Update date in profile configuration file.

_Function has no arguments._

#### Variables set

* **PROFILE_CONFIG_FILE** (string): Profile configuration file.
* **LAST_UPDATE** (string): Date of last update applied to profile configuration file.

#### Exit codes

* **0**: If successful.
* **1**: Profile configuration file not found.

### profile_create

Create a new profile.

_Function has no arguments._

#### Variables set

* **CONFIG_FILE_PATH** (string): Configuration file.

#### Exit codes

* **0**: If successful.
* **1**: Configuration file not found.
* **2**: Profile not found.
* **3**: Profile field not found in configuration file.

### main

Main function.

#### Arguments

* **...** (any): Options passed as script parameters.

#### Exit codes

* **0**: If successful.
* **1**: No function to call.
* **2**: Function name does not exist.

