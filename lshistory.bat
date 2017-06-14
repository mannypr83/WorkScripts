::
::	Before running this script run this cmd: 
::	runas /env /user:namerica4\clearcase_nm75 cmd
::	enter password
::	do a cd c:\lshistory
::	type lshistory
::	press enter
::

set var=GPS_SIMLAB_US_PVOB
m:
cd admin_view
cleartool protect -chmod 775 %var%
cd %var%
cleartool lshistory -minor -all -last 25 > c:\lshistory\%var%.txt
cd ..
cleartool protect -chmod 770 %var%
c:
