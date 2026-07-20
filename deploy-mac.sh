#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
echo "Installing dependencies..."
npm install
echo "Sign in to Cloudflare in the browser window that opens."
npx wrangler login
if grep -q 'REPLACE_WITH_YOUR_D1_DATABASE_ID' wrangler.toml; then
  echo "Creating D1 database..."
  OUT=$(npx wrangler d1 create prompt-engineering-quiz 2>&1 | tee /dev/tty)
  DBID=$(printf "%s" "$OUT" | sed -n 's/.*database_id = "\([^"]*\)".*/\1/p' | tail -1)
  if [ -z "$DBID" ]; then
    echo "Could not automatically read the database ID. Copy it into wrangler.toml, then run this script again."
    exit 1
  fi
  python3 - <<PY2
from pathlib import Path
p=Path('wrangler.toml')
s=p.read_text().replace('REPLACE_WITH_YOUR_D1_DATABASE_ID', '$DBID')
p.write_text(s)
PY2
fi
echo "Initializing database..."
npm run db:init
echo "Setting quiz password. Type scb320 when prompted."
npm run password:set
echo "Deploying to prompt-engineering.pages.dev..."
npm run deploy
echo "Deployment complete."