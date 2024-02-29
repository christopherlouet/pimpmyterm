param(
    [String] $distro = "Ubuntu-22.04",
    [String] $backupFolder = "$env:userprofile\WSL\images",
    [String] $instanceFolder = "$env:userprofile\WSL\instances"
)

&{
    $backupFile = $distro + ".bak.tar"
    $instanceFile = "$instanceFolder\$distro"

    function distro_start()
    {
        Write-Output "Start $distro"
        $sb = {
            param (
                $distro
            )
            wsl --distribution $distro
        }
        $job = Start-Job -ScriptBlock $sb -ArgumentList $distro
        Write-Output "Distro starting..."
        $job | Wait-Job | Receive-Job
        $job | Remove-Job
    }

    Write-Output "Shutdown current $distro"
    wsl --terminate "$distro"

    Write-Output "Remove current instance"
    wsl --unregister "$distro"

    Write-Output "Create a new instance from backup"
    New-Item -ItemType Directory -Force -Path "$instanceFolder"
    wsl --import "$distro" "$instanceFile" "$backupFolder\$backupFile" --version 2

    Write-Output "Restore the new instance from the $instanceFolder directory:"
    Get-ChildItem -Path $instanceFolder -Recurse -Force -ErrorAction SilentlyContinue `
      | Select-Object FullName, LastWriteTime  | Format-Table -hide

    Write-Host "
  To change the default user, edit the /etc/wsl.conf file in the distribution :
  [user]
  default=username

  Restart the distribution to apply the configuration :
  wsl --terminate $distro
  wsl --distribution $distro
    "

    distro_start
    Write-Output "Launching a new Windows terminal"
    wt.exe
}
