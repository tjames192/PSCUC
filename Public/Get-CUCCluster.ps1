function Get-CUCCluster {
<#
.SYNOPSIS
Get Cisco Unity Cluster
 
.DESCRIPTION
Get Cisco Unity Cluster

.EXAMPLE
Get-CUCCluster


Key                 : 28f8872f-d0ad-4a82-95e2-9890032900c5
DatabaseReplication : 0
HostName            : cuc01.contoso.com
Ipv6Name            :
MacAddress          :
Description         :

Key                 : 23af1f57-5426-cd2c-f4ca-ac0e63b76de3
DatabaseReplication : 1
HostName            : cuc02.contoso.com
Ipv6Name            :
MacAddress          :
Description         :

#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCServer'
    }
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/cluster"
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).Server
    }
	
    End { return Format-Result -results $objects -TypeName $TypeName }
}