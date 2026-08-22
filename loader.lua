-- SERENITY HUB // PUBLIC LOADER COMPATIBILITY ALIAS
-- Canonical public loader: dist/loader.lua

local URL = "https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/dist/loader.lua"

local source = game:HttpGet(
    URL .. "?compat=" .. tostring(os.time()),
    true
)

local chunk, compileError = loadstring(
    source,
    "@SerenityHub/dist/loader.lua"
)

if not chunk then
    error(
        "[SERENITY HUB] Loader compatibility load failed: "
            .. tostring(compileError),
        0
    )
end

return chunk()
