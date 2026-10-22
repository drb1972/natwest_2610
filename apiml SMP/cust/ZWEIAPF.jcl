//ZWEIAPF JOB ACCT#,ZWEIAPF,MSGLEVEL=(1,1),MSGCLASS=X,CLASS=A
//*
//         EXPORT SYMLIST=*
//         SET LOADLIB=&HLQ..&PRDID..&VER..SZWEAUTH
//         SET LOADLOC='SMS'                                          
//         SET PLUGLIB=&HLQ..&PRDID..&VER..ZWESAPL
//         SET PLUGLOC='SMS' 
//APFAUTH EXEC PGM=BPXBATCH                               
//BPXPRINT DD SYSOUT=*                                    
//STDOUT   DD SYSOUT=*                                    
//STDERR   DD SYSOUT=*                                    
//STDPARM DD *,SYMBOLS=EXECSYS                                            
SH cd &ZOWEPATH &&                        
cd bin/utils &&                                           
export LOADLIB='&LOADLIB' &&      
export LOADLOC=SMS &&                                     
export PLUGLIB='&PLUGLIB' &&    
export PLUGLOC=SMS &&                                     
./opercmd.rex "SETPROG APF,ADD,DSN=$LOADLIB,$LOADLOC" &&  
./opercmd.rex "SETPROG APF,ADD,DSN=$PLUGLIB,$PLUGLOC"     
//* 