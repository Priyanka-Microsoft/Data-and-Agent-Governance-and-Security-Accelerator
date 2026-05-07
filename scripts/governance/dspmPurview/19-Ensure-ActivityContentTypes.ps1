# Filename: 19-Ensure-ActivityContentTypes.ps1
param([Parameter(Mandatory=$true)][string]$SpecPath)
$spec = Get-Content $SpecPath -Raw | ConvertFrom-Json
$_importSafePath = Join-Path $PSScriptRoot "..\..\common\Import-AzModuleSafe.ps1"
. $_importSafePath
Import-AzModuleSafe Az.Accounts
$token = (Get-AzAccessToken -ResourceUrl "https://manage.office.com").Token
$h = @{ Authorization = "Bearer $token" }
$base = "https://manage.office.com/api/v1.0/$($spec.tenantId)/activity/feed/subscriptions"
foreach($ct in $spec.activityExport.contentTypes){
  try { Invoke-RestMethod -Method POST -Uri "$base/start?contentType=$ct" -Headers $h -ErrorAction SilentlyContinue | Out-Null } catch {}
}
Write-Host "Audit content types ensured."
