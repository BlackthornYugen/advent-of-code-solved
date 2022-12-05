#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/input.4"
)

Get-Content $FileName | ForEach-Object {
    [int]$xLow, [int]$xHigh, [int]$yLow, [int]$yHigh = $_.split(",") | ForEach-Object{ $_.split("-") }
    if ((($xLow -le $yLow) -and ($xHigh -ge $yHigh)) -or (($yLow -le $xLow) -and ($yHigh -ge $xHigh)))
    {
        $true
    }
} | Measure-Object | ForEach-Object Count
