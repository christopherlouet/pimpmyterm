# Batcat

Script to install Batcat.

## Overview

The library lets you install the latest version of Batcat.

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

Check if Batcat is installed.

_Function has no arguments._

#### Exit codes

* **0**: If Batcat is not installed.
* **1**: If Batcat is already installed.

### install

Installing Batcat.

_Function has no arguments._

#### Exit codes

* **0**: If batcat is successfully installed.
* **1**: If Batcat is already installed.
* **2**: If can't find the version to install.
* **3**: If default package manager was not found.
* **4**: If error updating the apt index.
* **5**: If there's a package installation error.
* **6**: If Batcat archive was not found.
* **7**: If curl is not installed.
* **8**: If there's a cargo package installation error.
* **9**: If if Batcat archive url not exists.
* **10**: if Batcat archive could not be downloaded.
* **11**: If the archive could not be extracted.
* **12**: If an error was encountered during build.
* **13**: If the Batcat binary was not found.
* **14**: If Batcat not successfully installed.
* **15**: If unable to find Batcat extras url.

### remove

Removing Batcat.

#### Exit codes

* **0**: If Batcat was successfully deleted.
* **1**: If Batcat is not installed.
* **2**: If Batcat has not been successfully removed.

