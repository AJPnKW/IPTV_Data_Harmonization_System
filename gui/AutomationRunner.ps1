
function Run-Automation {
    Write-Host "`n🔁 Starting full pipeline..."

    .\fetch_sources.ps1
    .\Normalize-And-Resolve.ps1
    .\Transform-Canonical.ps1
    .\Reconcile-And-Match.ps1
    .\Generate-Outputs.ps1
    .\Enrich-Metadata.ps1

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content ".\logs\run_$(Get-Date -Format yyyyMMdd-HHmm).log" "✅ Pipeline completed at $timestamp"
    Write-Host "`n✅ Pipeline complete. Outputs saved and logged."
}
