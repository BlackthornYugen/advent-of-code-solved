#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/3.input"
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

$result = [PSCustomObject]@{
    SumOfPriorities = 0
    SumOfBadges     = 0
}

# Keep a buffer of 2 rucksacks so that we can compare every third one.
$rucksackBuffer = New-Object Collections.Generic.List[PSCustomObject](2)

Write-Debug "Item`tPriority"

Get-Content $FileName | ForEach-Object {
    $rucksack = [PSCustomObject]@{ 
        Compartments = $_.Substring(0, $_.Length / 2), $_.Substring($_.Length / 2)
        MisidentifiedItem = $null
        OrganizationPriority = 0
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
            }
        }
    }
    Write-Debug "$($rucksack.MisidentifiedItem)`t$($rucksack.OrganizationPriority)"
    
    $result.SumOfPriorities += $rucksack.OrganizationPriority

    # Calculate badge values for every third rucksack
    if ($rucksackBuffer.Count -eq $rucksackBuffer.Capacity) {
        for ($i = 0; $i -lt $_.Length; $i++)
        {
            if (
                ($rucksackBuffer 
                | ForEach-Object { $_.Compartments -join '' } 
                | Select-String -Pattern $_[$i] -CaseSensitive 
                | Measure-Object 
                | ForEach-Object Count) -eq 2
            )
            {
                $item = $_[$i]
                $badgeValue = Get-Priority $item
                Write-Debug "$item*`t$badgeValue"
                $result.SumOfBadges += $badgeValue
                break
            }
        }
        $rucksackBuffer.Clear()
    } 
    else 
    {
        $rucksackBuffer.add($rucksack)
    }
}

$result
