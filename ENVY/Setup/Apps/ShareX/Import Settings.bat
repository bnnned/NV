@echo off
:: Ensure the script runs relative to its execution folder
cd /d "%~dp0\Settings"

:: Closing active ShareX processes...
taskkill /f /im ShareX.exe >nul 2>&1
timeout /t 1 /nobreak >nul

:: Set ShareX directory
set "TARGET_DIR=%USERPROFILE%\Documents\ShareX"
if not exist "%TARGET_DIR%" (
    echo Target directory not found. Creating: %TARGET_DIR%
    mkdir "%TARGET_DIR%"
)

:: Copy ShareX settings
copy /y "*.json" "%TARGET_DIR%\" >nul
if exist "History.db" (
    copy /y "History.db" "%TARGET_DIR%\" >nul
)

echo Settings successfully imported!
timeout /t 2 >nul
exit
