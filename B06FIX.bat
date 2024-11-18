@echo off
echo.
echo __/\\\\\\\\\\\\\_______/\\\\\\\_______________/\\\\\____________/\\\\\\\\\\\\\\\__/\\\\\\\\\\\__/\\\_______/\\\_        
echo _\/\\\/////////\\\___/\\\/////\\\_________/\\\\////____________\/\\\///////////__\/////\\\///__\///\\\___/\\\/__       
echo _\/\\\_______\/\\\__/\\\____\//\\\_____/\\\///_________________\/\\\_________________\/\\\_______\///\\\\\\/____      
echo _\/\\\\\\\\\\\\\\__\/\\\_____\/\\\___/\\\\\\\\\\\______________\/\\\\\\\\\\\_________\/\\\_________\//\\\\______     
echo _\/\\\/////////\\\_\/\\\_____\/\\\__/\\\\///////\\\____________\/\\\///////__________\/\\\__________\/\\\\______    
echo _\/\\\_______\/\\\_\/\\\_____\/\\\_\/\\\______\//\\\___________\/\\\_________________\/\\\__________/\\\\\\_____   
echo _\/\\\_______\/\\\_\//\\\____/\\\__\//\\\______/\\\____________\/\\\_________________\/\\\________/\\\////\\\___  
echo _\/\\\\\\\\\\\\\/___\///\\\\\\\/____\///\\\\\\\\\/_____________\/\\\______________/\\\\\\\\\\\__/\\\/___\///\\\_ 
echo _\/////////////_______\///////________\/////////_______________\///______________\///////////__\///_______\///__
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges. Please run as Administrator.
    pause
    exit /b
)

setlocal enabledelayedexpansion

set FOUND=false
set CONTENTDIR=

echo Searching in common locations...

for %%D in ("C:\Program Files" "C:\Program Files (x86)" "C:\Users") do (
    for /f "delims=" %%I in ('dir /s /b /ad "%%D\Call Of Duty\Content" 2^>nul') do (
        set CONTENTDIR=%%I
        set FOUND=true
        goto :found
    )
)

if not !FOUND! == true (
    echo Searching all drives for "Call Of Duty" folder...
    for %%D in (C D E F G) do (
        for /f "delims=" %%I in ('dir /s /b /ad "%%D:\Call Of Duty\Content" 2^>nul') do (
            set CONTENTDIR=%%I
            set FOUND=true
            goto :found
        )
    )
)

:found

if "!CONTENTDIR!"=="" (
    echo No "Content" folder found.
    pause
    exit /b
)

echo "Content" folder located at: !CONTENTDIR!
set SYSFILE=!CONTENTDIR!\randgrid.sys

if not exist "!SYSFILE!" (
    echo Randgrid.sys not found in "!CONTENTDIR!".
    pause
    exit /b
)

sc query atvi-randgrid_msstore >nul 2>&1
if %errorlevel% equ 0 (
    echo Removing existing service atvi-randgrid_msstore...
    sc delete atvi-randgrid_msstore
    if %errorlevel% neq 0 (
        echo Failed to remove the service.
        pause
        exit /b
    )
) else (
    echo No existing service atvi-randgrid_msstore found.
)

echo Creating the Randgrid service...
sc create atvi-randgrid_msstore type= kernel binPath= "!SYSFILE!"
if %errorlevel% neq 0 (
    echo Failed to create the service. Ensure the file path is correct.
    pause
    exit /b
)

sc sdset atvi-randgrid_msstore D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWRPWPLOCRRC;;;IU)(A;;CCLCSWRPWPLOCRRC;;;SU)(A;;CCLCSWLOCRRC;;;AU)

if %errorlevel% neq 0 (
    echo Failed to set service permissions.
    pause
    exit /b
)

echo Service installed and configured successfully.

echo.
echo Attempting to repair game files using Xbox App...
start "" "ms-windows-store://pdp/?productid=9MWPM2CQNLX2" 
timeout /t 10 /nobreak

echo Running System File Checker (sfc /scannow)...
sfc /scannow
if %errorlevel% neq 0 (
    echo SFC scan failed. Please check system logs for details.
)

echo Running CHKDSK on C: drive...
chkdsk C: /f /r /x
if %errorlevel% neq 0 (
    echo CHKDSK scan failed. Please check system logs for details.
)

echo Repairing folder permissions for the game directory...
icacls "!CONTENTDIR!" /grant Everyone:F /T

echo Repair process completed.
pause
