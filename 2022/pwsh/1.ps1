#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/input.2"
)

$content = Get-Content $FileName
$elf_calories = New-Object Collections.Generic.List[Int]
$elf_calories.Add(0)
$highest_cals = (-1, -1, -1)
foreach ($line in $content) {
    $elf_index = $elf_calories.Count - 1
    if ($line -match ".") {
        $elf_calories[$elf_index] += $line
    }
    else {
        for ($i = 0; $i -lt $highest_cals.Count; $i++) {
            if ( $elf_calories[$elf_index] -gt $highest_cals[$i] ) {
                $highest_cals[$i] = $elf_calories[$elf_index]
                
                # Re-sort the list so that we are always replacing the elf with the fewest calories
                $highest_cals = $highest_cals | Sort-Object
                break
            }
        }
        $elf_index++
        $elf_calories.Add(0);
    }
}

$total = 0
$highest_cals | ForEach-Object { $total += $_ }
$total