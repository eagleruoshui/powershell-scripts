## Variables
$vcenter = $args[0]
$cluster = $args[1]

## Gather RPools
Connect-VIServer $vcenter
[array]$rpools = Get-ResourcePool -Location (Get-Cluster $cluster)
cls

## Enumerate Members of RPools
Foreach ($rpool in $rpools)
	{
	If ($rpool.name -ne "Resources")
		{
		[int]$pervmshares = Read-Host "How many shares per VM in the $($rpool.Name) resource pool?"
		$totalvms = $rpool.ExtensionData.Vm.count
		[int]$rpshares = $pervmshares * $totalvms
		Write-Host -ForegroundColor Green -BackgroundColor Black $rpool.name
		Write-Host "Found $totalvms in the $($rpool.name) resource pool. At $pervmshares each, this pool should be set to $rpshares shares."
		Set-ResourcePool -ResourcePool $rpool.Name -CpuSharesLevel:Custom -NumCpuShares $rpshares -MemSharesLevel:Custom -NumMemShares $rpshares -Confirm:$true | Out-Null
		}
	}