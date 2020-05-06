function Get-CUCLicenseStatus {
<#
.SYNOPSIS
Get Cisco Unity LicenseStatusCount
 
.DESCRIPTION
Get Cisco Unity LicenseStatusCount
 
.EXAMPLE
Get-CUCLicenseStatus

Description                              Count
-----------                              -----
Total Number of Voicemail users          286
Total Number of Enhanced Messaging Users 0
Speechview Standard users                0
Speechview Professional Users            0
Total Number of speech connect sessions  16

#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCLicenseStatus'
    }
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/licensestatuscounts"
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).LicenseStatusCount
    }
	
    End { return Format-Result -results $objects -TypeName $TypeName }
}