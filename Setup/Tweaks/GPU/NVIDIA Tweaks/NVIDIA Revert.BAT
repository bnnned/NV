@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Not elevated. Right-click -^> Run as administrator.
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
echo [INFO] Reverting NVIDIA Tweaks...
reg delete "%TARGET%" /v DisableDynamicPstate /f >nul 2>&1
reg delete "%TARGET%" /v RMHdcpKeyGlobZero /f >nul 2>&1
reg delete "%TARGET%" /v RMDisableGpuASPMFlags /f >nul 2>&1
reg delete "%TARGET%" /v PowerMizerEnable /f >nul 2>&1
reg delete "%TARGET%" /v PowerMizerLevel /f >nul 2>&1
reg delete "%TARGET%" /v PowerMizerLevelAC /f >nul 2>&1
reg delete "%TARGET%" /v PerfLevelSrc /f >nul 2>&1
reg delete "%TARGET%" /v RmDisableHwFaultBuffer /f >nul 2>&1
reg delete "%TARGET%" /v RmRcWatchdog /f >nul 2>&1
reg delete "%TARGET%" /v RMNvLog /f >nul 2>&1
reg delete "%TARGET%" /v EnableRuntimePowerManagement /f >nul 2>&1
reg delete "%TARGET%" /v RMPcieLtrOverride /f >nul 2>&1
reg delete "%TARGET%" /v RMPcieLtrL12ThresholdOverride /f >nul 2>&1
reg delete "%TARGET%" /v RMDeepL1EntryLatencyUsec /f >nul 2>&1
reg delete "%TARGET%" /v Head0DClkMode /f >nul 2>&1
reg delete "%TARGET%" /v Head1DClkMode /f >nul 2>&1
reg delete "%TARGET%" /v Head2DClkMode /f >nul 2>&1
reg delete "%TARGET%" /v Head3DClkMode /f >nul 2>&1
reg delete "%TARGET%" /v PClkMode /f >nul 2>&1
reg delete "%TARGET%" /v RmGpsPreferIntrinsicFuncs /f >nul 2>&1
reg delete "%TARGET%" /v RmGpsACPIType /f >nul 2>&1
reg delete "%TARGET%" /v RmDisableACPI /f >nul 2>&1
reg delete "%TARGET%" /v RMCtxswLog /f >nul 2>&1
reg delete "%SVCKEY%" /v RMDisableIntrIllegalCompstatAccess /f >nul 2>&1
reg delete "%SVCKEY%" /v DisableForcedRMHwSchedulingWARs /f >nul 2>&1
reg delete "%SVCKEY%" /v LogWarningEntries /f >nul 2>&1
reg delete "%SVCKEY%" /v LogPagingEntries /f >nul 2>&1
reg delete "%SVCKEY%" /v LogEventEntries /f >nul 2>&1
reg delete "%SVCKEY%" /v LogErrorEntries /f >nul 2>&1
reg delete "%SVCKEY%" /v DisableBugcheckCallback /f >nul 2>&1
reg delete "%SVCKEY%" /v EnableBugcheckDisplay /f >nul 2>&1
reg delete "%SVCKEY%" /v AllowdGPUPassthrough /f >nul 2>&1
reg delete "%SVCKEY%" /v EnableBugcheckTinting /f >nul 2>&1
echo [INFO] Done. Reboot to apply changes.
pause