REM The following is the format of the instruction for running this script.
REM You will need to access the command line using vobmadm_m account.
REM 
REM moveinactivevob <vobname> <refreshserverhostname> <LIDcode>
REM 
REM The vobname argument shall be entered without the backslash character ("\")
REM The refresh hostname shall be entered as the Full Qualified Domain name 
REM ending in "honeywell.com".
REM 

cleartool umount \%1
multitool chreplica -host %2 %1_%3@\%1
cleartool lsrep -invob vob:\%1
multitool syncreplica -export -fship