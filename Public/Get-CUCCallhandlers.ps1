function Get-CUCCallhandlers {
<#
.SYNOPSIS
Get Cisco Unity Callhandlers
 
.DESCRIPTION
Get Cisco Unity Callhandlers

.EXAMPLE
Get-CUCCallhandlers

DisplayName                  MaxMsgLen DtmfAccessId
-----------                  --------- ------------
Opening Greeting             300
Operator                     300       0
Goodbye                      300
undeliverablemessagesmailbox 300
operator                     300
MFA AA Main                  300       1015
LA Operator                  300       7890
NY Operator                  300       5801
demo@contoso.com             300
SF AA Main                   300       6650
NY AA Main                   300       6969
LA SR AA Main                300       7800
LA AA Main                   300       2181
SF Operator                  300       6921

#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCCallhandlers'
    }
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/handlers/callhandlers"
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).Callhandler
    }
	
    End { return Format-Result -results $objects -TypeName $TypeName }
}