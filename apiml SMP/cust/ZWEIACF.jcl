//ZWEIACF JOB ACCT#,ZWEIACF,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//* This program and the accompanying materials are made available
//* under the terms of the Eclipse Public License v2.0 which
//* accompanies this distribution, and is available at
//* https://www.eclipse.org/legal/epl-v20.html
//*
//* SPDX-License-Identifier: EPL-2.0
//*
//* Copyright Contributors to the Zowe Project. 2018, 2020
//*
//*********************************************************************
//*
//* Zowe Open Source Project
//* This JCL can be used to define security permits for Zowe
//*
//*
//* CAUTION: This is neither a JCL procedure nor a complete job.
//* Before using this JCL, you will have to make the following
//* modifications:
//*
//* 1) Add job name and job parameters to the JOB statement, to
//*    meet your system requirements.
//*
//* 12) When not using AUTOUID and AUTOGID to assign z/OS UNIX UID
//*     and GID values, update the SET *ID= statements to match the
//*     desired UID and GID values.
//*
//* 13) When using Top Secret, update the Top Secret specific SET
//*     statements.
//*
//* 14) Customize the commands in the DD statement that matches your
//*     security product so that they meet your system requirements.
//*
//* Note(s):
//*
//* 1. THE USER ID THAT RUNS THIS JOB MUST HAVE SUFFICIENT AUTHORITY
//*    TO ALTER SECURITY DEFINITIONS
//*
//* 2. The sample ACF2 commands create ROLEs that match the group
//*    names. Due to permits assigned to the &STCGRP ROLE, it is
//*    advised to ensure this ROLE has a unique identifier.
//*
//* 3. The Zowe started task user ID (variable ZOWEUSER) must be able
//*    to write persistent data in the zlux-app-server/deploy directory
//*    structure. This sample JCL makes the Zowe started task part of
//*    the Zowe administrator group (SET STCGRP=ADMINGRP. statement)
//*    to achieve this goal. Another solution, also below, which you can
//*    comment out, is giving the Zowe started task CONTROL access to
//*    the UNIXPRIV SUPERUSER.FILESYS profile.
//*
//* 4. This job WILL complete with return code 0.
//*    The results of each command must be verified after completion.
//*
//*********************************************************************
//         EXPORT SYMLIST=*
//*
//         SET  PRODUCT=ACF2
//         SET ADMINGRP=ZWEADMIN
//         SET   STCGRP=ZWEADMIN
//         SET ZOWEUSER=ZWESVUSR
//         SET  ZISUSER=ZWESIUSR
//         SET  ZOWESTC=ZWESLSTC
//         SET   ZISSTC=ZWESISTC
//         SET   AUXSTC=ZWESASTC
//         SET      HLQ=PUBLIC.ZOWE.V3.&PRDID..&VER
//         SET  SYSPROG=ZWEADMIN
//*
//* The sample RACF and ACF2 commands assume AUTOUID and AUTOGID are
//* enabled. When this is not the case, or you are using Top Secret,
//* provide appropriate (numeric) values to these SET commands.
//         SET ADMINGID=             * Group ID for ZOWE administrators
//         SET   STCGID=&ADMINGID.   * Group ID for ZOWE started tasks
//         SET  ZOWEUID=             * UID for ZOWE started task User
//         SET   ZISUID=             * UID for ZIS started task User
//*
//* For RACF: If using AUTOUID and AUTOGID, the RACF database must be
//*           at AIM 2 or higher, and BPX.NEXT.USER must exist.
//* For ACF2: If using AUTOUID and AUTOGID, an AUTOIDOM GSO Record must
//*           exist.
//* For Top Secret: If a default UID and GID range is defined, you can
//*                 specify '?' in the SET *ID= statements to utilize
//*                 auto-assignment of UID and GID.
//*
//* Top Secret ONLY -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
//*                     12345678
//         SET ADMINDEP=             * department owning admin group
//         SET  STCGDEP=             * department owning STC group
//         SET  STCUDEP=             * department owning STC user IDs
//         SET  ZOWEDEP=             * department owning Zowe resources
//         SET  FACACID=             * ACID owning IBMFAC
//*                     12345678
//*
//* end Top Secret ONLY -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
//*
//*********************************************************************
//*
//* EXECUTE COMMANDS FOR SELECTED SECURITY PRODUCT
//*
//RUN      EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=&PRODUCT
//*
//*********************************************************************
//*
//* ACF2 ONLY, customize to meet your system requirements
//*
//ACF2     DD DATA,DLM=$$,SYMBOLS=JCLONLY
ACF
*
* DEFINE ADMINISTRATORS ...........................................
*
* group for administrators
* replace AUTOGID with GID(&ADMINGID.) if AUTOGID is not enabled
*
SET PROFILE(GROUP) DIV(OMVS)
INSERT ZWEADMIN AUTOGID
F ACF2,REBUILD(GRP),CLASS(P)
*
* uncomment and customize to add an existing userid as administrator
*
SET X(ROL)
INSERT ZWEADMIN INCLUDE(PROD001) ROLE
F ACF2,NEWXREF,TYPE(ROL)
SET X(ROL)
INSERT ZWEADMIN INCLUDE(PROD002) ROLE
F ACF2,NEWXREF,TYPE(ROL)
*
* DEFINE STARTED TASK .............................................
*
* comment out if STCGRP matches ADMINGRP (default), expect
*   warning messages otherwise
* group for started tasks
* replace AUTOGID with GID(&STCGID.) if AUTOGID is not enabled
*
SET PROFILE(GROUP) DIV(OMVS)
INSERT ZWEADMIN AUTOGID
F ACF2,REBUILD(GRP),CLASS(P)
*
*****
*
* userid for ZOWE main server
* replace AUTOUID with UID(&ZOWEUID.) if AUTOUID is not enabled
*
SET LID
INSERT ZWESVUSR STC GROUP(ZWEADMIN)
SET PROFILE(USER) DIV(OMVS)
INSERT ZWESVUSR AUTOUID HOME(/tmp) OMVSPGM(/bin/sh)
F ACF2,REBUILD(USR),CLASS(P),DIVISION(OMVS)
*
* userid for ZIS cross memory server
* replace AUTOUID with UID(&ZISUID.) if AUTOUID is not enabled
*
SET LID
INSERT ZWESIUSR STC GROUP(ZWEADMIN)
SET PROFILE(USER) DIV(OMVS)
INSERT ZWESIUSR AUTOUID HOME(/tmp) OMVSPGM(/bin/sh)
F ACF2,REBUILD(USR),CLASS(P),DIVISION(OMVS)
*
*****
*
* started task for ZOWE main server
*
SET CONTROL(GSO)
INSERT STC.ZWESLSTC LOGONID(ZWESVUSR) +
GROUP(ZWEADMIN) +
STCID(ZWESLSTC)
F ACF2,REFRESH(STC)
*
* started task for ZIS cross memory server
*
SET CONTROL(GSO)
INSERT STC.ZWESISTC LOGONID(ZWESIUSR) +
GROUP(ZWEADMIN) +
STCID(ZWESISTC)
F ACF2,REFRESH(STC)
*
* started task for ZIS Auxiliary cross memory server
*
SET CONTROL(GSO)
INSERT STC.ZWESASTC LOGONID(ZWESIUSR) +
GROUP(ZWEADMIN) +
STCID(ZWESASTC)
F ACF2,REFRESH(STC)
*
* DEFINE ZIS SECURITY RESOURCES ..................................
*
* define a role holding the permissions, add &ZISUSER and
* &ZOWEUSER to it
*
SET X(ROL)
INSERT ZWEADMIN INCLUDE(ZWESVUSR) ROLE
F ACF2,NEWXREF,TYPE(ROL)
CHANGE ZWEADMIN INCLUDE(ZWESIUSR) ADD
F ACF2,NEWXREF,TYPE(ROL)
*
* DEFINE STC SERVER PERMISIONS ....................................
*
* permit AUX and Zowe main server to use ZIS cross memory server
*
SET RESOURCE(FAC)
RECKEY ZWES ADD(IS SERVICE(READ) ROLE(ZWEADMIN) ALLOW)
F ACF2,REBUILD(FAC)
*
* DEFINE ZOWE SERVER PERMISIONS ...................................
*
* permit Zowe main server to create a user's security environment
* ATTENTION: Defining the BPX.DAEMON or BPX.SERVER profile makes
*            z/OS UNIX switch to z/OS UNIX level security. This is
*            more secure, but it can impact operation of existing
*            applications. Test this thoroughly before activating
*            it on a production system.
*
SET RESOURCE(FAC)
RECKEY BPX ADD(DAEMON SERVICE(UPDATE) ROLE(ZWEADMIN) ALLOW)
RECKEY BPX ADD(SERVER SERVICE(UPDATE) ROLE(ZWEADMIN) ALLOW)
*
* permit Zowe main server to create a user's security environment
* comment out the following 3 lines if the OMVSAPPL is not defined
* in your environment
SET RESOURCE(APL)
RECKEY OMVSAPPL ADD(SERVICE(READ) ROLE(ZWEADMIN) ALLOW)
F ACF2,REBUILD(APL)
*
* Allow STCGRP role access to BPX.JOBNAME
RECKEY BPX ADD(JOBNAME SERVICE(READ) ROLE(ZWEADMIN) ALLOW)
F ACF2,REBUILD(FAC)
*
** comment out to not use SUPERUSER.FILESYS, see JCL comments
** permit Zowe main server to write persistent data
** if there is no rule, use set rule
SET RULE
COMPILE *
$KEY(SUPERUSER.FILESYS)
$TYPE(UNI)
$ROLESET
 ROLE(ZWEADMIN) ALLOW

STORE
* SET RESOURCE(UNI)
* RECKEY SUPERUSER.FILESYS ADD(SERVICE(READ) ROLE(ZWEADMIN) ALLOW)

  F ACF2,REBUILD(UNI)

* allow STCGRP role to use client certificate mapping service
SET RESOURCE(FAC)
RECKEY IRR ADD(RUSERMAP ROLE(ZWEADMIN) SERVICE(READ) ALLOW)
F ACF2,REBUILD(FAC)

* allow STCGRP role to use distributed identity mapping service
SET RESOURCE(FAC)
RECKEY IRR ADD(IDIDMAP.QUERY ROLE(ZWEADMIN) SERVICE(READ) ALLOW)
F ACF2,REBUILD(FAC)

* permit Zowe main server to cut SMF records
SET RESOURCE(FAC)
RECKEY IRR ADD(RAUDITX ROLE(ZWEADMIN) SERVICE(READ) ALLOW)
F ACF2,REBUILD(FAC)

*
* DEFINE ZOWE DATA SET PROTECTION .................................
*
* - HLQ..SZWEAUTH is an APF authorized data set. It is strongly
*   advised to protect it against updates.
*
*  HLQ stub
SET RULE
*  general data set protection
LIST PUBLIC.ZOWE.V3
RECKEY PUBLIC.ZOWE.V3 ADD(- UID(-) READ(A) EXEC(P))
RECKEY PUBLIC.ZOWE.V3 +
ADD(- UID(ZWEADMIN) READ(A) EXEC(A) ALLOC(A) WRITE(A))
*
*  show results
LIST PUBLIC.ZOWE.V3
*

*
* DEFINE ZOWE RESOURCE PROTECTION .................................
*
* - Defines new resource class for Zowe that protects access to
*   sensitive Zowe resources.
* - Defines resource APIML.SERVICES that controls access to
*   detailed information about API services to Zowe users.

* define ZOWE resource type and class mapping
* skip this section if the ZOWE resource class already exists
SET CONTROL(GSO)
INSERT CLASMAP.ZOWE RESOURCE(ZOWE) RSRCTYPE(ZWE)
F ACF2,REFRESH(CLASMAP),TYPE(GSO)
CHANGE INFODIR TYPES(R-RZWE)
F ACF2,REFRESH(INFODIR)
SET CONTROL(GSO)

* uncomment and replace "user" to permit Zowe users to access
* the resource:
SET RESOURCE(ZWE)
RECKEY APIML ADD(SERVICES -
UID(PROD001) SERVICE(READ) ALLOW)
F ACF2,REBUILD(ZWE)

SET RESOURCE(ZWE)
RECKEY APIML ADD(SERVICES -
UID(PROD002) SERVICE(READ) ALLOW)
F ACF2,REBUILD(ZWE)


* show results
SET RESOURCE(ZWE)
LIST LIKE(-)
$$
//*