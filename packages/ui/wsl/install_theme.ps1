param(
    [String] $colorSchemeFile = "CatppuccinMocha.json"
)

&{
    $assetsFolder = $PSScriptRoot + "\..\assets"
    $colorSchemePath = "$assetsFolder\$colorSchemeFile"

    $WTsettingsDir = Join-Path -Path $env:LocalAppData -ChildPath "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"
    $WTsettingsFile = Join-Path -Path $WTsettingsDir -ChildPath "settings.json"
    $WTsettingsBackup = Join-Path -Path $WTsettingsDir -ChildPath "settings.bak.json"
    $WTsettingsTempry = Join-Path -Path $WTsettingsDir -ChildPath "themetoggler.settings.tmp.json"

    if (-not(Test-Path -Path $WTsettingsFile -PathType Leaf))
    {
        Write-Error -Message "Windows Terminal settings file not found. Is Windows Terminal properly installed?" -ErrorAction Stop
    }

    # Get content from json files
    $colorScheme = Get-Content -Path $colorSchemePath -Encoding utf8 | Out-String | ConvertFrom-Json
    $colorSchemeName = $colorScheme.name
    $WTsettingshandle = [System.IO.File]::Open($WTsettingsFile, "open", "readwrite", "read")

    # Backup settings
    Copy-Item $WTsettingsFile $WTsettingsBackup -Force -ErrorAction Stop
    Write-Host "settings backed up at $WTsettingsBackup"

    try
    {
        $WTsettings = Get-Content $WTsettingsfile -Encoding utf8 | ConvertFrom-Json
        $validSchemes = $WTsettings.schemes | ForEach-Object name

        function setProfileTheme
        {
            param (
                $WTprofile
            )
            # check that the colorScheme is defined in settings.json
            if ($validSchemes -contains $colorSchemeName)
            {
                $WTprofile.colorScheme = $colorSchemeName
            }
            else
            {
                $WTsettings.schemes += $colorScheme
                $WTprofile.colorScheme = $colorSchemeName
            }
            Write-Host "profile $( if ([bool]$WTprofile.PSObject.Properties["guid"])
            {
                "($( $WTprofile.name ))"
            }
            else
            {
                "defaults"
            } ) now using colorScheme `"$colorSchemeName`""
        }

        # Apply theme if profile contains colorScheme property
        foreach ($WTprofile in $WTsettings.profiles.list)
        {
            if ([bool]$WTprofile.PSObject.Properties["colorScheme"])
            {
                setProfileTheme $WTprofile
            }
        }

        # Save $WTsettings in a temporary json file
        $WTsettings | ConvertTo-Json -Depth 10 | Set-Content $WTsettingsTempry
        $applyThemeSuccess = $true
    }
    catch
    {
        throw $_.Exception.Message
    }
    finally
    {
        $WTsettingshandle.close()
    }

    # Apply the theme
    if ($applyThemeSuccess)
    {
        Copy-Item $WTsettingsTempry $WTsettingsFile -Force -ErrorAction Stop
        Write-Host "settings flushed."
        Remove-Item $WTsettingsTempry
    }
}
