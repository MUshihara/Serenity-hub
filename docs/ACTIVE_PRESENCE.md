# Serenity presence and execution analytics

## Meaning
- Active now: anonymous sessions with a heartbeat in the last 300 seconds. Not exact unique people.
- Executions: successful builds through the shared V3 entrypoint, including reruns. A failed UI build does not count. No backfill before analytics deployment.
- Today/month: calendar periods in Philippine time (UTC+8). All time: since tracking began.
- Dashboard supports 30 daily buckets, 12 monthly buckets and cumulative monthly totals from the beginning. Empty periods show zero.

## Deployment
Cloudflare Worker source: services/active-counter/worker.js. Paste it into the existing serenity-active Worker and Deploy. Keep D1 binding DB -> serenity-presence. Schema additions are CREATE IF NOT EXISTS; existing presence is preserved. Tables and trigger initialize on first API request. No credentials or new bindings required.
Website: https://serenity-active.makimnaritn.workers.dev

## Client
Shared entrypoint dist/ui/serenity-v3.lua creates a fresh random execution UUID for each successful Build, alongside a reusable anonymous session UUID. The execution ID rides in the existing POST /heartbeat and retries with the SAME ID until executionRecorded=true. The previous Worker remains compatible but does not acknowledge analytics; this allows backend rollout after client publication. No extra client request or timer was added for execution history.

A deferred task sends sequential heartbeat requests about every 120 seconds. Timeout=10 is a library hint, not a guaranteed native cancellation. Rerun cancels the previous task; runtime destruction cancels it. Minimizing retains presence. Unsupported request functions skip tracking. Set getgenv().SerenityPresenceEnabled=false before execution to opt out. A brief anonymous-usage notice is shown once per environment. No username, user ID, place, profile or game data is submitted.

## Storage and reliability
presence stores session+expiry. execution_events stores random event ID+server-received Philippine date, retained to deduplicate retries. An AFTER INSERT trigger increments execution_days only for a newly inserted event. Duplicate INSERT OR IGNORE does not fire that trigger. A transactional D1 batch updates presence and inserts events atomically. Daily aggregates and analytics start metadata are retained. Events are attributed to their first successful receipt date, including delayed retries.

This stores anonymous execution history, not unique-user history. Public client reports can be spoofed. If a client closes before delivering its event, it can be missed. New sessions after teleport can overlap old presence until expiry. Only scripts reaching this shared UI entrypoint are covered. Cloudflare logging is separate from application data.

## In-hub card
Both UI adapters display a 66px orange card between the 94px avatar profile and What's new. The count GET /active occurs on the existing two-minute cycle only while About is visible; stale/error values clear to a dash. No animation or per-frame polling is added.

## Cost
Backend history adds database writes/storage per execution and aggregate reads for dashboard refreshes. It does not add client requests. Existing continuously active sessions send approximately 720 heartbeat requests per day; visible About pages add count reads. Cloudflare plan quotas still apply.

## Checks
Local Lua mocks cover routing, lifecycle, opt-out, rerun cancellation, request errors, identical event retries, explicit acknowledgment and new IDs on reruns. Worker/dashboard JavaScript parses; UUID/body-limit routes tested. SQLite checks cover schema migration, trigger deduplication, daily/month boundaries and all-time aggregation. Cloudflare analytics and visual dashboard validation await manual Worker deployment.
