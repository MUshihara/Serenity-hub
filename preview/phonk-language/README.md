# Phonk Evolution language preview v2

UI-only preview. No automation callbacks, feedback POSTs or presence/analytics requests. This branch does not change the public main loader or any public game payload. Uses a Phonk control fixture, not the protected runtime.

## Run
Open a fresh +1 Phonk Evolution session, without running the normal Serenity loader alongside it. Execute:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/Serenity-hub/phonk-language-preview-v1/preview/phonk-language/loader.lua"))()
```

It opens Settings > Appearance. Switch Language there. English is always the default. Roblox locale does not change the language. The old Automatic option migrates to English; explicitly chosen languages still persist. Ten languages: English, Filipino, Indonesian, Vietnamese, Thai, Spanish, Brazilian Portuguese, French, German, Russian. Portuguese regional variants currently use the Brazilian pack; tl/fil map to Filipino.

Translations are bundled. No translation API or background translation polling. Unknown phrases stay English. This is a first-pass translation preview: native-speaker corrections are welcome. Proper names, numbers, IDs and user-entered text are preserved. All Phonk control titles are translated; some diagnostic/context text remains English.

## What to test
- PC and mobile portrait/landscape: readable text, long labels, Thai/Vietnamese/Russian glyphs and dropdown scrolling.
- Switch through all ten languages without closing the window. No control values should change.
- Search using a translated control title or the original English title.
- Pick a language, close and rerun: choice should persist if the executor supports readfile/writefile/isfile.
- A fresh config or old Automatic selection must show English, even if Roblox uses another language.
- Minimize/reopen, open multiple dropdowns, and reset saved preview config.
- Type a feedback draft and change language: typed content stays intact. Submit only shows a preview notice; no report is sent.

A small language pack cannot translate new future strings automatically. Add new keys to translations.txt before rebuilding, or accept the English fallback.

## Isolation
Preview config: SerenityHub/ui-phonk-language-preview-v1.json. Runtime key: __SERENITY_PHONK_LANGUAGE_PREVIEW. ScreenGui: SerenityPhonkLanguagePreview. Rerunning destroys only this preview. Game controls are demonstrative; toggles do not farm, teleport or modify the game. Active-now card is intentionally unavailable (dash). Settings actions such as color, scale and language work.

## Build and checks
Base UI is dist/ui/phonk-v3-1-0.lua as pinned in this preview branch. Run from repository root:

```sh
python preview/phonk-language/build.py
python preview/phonk-language/tests/run-lua.py preview/phonk-language/tests/test-locale.lua
python preview/phonk-language/tests/run-lua.py preview/phonk-language/tests/test-ui.lua
```

The Python runner uses liblua5.4.so.0, checks the shared Lua/Luau syntax subset and mocked Roblox behavior. It is not an in-engine visual test. Tests cover 118 entries per translation pack, all Phonk control titles, English default, deferred selection display, dynamic strings, saved settings, unchanged canonical values, draft preservation, popup cleanup, viewport changes and public-runtime isolation. Visual sizing/font rendering still requires PC/mobile testing.

Reference: https://create.roblox.com/docs/reference/engine/classes/LocalizationService

## v2 feedback fixes
Restored original 44px desktop/48px touch switch rows and original header/slider spacing; removed the oversized language help panel. The selected native language name stays in the field, its dropdown check is vertically centered, and the confirmation names the selected language. Fixed pending Roblox property-change events overwriting selection summaries during translation refresh. Tabs retain compact dimensions and adapt to translated labels. No production main changes.
