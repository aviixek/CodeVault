# =======================================================
# CodeVault — Status Script (PowerShell)
# Displays container and service availability status
# =======================================================

$ErrorActionPreference = "Continue"

# Check Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker is not installed or not in PATH." -ForegroundColor Red
    exit 1
}

$dockerInfo = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker Desktop is not running." -ForegroundColor Yellow
    exit 1
}

# Inspect container states
$appRunning = $false
$dbRunning = $false

$containers = docker ps --format "{{.Names}}\t{{.Status}}" 2>&1

if ($containers -match "codevault-app") {
    $appRunning = $true
}
if ($containers -match "codevault-db") {
    $dbRunning = $true
}

# Check application healthcheck endpoint
$appHealthy = $false
try {
    $health = Invoke-RestMethod -Uri "http://localhost:8080/health" -Method Get -TimeoutSec 2 -ErrorAction SilentlyContinue
    if ($health -and $health.status -eq "UP") {
        $appHealthy = $true
    }
} catch {}

Write-Host ""
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "CodeVault Status" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

if ($appHealthy) {
    Write-Host "Application: " -NoNewline; Write-Host "RUNNING" -ForegroundColor Green
} elseif ($appRunning) {
    Write-Host "Application: " -NoNewline; Write-Host "STARTING (Initializing)" -ForegroundColor Yellow
} else {
    Write-Host "Application: " -NoNewline; Write-Host "NOT RUNNING" -ForegroundColor Red
}

if ($dbRunning) {
    Write-Host "Database:    " -NoNewline; Write-Host "RUNNING" -ForegroundColor Green
} else {
    Write-Host "Database:    " -NoNewline; Write-Host "NOT RUNNING" -ForegroundColor Red
}

Write-Host ""
Write-Host "Website:     http://localhost:8080" -ForegroundColor White
Write-Host "MySQL:       127.0.0.1:3307" -ForegroundColor White
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""
