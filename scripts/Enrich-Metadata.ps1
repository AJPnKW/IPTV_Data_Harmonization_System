# Requires: API keys stored in config\api_keys.yaml
# External APIs: TMDB, OMDB, TVMaze, Trakt, Google Geocoding, OpenAI

Import-Module powershell-yaml
$apiConfigPath = ".\config\api_keys.yaml"
$inputEPG = ".\data\reconciled\matched_channels.json"
$outputPath = ".\data\enriched"

New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

# Load API keys
$keys = ConvertFrom-Yaml (Get-Content $apiConfigPath -Raw)

# Load EPG data
$channels = Get-Content $inputEPG | ConvertFrom-Json

function Enrich-With-TMDB($title) {
    $key = $keys.tmdb
    $url = "https://api.themoviedb.org/3/search/movie?api_key=$key&query=$([uri]::EscapeDataString($title))"
    try {
        $resp = Invoke-RestMethod -Uri $url -Method Get
        if ($resp.results.Count -gt 0) {
            return @{
                overview = $resp.results[0].overview
                genre    = $resp.results[0].genre_ids
                rating   = $resp.results[0].vote_average
            }
        }
    } catch {}
    return $null
}

function Enrich-With-Geocoding($location) {
    $key = $keys.google_geocoding
    $url = "https://maps.googleapis.com/maps/api/geocode/json?address=$([uri]::EscapeDataString($location))&key=$key"
    try {
        $resp = Invoke-RestMethod -Uri $url -Method Get
        if ($resp.results.Count -gt 0) {
            return $resp.results[0].formatted_address
        }
    } catch {}
    return $location
}

foreach ($c in $channels) {
    foreach ($p in $c.epg) {
        $meta = Enrich-With-TMDB $p.title
        if ($meta) {
            $p.description += "`nTMDB: $($meta.overview)"
            $p.category += ", TMDB Genre: $($meta.genre -join ', ')"
            $p.rating = $meta.rating
        }
    }
    $c.location = Enrich-With-Geocoding $c.location
}

$channels | ConvertTo-Json -Depth 5 | Set-Content "$outputPath\enriched_epg.json"
Write-Host "`n✅ Metadata enrichment complete. Output saved to: $outputPath"
