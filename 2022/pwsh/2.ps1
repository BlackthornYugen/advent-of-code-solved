#/usr/bin/env pwsh

param (
    [string]$FileName = "../input.2"
)

$shapes = @{ 
    'A' = 'Rock'
    'B' = 'Paper'
    'C' = 'Scissors'
    'X' = 'Rock'
    'Y' = 'Paper'
    'Z' = 'Scissors'
}

$shape_scores = @{ 
    'Rock'     = 1
    'Paper'    = 2
    'Scissors' = 3
}

$victory_conditions = @{
    'Rock'     = 'Scissors' # rock crushes scissors 
    'Paper'    = 'Rock'     # paper covers rock
    'Scissors' = 'Paper'    # scissors cuts paper
}

function Resolve-Game {
    param (
        [string]$game_input
    )
    
    $result = [PSCustomObject]@{ 
        Score   = 0
        Outcome = "" 
    }
    
    $player_1, $player_2 = $game_input.Split(" ")

    if (!$shapes[$player_1]) {
        throw "$player_1 is an invalid shape!"
    }

    if (!$shapes[$player_2]) {
        throw "$player_2 is an invalid shape!"
    }

    $result.Score += $shape_scores[$shapes[$player_1]]

    if ($shapes[$player_1] -eq $shapes[$player_2]) {
        $result.Outcome = "Draw!"
        $result.Score += 3
    } elseif ($shapes[$player_2] -eq $victory_conditions[$shapes[$player_1]]) {
        $result.Outcome = "Victory!"
        $result.Score += 6
    } else {
        $result.Outcome = "Defeat!"
    }
    $result
}

function Get-Score {
    $Total = 0
    Get-Content $FileName | ForEach-Object{$Total += (Resolve-Game($_)).Score}
    $Total
}

Get-Score