
# Requires: powershell-yaml
# Install-Module powershell-yaml -Scope CurrentUser

Import-Module powershell-yaml

$rulePath = ".\config\rules.yaml"
$m3uInput = ".\data\normalized\normalized_m3u.json"
$epgInput = ".\data\normalized\normalized_epg.json"
$outputPath = ".\data\transformed"

New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

# Load rules
$rules = ConvertFrom-Yaml (Get-Content $rulePath -Raw)

# Load normalized inputs
$m3u = Get-Content $m3uInput | ConvertFrom-Json
$epg = Get-Content $epgInput | ConvertFrom-Json

function Apply-RulesToChannel($channel) {
    # Rename
    foreach ($r in $rules.rename) {
        if ($channel.channel_id -eq $r.match) {
            $channel.name = $r.replace
        }
    }

    # Group
    foreach ($g in $rules.group) {
        if ($channel.name -match $g.match) {
            $channel.group = $g.assign -replace "{country}", $channel.country
        }
    }

    # Filter
    foreach ($f in $rules.filter) {
        if ($channel.name -eq $f.exclude) {
            return $null
        }
    }

    # Logo
    foreach ($l in $rules.logo) {
        if ($channel.name -match $l.match) {
            $channel.logo = $l.url
        }
    }

    return $channel
}

# Transform M3U
$transformedM3U = @()
foreach ($c in $m3u) {
    $result = Apply-RulesToChannel $c
    if ($result) { $transformedM3U += $result }
}
$transformedM3U | ConvertTo-Json -Depth 3 | Set-Content "$outputPath\transformed_m3u.json"

# Transform EPG (pass-through for now)
$transformedEPG = $epg
$transformedEPG | ConvertTo-Json -Depth 5 | Set-Content "$outputPath\transformed_epg.json"

Write-Host "`n✅ Transformation complete. Outputs saved to: $outputPath"
