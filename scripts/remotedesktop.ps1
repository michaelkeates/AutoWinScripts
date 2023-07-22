Write-Host "============================"
Write-Host "ENABLE REMOTE DESKTOP"
Write-Host "============================"

#enable Remote Desktop firewall rule
netsh advfirewall firewall set rule group="Remote Desktop" new enable=Yes

#enable Remote Desktop in registry
#Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 0

#eet Terminal Service startup mode to automatic
#Set-Service -Name termservice -StartupType Automatic

#start the Terminal Service
#Start-Service -Name termservice
