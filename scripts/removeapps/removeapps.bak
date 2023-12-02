#get the directory path of the script
$scriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

#specify the relative path to the removeapps.config file
$removeAppsConfigPath = Join-Path -Path $scriptDirectory -ChildPath "..\..\removeapps.config"

#function to process app removal
function RemoveApp($appName) {
    #use `Get-AppxPackage` without `Version` parameter to remove all versions of the app
    Get-AppxPackage -Name *$appName* -AllUsers | Remove-AppxPackage
}

#function to run another PowerShell script
function RunScript($scriptName) {
    $scriptPath = Join-Path -Path $scriptDirectory -ChildPath $scriptName
    if (Test-Path $scriptPath) {
        & $scriptPath
    }
}

#function to enable Remote Desktop firewall rule
function EnableRemoteDesktopFirewallRule() {
    netsh advfirewall firewall set rule group="Remote Desktop" new enable=Yes
}

#process app removal configuration
if (Test-Path $removeAppsConfigPath) {
    #read the contents of the removeapps.config file
    $removeAppsConfig = Get-Content $removeAppsConfigPath

    #flag to track if Microsoft.RemoteDesktop is enabled in the config
    $remoteDesktopEnabled = $false

    #for each line in the removeapps.config file
    foreach ($line in $removeAppsConfig) {
        #skip comment lines that begin with #
        if (-not ($line -match '^\s*#')) {
            #extract the app name from the line
            $appName = $line.Trim()

            #check if the app name is Microsoft.RemoteDesktop
            if ($appName -eq "Microsoft.RemoteDesktop") {
                #set the flag to true if not commented out
                $remoteDesktopEnabled = $true
            }
            else {
                #process app removal
                RemoveApp -appName $appName

                #check if the app name is Microsoft.Edge exists and run another script
                if ($appName -eq "Microsoft.Edge") {
                    & $PSScriptRoot\removeedge.ps1
                }
            }
        }
    }

    #check if Microsoft.RemoteDesktop is not enabled and enable the firewall rule
    if (-not $remoteDesktopEnabled) {
        EnableRemoteDesktopFirewallRule
    }
}
else {
    Write-Host "removeapps.config file not found in the expected location."
}