function Set-CUCCallhandler {
<#
.SYNOPSIS
Set Cisco Unity Callhandler VoiceName
 
.DESCRIPTION
Set Cisco Unity Callhandler VoiceName for an auto attendant with specified wav file.
 
.EXAMPLE
Set-CUCCallhandler "Auto Attendant Main" -VoiceNameFile "Auto Attendant Main Call Tree Greeting.wav"

#>
    [CmdletBinding()]
    Param (
        [parameter(ValueFromPipeline = $True)]
        [string[]]$DisplayName,
		
        [parameter(ValueFromPipeline = $True)]
        [string]$VoiceNameFile,
		
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity Session')]
        $session = $DefaultCUCSession
    )
		
    Process {
        Write-Debug -Message "[$($MyInvocation.MyCommand)]"
        $URI = "https://$($session['server'])/vmrest/handlers/callhandlers?query=(displayname is $($DisplayName))"

        $Callhandler = Invoke-RestMethod -Headers $session['headers'] -Uri $URI
		
        if ($VoiceNameFile) {
            $file = try {
                get-item $VoiceNameFile -ErrorAction SilentlyContinue
            }
            catch {
                Write-Warning -Message "$($_)"
            }
			
            Write-Verbose -Message "[$($MyInvocation.MyCommand)] File: $($file)"
          			
            $URI = "https://$($session['server'])$($Callhandler.Callhandler.VoiceNameURI)"
			
            # PUT https://<Connection-server>/vmrest/handlers/callhandlers/<objectid>/voicename

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
}