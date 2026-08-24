# NEXUS//WATCH deploy script
# 使い方:  ./deploy.ps1              ← Vercel 本番へデプロイ
#          ./deploy.ps1 -Message "fix"
#          ./deploy.ps1 -Provider github   (GitHub Pages にもミラー)
param(
  [string]$Message = "update dashboard",
  [ValidateSet("vercel","github")]
  [string]$Provider = "vercel"
)

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $here

try {
  elseif ($Provider -eq "github") {
    git add -A
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
      Write-Host "[skip] 変更なし" -ForegroundColor DarkGray
    } else {
      git commit -m $Message | Out-Null
      Write-Host "[ok] committed: $Message" -ForegroundColor Green
    }
    git push origin main
    Write-Host ""
    Write-Host "LIVE → https://nexus-watch-eosin.vercel.app  (GitHub連携で自動反映)" -ForegroundColor Cyan
    Write-Host "MIRROR → https://undercerberus.github.io/nexus-watch/  (Pages再ビルド1〜2分)" -ForegroundColor DarkGray
  }
  else {
    npx --yes vercel@latest deploy --prod --yes .
    Write-Host ""
    Write-Host "LIVE → https://nexus-watch-eosin.vercel.app" -ForegroundColor Cyan
  }
}
finally {
  Pop-Location
}
