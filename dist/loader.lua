-- SERENITY HUB // ACCESS V2 ENTRY
local U="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/dist/access-v2/core.lua"
local source=game:HttpGet(U.."?v=20260824-mainstyle-keyfix-d",true)
local fn,err=loadstring(source,"@SerenityHub/AccessV2")
source=nil
if not fn then
    error("[SERENITY HUB] Access V2 entry compile failed: "..tostring(err),0)
end
return fn()
