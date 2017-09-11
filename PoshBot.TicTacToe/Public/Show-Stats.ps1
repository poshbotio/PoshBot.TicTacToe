
function Show-Stats {
    [PoshBot.BotCommand(
        Aliases = ('stats')
    )]
    [cmdletbinding()]
    param(
        [int]$Top = 10
    )
    # Get or initialize stats
    if (-not ($stats = Get-PoshBotStatefulData -Name Stats -ValueOnly)) {
        $stats = @{}
        Set-PoshBotStatefulData -Name Stats -Value $stats -Depth 20
        Write-Output 'There are no stats available. Be a trend setter and start a game!'
    } else {
        $players = New-Object -TypeName System.Collections.ArrayList
        $stats.GetEnumerator() | ForEach-Object {
            [void]$players.Add([pscustomobject]@{
                Player = $_.Name
                Wins = $_.Value.Wins
                Losses = $_.Value.Losses
                Ties = $_.Value.Ties
            })
        }

        $topN = $players | Sort-Object -Property $Wins -Descending | Select-Object -First $Top
        $text = ($topN | Format-Table -AutoSize | Out-String)
        New-PoshBotCardResponse -Title "Top $Top TicTacToe Players" -Text $text
    }
}
