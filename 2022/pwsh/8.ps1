#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/8.input"
)

function Build-Forest() 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, valueFromPipeline)]
        [String] $Line
    )
    
    begin { 
        [int[][]] $grid = $null
        $row = 0
    }

    process {
        if ($null -eq $grid)
        {
            $grid = [int[][]]::new($Line.Length, $Line.Length)
        }

        for ($column = 0; $column -lt $Line.Length; $column++) {
            $grid[$row][$column] = [int]::Parse($Line[$column])
        }
        $row++
    }

    end {
        return $grid
    }
}

function Test-Tree()
{
    [OutputType([bool])]
    param (
        [Parameter(Mandatory, valueFromPipeline)]
        [int[][]] $forest,

        [Parameter(Mandatory=$true)]
        [int] $x,

        [Parameter(Mandatory=$true)]
        [int] $y
    )

    [System.Tuple[int,int][]] $directions = @(
        [System.Tuple]::Create( -1,  0 ) # North
        [System.Tuple]::Create(  0,  1 ) # East
        [System.Tuple]::Create(  1,  0 ) # Sout
        [System.Tuple]::Create(  0, -1 ) # West
    )

    $width = $forest[0].Count
    $height = $forest.Count
    $treeHeight = $forest[$x][$y]

    foreach ($direction in $directions) {
        $scan_x = $x
        $scan_y = $y

        do
        {
            if (($scan_x -eq 0) -or ($scan_x -eq ($width - 1)) -or 
                ($scan_y -eq 0) -or ($scan_y -eq ($height - 1))) 
            {
                return $true
            }
            else
            {
                $scan_x += $direction.Item1
                $scan_y += $direction.Item2
            }
        } while ($treeHeight -gt $forest[$scan_x][$scan_y])
    }

    return $false
}

function Test-Trees() 
{
    param (
        [Parameter(Mandatory, valueFromPipeline)]
        [int[][]] $forest
    )

    for ($column = 0; $column -lt $forest[$column].Count ; $column++) {
        for ($row = 0; $row -lt $forest.Count; $row++) {
            if (($column -eq 0) -or ($row -eq 0) -or 
                ($row -eq $forest.Count) -or ($column -eq $forest[$column].Count)) 
            {
                $true
            }
            else
            {
                Test-Tree $forest $column $row
            }
        }
    }

}

$forest = Get-Content $FileName | Build-Forest
(Test-Trees $forest | ForEach-Object { if ($_) {$true} } | Measure-Object).Count
# 0,0 1,0 2,0 3,0 4,0
# 0,1 1,1 2,1 3,1 4,1
# 0,2 1,2 2,2 3,2 4,2
# 0,3 1,3 2,3 3,3 4,3
# 0,4 1,4 2,4 3,4 4,4