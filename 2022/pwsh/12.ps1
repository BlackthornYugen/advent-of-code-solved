#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/12.input.sample"
)

function Draw() 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, valueFromPipeline)]
        [String] $Line
    )

    process {
        for ($i = 0; $i -lt $Line.Length; $i++) {
            if ($Line[$i] -gt 120) {
                $colour = [System.ConsoleColor]::Red
            } elseif ($Line[$i] -gt 110) {
                $colour = [System.ConsoleColor]::DarkRed
            } elseif ($Line[$i] -gt 105) {
                $colour = [System.ConsoleColor]::Yellow
            } elseif ($Line[$i] -gt 100) {
                $colour = [System.ConsoleColor]::DarkYellow
            } elseif ($Line[$i] -gt 95) {
                $colour = [System.ConsoleColor]::DarkGreen
            } elseif ($Line[$i] -gt 90) {
                $colour = [System.ConsoleColor]::Green
            } else {
                $colour = $null
            }

            if ($null -ne $colour) {
                Write-Host -NoNewline -BackgroundColor $colour $Line[$i]
            }
            else
            {
                Write-Host -NoNewline $Line[$i]
            }
        }
        Write-Host ""
    }
    
    end {
        Write-Host " "
    }

}

function LoadMap() 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, valueFromPipeline)]
        [String] $Line
    )

    begin {
        $result = [PSCustomObject]@{
            Start = $null
            End = $null
            Map = [Collections.Generic.Dictionary[System.Tuple[int,int], int]]::New()
        }
        
        [int]$y = 0
    }

    process {
        Write-Debug $Line
        for ($x = 0; $x -lt $Line.Length; $x++) {
            $char = $Line[$x]
            $location = [System.Tuple]::Create($x, $y)

            if ($char -eq "S") 
            {
                $result.Start = $location
            }
            elseif ($char -eq "E") 
            {
                $result.End = $location
            }
            else 
            {
                # Use char's int value as altitute
                $result.Map.Add($location, $char)
            }
        }
        $y++
    }
    
    end {
        $result
    }

}


function FindPath {
    param (
        [Collections.Generic.Dictionary]$map
    )
    
    [System.Collections.Generic.PriorityQueue[System.Tuple]]$queue = `
        New-Object 'System.Collections.Generic.PriorityQueue[System.Tuple]'

    $queue
}

Get-Content $FileName | LoadMap