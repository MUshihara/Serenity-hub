--[[ Serenity Access V2 // protected-core key-fetch repair ]]
local CORE = "https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/dist/access-v2/core-protected.lua"
local source = game:HttpGet(CORE .. "?fix=keyfetch-20260824", true)

local marker = 'local FN,ER=L(SRC,"@SerenityShield/ACCESSV2-92C8406BEAB4-FINAL2")'
local oldFetch = 'local ok,remote=pcall(httpGet,keyUrl,true) keyUrl=nil remote=ok and trim(remote) or nil'
local newFetch = 'local ok,remote=pcall(function() return game:HttpGet(keyUrl,false) end) if not ok then ok,remote=pcall(function() return game:HttpGet(keyUrl,true) end) end if not ok then ok,remote=pcall(function() return game:HttpGet(keyUrl) end) end keyUrl=nil remote=ok and trim(remote) or nil'

local pos = string.find(source, marker, 1, true)
if not pos then
    error("[SERENITY HUB] Access V2 protected-core marker mismatch.", 0)
end

local injected =
    'local __s2_old=' .. string.format("%q", oldFetch) ..
    ' local __s2_new=' .. string.format("%q", newFetch) ..
    ' local __s2_p=string.find(SRC,__s2_old,1,true)' ..
    ' if not __s2_p then error("[SERENITY HUB] Key fetch repair mismatch.",0) end' ..
    ' SRC=string.sub(SRC,1,__s2_p-1)..__s2_new..string.sub(SRC,__s2_p+#__s2_old) ' ..
    marker

source = string.sub(source, 1, pos - 1) .. injected .. string.sub(source, pos + #marker)

local chunk, err = loadstring(source, "@SerenityShield/AccessV2-KeyFetchRepair")
source = nil
if not chunk then
    error("[SERENITY HUB] Access V2 repair compile failed: " .. tostring(err), 0)
end
return chunk()
