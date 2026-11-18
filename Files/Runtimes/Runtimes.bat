@echo off

:: 7-Zip, Open-Shell, VC++ Runtimes
call "%~dp0Runtimes\7z.exe" /S>nul 2>&1
call "%~dp0Runtimes\openshell.exe" /qn ADDLOCAL=StartMenu>nul 2>&1
call "%~dp0Runtimes\vc.exe" /ai /gm2>nul 2>&1

:: Blank icon shortcuts
copy "%~dp0blank.ico" "C:\Windows" /Y >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /t REG_SZ /d "C:\Windows\blank.ico" /f>nul 2>&1

:: Open-Shell: Dark theme
if exist "C:\Program Files\Open-Shell\StartMenu.exe" (
	xcopy "%~dp0OpenShell\Fluent-Metro.skin7" "C:\Program Files\Open-Shell\Skins\" /H /Y >nul 2>&1
	"C:\Program Files\Open-Shell\StartMenu.exe" -xml "%~dp0OpenShell\draculassi openshell settings.xml"
	echo Done.
	timeout /t 2 >nul 2>&1
) else ( 
	echo Openshell not found.
	timeout /t 2 >nul 2>&1
)