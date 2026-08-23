-- SERENITY HUB // ACCESS V2 ISOLATED D TEST ENTRY
local U="https://raw.githubusercontent.com/MUshihara/Serenity-hub/access-v2-verifier-sync-20260824/dist/access-v2/core.lua"
local source=game:HttpGet(U.."?v=20260824-mainstyle-keyfix-d-branch-"..tostring(os.time()),true)
local fn,err=loadstring(source,"@SerenityHub/AccessV2-D-BranchTest")
source=nil
if not fn then
    error("[SERENITY HUB] Access V2 D branch entry compile failed: "..tostring(err),0)
end
return fn()
