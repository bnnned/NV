@echo off
setlocal enabledelayedexpansion
copy "%~dp0MSI Afterburner.lnk" "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" >nul 2>&1
echo [INFO] Done.
pause
endlocal