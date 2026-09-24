-- MANUAL TEST ONLY. This does not load or replace the production Serenity loader.
if game.PlaceId~=104809044319701 and game.GameId~=10544327471 then
    warn("[Serenity test] This test is only available in +1 Phonk Evolution.")
    return
end
local env=(getgenv and getgenv()) or _G
env.__SERENITY_COMMUNITY_LOAD=(env.__SERENITY_COMMUNITY_LOAD or 0)+1
local generation=env.__SERENITY_COMMUNITY_LOAD
local prior=env.__SERENITY_PHONK_COMMUNITY_TEST
if prior and prior.Stop then prior:Stop() end
local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/dist/tests/phonk-community-v1/"
local function get(name)
    local source=game:HttpGet(BASE..name.."?test="..tostring(os.time()),true)
    if generation~=env.__SERENITY_COMMUNITY_LOAD then return nil end
    local fn,err=loadstring(source,"@SerenityCommunityTest/"..name)
    if not fn then error(err) end
    return fn()
end
local ok,result=pcall(function()
    local core=get("core.lua")
    if not core then return end
    local start=get("client.lua")
    if not start or generation~=env.__SERENITY_COMMUNITY_LOAD then return end
    return start(core)
end)
if not ok then
    if generation==env.__SERENITY_COMMUNITY_LOAD then
        local current=env.__SERENITY_PHONK_COMMUNITY_TEST
        if current and current.Stop then current:Stop() end
    end
    warn("[Serenity test] Could not start: "..tostring(result))
end
return ok and result or nil
