#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/11.input",
    [int]$RoundCount = 20,
    [bool]$WorriesManaged = $true
)

class Monkey {
    [int] $Divisor
    [Collections.Generic.List[bigint]] $Items
    [int[]] $Friends
    [char] $Operator
    [string] $Operand
    [int] $ItemsHandled = 0

    Monkey ([int]$Divisor,[int[]]$Friends,[String]$Operation,[int[]]$Items) {
        $this.Divisor = $Divisor
        $this.Friends = $Friends

        if ($Operation -match '^new = old (.) (old|\d+)$') 
        {
            $this.Operator = $Matches[1]
            $this.Operand  = $Matches[2]
        } else {
            throw "Unexpected operation: $Operation"
        }

        $this.Items = New-Object 'Collections.Generic.List[System.Numerics.BigInteger]'
        foreach ($Item in $Items) {
            $this.Items.Add($Item)
        }
    }
}

function Parse-Monkeys() 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, valueFromPipeline)]
        [String] $Line
    )

    begin {
        $Monkeys = [Collections.Generic.List[Monkey]]::new()
        [int[]] $items = $null
        [string] $opteration = $null
        [string] $divisor = 0
        [int] $trueFriend = -1
        [int] $falseFriend = -1
    }

    process {
        if (( $null -ne $items        ) -and
            ( $null -ne $opteration   ) -and
            (  0    -ne $divisor      ) -and
            ( -1    -ne $trueFriend   ) -and
            ( -1    -ne $falseFriend  ))
        {
            $Monkeys.Add([Monkey]::New($divisor, ($trueFriend, $falseFriend), $opteration, $items))
            $items = $null
            $opteration = $null
            $divisor = 0
            $trueFriend = -1
            $falseFriend = -1
        }
        elseif ($Line -match "Starting items:([0-9\, ]+)$") 
        {
            $items = $Matches[1].split(", ")
            Write-Debug "items: $items"
        }
        elseif ($Line -match "Operation: (.*)$") 
        {
            $opteration = $Matches[1]
            Write-Debug "operation: $opteration"
        }
        elseif ($Line -match "Test: divisible by (\d+)$")
        {
            $divisor = $Matches[1]
            Write-Debug "divisor: $divisor"
        }
        elseif ($Line -match "If (true|false): throw to monkey (\d+)$")
        {
            $condition = $Matches[1]
            if ($condition -eq "true")
            {
                $trueFriend = $Matches[2]
            }
            else 
            {
                $falseFriend = $Matches[2]
            }
            Write-Debug "condition: $condition"
        }
    }

    end {
        if (( $null -ne $items        ) -and
            ( $null -ne $opteration   ) -and
            (  0    -ne $divisor      ) -and
            ( -1    -ne $trueFriend   ) -and
            ( -1    -ne $falseFriend  ))
        {
            $Monkeys.Add([Monkey]::New($divisor, ($trueFriend, $falseFriend), $opteration, $items))
            $items = $null
            $opteration = $null
            $divisor = 0
            $trueFriend = -1
            $falseFriend = -1
        }

        return $Monkeys
    }
}

function Step-Turn() {
    param (
        [Collections.Generic.List[Monkey]] $Monkeys
    )

    for ($m = 0; $m -lt $Monkeys.Count; $m++) {
        $activeMonkey = $Monkeys[$m]
        for ($i = 0; $i -lt $activeMonkey.Items.Count; $i++) {
            $item = $activeMonkey.Items[$i]
            if ($activeMonkey.Operator -eq "*") 
            {
                if ($activeMonkey.Operand -eq "old") 
                {
                    $item *= $item
                }
                else {
                    $item *= [int]$activeMonkey.Operand
                }
            }
            elseif ($activeMonkey.Operator -eq "+" ) 
            {
                if ($activeMonkey.Operand -eq "old") 
                {
                    $item += $item
                }
                else {
                    $item += [int]$activeMonkey.Operand
                }
            }
            Write-Debug "$m inspects item with worry level of $item"

            if ($WorriesManaged) {
                $item = [Math]::Floor($item / 3)
                Write-Debug "Monkey gets bored with item. Worry level is divided by 3 to $item."
            }

            if (($item % $activeMonkey.Divisor) -eq 0)
            {
                $recipientMonkey = $activeMonkey.Friends[0]
            }
            else
            {
                $recipientMonkey = $activeMonkey.Friends[1]
            }

            $Monkeys[$recipientMonkey].Items.Add($item)
            Write-Debug "item with worry level of $item thrown to $recipientMonkey"
        }
        $activeMonkey.ItemsHandled += $activeMonkey.Items.Count
        $activeMonkey.Items.Clear()
    }
}

$Monkeys = Get-Content $FileName | Where-Object { $_.Length -gt 0 } | Parse-Monkeys

for ($i = 0; $i -lt $RoundCount ; $i++) {
    Write-Progress `
        -Id 1 `
        -Activity "Processing turn" `
        -Status "$i of $RoundCount" `
        -PercentComplete ([Math]::Max(1,[Math]::Min(100, $i / $RoundCount * 100)))
    Step-Turn $Monkeys
}

# Part 1
$monkeyBusiness = 1
$Monkeys | Sort-Object -Property ItemsHandled -Descending -Top 2 | ForEach-Object {
    $monkeyBusiness *= $_.ItemsHandled
}


Write-Progress `
-Id 1 `
-Activity "Processing turn" `
-Completed

[PSCustomObject]@{
    MonkeyBusiness = $monkeyBusiness
    Monkeys = $Monkeys
}
