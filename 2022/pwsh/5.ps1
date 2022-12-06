#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/5.input"
)

$patternStack = '^.([1A-Z ]). .([2A-Z ]). .([3A-Z ]). .([4A-Z ]). .([5A-Z ]). .([6A-Z ]). .([7A-Z ]). .([8A-Z ]). .([9A-Z ]).'
$patternStackMatches = New-Object System.Collections.Generic.List[Hashtable]
$patternAction = 'move (\d+) from (\d+) to (\d+)'
$elements = New-Object System.Collections.Generic.Stack[char][] 9
$cursorTop = [Console]::GetCursorPosition().Item2
$drawHeight = 50

for ($i = 0; $i -lt $elements.Count; $i++) {
    $elements[$i] = New-Object System.Collections.Generic.Stack[char]
}

function PrintElements {
    try {
        [Console]::CursorVisible = $false
        $elements | ForEach-Object {
            if ($_.Count) {
                Write-Host -NoNewline $_.Peek()
            }
        }
        Write-Host ""
        for ($i = 0; $i -lt $elements.Count; $i++) {
            $boxes = $elements[$i].ToArray()

            for ($j = 0; $j -lt $drawHeight; $j++) {
                [Console]::SetCursorPosition($i * 4, $cursorTop + $drawHeight - $j)
                if (!$boxes[$j]) {
                    Write-Host -NoNewline "    "
                }
            }

            for ($j = 0; $j -lt $boxes.Count; $j++) {
                Start-Sleep -Milliseconds 66
                [Console]::SetCursorPosition($i * 4, $cursorTop + $drawHeight - $j)
                Write-Host -NoNewline " [$($boxes[$j])]"
            }

        }
    } finally {
        [Console]::SetCursorPosition(0, $cursorTop)
        [Console]::CursorVisible = $true
    }
}

Get-Content $FileName
| Select-Object -First 12
| ForEach-Object {

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
        PrintElements

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
# [Console]::SetCursorPosition(0, $cursorTop)
# [Console]::CursorVisible = $true
PrintElements
