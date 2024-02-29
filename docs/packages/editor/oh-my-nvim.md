# oh-my-nvim

Script to install oh-my-nvim.

## Overview

The library lets you install the neovim theme from hardhackerlabs.

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

Check if oh-my-nvim is installed.

_Function has no arguments._

#### Exit codes

* **0**: If oh-my-nvim is not installed.
* **1**: If oh-my-nvim is already installed.

### install

Installing the neovim theme from hardhackerlabs.

_Function has no arguments._

#### Exit codes

* **0**: If oh-my-nvim is successfully installed.
* **1**: If oh-my-nvim is already installed.
* **2**: If Neovim is not installed.
* **3**: If unable to find project url.

### remove

Removing the neovim theme from hardhackerlabs.

#### Exit codes

* **0**: If oh-my-nvim was successfully deleted.
* **1**: If oh-my-nvim is not installed.
* **2**: If oh-my-nvim has not been successfully removed.

