
function CheckWinner {
    [cmdletbinding()]
    param(
        [pscustomobject]$Game
    )

    'X', 'O' | Foreach-Object {

        # Look for winner vertically
        if (($Game.Grid.A1 -eq $_) -and ($Game.Grid.B1 -eq $_) -and ($Game.Grid.C1 -eq $_)) {
            return $_
        }
        if (($Game.Grid.A2 -eq $_) -and ($Game.Grid.B2 -eq $_) -and ($Game.Grid.C2 -eq $_)) {
            return $_
        }
        if (($Game.Grid.A3 -eq $_) -and ($Game.Grid.B3 -eq $_) -and ($Game.Grid.C3 -eq $_)) {
            return $_
        }

        # Look for winner horizontally
        if (($Game.Grid.A1 -eq $_) -and ($Game.Grid.A2 -eq $_) -and ($Game.Grid.A3 -eq $_)) {
            return $_
        }
        if (($Game.Grid.B1 -eq $_) -and ($Game.Grid.B2 -eq $_) -and ($Game.Grid.B3 -eq $_)) {
            return $_
        }
        if (($Game.Grid.C1 -eq $_) -and ($Game.Grid.C2 -eq $_) -and ($Game.Grid.C3 -eq $_)) {
            return $_
        }

        # Look for winner diagonally
        if (($Game.Grid.A1 -eq $_) -and ($Game.Grid.B2 -eq $_) -and ($Game.Grid.C3 -eq $_)) {
            return $_
        }
        if (($Game.Grid.A3 -eq $_) -and ($Game.Grid.B2 -eq $_) -and ($Game.Grid.C1 -eq $_)) {
            return $_
        }
    }
}
