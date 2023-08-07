$host.ui.RawUI.WindowTitle = 'Edge Removal - AveYo, 2023.07.08'

# targets
#$remove_win32 = @("Microsoft Edge", "Microsoft Edge Update")
#$remove_appx = @("MicrosoftEdge")

$remove_win32 += "Microsoft EdgeWebView"
$remove_appx += "Win32WebViewHost"


# enable admin privileges
Write-Host "Enabling admin privileges..."
$D1 = [uri].module.gettype('System.Diagnostics.Process')."GetM`ethods"(42) | where {$_.Name -eq 'SetPrivilege'} #`:no-ev-warn
'SeSecurityPrivilege', 'SeTakeOwnershipPrivilege', 'SeBackupPrivilege', 'SeRestorePrivilege' | foreach {
    $D1.Invoke($null, @("$_", 2))
}

# set useless policies
Write-Host "Setting useless policies..."
foreach ($p in 'HKLM\SOFTWARE\Policies', 'HKLM\SOFTWARE', 'HKLM\SOFTWARE\WOW6432Node') {
    reg add "$p\Microsoft\EdgeUpdate" /f /v InstallDefault /d 0 /t reg_dword
    reg add "$p\Microsoft\EdgeUpdate" /f /v Install{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062} /d 0 /t reg_dword
    reg add "$p\Microsoft\EdgeUpdate" /f /v Install{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5} /d 1 /t reg_dword
    reg add "$p\Microsoft\EdgeUpdate" /f /v DoNotUpdateToEdgeWithChromium /d 1 /t reg_dword
}

Write-Host "Setting useless policies for EdgeUpdate..."
$edgeupdate = 'Microsoft\EdgeUpdate\Clients\{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}'
foreach ($p in 'HKLM\SOFTWARE', 'HKLM\SOFTWARE\Wow6432Node') {
    reg add "$p\$edgeupdate\Commands\on-logon-autolaunch" /f /v CommandLine /d systray.exe
    reg add "$p\$edgeupdate\Commands\on-logon-startup-boost" /f /v CommandLine /d systray.exe
    reg add "$p\$edgeupdate\Commands\on-os-upgrade" /f /v CommandLine /d systray.exe
}

# clear win32 uninstall block
Write-Host "Clearing win32 uninstall block..."
foreach ($hk in 'HKCU', 'HKLM') {
    foreach ($wow in '', '\Wow6432Node') {
        foreach ($i in $remove_win32) {
            reg delete "$hk\SOFTWARE${wow}\Microsoft\Windows\CurrentVersion\Uninstall\$i" /f /v NoRemove
            reg add "$hk\SOFTWARE${wow}\Microsoft\EdgeUpdateDev" /f /v AllowUninstall /d 1 /t reg_dword
        }
    }
}

# find all Edge setup.exe and gather BHO paths
$setup = @()
$bho = @()
$bho += "$env:ProgramData\ie_to_edge_stub.exe"
$bho += "$env:Public\ie_to_edge_stub.exe"
"LocalApplicationData", "ProgramFilesX86", "ProgramFiles" | foreach {
    $setup += Get-ChildItem "$($([Environment]::GetFolderPath($_)))\Microsoft\Edge*\setup.exe" -Recurse -ErrorAction SilentlyContinue
    $bho += Get-ChildItem "$($([Environment]::GetFolderPath($_)))\Microsoft\Edge*\ie_to_edge_stub.exe" -Recurse -ErrorAction SilentlyContinue
}

# shut edge down
foreach ($p in 'MicrosoftEdgeUpdate', 'chredge', 'msedge', 'edge', 'msedgewebview2', 'Widgets') {
    Stop-Process -Name $p -Force -ErrorAction SilentlyContinue
}

# use dedicated C:\Scripts path due to Sigma rules FUD
$DIR = "$env:SystemDrive\Scripts"
$null = New-Item -Path $DIR -ItemType Directory -ErrorAction SilentlyContinue

# export OpenWebSearch innovative redirector
foreach ($b in $bho) {
    if (Test-Path $b) {
        try {
            Copy-Item $b "$DIR\ie_to_edge_stub.exe" -Force -ErrorAction SilentlyContinue
        } catch { }
    }
}

# clear appx uninstall block and remove
Write-Host "Clearing appx uninstall block and removing..."
$provisioned = Get-AppxProvisionedPackage -Online
$appxpackage = Get-AppxPackage -AllUsers
$store = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore'
$store_reg = $store.replace(':', '')
$users = @('S-1-5-18')
if (Test-Path $store) {
    $users += (Get-ChildItem $store | where { $_ -like '*S-1-5-21*' }).PSChildName
}
foreach ($choice in $remove_appx) {
    if ('' -eq $choice.Trim()) { continue }
    foreach ($appx in $($provisioned | where { $_.PackageName -like "*$choice*" })) {
        Write-Host "Removing $($appx.DisplayName)..."
        $PackageFamilyName = ($appxpackage | where { $_.Name -eq $appx.DisplayName }).PackageFamilyName
        cmd /c "reg add ""$store_reg\Deprovisioned\$PackageFamilyName"" /f"
        cmd /c "dism /online /remove-provisionedappxpackage /packagename:$($appx.PackageName)"
    }
    foreach ($appx in $($appxpackage | where { $_.PackageFullName -like "*$choice*" })) {
        Write-Host "Removing $($appx.DisplayName)..."
        $inbox = (Get-ItemProperty "$store\InboxApplications\*$($appx.Name)*").Path.PSChildName
        $PackageFamilyName = $appx.PackageFamilyName
        $PackageFullName = $appx.PackageFullName
        ECHO Y | cmd /c "reg delete ""$store_reg\InboxApplications\$inbox"" /f"
        cmd /c "reg add ""$store_reg\Deprovisioned\$PackageFamilyName"" /f"
        foreach ($sid in $users) {
            cmd /c "reg add ""$store_reg\EndOfLife\$sid\$PackageFullName"" /f"
        }
        cmd /c "dism /online /set-nonremovableapppolicy /packagefamily:$PackageFamilyName /nonremovable:0"
        Remove-AppxPackage -Package $PackageFullName -AllUsers -ErrorAction SilentlyContinue
        foreach ($sid in $users) {
            Write-Host "Removing $PackageFullName..."
            cmd /c "reg delete ""$store_reg\EndOfLife\$sid\$PackageFullName"" /f"
        }
    }
}

# remove OpenWebSearch before running edge setup
Write-Host "Removing OpenWebSearch before running edge setup..."
$IFEO = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'
$MSEP = ($env:ProgramFiles, ${env:ProgramFiles(x86)})[[Environment]::Is64BitOperatingSystem] + '\Microsoft\Edge\Application'
cmd /c "reg delete ""$IFEO\ie_to_edge_stub.exe"" /f /v UseFilter /d 1 /t reg_dword"
cmd /c "reg delete ""$IFEO\ie_to_edge_stub.exe\0"" /f /v FilterFullPath /d ""$DIR\ie_to_edge_stub.exe"""
cmd /c "reg delete ""$IFEO\ie_to_edge_stub.exe\0"" /f /v Debugger /d ""$CMD $DIR\OpenWebSearch.cmd"""
cmd /c "reg delete ""$IFEO\msedge.exe"" /f /v UseFilter /d 1 /t reg_dword"
cmd /c "reg delete ""$IFEO\msedge.exe\0"" /f /v FilterFullPath /d ""$MSEP\msedge.exe"""
cmd /c "reg delete ""$IFEO\msedge.exe\0"" /f /v Debugger /d ""$CMD $DIR\OpenWebSearch.cmd"""

# shut edge down, again
Write-Host "Shutting edge down, again..."
foreach ($p in 'MicrosoftEdgeUpdate', 'chredge', 'msedge', 'edge', 'msedgewebview2', 'Widgets') {
    Stop-Process -Name $p -Force -ErrorAction SilentlyContinue
}

# brute-run found Edge setup.exe with uninstall args
Write-Host "Brute-running found Edge setup.exe with uninstall args..."
$purge = '--uninstall --force-uninstall --system-level' # --delete-old-versions --channel=stable
foreach ($s in $setup) {
    try {
        Start-Process -FilePath $s -ArgumentList "--msedgewebview $purge" -Wait -ErrorAction SilentlyContinue
    } catch { }
}

foreach ($s in $setup) {
    try {
        Start-Process -FilePath $s -ArgumentList "--msedge $purge" -Wait -ErrorAction SilentlyContinue
    } catch { }
}

# prevent latest cumulative update (LCU) failing due to non-matching EndOfLife Edge entries
Write-Host "Preventing latest cumulative update (LCU) failing due to non-matching EndOfLife Edge entries..."
foreach ($i in $remove_appx) {
    Get-ChildItem "$store\EndOfLife" -Recurse -ErrorAction SilentlyContinue | where { $_ -like "*${i}*" } | foreach {
        cmd /c "reg delete ""$($_.Name)"" /f"
    }
    Get-ChildItem "$store\Deleted\EndOfLife" -Recurse -ErrorAction SilentlyContinue | where { $_ -like "*${i}*" } | foreach {
        cmd /c "reg delete ""$($_.Name)"" /f"
    }
}

# extra cleanup
Write-Host "Extra cleanup..."
$appdata = [Environment]::GetFolderPath('ApplicationData')
$desktop = [Environment]::GetFolderPath('Desktop')
$public_desktop = [Environment]::GetFolderPath('CommonDesktopDirectory')
$start_menu_programs = [Environment]::GetFolderPath('CommonPrograms')
Remove-Item "$appdata\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Tombstones\Microsoft Edge.lnk" -Force -ErrorAction SilentlyContinue
Remove-Item "$appdata\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk" -Force -ErrorAction SilentlyContinue
Remove-Item "$appdata\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk" -Force -ErrorAction SilentlyContinue
Remove-Item "$desktop\Microsoft Edge.lnk" -Force -ErrorAction SilentlyContinue
Remove-Item "$public_desktop\Microsoft Edge.lnk" -Force -ErrorAction SilentlyContinue
Remove-Item "$start_menu_programs\Microsoft Edge.lnk" -Force -ErrorAction SilentlyContinue

# add OpenWebSearch to redirect microsoft-edge: anti-competitive links to the default browser
Write-Host "Adding OpenWebSearch to redirect microsoft-edge: anti-competitive links to the default browser..."
$IFEO = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'
$MSEP = ($env:ProgramFiles, ${env:ProgramFiles(x86)})[[Environment]::Is64BitOperatingSystem] + '\Microsoft\Edge\Application'
$MIN = ('--headless', '--width 1 --height 1')[([environment]::OSVersion.Version.Build) -gt 25179]
$CMD = "$env:systemroot\system32\conhost.exe $MIN" # AveYo: minimize prompt - see Terminal issue #13914
cmd /c "reg add HKCR\microsoft-edge /f /ve /d URL:microsoft-edge"
cmd /c "reg add HKCR\microsoft-edge /f /v ""URL Protocol"" /d """""
cmd /c "reg add HKCR\microsoft-edge /f /v NoOpenWith /d """""
cmd /c "reg add HKCR\microsoft-edge\shell\open\command /f /ve /d ""$DIR\ie_to_edge_stub.exe %1"""
cmd /c "reg add HKCR\MSEdgeHTM /f /v NoOpenWith /d """""
cmd /c "reg add HKCR\MSEdgeHTM\shell\open\command /f /ve /d ""$DIR\ie_to_edge_stub.exe %1"""
cmd /c "reg add ""$IFEO\ie_to_edge_stub.exe"" /f /v UseFilter /d 1 /t reg_dword"
cmd /c "reg add ""$IFEO\ie_to_edge_stub.exe\0"" /f /v FilterFullPath /d ""$DIR\ie_to_edge_stub.exe"""
cmd /c "reg add ""$IFEO\ie_to_edge_stub.exe\0"" /f /v Debugger /d ""$CMD $DIR\OpenWebSearch.cmd"""
cmd /c "reg add ""$IFEO\msedge.exe"" /f /v UseFilter /d 1 /t reg_dword"
cmd /c "reg add ""$IFEO\msedge.exe\0"" /f /v FilterFullPath /d ""$MSEP\msedge.exe"""
cmd /c "reg add ""$IFEO\msedge.exe\0"" /f /v Debugger /d ""$CMD $DIR\OpenWebSearch.cmd"""

$OpenWebSearch = @"
@title OpenWebSearch Redux & echo off & set ?= open start menu web search, widgets links or help in your chosen browser - by AveYo
for /f %%E in ('"prompt $E$S& for %%e in Get-MpPreference | select SubmitSamplesConsent # default is 2
# The rest of the $OpenWebSearch string content...
$OpenWebSearch += @"
"@ 