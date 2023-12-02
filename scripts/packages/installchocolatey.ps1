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
$packagesConfigPath = Join-Path -Path $scriptDirectory -ChildPath "..\..\packages.config"

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
if (Test-Path $packagesConfigPath) {
    #read the contents of the packages.config file
    $packagesConfig = Get-Content $packagesConfigPath

    #for each line in the packages.config file
    foreach ($line in $packagesConfig) {
        #skip comment lines that begin with #
        if (-not ($line -match '^\s*#')) {
            #extract the package name and version from the line
            $packageName, $version = $line -split ",", 2
            $packageName = $packageName.Trim()
            if ($version) {
                $version = $version.Trim()
            }

            #process package installation
            InstallPackage -packageName $packageName -version $version
        }
    }
}
else {
    #will update this to grab latest from GitHub repo
    Write-Host "packages.config file not found in the expected location."
}