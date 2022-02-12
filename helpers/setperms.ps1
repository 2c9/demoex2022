param (
    [string]$vcsa='vcsacluster.ouiit.local',
    [string]$vcsa_user='Administrator@vsphere.local',
    [string]$role='DEMOEX2022'
)

Connect-VIServer -Server $vcsa -User $vcsa_user -Password $Env:TF_VAR_vsphere_password -Force | out-null

$role = Get-VIRole -Name $role

$regex = "$($Env:TF_VAR_prefix).+_$($Env:TF_VAR_index)"

$nets = Get-VirtualNetwork -NetworkType "Distributed" | Where-Object { $_.Name -match $regex }
if ($nets.length -gt 0){
    $nets | New-VIPermission -Principal "KP11\$($Env:username)" -Role $role
}

Disconnect-VIServer -Server $vcsa -Confirm:$false