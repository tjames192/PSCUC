Function Get-CUCSSHAuth {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        $ComputerName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        $Credential
    )

    if (Get-Module -ListAvailable -Name 'Posh-SSH') {
        try {
            $session = New-SshSession -ComputerName $ComputerName -Credential $Credential
        
            $script:SSHstream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
        }
        catch {
        }
    }
    else {
        Write-Warning -Message "Please install Posh-SSH."
        Write-Warning -Message "Install-Module -Name Posh-SSH"
    }
}