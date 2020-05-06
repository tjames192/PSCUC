function New-CUCUserImport {
<#
.SYNOPSIS
New Cisco Unity User Imported from LDAP
 
.DESCRIPTION
New Cisco Unity User Imported from LDAP

.EXAMPLE
New-CUCUserImport -alias 'demo@demo.com' -firstname 'Demo' -lastname 'Demo' -displayname 'Demo Demo' -extension '6390' -emailaddress 'demo@demo.com'

/vmrest/users/05bffb3d-cd33-4097-becb-609f62b920de
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
		
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName, ValueFromPipeline, HelpMessage = 'User Template')]
        [string]$templatealias,
		
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName, ValueFromPipeline, HelpMessage = 'Class of Service')]
        [string]$CosDisplayName,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    Process {
        if (-not $templatealias) { $templatealias = $config.templateAlias }
        if (-not $CosDisplayName) { $CosDisplayName = $config.CosDisplayName }
		
        # https://ciscomarketing.jiveon.com/thread/43884
        # get the pkid of synced ldap user
        $URI = "https://$($session['server'])/vmrest/import/users/ldap?query=(alias is $($alias))"
        $user = Invoke-RestMethod -Headers $session['headers'] -Uri $URI
			
        # json fields are case sensitive
        $json = [ordered]@{
            pkid                      	= $user.ImportUser.pkid
            alias                     	= $alias
            firstName                 	= $firstname
            lastName                  	= $lastname
            dtmfAccessId              	= $extension
            displayName               	= $displayname
            extension                 	= $extension
            transferExtension         	= $extension
            standardTransferExtension	= $extension
            closedTransferExtension   	= $extension
            mwiExtension              	= $extension
            mailName                  	= $alias.split('@')[0]
            emailaddress              	= $emailaddress
            relayAddress              	= $emailaddress
            ldapCcmUserId             	= $alias
        }
			
        $body = $json | ConvertTo-Json
			
        # create user with specified User Template
        $URI = "https://$($session['server'])/vmrest/import/users/ldap?templateAlias=$($templatealias)"
			
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