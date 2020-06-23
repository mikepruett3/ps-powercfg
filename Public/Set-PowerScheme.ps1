function Set-PowerScheme {
    <#
    .SYNOPSIS
        Sets the desired Power Scheme (Plan) from an avaliable list of Power Schemes
    .DESCRIPTION
        A function that sets the active Power Scheme from a list of avaliable
        Power Schemes (Plans) for the current machine.
    .PARAMETER Plan
        Specify the Power Scheme (Plan) to set active. Choose from the following:
        - "Balanced"
        - "High Performance"
        - "Power Saver"
    .EXAMPLE
        *NOTE* It is important to specify the double-quotes for the Power Scheme Name!
        > Set-PowerScheme -Plan "High Performance"
    #>
    
    [CmdletBinding()]

    param (
    [Parameter(Mandatory=$False)]
    [string]$Plan
    )
    
    begin { }
    
    process {
        Write-Verbose "Setting desired Power Scheme..."
        if ( $Plan ) {
            powercfg.exe /s $( Get-PowerSchemes | Where-Object {$_.Plan -eq $Plan} ).GUID
        }
        
        Get-PowerSchemes
        #switch ( $Plan ) {
        #    "Balanced"              { continue }
        #    "High Performance"      { continue }
        #    "Power Saver"           { continue }
        #    "Ultimate Performance"  { continue }
        #    *                       { powercfg.exe /s $( Get-PowerSchemes | Where-Object {$_.Plan -eq $Plan} ).GUID }
        #    Default                 { Get-PowerSchemes; Break }
        #}
    }
    
    end {
        # Cleanup
        Write-Verbose "Cleaning up used Variables..."
        Clear-Variable -Name "Plan" -ErrorAction SilentlyContinue
    }
}
