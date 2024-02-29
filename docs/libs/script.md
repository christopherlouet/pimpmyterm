# Script

Script file configuration.

## Overview

Utility library used by package scripts to facilitate installation.

## Index

* [main](#main)

### main

Main function called by the package script to determine the action to be performed.

#### Arguments

* **...** (any): Options passed as script parameters.

#### Variables set

* **HELP** (integer): Displays help if set to 1.
* **INSTALL** (integer): Installing package if set to 1.
* **PRE_INSTALL** (integer): Installing prerequisites if set to 1.
* **REMOVE** (integer): Removing package if set to 1.
* **SILENT** (integer): Do not display installation details if set to 1.
* **CHECK** (integer): Check if the package is installed if set to 1.
* **DEBUG** (integer): 1 if debug mode is enabled.

#### Exit codes

* **0**: If successful.
* **1**: If the script not has the function check_install.
* **2**: If function passed as parameter does not exist
* **3**: If function with name help does not exist.
* **4**: If Function with name install does not exist.
* **5**: If function with name pre_install does not exist.
* **6**: If function with name remove does not exist.
* **7**: If function with name check_install does not exist.

