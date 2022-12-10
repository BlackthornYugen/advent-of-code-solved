#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/9.input.sample",
    [bool]$DrawThings = $false,
    [int]$KnotCount = 9,
    [int]$DrawTime = 1
)

function Add-Vector {
    param (
        $a,
        $b,
        $factor = 1 # Used -1 for subtraction
    )

    return [System.Tuple]::Create($a.Item1 + $b.Item1 * $factor, $a.Item2 + $b.Item2 * $factor)
}

function draw() {
    param (
        [int] $x,
        [int] $y,
        [string] $value,
        [bool] $highlight = $false
    )

    [Console]::SetCursorPosition($x * 6, $y * 3)

    if ($highlight) 
    {
        Write-Host -ForegroundColor Yellow $value -NoNewline
    }
    else
    {
        Write-Host $value -NoNewline
    }

    Start-Sleep -Milliseconds $DrawTime
}

if ($DrawThings)
{
    Clear-Host
    [Console]::CursorVisible = $false
    [Console]::SetCursorPosition(0,0)
}

$head = [System.Tuple]::Create(12, 18)
$tails = New-Object System.Collections.ArrayList $KnotCount

for ($i = 0; $i -lt $KnotCount; $i++) {
    $tails.Add($head) | Out-Null
}

$Directions = @{
    U = [System.Tuple]::Create(  0, -1 )
    R = [System.Tuple]::Create(  1,  0 )
    D = [System.Tuple]::Create(  0,  1 )
    L = [System.Tuple]::Create( -1,  0 )
}

$TailMoves = @{
    [System.Tuple]::Create(  0, -2 ) = $Directions.U
    [System.Tuple]::Create(  1, -2 ) = $Directions.U
    [System.Tuple]::Create( -1, -2 ) = $Directions.U

    [System.Tuple]::Create(  2,  0 ) = $Directions.R
    [System.Tuple]::Create(  2,  1 ) = $Directions.R
    [System.Tuple]::Create(  2, -1 ) = $Directions.R

    [System.Tuple]::Create(  0,  2 ) = $Directions.D
    [System.Tuple]::Create(  1,  2 ) = $Directions.D
    [System.Tuple]::Create( -1,  2 ) = $Directions.D

    [System.Tuple]::Create( -2,  0 ) = $Directions.L
    [System.Tuple]::Create( -2,  1 ) = $Directions.L
    [System.Tuple]::Create( -2, -1 ) = $Directions.L
    
    [System.Tuple]::Create( -2, -2 ) = (Add-Vector $Directions.L $Directions.U)
    [System.Tuple]::Create( -2,  2 ) = (Add-Vector $Directions.L $Directions.D)
    [System.Tuple]::Create(  2, -2 ) = (Add-Vector $Directions.R $Directions.U)
    [System.Tuple]::Create(  2,  2 ) = (Add-Vector $Directions.R $Directions.D)
}

$TailHistory = @{}

Get-Content $FileName | ForEach-Object {
    
    if ($_ -match '(U|R|D|L) (\d+)')
    {
        $direction = $Directions[$Matches[1]]
        $distance  = [int]$Matches[2]

        for ($i = 0; $i -lt $distance; $i++) {
            if ($DrawThings)
            {
                draw $tails[$KnotCount-1].Item1 $tails[$KnotCount-1].Item2 "##"
                draw $head.Item1 $head.Item2 "  "
            }

            $head = Add-Vector $head $direction

            for ($j = 0; $j -le $KnotCount; $j++) {
                $tailPos = $tails[$j]

                if ($j -eq 0)
                {
                    $headPos = $head
                }
                else
                {
                    $headPos = $tails[$j - 1]
                }

                $deltaPos = Add-Vector $tailPos $headPos -factor -1
    
                $newTailRelativePos = $TailMoves[$deltaPos]
    
                if ($null -ne $newTailRelativePos)
                {
                    $tailPos = Add-Vector $newTailRelativePos $headPos
                    if ($DrawThings) {
                        if ($j -eq $KnotCount - 1) {
                            draw $tails[$j].Item1 $tails[$j].Item2 "  "
                            draw $tails[$j].Item1 $tails[$j].Item2 ($TailHistory.Count)
                        } else {
                            draw $tails[$j].Item1 $tails[$j].Item2 "  "
                        }
                    }
                    $tails[$j] = $tailPos
                }
    
                if ($DrawThings)
                {
                    $highlight = if ($j % 2 -eq 0) { $true } else { $false }
                    draw $head.Item1 $head.Item2 " H "
                    draw $tailPos.Item1 $tailPos.Item2 "T$($j + 1)"  -highlight $highlight
                }
            }
            
            $tailPos = $tails[$KnotCount - 1]

            if ($TailHistory.Contains($tailPos)) {
                $TailHistory[$tailPos] = $TailHistory[$tailPos] + 1
            } else {
                $TailHistory.Add($tailPos, 1)
            }
        }
    }
    else
    {
        throw "Invalid input `"$_`""
    }
}

if ($DrawThings) {
    [Console]::SetCursorPosition(0,0)
    Write-Host "                "
    Write-Host "                "
    Write-Host "                "
    [Console]::SetCursorPosition(0,0)
    Write-Host "                "
}
Write-Host $TailHistory.Count