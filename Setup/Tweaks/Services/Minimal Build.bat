@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

"%~dp0service-builder.exe" --config "%~dp0Minimal Config.ini" --disable-service-warning
for /d %%A in ("%~dp0build\*") do (
    set "foldername=%%~nxA"
)

ren "%~dp0build\%foldername%" "Minimal Services"
xcopy /i "%~dp0build\Minimal Services" "%~dp0Minimal Services" /Y >nul 2>&1
copy "%~dp0NSudoLG.exe" "%~dp0Minimal Services" /Y >nul 2>&1
rmdir /s /q "%~dp0build" >nul 2>&1

echo Done. 
pause