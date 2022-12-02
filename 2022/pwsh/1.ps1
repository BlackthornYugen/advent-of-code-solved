#/usr/bin/env pwsh

$content = Get-Content ../input.1
$elf_callories = New-Object Collections.Generic.List[Int]
$elf_callories.Add(0)
$highest_cals = -1
$highest_cals_index = -1
foreach($line in $content) {
    $elf_index = $elf_callories.Count - 1
    if($line -match ".") {
        $elf_callories[$elf_index]+=$line
    } else {
        if ( $elf_callories[$elf_index] -gt $highest_cals ) {
            $highest_cals = $elf_callories[$elf_index]
            $highest_cals_index = $elf_index
        }
        $elf_index++
        $elf_callories.Add(0);
    }
}

$highest_cals