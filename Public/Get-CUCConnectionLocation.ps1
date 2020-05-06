function Get-CUCConnectionLocation {
<#
.SYNOPSIS
Get Cisco Unity ConnectionLocation
 
.DESCRIPTION
Get Cisco Unity ConnectionLocation
 
.EXAMPLE
Get-CUCConnectionLocation

DisplayName SystemVersion HostAddress    SmtpDomain       SmtpSmartHost                        IsPrimary Status
----------- ------------- -----------    ----------       -------------                        --------- ------
cuc01     12.0.1.60     192.168.50.130 cuc01.contoso.com contoso-com.mail.protection.outlook.com true      0

#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )

    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCConnectionLocation'
    }
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/locations/connectionlocations"
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).ConnectionLocation
    }
    
    End { return Format-Result -results $objects -TypeName $TypeName }
}