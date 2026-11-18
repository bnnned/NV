@echo off
echo Press F11 to start/end capturing.
pushd %~dp0
cd Captures
..\PresentMon.exe --multi_csv --exclude dwm.exe --no_console_stats --timed 60 --hotkey "F11"