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

local function marketplaceName()
    local ok,info=pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if ok and type(info)=="table" and type(info.Name)=="string" then
        return string.lower(info.Name)
    end
    return nil
end

local function isGreedyGrowers()
    -- Universe identity covers the experience and future normal sub-places.
    if game.PlaceId==74102906764176 or game.GameId==10440833423 then
        return true
    end

    local name=marketplaceName()
    return name~=nil
        and string.find(name,"greedy",1,true)~=nil
        and string.find(name,"growers",1,true)~=nil
end

local function isMonkeyEvolution()
    -- Universe identity covers all normal sub-places in the experience.
    if game.PlaceId==91701030914075 or game.GameId==10605939914 then
        return true
    end

    -- Fallback for unusual executor/runtime identity behavior.
    local name=marketplaceName()
    return name~=nil
        and string.find(name,"monkey",1,true)~=nil
        and string.find(name,"evolution",1,true)~=nil
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

    if controllerMatch and remoteMatch and worldMatch then
        return true
    end

    local name=marketplaceName()
    return name~=nil
        and string.find(name,"superhero",1,true)~=nil
        and string.find(name,"evolution",1,true)~=nil
end

local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local targetGreedy=isGreedyGrowers()
local targetMonkey=not targetGreedy and isMonkeyEvolution()
local targetSuperhero=not targetGreedy and not targetMonkey and isSuperheroEvolution()

local path
local chunkName
if targetGreedy then
    path="dist/access-v2/greedy-growers.lua"
    chunkName="@SerenityHub/AccessV2-GreedyGrowers"
elseif targetMonkey then
    path="dist/access-v2/monkey.lua"
    chunkName="@SerenityHub/AccessV2-Monkey"
elseif targetSuperhero then
    path="dist/access-v2/superhero.lua"
    chunkName="@SerenityHub/AccessV2-Superhero"
else
    path="dist/access-v2/core.lua"
    chunkName="@SerenityHub/AccessV2"
end

local U=BASE..path
local source=game:HttpGet(
    U.."?v=20260826-greedy-monkey-superhero-access-v2&cb="..tostring(os.time())..tostring(math.random(100000,999999)),
    true
)
local fn,err=loadstring(source,chunkName)
source=nil
if not fn then
    error("[SERENITY HUB] Access V2 entry compile failed: "..tostring(err),0)
end
return fn()
