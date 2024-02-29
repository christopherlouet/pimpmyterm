# Eza

Script to install Eza prerequisites.

## Overview

The library lets you add the Gierens repository to install Eza.

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

Installing Eza prerequisites with apt.

_Function has no arguments._

#### Exit codes

* **0**: If Eza prerequisites are successfully installed.
* **1**: If the Gierens apt repository already exists.
* **2**: If the pgp public key url was not found.
* **3**: If error updating the apt index.

### pre_install

Installing Eza prerequisites.

_Function has no arguments._

#### Exit codes

* **0**: If Eza prerequisites are successfully installed.
* **1**: If default package manager was not found.
* **2**: If an error occurred during installation of Eza prerequisites.

