# Phonk community test v1

Manual test only. Production loader.lua and shared UI are not modified or linked to
these files. Both loader.lua and client.lua reject games other than Phonk place
104809044319701 / universe 10544327471 before building UI or making API requests.
Nothing automatically executes in other games or for existing Serenity users.

Run normal Serenity in Phonk, then run this separately:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/dist/tests/phonk-community-v1/loader.lua"))()
```

Tap Community · Test at the bottom right. Test warning shows a local top-center
preview; no backend moderation or announcement is created. Stop test cancels
listeners/requests where executor cancellation permits, disconnects handlers and
destroys test UI. Late HTTP results are ignored after stop. Rerunning stops the old
instance. Stop does not unload the ordinary Serenity game script.

## What is included
- Compact top-center 100px warning banner, wrapping text, close button, 4–12 second
  bounded display, no blur or forced sound. Warning IDs are remembered across
  re-executions in the same executor environment; when the backend supplies no ID,
  creation time/message is used. A bounded 256-entry cache can eventually evict old
  IDs; it is not persisted across rejoins. Stable warning IDs are recommended.
- Announcements checked about every 10 seconds; failures back off to 120 seconds.
  Explicit game targeting takes precedence over an everyone/default field. Missing
  targets are skipped. Known expiry timestamps are checked. No second-host probing
  or localhost fallbacks. Category is displayed in the banner title.
- Chat starts minimized, with no chat/moderation polling until opened. Messages
  refresh about every 4 seconds while open, moderation about every 15 seconds, and
  failures back off. In-flight fetches can finish after minimization; no new chat
  poll begins while closed. Announcements continue until Stop test.
- Latest 100 messages; server-provided translations selectable through six existing
  API room/language codes. No Google requests, no invented translations. This is
  not a ten-language UI rollout. Names/messages are ordinary escaped TextLabels.
- Send cooldown and 200 Unicode-character limit, current moderation check before
  posting, clear error feedback, no automatic message retries. Ban affects chat UI
  only, never claims to disable the entire hub. No extra online-count request loop.
- Window width/height fit the viewport without shrinking fonts; viewport changes
  resize the test UI. Roblox device testing is still required.

## Live-service scope
This prototype consumes the TripNation module API contract at serenityhub.site/api.
Only the test UI is isolated: pressing Send posts to the existing LIVE global chat,
visible to other users. Test warning is purely local. This code sends no broadcast,
warning creation, mute, ban or stats heartbeat requests. No production backend or
Render code was edited. Test sources are public, manually opt-in files.

Backend identity verification, staff permissions, filtering and rate-limit enforcement
remain unverified until its source is supplied. Client-side moderation checks are not
security enforcement. Server warnings received while chat is closed are shown on its
next open/check; do not rely on these for hub-wide access control.

## Try before any rollout
1. In Phonk, execute ordinary Serenity then the test loader. Confirm only the small
   Community button appears initially, plus a short test notice.
2. Open it and press Test warning. Check portrait and landscape, readable text and X.
3. Execute the test again; confirm there is one button/window and one listener set.
4. Verify a genuine server warning appears once per ID while chat is open.
5. Check an existing Phonk-targeted announcement, then confirm unrelated game
   announcements do not display. Do not publish an everyone broadcast just to test.
6. If sending a message, remember it reaches the live chat. Check muted/blocked cases
   using a designated test account controlled by you and the backend owner.
7. Stop test and confirm ordinary Serenity continues working.
8. The loader must return immediately if manually attempted in a different game.

Local Lua tests verify targeting, warning ID deduplication, bounds, wrong-game guards,
closed-chat polling suppression, no blur creation, repeated execution and Stop cleanup.
They simulate Roblox services and HTTP; they are not proof of live device rendering
or backend security. No test messages or announcements were sent during development.
