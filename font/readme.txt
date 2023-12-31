
# wsl

Install Ubuntu-22.04 from Microsoft Store and set user password in terminal.

Make a backup of the distribution, clone the project and run this command
in Windows PowerShell (in the project folder):

```bash
powershell -noexit -nologo -noprofile -executionpolicy bypass -File .\scripts\wsl_backup.ps1
```

I recommend performing a restore immediately, in order to properly boot the Ubuntu instance.

```bash
powershell -noexit -nologo -noprofile -executionpolicy bypass -File .\scripts\wsl_restore.ps1
```

In Ubuntu-22.04, log in with your username, and clone the project and install all features:

```bash
sudo su <username>
git clone https://github.com/christopherlouet/pimpmyterm
./pimpmyterm/installer.sh --all --auto
```

To install the font and theme, run this command in Windows PowerShell (in the project folder):

```bash
powershell -noexit -nologo -noprofile -executionpolicy bypass -File .\scripts\wsl_install_font.ps1
powershell -noexit -nologo -noprofile -executionpolicy bypass -File .\scripts\wsl_install_theme.ps1
```

If you later want to restore the backup, run this command:

```bash
powershell -noexit -nologo -noprofile -executionpolicy bypass -File .\scripts\wsl_restore.ps1
```
