#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/input.4"
)

Get-Content $FileName 
| ForEach-Object {
    # Use the regular expression to match the input data
    if ($_ -match '(\d+)-(\d+),(\d+)-(\d+)') {
        # Extract the values from the input data
        $xLow  = [int]$Matches[1]
        $xHigh = [int]$Matches[2]
        $yLow  = [int]$Matches[3]
        $yHigh = [int]$Matches[4]

        # Test if x is within y->Y
        #  x-----X
        # y--------Y
        if (($xLow -ge $yLow) -and ($xLow -le $yHigh))
        {
            return $true
        }

        # Test if X is within y->Y
        #  x-----X
        # y--------Y
        if (($xHigh -ge $yLow) -and ($xHigh -le $yHigh))
        {
            return $true
        }

        # Test if y is within x->X
        #  y-----Y
        # x--------X
        if (($yLow -ge $xLow) -and ($yLow -le $xHigh))
        {
            return $true
        }

        # Code will never reach this point if Y is within x-----X.
    }
} | Measure-Object | ForEach-Object Count
