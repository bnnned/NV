@echo off
echo [INFO] Applying Notepad++ settings...
copy "%~dp0Draculassi.xml" "C:\Program Files\Notepad++\themes\Draculassi.xml" /Y >nul 2>&1
copy "%~dp0config.xml" "%APPDATA%\Notepad++\config.xml" /Y >nul 2>&1
echo [INFO] Done.
pause