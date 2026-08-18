# =======================================================
# CodeVault — Restart Script (PowerShell)
# Restarts services and waits for healthcheck
# =======================================================

$ErrorActionPreference = "Stop"

Write-Host "Restarting CodeVault services..." -ForegroundColor Cyan
docker compose restart

Write-Host "Waiting for CodeVault to become healthy..." -ForegroundColor Cyan

$healthUrl = "http://localhost:8080/health"
$maxRetries = 30
$isHealthy = $false

for ($i = 1; $i -le $maxRetries; $i++) {
    try {
        $response = Invoke-RestMethod -Uri $healthUrl -Method Get -TimeoutSec 3 -ErrorAction SilentlyContinue
        if ($response -and $response.status -eq "UP") {
            $isHealthy = $true
            break
        }
    } catch {
        # Waiting for services
    }
    Start-Sleep -Seconds 2
}

if ($isHealthy) {
    Write-Host ""
    Write-Host "=================================" -ForegroundColor Green
    Write-Host "CodeVault restarted successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Website:" -ForegroundColor Cyan
    Write-Host "http://localhost:8080" -ForegroundColor White
    Write-Host "=================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "CodeVault is restarting, but healthcheck took longer than expected." -ForegroundColor Yellow
    Write-Host "To check service status, run: .\status.ps1" -ForegroundColor Yellow
    Write-Host "To view recent logs, run:     docker compose logs --tail 50" -ForegroundColor Yellow
}
