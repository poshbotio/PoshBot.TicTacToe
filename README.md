
[![Build status][appveyor-badge]][appveyor-build]

# PoshBot.TicTacToe

A simple Tic Tac Toe plugin for [PoshBot](https://github.com/poshbotio/PoshBot).

## Install Module

To install the module from the [PowerShell Gallery](https://www.powershellgallery.com/):

```powershell
PS C:\> Install-Module -Name PoshBot.TicTacToe -Repository PSGallery
```

## Install Plugin

To install the plugin from within PoshBot:

```
!install-plugin poshbot.tictactoe
```

## Commands

| Name | Alias | Description |
|------|-------| ------------|
New-TicTacToeGame | newtictactoe | Create a new Tic Tac Toe game against a player
Set-BoardSquare | mark | Mark a square on the board
Show-Game | mygames | Show your active games
Show-Stats | stats | Show stats for all players

## Usage

[appveyor-badge]: https://ci.appveyor.com/api/projects/status/aqtia3gkf8p9xktc?svg=true
[appveyor-build]: https://ci.appveyor.com/project/devblackops/poshbot-tictactoe