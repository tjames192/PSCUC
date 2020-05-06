function Get-CUCUserTemplates {
<#
.SYNOPSIS
Get Cisco Unity UserTemplate
 
.DESCRIPTION
Get Cisco Unity UserTemplate
 
.EXAMPLE
Get-CUCUserTemplates

DisplayName                   : Voice Mail User Template
Alias                         : voicemailusertemplate
GreetByName                   : true
ListInDirectory               : true
CreateSmtpProxyFromCorp       : true
RecordUnknownCallerName       : true
RepeatMenu                    : 1
ConfirmDeleteMultipleMessages : true
RouteNDRToSender              : true
UseVui                        : true
JumpToMessagesOnLogin         : true
LdapType                      : 0

.EXAMPLE
Get-CUCUserTemplates | select *


#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCUserTemplate'
    }
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/usertemplates"
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).UserTemplate
    }

    End { return Format-Result -results $objects -TypeName $TypeName }
}