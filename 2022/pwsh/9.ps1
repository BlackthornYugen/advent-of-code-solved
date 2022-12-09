#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/9.input"
)
Clear-Host
[Console]::CursorVisible = $false
[Console]::SetCursorPosition(0,0)

$xMax = [Console]::BufferWidth
$yMax = [Console]::BufferHeight

$headPos = [System.Tuple]::Create(5, 5)
$tailPos = $headPos
[Console]::SetCursorPosition($currentPosition.Item1, $currentPosition.Item2)

$Directions = @{
    "U" = [System.Tuple]::Create(  0, -1 )
    "R" = [System.Tuple]::Create(  1,  0 )
    "D" = [System.Tuple]::Create(  0,  1 )
    "L" = [System.Tuple]::Create( -1,  0 )
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
    
}
# Write-Host "S" -NoNewline

Get-Content $FileName | ForEach-Object {
    
    if ($_ -match '(U|R|D|L) (\d+)')
    {
        $direction = $Directions[$Matches[1]]
        $distance  = [int]$Matches[2]

        for ($i = 0; $i -lt $distance; $i++) {

            draw $tailPos.Item1 $tailPos.Item2 "#"
            draw $headPos.Item1 $headPos.Item2 " "

            $headPos = [System.Tuple]::Create(
                $headPos.Item1 + $direction.Item1,
                $headPos.Item2 + $direction.Item2
            )

            $diffX = (($headPos.Item1 - $tailPos.Item1) / 2)
            $diffY = (($headPos.Item2 - $tailPos.Item2) / 2)
            $xxx = if ($direction.Item2 -eq 0) { [int]$diffX + $tailPos.Item1 } else { $headPos.Item1 }
            $yyy = if ($direction.Item1 -eq 0) { [int]$diffY + $tailPos.Item2 } else { $headPos.Item2 }
            # if (!(([Math]::Abs($diffX) -eq 1) -or ([Math]::Abs($diffY) -eq 1)))
            if (!(([Math]::Abs($diffX) -eq 0.5) -and ([Math]::Abs($diffY) -eq 0.5)))
            {
                $tailPos = [System.Tuple]::Create($xxx, $yyy)
            }
            
            if ($TailHistory.Contains($tailPos)) {
                $TailHistory[$tailPos] = $TailHistory[$tailPos] + 1
            } else {
                $TailHistory.Add($tailPos, 1)
            }
            draw $headPos.Item1 $headPos.Item2 "H"
            draw $tailPos.Item1 $tailPos.Item2 "T$($TailHistory[$tailPos])"

            [Console]::SetCursorPosition($xMax, $yMax)
            Start-Sleep -Milliseconds 200
        }

    }
    else
    {
        throw "Invalid input `"$_`""
    }

}

# Start-Sleep 3
[Console]::SetCursorPosition(0,0)
Write-Host "                "
Write-Host "                "
Write-Host "                "
[Console]::SetCursorPosition(0,0)
Write-Host "                "
Write-Host $TailHistory.Count