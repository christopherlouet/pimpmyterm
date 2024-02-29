# oh-my-zsh

Script to install oh-my-zsh.

## Overview

The library lets you install oh-my-zsh.

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

Check if oh-my-zsh is installed.

_Function has no arguments._

#### Exit codes

* **0**: If oh-my-zsh is not installed.
* **1**: If oh-my-zsh is already installed.

### install

Installing oh-my-zsh.

_Function has no arguments._

#### Exit codes

* **0**: If oh-my-zsh is successfully installed or already installed.
* **1**: If oh-my-zsh is already installed.
* **2**: If oh-my-zsh url was not found.
* **3**: If curl was not found.
* **4**: If the .zshrc file cannot be saved.
* **5**: If an error was encountered during oh-my-zsh installation.

### remove

Removing oh-my-zsh.

_Function has no arguments._

#### Exit codes

* **0**: If oh-my-zsh is successfully removed.
* **1**: If oh-my-zsh is not installed.
* **2**: If the .oh-my-zsh folder cannot be saved.
* **3**: If the .zshrc file cannot be saved.
* **4**: If the origin .zshrc file cannot be copied.

