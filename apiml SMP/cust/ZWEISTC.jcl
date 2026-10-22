//ZWEISTC  JOB ACCT#,ZWEISTC,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//* Copy instream data to a USS file using IEBGENER
//*
//         EXPORT SYMLIST=*
//*
//* //         SET INSTHLQ=&HLQ..&PRDID..&VER
//* //         SET PRODUCT=PRODUCT
//         SET INSTHLQ=&HLQ..&PRDID..&VER
//         SET PRODUCT=PRODUCT
//* --- ZWESASTC ---
//STEP1    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DATA,DLM=@@,SYMBOLS=JCLONLY
//ZWESAUX  PROC RGN=0M
//* DO NOT LAUNCH THIS PROC MANUALLY OR IT WILL FAIL.                */
//* THE ZSS CROSS MEMORY SERVER WILL LAUNCH IT IF REQUIRED.          */
//********************************************************************/
//* This program and the accompanying materials are                  */
//* made available under the terms of the                            */
//* Eclipse Public License v2.0                                      */
//* which accompanies this distribution, and is available at         */
//* https://www.eclipse.org/legal/epl-v20.html                       */
//*                                                                  */
//* SPDX-License-Identifier: EPL-2.0                                 */
//*                                                                  */
//* Copyright Contributors to the Zowe Project.                      */
//********************************************************************/
//* A SAMPLE STC JCL FOR THE ZSS CROSS-MEMORY AUX SERVER             */
//*                                                                  */
//* 1. RUN-TIME PARAMETERS                                           */
//*                                                                  */
//* NONE                                                             */
//*                                                                  */
//* 2. PARMLIB                                                       */
//*                                                                  */
//* NONE                                                             */
//*                                                                  */
//* 3. STEPLIB DATASET NAME                                          */
//*                                                                  */
//* VERIFY AND/OR CHANGE THE NAME OF THE STEPLIB DATASET             */
//*                                                                  */
//* THE STARTED TASK MUST USE A STEPLIB DD STATEMENT TO DECLARE      */
//* THE ZSS CROSS MEMORY SERVER AUX LOAD LIBRARY NAME. THIS IS       */
//* REQUIRED SO THAT THE APPROPRIATE VERSION OF THE SOFTWARE IS      */
//* LOADED CORRECTLY. DO NOT ADD THE LOAD LIBRARY DATA SET TO        */
//* THE SYSTEM LNKLST OR LPALST CONCATENATIONS.                      */
//*                                                                  */
//********************************************************************/
//ZWESAUX  EXEC PGM=ZWESAUX,REGION=&RGN
//STEPLIB  DD   DSNAME=&INSTHLQ..SZWEAUTH,DISP=SHR
//         DD   DSNAME=&INSTHLQ..ZWESAPL,DISP=SHR
//SYSPRINT DD   SYSOUT=*
@@
//SYSUT2   DD DSN=&PRODUCT..PROCLIB(ZWESASTC),DISP=SHR
//* --- ZWESLSTC ---
//STEP2    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DATA,DLM=@@,SYMBOLS=JCLONLY
//ZWESLSTC  PROC RGN=0M,HAINST='__ha_instance_id__'
//********************************************************************/
//* This program and the accompanying materials are                  */
//* made available under the terms of the                            */
//* Eclipse Public License v2.0                                      */
//* which accompanies this distribution, and is available at         */
//* https://www.eclipse.org/legal/epl-v20.html                       */
//*                                                                  */
//* SPDX-License-Identifier: EPL-2.0                                 */
//*                                                                  */
//* Copyright Contributors to the Zowe Project.                      */
//********************************************************************/
//*                                                                  */
//* ZOWE LAUNCHER PROCEDURE                                          */
//*                                                                  */
//* NOTE: this procedure is a template, you will need to modify      */
//*       #zowe_yaml variable to point to your Zowe YAML config      */
//*       file.                                                      */
//*                                                                  */
//* Check https://docs.zowe.org for more details.                    */
//*                                                                  */
//********************************************************************/
//ZWELNCH  EXEC PGM=ZWELNCH,REGION=&RGN,TIME=NOLIMIT,
// PARM='ENVAR(_CEE_ENVFILE=DD:STDENV),POSIX(ON)/&HAINST.'
//STEPLIB  DD   DSNAME=&INSTHLQ..SZWEAUTH,
//             DISP=SHR
//SYSIN    DD  DUMMY
//SYSPRINT DD  SYSOUT=*,LRECL=1600
//SYSERR   DD  SYSOUT=*
//********************************************************************/
//*
//* CONFIG= can be either a single path ex.
//*   CONFIG=/my/zowe.yaml
//*
//* Or a list of FILE() or PARMLIB() and colon : separated paths
//*   in the form of
//*
//*    +------------ : ------------+
//*    V                           |
//* >--+--FILE(ussPath)------------+--><
//*    |                           |
//*    +--PARMLIB(dsname(member))--+
//*
//* Example:
//*   CONFIG=FILE(/my/long/path/to/1.yaml)\
//*   :PARMLIB(ZOWE.PARMLIB(YAML))
//*
//* In the above case, the \ is used as a line continuation.
//*
//* When using a list, files on left override properties
//* from files to their right.
//* Typically the right-most file should be the Zowe default yaml.
//*
//* Note: All PARMLIB() entries must all have the same member name.
//*
//********************************************************************/
//STDENV   DD  *
_CEE_ENVFILE_CONTINUATION=\
_CEE_RUNOPTS=HEAPPOOLS(OFF),HEAPPOOLS64(OFF)
_EDC_UMASK_DFLT=0002
CONFIG=&ZOWEPATH./zowe.yaml
/*
@@
//SYSUT2   DD DSN=&PRODUCT..PROCLIB(ZWESLSTC),DISP=SHR
//* --- ZWESISTC ---
//STEP3    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DATA,DLM=@@,SYMBOLS=JCLONLY
//ZWESIS01  PROC NAME='ZWESIS_STD',MEM=00,RGN=0M,OPT=''
//********************************************************************/
//* This program and the accompanying materials are                  */
//* made available under the terms of the                            */
//* Eclipse Public License v2.0                                      */
//* which accompanies this distribution, and is available at         */
//* https://www.eclipse.org/legal/epl-v20.html                       */
//*                                                                  */
//* SPDX-License-Identifier: EPL-2.0                                 */
//*                                                                  */
//* Copyright Contributors to the Zowe Project.                      */
//********************************************************************/
//* A SAMPLE STC JCL FOR THE ZSS CROSS-MEMORY SERVER                 */
//*                                                                  */
//* 1. RUN-TIME PARAMETERS                                           */
//*                                                                  */
//*   COLD  - COLD START                                             */
//*           RESET SERVER STATE. DO NOT USE WITHOUT CONSULTING WITH */
//*           SUPPORT.                                               */
//*           EXAMPLE: S ZWESIS01,REUSASID=YES,OPT='COLD'            */
//*                                                                  */
//*   DEBUG - DEBUG MODE                                             */
//*           EXAMPLE: S ZWESIS01,REUSASID=YES,OPT='DEBUG'           */
//*                                                                  */
//*   NAME  - NAME OF THIS SERVER                                    */
//*           ZWESIS_STD IS THE DEFAULT NAME, THE MAX LENGTH IS 16.  */
//*           EXAMPLE: S ZWESIS01,REUSASID=YES,NAME='ZWESIS_02'      */
//*                                                                  */
//*   MEM   - THE SUFFIX OF THE PARMLIB MEMBER                       */
//*           00 IS THE DEFAULT VALUE.                               */
//*           EXAMPLE: S ZWESIS01,REUSASID=YES,MEM=02                */
//*                                                                  */
//* AN EXAMPLE OF PASSING MULTIPLE PARAMETERS:                       */
//*   S ZWESIS01,REUSASID=YES,NAME='TEST',MEM=03,OPT='COLD,DEBUG'    */
//*                                                                  */
//* 2. PARMLIB                                                       */
//*                                                                  */
//* BY DEFAULT THE SERVER WILL READ ITS PARAMETERS FROM THE PARMLIB  */
//* DD DATASET. IF YOU WANT TO USE YOUR SYSTEM DEFINED PARMLIB,      */
//* REMOVE OR COMMENT OUT THE PARMLIB DD.                            */
//*                                                                  */
//* 3. STEPLIB DATASET NAME                                          */
//*                                                                  */
//* VERIFY AND/OR CHANGE THE NAME OF THE STEPLIB DATASET             */
//*                                                                  */
//* THE STARTED TASK MUST USE A STEPLIB DD STATEMENT TO DECLARE      */
//* THE ZSS CROSS MEMORY SERVER LOAD LIBRARY NAME. THIS IS REQUIRED  */
//* SO THAT THE APPROPRIATE VERSION OF THE SOFTWARE IS LOADED        */
//* CORRECTLY. DO NOT ADD THE LOAD LIBRARY DATA SET TO THE SYSTEM    */
//* LNKLST OR LPALST CONCATENATIONS.                                 */
//*                                                                  */
//********************************************************************/
//ZWESIS01 EXEC PGM=ZWESIS01,REGION=&RGN,
//         PARM='NAME=&NAME,MEM=&MEM,&OPT'
//STEPLIB  DD   DSNAME=&INSTHLQ..SZWEAUTH,DISP=SHR
//         DD   DSNAME=&INSTHLQ..ZWESAPL,DISP=SHR
//PARMLIB  DD   DSNAME=&PRODUCT..PARMLIB,DISP=SHR
//SYSPRINT DD   SYSOUT=*
@@
//SYSUT2   DD DSN=&PRODUCT..PROCLIB(ZWESISTC),DISP=SHR


