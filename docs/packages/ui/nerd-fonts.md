# Nerd Fonts

Script to install a font from the Nerd Fonts project.

## Overview

The library lets you download and install a font from the Nerd Fonts project.

## Index

* [debug](#debug)
* [package_information](#packageinformation)
* [help](#help)
* [check_install](#checkinstall)
* [install](#install)
* [remove](#remove)

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

### check_install

Check if the font is installed.

_Function has no arguments._

#### Exit codes

* **0**: If the font is not installed.
* **1**: If the font is already installed.
* **2**: If default package manager was not found.
* **3**: If package installation error.

### install

Download and copy a font.

#### Arguments

* **$1** (string): Font file name.
* **$2** (string): Font name.

#### Exit codes

* **0**: If successful.
* **1**: If font has already been installed.
* **2**: If font url not found.
* **3**: If font download was unsuccessful.
* **4**: If the font was not found.

### remove

Remove a font.

#### Arguments

* **$1** (string): Font file name.
* **$2** (string): Font name.

#### Exit codes

* **0**: If successful.
* **1**: If font path not found.
* **2**: If the font was not found.

