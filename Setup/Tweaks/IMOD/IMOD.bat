@echo off
xcopy /i "%~dp0RW-Everything" "C:\Program Files\RW-Everything" /Y >nul 2>&1
copy "%~dp0IMOD.ps1" "C:\Program Files\RW-Everything" /Y >nul 2>&1
copy "%~dp0IMOD.lnk" "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" /Y >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d "0" /f>nul 2>&1
echo Done.
pause