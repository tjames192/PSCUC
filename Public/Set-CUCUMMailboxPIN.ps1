function Set-CUCUMMailboxPIN {
<#
.SYNOPSIS
Set Cisco Unity UM Mailbox PIN
 
.DESCRIPTION
Set Cisco Unity UM Mailbox PIN and email user of new PIN.
By default a unique generated PIN will be created automatically.
 
.EXAMPLE
Set-CUCUMMailboxPIN demo@demo.com

.EXAMPLE
Set-CUCUMMailboxPIN demo@demo.com -PIN 1234

.EXAMPLE
Set-CUCUMMailboxPIN demo@demo.com -Debug
DEBUG: [Set-CUCUMMailboxPIN] PIN: 6154

Confirm
Continue with this operation?
[Y] Yes  [A] Yes to All  [H] Halt Command  [S] Suspend  [?] Help (default is "Y"):

DEBUG: [Get-CUCConnectionLocation]

Confirm
Continue with this operation?
[Y] Yes  [A] Yes to All  [H] Halt Command  [S] Suspend  [?] Help (default is "Y"):

#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true, ValueFromPipeline=$True)]
		[string[]]$alias,
		
		[Parameter(Mandatory = $false, ValueFromPipeline=$True)]
		[int]$PIN,
		
		[Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
		$session = $DefaultCUCSession
	)
		
	Process {
		Write-Verbose -Message "[$($MyInvocation.MyCommand)] Processing alias: $($alias)"

		$URI = "https://$($session['server'])/vmrest/users?query=(alias is $($alias))"

		$user = Invoke-RestMethod -Headers $session['headers'] -Uri $URI

		$URI = "https://$($session['server'])/$($user.user.uri)"

		$user = Invoke-RestMethod -Headers $session['headers'] -Uri $URI

		Write-Verbose -Message "[$($MyInvocation.MyCommand)] DisplayName: $($user.displayname)"
		Write-Verbose -Message "[$($MyInvocation.MyCommand)] ObjectId: $($user.objectid)"

		# Take care not to run into "Repeat credentials prohibited by credential policy"
		# Sytem Settings > Authentication Rules
		$json = [ordered]@{
			CredMustChange = $false
			Credentials = get-random -Minimum 1000 -Maximum 9999
		}
		
		if($PIN) {
			$json.Credentials = $PIN
		}

		$body = $json | ConvertTo-Json

		$URI = "https://$($session['server'])/$($user.UserVoicePinURI)"

		# PUT https://<Connection-server>/vmrest/users/<user-objectid>/credential/pin
		Write-Verbose -Message "[$($MyInvocation.MyCommand)] URI: $URI"
		Write-Debug -Message "[$($MyInvocation.MyCommand)] PIN: $($json.Credentials)"

		$irmSplat = @{
			Headers     = $session['headers']
			Uri         = $URI
			method      = 'put'
			Body        = $body
			ContentType = 'application/json'
		}

		invoke-restmethod @irmSplat
		
		$sendSplat = @{
			PIN				= $json.Credentials
			EmailAddress	= $user.EmailAddress
			PhoneNumber		= $user.PhoneNumber
		}
		
		Send-CUCMailMessageUMMailboxPIN @sendSplat
	}
}