@echo off
:: Copy to Program Files
xcopy /i "%~dp0Mem Reduct" "C:\Program Files\Mem Reduct" /Y >nul 2>&1
:: Desktop & Start Menu shortcuts
copy "C:\Program Files\Mem Reduct\Mem Reduct.lnk" "%USERPROFILE%\Desktop" /Y >nul 2>&1
mkdir "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Mem Reduct" >nul 2>&1
copy "C:\Program Files\Mem Reduct\Mem Reduct.lnk" "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Mem Reduct" /Y >nul 2>&1
:: Delete unnecessary shortcut
del "C:\Program Files\Mem Reduct\Mem Reduct.lnk" >nul 2>&1

echo Mem Reduct has been installed and configured.
pause