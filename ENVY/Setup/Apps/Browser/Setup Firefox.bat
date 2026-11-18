@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Define the download URL and the destination filename
set "URL=https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
set "OUTPUT=FirefoxInstaller.exe"

echo Downloading the latest version of Firefox...

:: Use curl to download the file
:: -L follows redirects (Mozilla uses redirects for its download links)
:: -o specifies the output filename
curl -L "%URL%" -o "%OUTPUT%"

if %ERRORLEVEL% equ 0 (
    echo Launching installer...
    start "" "%OUTPUT%"
) else (
    echo An error occurred during the download process.
)

pause