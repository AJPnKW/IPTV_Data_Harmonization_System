# 📦 Source Manager — Validate and summarize sources.yaml

Import-Module powershell-yaml

$sourcePath = ".\config\sources.yaml"

if (-not (Test-Path $sourcePath)) {
    Write-Host "❌ sources.yaml not found at $sourcePath"
    exit 1
}

try {
    $config = ConvertFrom-Yaml (Get-Content $sourcePath -Raw)
    $sources = $config.sources
} catch {
    Write-Host "❌ Failed to parse sources.yaml"
    Write-Host $_.Exception.Message
    exit 1
}

Write-Host "`n📦 Source Registry Summary"
Write-Host "───────────────────────────────"
Write-Host "Name`tType`tCountry`tEnabled`tStatus"

foreach ($src in $sources) {
    $name = $src.name
    $type = $src.type
    $country = $src.country
    $enabled = $src.enabled
    $url = $src.url

    $status = "❌"
    try {
        $r = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 5 -ErrorAction Stop
        $status = if ($r.StatusCode -lt 400) { "✅" } else { "⚠️ $($r.StatusCode)" }
    } catch {
        $status = "❌"
    }

    Write-Host "$name`t$type`t$country`t$enabled`t$status"
}
