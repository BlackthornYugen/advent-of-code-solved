#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/5.input"
)

$patternCapture = '^.([A-Z ]). .([A-Z ]). .([A-Z ]). .([A-Z ]). .([A-Z ]). .([A-Z ]). .([A-Z ]). .([A-Z ]). .([A-Z ]).'
$patternAction = 'move (\d+) from (\d+) to (\d+)'
# $cursorTop = [Console]::GetCursorPosition().Item2
$workspace = "`n`n`n`n`n`n`n`n`n`n`n`n"
# [Console]::CursorVisible = $false
$elements = New-Object System.Collections.Generic.Stack[char][] 9

for ($i = 0; $i -lt $elements.Count; $i++) {
    $elements[$i] = New-Object System.Collections.Generic.Stack[char]
}


Get-Content $FileName
| ForEach-Object {
    if (!$workspaceComplete) {
        $workspace += "$_`n"
        if ($_ -match $patternCapture ) {
            for ($i = 1; $i -lt $elements.Count; $i++) {
                $elements[$i].Push($Matches[$i + 1]) | Out-Null
            }
        }
    } elseif ($_ -match $patternAction) {
        $_
        # [Console]::SetCursorPosition(0, $cursorTop)
        # Write-Host -NoNewLine "x"
        # [Console]::SetCursorPosition(5, $cursorTop)
        # Write-Host -NoNewLine "y"
    }
}


# Throw away any keyboard input during animation
while ($Host.UI.RawUI.KeyAvailable) {
    $host.ui.rawui.readkey("NoEcho,IncludeKeyup") | Out-Null
}
# [Console]::SetCursorPosition(0, $cursorTop)
# [Console]::CursorVisible = $true

$elements