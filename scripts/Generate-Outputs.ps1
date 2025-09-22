$inputM3U = ".\data\reconciled\matched_channels.json"
$inputEPG = ".\data\reconciled\matched_channels.json"  # Reuse same input for EPG programs
$outputPath = ".\data\final"
$versionTag = Get-Date -Format "yyyyMMdd-HHmm"

New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

$m3u = Get-Content $inputM3U | ConvertFrom-Json

# Generate final M3U
$m3uLines = @("#EXTM3U")
foreach ($c in $m3u | Sort-Object group, name) {
    $group = if ($c.group) { $c.group } else { "General" }
    $logo  = if ($c.logo)  { $c.logo } else { "" }
    $line1 = "#EXTINF:-1 tvg-id=\"$($c.channel_id)\" tvg-name=\"$($c.name)\" tvg-logo=\"$logo\" group-title=\"$group\",$($c.name)"
    $line2 = $c.url
    $m3uLines += $line1
    $m3uLines += $line2
}
$m3uLines | Set-Content "$outputPath\final_$versionTag.m3u"

# Generate final EPG (XMLTV)
$xml = New-Object System.Xml.XmlDocument
$tv = $xml.CreateElement("tv")
$xml.AppendChild($tv) | Out-Null

foreach ($c in $m3u) {
    $channel = $xml.CreateElement("channel")
    $channel.SetAttribute("id", $c.channel_id)

    $displayName = $xml.CreateElement("display-name")
    $displayName.InnerText = $c.name
    $channel.AppendChild($displayName) | Out-Null

    $tv.AppendChild($channel) | Out-Null

    foreach ($p in $c.epg) {
        $prog = $xml.CreateElement("programme")
        $prog.SetAttribute("start", $p.start)
        $prog.SetAttribute("stop", $p.end)
        $prog.SetAttribute("channel", $c.channel_id)

        $title = $xml.CreateElement("title")
        $title.InnerText = $p.title
        $prog.AppendChild($title) | Out-Null

        $desc = $xml.CreateElement("desc")
        $desc.InnerText = $p.description
        $prog.AppendChild($desc) | Out-Null

        $cat = $xml.CreateElement("category")
        $cat.InnerText = $p.category
        $prog.AppendChild($cat) | Out-Null

        $tv.AppendChild($prog) | Out-Null
    }
}
$xml.Save("$outputPath\final_$versionTag.xml")

Write-Host "`n✅ Output generation complete. Files saved to: $outputPath"

