# Neovim

Script to install Neovim prerequisites.

## Overview

The library lets you add the Neovim repository.

## Index

* [debug](#debug)
* [help](#help)
* [pre_install_apt](#preinstallapt)
* [pre_install](#preinstall)

### debug

Displays debug information.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Displays debug information with date and script name.

### help

Display the help.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### pre_install_apt

Installing Neovim prerequisites with apt.

_Function has no arguments._

#### Exit codes

* **0**: If Neovim prerequisites are successfully installed.
* **1**: The neovim PPA already exists.

### pre_install

Installing Neovim prerequisites.

_Function has no arguments._

#### Exit codes

* **0**: If Neovim prerequisites are successfully installed.
* **1**: If default package manager was not found.
* **2**: If an error occurred during installation of Neovim prerequisites.

