function Connect-CUC {
<#
.SYNOPSIS
Connect to Cisco Unity Connection
 
.DESCRIPTION
Connect to Cisco Unity Connection
 
.EXAMPLE
Connect-CUC sfucpub -Username "ccmadmin"  -Password "ccmAB!(^$"

Name                           Value                   
----                           -----                   
IsConnected                    True                    
Server                         sfucpub                 
Headers                        {Accept, Authorization}

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "ByServer", ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Cisco Unity FQDN or IP address')]
        $Server,
		
        [Parameter(Mandatory = $true, ParameterSetName = "BySession", ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Cisco Unity Session object')]
        $Session,
		
        [Parameter(Mandatory = $true, HelpMessage = 'Cisco Unity credentials')]
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
        $session = Get-CUCAuth -Server $server -Credentials $Credentials
				
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
