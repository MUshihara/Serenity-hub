-- SERENITY HUB // ACCESS V2 ENTRY

-- One-time cleanup: only SerenityHub/.access is used by the current gate.
pcall(function()
    if type(delfile)=="function" and type(isfile)=="function"
        and isfile("SerenityHub/.access-v2.dat") then
        delfile("SerenityHub/.access-v2.dat")
    end
end)

local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local targetSuperhero=(game.PlaceId==97824450589417 or game.GameId==10577588270)
local path=targetSuperhero and "dist/access-v2/superhero.lua" or "dist/access-v2/core.lua"
local U=BASE..path
local source=game:HttpGet(
    U.."?v=20260826-superhero-route&cb="..tostring(os.time())..tostring(math.random(100000,999999)),
    true
)
local fn,err=loadstring(source,targetSuperhero and "@SerenityHub/AccessV2-Superhero" or "@SerenityHub/AccessV2")
source=nil
if not fn then
    error("[SERENITY HUB] Access V2 entry compile failed: "..tostring(err),0)
end
return fn()
