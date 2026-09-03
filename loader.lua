-- SERENITY HUB // CANONICAL PUBLIC LOADER
-- Keep this root file tiny and stable.

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"

local isUnscathedRNG=
    game.PlaceId==122951224417794
    or game.GameId==8959257868

local path=isUnscathedRNG
    and "dist/games/unscathedrng.lua"
    or "dist/loader.lua"

local chunkName=isUnscathedRNG
    and "@SerenityHub/Game-UnscathedRNG"
    or "@SerenityHub/CurrentLoader"

local url=BASE..path.."?cb="..tostring(os.time())..tostring(math.random(100000,999999))

local ok,source=pcall(function()
    return game:HttpGet(url,true)
end)

if not ok or type(source)~="string" or source=="" then
    error("[SERENITY HUB] Current loader is unavailable. Try again in a moment.",0)
end

local fn,err=loadstring(source,chunkName)
source=nil

if not fn then
    error("[SERENITY HUB] Loader compile failed: "..tostring(err),0)
end

return fn()
