chcp 65001
set workdir=%1
set workdir=%workdir:"=%
%workdir:~0,2%
cd %1
set PSScript=%~dp0自动压制.ps1

powershell.exe -Command "& '%PSScript%'"

exit 0
