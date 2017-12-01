
# Dot source public/private
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )
foreach($import in @($Public + $Private)) {
    try {
        . $import.fullname
    } catch {
        throw $_
    }
}

Export-ModuleMember -Function $Public.Basename