function Remove-CUCUser {
<#
.SYNOPSIS
Remove Cisco Unity User
 
.DESCRIPTION
Remove Cisco Unity User

.EXAMPLE
Remove-CUCUser demo@domain.com

#>
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline, HelpMessage = 'userPrincipalName')]
		[string]$alias,
		
		[Parameter(Mandatory = $false,HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
	)
		
	Process {
		Write-Verbose -Message "[$($MyInvocation.MyCommand)] Processing alias: $($alias)"

		$URI = "https://$($session['server'])/vmrest/users?query=(alias is $($alias))"

		$user = Invoke-RestMethod -Headers $session['headers'] -Uri $URI

		$URI = "https://$($session['server'])$($user.user.uri)"

		Write-Verbose -Message "[$($MyInvocation.MyCommand)] DisplayName: $($user.user.displayname)"
		Write-Verbose -Message "[$($MyInvocation.MyCommand)] ObjectId: $($user.user.objectid)"

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
