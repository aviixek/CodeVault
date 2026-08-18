# =======================================================
# CodeVault — Database Backup Script (PowerShell)
# Creates a timestamped database backup file securely
# =======================================================

$ErrorActionPreference = "Stop"

# Generate timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFileName = "backup_codevault_$timestamp.sql"
$backupFilePath = Join-Path $PSScriptRoot $backupFileName

Write-Host "Creating database backup..." -ForegroundColor Cyan

# Execute mysqldump inside container using container-managed environment variables
# (No plaintext passwords are passed in PowerShell command-line arguments)
try {
    docker compose exec -T db sh -c 'mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --no-tablespaces "$MYSQL_DATABASE"' | Out-File -FilePath $backupFilePath -Encoding utf8

    if (Test-Path $backupFilePath) {
        $fileSize = (Get-Item $backupFilePath).Length
        if ($fileSize -gt 100) {
            Write-Host ""
            Write-Host "Database backup created successfully." -ForegroundColor Green
            Write-Host "File saved to: $backupFileName" -ForegroundColor White
            Write-Host ""
            Write-Host "To restore this backup in the future, run:" -ForegroundColor Yellow
            Write-Host "  docker compose exec -T db sh -c 'mysql -u `"`$MYSQL_USER`" -p`"`$MYSQL_PASSWORD`" `"`$MYSQL_DATABASE`"' < $backupFileName" -ForegroundColor Gray
        } else {
            Write-Host "Warning: Backup file was created but appears empty. Check if the database service is running." -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "Error creating backup: $_" -ForegroundColor Red
    Write-Host "Please ensure CodeVault is running before creating a backup: .\start.ps1" -ForegroundColor Yellow
}
