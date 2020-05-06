function Get-CUCVmsServer {
<#
.SYNOPSIS
Get Cisco Unity VmsServers
 
.DESCRIPTION
Get Cisco Unity VmsServers
 
.EXAMPLE
Get-CUCVmsServer

HostName         IpAddress       ClusterMemberId ServerState ServerDisplayState
--------         ---------       --------------- ----------- ------------------
cuc01.contoso.com 192.168.50.130  0               1           3
cuc02.contoso.com 192.168.110.130 1               8           4

.EXAMPLE
Get-CUCVmsServer | select *

#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCVmsServer'
    }
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/vmsservers"
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).VmsServer
    }
	
    End { return Format-Result -results $objects -TypeName $TypeName }
}