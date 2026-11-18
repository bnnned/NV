@echo off
echo [INFO] Applying BCD Settings...
bcdedit /set allowedinmemorysettings 0x0>nul 2>&1
bcdedit /set linearaddress57 optout>nul 2>&1
bcdedit /set bootux disabled>nul 2>&1
bcdedit /set disabledynamictick yes>nul 2>&1
bcdedit /set quietboot yes>nul 2>&1
bcdedit /set bootlog no>nul 2>&1
bcdedit /set isolatedcontext no>nul 2>&1
bcdedit /set tpmbootentropy forcedisable>nul 2>&1
echo [INFO] Done.
pause