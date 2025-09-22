```powershell
# Requires: powershell-yaml module
# Install-Module powershell-yaml -Scope CurrentUser

Import-Module powershell-yaml

$sourceConfigPath = ".\config\sources.yaml"
$rawDataRoot = ".\data\raw"

function Get-ExtensionFromUrl($url) {
    if ($url -match "\.gz$") { return "xml.gz" }
    elseif ($url -match "\.zip$") { return "zip" }
    elseif ($url -match "\.m3u$") { return "m3u" }
    elseif ($url -match "\.xml$") { return "xml" }
    else { return "txt" }
}

function Fetch-And-StageSource($source) {
    $name = $source.name
    $type = $source.type
    $country = $source.country
    $url = $source.url
    $decompress = $source.decompress
    $ext = Get-ExtensionFromUrl $url

    $targetDir = Join-Path $rawDataRoot "$type\$country"
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

    $targetPath = Join-Path $targetDir "$name.$ext"
    $logPath = Join-Path $targetDir "$name.log"

    Write-Host "🔄 Fetching $name ($type/$country)..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $targetPath -UseBasicParsing
        Add-Content $logPath "$(Get-Date -Format o) ✅ Fetched: $url"

        if ($decompress -eq $true -and $ext -eq "xml.gz") {
            $decompressedPath = $targetPath -replace "\.gz$", ""
            Write-Host "📦 Decompressing $targetPath → $decompressedPath"
            $fs = New-Object System.IO.FileStream($targetPath, [System.IO.FileMode]::Open)
            $gz = New-Object System.IO.Compression.GzipStream($fs, [System.IO.Compression.CompressionMode]::Decompress)
            $out = New-Object System.IO.FileStream($decompressedPath, [System.IO.FileMode]::Create)
            $gz.CopyTo($out)
            $gz.Close(); $fs.Close(); $out.Close()
            Add-Content $logPath "$(Get-Date -Format o) ✅ Decompressed to: $decompressedPath"
        }

    } catch {
        Add-Content $logPath "$(Get-Date -Format o) ❌ Error: $($_.Exception.Message)"
        Write-Host "❌ Failed to fetch $name: $($_.Exception.Message)"
    }
}

# Load source registry
$sources = ConvertFrom-Yaml (Get-Content $sourceConfigPath -Raw)

foreach ($source in $sources.sources) {
    Fetch-And-StageSource $source
}

Write-Host "`n✅ All sources processed. Raw files staged under: $rawDataRoot"
```

---

**Folder Structure Created:**
```
data/
└── raw/
    ├── m3u/
    │   └── US/
    │       └── m3u_US.m3u
    └── epg/
        └── CA/
            └── epg_CA.xml.gz → epg_CA.xml
```

**Log Format:**
```
2025-09-22T13:36:00.0000000Z ✅ Fetched: https://...
2025-09-22T13:36:01.0000000Z ✅ Decompressed to: ...
```
