# Shared UI languages

The production Phonk and universal V3 adapters include ten languages: English, Filipino, Indonesian, Vietnamese, Thai, Spanish, Brazilian Portuguese, French, German and Russian.

Choose Settings > Appearance > Language. English is always the initial default, regardless of Roblox locale. Manual choices save in each game's existing UI configuration. Reset saved UI settings restores English. Re-execute the normal loader to obtain the update; its URL is unchanged.

Translations are bundled locally: no translation API or additional translation requests. Known shared UI and common feature labels translate immediately. Unlisted game-specific phrases remain English. This is not full automatic translation of arbitrary game manifests. Player names, game titles, typed feedback, callback keys and saved gameplay values remain original. Existing layout and scale defaults are retained; translated labels may wrap within their existing space.

## Maintaining translations

Edit src/ui/localization/translations.txt: each line is English|Filipino|Indonesian|Vietnamese|Thai|Spanish|Portuguese|French|German|Russian. Keep ten columns, unique English keys and no literal pipe characters within phrases. Add future game feature labels here without changing their control IDs. Runtime binding logic lives in src/ui/localization/i18n-core.lua.

Run `python scripts/build-ui-locales.py` to rebuild the marked translation sections in both dist/ui/phonk-v3-1-0.lua and dist/ui/universal-v3-2-0.lua. Commit sources and both generated bundles together. Shared V3 manifests receive the selector automatically; legacy V12 adapters are not changed.

## Release validation

Mocked Roblox tests passed for both production adapters: all ten language selections, English default despite a Spanish Roblox locale, saved language restoration, deferred selection rendering and Filipino confirmation, unchanged feedback drafts, stable canonical option values, original desktop row height, viewport resizing and connection cleanup. The universal fixture verified 51 game controls, gameplay callback isolation, saved gameplay state, reset and runtime cleanup. These checks do not replace live PC/mobile testing of every supported game.
