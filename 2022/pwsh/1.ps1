#/usr/bin/env pwsh

$content = Get-Content ../input.1
$elf_callories = New-Object Collections.Generic.List[Int]
$elf_callories.Add(0)
$highest_cals = (-1, -1, -1)
foreach ($line in $content) {
    $elf_index = $elf_callories.Count - 1
    if ($line -match ".") {
        $elf_callories[$elf_index] += $line
    }
    else {
        for ($i = 0; $i -lt $highest_cals.Count; $i++) {
            if ( $elf_callories[$elf_index] -gt $highest_cals[$i] ) {
                $highest_cals[$i] = $elf_callories[$elf_index]
                
                # Re-sort the list so that we are always replacing the elf with the fewest calories
                $highest_cals = $highest_cals | Sort-Object
                break
            }
        }
        $elf_index++
        $elf_callories.Add(0);
    }
}

$total = 0
$highest_cals | ForEach-Object { $total += $_ }
$total