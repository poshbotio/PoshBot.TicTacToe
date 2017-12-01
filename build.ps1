
[cmdletbinding(DefaultParameterSetName = 'task')]
param(
    [parameter(ParameterSetName = 'task', position = 0)]
    [string[]]$Task = 'default',

    [parameter(ParameterSetName = 'help')]
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

if (-not (Get-Module -Name PSDepend -ListAvailable)) {
    Install-module -Name PSDepend -Repository PSGallery
}
Import-Module -Name PSDepend
Invoke-PSDepend -Path .\requirements.psd1 -Install -Import -Force
if (-not (Get-Module -Name BuildHelpers -ListAvailable)) {
    Install-Module -Name BuildHelpers -AllowClobber
}
Import-Module -Name BuildHelpers

if ($PSBoundParameters.ContainsKey('help')) {
    Get-PSakeScriptTasks -buildFile "$PSScriptRoot\psake.ps1" |
        Format-Table -Property Name, Description, Alias, DependsOn
} else {
    Set-BuildEnvironment -Force

    Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task -nologo
    exit ( [int]( -not $psake.build_success ) )
}
