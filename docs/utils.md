# Utils

**utils.sh** is a useful toolbox for developing the bash application.

## Overview

This toolbox enables you to perform the following actions:

* Generating the API documentation with the **shdoc** utility
* Generating a site from markdown files with **mkdocs**
* Run unit tests with **pytest**
* Linter the code with the **shellcheck** utility
* Install **poetry** if you need to update python dependencies

## Index

* [check_env_docker](#checkenvdocker)
* [docker_build](#dockerbuild)
* [docker_image_remove](#dockerimageremove)
* [docker_run](#dockerrun)
* [generate_doc](#generatedoc)
* [mkdocs_server_start](#mkdocsserverstart)
* [lint_code](#lintcode)
* [run_tests](#runtests)
* [run_bash](#runbash)
* [poetry_install](#poetryinstall)
* [help](#help)
* [execute_tasks](#executetasks)
* [display_menu](#displaymenu)
* [check_opts](#checkopts)
* [main](#main)

### check_env_docker

Check if docker is installed.

_Function has no arguments._

#### Exit codes

* **0**: If docker is installed.
* **1**: If docker is not installed.

### docker_build

Building the utils docker image.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### docker_image_remove

Removing the utils docker image.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### docker_run

Execute a command in the docker container.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### generate_doc

Generate API documentation in markdown format.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### mkdocs_server_start

Start the mkdocs server to browse the API documentation in a browser.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the docker environment is not installed.
* **2**: If docker image deletion failed.
* **3**: If docker image building failed.
* **4**: If execution of the command in the docker container has failed.

### lint_code

Linter the application's bash code.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the docker environment is not installed.
* **2**: If docker image deletion failed.
* **3**: If docker image building failed.
* **4**: If execution of the command in the docker container has failed.

### run_tests

Run unit tests.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the docker environment is not installed.
* **2**: If docker image deletion failed.
* **3**: If docker image building failed.
* **4**: If execution of the command in the docker container has failed.

### run_bash

Execute bash in the docker container.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the docker environment is not installed.
* **2**: If docker image deletion failed.
* **3**: If docker image building failed.
* **4**: If execution of the command in the docker container has failed.

### poetry_install

Installing Poetry.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If Poetry is already installed.
* **2**: If Python 3 is not installed.
* **3**: If Curl is not installed.

### help

Display the help.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### execute_tasks

Execute tasks based on script parameters or user actions.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If an error has been encountered displaying help.
* **2**: If an error was encountered in generating the documentation.
* **3**: If an error was encountered starting the mkdocs server.
* **4**: If an error was encountered while analyzing the code
* **5**: If an error has been encountered during execution of the unit tests.
* **6**: If an error was encountered running bash in the docker container.
* **7**: If an error was encountered installing Poetry.

### display_menu

Display menu.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### check_opts

Check options passed as script parameters.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### main

Main function.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the options check failed.
* **2**: If menu display has failed.
* **3**: If task execution failed.

