
function RenderGrid {
    [cmdletbinding()]
    param(
        [pscustomobject]$Game
    )

    $grid = [string]::Empty

    $grid += "Player X: $($Game.PlayerX)`n"
    $grid += "Player O: $($Game.PlayerO)`n`n"

    # Row 1
    $grid += "    1     2     3`n"
    $grid += "       |     |`n"
    $grid += "A   $($Game.Grid.A1)  |  $($Game.Grid.A2)  |  $($Game.Grid.A3)  `n"
    $grid += "  _____|_____|_____`n"

    # Row 2
    $grid += "       |     |`n"
    $grid += "B   $($Game.Grid.B1)  |  $($Game.Grid.B2)  |  $($Game.Grid.B3)  `n"
    $grid += "  _____|_____|_____`n"

    # Row 3
    $grid += "       |     |`n"
    $grid += "C   $($Game.Grid.C1)  |  $($Game.Grid.C2)  |  $($Game.Grid.C3)  `n"
    $grid += "       |     |"

    if (([string]::IsNullOrEmpty($Game.Winner) -and (-not $Game.Tie))) {
        $player = $Game."Player$($($Game.CurrentTurn))"
        $grid += "`n`nCurrent Turn: $player"
    } elseIf ($Game.Tie) {
        $grid += "`n`n======================================================================`n`n"
        $grid += "  Game ended in a tie. I guess the only winning move is not to play.`n`n"
        $grid += "  Stats:`n`n"
        $grid += "  Player X Wins | Player O Wins | Ties`n"
        $grid += "  ------------------------------------`n"
        $grid += "  $($Game.Stats.PlayerXWins)               $($Game.Stats.PlayerOWins)               $($Game.Stats.Ties)`n`n"
        $grid += "======================================================================`n"
    } elseIf ($Game.Winner) {
        $winner = $Game."Player$($($Game.Winner))"
        $m = "  Alright $winner! You won!`n"
        $grid += "`n`n$('=' * ($m.Length + 1))`n"
        $grid += $m
        $grid += "$('=' * ($m.Length + 1))"
    }

    $grid
}
