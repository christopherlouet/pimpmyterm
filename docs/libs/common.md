# Common

Common functions.

## Overview

This library contains the application's common functions.

## Index

* [init_opts](#initopts)
* [get_opts](#getopts)
* [display_opts](#displayopts)
* [check_url](#checkurl)
* [download_file](#downloadfile)
* [success](#success)
* [die](#die)
* [die_line_break](#dielinebreak)
* [warning](#warning)
* [warning_line_break](#warninglinebreak)
* [info](#info)
* [info_line_break](#infolinebreak)
* [info_no_newline](#infononewline)
* [info_success](#infosuccess)
* [test](#test)
* [debug_script](#debugscript)
* [confirm_message](#confirmmessage)
* [confirm_prompt](#confirmprompt)
* [confirm_continue](#confirmcontinue)
* [die_and_continue](#dieandcontinue)
* [main](#main)

### init_opts

Reading options passed to the script.

#### Arguments

* **...** (any): Options passed as script parameters.

#### Variables set

* **OPTS** (array): Options passed as arguments.
* **LIST** (integer): Display packages.
* **HELP** (integer): Show help.
* **UPDATE** (integer): Update packages.
* **INSTALL** (integer): Installing packages.
* **REMOVE** (integer): Delete packages.
* **SHOW_ALL** (integer): View package details.
* **SEARCH_CATEGORY** (integer): Search by category name.
* **SEARCH_PACKAGES** (integer): Search by package name.
* **DEBUG** (integer): 1 if debug mode is enabled.
* **YES** (integer): No confirmation before installation.
* **SILENT** (integer): Do not display installation details.
* **NO_BANNER** (integer): Do not display banner.

#### Exit codes

* **0**: If successful.

### get_opts

Get options passed as arguments in functions.

_Function has no arguments._

#### Variables set

* **OPTS** (array): Options passed as arguments.
* **LIST** (integer): Display packages.
* **HELP** (integer): Show help.
* **UPDATE** (integer): Update packages.
* **INSTALL** (integer): Installing packages.
* **REMOVE** (integer): Delete packages.
* **SHOW_ALL** (integer): View package details.
* **SEARCH_CATEGORY** (integer): Search by category name.
* **SEARCH_PACKAGES** (integer): Search by package name.
* **DEBUG** (integer): 1 if debug mode is enabled.
* **YES** (integer): No confirmation before installation.
* **SILENT** (integer): Do not display installation details.
* **NO_BANNER** (integer): Do not display banner.

#### Exit codes

* **0**: If successful.

### display_opts

Display options passed as arguments in functions.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### check_url

Check if a URL exists.

#### Arguments

* **$1** (string): URL.

#### Exit codes

* **0**: If URL exists.
* **1**: If no URL passed as parameter.
* **2**: If URL not exists.

### download_file

Download a file.

#### Arguments

* **$1** (string): URL.
* **$2** (string): Destination path.

#### Exit codes

* **0**: If the download was successful.
* **1**: If no URL passed as parameter.
* **2**: If no destination path passed as parameter.
* **3**: If an error was encountered while downloading in silent mode.
* **4**: If an error was encountered during the download with the progress bar.

### success

Display a success message.

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### die

Display an error message.

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### die_line_break

Display a error message starting with a line break.

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### warning

Display a warning message.

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### warning_line_break

Display a warning message starting with a line break.

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### info

Display an information message.

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### info_line_break

Display a information message starting with a line break.

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### info_no_newline

Display an information message without adding a new line at the end.

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### info_success

Display an information message by adding OK at the end.

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### test

Used by unit tests to display a message

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### debug_script

Display a debug message.

#### Arguments

* **$1** (string): Script path.
* **$2** (string): Message to display.

#### Exit codes

* **0**: If successful.

#### Output on stdout

* Message displayed in standard output.

### confirm_message

Prompt a confirm message.

#### Arguments

* **$1** (string): Confirmation message to display.

#### Variables set

* **answer** (string): Answer entered by user.
* **confirm_answer** (string): Checks that the user has validated.

#### Exit codes

* **0**: If successful.

### confirm_prompt

Request a confirmation message every half-second.

#### Arguments

* **$1** (string): Confirmation message to display.

#### Variables set

* **answer** (string): Answer entered by user.

#### Exit codes

* **0**: If successful.

### confirm_continue

Display a message and wait for user keystroke.

#### Arguments

* **$1** (string): Message to display.

#### Exit codes

* **0**: If successful.

### die_and_continue

Display an error message and wait for user keystroke.

#### Arguments

* **$1** (string): Error message to display.

#### Exit codes

* **0**: If successful.

### main

Main function.

#### Arguments

* **...** (any): Options passed as script parameters.

#### Exit codes

* **0**: If successful.
* **1**: No function to call.
* **2**: Function name does not exist.

