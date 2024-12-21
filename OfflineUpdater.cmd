@echo off 
(NET FILE||(powershell -command Start-Process '%0' -Verb runAs -ArgumentList '%* '&EXIT /B))>NUL 2>&1 
pushd "%~dp0" && cd %~dp0

:detection
for /f %%a in ('wmic logicaldisk where "VolumeName='WINVENUS'" get deviceid^|find ":"')do set "DrivePath=%%a" 
if not [%DrivePath%]==[] goto start 
if [%DrivePath%]==[] echo Automatic WINVENUS detection failed! Enter Drive Letter manually. 
:sdisk 
set /P DrivePath=Enter the drive letter of WINVENUS ^(should be X:^): 
if [%DrivePath%]==[] goto sdisk 
if not "%DrivePath:~1,1%"==":" set DrivePath=%DrivePath%:
:start 
if not exist "%DrivePath%\Windows\" echo Error! Selected Disk "%DrivePath%" doesn't have any Windows installation. & pause & exit 
.\tools\DriverUpdater\%PROCESSOR_ARCHITECTURE%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\venus.xml -p %DrivePath% 
pause