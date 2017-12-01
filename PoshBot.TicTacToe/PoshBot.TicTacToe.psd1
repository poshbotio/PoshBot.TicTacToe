@{
RootModule = 'PoshBot.TicTacToe'
ModuleVersion = '0.1.0'
GUID = '3a7f0ac6-0c32-4690-85cd-ad3531cacf6c'
Author = 'Brandon Olin'
CompanyName = 'Community'
Copyright = '(c) 2017 Brandon Olin. All rights reserved.'
Description = 'A PoshBot plugin to play Tic-tac-toe'
PowerShellVersion = '5.0.0'
RequiredModules = @('PoshBot')
FunctionsToExport = @('New-TicTacToeGame', 'Set-BoardSquare', 'Show-Game', 'Show-Stats')
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = @()
PrivateData = @{
    PSData = @{
        Tags = @('PoshBot', 'Tic Tac Toe', 'tictactoe', 'game', 'ChatOps')
        LicenseUri = 'https://raw.githubusercontent.com/poshbotio/PoshBot.TicTacToe/master/LICENSE'
        ProjectUri = 'https://github.com/poshbotio/PoshBot.TicTacToe'
        IconUri = ''
        ReleaseNotes = 'https://raw.githubusercontent.com/poshbotio/PoshBot.TicTacToe/master/CHANGELOG.md'
    }
}
}

