REM The following is the format of the instruction for running this script.
REM You will need to access the command line using vobmadm_m account.
REM 
REM moveinactivevob2 <vobname> <refreshserverhostname> <LIDcode>
REM 
REM The vobname argument shall be entered without the backslash character ("\")
REM The refresh hostname shall be entered as the Full Qualified Domain name 
REM ending in "honeywell.com".
REM 

SET vobname=%1
SET lid1=%2
SET lid2=%3
SET lid3=%4
SET lid4=%5
SET lid5=%6
SET lid6=%7
SET lid7=%8
SET lid8=%9

multitool syncreplica -export -fship %1_DCE@\%1