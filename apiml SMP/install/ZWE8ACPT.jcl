//ZWE8ACPT JOB ACCT#,ZWE8ACPT,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//* This program and the accompanying materials are made available
//* under the terms of the Eclipse Public License v2.0 which
//* accompanies this distribution, and is available at
//* https://www.eclipse.org/legal/epl-v20.html
//*
//* SPDX-License-Identifier: EPL-2.0
//*
//* Copyright Contributors to the Zowe Project. 2019, 2024
//*
//********************************************************************
//*
//* This JCL will SMP/E ACCEPT product
//* Zowe Open Source Project
//*
//*
//* CAUTION: This is neither a JCL procedure nor a complete job.
//* Before using this job step, you will have to make the following
//* modifications:
//*
//* 1) Add the job parameters to meet your system requirements.
//*
//* 2) Change #csihlq to the high level qualifier for the global zone
//*    of the CSI.
//*
//* 3) Change #dzone to your CSI distribution zone name.
//*
//* 4) Once the ACCEPT CHECK is successful, remove the CHECK operand
//*    and run the job again to do the ACCEPT.
//*
//* Note(s):
//*
//* 1. The REDO operand must be added to the ACCEPT command if the
//*    product has been ACCEPTed previously.
//*
//* 2. This job should complete with a return code 0.
//*
//********************************************************************
//         EXPORT SYMLIST=(CSIHLQ,DZONE)
//* longest DSN is dsprefix.fmid.Fxx, so CISHLQ can be up to 32 chars
//*                            1         2         3
//*                   12345678901234567890123456789012
//         SET CSIHLQ=&HLQ..&PRDID..&VER
//         SET DZONE=DZONE
//*
//ACCEPT   EXEC PGM=GIMSMP,REGION=0M,COND=(4,LT)
//SMPCSI   DD DISP=OLD,DSN=&CSIHLQ..CSI
//SMPCNTL  DD *,SYMBOLS=JCLONLY
  SET BOUNDARY(&DZONE) .
  ACCEPT SELECT(&FMID)
         BYPASS(HOLDSYS,HOLDUSER,APPLYCHECK)
         COMPRESS(ALL) .
//*
