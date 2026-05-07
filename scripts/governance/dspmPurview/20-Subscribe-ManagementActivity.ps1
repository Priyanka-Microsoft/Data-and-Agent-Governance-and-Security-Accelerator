# Filename: 20-Subscribe-ManagementActivity.ps1
param([Parameter(Mandatory=$true)][string]$SpecPath)
$spec = Get-Content $SpecPath -Raw | ConvertFrom-Json

if(-not $spec.activityExport -or -not $spec.activityExport.contentTypes -or -not $spec.activityExport.contentTypes.Count){
	Write-Host "No activityExport.contentTypes configured. Skipping audit subscription setup." -ForegroundColor Yellow
	exit 0
}

$_importSafePath = Join-Path $PSScriptRoot "..\..\common\Import-AzModuleSafe.ps1"
. $_importSafePath
Import-AzModuleSafe Az.Accounts
$token = (Get-AzAccessToken -ResourceUrl "https://manage.office.com").Token
$h = @{ Authorization = "Bearer $token" }
$base = "https://manage.office.com/api/v1.0/$($spec.tenantId)/activity/feed/subscriptions"
foreach($ct in $spec.activityExport.contentTypes){
	try{
		Invoke-RestMethod -Method POST -Uri "$base/start?contentType=$ct" -Headers $h -ErrorAction SilentlyContinue | Out-Null
	}catch{}
}
Write-Host "Subscriptions ensured"