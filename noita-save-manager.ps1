<#
Noita Save Manager

This script allows you to easily backup and restore your Noita game save.
Usage:
    .\noita-save-manager.ps1 save   # Creates a backup of your current save
    .\noita-save-manager.ps1 load   # Restores your save from the backup

Backups are stored in: $env:USERPROFILE\Documents\NoitaBackups\save

Parameters:
    -Action [save|load]   Specify "save" to backup or "load" to restore.

#>

param (
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet("save", "load")]
    [string]$Action
)

$noitaSaveDir = "$env:USERPROFILE\AppData\LocalLow\Nolla_Games_Noita\save00"
$backupDir = "$env:USERPROFILE\Documents\NoitaBackups"
$saveName = "save"
$savePath = Join-Path $backupDir $saveName

if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

function Save-Backup {
    if (Test-Path $savePath) {
        Remove-Item -Recurse -Force $savePath
    }
    Copy-Item -Recurse -Force $noitaSaveDir $savePath
    Write-Host "[OK] Save created: $savePath"
}

function Load-Backup {
    if (-not (Test-Path $savePath)) {
        Write-Error "[ERROR] No backup found."
        return
    }
    Remove-Item -Recurse -Force $noitaSaveDir -ErrorAction SilentlyContinue
    Copy-Item -Recurse -Force $savePath $noitaSaveDir
    Write-Host "[OK] Save loaded from: $savePath"
}

switch ($Action) {
    "save" { Save-Backup }
    "load" { Load-Backup }
}
