#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/5.input"
)

$patternStack = '^.([1A-Z ]). .([2A-Z ]). .([3A-Z ]). .([4A-Z ]). .([5A-Z ]). .([6A-Z ]). .([7A-Z ]). .([8A-Z ]). .([9A-Z ]).'
$patternStackMatches = New-Object System.Collections.Generic.List[Hashtable]
$patternAction = 'move (\d+) from (\d+) to (\d+)'
$elements = New-Object System.Collections.Generic.Stack[char][] 9

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
        $_

        $numberOfBoxes = [int]$Matches[1]
        $from          = $elements[[int]$Matches[2] - 1]
        $to            = $elements[[int]$Matches[3] - 1]

        for ($i = 0; $i -lt $numberOfBoxes; $i++) {
            $to.push($from.Pop())
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
