@echo off
set /p view="Enter view name: "
set /p viewpath="Enter view path: "
cd %RATIONAL_HOME%\ClearCase\etc\utils
fix_prot -replace %viewpath%
cleartool lsview -prop -full %view%
