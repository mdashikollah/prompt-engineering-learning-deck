$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
Write-Host "Installing dependencies..."
npm install
Write-Host "Sign in to Cloudflare in the browser window that opens."
npx wrangler login
$wrangler = Get-Content "wrangler.toml" -Raw
if ($wrangler -match "REPLACE_WITH_YOUR_D1_DATABASE_ID") {
  Write-Host "Creating D1 database..."
  $output = npx wrangler d1 create prompt-engineering-quiz 2>&1 | Tee-Object -Variable createOutput
  $text = ($createOutput | Out-String)
  $match = [regex]::Match($text, 'database_id\s*=\s*"([^"]+)"')
  if (-not $match.Success) {
    throw "Could not automatically read the database ID. Copy it into wrangler.toml and run this script again."
  }
  $dbid = $match.Groups[1].Value
  $wrangler = $wrangler.Replace("REPLACE_WITH_YOUR_D1_DATABASE_ID", $dbid)
  Set-Content "wrangler.toml" $wrangler
}
Write-Host "Initializing database..."
npm run db:init
Write-Host "Setting quiz password. Type scb320 when prompted."
npm run password:set
Write-Host "Deploying to prompt-engineering.pages.dev..."
npm run deploy
Write-Host "Deployment complete."