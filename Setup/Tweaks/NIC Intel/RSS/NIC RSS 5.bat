@echo off

echo [INFO] Configuring RSS to
echo [INFO] ProcNumber: 5, Queues: 1
for /f "delims=" %%b in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /f "*SpeedDuplex" ^| findstr "HKEY"') do (

    reg add "%%b" /v "*RSSProfile" /t REG_SZ /d "4" /f >nul 2>&1
	reg add "%%b" /v "*NumRssQueues" /t REG_SZ /d "1" /f >nul 2>&1
	reg add "%%b" /v "*RssBaseProcNumber" /t REG_SZ /d "5" /f >nul 2>&1
	reg add "%%b" /v "*MaxRssProcessors" /t REG_SZ /d "1" /f >nul 2>&1
)

echo. 
echo [INFO] Done.
pause 
