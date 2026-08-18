# =======================================================
# CodeVault — Stop Script (PowerShell)
# Stops all CodeVault containers cleanly (preserves database data)
# =======================================================

$ErrorActionPreference = "Continue"

Write-Host "Stopping CodeVault services..." -ForegroundColor Cyan
docker compose stop

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "CodeVault has been stopped." -ForegroundColor Green
    Write-Host "To start it again, run: .\start.ps1" -ForegroundColor Yellow
} else {
    Write-Host "Failed to stop services cleanly. Run: docker compose down" -ForegroundColor Red
}
