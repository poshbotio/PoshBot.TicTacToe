@{
RootModule = '.\PoshBot.TicTacToe'
ModuleVersion = '1.0.0'
GUID = '3a7f0ac6-0c32-4690-85cd-ad3531cacf6c'
Author = 'Brandon Olin'
CompanyName = 'Community'
Copyright = '(c) 2017 Brandon Olin. All rights reserved.'
Description = 'A PoshBot plugin to play TicTacToe'
PowerShellVersion = '5.0.0'
RequiredModules = @('PoshBot')
FunctionsToExport = @('New-TicTacToeGame', 'Set-BoardSquare', 'Show-Game', 'Show-Stats')
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = @()
PrivateData = @{
    PSData = @{
        Tags = @()
        LicenseUri = ''
        ProjectUri = ''
        IconUri = ''
        ReleaseNotes = ''
    }
}
}

