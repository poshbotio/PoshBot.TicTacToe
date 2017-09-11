$script:State = @{
    Started = $false
    PlayerX = [string]::empty
    PlayerO = [string]::empty
    CurrentTurn = [string]::empty
    Winner = [string]::empty    
    Tie = $false
    Moves = 0
    Grid = @{
        A1 = ' '
        A2 = ' '
        A3 = ' '
        B1 = ' '
        B2 = ' '
        B3 = ' '
        C1 = ' '
        C2 = ' '
        C3 = ' '
    }
    Stats = @{
        PlayerXWins = 0
        PlayerOWins = 0
        Ties = 0
    }
}

$currentPlayer = $State.PlayerX

function StartGame {
    [cmdletbinding()]
    param(
        [parameter(mandatory)]
        [string]$PlayerX,

        [parameter(mandatory)]
        [string]$PlayerO
    )

    $script:State.Started = $true
    $script:State.PlayerX = $PlayerX
    $script:State.PlayerO = $PlayerO
    $script:State.CurrentTurn = 'X'
    $script:State.Winner = [string]::empty    
    $script:State.Tie = $false
    $script:State.Moves = 0
    $script:State.Grid = @{
        A1 = ' '
        A2 = ' '
        A3 = ' '
        B1 = ' '
        B2 = ' '
        B3 = ' '
        C1 = ' '
        C2 = ' '
        C3 = ' '                
    }

    Write-Output "Starting new game!`n"
    WriteGrid    
}

function WriteGrid {

    $grid = [string]::Empty

    $grid += "Player X: $($script:State.PlayerX)`n"
    $grid += "Player O: $($script:State.PlayerO)`n`n"

    # Row 1
    $grid += "    1     2     3`n"
    $grid += "       :     :`n"
    $grid += "A   $($script:State.Grid.A1)  :  $($script:State.Grid.A2)  :  $($script:State.Grid.A3)  `n"
    $grid += "  _____:_____:_____`n"

    # Row 2
    $grid += "       :     :`n"
    $grid += "B   $($script:State.Grid.B1)  :  $($script:State.Grid.B2)  :  $($script:State.Grid.B3)  `n"
    $grid += "  _____:_____:_____`n"

    # Row 3
    $grid += "       :     :`n"
    $grid += "C   $($script:State.Grid.C1)  :  $($script:State.Grid.C2)  :  $($script:State.Grid.C3)  `n"
    $grid += "       :     :"

    if (([string]::IsNullOrEmpty($script:State.Winner) -and (-not $script:State.Tie))) {
        $player = $script:State."Player$($($script:State.CurrentTurn))"
        $grid += "`n`nCurrent Turn: $player"
    } elseIf ($script:State.Tie) {
        $grid += "`n`n======================================================================`n`n"
        $grid += "  Game ended in a tie. I guess the only winning move is not to play.`n`n"
        $grid += "  Stats`n`n"
        $grid += "  Player X Wins | Player O Wins | Ties`n"
        $grid += "  ------------------------------------`n"
        $grid += "  $($script:State.Stats.PlayerXWins)               $($script:State.Stats.PlayerOWins)               $($script:State.Stats.Ties)`n`n"
        $grid += "======================================================================`n"
    } elseIf ($script:State.Winner) {
        $winner = $script:State."Player$($($script:State.Winner))"
        $m = "  Alright $winner! You won!`n"
        $grid += "`n`n$('=' * ($m.Length + 1))`n"
        $grid += $m
        $grid += "$('=' * ($m.Length + 1))"
    }

    Write-Host $grid
}

function Set-BoardSquare {
    [cmdletbinding()]
    param(
        [parameter(mandatory)]
        [ValidateSet('A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3')]
        [string]$Location,
        
        [parameter(mandatory)]
        [ValidateSet('X', 'O')]        
        [string]$Player
    )  

    # Validate game is in progress
    if (-not $script:State.Started) {
        Write-Error 'Game has not started yet. Run Start-Game first.'
        return
    }

    # Validate no winner or tie
    if (-not [string]::IsNullOrEmpty($script:State.Winner) -or ($script:State.Tie)) {
        Write-Error "This game is finished. [$($script:State.Winner)] won in [$($script:state.Moves)] moves."
        return
    }   

    # Validate correct player
    if ($Player -ne $script:State.CurrentTurn) {
        Write-Error "Cool your jets. It is Player $($script:State.CurrentTurn)'s turn."
        return
    }    

    # Validate open square
    if ($script:State.Grid[$Location] -ne ' ') {
        Write-Error "Square [$_] is already taken"
        return
    }     

    $script:State.Grid[$Location] = $player
    
    if ($script:State.CurrentTurn -eq 'X') {
        $script:State.CurrentTurn = 'O'
    } else {
        $script:State.CurrentTurn = 'X'
    }
   
    CheckWinner

    $script:State.Moves++

    CheckTie

    WriteGrid
    
    if ($script:State.Winner -or $script:State.Tie) {
        Reset-Game
    }
}

function Reset-Game {
    [cmdletbinding()]
    param()
    
    $script:State.Started = $false
    $script:State.PlayerX = [string]::empty
    $script:State.PlayerO = [string]::empty
    $script:State.CurrentTurn = [string]::empty
    $script:State.Winner = [string]::empty    
    $script:State.Tie = $false
    $script:State.Moves = 0
    $script:State.Grid = @{
        A1 = ' '
        A2 = ' '
        A3 = ' '
        B1 = ' '
        B2 = ' '
        B3 = ' '
        C1 = ' '
        C2 = ' '
        C3 = ' '        
    }
}

# Example grid and determine winner
function CheckWinner {
    [cmdletbinding()]
    param()
        
    'X', 'O' | Foreach-Object {
            
        # Look for winner vertically
        if (($script:State.Grid.A1 -eq $_) -and ($script:State.Grid.B1 -eq $_) -and ($script:State.Grid.C1 -eq $_)) {
            $script:State.Winner = $_
            return
        }
        if (($script:State.Grid.A2 -eq $_) -and ($script:State.Grid.B2 -eq $_) -and ($script:State.Grid.C2 -eq $_)) {
            $script:State.Winner = $_
            return
        }
        if (($script:State.Grid.A3 -eq $_) -and ($script:State.Grid.B3 -eq $_) -and ($script:State.Grid.C3 -eq $_)) {
            $script:State.Winner = $_
            return
        }

        # Look for winner horizontally
        if (($script:State.Grid.A1 -eq $_) -and ($script:State.Grid.A2 -eq $_) -and ($script:State.Grid.A3 -eq $_)) {
            $script:State.Winner = $_
            return
        }
        if (($script:State.Grid.B1 -eq $_) -and ($script:State.Grid.B2 -eq $_) -and ($script:State.Grid.B3 -eq $_)) {
            $script:State.Winner = $_
            return
        }
        if (($script:State.Grid.C1 -eq $_) -and ($script:State.Grid.C2 -eq $_) -and ($script:State.Grid.C3 -eq $_)) {
            $script:State.Winner = $_
            return
        }

        # Look for winner diagonally
        if (($script:State.Grid.A1 -eq $_) -and ($script:State.Grid.B2 -eq $_) -and ($script:State.Grid.C3 -eq $_)) {
            $script:State.Winner = $_
            return
        }
        if (($script:State.Grid.A3 -eq $_) -and ($script:State.Grid.B2 -eq $_) -and ($script:State.Grid.C1 -eq $_)) {
            $script:State.Winner = $_
            return
        }
    }

    # Upate game stats
    if ($script:State.Winner) {
        $script:State.Stats."Player$($($script:State.Winner))Wins" += 1
    }
}

# Examine grid and determine if tie
function CheckTie {
    if ([string]::IsNullOrEmpty($script:State.Winner) -and $script:State.Moves -eq 9) {
        $script:State.Tie = $true

        # Upate game stats
        $script:State.Stats.Ties++    
    }
}