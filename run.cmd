@echo off
title Automated Setup and Debloat Script
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\hardware.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\systemrestore.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\remotedesktop.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\installchocolatey.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\registry\registry.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\services\services.ps1'  %*"
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& '%~dp0scripts\apps\removedefaultapps.ps1'  %*"
echo Completed
pause