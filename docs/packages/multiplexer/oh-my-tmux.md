# oh-my-tmux

Script to install oh-my-tmux.

## Overview

The library lets you install the tmux theme from Gregory Pakosz.

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

Check if oh-my-tmux is installed.

_Function has no arguments._

#### Exit codes

* **0**: If oh-my-tmux is not installed.
* **1**: If oh-my-tmux is already installed.

### install

Installing the tmux theme from Gregory Pakosz.

_Function has no arguments._

#### Variables set

* **OHMYTMUX_CUSTOM_INSTALL** (integer): Customized installation.
* **OHMYTMUX_CUSTOM_CONF** (string): Custom configuration file path.
* **DEFAULT_PACKAGE_MANAGER** (string): Distribution package manager.

#### Exit codes

* **0**: If oh-my-tmux is successfully installed.
* **1**: If oh-my-tmux is already installed.
* **2**: If tmux is not installed.
* **3**: If default package manager was not found.
* **4**: If there's a xsel package installation error.
* **5**: If unable to find project url.
* **6**: If configuration file not found.

### remove

Removing the tmux theme from Gregory Pakosz.

#### Exit codes

* **0**: If oh-my-tmux was successfully deleted.
* **1**: If oh-my-tmux is not installed.
* **2**: If oh-my-tmux has not been successfully removed.

