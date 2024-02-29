# Package apt

Managing apt packages.

## Overview

This library contains a list of functions for managing apt packages.

## Index

* [debug_package_apt](#debugpackageapt)
* [package_apt_info](#packageaptinfo)
* [package_apt_update](#packageaptupdate)
* [package_apt_install](#packageaptinstall)
* [package_apt_remove](#packageaptremove)
* [main](#main)

### debug_package_apt

Displays debug information for package_apt library.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Displays debug information with date and script name.

### package_apt_info

Read information from the apt package.

#### Arguments

* **$1** (string): Package name.

#### Exit codes

* **0**: If successful.
* **1**: If no package passed as parameter.
* **2**: If no package information is available.
* **3**: If no package version has been found.

#### Output on stdout

* Package information in the standard output.

### package_apt_update

Update package manager index.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### package_apt_install

Installing a package from the package manager.

#### Arguments

* **$1** (string): Packages name.

#### Variables set

* **SILENT** (integer): If 1, do not display installation details.

#### Exit codes

* **0**: If successful.

### package_apt_remove

Remove a package from the package manager.

#### Arguments

* **$1** (string): Packages name.

#### Variables set

* **SILENT** (integer): If 1, do not display package deletion details.

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

