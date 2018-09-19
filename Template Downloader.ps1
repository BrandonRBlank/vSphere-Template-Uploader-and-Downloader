# CONFIG TO YOUR NEEDS-------------------------------------------------
$VMDestination = ""  # Local dir to download templates to
$VMFolder = ""       # Dir in vSphere to download templates from
$RPool = ""          # Resource Pool your folder vsphere folder is in
$Username = ""       # vSphere username
$Password = ""       # vSphere user password
$IP = ""             # vSphere server IP
# ---------------------------------------------------------------------

$VM = ""
$StrayVMs = @() # Array to keep track of stray VMs in folder (Does not download)
$RunFlag = 0
$ConvertFlag = 1
 
# Server login
Connect-VIServer $IP -User $Username -Password $Password

# Convert folder of templates to VMs (keeps track of present VMs; doesn't download)
if ($ConvertFlag) {
    Get-Folder $VMFolder | Get-VM |
        ForEach-Object {
            $StrayVMs += $_.Name
        }
    Get-Folder $VMFolder | Get-Template |
        ForEach-Object {
            Set-Template -Template $_.Name -ToVM -Confirm:$false
        }
}

# Bulk Download from a specific folder (must be VMs, templates are not exportable)
if ($VMFolder) {
    Get-Folder $VMFolder | Get-VM |
        ForEach-Object {
            if ($StrayVMs -notcontains $_.Name) {
                Export-VApp -Destination $VMDestination -VM $_.Name -CreateSeparateFolder -Force
            }
        }
    $RunFlag = 1
}

# Single VM Download
if ($VM) {   
    Export-VApp -Destination $VMDestination -VM $VM -Force
    $RunFlag = 1
}

# Converts VMs back to templates
if ($ConvertFlag -eq 1) {
    Get-Folder $VMFolder | Get-VM |
        ForEach-Object {
            if ($StrayVMs -notcontains $_.Name) {
                Set-VM -VM $_.Name -ToTemplate -Confirm:$false
            }
        }
}

# Renames *.ovf to descriptor.ovf
if ($RunFlag -eq 1) {
    Get-ChildItem $VMDestination -Recurse -Filter *.ovf | 
        ForEach-Object {
            Rename-Item $_.FullName -NewName "template.ovf"
        }
}

else {
    "You need to specify a folder or single VM to export in file"
}