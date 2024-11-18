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

echo Searching for the "Call Of Duty" folder. Please wait...
for /f "delims=" %%I in ('powershell -NoProfile -Command ^
    "Get-ChildItem -Path C:\ -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'Call Of Duty' } | ForEach-Object { Get-ChildItem -Path $_.FullName -Recurse -Directory | Where-Object { $_.Name -eq 'Content' } } | Select-Object -ExpandProperty FullName"') do set CONTENTDIR=%%I

if "%CONTENTDIR%"=="" (
    echo No "Content" subfolder found under any "Call Of Duty" folder.
    pause
    exit /b
)

echo "Content" folder located at: %CONTENTDIR%
set SYSFILE=%CONTENTDIR%\randgrid.sys

if not exist "%SYSFILE%" (
    echo Randgrid.sys not found in "%CONTENTDIR%".
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
sc create atvi-randgrid_msstore type= kernel binPath= "%SYSFILE%"
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
pause
