# NEXUS//WATCH deploy script
# 使い方:  ./deploy.ps1              ← GitHub Pages に即デプロイ
#          ./deploy.ps1 -Message "fix"
#          ./deploy.ps1 -Provider vercel   (Vercelへ / 初回のみログイン)
#          ./deploy.ps1 -Provider netlify  (Netlifyへ / 初回のみログイン)
param(
  [string]$Message = "update dashboard",
  [ValidateSet("github","vercel","netlify")]
  [string]$Provider = "github"
)

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $here

try {
  if ($Provider -eq "github") {
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
    Write-Host "LIVE → https://undercerberus.github.io/nexus-watch/" -ForegroundColor Cyan
    Write-Host "(GitHub Pages の再ビルド完了まで約1〜2分)" -ForegroundColor DarkGray
  }
  elseif ($Provider -eq "vercel") {
    npx --yes vercel@latest deploy --prod --yes .
    Write-Host "LIVE → Vercel が表示する URL を確認してください" -ForegroundColor Cyan
  }
  elseif ($Provider -eq "netlify") {
    npx --yes netlify-cli@latest deploy --prod --dir .
    Write-Host "LIVE → Netlify が表示する URL を確認してください" -ForegroundColor Cyan
  }
}
finally {
  Pop-Location
}
