@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Define the download URL and the destination filename
set "URL=https://github.com/gz83/thorium/releases/download/M156.0.8078.28/thorium_AVX2_mini_installer.exe"
set "OUTPUT=Thorium AVX2.exe"

echo Downloading Thorium AVX2...

:: Use curl to download the file
:: -L follows redirects (Mozilla uses redirects for its download links)
:: -o specifies the output filename
curl -L "%URL%" -o "%OUTPUT%"

if %ERRORLEVEL% equ 0 (
    start "" "%OUTPUT%"
) else (
    echo An error occurred during the download process.
)