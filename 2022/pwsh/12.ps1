#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/12.input.sample"
)

$StartAltitude = 97
$EndAltitude = 122

$Directions = @{
    U = [System.Tuple]::Create(  0, -1 )
    R = [System.Tuple]::Create(  1,  0 )
    D = [System.Tuple]::Create(  0,  1 )
    L = [System.Tuple]::Create( -1,  0 )
}

function Add-Vector {
    param (
        $a,
        $b
    )

    return [System.Tuple]::Create($a.Item1 + $b.Item1, $a.Item2 + $b.Item2)
}

function Get-Map() 
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

            if ($char -ceq "S") 
            {
                $result.Map.Add($location, $StartAltitude)
                $result.Start = $location
            }
            elseif ($char -ceq "E")
            {
                $result.Map.Add($location, $EndAltitude)
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

function Get-Path {
    param (
        [Collections.Generic.Dictionary[System.Tuple[int,int], int]]$locationsByAltitude,
        [System.Tuple[int, int]]$start,
        [System.Tuple[int, int]]$end
    )
    
    $queue = New-Object 'System.Collections.Generic.PriorityQueue[System.Tuple[int,int], int]'
    $locationsByDistance = New-Object 'Collections.Generic.Dictionary[System.Tuple[int,int], int]'
    $previousLocationByLocation = New-Object 'Collections.Generic.Dictionary[System.Tuple[int,int], System.Tuple[int,int]]'
    $breadcrumbByLocation = New-Object 'Collections.Generic.Dictionary[System.Tuple[int,int], String]'
    $locationsByDistance.Add($start, 0)
    $breadcrumbByLocation.Add($start, "")
    $queue.Enqueue($start, 0)

    while ($queue.Count -gt 0) {
        $position = $queue.Dequeue()
        $altitude = $locationsByAltitude[$position]
        $distance = $locationsByDistance[$position]
        $breadcrumb = $breadcrumbByLocation[$position]

        if ($altitude -eq $EndAltitude) {
            Write-Host "${distance}: $breadcrumb"
        }
        
        foreach ($directionName in $Directions.Keys) {
            $direction = $Directions[$directionName]
            $locationToConsider = Add-Vector $direction $position
            $altitudeToConsider = $locationsByAltitude[$locationToConsider]
            
            if ((-not $locationsByDistance.ContainsKey($locationToConsider)) -and
                ($null -ne $altitudeToConsider) -and
                ($altitude -ge ($altitudeToConsider - 1)))
            {
                $breadcrumbByLocation.Add($locationToConsider, $breadcrumb + $directionName)
                $locationsByDistance.Add($locationToConsider, ($distance + 1))
                $previousLocationByLocation.Add($locationToConsider, $position)
                $queue.Enqueue($locationToConsider, $distance)
            }
            # Write-Debug "Altitude $locationToConsider $altitudeToConsider"
        }
    }
}

$mapData = Get-Content $FileName | Get-Map

Get-Path $mapData.Map $mapData.Start $mapData.End