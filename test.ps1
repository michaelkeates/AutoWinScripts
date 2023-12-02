# Use $PSScriptRoot to get the script directory
$scriptDirectory = $PSScriptRoot

# URL of the PowerShell scripts on GitHub
$hardwareUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/scripts/other/hardware.ps1"
$systemrestoreUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/scripts/other/systemrestore.ps1"
$installchocolateyUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/scripts/packages/installchocolatey_test2.ps1"

# Function to execute another PowerShell script
function RunGitHubScript($scriptUrl) {
    try {
        # Download the script from GitHub
        $scriptContent = Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing | Select-Object -ExpandProperty Content

        # Execute the script content in a new scope
        & ([ScriptBlock]::Create($scriptContent))
    }
    catch {
        Write-Host "Failed to download or execute the GitHub script from $scriptUrl. Error: $_"
    }
}

# Run the GitHub scripts
RunGitHubScript -scriptUrl $hardwareUrl
RunGitHubScript -scriptUrl $systemrestoreUrl
RunGitHubScript -scriptUrl $installchocolateyUrl