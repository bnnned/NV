@echo off

:: 7-Zip, Open-Shell, VC++ Runtimes
call "C:\ProgramData\ENVY\Files\Runtimes\7z.exe" /S>nul 2>&1
call "C:\ProgramData\ENVY\Files\Runtimes\openshell.exe" /qn ADDLOCAL=StartMenu>nul 2>&1
call "C:\ProgramData\ENVY\Files\Runtimes\vc.exe" /ai /gm2>nul 2>&1

:: BCD 
bcdedit /set bootmenupolicy legacy>nul 2>&1

:: NVIDIA Inspector Profile (.nip) file association
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.nip" /v "FriendlyTypeName" /t REG_SZ /d "nvidiaProfileInspector Profile" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.nip" /ve /t REG_SZ /d "nvidiaProfileInspector Profile" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\.nip\Shell" /ve /t REG_SZ /d "Import" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\.nip\Shell\Import\Command" /ve /t REG_EXPAND_SZ /d "\"C:\ProgramData\ENVY\Setup\Tweaks\GPU\Inspector\nvidiaProfileInspector.exe\" \"%%1\"" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\.nip\DefaultIcon" /ve /t REG_EXPAND_SZ /d "C:\ProgramData\ENVY\Setup\Tweaks\GPU\Inspector\nvidiaProfileInspector.exe,0" /f >nul 2>&1

:: Power plan (.pow) file association
reg add "HKEY_CLASSES_ROOT\.pow" /ve /t REG_SZ /d "Power Plan" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\.pow" /v "FriendlyTypeName" /t REG_SZ /d "Power Plan" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\.pow\DefaultIcon" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\powercfg.cpl,-202" /f >nul 2>&1
reg add "HKEY_CLASSES_ROOT\.pow\shell\Import\command" /ve /t REG_SZ /d "powercfg /import \"%%1\"" /f>nul 2>&1

:: Storage tweaks
fsutil 8dot3name set 1>nul 2>&1
fsutil behavior set disablelastaccess 1>nul 2>&1

:: Explorer tweaks
reg delete "HKEY_CLASSES_ROOT\.bmp\ShellNew" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\txtfile\shell\print" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\regfile\shell\print" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\batfile\shell\print" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.1\shell\print" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\AcroExch.Document.DC\shell\print" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\AcroExch.Document\shell\print" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\PreviousVersions" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /ve /t REG_SZ /d "" /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f>nul 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ForegroundLockTimeout /t REG_DWORD /d 0 /f>nul 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v JPEGImportQuality /t REG_DWORD /d 100 /f>nul 2>&1

:: Blank icon shortcuts
copy "C:\ProgramData\ENVY\Files\blank.ico" "C:\Windows" /Y >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /t REG_SZ /d "C:\Windows\blank.ico" /f>nul 2>&1

:: Open-Shell: Dark theme
if exist "C:\Program Files\Open-Shell\StartMenu.exe" (
	xcopy "C:\ProgramData\ENVY\Files\OpenShell\Fluent-Metro.skin7" "C:\Program Files\Open-Shell\Skins\" /H /Y >nul 2>&1
	"C:\Program Files\Open-Shell\StartMenu.exe" -xml "C:\ProgramData\ENVY\Files\OpenShell\draculassi openshell settings.xml"
	echo Done.
	timeout /t 2 >nul 2>&1
) else ( 
	echo Openshell not found.
	timeout /t 2 >nul 2>&1
)