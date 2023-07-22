#if not installed, install chocolatey
if (!(Test-Path -Path "$env:ProgramData\Chocolatey")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed. Skipping installation."
}

#get the directory path of the script
$scriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

#specify the relative path to the packages.config file
$packagesConfigPath = Join-Path -Path $scriptDirectory -ChildPath "..\packages.config"

#function to process package installation
function InstallPackage($packageName) {
    #run the package installation
    choco install -y $packageName
}

#process package configuration
if (Test-Path $packagesConfigPath) {
    #read the contents of the packages.config file
    $packagesConfig = Get-Content $packagesConfigPath

    #for each line in the packages.config file
    foreach ($line in $packagesConfig) {
        #skip comment lines that begin with #
        if (-not ($line -match '^\s*#')) {
            #extract the package name from the line
            $packageName = ($line -split "\r\n")[0].Trim()

            #process package installation
            InstallPackage -packageName $packageName
        }
    }
}
else {
    #will update this to grab latest from github repo
    Write-Host "packages.config file not found in the expected location."
}
