function Connect-CUC {
<#
.SYNOPSIS
Connect to Cisco Unity Connection
 
.DESCRIPTION
Connect to Cisco Unity Connection
 
.EXAMPLE
Connect-CUC server -Username "ccmadmin"  -Password "abcd1234"

Name                           Value                   
----                           -----                   
IsConnected                    True                    
Server                         server                 
Headers                        {Accept, Authorization}

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "ByServer", ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Cisco Unity FQDN or IP address')]
        $Server,
		
        [Parameter(Mandatory = $true, ParameterSetName = "BySession", ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Cisco Unity Session object')]
        $Session,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity username')]
        [String]$Username,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity password')]
        [String]$Password,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity credentials')]
        [PSCredential]$Credentials,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Trust all certs ?')]
        [Bool]$TrustAllCerts = $True
    )
    Begin {
        Write-Debug -Message "[$($MyInvocation.MyCommand)] Executing function"
		
        if ($TrustAllCerts) {
            Unblock-Certs
        }
    }
    Process {
        $EncodedAuthorization = [System.Text.Encoding]::UTF8.GetBytes($Username + ':' + $Password)
        $EncodedPassword = [System.Convert]::ToBase64String($EncodedAuthorization)
		
        $session = Get-CUCAuth -Server $server -EncodedPassword $EncodedPassword
				
        #Add the $session to the $global:DefaultCUCSession
        $script:DefaultCUCSession = @{
            IsConnected	= if ($session.headers) { $true } else { $false }
            Server      = $Server
            Headers     = if ($session.headers) { [hashtable]$session.headers } else { $null }
        }
		
        $DefaultCUCSession
		
		$config
    }
}