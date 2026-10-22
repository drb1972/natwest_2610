# APIML SMP/E Installation Workflow - On Construction

## Overview

The `apiml_smpe_install` workflow automates the complete installation of API Mediation Layer (APIML) via SMP/E on z/OS. It orchestrates the full lifecycle: PAX file retrieval and extraction, SMP/E base installation, GA maintenance application.

## Execution Order

The workflow consists of four main phases executed sequentially:

1. **Generic SMP/E Setup** (`generic_smpe`) — Mounts the PAX file system, downloads the PAX file from Artifactory, uploads it to z/OS USS, and extracts it.
2. **Base Installation** (`apiml_smpe_install_base`) — Creates the SMP/E environment and performs RECEIVE, APPLY, and ACCEPT of the base product FMID.
3. **GA Maintenance** (`apiml_smpe_ga_maintenance`) — Receives the latest GA maintenance SYSMODs via SMP/E RECEIVE ORDER, then APPLYs and ACCEPTs them.


## Input Parameters

## zENV Info

| Dataset | Value | Comment |
|---|---|---|
| TZONE   | `TZONE` | Hardcoded in JCLs |
| DZONE   | `DTZONE` | Hardcoded in JCLs |
| PROCLIB | `PRODUCT.PROCLIB` | Hardcoded in JCLs |
| PARMLIB | `PRODUCT.PARMLIB` | Hardcoded in JCLs |

## JCL Reference

### Install Phase (`install/`)

These JCLs are executed by the `apiml_smpe_install_base` sub-workflow to build the SMP/E environment and install the base product.

| JCL | Description |
|---|---|
| `ZWE0EXT.jcl` | Runs GIMUNZIP to extract dataset content from the SMP/E PAX file. |
| `ZWE1SMPE.jcl` | Allocates the CSI, SMP/E data sets, and defines the initial DDDEFs. |
| `ZWE2RCVE.jcl` | SMP/E RECEIVE of the product FMID into the CSI. |
| `ZWE3ALOC.jcl` | Allocates SMP/E target and distribution libraries. |
| `ZWE4DZFS.jcl` | Unmounts and deletes an existing APIML z/OS file system (pre-clean before recreation). |
| `ZWE4ZFS.jcl` | Creates and mounts the z/OS UNIX file system for the product. |
| `ZWE5MKD.jcl` | Creates required z/OS UNIX directories under the product mount point. |
| `ZWE6DDEF.jcl` | Creates DDDEF entries in the SMP/E CSI for target and distribution zones. |
| `ZWE7APLY.jcl` | SMP/E APPLY of the base product FMID. |
| `ZWE8ACPT.jcl` | SMP/E ACCEPT of the base product FMID. |

### Maintenance Phase (`maint/`)

#### MaintenanceContent on RCVORDER.jcl - 
APIML PTFs shipped as cummulative or whole product ptfs, hence no need to RECIEVE all of them, we should always fetch the required PTFS, preferably the latest PTF. Latest maintenance could be found on https://www.zowe.org/download . Then pick the PTF numbers ex: "maintenanceContent": "PTFS(UO03573,UO03574)" for 3.4.1 as example.

These JCLs are executed by the `apiml_smpe_ga_maintenance` sub-workflow to apply the latest GA maintenance.

| JCL | Description |
|---|---|
| `RCVORDER.jcl` | SMP/E RECEIVE ORDER to receive the latest GA maintenance SYSMODs from the order stream. |
| `ZWE80APM.jcl` | Verifies that the SMP/E APPLY would succeed by running in CHECK mode. |
| `ZWE85APM.jcl` | SMP/E APPLY of the GA maintenance to the installed APIML. |
| `ZWE90ACM.jcl` | Verifies that the SMP/E ACCEPT would succeed by running in CHECK mode. |
| `ZWE95ACM.jcl` | SMP/E ACCEPT of the GA maintenance to the installed APIML. |

### Customization Phase (`cust/`)

These JCLs are executed by the `apiml_custom` sub-workflow to configure the installed product. Security JCLs (ZWEIRAC / ZWEITSS / ZWEIACF) are executed conditionally based on the security manager detected by `REXXESM.jcl`.

| JCL | Description |
|---|---|
| `ZWEIMVS.jcl` | Creates the MVS datasets required by a Zowe instance. |
| `ZWEIAPF.jcl` | APF authorizes the Zowe product load libraries. |
| `REXXESM.jcl` | REXX exec that detects the active external security manager (CC 0001 = RACF, CC 0002 = TSS, CC 0003 = ACF2). |
| `ZWEIRAC.jcl` | Defines RACF profiles and permits for Zowe (executed when RACF is detected). |
| `ZWEITSS.jcl` | Defines TSS security profiles and permits for Zowe (executed when TSS is detected). |
| `ZWEIACF.jcl` | Defines ACF2 security rules and permits for Zowe (executed when ACF2 is detected). |
| `ZWEYAML.jcl` | Generates and copies the `zowe.yaml` instance configuration file to the USS home directory. |
| `ZWEISTC.jcl` | Copies the Zowe started task JCL members (ZWESLSTC, ZWESISTC, ZWESASTC) into the target PROCLIB. |

## Sample Input

| key added | Value | Description |
|---|---|---|
| `ssh_port` | 22 | Used when issuing ssh commands in USS. |
| `fmid` | AZWE003 | No hardcoded FMID in JCLs. |
| `node_nome` | /usr/lpp/IBM/cnj/IBM/node-latest-os390-s390x/bin | System Default. Used in zowe.yaml |

```json
{
  "sshInfo": {
    "dir": "",
    "env": {},
    "hostname": "",
    "user": "root",
    "password": "",
    "sshkey": "/root/.ssh/id_rsa",
    "offHostHomeDir": "/root/dev4z-pipeline"
  },
  "productInfo": {
    "paxZfsDsn": "PUBLIC.PAX.ZFS",
    "paxZfsCylSizePrimary": "2000",
    "paxZfsCylSizeSecondary": "700",
    "paxFilename": "AZWE003.pax.Z",
    "hlq": "PUBLIC",
    "id": "ZOWE",
    "fmid": "AZWE003",
    "version": "V3",
    "artifactoryUrl": "https://artifactory-lvn.broadcom.net/artifactory/msd-common-docker/dev4z/dev/msd-devops-products/ZOWE/AZWE003.pax.Z",
    "smpePaxDir": "/opt/platform",
    "installConfigAssets": "/root/dev4z-pipeline/staging/apiml",
    "maintenanceContent": "PTFS(UO03573,UO03574)",
    "preGa": "NO",
    "acceptPriorMaintenance": "NO",
    "acceptMaintenance": "NO"
  },
  "zenvInfo": {
    "password": "",
    "port": "zosmfPort",
    "host": "zosLPARName",
    "user": "",
    "javaHome": "/usr/lpp/java/current",
    "ussHomeDir": "/u/users/group/product",
    "nodeHome": "/usr/lpp/IBM/cnj/IBM/node-latest-os390-s390x/bin"
  },
  "zowe_cli": {
    "container": "zowe-cli-v3",
    "runAsContainer": "NO",
    "useCertificates": "YES",
    "zoweDir": "/root/.zowe"
  },
  "artifactory": {
    "user": "dev4zbot",
    "password": ""
  }
}
```
