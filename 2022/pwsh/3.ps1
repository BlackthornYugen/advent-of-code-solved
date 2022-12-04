#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/input.3"
)

function Get-Priority() {
    param (
        [char]$Item
    )

    $asciiValue = [int]$Item

    if ( $asciiValue -ge [int]([char]"a") -And $asciiValue -le [int]([char]"z") )
    {
        return 1 + $asciiValue - [int]([char]"a")
    }

    if ( $asciiValue -ge [int]([char]"A") -And $asciiValue -le [int]([char]"Z") )
    {
        return 1 + 26 + $asciiValue - [int]([char]"A")
    }

    throw "Invalid item"
}

$sumOfPriorities = 0

Write-Debug "Item`tPriority"
Get-Content $FileName | Select-Object | ForEach-Object {
    $rucksack = [PSCustomObject]@{ 
        Compartments = $_.Substring(0, $_.Length / 2), $_.Substring($_.Length / 2)
        MisidentifiedItem = $null
        OrganizationPriority = 0
    }


    if (!$rucksack)
    {
        continue
    }

    
    for ($i = 0; $i -lt $rucksack.Compartments.Length; $i++) 
    {
        for ($j = 0; $j -lt $rucksack.Compartments[$i].Length; $j++)
        {
            # Check other compartment for the item
            if ($rucksack.Compartments[$i % 1].Contains($rucksack.Compartments[$i][$j]))
            {
                $rucksack.MisidentifiedItem = $rucksack.Compartments[$i][$j]
                $rucksack.OrganizationPriority = Get-Priority $rucksack.MisidentifiedItem
                break
            }
        }

    }
    Write-Debug "$($rucksack.MisidentifiedItem)`t$($rucksack.OrganizationPriority)"
    $sumOfPriorities += $rucksack.OrganizationPriority
}

$sumOfPriorities