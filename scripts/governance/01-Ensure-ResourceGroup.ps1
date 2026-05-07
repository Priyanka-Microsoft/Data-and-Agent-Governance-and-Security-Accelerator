# Filename: 01-Ensure-ResourceGroup.ps1
param([Parameter(Mandatory=$true)][string]$SpecPath)
$spec = Get-Content $SpecPath -Raw | ConvertFrom-Json
$ensureContextPath = Join-Path $PSScriptRoot "..\common\Ensure-AzContext.ps1"
. $ensureContextPath
Import-AzModuleSafe Az.Accounts, Az.Resources
Ensure-AzContext -TenantId $spec.tenantId -SubscriptionId $spec.subscriptionId
$rg = Get-AzResourceGroup -Name $spec.resourceGroup -ErrorAction SilentlyContinue
if (!$rg) { New-AzResourceGroup -Name $spec.resourceGroup -Location $spec.location | Out-Null; Write-Host "Created RG" -ForegroundColor Green } else { Write-Host "RG exists" -ForegroundColor DarkGray }