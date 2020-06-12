function Set-CUCNotificationSMTPDevice {
<#
.SYNOPSIS
Set Cisco Unity Users' SMTP Notifcation Device
 
.DESCRIPTION
Set Cisco Unity Users' SMTP Notifcation Device
 
.EXAMPLE
Set-CUCNotificationSMTPDevice -alias demo@demo.com -DisplayName "SMTP" -Enabled $true

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

        Write-Verbose -Message "[$($MyInvocation.MyCommand)] Getting all SMTP Devices for $($alias)"
        # https://server/vmrest/users/2899743d-0d2f-4e4e-abc6-8ee00fe17969/notificationdevices/smtpdevices/
        $URI = "https://$($session['server'])/vmrest/users/$($user.user.objectid)/notificationdevices/smtpdevices/"
        $NotificationDevices = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).SmtpDevice
				
        Write-Verbose -Message "[$($MyInvocation.MyCommand)] Selecting SmtpDevice $DisplayName"
        $NotificationDevice = $NotificationDevices | ? {$_.displayname -eq $DisplayName}
        $URI = "https://$($session['server'])$($NotificationDevice.URI)"
		
        $json = [ordered]@{
            SmtpAddress = $user.user.EmailAddress
            Active      = $Enabled
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
          Write-Verbose -Message "[$($MyInvocation.MyCommand)] Setting alias: $alias, notification: $($NotificationDevice.DisplayName) to $Enabled"		
          $request = invoke-restmethod @irmSplat -ErrorVariable apiErr
        } 
        catch {
          write-warning $apiErr.InnerException
        }
    }
}
