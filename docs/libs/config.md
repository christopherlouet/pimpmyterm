# Config

Global application configuration.

## Overview

This library manages the application's global configuration.

## Index

* [debug_config](#debugconfig)
* [config_read](#configread)
* [config_profile_list](#configprofilelist)
* [config_profile_update](#configprofileupdate)
* [config_theme_list](#configthemelist)
* [setup_unit_tests](#setupunittests)
* [main](#main)

### debug_config

Displays debug information for config library.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Displays debug information with date and script name.

### config_read

Read the configuration file.

_Function has no arguments._

#### Variables set

* **CONFIG_FILE_PATH** (string): Configuration file.
* **PROFILES_PATH** (string): Profile path.
* **PROFILE** (string): Profile name.
* **PROFILE_CONFIG_FILE** (string): Profile configuration file.

#### Exit codes

* **0**: If successful.
* **1**: If configuration file not found.
* **2**: If profile path not found.
* **3**: If profile not found.
* **4**: If profile configuration file not found.

### config_profile_list

Get profile list.

_Function has no arguments._

#### Variables set

* **PROFILES_PATH** (string): Profile path.
* **PROFILE_LIST** (array): Profile list.

#### Exit codes

* **0**: If successful.
* **1**: Profile path not found.
* **2**: No profile found.

### config_profile_update

Update profile in configuration file.

_Function has no arguments._

#### Variables set

* **CONFIG_FILE_PATH** (string): Configuration file.
* **PROFILE** (string): Profile name.

#### Exit codes

* **0**: If successful.
* **1**: Configuration file not found.
* **2**: Profile not found.
* **3**: Profile field not found in configuration file.

### config_theme_list

Get theme list.

_Function has no arguments._

#### Variables set

* **THEMES_PATH** (string): Theme path.
* **THEME_LIST** (array): Theme list.

#### Exit codes

* **0**: If successful.
* **1**: Theme path not found.
* **2**: No theme found.

### setup_unit_tests

Setting up unit tests.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### main

Main function.

#### Arguments

* **...** (any): Options passed as script parameters.

#### Exit codes

* **0**: If successful.
* **1**: No function to call.
* **2**: Function name does not exist.

