#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/5.input"
)

$patternStack = '^'
$patternStackMatches = New-Object System.Collections.Generic.List[Hashtable]
$patternAction = 'move (\d+) from (\d+) to (\d+)'
$elements = New-Object System.Collections.Generic.Stack[char][] 9

$boxesMoved = 1
$boxesExpectedToMove = 500 # Doesn't need to be exact

for ($i = 0; $i -lt $elements.Count; $i++) {
    $elements[$i] = New-Object System.Collections.Generic.Stack[char]
}

function PrintElements {
    $elements | ForEach-Object {
        if ($_.Count) {
            Write-Host -NoNewline $_.Peek()
        }
    }
    Write-Host ""
}

Get-Content $FileName
| Select-Object
| ForEach-Object {

    if ($patternStack -eq '^') {
        for ($i = 0; $i -lt (($_.Length + 1) / 4); $i++) {
            $patternStack += ".([$($i + 1)A-Z ]). "
        }
        $patternStack = $patternStack.Trim()
    }

    if ($_ -match $patternStack ) {
        if ( $Matches[1] -eq "1" ) {
            for ($i = $patternStackMatches.Count - 1; $i -ge 0 ; $i--) {
                for ($j = 0; $j -lt $elements.Count; $j++) {
                    $box = $patternStackMatches[$i][$j + 1]
                    if ($box -ne " ") {
                        $elements[$j].Push($patternStackMatches[$i][$j + 1])
                    }
                }
            }
        } else {
            $patternStackMatches.Add($Matches)
        }
    } elseif ($_ -match $patternAction) {

        $percentComplete = [Math]::Max([Math]::Min((($boxesMoved++ / $boxesExpectedToMove)), 1), 0.01) * 100
        Write-Progress -Activity "Moving boxes" -Status "Processing command: $_" -PercentComplete $percentComplete
        Start-Sleep -Milliseconds 5

        $numberOfBoxes = [int]$Matches[1]
        $from          = $elements[[int]$Matches[2] - 1]
        $to            = $elements[[int]$Matches[3] - 1]
        $buffer        = New-Object char[] $numberOfBoxes

        for ($i = 0; $i -lt $buffer.Count; $i++) {
            $buffer[$i] = $from.Pop()
        }

        for ($i = $buffer.Count - 1; $i -ge 0 ; $i--) {
            $to.Push($buffer[$i])
        }
    }
}


# Throw away any keyboard input during animation
while ($Host.UI.RawUI.KeyAvailable) {
    $host.ui.rawui.readkey("NoEcho,IncludeKeyup") | Out-Null
}

Write-Progress -Activity "Moving boxes" -PercentComplete 100
Start-Sleep -Milliseconds 200
Write-Progress -Activity "Moving boxes" -Completed
Start-Sleep -Milliseconds 200
PrintElements
