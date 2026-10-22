//ZWEIMVS JOB ACCT#,ZWEIMVS,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//* This program and the accompanying materials are made available
//* under the terms of the Eclipse Public License v2.0 which
//* accompanies this distribution, and is available at
//* https://www.eclipse.org/legal/epl-v20.html
//*
//* SPDX-License-Identifier: EPL-2.0
//*
//* Copyright Contributors to the Zowe Project. 2020, 2020
//*
//*********************************************************************
//*
//* This job is used to create datasets used by a Zowe "instance"
//* Instances represent a configuration of Zowe, different from the
//* "runtime" datasets that are created upon install of Zowe / SMPE.
//*
//* If your choosen value of 'zowe.setup.dataset.authLoadlib' is not
//* Equal to 'zowe.setup.prefix' + 'SZWELOAD',
//* Then you must also run "ZWEIMVS2".
//*
//*********************************************************************
//         EXPORT SYMLIST=*
//*
//         SET INSTHLQ=&HLQ..&PRDID..&VER
//         SET PRODUCT=PRODUCT
//DELETEDS EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *,SYMBOLS=EXECSYS
  DELETE &INSTHLQ..PARMLIB
  DELETE &INSTHLQ..ZWESAPL
  SET MAXCC = 0
//*
//MKPDSE EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=A
//SYSTSIN DD *,SYMBOLS=EXECSYS
ALLOC NEW DA('&INSTHLQ..PARMLIB') +
dsntype(library) dsorg(po) recfm(f b) lrecl(80) +
unit(sysallda) space(15,15) tracks
ALLOC NEW DA('&INSTHLQ..ZWESAPL') +
dsntype(library) dsorg(po) recfm(u) lrecl(0) +
blksize(32760) unit(sysallda) space(30,15) tracks
//*
//MEMBCPY EXEC PGM=IEBCOPY
//SYSPRINT DD SYSOUT=A
//SYSUT1 DD DSN=&INSTHLQ..SZWESAMP,DISP=SHR
//SYSUT2 DD DSN=&PRODUCT..PARMLIB,DISP=OLD
//SYSIN DD *,SYMBOLS=EXECSYS
  COPY OUTDD=SYSUT2,INDD=SYSUT1
  SELECT MEMBER=((ZWESIP00,,R))
//*
