function Get-CUCScheduleSets {
<#
.SYNOPSIS
Get Cisco Unity ScheduleSets
 
.DESCRIPTION
Get Cisco Unity ScheduleSets

.EXAMPLE
Get-CUCScheduleSets

DisplayName                       Undeletable
-----------                       -----------
Weekdays                          true
All Hours                         true
Voice Recognition Update Schedule false

#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCScheduleSet'
    }
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/schedulesets"
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).ScheduleSet
    }
	
    End { return Format-Result -results $objects -TypeName $TypeName }
}