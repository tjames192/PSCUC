function Set-CUCNotificationHTMLDevice {
<#
.SYNOPSIS
Set Cisco Unity Users' HTML Notifcation Device
 
.DESCRIPTION
Set Cisco Unity Users' HTML Notifcation Device
 
.EXAMPLE
Set-CUCNotificationHTMLDevice -alias demo@demo.com -DisplayName "HTML Missed Call" -Enabled $true

#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $True)]
        [string[]]$alias,
		
        [Parameter(Mandatory = $true, ValueFromPipeline = $True, HelpMessage = 'Notification Device DisplayName')]
        [string[]]$DisplayName,
		
        [Parameter(Mandatory = $true, ValueFromPipeline = $True)]
        [bool]$Enabled,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
		
    Process {
        Write-Verbose -Message "[$($MyInvocation.MyCommand)] Processing alias: $($alias)"

        $URI = "https://$($session['server'])/vmrest/users?query=(alias is $($alias))"

        $user = Invoke-RestMethod -Headers $session['headers'] -Uri $URI 

        # https://server/vmrest/users/2899743d-0d2f-4e4e-abc6-8ee00fe17969/notificationdevices/htmldevices/		
        $URI = "https://$($session['server'])/vmrest/users/$($user.user.objectid)/notificationdevices/htmldevices/"
				
        Write-Verbose -Message "[$($MyInvocation.MyCommand)] Getting all HTMLDevices for $($alias)"
        $NotificationDevices = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).HtmlDevice
				
        Write-Verbose -Message "[$($MyInvocation.MyCommand)] Selecting HTMLDevice $DisplayName"
        $NotificationDevice = $NotificationDevices | ? {$_.displayname -eq $DisplayName}
		
        $URI = "https://$($session['server'])$($NotificationDevice.URI)"
		
        # if config NotificationID missing use Default_Missed_Call HTML Template
        # else use custom HTML Template
        # TODO: enumerate HTML Template ObjectIDs, don't rely on static objectid
        if (-not $config.NotificationTemplateID) { $NotificationTemplateID = "a4cf3357-3856-48d5-a75e-8848a673fa66" }
        else { $NotificationTemplateID = $config.NotificationTemplateID }
		
        $json = [ordered]@{
            SmtpAddress            = $user.user.EmailAddress
            Active                 = $Enabled
            NotificationTemplateID = $NotificationTemplateID
        }
		
        $body = $json | ConvertTo-Json
		
        $irmSplat = @{
            Headers     = $session['headers']
            Uri         = $URI
            method      = 'put'
            Body        = $body
            ContentType = 'application/json'
        }
		
        try { 
            $request = invoke-restmethod @irmSplat -ErrorVariable apiErr
        } 
        catch {
            write-warning $apiErr.InnerException
        }
    }
}