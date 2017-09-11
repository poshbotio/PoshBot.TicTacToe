
# Dot source public/private
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )
foreach($import in @($Public + $Private)) {
    . $import.fullname
}

Export-ModuleMember -Function $Public.Basename