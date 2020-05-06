Import-Module .\PSCUC.psd1 -Verbose -Force -debug -ArgumentList $true

Connect-CUC server -Username "ccmadmin"  -Password "abcd1234"
Connect-CUCSSH server -Username "admin"  -Password "abcd1234"