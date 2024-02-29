# zsh

Script to install zsh.

## Overview

The library lets you install zsh without user interaction.

## Index

* [debug](#debug)
* [package_information](#packageinformation)
* [help](#help)
* [check_install](#checkinstall)
* [install_apt](#installapt)
* [remove_apt](#removeapt)
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

Check if zsh is installed.

_Function has no arguments._

#### Exit codes

* **0**: If zsh is not installed.
* **1**: If zsh is already installed.

### install_apt

Installing zsh with apt.

_Function has no arguments._

#### Exit codes

* **0**: If zsh is successfully installed.
* **1**: If error updating the apt index.
* **2**: If zsh was not installed correctly.

### remove_apt

Removing zsh with apt.

_Function has no arguments._

#### Exit codes

* **0**: If zsh is successfully removed.
* **1**: If an error was encountered when deleting zsh.
* **2**: If the zsh configuration file could not be saved.
* **3**: If zsh was not removed correctly.

### install

Installing zsh.

_Function has no arguments._

#### Exit codes

* **0**: If zsh is successfully installed.
* **1**: If zsh is already installed.
* **2**: If default package manager was not found.
* **3**: If errors were encountered during zsh installation.

### remove

Removing zsh.

_Function has no arguments._

#### Exit codes

* **0**: If zsh is successfully removed.
* **1**: If zsh is already installed.
* **2**: If default package manager was not found.
* **3**: If errors were encountered when deleting zsh.

