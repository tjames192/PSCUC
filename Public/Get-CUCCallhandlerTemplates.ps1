function Get-CUCCallhandlerTemplates {
<#
.SYNOPSIS
Get Cisco Unity CallhandlerTemplate
 
.DESCRIPTION
Get Cisco Unity CallhandlerTemplate
 
.EXAMPLE
Get-CUCCallhandlerTemplates

DisplayName                  MaxMsgLen IsTemplate
-----------                  --------- ----------
System Call Handler Template 300       true

#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCCallhandlerTemplate'
    }
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/callhandlertemplates"
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).CallhandlerTemplate
    }
	
    End { return Format-Result -results $objects -TypeName $TypeName }
}