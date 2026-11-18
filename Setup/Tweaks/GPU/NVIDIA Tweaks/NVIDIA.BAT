@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Run as administrator.
    pause
    exit /b 1
)

set "CLASSKEY=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
set "SVCKEY=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\nvlddmkm"
set "TARGET="
set "MATCHDESC="
set /a MATCHCOUNT=0

for /f "delims=" %%K in ('reg query "%CLASSKEY%" 2^>nul') do (
    set "LINE=%%K"
    if not "!LINE!"=="" (
        if "!LINE:~0,5!"=="HKEY_" (
            if /I not "!LINE!"=="%CLASSKEY%" (
                set "SUBKEY=!LINE!"
                set "DESC="
                for /f "tokens=2,*" %%A in ('reg query "!SUBKEY!" /v DriverDesc 2^>nul ^| findstr /I "DriverDesc"') do set "DESC=%%B"
                if defined DESC (
                    echo !DESC! | findstr /I "NVIDIA" >nul
                    if not errorlevel 1 (
                        set /a MATCHCOUNT+=1
                        set "TARGET=!SUBKEY!"
                        set "MATCHDESC=!DESC!"
                    )
                )
            )
        )
    )
)

if %MATCHCOUNT% equ 0 (
    echo [ERROR] No instance with "NVIDIA" was found.
    pause
    exit /b 1
)

if %MATCHCOUNT% gtr 1 (
    echo [INFO] Found %MATCHCOUNT% NVIDIA instances.
)

echo [GPU] !MATCHDESC!

:apply
echo [INFO] Applying NVIDIA Tweaks...
reg add "%TARGET%" /v DisableDynamicPstate /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%TARGET%" /v RMHdcpKeyGlobZero /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%TARGET%" /v RMDisableGpuASPMFlags /t REG_DWORD /d 3 /f >nul 2>&1
reg add "%TARGET%" /v PowerMizerEnable /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%TARGET%" /v PowerMizerLevel /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%TARGET%" /v PowerMizerLevelAC /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%TARGET%" /v PerfLevelSrc /t REG_DWORD /d 0x2222 /f >nul 2>&1
reg add "%TARGET%" /v RmDisableHwFaultBuffer /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%TARGET%" /v RmRcWatchdog /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%TARGET%" /v RMNvLog /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%TARGET%" /v EnableRuntimePowerManagement /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%TARGET%" /v RMPcieLtrOverride /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%TARGET%" /v RMPcieLtrL12ThresholdOverride /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%TARGET%" /v RMDeepL1EntryLatencyUsec /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%TARGET%" /v Head0DClkMode /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "%TARGET%" /v Head1DClkMode /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "%TARGET%" /v Head2DClkMode /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "%TARGET%" /v Head3DClkMode /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "%TARGET%" /v PClkMode /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "%TARGET%" /v RmGpsPreferIntrinsicFuncs /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%TARGET%" /v RmGpsACPIType /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%TARGET%" /v RmDisableACPI /t REG_DWORD /d 0x3ff /f >nul 2>&1
reg add "%TARGET%" /v RMCtxswLog /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%SVCKEY%" /v RMDisableIntrIllegalCompstatAccess /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%SVCKEY%" /v DisableForcedRMHwSchedulingWARs /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%SVCKEY%" /v LogWarningEntries /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%SVCKEY%" /v LogPagingEntries /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%SVCKEY%" /v LogEventEntries /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%SVCKEY%" /v LogErrorEntries /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%SVCKEY%" /v DisableBugcheckCallback /t REG_DWORD /d 1 /f >nul 2>&1
reg add "%SVCKEY%" /v EnableBugcheckDisplay /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%SVCKEY%" /v AllowdGPUPassthrough /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%SVCKEY%" /v EnableBugcheckTinting /t REG_DWORD /d 0 /f >nul 2>&1
echo [INFO] Done. Reboot to apply changes.
pause