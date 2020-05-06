function Send-CUCMailMessageUMMailboxPIN {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $True)]
        [int]$PIN,
		
        [Parameter(Mandatory = $true, ValueFromPipeline = $True)]
        [string]$EmailAddress,
		
        [Parameter(Mandatory = $true, ValueFromPipeline = $True)]
        [int]$PhoneNumber,
		
        [Parameter(Mandatory = $false, ValueFromPipeline = $True)]
        [string]$From,
		
        [Parameter(Mandatory = $false, ValueFromPipeline = $True)]
        [string]$Subject,
		
        [Parameter(Mandatory = $false, ValueFromPipeline = $True)]
        [string]$SmtpSmartHost,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
	
    $head = @"
<style type="text/css">
a:link {
    color: #3399ff;
}

a:visited {
    color: #3366cc;
}

a:active {
    color: #ff9900;
}

table {
    border:0;
    table-layout:auto;
}
td {
    font-family: Tahoma, sans-serif;
    color: #686a6b; 
    font-size:10pt;
    border-width: 0in;
}
</style>
"@

    $pre = @"
<div id="UM-call-info" lang="en">
<div style="font-family: Arial; font-size: 10pt; color:#000066; font-weight: bold;">Your Voicemail PIN has been reset.</div>
<br>
</div>To use your phone to access your voicemails and calendar, press messages button and enter your PIN at the prompt.
<br>
<br>
"@

    $post = @"
<br>
<br>To change your voice mail greetings from your phone:
<ol>
    <li>Call the voicemail system and log in with your 4 digit extension and your PIN shown above.</li>
    <li>At the Main menu, press &#8220;4&#8221; for Setup Options, then press &#8220;1&#8220; for Greetings.</li>
    <li>Press # to skip hearing your current greeting.</li>
	<li>If you turned on your alternate greeting, follow the prompts to set when you want it turned off or to leave it on indefinitely.</li>
</ol>
"@

    $props = [ordered]@{
        'Your number' = $PhoneNumber
        'Your PIN'    = $PIN
        'Email'       = $EmailAddress
    }

    $BodyAsHtml = New-Object -Type PSObject -Prop $props

    $BodyAsHtml = $BodyAsHtml | ConvertTo-Html -As List -Head $head -pre $pre -post $post | Out-String
	
    if (-not $From) { $From = $config.from }
    if (-not $Subject) { $Subject = $config.subject }
    
    $SmtpSmartHost = $config.SmtpSmartHost

    if (-not $SmtpSmartHost) { $SmtpSmartHost = (Get-CUCConnectionLocation).ConnectionLocation.SmtpSmartHost }

    $MailMessage = @{
        subject    = $Subject
        from       = $From
        to         = $EmailAddress
        smtpserver	= $SmtpSmartHost
        body       = $BodyAsHtml
    }
	
    Send-MailMessage @MailMessage -BodyAsHtml
}