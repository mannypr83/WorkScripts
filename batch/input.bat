@echo off
set /p view="Enter view name: "
set /p path="Enter view path: "
echo %view%
echo %path%
cd %RATIONAL_HOME%\ClearCase\etc\utils
fix_prot -replace %path%
cleartool lsview -prop -full %view%
