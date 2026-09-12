-- SERENITY HUB // CANONICAL PUBLIC LOADER
-- Keep this root file tiny and stable. It always pulls the newest router
-- with cache-busting so existing public loadstrings never need to change.

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local isStealASeed=game.PlaceId==122216176958450 or game.GameId==10764328008
local isLiftACube=game.PlaceId==109530157755211 or game.GameId==10759860151

if isStealASeed or isLiftACube then
    local env=(type(getgenv)=="function" and getgenv()) or _G
    env.__SERENITY_PAYLOAD_AUTHORIZED=true
    _G.__SERENITY_PAYLOAD_AUTHORIZED=true
end

local target
local chunkName

if isStealASeed then
    target="dist/runtime/games/stealaseed.lua"
    chunkName="@SerenityHub/Game-StealASeed"
elseif isLiftACube then
    target="dist/runtime/games/liftacube.lua"
    chunkName="@SerenityHub/Game-LiftACube"
else
    target="dist/loader.lua"
    chunkName="@SerenityHub/CurrentLoader"
end

local url=BASE..target.."?cb="..tostring(os.time())..tostring(math.random(100000,999999))

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