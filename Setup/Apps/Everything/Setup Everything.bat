@echo off
:: Copy to Program Files
xcopy /i "%~dp0Everything 1.5a" "C:\Program Files\Everything 1.5a" /Y >nul 2>&1
:: Desktop & Start Menu shortcuts
copy "C:\Program Files\Everything 1.5a\Everything.lnk" "%USERPROFILE%\Desktop" /Y >nul 2>&1
mkdir "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Everything" >nul 2>&1
copy "C:\Program Files\Everything 1.5a\Everything.lnk" "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Everything" /Y >nul 2>&1
:: Delete unnecessary shortcut
del "C:\Program Files\Everything 1.5a\Everything.lnk" >nul 2>&1

echo Done.
pause