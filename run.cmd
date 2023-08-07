@echo off
title Automated Setup and Debloat Script
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\other\hardware.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\other\systemrestore.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\packages\installchocolatey.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\registry\registry.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\services\services.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\removeapps\removeapps.ps1'  %*"
echo Cleaning up...
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& 'C:\tools\BCURRAN3\choco-cleaner.ps1'  %*"
echo Completed. Please reboot.
pause