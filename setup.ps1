# IPTV Harmonization System — Setup & Validation Script

$folders = @(
    ".\config",
    ".\data\raw",
    ".\data\normalized",
    ".\data\transformed",
    ".\data\reconciled",
    ".\data\enriched",
    ".\logs",
    ".\gui",
    ".\scripts"
)

$requiredFiles = @(
    "run_gui.ps1",
    "run_gui.bat",
    ".\scripts\fetch_sources.ps1",
    ".\scripts\Normalize-And-Resolve.ps1",
    ".\scripts\Transform-Canonical.ps1",
    ".\scripts\Reconcile-And-Match.ps1",
    ".\scripts\Generate-Outputs.ps1",
    ".\scripts\Enrich-Metadata.ps1",
    ".\gui\SourceManager.ps1",
    ".\gui\MappingDashboard.ps1",
    ".\gui\RuleEditor.ps1",
    ".\gui\PreviewPanel.ps1",
    ".\gui\RunHistory.ps1",
    ".\gui\AutomationRunner.ps1",
    ".\config\sources.yaml",
    ".\config\rules.yaml",
    ".\config\aliases.yaml",
    ".\config\api_keys.yaml"
)

Write-Host "`n📁 Creating folder structure..."
foreach ($f in $folders) {
    New-Item -ItemType Directory -Path $f -Force | Out-Null
    $placeholder = Join-Path $f ".gitkeep"
    if (-not (Test-Path $placeholder)) {
        New-Item -ItemType File -Path $placeholder -Force | Out-Null
    }
}

Write-Host "`n📋 Validating required files..."
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ Found: $file"
    } else {
        Write-Host "❌ Missing: $file"
    }
}

Write-Host "`n✅ Setup complete. Folder structure initialized and file check finished."
