Write-Host "============================"
Write-Host "Automated Setup and Debloat Script"
Write-Host "============================"
Write-Host "Please wait... Checking system information."

#OS information.
Write-Host "============================"
Write-Host "OS INFO"
Write-Host "============================"
Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption
Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty Version
Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty OSArchitecture

#Hardware information.
Write-Host "============================"
Write-Host "HARDWARE INFO"
Write-Host "============================"
Get-CimInstance -Class Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
Get-CimInstance -Class Win32_Processor | Select-Object -ExpandProperty Name

#Networking information.
Write-Host "============================"
Write-Host "NETWORK INFO"
Write-Host "============================"
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4'}
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv6'}

#Wait for 5 seconds so view what ip address been given to machine
Write-Host "============================"
Write-Host "Waiting for 5 seconds..."
Start-Sleep -Seconds 5

# Do a system restore
Enable-ComputerRestore -Drive 'C:'
Checkpoint-Computer -Description "Script Restore Point" -RestorePointType "MODIFY_SETTINGS"

# Install chocolatey
#if not installed, install chocolatey
if (!(Test-Path -Path "$env:ProgramData\Chocolatey")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed. Skipping installation."
}

#get the directory path of the script
#$scriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

#specify the relative path to the packages.config file
#$packagesConfigPath = Join-Path -Path $scriptDirectory -ChildPath "packages.config"

$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
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