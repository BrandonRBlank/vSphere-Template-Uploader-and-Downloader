# CHANGE TO YOUR NEEDS ---------------------------------
$TemplatePATH = ""     # Local path to VM templates
$VMFolder = ""         # Folder to upload VMs to
$Format = "Thin"       # Template provisioning type
$Username = ""         # vSphere username
$Password = ""         # vSphere user password
$IP = ""               # vSphere server IP
# ------------------------------------------------------

$VMHostArray = @() # Leave empty
$VMLocArray = @() # Leave empty
$HostCount = 0
$GoFlag = 0

# Server Login
Connect-VIServer $IP -User $Username -Password $Password

# Specify a network to map to (Commented out by default)
# You'll need to add "-OvfConfiguration $ovfconfig" to Import -vApp perameters
#$ovfconfig.NetworkMapping.bridged.Value = ""

# Gets all VM Host servers and adds them to an array
ForEach($VM in Get-VMHost){
    if ($VM.Name -like "crdevesx*") {
        $VMHostArray += $VM.Name
    }
}
$NumVMHosts = $VMHostArray.count
$HostMAX = $NumVMHosts - 1

# Gets all Clusters and add thems to an array
$LocGet = Get-Cluster
ForEach($Loc in $LocGet){
    $VMLocArray += $Loc.Name
}

$VMfolder = Get-Inventory -Name $VMFolder

# For VSphere
Get-ChildItem $TemplatePATH -Recurse | 
    ForEach-Object {
        if ($_.Name -match ".mf") {
            $VMName = $_.Name.TrimEnd(".mf")
            $VMTemplate = $_.FullName.TrimEnd($_.Name) + "template.ovf"
            $GoFlag = 1
        }

        $VMHost = $VMHostArray[$HostCount]
        if ($HostCount -eq $HostMAX) {
            $HostCount = 0
        }
        else {
            $HostCount++
        }

        # Imports Template
        if ($GoFlag -eq 1) {
            Import-VApp -Source $VMTemplate -VMHost $VMHost -Name $VMName -Force -DiskStorageFormat $Format

            $VMList = Get-VM -Name $VMName

            # Moves VM to designated folder (Host/Cluster and VM Folder)
            Move-VM -VM $VMList.Name -InventoryLocation $VMFolder

        }
        $GoFlag = 0
}
