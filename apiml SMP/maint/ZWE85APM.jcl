//ZWE85APM JOB ACCT#,ZWE85APM,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//*********************************************************************
//* APPLY  MAINTENANCE                                                *
//*********************************************************************
//*                                                                   *
//* You may use this JCL to APPLY the received SYSMODs.               *
//*                                                                   *
//* This APPLY processing will also select SYSMOD for other           *
//* functions that are installed into your target zone, if            *
//* the SYSMOD is needed to satisfy an IFREQ.                         *
//*                                                                   *
//* Review the system holddata and ensure you can comply with all     *
//* holds before you run this job.                                    *
//*                                                                   *
//* Run the following JCL with the CHECK parameter.  After successful *
//* completion of the job remove the CHECK parameter and rerun.       *
//*                                                                   *
//* To apply Broadcom Recommended service, uncomment the              *
//* SOURCEID(CAR*) statement.                                         *
//*                                                                   *
//* Execute the SCMSEDIT edit macro to customize this job for your    *
//* environment, then submit the job.                                 *
//*                                                                   *
//*********************************************************************
//* (C) 2025 Broadcom Inc and/or its subsidiaries;                    *
//* All rights reserved                                               *
//*********************************************************************
//*
//APPLY    EXEC PGM=GIMSMP,PARM='DATE=U',REGION=0M
//SMPCSI   DD DISP=SHR,DSN=&HLQ..&PRDID..&VER..CSI
//SMPCNTL  DD   *,SYMBOLS=JCLONLY
SET BOUNDARY (&TZONE) .
APPLY
 /* SOURCEID(CAR*) */ /*** Uncomment if applying CA RS  ***/
  FORFMID (
   &FMID   /*APIML                                                 */
          )
  GROUPEXTEND(NOAPARS NOUSERMODS)
  BYPASS(HOLDSYSTEM) .