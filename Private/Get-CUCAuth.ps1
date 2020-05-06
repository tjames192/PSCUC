function Get-CUCAuth {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true,Position = 0,HelpMessage = 'Cisco Unity FQDN or IP address',ParameterSetName='p1')]
		[ValidateNotNullorEmpty()]
		$Server,
		
		[Parameter(Mandatory = $true,Position = 0,HelpMessage = 'Cisco Unity Rest URI',ParameterSetName='p2')]
		[ValidateNotNullorEmpty()]
		[String]$URI,
		
		[Parameter(Mandatory = $true,Position = 1,HelpMessage = 'Cisco Unity Encoded Password')]
		$EncodedPassword
	)

	If ($PsCmdlet.ParameterSetName -eq 'p1') {
		Write-Verbose -Message 'Build the URI'
		$URI= 'https://'+$Server+'/vmrest/vmsservers'
	}
	
	Write-Verbose "URI: $URI"
	
	$header = @{
		Authorization = "BASIC $($EncodedPassword)"
		Accept        = 'application/json'
	}
	
	Write-Verbose "Sending authentication request"
	
	try {
		$r = Invoke-RestMethod -Uri $URI -Headers $header -ErrorVariable apiErr -SessionVariable Session

		$Session
	}
	catch {
		Write-warning $apiErr.InnerException
	}
}