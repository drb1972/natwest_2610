//ZWEIKRR2 JOB ACCT#,ZWEIKRR2,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//*********************************************************************
//*
//* EXECUTE COMMANDS FOR SELECTED SECURITY PRODUCT
//*
//RUNRACF  EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=RACF
//*
//*********************************************************************
//*
//* RACF ONLY, customize to meet your system requirements
//*
//RACF     DD DATA,DLM=$$,SYMBOLS=JCLONLY

/* Create the keyring .............................................. */
   RACDCERT ADDRING(ZoweKeyring) +
            ID(ZWESVUSR)
   SETROPTS RACLIST(DIGTRING) REFRESH
$$
//*
//RUNOPT2  EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=RACF
//RACF     DD DATA,DLM=$$,SYMBOLS=JCLONLY

/* Connect a Zowe's certificate with the keyring ................... */
   RACDCERT CONNECT(SITE +
            LABEL('ROOTSTAR') +
            RING(ZoweKeyring) +
            USAGE(PERSONAL) DEFAULT) +
            ID(ZWESVUSR)

   SETROPTS RACLIST(DIGTCERT,DIGTRING) REFRESH

$$
//RUNZWCA  EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=RACF
//RACF     DD DATA,DLM=$$,SYMBOLS=JCLONLY

/* Connect all CAs of the Zowe certificate's signing chain with the  */
/* keyring ......................................................... */
   RACDCERT CONNECT(CERTAUTH +
            LABEL('DigiCert Global Root CA') +
            RING(ZoweKeyring) +
            USAGE(CERTAUTH)) +
            ID(ZWESVUSR)

   RACDCERT CONNECT(CERTAUTH +
            LABEL('DigiCert CA') +
            RING(ZoweKeyring) +
            USAGE(CERTAUTH)) +
            ID(ZWESVUSR)

   SETROPTS RACLIST(DIGTCERT,DIGTRING) REFRESH
$$
//*
//COMRACF  EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=RACF
//RACF     DD DATA,DLM=$$,SYMBOLS=JCLONLY

/* A common part for all options - BEGINNING ....................... */

/* Allow ZOWEUSER to access keyring ................................ */

/* Activate RDATALIB class holding profiles that control ........... */
/* certificate access  ............................................. */
   SETROPTS CLASSACT(RDATALIB) RACLIST(RDATALIB)

/* Define profiles that control certificate access ................. */
   RDEFINE RDATALIB +
   ZWESVUSR.ZoweKeyring.LST +
   UACC(NONE)

/* Permit server user ID to access key ring and related ............ */
/* private keys. ................................................... */
   PERMIT +
   ZWESVUSR.ZoweKeyring.LST +
   CLASS(RDATALIB) ID(ZWESVUSR) +
   ACCESS(CONTROL)

/* Uncomment this command to allow other user to access key ring ... */
/* PERMIT ZWESVUSR.ZoweKeyring.LST +                              */
/*   CLASS(RDATALIB) ID(<user>) +                                    */
/*        ACCESS(READ)                                               */

/* Refresh to dynamically activate the changes. .................... */
   SETROPTS RACLIST(RDATALIB) REFRESH

/* IRR.DIGTCERT logic pre-dates RDATALIB logic, and is not used when */
/* the RDATALIB profile is used. The following PERMIT commands are . */
/* present for customers who do not wish to use RDATALIB and want to */
/* continue using their existing IRR.DIGTCERT setup. Note that the . */
/* PERMIT commands will fail if the IRR.DIGTCERT profiles do not ... */
/* already exist. .................................................. */
   PERMIT IRR.DIGTCERT.LISTRING CLASS(FACILITY) +
          ID(ZWESVUSR) +
          ACCESS(READ)
   PERMIT IRR.DIGTCERT.LIST CLASS(FACILITY) +
          ID(ZWESVUSR) +
          ACCESS(READ)

/* Uncomment this command if SITE user owns the Zowe certificate ... */
/*  PERMIT IRR.DIGTCERT.GENCERT CLASS(FACILITY)                      */
/*         ID(ZWESVUSR) +                                           */
/*         ACCESS(CONTROL)                                           */

   SETROPTS RACLIST(FACILITY) REFRESH

/* show results .................................................... */
   RLIST  RDATALIB +
   ZWESVUSR.ZoweKeyring.LST ALL
   RLIST  FACILITY IRR.DIGTCERT.LISTRING ALL
   RLIST  FACILITY IRR.DIGTCERT.LIST ALL
   RLIST  FACILITY IRR.DIGTCERT.GENCERT ALL

/* List the keyring ................................................ */
   RACDCERT LISTRING(ZoweKeyring) +
   ID(ZWESVUSR)

/* Common part - END ............................................... */
/* only the last RC is returned, this command ensures it is a 0 .... */
PROFILE
$$
//*