/* Open Object REXX (ooRexx) Script */

zfsName = "PROD001.NTW.DELETE"
dir = "/tmp/ntw"

"zowe files create zos-file-system " || zfsName || " --cyls-pri 5 --cyls-sec 1"
"zowe files create uss-directory " || dir || " --mode rwxr-xr-x"
"zowe files mount fs " || zfsName || " " || dir || " --fs-type ZFS --mode rdwr" 



