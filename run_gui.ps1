# IPTV Harmonization System — Unified Pipeline Launcher

$guiRoot = ".\gui"
$logPath = ".\logs"
New-Item -ItemType Directory -Path $logPath -Force | Out-Null

Write-Host "`n📺 IPTV Harmonization System — GUI Launcher"
Write-Host "──────────────────────────────────────────────"
Write-Host "Modules:"
Write-Host "1. Source Manager"
Write-Host "2. Mapping Dashboard"
Write-Host "3. Rule Editor"
Write-Host "4. Preview Panel"
Write-Host "5. Run History"
Write-Host "6. Run Full Automation"
Write-Host "──────────────────────────────────────────────"

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

