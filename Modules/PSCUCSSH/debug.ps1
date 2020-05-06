#Import-Module .\PSCUC.psd1 -Verbose -Force -debug -ArgumentList $true

Connect-CUCSSH cuc01 -Username "admin"  -Password "abdef1234"