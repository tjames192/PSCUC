function Get-CUCNotificationTemplate {
<#
.SYNOPSIS
Get Cisco Unity Notification Templates
 
.DESCRIPTION
Get Cisco Unity Notification Templates
 
.EXAMPLE
Get-CUCNotificationTemplate

.EXAMPLE
Get-CUCNotificationTemplate Default_Voice_Message_With_Summary

#>
    [CmdletBinding()]
    Param (
        [parameter(ValueFromPipeline = $True)]
        [string[]]$NotificationTemplateName,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )

    Begin {
        $TypeName = 'Cisco.UnityConnection.CUCNotificationTemplates'
    }
		
    Process {
        if ($NotificationTemplateName) {
            Write-Debug -Message "[$($MyInvocation.MyCommand)] Processing alias: $($alias)"
            $URI = "https://$($session['server'])/vmrest/notificationtemplates?query=(NotificationTemplateName is $($NotificationTemplateName))"
        }
        else {
            $URI = "https://$($session['server'])/vmrest/notificationtemplates"
        }
		
        $objects = (Invoke-RestMethod -Headers $session['headers'] -Uri $URI).NotificationTemplate
    }

    End { return Format-Result -results $objects -TypeName $TypeName }
}
