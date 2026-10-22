//ZWE0EXT JOB ACCT#,ZWE0EXT,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*   - Change:                                                                 
//*       @PREFIX@                                                              
//*       ----+----1----+----2----+                                             
//*                  - To your desired data set name prefix                     
//*                  - Maximum length is 25 characters                          
//*                  - This value is used for the names of the                  
//*                    data sets extracted from the download-package            
//*       @zfs_path@                                                            
//*       ----+----1----+----2----+----3----+----4----+----5                    
//*                  - To the absolute z/OS UNIX path for the download          
//*                    package (starting with /)                                
//*                  - Maximum length is 50 characters                          
//*                  - Do not include a trailing /                              
//*                                                            
//* //UNPAX    EXEC PGM=IKJEFT01,REGION=0M,COND=(0,LT)
//* //SYSEXEC  DD DISP=SHR,DSN=SYS1.SBPXEXEC
//* //SYSTSPRT DD SYSOUT=*
//* //SYSTSIN  DD *
//*   oshell cd @zfs_path@/ ; +
//*     pax -rvf &FMID..pax.Z
//*
//         EXPORT SYMLIST=*
//*
//GIMUNZIP EXEC PGM=GIMUNZIP,REGION=0M,COND=(0,LT)
//*STEPLIB  DD DISP=SHR,DSN=SYS1.MIGLIB
//SYSUT3   DD UNIT=SYSALLDA,SPACE=(CYL,(50,10))
//SYSUT4   DD UNIT=SYSALLDA,SPACE=(CYL,(25,5))
//SMPOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SMPDIR   DD PATHDISP=KEEP,
// PATH='&PAXUSS'
//* //SYSIN    DD *
//SYSIN    DD  *,SYMBOLS=EXECSYS
<GIMUNZIP>
<ARCHDEF archid="&FMID..SMPMCS"
newname="&HLQ..&PRDID..&FMID..SMPMCS"
replace="YES"/>
<ARCHDEF archid="&FMID..F1"
newname="&HLQ..&PRDID..&FMID..F1"
replace="YES"/>
<ARCHDEF archid="&FMID..F2"
newname="&HLQ..&PRDID..&FMID..F2"
replace="YES"/>
<ARCHDEF archid="&FMID..F3"
newname="&HLQ..&PRDID..&FMID..F3"
replace="YES"/>
<ARCHDEF archid="&FMID..F4"
newname="&HLQ..&PRDID..&FMID..F4"
replace="YES"/>
</GIMUNZIP>
//*
