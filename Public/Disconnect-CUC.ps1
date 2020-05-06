function Disconnect-CUC {
    <#  
    .SYNOPSIS  
        Disconnects session against CUC server.
    .DESCRIPTION
        Disconnects session against CUC server.
    .EXAMPLE
    Disconnect-CUC
    Description
    -----------
    This command will disconnect the session to the CUC server.  
           
    #> 
    [cmdletbinding()]  
    Param ()
    Process { 
        # Disconnect CUC session by removing the variable   
        Remove-Variable -Name DefaultCUCSession -Force -Scope Script
        $functions = (Get-Command -Module pscuc).name
        $functions | foreach { Remove-Item -path Function:\$_ }
        Remove-Module -Name PSCUC -Verbose -Force
    }
}