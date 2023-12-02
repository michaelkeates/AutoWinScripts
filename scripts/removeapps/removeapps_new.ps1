param (
    [string]$removeappsConfigUrl
)

# Function to process app removal
function RemoveApp($appName) {
    # Use `Get-AppxPackage` without `Version` parameter to remove all versions of the app
    Get-AppxPackage -Name *$appName* -AllUsers | Remove-AppxPackage
}

# Function to run another PowerShell script
function RunScript($scriptUrl) {
    $scriptContent = Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing | Select-Object -ExpandProperty Content
    $scriptBlock = [ScriptBlock]::Create($scriptContent)
    & $scriptBlock
}

# Function to enable Remote Desktop firewall rule
function EnableRemoteDesktopFirewallRule() {
    netsh advfirewall firewall set rule group="Remote Desktop" new enable=Yes
}

# Attempt to download the registry.config file
Invoke-WebRequest -Uri $removeappsConfigUrl -OutFile "$scriptDirectory\removeapps.config"

# Process app removal configuration
if (Test-Path $removeappsConfigUrl) {
    # Read the contents of the removeapps.config file
    $removeappsConfig = Get-Content "$scriptDirectory\removeapps.config"

    # Flag to track if Microsoft.RemoteDesktop is enabled in the config
    $remoteDesktopEnabled = $false

    # For each line in the removeapps.config file
    foreach ($line in $removeAppsConfig) {
        # Skip comment lines that begin with #
        if (-not ($line -match '^\s*#')) {
            # Extract the app name from the line
            $appName = $line.Trim()

            # Check if the app name is Microsoft.RemoteDesktop
            if ($appName -eq "Microsoft.RemoteDesktop") {
                # Set the flag to true if not commented out
                $remoteDesktopEnabled = $true
            }
            else {
                # Process app removal
                RemoveApp -appName $appName

                # Check if the app name is Microsoft.Edge exists and run another script
                if ($appName -eq "Microsoft.Edge") {
                    $edgeRemovalScriptUrl = "https://raw.githubusercontent.com/michaelkeates/AutoWinScripts/main/scripts/removeapps/removeedge.ps1"
                    RunScript -scriptUrl $edgeRemovalScriptUrl
                }
            }
        }
    }

    # Check if Microsoft.RemoteDesktop is not enabled and enable the firewall rule
    if (-not $remoteDesktopEnabled) {
        EnableRemoteDesktopFirewallRule
    }
}
else {
    Write-Host "removeapps.config file not found in the expected location."
}