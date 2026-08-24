--[[
    SERENITY HUB // ACCESS V2 CURRENT-KEY GATE

    Canonical behavior:
      * The current raw key lives only at the shared remote key source.
      * SerenityHub/.access stores only a derived receipt, never the raw key.
      * Every launch fetches the CURRENT raw key and derives the expected receipt.
      * Changing access_key.txt intentionally invalidates old receipts and reopens the key UI.
      * There is no fixed-key / transformed-key fallback in the loader.

    The already-tested protected core remains the route/launch engine. This wrapper
    replaces only its old access persistence/key verification behavior at runtime.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

local BASE = "https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local PROTECTED = BASE .. "dist/access-v2/core-protected.lua"
local UIPATCH = BASE .. "dist/access-v2/ui-mainstyle-keyfix.lua.txt"

-- Build the key URL in pieces so the complete destination is not stored as one
-- literal in the public entry file. This is obfuscation only; the remote key is
-- intentionally the authority, not a client-side secret.
local KEY_URL = BASE .. ("access_" .. "key" .. ".txt")
local ACCESS_DIR = "SerenityHub"
local ACCESS_FILE = ACCESS_DIR .. "/.access"

local MOD = 4294967291

local function trim(s)
    s = tostring(s or "")
    -- UTF-8 BOM
    if #s >= 3 and string.byte(s,1) == 239 and string.byte(s,2) == 187 and string.byte(s,3) == 191 then
        s = string.sub(s,4)
    end
    s = string.gsub(s, "^%s+", "")
    s = string.gsub(s, "%s+$", "")
    return s
end

-- Exact Access V2 hash primitive. This is the same DJB-style primitive used by
-- the existing Access V2 verifier; the receipt construction below is now the
-- canonical V2 receipt format going forward.
local function accessHash(s)
    local q = 5381
    for i = 1, #s do
        q = (q * 33 + string.byte(s, i) + 17) % MOD
    end
    return q
end

local function receiptFor(rawKey, userId)
    rawKey = trim(rawKey)
    local uid = tostring(userId or 0)
    local a = accessHash("SERENITY|ACCESS|V2|" .. uid .. "|" .. rawKey)
    local b = accessHash(rawKey .. "|" .. uid .. "|" .. tostring(a) .. "|RECEIPT")
    return string.format("%08x%08x", a, b)
end

local function validRemoteKey(s)
    if type(s) ~= "string" then return false end
    s = trim(s)
    if s == "" or #s > 256 then return false end
    local low = string.lower(s)
    if string.find(low, "<html", 1, true) or string.find(low, "<!doctype", 1, true) then
        return false
    end
    return true
end

local function fetchCurrentKey()
    local stamp = tostring(os.time()) .. tostring(math.random(100000,999999))
    local attempts = {
        KEY_URL .. "?accessv2=" .. stamp,
        KEY_URL,
    }

    for _, url in ipairs(attempts) do
        local ok, body = pcall(function()
            return game:HttpGet(url, true)
        end)
        if not ok then
            ok, body = pcall(function()
                return game:HttpGet(url)
            end)
        end
        if ok then
            body = trim(body)
            if validRemoteKey(body) then
                return body
            end
        end
    end

    return nil
end

local function fsReady()
    return type(isfile) == "function"
        and type(readfile) == "function"
        and type(writefile) == "function"
end

local function readReceipt()
    if not fsReady() then return nil end
    local ok, exists = pcall(isfile, ACCESS_FILE)
    if not ok or not exists then return nil end
    local rok, body = pcall(readfile, ACCESS_FILE)
    if not rok then return nil end
    return trim(body)
end

local function removeInvalidReceipt()
    if type(delfile) == "function" then
        pcall(function()
            if isfile(ACCESS_FILE) then delfile(ACCESS_FILE) end
        end)
    end
end

local currentKey = fetchCurrentKey()
local expectedReceipt = currentKey and receiptFor(currentKey, LP.UserId) or nil
local savedReceipt = readReceipt()
local preverified = expectedReceipt ~= nil and savedReceipt ~= nil and savedReceipt == expectedReceipt

-- A receipt that no longer matches the CURRENT remote key is deliberately stale.
if savedReceipt and expectedReceipt and not preverified then
    removeInvalidReceipt()
end
savedReceipt = nil

local outer = game:HttpGet(PROTECTED .. "?v=current-key-v2-20260824a", true)
local uiPatch = game:HttpGet(UIPATCH .. "?v=current-key-v2-20260824a", true)

if type(outer) ~= "string" or outer == "" then
    error("[SERENITY HUB] Access V2 protected core is unavailable.", 0)
end
if type(uiPatch) ~= "string" or uiPatch == "" then
    error("[SERENITY HUB] Access V2 UI is unavailable.", 0)
end

-- The old public UI patch contained a fixed transformed fallback. Remove that
-- completely: only the current remote raw key may authorize a new receipt.
local oldVerify = [[
        local embeddedOk=(H(entered)==((2100000000+2027360581)%4294967291))
        local valid=(remoteUsable and secureEq(entered,remote)) or embeddedOk
        remote=nil
]]
local newVerify = [[
        local valid=(remoteUsable and secureEq(entered,remote))
        remote=nil
]]

local n
uiPatch, n = uiPatch:gsub(oldVerify, newVerify, 1)
if n ~= 1 then
    -- The previous conversation may have already patched the numeric fallback.
    uiPatch, n = uiPatch:gsub(
        "        local embeddedOk=%(H%(entered%)==.-%)\n        local valid=%(remoteUsable and secureEq%(entered,remote%)%) or embeddedOk\n        remote=nil\n",
        newVerify,
        1
    )
end
if n ~= 1 then
    error("[SERENITY HUB] Access V2 verifier patch mismatch.", 0)
end

-- Replace only the UI's key-source lookup. Provider/game links remain inside the
-- protected resolver and are not moved into this readable wrapper.
uiPatch = uiPatch:gsub("local keyUrl=R%(ID_KEY%)", "local keyUrl=__S2_KEY_URL", 1)

-- Replace old receipt writing with the new .access receipt. The file contains
-- exactly the derived receipt and never the user's raw key.
local oldSave = [[
        local saved,proof=saveReceipt(entered)
        proof=proof or proofFor(LP.UserId)
        applyCompat(entered,proof)
]]
local newSave = [[
        local saved=false
        if __S2_FS_READY then
            pcall(function()
                if type(makefolder)=="function" and not isfolder("SerenityHub") then
                    makefolder("SerenityHub")
                end
            end)
            local receipt=__S2_RECEIPT_FOR(entered,LP.UserId)
            local wok=pcall(writefile,"SerenityHub/.access",receipt)
            receipt=nil
            saved=wok
        end
        local proof=proofFor(LP.UserId)
        applyCompat(entered,proof)
]]
uiPatch, n = uiPatch:gsub(oldSave, newSave, 1)
if n ~= 1 then
    error("[SERENITY HUB] Access V2 receipt-save patch mismatch.", 0)
end

-- If the new .access receipt was valid against today's remote key, skip the UI
-- but still use the existing protected launch/session compatibility path.
local uiMarker = "local function New(class,props)"
local uiPos = string.find(uiPatch, uiMarker, 1, true)
if not uiPos then
    error("[SERENITY HUB] Access V2 UI marker mismatch.", 0)
end

local preamble = string.format([[
local __S2_KEY_URL=%q
local __S2_FS_READY=%s
local __S2_PREVERIFIED=%s
local __S2_CURRENT_KEY=%s
local __S2_MOD=4294967291
local function __S2_TRIM(s)
    s=tostring(s or "")
    if #s>=3 and string.byte(s,1)==239 and string.byte(s,2)==187 and string.byte(s,3)==191 then
        s=string.sub(s,4)
    end
    s=string.gsub(s,"^%%s+","")
    s=string.gsub(s,"%%s+$","")
    return s
end
local function __S2_HASH(s)
    local q=5381
    for i=1,#s do q=(q*33+string.byte(s,i)+17)%%__S2_MOD end
    return q
end
local function __S2_RECEIPT_FOR(rawKey,userId)
    rawKey=__S2_TRIM(rawKey)
    local uid=tostring(userId or 0)
    local a=__S2_HASH("SERENITY|ACCESS|V2|"..uid.."|"..rawKey)
    local b=__S2_HASH(rawKey.."|"..uid.."|"..tostring(a).."|RECEIPT")
    return string.format("%%08x%%08x",a,b)
end
if __S2_PREVERIFIED and __S2_CURRENT_KEY then
    local proof=proofFor(LP.UserId)
    applyCompat(__S2_CURRENT_KEY,proof)
    local k=__S2_CURRENT_KEY
    __S2_CURRENT_KEY=nil
    return launch(k,proof)
end
]], KEY_URL, tostring(fsReady()), tostring(preverified), currentKey and string.format("%q", currentKey) or "nil")

uiPatch = string.sub(uiPatch, 1, uiPos - 1) .. preamble .. string.sub(uiPatch, uiPos)

-- Disable the legacy receipt file inside the protected core. Access V2 now owns
-- SerenityHub/.access and validates it before the protected route engine runs.
local outerMarker = 'local FN,ER=L(SRC,"@SerenityShield/ACCESSV2-92C8406BEAB4-FINAL2")'
local outerPos = string.find(outer, outerMarker, 1, true)
if not outerPos then
    error("[SERENITY HUB] Access V2 protected-core marker mismatch.", 0)
end

local inject =
    ' SRC=string.gsub(SRC,"SerenityHub/%%.access%%-v2%%.dat","SerenityHub/.access-v2-legacy-disabled")' ..
    ' local __s2_ui_marker="local function New(class,props)"' ..
    ' local __s2_ui_pos=string.find(SRC,__s2_ui_marker,1,true)' ..
    ' if not __s2_ui_pos then error("[SERENITY HUB] Access UI marker mismatch.",0) end' ..
    ' SRC=string.sub(SRC,1,__s2_ui_pos-1)..' .. string.format("%q", uiPatch) .. ' ' ..
    outerMarker

outer = string.sub(outer, 1, outerPos - 1) .. inject .. string.sub(outer, outerPos + #outerMarker)

-- Clear plaintext remote material from this wrapper before the protected source
-- is compiled. The key still necessarily exists briefly at runtime when used.
currentKey = nil
expectedReceipt = nil
uiPatch = nil

local fn, err = loadstring(outer, "@SerenityShield/AccessV2-CurrentKey")
outer = nil
if not fn then
    error("[SERENITY HUB] Access V2 current-key build failed: " .. tostring(err), 0)
end
return fn()
