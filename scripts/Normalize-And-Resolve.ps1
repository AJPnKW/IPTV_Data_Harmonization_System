# Requires: powershell-yaml, FuzzySharp
# Install-Module powershell-yaml -Scope CurrentUser
# Install-Package FuzzySharp -Scope CurrentUser

Import-Module powershell-yaml
Add-Type -Path (Join-Path $env:USERPROFILE "\Documents\PowerShell\Modules\FuzzySharp\FuzzySharp.dll")

$aliasPath = ".\config\aliases.yaml"
$m3uRawPath = ".\data\raw\m3u\US\m3u_US.m3u"
$epgRawPath = ".\data\raw\epg\CA\epg_CA.xml"
$outputPath = ".\data\normalized"

New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

# Load alias dictionary
$aliases = ConvertFrom-Yaml (Get-Content $aliasPath -Raw)

function Resolve-Alias($id) {
    if ($aliases.ContainsKey($id)) {
        $a = $aliases[$id]
        return @{
            channel_id = $id
            name       = "$($a.country)-$($a.network)-$($a.station) ($($a.location))"
            network    = $a.network
            station    = $a.station
            location   = $a.location
            country    = $a.country
        }
    } else {
        # Fuzzy match fallback
        $best = $null
        $score = 0
        foreach ($key in $aliases.Keys) {
            $s = [FuzzySharp.Fuzz]::Ratio($id, $key)
            if ($s -gt $score) {
                $score = $s
                $best = $key
            }
        }
        if ($score -ge 85) {
            return Resolve-Alias $best
        } else {
            return @{ channel_id = $id; name = $id }
        }
    }
}

function Normalize-M3U($path) {
    $lines = Get-Content $path
    $channels = @()
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -like "#EXTINF*") {
            $meta = $lines[$i]
            $url = $lines[$i + 1]
            $id = ($meta -split ",")[-1].Trim()
            $resolved = Resolve-Alias $id
            $channels += [PSCustomObject]@{
                channel_id = $resolved.channel_id
                name       = $resolved.name
                network    = $resolved.network
                station    = $resolved.station
                location   = $resolved.location
                country    = $resolved.country
                group      = "Unassigned"
                url        = $url
                logo       = ""
            }
        }
    }
    $channels | ConvertTo-Json -Depth 3 | Set-Content "$outputPath\normalized_m3u.json"
}

function Normalize-EPG($path) {
    [xml]$xml = Get-Content $path
    $channels = @{}
    foreach ($c in $xml.tv.channel) {
        $id = $c.id
        $resolved = Resolve-Alias $id
        $channels[$id] = @{
            channel_id = $resolved.channel_id
            name       = $resolved.name
            country    = $resolved.country
            programs   = @()
        }
    }
    foreach ($p in $xml.tv.programme) {
        $id = $p.channel
        if ($channels.ContainsKey($id)) {
            $channels[$id].programs += @{
                start      = $p.start
                end        = $p.stop
                title      = $p.title.'#text'
                description= $p.desc.'#text'
                category   = $p.category.'#text'
            }
        }
    }
    $channels.Values | ConvertTo-Json -Depth 5 | Set-Content "$outputPath\normalized_epg.json"
}

Normalize-M3U $m3uRawPath
Normalize-EPG $epgRawPath

Write-Host "`n✅ Normalization and alias resolution complete. Outputs saved to: $outputPath"

