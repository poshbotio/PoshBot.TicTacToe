properties {
    $Settings = . $PSScriptRoot/build.settings.ps1
}

task default -depends Test

task Init {
    "`nSTATUS: Testing with PowerShell $psVersion"
    "Build System Details:"
    Get-Item ENV:BH*
} -description 'Initialize build environment'

task Test -Depends Init, Analyze, Pester -description 'Run test suite'

task Analyze -Depends Init {
    $analysis = Invoke-ScriptAnalyzer -Path $Settings.SUT -Recurse -Verbose:$false
    $errors = $analysis | Where-Object {$_.Severity -eq 'Error'}
    $warnings = $analysis | Where-Object {$_.Severity -eq 'Warning'}
    if (@($errors).Count -gt 0) {
        Write-Error -Message 'One or more Script Analyzer errors were found. Build cannot continue!'
        $errors | Format-Table
    }

    if (@($warnings).Count -gt 0) {
        Write-Warning -Message 'One or more Script Analyzer warnings were found. These should be corrected.'
        $warnings | Format-Table
    }
} -description 'Run PSScriptAnalyzer'

task Pester -Depends Init {
    Remove-Module $settings.ProjectName -ErrorAction SilentlyContinue -Verbose:$false
    Import-Module -Name $settings.ManifestPath -Force -Verbose:$false

    if (Test-Path -Path $settings.Tests) {
        Invoke-Pester -Path $settings.Tests -PassThru -EnableExit
    }
} -description 'Run Pester tests'

Task Publish -Depends Test {
    "    Publishing version [$($manifest.ModuleVersion)] to PSGallery..."
    Publish-Module -Path $settings.SUT -NuGetApiKey $settings.PSGalleryApiKey -Repository PSGallery
}
