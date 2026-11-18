@echo off
setlocal EnableDelayedExpansion

set "BACKUP_DIR=%~dp0Backup"
mkdir "%BACKUP_DIR%" >nul 2>&1

echo [INFO] Creating registry backup...
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" "%BACKUP_DIR%\Kernel.reg" /y >nul 2>&1 && echo   [OK] Kernel || echo   [!] Failed to backup kernel
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "%BACKUP_DIR%\Memory Management.reg" /y >nul 2>&1 && echo   [OK] Memory Management || echo   [!] Failed
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "%BACKUP_DIR%\Session Manager Power.reg" /y >nul 2>&1 && echo   [OK] Session Manager Power || echo   [!] Failed
reg export "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "%BACKUP_DIR%\Graphics Drivers.reg" /y >nul 2>&1 && echo   [OK] Graphics Drivers || echo   [!] Failed
reg export "HKLM\SOFTWARE\Microsoft\Windows\Dwm" "%BACKUP_DIR%\DWM.reg" /y >nul 2>&1 && echo   [OK] DWM || echo   [!] Failed
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Power" "%BACKUP_DIR%\Power.reg" /y >nul 2>&1 && echo   [OK] Power || echo   [!] Failed
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" "%BACKUP_DIR%\NVIDIA Class.reg" /y >nul 2>&1 && echo   [OK] NVIDIA Class || echo   [!] Failed
reg export "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" "%BACKUP_DIR%\nvlddmkm.reg" /y >nul 2>&1 && echo   [OK] nvlddmkm || echo   [!] Failed
echo.
echo [INFO] Done.
pause