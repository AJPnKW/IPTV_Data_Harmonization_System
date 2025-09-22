function Show-RunHistory {
    Write-Host "`n📊 Run History"
    Get-ChildItem .\logs\run_*.log | ForEach-Object {
        Write-Host "• $($_.Name)"
    }
}

