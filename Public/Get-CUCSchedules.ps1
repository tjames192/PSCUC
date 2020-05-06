function Get-CUCSchedules {
<#
.SYNOPSIS
Get Cisco Unity Schedules
 
.DESCRIPTION
Get Cisco Unity Schedules

.EXAMPLE
Get-CUCSchedules

DisplayName                       IsHoliday Undeletable
-----------                       --------- -----------
Contoso Holidays                  true      true
Weekdays                          false     true
All Hours                         false     true
Voice Recognition Update Schedule false     true
Sync Schedule                     false     false

#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCSchedule'
    }
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/schedules"
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).Schedule
    }
	
    End { return Format-Result -results $objects -TypeName $TypeName }
}