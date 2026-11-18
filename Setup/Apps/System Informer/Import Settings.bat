@echo off
echo [INFO] Copying settings file...
copy "%~dp0settings.json" "%APPDATA%\SystemInformer\settings.json" /Y >nul 2>&1
echo [INFO] Done.
pause