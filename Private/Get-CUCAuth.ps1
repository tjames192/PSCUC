function Get-CUCAuth {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true,Position = 0,HelpMessage = 'Cisco Unity FQDN or IP address',ParameterSetName='p1')]
		[ValidateNotNullorEmpty()]
		$Server,
		
		[Parameter(Mandatory = $true,Position = 0,HelpMessage = 'Cisco Unity Rest URI',ParameterSetName='p2')]
		[ValidateNotNullorEmpty()]
		[String]$URI,
		
		[Parameter(Mandatory = $true, HelpMessage = 'Cisco Unity credentials')]
		[PSCredential]$Credentials
	)

	If ($PsCmdlet.ParameterSetName -eq 'p1') {
		Write-Verbose -Message 'Build the URI'
		$URI= 'https://'+$Server+'/vmrest/vmsservers'
	}

	Write-Verbose "URI: $URI"

	$EncodedAuthorization = [System.Text.Encoding]::UTF8.GetBytes($Credentials.UserName + ':' + $Credentials.GetNetworkCredential().Password)
	$EncodedPassword = [System.Convert]::ToBase64String($EncodedAuthorization)

	$header = @{
		Authorization = "BASIC $($EncodedPassword)"
		Accept        = 'application/json'
	}

	Write-Verbose "Sending authentication request"

	try {
		$null = Invoke-RestMethod -Uri $URI -Headers $header -ErrorVariable apiErr -SessionVariable Session

		$Session
	}
	catch {
		Write-warning $apiErr.InnerException
	}
}
