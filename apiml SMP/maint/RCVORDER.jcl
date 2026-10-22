//RCVORDER JOB ACCT#,RCVORDER,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
/*JOBPARM S=*
//*--------------------------------------------------------------------
//*
//* JCL UPDATES REQUIRED:
//* ---------------------
//* 1. Update JOBPARM. the job much run on LPAR that has your USS dir.
//* 2. Change PMFKEY to your USERID.
//* 3. Change YOURCSI to your product CSI.
//* 4. Change YOURSMPNTS to your USS path example /a/damda01/smppts.
//* 5. Change ACCTNBR to your job account number.
//*
//* ---------------------------------
//* ** NEW 02FEB2024 **
//* Turn on Validate Package Signing
//* ---------------------------------
//* To validate packge signing, you will need to add the following
//* in the <CLIENT> XML.
//*
//*   signaturekeyring="*AUTH*/*
//*
//*
//* SMP/E Receive Order
//* --------------------
//* The JCL will submit an SMP/E Receive Order within our QA
//* environment. The receive order command generates a bitmap of the
//* FMID/PTFS within your TZONE and receives all PTFS that have been
//* published and not in your TZONE.
//*
//* WAIT(120) means wait for the order to be ready and time out after
//* 120 minutes.  If that happens you can then do a second receive
//* order and specify the order number
//*
//* If the order does time out, get the order number from the output of
//* the first receive job.  Uncomment the PENDING statement and use the
//* order number from the order that timed out.
//*
//* TRANSFERONLY brings the order to your SMPNTS.
//* You can do RECEIVE NTS later.
//*
//* ORDER TYPES:
//* ------------
//*     CONTENT(ALL)                   Get ALL missing PTFs
//*     CONTENT(HOLDDATA)              Get HOLDDATA only
//*     CONTENT(CRITICAL)              Get CRITICAL only
//*     CONTENT(RECOMMENDED)           Get Recommened Service
//*     CONTENT(PTFS(RO12345,RO23456)) Get these PTFS and REQS
//*     CONTENT(APARS(TR12345)         Get PTF that resolves APAR
//*
//* Restart failed order:
//* ---------------------
//*     PENDING(ORDnnnnn)              Restart failed Order
//*     FORTGTZONES(TZONE)             Specify a specific zone
//*
//*     TRANSFERONLY                   Does not recieve PTFs
//*
//*--------------------------------------------------------------------
//RECEIVE   EXEC PGM=GIMSMP,
//          PARM='PROCESS=WAIT',
//          REGION=0M,
//          DYNAMNBR=120
//SMPCSI    DD   DISP=SHR,DSN=&HLQ..&PRDID..&VER..CSI
//SMPNTS   DD  PATHDISP=KEEP,PATH='&ZOWEPATH'
//* Maybe is &PAXUSS instead of &ZOWEPATH??
//*
//SMPCNTL   DD   *,SYMBOLS=EXECSYS
   SET BOUNDARY(GLOBAL) .
   RECEIVE ORDER(
           CONTENT(&CONTENT)  
           WAIT(40)
           ORDERSERVER(SMPORDSR)
           CLIENT(SMPORDCL)
           )
        DELETEPKG.
//*
//SMPORDSR DD *
<ORDERSERVER
  url="https://eapi.broadcom.com/receiveorder"
  keyring="*AUTH*/*"
  inventory="all"
  certificate="RECEIVE">
 </ORDERSERVER>
//*
//SMPORDCL DD *,SYMBOLS=EXECSYS
 <CLIENT
   downloadmethod="https"
   javahome="&JAVAHOME"
   classpath="/usr/lpp/smp/classes"
   javadebugoptions="-Dcom.ibm.smp.debug=severe -showversion
                     -Djava.security.debug
                     -Djavax.net.debug"
   signaturekeyring="*AUTH*/*">
 </CLIENT>
//