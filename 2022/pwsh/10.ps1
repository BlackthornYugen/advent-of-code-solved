#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/10.input"
)


function Step-Tube() 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, valueFromPipeline)]
        [String] $Line
    )

    begin {
        $Signals = [System.Collections.ObjectModel.Collection[System.Tuple[int, int]]]::new()
        $Signals.Add([System.Tuple]::Create(0, 1))
        $ClockCycle = 1
    }

    process {
        if ($_ -match "^(addx|noop) ?(-?\d+)?") {
            [string]$instruction = $Matches[1]
            
            switch ($instruction) {
                addx { $ClockCycle += 2 ; $Signals.Add([System.Tuple]::Create($ClockCycle, [int]::Parse($Matches[2]))) }
                noop { $ClockCycle++ }
                Default { throw "Unknown instruction `"$_`"" }
            }
        }
    }

    end {
        return $Signals
    }
}

$Cycles = Get-Content $FileName | Step-Tube 

$sampleCycles = 20, 60, 100, 140, 180, 220

$answer = 0
foreach ($sampleCycle in $sampleCycles) {
    $unprocessedSignal = ($Cycles 
    | Where-Object -Property Item1 -LE $sampleCycle
    | Measure-Object -Sum -Property Item2 
    | ForEach-Object Sum)
    $signal = $unprocessedSignal * $sampleCycle
    Write-Debug "$sampleCycle`t$unprocessedSignal`t$signal"
    $answer += $signal
}
$answer