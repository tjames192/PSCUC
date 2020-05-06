function Format-Result {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true)]
        $results,
        [parameter(Mandatory = $true)]
        [string]$TypeName
    )
		
		
    Begin {
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] Executing function"
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] ParameterSetName: $($PsCmdlet.ParameterSetName)"
        Write-Debug -Message "[$($MyInvocation.MyCommand.Name)] PSBoundParameters: $($PSBoundParameters | Out-String)"
        $object = @() 
    }

    Process {
        # Add custom type to the resulting oject for formating purpose
        Foreach ($result in $results) {
            If ($result) {
                Write-Debug -Message "[$($MyInvocation.MyCommand)] Data: $($result) with typename: $($TypeName)"
                $result.PSObject.TypeNames.Insert(0, $TypeName)
            }
            $object += $result
        }
    }

    End {
        return $object
    }
}