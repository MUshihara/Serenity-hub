-- SERENITY HUB // +1 SUPERHERO EVOLUTION ACCESS V2 COMPATIBILITY BRIDGE
-- Runs the exact canonical Access V2 core/UI/providers/webhook while presenting
-- a legacy-supported identity only to the protected route compatibility layer.

local realGame=game
local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local CORE_URL=BASE.."dist/access-v2/core.lua"

local function isTargetGame()
    if realGame.PlaceId==97824450589417 or realGame.GameId==10577588270 then
        return true
    end

    local RS=realGame:GetService("ReplicatedStorage")
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

    local ok,info=pcall(function()
        return realGame:GetService("MarketplaceService"):GetProductInfo(realGame.PlaceId)
    end)
    if ok and type(info)=="table" and type(info.Name)=="string" then
        local name=string.lower(info.Name)
        return string.find(name,"superhero",1,true)~=nil
            and string.find(name,"evolution",1,true)~=nil
    end

    return false
end

if not isTargetGame() then
    error("[SERENITY HUB] This Access V2 route is only for +1 Superhero Evolution.",0)
end

local function replacePlain(source,old,new,label)
    local p=string.find(source,old,1,true)
    if not p then
        error("[SERENITY HUB] "..tostring(label),0)
    end
    return string.sub(source,1,p-1)..new..string.sub(source,p+#old)
end

local function replaceAllPlain(source,old,new)
    local count=0
    local start=1
    local out={}
    while true do
        local p=string.find(source,old,start,true)
        if not p then
            out[#out+1]=string.sub(source,start)
            break
        end
        out[#out+1]=string.sub(source,start,p-1)
        out[#out+1]=new
        count=count+1
        start=p+#old
    end
    return table.concat(out),count
end

local url=CORE_URL.."?superhero=canonical&cb="..tostring(os.time())..tostring(math.random(100000,999999))
local ok,source=pcall(function()
    return realGame:HttpGet(url,true)
end)
url=nil
if not ok or type(source)~="string" or source=="" then
    error("[SERENITY HUB] Canonical Access V2 core is unavailable.",0)
end

-- The canonical core already contains the Superhero post-verification launch.
-- Force those two internal checks while the protected legacy router sees a
-- known-supported compatibility identity.
local superheroCheck='if game.PlaceId==97824450589417 or game.GameId==10577588270 then'
local checkCount
source,checkCount=replaceAllPlain(source,superheroCheck,'if true then')
if checkCount<2 then
    error("[SERENITY HUB] Superhero Access V2 route patch mismatch.",0)
end

-- The webhook runs inside the compatibility identity. Keep its visible game
-- label correct while retaining the exact canonical webhook destination/body.
source=replacePlain(
    source,
    '[10561352230]="+1 Drain Water Per Click",',
    '[10561352230]="+1 Superhero Evolution",',
    "Superhero webhook label patch mismatch."
)

local fn,err=loadstring(source,"@SerenityHub/AccessV2-Superhero-Canonical")
source=nil
if not fn then
    error("[SERENITY HUB] Canonical Access V2 compile failed: "..tostring(err),0)
end

if type(setfenv)~="function" then
    error("[SERENITY HUB] This executor does not support the Access V2 compatibility environment.",0)
end

-- Drain Water is already accepted by the protected legacy route. Only the
-- identity fields are substituted; all services, HTTP, UI, clipboard, key
-- verification, saved receipt logic, and webhook requests use the real game.
local proxy={}
function proxy:GetService(name)
    return realGame:GetService(name)
end
function proxy:HttpGet(requestUrl,cache)
    return realGame:HttpGet(requestUrl,cache)
end
function proxy:IsLoaded()
    return realGame:IsLoaded()
end
setmetatable(proxy,{
    __index=function(_,key)
        if key=="GameId" then return 10561352230 end
        if key=="PlaceId" then return 103883942725157 end
        local value=realGame[key]
        if type(value)=="function" then
            return function(_,...)
                return value(realGame,...)
            end
        end
        return value
    end
})

local baseEnv=(type(getfenv)=="function" and getfenv()) or _G
local env=setmetatable({game=proxy},{__index=baseEnv})
setfenv(fn,env)
return fn()
