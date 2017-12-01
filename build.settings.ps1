
$projectRoot = if ($ENV:BHProjectPath) { $ENV:BHProjectPath } else { $PSScriptRoot }

@{
    ProjectRoot = $projectRoot
    ProjectName = $env:BHProjectName
    SUT = Join-Path -Path $projectRoot -ChildPath $env:BHProjectName
    Tests = Join-Path -Path $projectRoot -ChildPath Tests
    ManifestPath = $env:BHPSModuleManifest
    Manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    PSVersion = $PSVersionTable.PSVersion.Major
    PSGalleryApiKey = $env:PSGalleryApiKey
}
