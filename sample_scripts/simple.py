zfsName = "SYSZWE.ZOWE.V350.ZFS"
dir = "software/zowe/v3.5.0"

import subprocess
def exec(command):
    result = subprocess.run(command,
        shell=True, text=True, capture_output=True)
    return result.stdout, result.stderr, result.returncode 

sto, ste, rc = exec(f"zowe files create zos-file-system {zfsName} --cyls-pri 5 --cyls-sec 1 --group ZWEADMIN --owner ZWESVUSR --perms 777 --timeout 300 --response-timeout 300")
sto, ste, rc = exec(f"zowe zos-files create uss-directory ${dir} --mode rwxr-xr-x")
sto, ste, rc = exec(f"zowe zos-files mount file-system ${input:zfsName} ${dir} --fs-type ZFS --mode rdwr")
