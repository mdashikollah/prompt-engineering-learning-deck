# Prompt Engineering Quiz — Complete Cloudflare Pages Package

This is not a static-only upload. It contains:

- `public/index.html` — the complete presentation and timed quiz
- `functions/` — server-side password, certificate creation, and certificate lookup
- `schema.sql` — shared D1 database tables
- `wrangler.toml` — Pages and D1 configuration

Certificates are stored centrally, so a 3-digit certificate generated on one participant's device can be retrieved from the Winner Announcement page on another device.

## One-time setup for prompt-engineering.pages.dev

Cloudflare dashboard drag-and-drop does not deploy Pages Functions. Use Wrangler or Git integration.

1. Install Node.js, unzip this package, and open Terminal in the package folder.
2. Run:

   npm install
   npx wrangler login
   npx wrangler d1 create prompt-engineering-quiz

3. Copy the returned D1 database ID into `wrangler.toml`, replacing:

   REPLACE_WITH_YOUR_D1_DATABASE_ID

4. Create the database tables:

   npm run db:init

5. Store the quiz password securely. When prompted, enter `scb320`:

   npm run password:set

6. Deploy the complete site to the existing Pages project:

   npm run deploy

## Future updates

After changing the presentation, run only:

   npm run deploy

## Local test

After creating the D1 database and updating `wrangler.toml`:

   npm run dev

## Capacity

A 3-digit certificate number provides 900 unique values, from 100 through 999. The API checks uniqueness before issuing each certificate.

## Prepared password

The package is configured to use `scb320`. For production, run `npm run password:set` and enter `scb320` when Wrangler asks for the secret value. The password is validated by the server-side Pages Function and is not embedded in the browser JavaScript.

## Assisted deployment

Run `./deploy-mac.sh` on macOS/Linux or `deploy-windows.ps1` in PowerShell. The script installs dependencies, opens Cloudflare login, creates/uses the D1 database, initializes the schema, stores the password secret, and deploys the Pages project. You must approve the Cloudflare login in your own browser.