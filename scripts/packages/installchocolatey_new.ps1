# Install chocolatey
#if not installed, install chocolatey
if (!(Test-Path -Path "$env:ProgramData\Chocolatey")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed. Skipping installation."
}

# Determine the script directory
$scriptDirectory = $PSScriptRoot

$packagesConfigUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/minimal/packages.config"
Invoke-WebRequest -Uri $packagesConfigUrl -OutFile "$scriptDirectory\packages.config"

#function to process package installation with version handling
function InstallPackage($packageName, $version) {
    #if a specific version is provided, use `choco upgrade --version`
    if ($version) {
        & choco upgrade -y $packageName --version $version
    } else {
        #if no version is provided, use `choco upgrade` to install the latest version
        & choco upgrade -y $packageName
    }
}

#process package configuration
try {
    # Attempt to download the packages.config file
    Invoke-WebRequest -Uri $packagesConfigUrl -OutFile "$scriptDirectory\packages.config"

    # Process package configuration
    $packagesConfig = Get-Content "$scriptDirectory\packages.config"

    foreach ($line in $packagesConfig) {
        if (-not ($line -match '^\s*#')) {
            $packageName, $version = $line -split ",", 2
            $packageName = $packageName.Trim()
            if ($version) {
                $version = $version.Trim()
            }

            InstallPackage -packageName $packageName -version $version
        }
    }
}
catch {
    Write-Host "Failed to download packages.config file from $packagesConfigUrl. Error: $_"
}