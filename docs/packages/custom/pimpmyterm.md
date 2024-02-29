# PimpMyTerm

Script to install a customized terminal and shell configuration.

## Overview

This library can be used to install the following packages:
* Meslo Nerd fonts
* Catppuccin Mocha gnome theme
* zsh and oh-my-zsh plugins and theme
* tmux and themes
* neovim and themes
* VSCode
* fzf, fd-find, Batcat and Eza

## Index

* [debug](#debug)
* [package_information](#packageinformation)
* [help](#help)
* [install_nerd_fonts](#installnerdfonts)
* [install_gnome_theme](#installgnometheme)
* [install_fzf](#installfzf)
* [install_fdfind](#installfdfind)
* [install_batcat](#installbatcat)
* [install_eza](#installeza)
* [install_zsh](#installzsh)
* [install_oh_my_zsh](#installohmyzsh)
* [install_ohmyzsh_powerlevel10k](#installohmyzshpowerlevel10k)
* [install_ohmyzsh_plugins](#installohmyzshplugins)
* [install_ohmyzsh_custom](#installohmyzshcustom)
* [install_tmux](#installtmux)
* [install_ohmytmux](#installohmytmux)
* [install_neovim](#installneovim)
* [install_ohmyneovim](#installohmyneovim)
* [install_vscode](#installvscode)
* [check_install](#checkinstall)
* [install](#install)

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

### install_nerd_fonts

Installing MesloLGS Nerd font.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the package script does not exist.
* **2**: If an error was encountered during installation.

### install_gnome_theme

Installing Catppuccin Mocha gnome theme.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the package script does not exist.
* **2**: If an error was encountered during installation.

### install_fzf

Installing fzf.

_Function has no arguments._

#### Exit codes

* **0**: If fzf is successfully or already installed.
* **1**: If default package manager was not found.
* **2**: If an error was encountered during installation with apt.

### install_fdfind

Installing fd-find.

_Function has no arguments._

#### Exit codes

* **0**: If fd-find is successfully or already installed.
* **1**: If default package manager was not found.
* **2**: If an error was encountered during installation with apt.

### install_batcat

Installing Batcat.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the package script does not exist.
* **2**: If an error was encountered during installation.

### install_eza

Installing Eza.

_Function has no arguments._

#### Exit codes

* **0**: If Eza is successfully or already installed.
* **1**: If the package script does not exist.
* **2**: If an error was encountered during prerequisite installation.
* **3**: If default package manager was not found.
* **4**: If an error was encountered during installation with apt.

### install_zsh

Installing zsh.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the package script does not exist.
* **2**: If an error was encountered during installation.

### install_oh_my_zsh

Installing oh-my-zsh.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the package script does not exist.
* **2**: If an error was encountered during installation.

### install_ohmyzsh_powerlevel10k

Installing and configure powerlevel10k theme.

_Function has no arguments._

#### Exit codes

* **0**: If powerlevel10k is successfully or already installed.
* **1**: If an error was encountered when copying the configuration file.

### install_ohmyzsh_plugins

Installing oh-my-zsh plugins.

_Function has no arguments._

#### Exit codes

* **0**: If successful.

### install_ohmyzsh_custom

Installing oh-my-zsh custom configuration.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If the custom fzf configuration file does not exist.
* **2**: If the custom eza configuration file does not exist.

### install_tmux

Installing tmux multiplexer.

_Function has no arguments._

#### Exit codes

* **0**: If tmux is successfully or already installed.
* **1**: If default package manager was not found.
* **2**: If an error was encountered during installation with apt.

### install_ohmytmux

Installing oh-my-tmux tmux theme.

_Function has no arguments._

#### Exit codes

* **0**: If tmux is successfully or already installed.
* **1**: If the package script does not exist.
* **2**: If an error was encountered during installation.

### install_neovim

Installing neovim editor.

_Function has no arguments._

#### Exit codes

* **0**: If neovim is successfully or already installed.
* **1**: If the package script does not exist.
* **2**: If an error was encountered during installation.
* **3**: If default package manager was not found.
* **4**: If an error was encountered during installation with apt.

### install_ohmyneovim

Installing oh-my-neovim neovim theme.

_Function has no arguments._

#### Exit codes

* **0**: If oh-my-neovim is successfully or already installed.
* **1**: If the package script does not exist.
* **2**: If an error was encountered during installation.

### install_vscode

Installing VSCode editor.

_Function has no arguments._

#### Exit codes

* **0**: If oh-my-neovim is successfully installed, already installed, or no display manager exists.
* **1**: If the package script does not exist.
* **2**: If an error was encountered during prerequisite installation.
* **3**: If default package manager was not found.
* **4**: If an error was encountered during installation with apt.

### check_install

Check if pimpmyterm packages are installed.

_Function has no arguments._

#### Exit codes

* **0**: If pimpmyterm is not installed.
* **1**: If pimpmyterm is already installed.

### install

Installing customized terminal and shell configuration.

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If an error was encountered during font installation.
* **2**: If an error was encountered during gnome theme installation.
* **3**: If an error was encountered during fzf installation.
* **4**: If an error was encountered during fd-find installation.
* **5**: If an error was encountered during Batcat installation.
* **6**: If an error was encountered during Eza installation.
* **7**: If an error was encountered during Zsh installation.
* **8**: If an error was encountered during oh-my-zsh installation.
* **9**: If an error was encountered during powerlevel10k theme installation.
* **10**: If an error was encountered during oh-my-zsh plugins installation.
* **11**: If an error was encountered during oh-my-zsh custom configuration installation.
* **12**: If an error was encountered during tmux installation.
* **13**: If an error was encountered during oh-my-tmux installation.
* **14**: If an error was encountered during Neovim installation.
* **15**: If an error was encountered during oh-my-neovim installation.
* **16**: If an error was encountered during VSCode installation.

