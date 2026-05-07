# Filename: 22-Ship-AuditToStorage.ps1
param([Parameter(Mandatory=$true)][string]$StorageAccount,[Parameter(Mandatory=$true)][string]$Container,[Parameter(Mandatory=$true)][string]$LocalPath)
$_importSafePath = Join-Path $PSScriptRoot "..\..\common\Import-AzModuleSafe.ps1"
. $_importSafePath
Import-AzModuleSafe Az.Accounts, Az.Storage
$ctx = (Get-AzStorageAccount -Name $StorageAccount -ErrorAction Stop).Context
Get-ChildItem -Path $LocalPath -File | ForEach-Object {
  Set-AzStorageBlobContent -File $_.FullName -Container $Container -Blob $_.Name -Context $ctx -Force | Out-Null
  Write-Host "Uploaded $($_.Name) to $StorageAccount/$Container" -ForegroundColor Green
}