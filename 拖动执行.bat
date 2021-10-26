chcp 65001
cd %1
set PSScript=%~dp0\自动压制.ps1

powershell.exe -Command "& '%PSScript%'"

exit 0