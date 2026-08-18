# =======================================================
# CodeVault — Database Reset Script (PowerShell)
# Destructive: Clears all local database data and re-initializes
# =======================================================

$ErrorActionPreference = "Stop"

Write-Host "======================================================" -ForegroundColor Red
Write-Host " WARNING: DESTRUCTIVE ACTION                          " -ForegroundColor Red
Write-Host "======================================================" -ForegroundColor Red
Write-Host ""
$confirmation = Read-Host "This will delete all local CodeVault database data. Continue? (Y/N)"

if ($confirmation -ne "Y" -and $confirmation -ne "y") {
    Write-Host "Operation cancelled. No changes were made." -ForegroundColor Green
    exit 0
}

Write-Host ""
Write-Host "Stopping services and removing database volume..." -ForegroundColor Cyan
docker compose down -v

Write-Host "Rebuilding and initializing fresh database..." -ForegroundColor Cyan
docker compose up --build -d

Write-Host "Waiting for database initialization and healthcheck..." -ForegroundColor Cyan

$healthUrl = "http://localhost:8080/health"
$maxRetries = 40
$isHealthy = $false

for ($i = 1; $i -le $maxRetries; $i++) {
    try {
        $response = Invoke-RestMethod -Uri $healthUrl -Method Get -TimeoutSec 3 -ErrorAction SilentlyContinue
        if ($response -and $response.status -eq "UP") {
            $isHealthy = $true
            break
        }
    } catch {
        # Waiting for initialization
    }
    Start-Sleep -Seconds 3
}

if ($isHealthy) {
    Write-Host ""
    Write-Host "=================================" -ForegroundColor Green
    Write-Host "Database reset completed." -ForegroundColor Green
    Write-Host "Fresh database initialized." -ForegroundColor Green
    Write-Host ""
    Write-Host "Website:" -ForegroundColor Cyan
    Write-Host "http://localhost:8080" -ForegroundColor White
    Write-Host "=================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "Database reset completed, but healthcheck took longer than expected." -ForegroundColor Yellow
    Write-Host "Check status with: .\status.ps1" -ForegroundColor Yellow
}
