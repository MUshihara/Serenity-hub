# Serenity presence and execution analytics

## Meaning
- Active now: estimated unique Roblox accounts with a heartbeat in the last 600 seconds. Rejoins and multiple devices on the same account update one entry. Different accounts held by one person still count separately.
- Executions: successful builds through the shared V3 entrypoint, including reruns. A failed UI build does not count. No backfill before analytics deployment.
- Today/month: calendar periods in Philippine time (UTC+8). All time: since tracking began.
- Dashboard supports 30 daily buckets, 12 monthly buckets and cumulative monthly totals from the beginning. Empty periods show zero.

## Deployment
Cloudflare Worker source: services/active-counter/worker.js. Paste it into the existing serenity-active Worker and Deploy. Keep D1 binding DB -> serenity-presence. Schema additions are CREATE IF NOT EXISTS; existing presence is preserved. Tables and trigger initialize on first API request. Add the Worker secret PRESENCE_HMAC_SECRET with at least 32 cryptographically random characters. Keep it stable and out of GitHub/client code. Missing or short secrets cause API requests to return 503. In Cloudflare: Workers & Pages > serenity-active > Settings > Variables and Secrets > Add > Secret, then Deploy. Add the secret before deploying this Worker code.
Website: https://serenity-active.makimnaritn.workers.dev

## Client
Shared entrypoint dist/ui/serenity-v3.lua creates a fresh random execution UUID for each successful Build, alongside a reusable random session UUID. It sends the Roblox UserId in the X-Serenity-Account header over HTTPS. The header keeps the existing body within the old 128-byte limit; old Workers ignore the header. The execution ID rides in the existing POST /heartbeat and retries with the SAME ID until executionRecorded=true. The previous Worker remains compatible but does not acknowledge analytics; this allows backend rollout after client publication. No extra client request or timer was added for execution history.

A deferred task sends sequential heartbeat requests about every 300 seconds once the Worker acknowledges interval=300 and ttl=600 (120 seconds with the old Worker during rollout). Timeout=10 is a library hint, not a guaranteed native cancellation. Rerun cancels the previous task; runtime destruction cancels it. Minimizing retains presence. Unsupported request functions skip tracking. Set getgenv().SerenityPresenceEnabled=false before execution to opt out. The startup notification is the Discord invite. No username or profile data is submitted. Game ranking now sends the Roblox universe ID and the manifest game name in the existing heartbeat headers. The Worker computes HMAC-SHA256 with its secret and stores the account hash, expiry, universe ID and game name, never the raw UserId. The Worker code does not log identifiers; do not add request-header logging.

## Storage and reliability
account_presence stores the server-generated account hash and expiry. The old presence table is retained but excluded from all counts. execution_events stores random event ID+server-received Philippine date, retained to deduplicate retries. An AFTER INSERT trigger increments execution_days only for a newly inserted event. Duplicate INSERT OR IGNORE does not fire that trigger. A transactional D1 batch updates presence and inserts events atomically. Daily aggregates and analytics start metadata are retained. Events are attributed to their first successful receipt date, including delayed retries.

This stores anonymous execution history, not unique-user history. Public client reports can be spoofed. If a client closes before delivering its event, it can be missed. Rejoining with the same Roblox account does not add an active account. A /leave request is acknowledged without deleting presence so an old session cannot remove a newer session or another device. Accounts leave the count up to ten minutes after their last heartbeat; there is no guaranteed immediate disconnect detection. Only scripts reaching this shared UI entrypoint are covered. Cloudflare logging is separate from application data.

## In-hub card
Both UI adapters display a 66px orange card between the 94px avatar profile and What's new. The heartbeat response now includes the active count, eliminating the client's separate GET /active request. It updates the cached UI count even while minimized; readings older than 360 seconds or failed responses clear to a dash. No animation or per-frame polling is added.

## Cost
Backend history adds database writes/storage per execution and aggregate reads for dashboard refreshes. It does not add client requests. Updated continuously active sessions send approximately 288 heartbeat requests per day, including the active count, plus startup/rerun traffic. The website refreshes every five minutes while visible and on manual refresh/return to the tab. Dashboard/count requests no longer delete database rows; expiry filtering still excludes inactive sessions immediately at query time. Cloudflare plan quotas still apply.

## Checks
Local Lua mocks cover routing, lifecycle, opt-out, rerun cancellation, request errors, identical event retries, explicit acknowledgment and new IDs on reruns. Worker/dashboard JavaScript parses; UUID/body-limit routes tested. SQLite checks cover schema migration, trigger deduplication, daily/month boundaries and all-time aggregation. Cloudflare analytics and visual dashboard validation await manual Worker deployment.

## Five-minute rollout
Deploy the updated services/active-counter/worker.js to the existing Cloudflare Worker; keep DB and existing tables/history. New client code safely stays on 120 seconds until a successful response explicitly advertises interval=300 and ttl=600, then switches automatically without re-execution. Existing old client loops must re-execute Serenity to send the account header. Old clients can still report executions but are excluded from account presence, so migration temporarily undercounts until users reload. The new client does not perform a fallback count GET against the old Worker, so its count displays a dash until backend deployment.

Verified locally: real SQLite-backed Worker tests for combined responses, 600-second expiry, execution retry deduplication, read-only stats, and retained history; mocked Lua tests for both adapter routes, interval negotiation, old-backend compatibility, removal of GET polling, failure/cleanup and rerun behavior. Live Cloudflare deployment is manual.


## Account migration and limitations
Do not add old session totals to account totals: that would count the same users twice. Account presence starts from updated-client reports; execution history and aggregates remain intact. The shared loader URL stays unchanged.

HMAC provides pseudonymization, not account authentication: the public endpoint cannot verify a self-reported Roblox UserId. Do not call this a fraud-proof exact headcount. Keep the secret stable; rotating it produces different hashes and can cause up to ten minutes of overlap. If rotating deliberately, clear only account_presence after rotation to reset the active estimate; do not clear analytics history.

Local regression checks cover twenty repeated rejoins of one account, two distinct accounts, legacy session exclusion, late leave requests, exact expiry, missing secrets, HMAC-only storage, event retry deduplication and retained history. These tests do not replace device testing or deploy Cloudflare.



## Active games ranking (2026-09-24)

The shared entrypoint adds `X-Serenity-Game` (Roblox `game.GameId`, a universe ID)
and optional URL-encoded `X-Serenity-Game-Name` (manifest `GameName`) to the existing
heartbeat. The 128-byte JSON body and request interval are unchanged. Old Workers
ignore these headers, allowing client-first rollout. New supported games using this
shared Build path are covered automatically; scripts bypassing it are not covered.

The Worker adds `game_id` and `game_name` columns to `account_presence` on first API
initialization. Migration preserves all rows and execution history, rechecks concurrent
column creation, and retries initialization on failure. It uses the existing account
upsert, with no additional per-heartbeat SQL statement. Expiry and HMAC settings stay
unchanged. The name is bounded and rendered with textContent, never as HTML.

`GET /stats` now includes:

```json
{
  "games": [
    {"id": "10035204815", "name": "Ride A Pet", "active": 30},
    {"id": "10708913337", "name": "Anime Dice", "active": 12},
    {"id": "unknown", "name": "Unknown / older client", "active": 3}
  ],
  "gameWindowSeconds": 600
}
```

These are illustrative values. Existing active/today/month/total/day/daily/started
fields remain available. Games sort by active descending, then universe ID ascending
for ties. Zero-active games are omitted; no accounts returns an empty list. All buckets,
including unknown, sum to active because one account contributes to one bucket.
An account's latest received game report wins; concurrent devices can move that account
between games as they report. This is a reported estimate, not verified Roblox gameplay.
No previous game history can be reconstructed, and there are no per-game execution totals.

Existing clients without game headers appear as Unknown / older client. Users must
re-execute to load the new shared entrypoint; already-running loops do not hot-update.
A legacy heartbeat after a new one moves the account to unknown because its current game
is not known. Expired accounts disappear from both totals and rankings after 600 seconds.

### Cloudflare deployment
1. Open Workers & Pages > serenity-active > Edit code.
2. Replace worker.js with services/active-counter/worker.js from this repository and Deploy.
3. Keep binding DB -> serenity-presence and the existing PRESENCE_HMAC_SECRET.
4. Fetch /stats and confirm games and gameWindowSeconds exist. Empty/unknown is expected
   before updated clients report. Open the Worker website to see Active users by game.
5. Execute the canonical loader in one supported game; refresh the website and confirm
   its bucket appears. A re-execution on the same account should not increase active.

GitHub publication updates the shared client source; it does NOT deploy the Cloudflare
Worker or the separate Render website. The Cloudflare site retains its five-minute
visible-page refresh and manual Refresh button.

### Render developer integration
Continue using the same public GET /stats endpoint. No API key or presence secret is
needed. Extend the cached proxy response to retain games and gameWindowSeconds:

```js
// Add when building cachedStats, after validating upstream data:
games: data.games,
gameWindowSeconds: data.gameWindowSeconds,
```

Validate games is an array; each row must have string id/name and a nonnegative safe
integer active. If games is absent during rollout, show Ranking not available yet rather
than claiming no active players. Render the supplied order with DOM textContent or the
framework's normal escaped text interpolation. Use the SAME cached /stats response for
the four cards and ranking; do not fetch per game or call /heartbeat from the website.
On upstream failure mark cached data stale, or show unavailable if no good data exists.
Do not show old rankings as current. Preserve the site's existing authentication.

A 60-second cache shared per backend process limits upstream fetches to about 1,440/day
per continuously requested Render process. Cold restarts, multiple processes and failures
can increase requests; cache hits do not hit Cloudflare. The Worker groups active rows
in the existing stats query instead of issuing a query per game. Grouping/reading wider
rows adds work, so this is not a guarantee of unchanged D1 billing. No new game-name
lookup service, client request loop, database table or execution write is added.

### Validation performed
Real SQLite Worker regression tests cover upgrading an existing account table,
retaining execution totals, ranking order, switching games, repeated rejoins,
legacy unknown rows, UTF-8 names, invalid metadata, exact expiry, and SELECT-only stats
after initialization. Lua mocks cover new headers, routing, interval negotiation,
retry identity, cleanup and no additional request loop. These are local tests;
Cloudflare deployment and Roblox device verification are separate rollout steps.
