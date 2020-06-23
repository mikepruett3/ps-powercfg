function Unlock-UltimatePerformanceScheme {
    <#
    .SYNOPSIS
        Unlocks the Ultimate Performance Power Scheme (Plan)
    .DESCRIPTION
        A function that unlocks the Ultimate Performance
        Power Scheme (Plan) for the current machine.
    .EXAMPLE
        > Unlock-UltimatePerformanceScheme
    #>
    
    [CmdletBinding()]

    param ( )
    
    begin { }
    
    process {
        if (! ( Get-PowerSchemes | Where-Object {$_.Plan -eq "Ultimate Performance"} ) ) {
            Write-Verbose "Unlocking the Ultimate Performance Power Scheme..."
            powercfg.exe -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        }
    }
    
    end { }
}
