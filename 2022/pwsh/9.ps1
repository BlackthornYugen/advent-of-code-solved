#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/9.input",
    [bool]$DrawThings = $false
)

if ($DrawThings)
{
    Clear-Host
    [Console]::CursorVisible = $false
    [Console]::SetCursorPosition(0,0)
}

$headPos = [System.Tuple]::Create(0, 0)
$tailPos = $headPos

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
}

$TailHistory = @{}

function draw() {
    param (
        [int] $x,
        [int] $y,
        [string] $value
    )

    [Console]::SetCursorPosition($x * 4, $y * 2)
    Write-Host $value -NoNewline
    Start-Sleep -Milliseconds 200
}
# Write-Host "S" -NoNewline

Get-Content $FileName | ForEach-Object {
    
    if ($_ -match '(U|R|D|L) (\d+)')
    {
        $direction = $Directions[$Matches[1]]
        $distance  = [int]$Matches[2]

        for ($i = 0; $i -lt $distance; $i++) {

            # draw $tailPos.Item1 $tailPos.Item2 "#"
            # draw $headPos.Item1 $headPos.Item2 " "

            $headPos = [System.Tuple]::Create(
                $headPos.Item1 + $direction.Item1,
                $headPos.Item2 + $direction.Item2
            )

            $deltaPos = [System.Tuple]::Create(
                $tailPos.Item1 - $headPos.Item1,
                $tailPos.Item2 - $headPos.Item2
            )

            $newTailRelativePos = $TailMoves[$deltaPos]

            if ($null -ne $newTailRelativePos)
            {
                $tailPos = [System.Tuple]::Create(
                    $newTailRelativePos.Item1 + $headPos.Item1,
                    $newTailRelativePos.Item2 + $headPos.Item2
                )
            }
            
            if ($TailHistory.Contains($tailPos)) {
                $TailHistory[$tailPos] = $TailHistory[$tailPos] + 1
            } else {
                $TailHistory.Add($tailPos, 1)
            }

            if ($DrawThings)
            {
                draw $headPos.Item1 $headPos.Item2 "H"
                draw $tailPos.Item1 $tailPos.Item2 "T$($TailHistory[$tailPos])"
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