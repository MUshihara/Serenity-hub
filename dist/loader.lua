-- SERENITY HUB // ACCESS V2 ENTRY

-- One-time cleanup: only SerenityHub/.access is used by the current gate.
pcall(function()
    if type(delfile)=="function" and type(isfile)=="function"
        and isfile("SerenityHub/.access-v2.dat") then
        delfile("SerenityHub/.access-v2.dat")
    end
end)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local function isSuperheroEvolution()
    -- Primary identity checks.
    if game.PlaceId==97824450589417 or game.GameId==10577588270 then
        return true
    end

    -- Runtime/sub-place fallback: identify the game by a combination of
    -- replicated controllers, remotes, and world objects unique to this build.
    local RS=game:GetService("ReplicatedStorage")
    local Client=RS:FindFirstChild("Client")
    local Shared=RS:FindFirstChild("Shared")
    local Remotes=Shared and Shared:FindFirstChild("Remotes")

    local controllerMatch=Client
        and Client:FindFirstChild("ItemController")
        and Client:FindFirstChild("DataController")

    local remoteMatch=Remotes
        and Remotes:FindFirstChild("RequestRebirth")
        and Remotes:FindFirstChild("RequestWorldChange")
        and Remotes:FindFirstChild("EnemyMeleeContact")

    local worldMatch=workspace:FindFirstChild("BossFightStage")
        and workspace:FindFirstChild("CombatZoneTrigger")
        and (workspace:FindFirstChild("MapTest") or workspace:FindFirstChild("Map3"))

    return controllerMatch and remoteMatch and worldMatch and true or false
end

local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local targetSuperhero=isSuperheroEvolution()
local path=targetSuperhero and "dist/access-v2/superhero.lua" or "dist/access-v2/core.lua"
local U=BASE..path
local source=game:HttpGet(
    U.."?v=20260826-superhero-fingerprint&cb="..tostring(os.time())..tostring(math.random(100000,999999)),
    true
)
local fn,err=loadstring(source,targetSuperhero and "@SerenityHub/AccessV2-Superhero" or "@SerenityHub/AccessV2")
source=nil
if not fn then
    error("[SERENITY HUB] Access V2 entry compile failed: "..tostring(err),0)
end
return fn()
