param(
    [String] $archive = "MesloLGSNF.zip"
)

&{
    $assetsFolder = $PSScriptRoot + "\..\assets"
    $archiveFile = "$assetsFolder\MesloLGSNF.zip"

    if (-Not(Test-Path $archiveFile -PathType leaf))
    {
        Write-Error -Message "The archive file '$archiveFile' not exists!" -ErrorAction Stop
    }
    $fontsFolderName = (Get-Item $archiveFile).Basename
    $fontsFolder = "$assetsFolder\$fontsFolderName"

    function unzip()
    {
        Write-Output "Extract the $archiveFile archive into the $fontsFolder folder"
        Expand-Archive $archiveFile -DestinationPath $fontsFolder -Force
    }

    # Installing fonts
    function installFonts
    {
        $copyOptions = 4 + 16;
        $objShell = New-Object -ComObject Shell.Application
        $fonts = 0x14
        $objFolder = $objShell.Namespace($fonts)
        foreach ($font in Get-ChildItem -Path $fontsFolder -File)
        {
            $dest = "C:\Windows\Fonts\$font"
            If (Test-Path -Path $dest)
            {
                Write-Output "Font $font already installed"
            }
            Else
            {
                Write-Output "Installing $font"
                $copyFlag = [String]::Format("{0:x}", $copyOptions);
                $objFolder.CopyHere($font.fullname, $copyFlag)
            }
        }
    }

    function cleanFiles()
    {
        Write-Output "Delete $fontsFolder folder"
        Remove-Item $fontsFolder -Recurse
    }

    unzip
    installFonts
    cleanFiles
}
