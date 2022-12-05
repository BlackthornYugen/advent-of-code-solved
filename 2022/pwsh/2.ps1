#/usr/bin/env pwsh

param (
    [string]$FileName = "./2022/2.input"
)

$Shapes = @{ 
    'A' = 'Rock'
    'B' = 'Paper'
    'C' = 'Scissors'
}

$Strategies = @{
    'X' = 'Lose'
    'Y' = 'Draw'
    'Z' = 'Win'
}

$Shape_Scores = @{ 
    'Rock'     = 1
    'Paper'    = 2
    'Scissors' = 3
}

$Victory_Conditions = @{
    'Rock'     = 'Scissors' # rock crushes scissors 
    'Paper'    = 'Rock'     # paper covers rock
    'Scissors' = 'Paper'    # scissors cuts paper
}

function Pick_Shape() {
    param (
        [Parameter(Mandatory=$true)]
        $Opponent_Shape_Name,
        [Parameter(Mandatory=$true)]
        $Strategy
    )

    if ($Strategy -eq 'Win') {
        $Player_Shape_Name = $Victory_Conditions.GetEnumerator() `
            | Where-Object -Property Value -eq $Opponent_Shape_Name `
            | Select-Object -First 1 `
            | ForEach-Object Name
    } elseif ($Strategy -eq 'Lose') {
        $Player_Shape_Name = $Victory_Conditions[$Opponent_Shape_Name]
    } else {
        $Player_Shape_Name = $Opponent_Shape_Name
    }

    # Return shape code from shape name
    return $Player_Shape_Name

}

function Resolve-Game {
    param (
        [string]$game_input
    )

    $result = [PSCustomObject]@{ 
        Score   = 0
        Outcome = ""
        Description = ""
    }
    
    $Opponent_Shape_Code, $Strat = $game_input.Split(" ")
    $Opponent = $Shapes[$Opponent_Shape_Code]
    $Strategy = $Strategies[$Strat]

    if (!$Opponent) {
        throw "$Opponent is an invalid shape!"
    }

    if (!$Strategy) {
        throw "$Strat an invalid stratagy!"
    }

    $Player = Pick_Shape $Opponent $Strategy

    if (!$Player) {
        throw "Failed to select a move!"
    }

    $result.Score += $Shape_Scores[$Player]

    if ($Player -eq $Opponent) {
        $result.Description = "Both picked $Opponent."
        $result.Outcome = "Draw!"
        $result.Score += 3
    } elseif ($Victory_Conditions[$Opponent] -eq $Player) {
        $result.Description = "$Opponent beats $Player."
        $result.Outcome = "Defeat!"
    } else {
        $result.Description = "$Player beats $Opponent."
        $result.Outcome = "Victory!"
        $result.Score += 6
    }
    Write-Debug "$Opponent`t$($Strategies[$Strat])`t$Player`t$($result.Score)`t$($result.Outcome) $($result.Description)" 
    $result
}

function Get-Score {
    $Total = 0
    Write-Debug "Opponent`tStrat`tPlayer`tScore`tResult" 
    Get-Content $FileName | ForEach-Object{$Total += (Resolve-Game($_)).Score}
    $Total
}

Get-Score
