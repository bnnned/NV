@echo off
setlocal enabledelayedexpansion

set "TEMP_DIR=%TEMP%\ShareXInstall"
mkdir "%TEMP_DIR%" 2>nul

echo Resolving latest ShareX release...
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command ^
    "(Invoke-RestMethod 'https://api.github.com/repos/ShareX/ShareX/releases/latest').assets | Where-Object { $_.name -like '*Setup*.exe' } | Select-Object -ExpandProperty browser_download_url"`) do (
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
"%INSTALLER%" /VERYSILENT /NORESTART /SUPPRESSMSGBOXES

echo Done.
endlocal