@echo off
setlocal enabledelayedexpansion

set "TEMP_DIR=%TEMP%\SystemInformerInstall"
mkdir "%TEMP_DIR%" 2>nul

echo Resolving latest System Informer Canary release...
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command ^
    "(Invoke-RestMethod 'https://api.github.com/repos/winsiderss/si-builds/releases/latest').assets | Where-Object { $_.name -like '*canary-setup.exe' } | Select-Object -ExpandProperty browser_download_url"`) do (
    set "DOWNLOAD_URL=%%A"
)

if "%DOWNLOAD_URL%"=="" (
    echo Failed to resolve download URL. Check network/GitHub API rate limit.
    exit /b 1
)

for %%F in ("%DOWNLOAD_URL%") do set "FILENAME=%%~nxF"
set "INSTALLER=%TEMP_DIR%\%FILENAME%"

echo Downloading %FILENAME%...
curl.exe -L -o "%INSTALLER%" "%DOWNLOAD_URL%"

if not exist "%INSTALLER%" (
    echo Download failed.
    exit /b 1
)

echo Installing silently...
"%INSTALLER%" -silent

echo Done.
endlocal