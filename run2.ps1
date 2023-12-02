$installchocolateyUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/scripts/packages/installchocolatey_new2.ps1"
$packagesConfigUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/minimal/packages.config"
$hardwareUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/scripts/other/hardware.ps1"
$systemrestoreUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/scripts/other/systemrestore.ps1"
$registryUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/scripts/registry/registry_new.ps1"
$servicesUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/scripts/services/services_new.ps1"
$removeaappsUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/scripts/removeapps/removeapps_new.ps1"
$localScriptPath = "C:\tools\BCURRAN3\choco-cleaner.ps1"

# Function to execute another PowerShell script
function RunGitHubScript($scriptUrl, $parameters = @{}) {
    try {
        # Download the script from GitHub
        $scriptContent = Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing | Select-Object -ExpandProperty Content

        # Execute the script content in a new scope with parameters
        & ([ScriptBlock]::Create($scriptContent)) @parameters
    }
    catch {
        Write-Host "Failed to download or execute the GitHub script from $scriptUrl. Error: $_"
    }
}

# Function to run another PowerShell script
function RunScript($scriptPath) {
    if (Test-Path $scriptPath) {
        & $scriptPath
    }
}

# Prompt the user to choose between Minimal and Default installation
$installType = Read-Host "Choose installation type (Minimal/Default)"

# Run additional scripts for Default installation
if ($installType -eq "Default") {
    RunGitHubScript -scriptUrl $hardwareUrl
    RunGitHubScript -scriptUrl $systemrestoreUrl
    RunGitHubScript -scriptUrl $installchocolateyUrl -parameters @{ packagesConfigUrl = $packagesConfigUrl }
    RunGitHubScript -scriptUrl $registryUrl
    RunGitHubScript -scriptUrl $servicesUrl
    RunGitHubScript -scriptUrl $removeaappsUrl
}

# Run the local script
RunScript -scriptPath $localScriptPath

# Remove functions defined in the script
Get-Command -Name * | ForEach-Object { Remove-Item -Path Function:\$($_.Name) -ErrorAction SilentlyContinue }