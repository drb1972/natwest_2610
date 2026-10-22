file_system = "SYSZWE.ZOWE.V350.ZFS"
uss_path = "software/zowe/v3.5.0"
group = ""
owner = "" 
pax_file =  "" # pax file name
yaml_file = "" # name of zowe.yaml file


import subprocess

def execute_command(command):
   try:
      # Run the command and capture its output and error
      result = subprocess.run(command, shell=True, text=True, capture_output=True)

   except subprocess.CalledProcessError as e:
      print("Command execution failed.")
      print("Return Code:", e.returncode)
      print("Error:", e.stderr)
      exit(8)

   if result.returncode!=0:
      print('rc', result.returncode)
      print('sto ', result.stdout)
      print('ste ', result.stderr)
      exit(8)

   return result.stdout

#- Create FileSystem
zowe_command = f'zowe zos-files create zos-file-system {file_system} --cyls-pri 500 --cyls-sec 50 --group {group} --owner {owner} --perms 777 --timeout 300 --response-timeout 300' 
sto = execute_command(zowe_command)

#- Create directory
zowe_command = f'zowe zos-files create uss-directory {uss_path} --mode rwxrwxrwx'
sto = execute_command(zowe_command)
        
#- Mount FileSystem
zowe_command = f'zowe zos-files mount file-system {file_system} {uss_path} --fs-type ZFS --mode rdwr'
sto = execute_command(zowe_command)

#- Upload pax file
zowe_command = f'zowe zos-files upload file-to-uss {pax_file} {uss_path}/{pax_file} --binary'
sto = execute_command(zowe_command)

#- Unpax file with zowe
zowe_command = f'zowe zos-ssh issue command "pax -ppx -rf {pax_file}" --cwd {uss_path}'
sto = execute_command(zowe_command)

#- Delete the pax file
zowe_command = f'zowe zos-files delete uss-file {uss_path}/{pax_file} --for-sure'
sto = execute_command(zowe_command)

#- Upload zowe.yaml
zowe_command = f'zowe zos-files upload file-to-uss "zowe.yaml" "{uss_path}/{yaml_file}"'
sto = execute_command(zowe_command)


# Install zowe
runtime_path = f'{uss_path}/bin'
yaml_path = f'{uss_path}/{yaml_file}'

# Install MVS datasets - Review zowe.setup.dataset.prefix section in zowe.yaml
command = f'zowe zos-ssh issue command "zwe install -v -c {yaml_path}" --cwd {runtime_path}'
sto = execute_command(zowe_command)

# Copies the data sets provided with Zowe to custom data sets
command = f'zowe zos-ssh issue command "zwe init mvs -v -c {yaml_path}" --cwd {runtime_path}'
sto = execute_command(zowe_command)

# Don't need to exec zwe init security - zowe sec aready defined

# APF auth
command = f'zowe zos-ssh issue command "zwe init apfauth -v -c {yaml_path}" --cwd {runtime_path}'
sto = execute_command(zowe_command)

# Don't need to exec zwe init certificate - zowe sec aready defined

# Create & copy STC procs
command = f'zowe zos-ssh issue command "zwe init stc -v -c {yaml_path}" --cwd {runtime_path}'
sto = execute_command(zowe_command)

