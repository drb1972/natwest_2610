//ZWEIKRT2 JOB ACCT#,ZWEIKRT2,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//*********************************************************************
//*
//* EXECUTE COMMANDS FOR SELECTED SECURITY PRODUCT
//*
//RUNTSS   EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=TSS
//TSS      DD DATA,DLM=$$,SYMBOLS=JCLONLY

/* Create the keyring .............................................. */
  TSS ADD(ZWESVUSR) KEYRING(ZOWERING) +
      LABLRING(ZoweKeyring)
$$
//*
//RUNOPT2  EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=TSS
//TSS      DD DATA,DLM=$$,SYMBOLS=JCLONLY

/* Option 2 - BEGINNING ............................................ */
/* Connect a Zowe's certificate with the keyring ................... */
   TSS ADD(ZWESVUSR) KEYRING(ZOWERING) +
       LABLRING('ROOTSTAR')
       RINGDATA(CERTSITE) +
       USAGE(PERSONAL) DEFAULT

/* Option 2 - END .................................................. */
$$
//*
//RUNZWCA  EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=TSS
//TSS      DD DATA,DLM=$$,SYMBOLS=JCLONLY

/* Connect all CAs of the Zowe certificate's signing chain with the  */
/* keyring ......................................................... */
   TSS ADD(ZWESVUSR) KEYRING(ZOWERING) +
       LABLRING(ZoweKeyring) +
       RINGDATA(CERTAUTH,'DigiCert Global Root CA') USAGE(CERTAUTH)

   TSS ADD(ZWESVUSR) KEYRING(ZOWERING) +
       LABLRING(ZoweKeyring) +
       RINGDATA(CERTAUTH,'DigiCert CA') USAGE(CERTAUTH)
$$
//*
//COMTSS   EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=TSS
//TSS      DD DATA,DLM=$$,SYMBOLS=JCLONLY

/* A common part for all options starts here ....................... */

/* Allow ZOWEUSER to access keyring ................................ */
  TSS PERMIT(ZWESVUSR) +
      IBMFAC(IRR.DIGTCERT.LISTRING) ACCESS(READ)

/* Uncomment this command if SITE acid owns the Zowe certificate ... */
/* TSS PERMIT(ZWESVUSR) +
       IBMFAC(IRR.DIGTCERT.GENCERT) ACCESS(CONTROL)

/* List the keyring ................................................ */
  TSS LIST(ZWESVUSR) KEYRING(ZOWERING) +
      LABLRING(ZoweKeyring)

/* Common part - END ............................................... */
/* only the last RC is returned, this command ensures it is a 0      */
PROFILE
$$
//*
