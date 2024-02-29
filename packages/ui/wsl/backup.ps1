param(
    [String] $distro = "Ubuntu-22.04",
    [String] $backupFolder = "$env:userprofile\WSL\images"
)

&{
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

    Write-Output "Shutdown $distro"
    wsl --terminate "$distro"

    Write-Output "Backup distro to the $backupFolder\$distro.bak.tar file"
    New-Item -ItemType Directory -Force -Path "$backupFolder"
    wsl --export "$distro" "$backupFolder\$distro.bak.tar"

    Write-Output "Creating the new backup in the $backupFolder directory:"
    Get-ChildItem -Path $backupFolder -Recurse -Force -ErrorAction SilentlyContinue `
    | Select-Object FullName, LastWriteTime  | Format-Table -hide

    distro_start
}
