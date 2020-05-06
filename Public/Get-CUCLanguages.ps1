function Get-CUCLanguages {
<#
.SYNOPSIS
Get Cisco Unity Language Mapping
 
.DESCRIPTION
Get Cisco Unity Language Mapping
 
.EXAMPLE
Get-CUCLanguages

LanguageCode LanguageAbbreviation LanguageTag
------------ -------------------- -----------
1025         ARA                  ar-SA
1026         BGR                  bg-BG
1027         CAT                  ca-ES
1028         CHT                  zh-TW

#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCLanguageMapping'
    }
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/languagemap"
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).LanguageMapping
    }
	
    End { return Format-Result -results $objects -TypeName $TypeName }
}