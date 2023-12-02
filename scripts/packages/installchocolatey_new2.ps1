param (
    [string]$packagesConfigUrl
)

# Install Chocolatey if not installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed. Skipping installation."
}

# Process package configuration
try {
    # Attempt to download the packages.config file
    Invoke-WebRequest -Uri $packagesConfigUrl -OutFile "$PSScriptRoot\packages.config"

    # Process package configuration
    $packagesConfig = Get-Content "$PSScriptRoot\packages.config"

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
    Write-Host "Failed to download packages.config file from $packagesConfigFile. Error: $_"
}