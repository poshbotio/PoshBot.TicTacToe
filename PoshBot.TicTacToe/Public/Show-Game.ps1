
function Show-Game {
    [PoshBot.BotCommand(
        Aliases = ('mygames')
    )]
    [cmdletbinding()]
    param(
        [string]$Against
    )

    if ($global:PoshBotContext.FromName) {
        $thisPlayer = $global:PoshBotContext.FromName
    } else {
        $thisPlayer = $global:PoshBotContext.From
    }

    if (-not ($games = Get-PoshBotStatefulData -Name Games -ValueOnly)) {
        Write-Output 'There are no active games against anyone. Be a trend setter and start one!'
        return
    } else {
        if ($Against) {
            # Show just the one game
            $key = ($thisPlayer, $Against | Sort-Object) -Join '_'
            if ($game = $games[$key]) {
                $grid = RenderGrid -Game $game
                New-PoshBotTextResponse -Text $grid -AsCode
            } else {
                Write-Output "You have no active game against [$Against]. Show 'em what you're made of and start one!"
            }
        } else {
            if ($myGames = $games.Keys | Where-Object {$_ -like "*$thisPlayer*"}) {
                if ($myGames.Count -gt 1) {
                    # Show list of my games
                    $otherPlayers = $myGames | Foreach-Object {
                        $_.Replace($thisPlayer, '').Replace('_', '')
                    } | Sort-Object
                    $text = "You have active games against:`n"
                    $text += "$($otherPlayers | Format-List | Out-String)"
                    Write-Output $text
                } else {
                    $game = $games[$myGames]
                    $grid = RenderGrid -Game $game
                    New-PoshBotTextResponse -Text $grid -AsCode
                }
            } else {
                Write-Output "You have no active games. Show 'em what you're made of and start one!"
            }
        }
    }
}
