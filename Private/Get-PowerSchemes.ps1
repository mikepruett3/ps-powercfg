function Get-PowerSchemes {
    <#
    .SYNOPSIS
        Retrieve list of Power Schemes (Plans) from the active machine
    .DESCRIPTION
        A function that creates an array with all of the avaliable Power Schemes (Plans)
        for the current machine. Also specifying which plan is active 
    .EXAMPLE
        > Get-PowerSchemes
    #>
    
    [CmdletBinding()]
    param ()
    
    begin {
        # Creating new Array for result
        Write-Verbose "Creating new Results array..."
        $Result = New-Object System.Collections.ArrayList

        # Capture Output of PowerCfg, listing all avaliable plans
        Write-Verbose "Getting current Power Plans from powercfg.exe ..."
        try { $powercfg = $(powercfg /l) }
        catch {
            Write-Error "Unable to get the current Power Plans from powercfg.exe"
            Break
        }
    }
    
    process {
        # Loop Thru each Power Plan
        Write-Verbose "Creating new array of avaliable Power Plans..."
        foreach ($Scheme in $powercfg) {
            if ($Scheme -like "*GUID*") {
                # Create a temporary System Object
                $Schemes = New-Object System.Object

                # Retrieve GUID's from Output
                $GUID = $Scheme.Split(" ")
                $Schemes | Add-Member -MemberType NoteProperty -Name GUID -Value $GUID[3]

                # Retrieve Power Plan Names from Output
                $PlanSeperator = "(",")"
                $PlanSeperatorOptions = [System.StringSplitOptions]::None
                $Plan = $Scheme.Split($PlanSeperator,$PlanSeperatorOptions)
                $Schemes | Add-Member -MemberType NoteProperty -Name Plan -Value $Plan[1]

                # Retrieve Active Power Plan from Output
                $Active = $Scheme.Contains("*")
                if ($Active) {
                    $Schemes | Add-Member -MemberType NoteProperty -Name Active -Value $True
                } else {
                    $Schemes | Add-Member -MemberType NoteProperty -Name Active -Value $False
                }
            }

            # Add the output of the new System Object to Results
            Write-Verbose "Adding Power Plans to Results array..."
            $Result.Add($Schemes) | Out-Null
        }
        Return $Result
    }
    
    end {
        # Cleanup
        Write-Verbose "Cleaning up used Variables..."
        Clear-Variable -Name "Result" -ErrorAction SilentlyContinue
        Clear-Variable -Name "powercfg" -ErrorAction SilentlyContinue
        Clear-Variable -Name "Scheme" -ErrorAction SilentlyContinue
        Clear-Variable -Name "Schemes" -ErrorAction SilentlyContinue
        Clear-Variable -Name "GUID" -ErrorAction SilentlyContinue
        Clear-Variable -Name "Plan" -ErrorAction SilentlyContinue
        Clear-Variable -Name "PlanSeperator" -ErrorAction SilentlyContinue
        Clear-Variable -Name "PlanSeperatorOptions" -ErrorAction SilentlyContinue
        Clear-Variable -Name "Active" -ErrorAction SilentlyContinue
    }
}