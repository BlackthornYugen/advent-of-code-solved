#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/5.input"
)

$patternStack = '^.([1A-Z ]). .([2A-Z ]). .([3A-Z ]). .([4A-Z ]). .([5A-Z ]). .([6A-Z ]). .([7A-Z ]). .([8A-Z ]). .([9A-Z ]).'
$patternStackMatches = New-Object System.Collections.Generic.List[Hashtable]
$patternAction = 'move (\d+) from (\d+) to (\d+)'
$elements = New-Object System.Collections.Generic.Stack[char][] 9
$drawHeight = 20

for ($i = 0; $i -lt $elements.Count; $i++) {
    $elements[$i] = New-Object System.Collections.Generic.Stack[char]
}

function PrintElements {
    try {
        $cursorPosition = [Console]::GetCursorPosition()
        [Console]::CursorVisible = $false
        for ($i = 0; $i -lt $elements.Count; $i++) {
            $boxes = $elements[$elements.Count - 1 - $i].ToArray()

            for ($j = 0; $j -lt $drawHeight; $j++) {
                [Console]::SetCursorPosition([System.Console]::BufferWidth - 4 - ($i * 4), [System.Console]::BufferHeight - 1 - $j )
                Write-Host -NoNewline "    "
            }

            # for ($j = 0; $j -lt $boxes.Count; $j++) {
            #     Start-Sleep -Milliseconds 2
            #     [Console]::SetCursorPosition([System.Console]::BufferWidth - 4 - ($i * 4), [System.Console]::BufferHeight - 1 - $j)
            #     Write-Host -NoNewline " [$($boxes[$j])]"
            # }

            DrawArray -boxes $boxes -column $i 0
        }
    } finally {
        [Console]::SetCursorPosition($cursorPosition.Item1,$cursorPosition.Item2)
        [Console]::CursorVisible = $true
    }
}

function DrawArray {
    param (
        [char[]] $boxes,
        [int]    $column,
        [int]    $offset = 0,
        [int]    $sleep = 2
    )
    
    try {
        $cursorPosition = [Console]::GetCursorPosition()
        [Console]::CursorVisible = $false
        for ($i = 0; $i -lt $boxes.Length; $i++) {
            Start-Sleep -Milliseconds $sleep
            [Console]::SetCursorPosition([System.Console]::BufferWidth - 3 - ($column * 4), [System.Console]::BufferHeight - 1 - $i - $offset)
            if ($boxes[$i]) {
                Write-Host -NoNewline "[$($boxes[$boxes.Length - 1 - $i])]"
            } else {
                Write-Host -NoNewline "   "
            }
        }
    } finally {
        [Console]::SetCursorPosition($cursorPosition.Item1,$cursorPosition.Item2)
        [Console]::CursorVisible = $true
    }
}

Get-Content $FileName
# | Select-Object -First 11
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

            PrintElements
        } else {
            $patternStackMatches.Add($Matches)
        }
    } elseif ($_ -match $patternAction) {
        $numberOfBoxes = [int]$Matches[1]
        $from          = $elements[[int]$Matches[2] - 1]
        $to            = $elements[[int]$Matches[3] - 1]
        $buffer        = New-Object char[] $numberOfBoxes
        $emptyBuffer   = New-Object char[] $numberOfBoxes

        for ($i = 0; $i -lt $buffer.Count; $i++) {
            $buffer[$i] = $from.Pop()
        }

        for ($i = $buffer.Count - 1; $i -ge 0 ; $i--) {
            $to.Push($buffer[$i])
        }

        DrawArray -boxes $emptyBuffer -column (10 - [int]$Matches[2] - 1) -offset (-3+$buffer.Count) -sleep 200
        DrawArray -boxes $buffer      -column (10 - [int]$Matches[3] - 1) -offset (3+$buffer.Count) -sleep 200
    }
}


# Throw away any keyboard input during animation
while ($Host.UI.RawUI.KeyAvailable) {
    $host.ui.rawui.readkey("NoEcho,IncludeKeyup") | Out-Null
}
# [Console]::SetCursorPosition(0, $cursorTop)
# [Console]::CursorVisible = $true
# PrintElements

[Console]::SetCursorPosition($cursorPosition.Item1,$cursorPosition.Item2)