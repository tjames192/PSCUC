function Remove-CUCCallhandler {
<#
.SYNOPSIS
Remove Cisco Unity Callhandler
 
.DESCRIPTION
Remove Cisco Unity Callhandler
 
.EXAMPLE
Remove-CUCCallhandler "AA-1"

#>
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline, HelpMessage = 'DisplayName')]
		[string]$DisplayName,
		
		[Parameter(Mandatory = $false,HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
	)
		
	Process {
		Write-Debug -Message "[$($MyInvocation.MyCommand)]"
		
		$URI = "https://$($session['server'])/vmrest/handlers/callhandlers?query=(displayname is $($DisplayName))"
		
		$Callhandler = Invoke-RestMethod -Headers $session['headers'] -Uri $URI
		
		$URI = "https://$($session['server'])/$($Callhandler.Callhandler.URI)"
		
		Write-Verbose -Message "[$($MyInvocation.MyCommand)] DisplayName: $($Callhandler.Callhandler.DisplayName)"
		Write-Verbose -Message "[$($MyInvocation.MyCommand)] ObjectId: $($Callhandler.Callhandler.ObjectId)"
		
		$irmSplat = @{
			Headers     = $session['headers']
			Uri         = $URI
			method      = 'delete'
			Body        = $body
			ContentType = 'application/json'
		}

		invoke-restmethod @irmSplat
	}
}