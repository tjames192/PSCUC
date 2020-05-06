function New-CUCUser {
<#
.SYNOPSIS
New Cisco Unity User
 
.DESCRIPTION
New Cisco Unity User
 
.EXAMPLE
$newuser = [pscustomobject][ordered]@{
alias = 'demo@domain.com'
firstName = 'Demo'
lastName = 'Demo'
displayName = 'Demo Demo'
extension = '1111'
emailaddress = 'demo@domain.com'
}

$newuser | New-CUCUser

/vmrest/users/b99adcb9-ef4d-47a0-94a7-3363d885e995

.EXAMPLE
New-CUCUser -alias 'demo@domain.com' -firstname 'Demo' -lastname 'Demo' -displayname 'Demo Demo' -extension '1111'  -emailaddress 'demo@domain.com'

/vmrest/users/b99adcb9-ef4d-47a0-94a7-3363d885e995
#>
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, HelpMessage = 'userPrincipalName')]
        [string]$alias,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string]$firstname,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string]$lastname,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string]$displayname,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string]$extension,
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string]$emailaddress,
		
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName, HelpMessage = 'User Template')]
        [string]$templatealias,
		
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName, HelpMessage = 'Class of Service')]
        [string]$CosDisplayName,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Process {
        if (-not $templatealias) { $templatealias = $config.templateAlias }
        if (-not $CosDisplayName) { $CosDisplayName = $config.CosDisplayName }
		
        # json keys are case sensitive
        $json = [ordered]@{
            Alias                     = $alias
            FirstName                 = $firstname
            LastName                  = $lastname
            DisplayName               = $displayname
            DtmfAccessId              = $extension
            transferExtension         = $extension
            standardTransferExtension	= $extension
            closedTransferExtension   = $extension
            mwiExtension              = $extension
            mailName                  = $alias.split('@')[0]
            emailaddress              = $emailaddress
            relayAddress              = $emailaddress
        }
			
        $body = $json | ConvertTo-Json
			
        # create user with specified User Template
        $URI = "https://$($session['server'])/vmrest/users?templateAlias=$($templatealias)"
			
        $irmSplat = @{
            Headers     = $session['headers']
            Uri         = $URI
            method      = 'post'
            Body        = $body
            ContentType = 'application/json'
        }
		
        $response = invoke-restmethod @irmSplat
		
        $response		
    }
}