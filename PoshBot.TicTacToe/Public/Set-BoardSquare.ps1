
function Set-BoardSquare {
    [PoshBot.BotCommand(
        aliases = ('mark')
    )]
    [cmdletbinding()]
    param(
        [parameter(mandatory)]
        [ValidateSet('A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3')]
        [string]$Location,

        [parameter(mandatory)]
        [string]$Against
    )

    # Unique key for these players
    if ($global:PoshBotContext.FromName) {
        $thisPlayer = $global:PoshBotContext.FromName
    } else {
        $thisPlayer = $global:PoshBotContext.From
    }
    $thatPlayer = $Against
    $key = ($thisPlayer, $thatPlayer | Sort-Object) -Join '_'

    # Get or initialize stats
    if (-not ($stats = Get-PoshBotStatefulData -Name Stats -ValueOnly)) {
        $stats = @{}
        $stats.Add($thisPlayer, [pscustomobject]@{Wins = 0; Losses = 0; Ties = 0})
        $stats.Add($thatPlayer, [pscustomobject]@{Wins = 0; Losses = 0; Ties = 0})
        Set-PoshBotStatefulData -Name Stats -Value $stats -Depth 20
    }

    if ($games = Get-PoshBotStatefulData -Name Games -ValueOnly) {
        if ($game = $games[$key]) {

            # Validate correct player
            $playerX = $game.PlayerX
            $playerO = $game.PlayerO
            $player = if ($thisPlayer -eq $playerX) { 'X' } else { 'O' }

            $currentTurnName = if ($game.CurrentTurn -eq 'X') { $playerX } else { $playerO }
            if ($player -ne $game.CurrentTurn) {
                Write-Error "Cool your jets. It is $($currentTurnName)'s turn."
                return
            }

            # Validate open square
            if ($game.Grid[$Location] -ne ' ') {
                New-PoshBotCardResponse -Type Warning -Text "Square [$Location] is already taken"
                return
            }

            # Mark the square
            $game.Grid[$Location] = $player

            # Switch turns
            if ($game.CurrentTurn -eq 'X') {
                $game.CurrentTurn = 'O'
            } else {
                $game.CurrentTurn = 'X'
            }

            # Determine winner
            if ($winner = CheckWinner -Game $game) {
                $game.Winner = $winner
                if ($winner -eq 'X') {
                    $stats[$playerX].Wins += 1
                    $stats[$PlayerO].Losses += 1
                } else {
                    $stats[$playerO].Wins += 1
                    $stats[$PlayerX].Losses += 1
                }
            }

            $game.Moves++

            # Determine if tie
            if ([string]::IsNullOrEmpty($game.Winner) -and $game.Moves -eq 9) {
                $game.Tie = $true
                $stats[$playerX].Ties += 1
                $stats[$playerO].Ties += 1
            }

            $grid = RenderGrid -Game $game
            New-PoshBotTextResponse -Text $grid -AsCode

            #$games[$key] = $game

            if ($game.Winner -or $game.Tie) {
                $games.Remove($key)
            }

            Set-PoshBotStatefulData -Value $games -Name Games -Depth 20
            Set-PoshBotStatefulData -Value $stats -Name Stats -Depth 20
        } else {
            New-PoshBotCardResponse -Type Warning -Text "There is no active game with [$thisPlayer] vs [$thatPlayer]. To start one, run the [New-TicTacToeGame] command."
        }
    } else {
        New-PoshBotCardResponse -Type Warning -Text "There is no active game with [$thisPlayer] vs [$thatPlayer]. To start one, run the [New-TicTacToeGame] command."
    }
}
