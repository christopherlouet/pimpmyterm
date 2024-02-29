# VSCode

Script to install VSCode prerequisites.

## Overview

The library lets you add the VSCode repository.

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

Installing VSCode prerequisites with apt.

_Function has no arguments._

#### Exit codes

* **0**: If VSCode prerequisites are successfully installed.
* **1**: If the VSCode apt repository already exists.
* **2**: If the PGP public key url was not found.

### pre_install

Installing VSCode prerequisites.

_Function has no arguments._

#### Exit codes

* **0**: If VSCode prerequisites are successfully installed.
* **1**: If default package manager was not found.
* **2**: If an error occurred during installation of VSCode prerequisites.

