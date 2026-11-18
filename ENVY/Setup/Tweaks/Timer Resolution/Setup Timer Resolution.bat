@echo off

copy "%~dp0SetTimerResolution.exe" "C:\Windows" /Y >nul 2>&1
copy "%~dp0SetTimerResolution.lnk" "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" /Y >nul 2>&1
echo Done.
pause