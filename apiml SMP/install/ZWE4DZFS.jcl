//ZWE4DZFS JOB ACCT#,ZWE4DZFS,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//         EXPORT SYMLIST=(HLQ,PRDID,VER)
//         SET HLQ=&HLQ
//         SET PRDID=&PRDID
//         SET VER=&VER
//*
//**********************************************************************
//* Unmount zFS
//**********************************************************************
//UNMNTZFS EXEC PGM=BPXBATCH
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//STDPARM  DD *,SYMBOLS=EXECSYS
sh
su;
  /usr/sbin/unmount -f &HLQ..&PRDID..&VER..ZFSAPIML -o immediate ;
  /usr/sbin/unmount -f &HLQ..&PRDID..&VER..ZFSAPIML -o force ;
exit 0;
//DELETEDS EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *,SYMBOLS=JCLONLY
  DELETE &HLQ..&PRDID..&VER..ZFSAPIML
  SET MAXCC = 0
/*
//
