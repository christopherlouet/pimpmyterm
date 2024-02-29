# Package file

Managing package scripts.

## Overview

This library contains a list of functions for managing package scripts.

## Index

* [debug_package_file](#debugpackagefile)
* [package_file_info](#packagefileinfo)
* [package_file_preinstall](#packagefilepreinstall)
* [package_file_install](#packagefileinstall)
* [package_file_remove](#packagefileremove)
* [main](#main)

### debug_package_file

Displays debug information for package_file library.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Displays debug information with date and script name.

### package_file_info

Read information from the package script.

#### Arguments

* **$1** (string): Source name.
* **$2** (string): Category name.
* **$3** (string): Package name.

#### Exit codes

* **0**: If successful.
* **1**: If no source passed as parameter.
* **2**: If no category passed as parameter.
* **3**: If no package passed as parameter.
* **4**: If no package folders found.
* **5**: If the package script is not found.
* **6**: If an error was found retrieving information from the script.

#### Output on stdout

* Package information in the standard output.

### package_file_preinstall

Install prerequisites from the package script.

#### Arguments

* **$1** (string): Category name.
* **$2** (string): Package name.

#### Exit codes

* **0**: If successful.
* **1**: If no category passed as parameter.
* **2**: If no package passed as parameter.
* **3**: If no package folders found.
* **4**: If the package script is not found.

### package_file_install

Installing the package from the script.

#### Arguments

* **$1** (string): Category name.
* **$2** (string): Package name.

#### Exit codes

* **0**: If successful.
* **1**: If no category passed as parameter.
* **2**: If no package passed as parameter.
* **3**: If no package folders found.
* **4**: If the package script is not found.

### package_file_remove

Delete package from script.

#### Arguments

* **$1** (string): Category name.
* **$2** (string): Package name.

#### Exit codes

* **0**: If successful.
* **1**: If no category passed as parameter.
* **2**: If no package passed as parameter.
* **3**: If no package folders found.
* **4**: If the package script is not found.

### main

Main function.

#### Arguments

* **...** (any): Options passed as script parameters.

#### Exit codes

* **0**: If successful.
* **1**: No function to call.
* **2**: Function name does not exist.

