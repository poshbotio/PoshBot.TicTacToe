
function NewGame {
    param(
        [parameter(Mandatory)]
        [string]$PlayerX,

        [parameter(Mandatory)]
        [string]$PlayerO
    )

    [pscustomobject]@{
        Started = $true
        PlayerX = $PlayerX
        PlayerO = $PlayerO
        CurrentTurn = 'X'
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
        Stats = [pscustomobject]@{
            PlayerXWins = 0
            PlayerOWins = 0
            Ties = 0
        }
    }
}
