# Vsphere Template uploader and downloader (Version 15.0.2)
---

## Required software:
* .NET Framework 4.5
* PowerShell 3.0
* PowerCLI 6.5

# Template Uploader.ps1:
---
## Uses:
_Used for uploading templates from a local machine to a Vsphere server_

## Before running the script a few variable changes need to be made:
* You need a local path to VM folders.
* You need a Resource Pool for VMs to go to.
* You need a VM folder for VMs to go to.
* You need the IP, Username, and Password for Vsphere server.

#### NOTE: 
If you are not connected to a Vsphere server you may need to uncomment the Server login (‘Connect-VIServer $IP -User $Username -Password $Password’) line in the script (Commented out by default) in order to upload templates.

#### NOTE 2 ELECTRIC BOOGALOO: 
If you wish to map the uploaded VMs to a network you will need to uncomment the Network line (‘$ovfconfig.NetworkMapping.bridged.Value = ""’) and in the double quotes you must specify a network on the server. You will also need to add “-OvfConfiguration $ovfconfig” line to the Import VApp parameters.

#### NOTE 3: 
Vcloud (old) templates must be named “descriptor.ovf” and Vsphere (new) templates must be named “template.ovf” (When using the Template Downloader, these templates are automatically named “template.ovf”).

## To Run:
* Open PowerCLI and wait for it to load.
* Make sure the working directory is where the script is located.
* Run the script (.\”Template Uploader.ps1”)


## Variables:

### Variables that need custom input:
* $TemplatePATH: The local path to where the VM templates folders are.
* $RPool: Resource Pool that the VM will be moved into once it’s imported.
* $VMFolder: The VM Folder the VM will be moved into once it’s imported.
* $Username: Username for Vsphere server.
* $Password: Password for Vsphere server.
* $IP: IP for Vsphere server.

### Variables that should not be changed:
* $VMLocArray: The Script gets all clusters in the Vshpere server.
* $VMHostArray: The Script gets all hosts in the Vsphere server to allocate VMs evenly.
* $HostCount is going to be one less than the number of host in the Vsphere server and be used to allocate VMs to host equally.
* $Name:
  * For Vcloud templates, this is used as the name of the VApp shell that is imported automatically and once the VM is moved, the VApp is deleted.
  * For Vsphere templates, this will be automatically changed to the name of the folder it’s in and will be the name of the VM (VApps are not imported with new Vsphere templates).
* $Format: Provisioning format for VMs (Default thick, is set to Thin; don’t change unless you know what you’re doing).
* $GoFlag: Used to determine if it is uploading Vcloud templates or Vsphere template.


# Template Downloader.ps1:
---
## Uses:
_Used for downloading templates from a Vsphere server to a local machine_

## Before running the script a few variable changes need to be made:
* You need a local path to where you want your VM templates and VM folders to go.
* You need to either specify a single VM template to download or a whole VM folder in a Vsphere server.
* You need the IP, Username, and Password for Vsphere server.

#### NOTE: 
If you are not connected to a Vsphere server you may need to uncomment the Server login (‘Connect-VIServer $IP -User $Username -Password $Password’) line in the script (Commented out by default) in order to upload templates.

## To Run:
* Open PowerCLI and wait for it to load.
* Make sure the working directory is where the script is located.
* Run the script (.\”Template Downloader.ps1”)

## Variables:
* $VMDestination: This is the destination where you want your VM templates to be stored
* $VM: Name of VM in Vsphere if you want a singular VM template downloaded.
* $VMFolder: Name of folder in Vsphere if you want a whole folder downloaded.
* $Username: Username for Vsphere server.
* $Password: Password for Vsphere server.
* $IP: IP for Vshpere server.
* $RunFlag: Used to determine either single template download or a whole folder.
