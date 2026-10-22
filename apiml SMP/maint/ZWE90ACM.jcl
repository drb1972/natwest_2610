//ZWE90ACM JOB ACCT#,ZWE90ACM,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//*********************************************************************
//* MEMBER: ZWEM90ACM  ACCEPT MAINTENANCE   CHECK                     *
//*********************************************************************
//*                                                                   *
//* You may use this JCL to ACCEPT the applied SYSMODs.               *
//*                                                                   *
//* It is recommended that you run the following JCL with the         *
//* CHECK parameter.  After ACCEPT completes successfully with CHECK, *
//* remove the CHECK and rerun.                                       *
//*                                                                   *
//* To accept Broadcom Recommended service, uncomment SOURCEID(CAR*)  *
//* statement.                                                        *
//*                                                                   *
//* Execute the SCMSEDIT edit macro to customize this JOB for your    *
//* environment, then submit the job.                                 *
//*                                                                   *
//*********************************************************************
//* (C) 2025 Broadcom Inc and/or its subsidiaries;                    *
//* All rights reserved                                               *
//*********************************************************************
//*
//ACCEPT   EXEC PGM=GIMSMP,PARM='DATE=U',REGION=0M
//SMPCSI    DD DISP=SHR,DSN=&HLQ..&PRDID..&VER..CSI
//SMPCNTL   DD   *,SYMBOLS=JCLONLY
SET BOUNDARY (&DZONE) .
ACCEPT PTFS
  CHECK               /*** Remove to accept all SYSMODs.     ***/
 /* SOURCEID(CAR*) */ /*** Uncomment if accepting CA RS   ***/
  GROUPEXTEND(NOAPARS NOUSERMODS)
  FORFMID (
   &FMID   /*APIML                                             */
          )
  BYPASS(HOLDSYSTEM) .