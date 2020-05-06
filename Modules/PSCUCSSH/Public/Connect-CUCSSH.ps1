Function Connect-CUCSSH {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True)]
        [ValidateNotNullorEmpty()]
        $ComputerName,

        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity OS Admin')]
        [String]$Username,
        
        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity OS Password')]
        [String]$Password,

        [Parameter(Mandatory = $false, HelpMessage = 'Cisco Unity OS Credentials')]
        [PSCredential]$Credentials
    )
    $User = $Username
    $Pass = ConvertTo-SecureString -String $Password -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Pass

    Get-CUCSSHAuth $ComputerName -credential $Credential
}
