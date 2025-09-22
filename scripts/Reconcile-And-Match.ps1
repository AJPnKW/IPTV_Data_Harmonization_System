$inputM3U = ".\data\transformed\transformed_m3u.json"
$inputEPG = ".\data\transformed\transformed_epg.json"
$outputPath = ".\data\reconciled"

New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

$m3u = Get-Content $inputM3U | ConvertFrom-Json
$epg = Get-Content $inputEPG | ConvertFrom-Json

$matched = @()
$unmatched = @()
$conflicts = @()

function Match-Channel($m3uChannel, $epgList) {
    foreach ($epgChannel in $epgList) {
        if ($m3uChannel.channel_id -eq $epgChannel.channel_id) {
            return $epgChannel
        }
        elseif ($m3uChannel.name -eq $epgChannel.name) {
            return $epgChannel
        }
        elseif ($m3uChannel.name -like "*$($epgChannel.station)*") {
            return $epgChannel
        }
    }
    return $null
}

foreach ($c in $m3u) {
    $match = Match-Channel $c $epg
    if ($match) {
        $matched += [PSCustomObject]@{
            channel_id = $c.channel_id
            name       = $c.name
            country    = $c.country
            url        = $c.url
            logo       = $c.logo
            group      = $c.group
            epg        = $match.programs
        }
    } else {
        $unmatched += $c
    }
}

# Detect conflicts (e.g., same ID but different names)
foreach ($e in $epg) {
    $conflict = $matched | Where-Object { $_.channel_id -eq $e.channel_id -and $_.name -ne $e.name }
    if ($conflict) {
        $conflicts += $e
    }
}

# Save outputs
$matched | ConvertTo-Json -Depth 5 | Set-Content "$outputPath\matched_channels.json"
$unmatched | ConvertTo-Json -Depth 3 | Set-Content "$outputPath\unmatched_channels.json"
$conflicts | ConvertTo-Json -Depth 3 | Set-Content "$outputPath\conflicting_channels.json"

# Generate report
$report = @"
Reconciliation Report — $(Get-Date -Format yyyy-MM-ddTHH:mm:ssZ)

✅ Matched: $($matched.Count)
❌ Unmatched: $($unmatched.Count)
⚠️ Conflicts: $($conflicts.Count)

Manual Overrides Required:
- Unmatched channels saved to: unmatched_channels.json
- Conflicting channels saved to: conflicting_channels.json
"@

Set-Content "$outputPath\match_report.txt" $report
Write-Host "`n✅ Reconciliation complete. Report saved to: $outputPath"

