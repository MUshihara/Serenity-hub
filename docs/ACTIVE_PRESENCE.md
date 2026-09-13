# Active-session counter

The shared V3 entrypoint starts anonymous presence after a successful UI build.
Endpoint: https://serenity-active.makimnaritn.workers.dev

- POST /heartbeat with a random session UUID on startup, then 120 seconds after each request completes.
- One deferred task per executor environment; re-execution cancels the previous task and reuses its ID.
- UI minimization does not stop presence. Runtime destruction cancels it. Server expiry removes the session from the count after 300 seconds without a heartbeat.
- Only the session UUID is submitted. No username, user ID, place, profile or history is sent by this client. Cloudflare infrastructure logging is separate.
- Request failure is silent and never blocks UI initialization. Unsupported request environments skip presence.
- Timeout=10 is a request-library hint; unsupported timeouts cannot guarantee cancellation of native network operations. Requests are sequential, never accumulated.
- Users receive a one-time session-counting notice. Set getgenv().SerenityPresenceEnabled=false before execution to opt out; an active task also checks this flag before its next request.
- Counts estimate sessions, not unique humans. Teleports/new executor environments can overlap until expiry. Public reports can be spoofed. No historical analytics are kept by the application; expired rows are pruned on heartbeat/count access.
- Cloudflare quotas still apply. At 120-second intervals, a continuously active session generates about 720 heartbeat requests/day; D1 writes and dashboard requests add separate usage.

Deployment changes only dist/ui/serenity-v3.lua. Existing root loader URL and game payloads stay intact. Already-running sessions must re-execute to receive the integration. Scripts bypassing the shared V3 entrypoint are outside its coverage.

Validation: user confirmed live /heartbeat HTTP 200 and displayed count 1. Local Lua 5.4-compatible mocked tests passed for Phonk/universal routing, scheduling, re-execution, cleanup, failure handling, opt-out and unsupported executors. Full integration still requires Roblox execution after publication.

## In-hub display

Both shared UI adapters display Active now in a separate orange-accented 66 px card between the avatar profile and What's new. The profile is 94 px high and the content scroller begins at 104 px. The presence card is the first scrolling item (LayoutOrder=-1), with a 26 px count, static status dot and Across Serenity subtitle. No decorative animation or additional network traffic was added. This is the global session total across participating games, not the current game's player count.

The existing heartbeat task makes one additional GET /active per cycle only while About is visible. Minimized windows and other pages skip that read. The two-minute interval begins after requests complete; returning to About may wait until the next cycle. Failed reads clear the value; the existing profile timer clears readings older than 150 seconds. No extra polling task, frame callback, or Cloudflare deployment is required.

Validation: both modified bundles compile in the Lua 5.4-compatible subset; mocked entrypoint tests cover visible/hidden reads, HTTP errors, invalid counts, recovery, reruns and cleanup. Visual PC/mobile verification is pending user execution.
