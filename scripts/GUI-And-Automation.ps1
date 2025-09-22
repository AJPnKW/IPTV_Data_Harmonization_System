$guiRoot = ".\gui"
$configPath = ".\config"
$dataPath = ".\data"
$logPath = ".\logs"

New-Item -ItemType Directory -Path $guiRoot -Force | Out-Null
New-Item -ItemType Directory -Path $logPath -Force | Out-Null

# GUI Module Stubs
$modules = @(
    "SourceManager",
    "MappingDashboard",
    "RuleEditor",
    "PreviewPanel",
    "RunHistory"
)

foreach ($m in $modules) {
    $stub = @"
# GUI Module: $m

function Show-$m {
    Write-Host "`n[$m] Module Loaded"
    # TODO: Implement UI logic
}
"@
    Set-Content "$guiRoot\$m.ps1" $stub
}

# Automation Scheduler Stub
$automationScript = @"
# Automation Runner

function Run-Automation {
    Write-Host "`n🔁 Starting scheduled pipeline..."

    .\fetch_sources.ps1
    .\Normalize-And-Resolve.ps1
    .\Transform-Canonical.ps1
    .\Reconcile-And-Match.ps1
    .\Generate-Outputs.ps1

    Write-Host "`n✅ Pipeline complete. Outputs ready."
    Add-Content "$logPath\run_$(Get-Date -Format yyyyMMdd-HHmm).log" "Run completed at $(Get-Date -Format o)"
}
"@
Set-Content "$guiRoot\AutomationRunner.ps1" $automationScript

# CLI Entry Point
$entryPoint = @"
# IPTV Harmonization CLI

Write-Host "`n📺 IPTV Harmonization System"
Write-Host "Modules:"
Write-Host "1. Source Manager"
Write-Host "2. Mapping Dashboard"
Write-Host "3. Rule Editor"
Write-Host "4. Preview Panel"
Write-Host "5. Run History"
Write-Host "6. Run Full Automation"

$choice = Read-Host "Select module (1-6)"
switch ($choice) {
    1 { . "$guiRoot\SourceManager.ps1"; Show-SourceManager }
    2 { . "$guiRoot\MappingDashboard.ps1"; Show-MappingDashboard }
    3 { . "$guiRoot\RuleEditor.ps1"; Show-RuleEditor }
    4 { . "$guiRoot\PreviewPanel.ps1"; Show-PreviewPanel }
    5 { . "$guiRoot\RunHistory.ps1"; Show-RunHistory }
    6 { . "$guiRoot\AutomationRunner.ps1"; Run-Automation }
    default { Write-Host "❌ Invalid selection." }
}
"@
Set-Content ".\run_gui.ps1" $entryPoint

Write-Host "`n✅ GUI stubs and automation runner created. Launch with: .\run_gui.ps1"

