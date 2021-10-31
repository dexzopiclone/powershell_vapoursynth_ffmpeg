chcp 65001
set workdir=%1
%workdir:~0,2%
cd %1
set PSScript=%~dp0\自动压制.ps1

powershell.exe -Command "& '%PSScript%'"

exit 0
