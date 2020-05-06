function Set-CUCUMMailboxVoiceName {
<#
.SYNOPSIS
Set Cisco Unity UM Mailbox VoiceName
 
.DESCRIPTION
Set Cisco Unity UM Mailbox VoiceName for a user with specified wav file.
 
.EXAMPLE
Set-CUCUMMailboxVoiceName -alias demo@demo.com -voicenamefile '.\Demo Demo.wav'

#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true, ValueFromPipeline=$True)]
		[string[]]$alias,
        
		[Parameter(Mandatory = $false, ValueFromPipeline=$True)]
		[string[]]$voicenamefile,
		
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
        
		$file = try { get-item $voicenamefile -ErrorAction SilentlyContinue }
			catch { Write-Warning -Message "$($_)" }
    
		Write-Verbose -Message "[$($MyInvocation.MyCommand)] File: $($file)"
    
		$URI = "https://$($session['server'])/$($user.VoiceNameURI)"
		
    
		Write-Verbose -Message "[$($MyInvocation.MyCommand)] URI: $($URI)"
    
		$invokeSplat = @{
			uri         = $URI
			method      = 'put'
			infile      = $file
			contenttype = 'audio/wav'
			headers     = $session['headers']
		}
		
		try {
			Invoke-RestMethod @invokeSplat
		}
		catch {
			Write-Warning -Message "$($_)"
		}
	}
}