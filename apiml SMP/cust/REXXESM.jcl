//REXXESM  JOB ACCT#,REXXESM,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//********************************************************************* 00070002
//*         COPY STEP - IEBGENER -                                    * 00080002
//********************************************************************* 00090002
//*                                                                     00100002
//GENER    EXEC PGM=IEBGENER                                            00110002
//*                                                                     00120002
//SYSPRINT DD SYSOUT=*                                                  00130002
//*                                                                     00140002
//SYSIN    DD DUMMY                                                     00150002
//*                                                                     00160002
//SYSUT1   DD DDNAME=TSOREXX                                            00170002
//*                                                                     00180002
//SYSUT2   DD DISP=(NEW,PASS),DSN=&&TMP(TSOREXX),                       00190002
//             UNIT=SYSALLDA,SPACE=(1024,(1000,500,1)),                 00200002
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)                        00210002
//*                                                                     00220002
//TSOREXX  DD *,DLM=$$                                                  00230002
/*************************** REXX ************************************/ 00240002
/*                     SYSTEM INFORMATION                            */ 00250002
/*                z/OS System Information Utility                    */ 00260002
/*                                                                   */ 00270002
/* DESCRIPTION:   Read z/OS image and return basic information       */ 00280002
/*                about the system.                                  */ 00290002
/*********************************************************************/ 00300002
Address TSO                                                             00310002
numeric Digits 64                                                       00320002
s = 0                                                                   00330002
                                                                        00340002
call GET_ESM                                                            00350002
call WRITE_OUTPUT                                                       00360002
                                                                        00370002
/*-------------------------------------------------------------------*/ 00380002
/*    EXIT                                                           */ 00390002
/*-------------------------------------------------------------------*/ 00400002
EXIT;                                                                   00410002
                                                                        00420002
GET_ESM:                                                                00430002
/*-------------------------------------------------------------------*/ 00440002
/*  Get External Security System Information                         */ 00450002
/*-------------------------------------------------------------------*/ 00460002
var = "BCM_CEM_ESM_DISCOVERED"                                          00470002
cvt_addr = x2d(c2x(Storage(d2x(16),4)))           /* Get CVT address */ 00480002
cvtrac = x2d(c2x(Storage(d2x(cvt_addr+992),4)))   /* Get rac address */ 00490002
rcvtid = Storage(d2x(cvtrac),4)                   /* Get rac string  */ 00500002
If rcvtid = 'RCVT' Then                                                 00510002
   do                                                                   00520002
        say 'External Security Software: RACF'                          00530002
        value='RACF'                                                    00540002
        exit 1                                                          00550003
   end;                                                                 00560002
Else If rcvtid = 'RTSS' Then                                            00570002
   do                                                                   00580002
        say 'External Security Software: Top Secret'                    00590002
        value='Top Secret'                                              00600002
        exit 2                                                          00610003
   end;                                                                 00620002
Else If rcvtid = 'ACF2' Then                                            00630002
   do                                                                   00640002
        say 'Security Software: ACF2'                                   00650002
        value='ACF2'                                                    00660002
        exit 3                                                          00670003
   end;                                                                 00680002
Else SAY "*Error*  No Security Software Found";                         00690002
return                                                                  00700002
                                                                        00710002
ADD_LINE:                                                               00720002
s = s + 1                                                               00730002
sysinfo.s = var || '=' || value                                         00740002
sysinfo.0 = s                                                           00750002
return                                                                  00760002
                                                                        00770002
WRITE_OUTPUT:                                                           00780002
ADDRESS TSO                                                             00790002
"ALLOC FI(outdd) DA('PUBLIC.CEM.CUST.ZOSMFLIB(SYSINFO)') SHR"           00800002
"EXECIO * DISKW outdd (STEM sysinfo. FINIS"                             00810002
"FREE FI(outdd)"                                                        00820002
return                                                                  00830002
$$                                                                      00840002
//*                                                                     00850002
//********************************************************************* 00860002
//*         RUN  STEP - IKJEFT01 -                                    * 00870002
//********************************************************************* 00880002
//*                                                                     00890002
//RUNIT    EXEC PGM=IKJEFT01                                            00900002
//*                                                                     00910002
//SYSEXEC  DD DISP=(OLD,DELETE),DSN=&&TMP                               00920002
//*                                                                     00930002
//SYSTSPRT DD SYSOUT=*                                                  00940002
//*                                                                     00950002
//SYSTSIN  DD *                                                         00960002
  %TSOREXX                                                              00970002
/*                                                                      00980002
//*                                                                     00990002
//********************************************************************* 01000002
