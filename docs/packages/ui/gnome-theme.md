# Gnome Theme

Script to install a theme in the gnome terminal.

## Overview

The library lets you install a theme in the gnome terminal.

## Index

* [debug](#debug)
* [package_information](#packageinformation)
* [help](#help)
* [load_profile](#loadprofile)
* [apply_theme](#applytheme)
* [install_prerequisites](#installprerequisites)
* [check_install](#checkinstall)
* [install](#install)

### debug

Displays debug information.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Displays debug information with date and script name.

### package_information

Get package information.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### help

Display the help.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### load_profile

Duplicate and load a gnome profile.

#### Arguments

* **$1** (string): Gnome profile path.

#### Exit codes

* **0**: If successful.
* **1**: If no gnome profile path passed as parameter.
* **2**: If no profile name passed as parameter.

### apply_theme

Apply theme in the gnome terminal.

#### Arguments

* **$1** (string): Gnome theme name.

#### Exit codes

* **0**: If successful.
* **1**: If configuration file not found.
* **2**: If profile loading failed.

### install_prerequisites

Installation of prerequisites.

_Function has no arguments._

#### Variables set

* **DEFAULT_PACKAGE_MANAGER** (string): Default package manager.

#### Exit codes

* **0**: If successful.
* **1**: If the default package manager has not been found.
* **2**: If dconf-cli installation failed.

### check_install

Check if the gnome theme is installed.

_Function has no arguments._

#### Exit codes

* **0**: If gnome theme is not installed.
* **1**: If gnome theme is already installed or Gnome is not installed.
* **2**: If the configuration file was not found.
* **3**: If dconf is not installed.
* **4**: If font is not installed.

### install

Installing a theme in the gnome terminal.

#### Arguments

* **$1** (string): Gnome theme name.

#### Exit codes

* **0**: If successful.
* **1**: If theme is already installed.
* **2**: If prerequisite installation has failed.
* **3**: If theme installation failed.

