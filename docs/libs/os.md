# OS

Utility library for distribution information.

## Overview

This library contains a list of functions for obtaining distribution information.

## Index

* [debug_os](#debugos)
* [os_package_manager](#ospackagemanager)
* [main](#main)

### debug_os

Displays debug information for os library.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Displays debug information with date and script name.

### os_package_manager

Get the package manager.

_Function has no arguments._

#### Variables set

* **DEFAULT_PACKAGE_MANAGER** (string): Name of the package manager.

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

