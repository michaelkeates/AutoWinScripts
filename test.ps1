Write-Host "============================"
Write-Host "Automated Setup and Debloat Script"
Write-Host "============================"
Write-Host "Please wait... Checking system information."

#OS information.
Write-Host "============================"
Write-Host "OS INFO"
Write-Host "============================"
Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption
Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty Version
Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty OSArchitecture

#Hardware information.
Write-Host "============================"
Write-Host "HARDWARE INFO"
Write-Host "============================"
Get-CimInstance -Class Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
Get-CimInstance -Class Win32_Processor | Select-Object -ExpandProperty Name

#Networking information.
Write-Host "============================"
Write-Host "NETWORK INFO"
Write-Host "============================"
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4'}
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv6'}

#Wait for 5 seconds so view what ip address been given to machine
Write-Host "============================"
Write-Host "Waiting for 5 seconds..."
Start-Sleep -Seconds 5
