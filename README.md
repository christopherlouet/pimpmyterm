# Pimp My Term

<p align="left">
  <a href="https://github.com/christopherlouet/pimpmyterm/actions?query=workflow%3Atests"><img src="https://github.com/christopherlouet/pimpmyterm/workflows/tests/badge.svg" alt="Build Status"></a>
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="license">
</p>

A utility script to easily customize the terminal with killer features 😛.

## 🎇 Preview

| | |
|:-------------------------:|:-------------------------:|
|<img src="assets/preview_01.png"/>  |  <img src="assets/preview_02.png"/>|
|<img src="assets/preview_03.png"/>  |  <img src="assets/preview_04.png"/>|

## 🚧 Installation

**Requirements**

- Ubuntu 22.04
- wsl2 with Ubuntu 22.04

### 💡 Usage

```bash
Usage installer.sh [--all] [--zsh|--neovim|--tmux] [--fonts] [--gnome-terminal] [--auto]
```

### Installation on Ubuntu 22.04

1️⃣ **Log in with your username, and clone the project and install all features:**

```bash
git clone https://github.com/christopherlouet/pimpmyterm
./pimpmyterm/installer.sh --all --auto
```

2️⃣ **Install gnome terminal theme**

```bash
./pimpmyterm/installer.sh --gnome-terminal
```

3️⃣ **Install Meslo Nerd Fonts**

```bash
./pimpmyterm/installer.sh --fonts
```

### Installation with wsl2

1️⃣ **Install Ubuntu-22.04 from Microsoft Store and set user password in terminal.**

Make a backup of the distribution, clone the project and run this command
in Windows PowerShell (in the project folder):

```bash
powershell -noexit -nologo -noprofile -executionpolicy bypass -File .\scripts\wsl_backup.ps1
```

I recommend performing a restore immediately, in order to properly boot the Ubuntu instance.

```bash
powershell -noexit -nologo -noprofile -executionpolicy bypass -File .\scripts\wsl_restore.ps1
```

2️⃣ **In Ubuntu-22.04, log in with your username, and clone the project and install all features:**

```bash
sudo su <username>
git clone https://github.com/christopherlouet/pimpmyterm
./pimpmyterm/installer.sh --all --auto
```

3️⃣ **To install the font and theme, run this command in Windows PowerShell (in the project folder):**

```bash
powershell -noexit -nologo -noprofile -executionpolicy bypass -File .\scripts\wsl_install_font.ps1
powershell -noexit -nologo -noprofile -executionpolicy bypass -File .\scripts\wsl_install_theme.ps1
```

4️⃣ **If you later want to restore the backup, run this command:**

```bash
powershell -noexit -nologo -noprofile -executionpolicy bypass -File .\scripts\wsl_restore.ps1
```

## 🚀 Features

### ⌨️ Key bindings

- `<Alt>C`  Print tree structure in the current folder

- `<Ctrl>T` Preview file content using bat and eza

- `<Ctrl>R` Print bash history

### 🧩 Plugins and themes

- [**oh-my-zsh**](https://github.com/ohmyzsh/ohmyzsh)

- [**powerlevel10k**](https://github.com/romkatv/powerlevel10k)

- [**oh-my-tmux**](https://github.com/gpakosz/.tmux)

- [**oh-my-nvim**](https://github.com/hardhackerlabs/oh-my-nvim)

- [**fzf**](https://github.com/junegunn/fzf)

- [**fd**](https://github.com/sharkdp/fd)

- [**bat**](https://github.com/sharkdp/bat)

- [**eza**](https://github.com/eza-community/eza)

- [**Meslo Nerd font**](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo)

- [**Catppuccin for Gnome Terminal**](https://github.com/catppuccin/gnome-terminal)

## ⚒ Unit tests

To launch the tests, use the command:

```bash
./tests.sh
```

## 📃 License

Distributed under the MIT License.
