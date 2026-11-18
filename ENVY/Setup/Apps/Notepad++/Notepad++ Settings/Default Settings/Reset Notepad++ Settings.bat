@echo off
echo [INFO] Resetting Notepad++ settings...
copy "%~dp0config.xml" "%APPDATA%\Notepad++\config.xml" /Y >nul 2>&1
echo [INFO] Done.
pause