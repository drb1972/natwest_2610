//ZWEIKRA2 JOB ACCT#,ZWEIKRA2,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//*********************************************************************
//*
//* EXECUTE COMMANDS FOR SELECTED SECURITY PRODUCT
//*
//RUNACF2  EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=ACF2
//ACF2     DD DATA,DLM=$$,SYMBOLS=JCLONLY
ACF
//
* Create the keyring .............................................. */
  SET PROFILE(USER) DIVISION(KEYRING)
  INSERT ZWESVUSR.ZOWERING +
  RINGNAME(ZoweKeyring)
  F ACF2,REBUILD(USR),CLASS(P),DIVISION(KEYRING)
$$
//*
//RUNOPT2  EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=ACF2
//ACF2     DD DATA,DLM=$$,SYMBOLS=JCLONLY
ACF
//
* Option 2 - BEGINNING ............................................ */
* Connect a Zowe's certificate with the keyring ................... */
   SET PROFILE(USER) DIVISION(CERTDATA)
   CONNECT CERTDATA(SITECERT.ROOTSTAR) -
   KEYRING(ZWESVUSR.ZOWERING) -
   USAGE(PERSONAL) DEFAULT
   CHKCERT ZWESVUSR.ZOWECERT
*
* Option 2 - END .................................................. */
$$
//*
//RUNZWCA  EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=ACF2
//ACF2     DD DATA,DLM=$$,SYMBOLS=JCLONLY
ACF
//
* Connect all CAs of the Zowe certificate's signing chain with the  */
* keyring ......................................................... */
   SET PROFILE(USER) DIVISION(CERTDATA)
   CONNECT CERTAUTH LABEL('DigiCert Global Root CA') -
   RINGNAME(ZoweKeyring) -
   KEYRING(ZWESVUSR.ZOWERING) USAGE(CERTAUTH)
*
   CONNECT CERTAUTH LABEL('DigiCert CA') -
   RINGNAME(ZoweKeyring) -
   KEYRING(ZWESVUSR.ZOWERING) USAGE(CERTAUTH)
$$
//IFZFCAED ENDIF
//*
//COMACF2  EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DDNAME=ACF2
//ACF2     DD DATA,DLM=$$,SYMBOLS=JCLONLY
ACF
//
* A common part for all options - BEGINNING ....................... */
*
* Allow ZOWEUSER to access keyring ................................ */
  SET RESOURCE(FAC)
  RECKEY IRR ADD(DIGTCERT.LISTRING -
  ROLE(ZWEADMIN) -
  SERVICE(READ) ALLOW)
*
* Uncomment this command if SITE acid owns the Zowe certificate ... */
*  RECKEY IRR ADD(DIGTCERT.GENCERT -
*  ROLE(ZWEADMIN) -
*  SERVICE(CONTROL) ALLOW)
*
  F ACF2,REBUILD(FAC)
*
* List the keyring ................................................ */
  SET PROFILE(USER) DIVISION(KEYRING)
  LIST ZWESVUSR.ZOWERING
* Common part - END ............................................... */
$$
//*
