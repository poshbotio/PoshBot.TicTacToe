
function New-TicTacToeGame {
    [PoshBot.BotCommand(
        aliases = ('newtictactoe')
    )]
    [cmdletbinding()]
    param(
        [parameter(mandatory)]
        [string]$Against,

        [switch]$Force
    )

    if ($global:PoshBotContext.FromName) {
        $playerX = $global:PoshBotContext.FromName
    } else {
        $playerX = $global:PoshBotContext.From
    }
    $playerO = $Against

    # Unique key for these players
    $key = ($PlayerX, $PlayerO | Sort-Object) -Join '_'

    # Get or initialize stats
    if (-not ($stats = Get-PoshBotStatefulData -Name Stats -ValueOnly)) {
        $stats = @{}
        $stats[$playerX] = [pscustomobject]@{Wins = 0; Losses = 0; Ties = 0}
        $stats[$playerO] = [pscustomobject]@{Wins = 0; Losses = 0; Ties = 0}
        Set-PoshBotStatefulData -Name Stats -Value $stats -Depth 10
    }

    if ($games = Get-PoshBotStatefulData -Name Games -ValueOnly) {
        if ($games.ContainsKey($key)) {
            if ($Force) {
                Write-Output "Starting new game!`n"
                $game = NewGame -PlayerX $playerX -PlayerO $playerO
                $games[$key] = $game
                Set-PoshBotStatefulData -Value $games -Name Games -Depth 20
                $grid = RenderGrid -Game $game
                New-PoshBotTextResponse -Text $grid -AsCode
            } else {
                New-PoshBotCardResponse -Type Warning -Text "There is currently an active game with $Against. Complete that game before creating a new one, or use the -Force switch to reset your active game."
            }
        } else {
            # No current game against these players. Create one
            Write-Output "Starting new game!`n"
            $game = NewGame -PlayerX $playerX -PlayerO $playerO
            $games[$key] = $game
            Set-PoshBotStatefulData -Value $games -Name Games -Depth 20
            $grid = RenderGrid -Game $game
            New-PoshBotTextResponse -Text $grid -AsCode
        }
    } else {
        # No games are currently stored
        Write-Output "Starting new game!`n"
        $games = @{
            stub = 'DO NOT DELETE ME'
        }
        $game = NewGame -PlayerX $playerX -PlayerO $playerO
        $games[$key] = $game
        Set-PoshBotStatefulData -Value $games -Name Games -Depth 20
        $grid = RenderGrid -Game $game
        New-PoshBotTextResponse -Text $grid -AsCode
    }
}
