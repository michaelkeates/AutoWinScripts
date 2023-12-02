# URL of the PowerShell script on GitHub
$githubScriptUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/minimal/minimal.ps1"

# Function to execute another PowerShell script
function RunGitHubScript($scriptUrl) {
    try {
        # Download the script from GitHub
        $scriptContent = Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing | Select-Object -ExpandProperty Content

        # Execute the script content
        Invoke-Expression -Command $scriptContent
    }
    catch {
        Write-Host "Failed to download or execute the GitHub script from $scriptUrl. Error: $_"
    }
}

# Run the GitHub script
RunGitHubScript -scriptUrl $githubScriptUrl
