function Get-CUCUser {
<#
.SYNOPSIS
Get Cisco Unity Users
 
.DESCRIPTION
Get Cisco Unity Users
 
.EXAMPLE
Get-CUCUser

.EXAMPLE
Get-CUCUser user@contoso.com

FirstName LastName Alias           DisplayName EmailAddress    ListInDirectory DtmfAccessId PhoneNumber
--------- -------- -----           ----------- ------------    --------------- ------------ -----------
User      Last    user@contoso.com User Last  user@contoso.com true            6764         6764

#>
    [CmdletBinding()]
    Param (
        [parameter(ValueFromPipeline = $True)]
        [string[]]$alias,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )

    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCUser'
    }
		
    Process {
        if ($alias) {
            Write-Debug -Message "[$($MyInvocation.MyCommand)] Processing alias: $($alias)"
            $URI = "https://$($session['server'])/vmrest/users?query=(alias is $($alias))"
        }
        else {
            $URI = "https://$($session['server'])/vmrest/users"
        }
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).user
        
    }

    End { return Format-Result -results $objects -TypeName $TypeName }
}