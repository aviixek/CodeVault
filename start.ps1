# =======================================================
# CodeVault — Start Script (PowerShell)
# Starts containers, checks health, and opens website
# =======================================================

$ErrorActionPreference = "Stop"

Write-Output "Checking Docker environment..."

# 1. Check whether Docker CLI is installed
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Docker is not installed or not in your PATH." -ForegroundColor Red
    Write-Host "Please install Docker Desktop: https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    exit 1
}

# 2. Check whether Docker daemon is running
$dockerInfo = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker Desktop is not running. Please open Docker Desktop and run .\start.ps1 again." -ForegroundColor Yellow
    exit 1
}

# 3. Create .env from .env.example if missing (NEVER overwrite existing .env)
$envFile = Join-Path $PSScriptRoot ".env"
$envExample = Join-Path $PSScriptRoot ".env.example"

if (-not (Test-Path $envFile)) {
    if (Test-Path $envExample) {
        Write-Host "Creating .env from .env.example..." -ForegroundColor Cyan
        Copy-Item $envExample $envFile
    } else {
        Write-Host "Error: Neither .env nor .env.example found." -ForegroundColor Red
        exit 1
    }
}

# 4. Validate required environment variables in .env
$envContent = Get-Content $envFile
$hasDbPass = $false
$hasRootPass = $false

foreach ($line in $envContent) {
    $trimmed = $line.Trim()
    if ($trimmed.StartsWith("#") -or [string]::IsNullOrWhiteSpace($trimmed)) {
        continue
    }
    if ($trimmed -match "^DB_PASSWORD=(.+)$") {
        $val = $matches[1].Trim()
        if ($val -ne "" -and $val -ne "your_strong_app_password_here") {
            $hasDbPass = $true
        }
    }
    if ($trimmed -match "^MYSQL_ROOT_PASSWORD=(.+)$") {
        $val = $matches[1].Trim()
        if ($val -ne "" -and $val -ne "your_strong_root_password_here") {
            $hasRootPass = $true
        }
    }
}

if (-not $hasDbPass -or -not $hasRootPass) {
    Write-Host "Note: Please ensure DB_PASSWORD and MYSQL_ROOT_PASSWORD in .env are configured with your custom passwords." -ForegroundColor Cyan
}

# 5. Start and build containers
Write-Host "Starting CodeVault services..." -ForegroundColor Cyan
docker compose up --build -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to start Docker containers." -ForegroundColor Red
    Write-Host "To inspect issues, run: .\status.ps1" -ForegroundColor Yellow
    Write-Host "To view logs: docker compose logs --tail 50" -ForegroundColor Yellow
    exit 1
}

# 6. Wait for health endpoint (finite 120-second timeout)
Write-Host "Waiting for CodeVault to initialize (up to 120s)..." -ForegroundColor Cyan

$healthUrl = "http://localhost:8080/health"
$maxRetries = 40  # 40 attempts * 3 seconds = 120s timeout
$isHealthy = $false

for ($i = 1; $i -le $maxRetries; $i++) {
    try {
        $response = Invoke-RestMethod -Uri $healthUrl -Method Get -TimeoutSec 3 -ErrorAction SilentlyContinue
        if ($response -and $response.status -eq "UP") {
            $isHealthy = $true
            break
        }
    } catch {
        # Waiting for container and Tomcat initialization
    }
    Start-Sleep -Seconds 3
}

if ($isHealthy) {
    Write-Host ""
    Write-Host "=================================" -ForegroundColor Green
    Write-Host "CodeVault is ready!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Website:" -ForegroundColor Cyan
    Write-Host "http://localhost:8080" -ForegroundColor White
    Write-Host "=================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "CodeVault startup is taking longer than expected or encountered an error." -ForegroundColor Yellow
    Write-Host "To check service status, run: .\status.ps1" -ForegroundColor Yellow
    Write-Host "To view recent logs, run:     docker compose logs --tail 50" -ForegroundColor Yellow
}
