--[[
    SERENITY HUB // ACCESS V2 CURRENT-KEY GATE

    Canonical Access V2 behavior:
      * access_key.txt is the one current raw-key authority shared by every game.
      * SerenityHub/.access stores only a derived receipt; plaintext is never saved.
      * Every launch fetches the current raw key and derives the expected receipt.
      * Changing access_key.txt invalidates old receipts and reopens the key UI.
      * Legacy .access-v2.dat and legacy in-memory shortcuts cannot authorize.
      * There is no fixed/transformed fallback key embedded in this gate.

    The existing protected core remains the route/launch engine. This wrapper
    repairs only its access gate and injects the existing Serenity key UI.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

local BASE = "https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local PROTECTED = BASE .. "dist/access-v2/core-protected.lua"
local UIPATCH = BASE .. "dist/access-v2/ui-mainstyle-keyfix.lua.txt"
local KEY_URL = BASE .. ("access_" .. "key" .. ".txt")
local ACCESS_DIR = "SerenityHub"
local ACCESS_FILE = ACCESS_DIR .. "/.access"
local MOD = 4294967291

local function trim(s)
    s = tostring(s or "")
    if #s >= 3
        and string.byte(s,1) == 239
        and string.byte(s,2) == 187
        and string.byte(s,3) == 191 then
        s = string.sub(s,4)
    end
    s = string.gsub(s,"^%s+","")
    s = string.gsub(s,"%s+$","")
    return s
end

-- Access V2 hash primitive.
local function accessHash(s)
    local q = 5381
    for i = 1, #s do
        q = (q * 33 + string.byte(s,i) + 17) % MOD
    end
    return q
end

-- Canonical receipt. Only this derived value is persisted.
local function receiptFor(rawKey,userId)
    rawKey = trim(rawKey)
    local uid = tostring(userId or 0)
    local a = accessHash("SERENITY|ACCESS|V2|" .. uid .. "|" .. rawKey)
    local b = accessHash(rawKey .. "|" .. uid .. "|" .. tostring(a) .. "|RECEIPT")
    return string.format("%08x%08x",a,b)
end

local function validRemoteKey(s)
    if type(s) ~= "string" then return false end
    s = trim(s)
    if s == "" or #s > 256 then return false end
    local low = string.lower(s)
    if string.find(low,"<html",1,true)
        or string.find(low,"<!doctype",1,true) then
        return false
    end
    return true
end

local function fetchCurrentKey()
    local stamp = tostring(os.time()) .. tostring(math.random(100000,999999))
    local urls = {
        KEY_URL .. "?accessv2=" .. stamp,
        KEY_URL,
    }

    for _,url in ipairs(urls) do
        local ok,body = pcall(function()
            return game:HttpGet(url,true)
        end)
        if not ok then
            ok,body = pcall(function()
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
    local ok,exists = pcall(isfile,ACCESS_FILE)
    if not ok or not exists then return nil end
    local rok,body = pcall(readfile,ACCESS_FILE)
    if not rok then return nil end
    return trim(body)
end

local function removeStaleReceipt()
    if type(delfile) ~= "function" then return end
    pcall(function()
        if isfile(ACCESS_FILE) then
            delfile(ACCESS_FILE)
        end
    end)
end

local function replacePlain(source,old,new,label)
    local p = string.find(source,old,1,true)
    if not p then
        error("[SERENITY HUB] " .. tostring(label),0)
    end
    return string.sub(source,1,p-1) .. new .. string.sub(source,p+#old)
end

-- Fetch CURRENT key before any old protected-core authorization path is allowed.
local currentKey = fetchCurrentKey()
local expectedReceipt = currentKey and receiptFor(currentKey,LP.UserId) or nil
local savedReceipt = readReceipt()
local preverified = expectedReceipt ~= nil
    and savedReceipt ~= nil
    and savedReceipt == expectedReceipt

if savedReceipt and expectedReceipt and not preverified then
    removeStaleReceipt()
end
savedReceipt = nil
expectedReceipt = nil

local outer = game:HttpGet(PROTECTED .. "?v=current-key-v2-20260824c",true)
local uiPatch = game:HttpGet(UIPATCH .. "?v=current-key-v2-20260824c",true)

if type(outer) ~= "string" or outer == "" then
    error("[SERENITY HUB] Access V2 protected core is unavailable.",0)
end
if type(uiPatch) ~= "string" or uiPatch == "" then
    error("[SERENITY HUB] Access V2 UI is unavailable.",0)
end

-- Remove the old fixed transformed-key fallback from the UI source.
local oldVerify = [[        local embeddedOk=(H(entered)==((2100000000+2027360581)%4294967291))
        local valid=(remoteUsable and secureEq(entered,remote)) or embeddedOk
        remote=nil
]]
local newVerify = [[        local valid=(remoteUsable and secureEq(entered,remote))
        remote=nil
]]
uiPatch = replacePlain(
    uiPatch,
    oldVerify,
    newVerify,
    "Access V2 verifier patch mismatch."
)

-- The current key was already fetched at launch. Verification uses exactly that
-- same value instead of a second endpoint/fallback with different behavior.
local oldFetch = [[        local keyUrl=R(ID_KEY)
        local ok,remote=pcall(function()
            return game:HttpGet(keyUrl,false)
        end)
        if not ok then
            ok,remote=pcall(function()
                return game:HttpGet(keyUrl,true)
            end)
        end
        if not ok then
            ok,remote=pcall(function()
                return game:HttpGet(keyUrl)
            end)
        end
        keyUrl=nil
        remote=ok and trim(remote) or nil
]]
local newFetch = [[        local ok=__S2_CURRENT_KEY~=nil
        local remote=ok and trim(__S2_CURRENT_KEY) or nil
]]
uiPatch = replacePlain(
    uiPatch,
    oldFetch,
    newFetch,
    "Access V2 current-key UI patch mismatch."
)

-- Replace the legacy receipt writer. The raw entered key is never written.
local oldSave = [[        local saved,proof=saveReceipt(entered)
        proof=proof or proofFor(LP.UserId)
        applyCompat(entered,proof)
]]
local newSave = [[        local saved=false
        if __S2_FS_READY then
            pcall(function()
                if type(makefolder)=="function" then
                    if type(isfolder)=="function" then
                        if not isfolder("SerenityHub") then
                            makefolder("SerenityHub")
                        end
                    else
                        makefolder("SerenityHub")
                    end
                end
            end)
            local receipt=__S2_RECEIPT_FOR(entered,LP.UserId)
            local wok=pcall(writefile,"SerenityHub/.access",receipt)
            receipt=nil
            saved=wok
        end
        local proof=proofFor(LP.UserId)
        applyCompat(entered,proof)
        __S2_CURRENT_KEY=nil
]]
uiPatch = replacePlain(
    uiPatch,
    oldSave,
    newSave,
    "Access V2 receipt-save patch mismatch."
)

-- Runtime helpers injected immediately before the UI. A matching .access receipt
-- can skip the UI, but only after it matched the CURRENT remote key above.
local uiMarker = "local function New(class,props)"
local uiPos = string.find(uiPatch,uiMarker,1,true)
if not uiPos then
    error("[SERENITY HUB] Access V2 UI marker mismatch.",0)
end

local preamble = string.format([[
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
    for i=1,#s do
        q=(q*33+string.byte(s,i)+17)%%__S2_MOD
    end
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
]],
    tostring(fsReady()),
    tostring(preverified),
    currentKey and string.format("%q",currentKey) or "nil"
)

uiPatch = string.sub(uiPatch,1,uiPos-1)
    .. preamble
    .. string.sub(uiPatch,uiPos)

-- These two shortcuts live BEFORE the original UI marker in the protected source.
-- They must be removed, otherwise the old receipt/session can bypass current-key
-- revalidation before our new gate gets control.
local legacySavedShortcut = [[local savedKey,savedProof=readReceipt() if savedKey and savedProof then applyCompat(savedKey,savedProof) return launch(savedKey,savedProof) end]]
local legacyEnvShortcut = [[if type(ENV.__SERENITY_ACCESS_V2)=="string" and ENV.__SERENITY_ACCESS_V2==proofFor(LP.UserId) then return launch(nil,ENV.__SERENITY_ACCESS_V2) end]]

local outerMarker = 'local FN,ER=L(SRC,"@SerenityShield/ACCESSV2-92C8406BEAB4-FINAL2")'
local outerPos = string.find(outer,outerMarker,1,true)
if not outerPos then
    error("[SERENITY HUB] Access V2 protected-core marker mismatch.",0)
end

-- This code executes inside the existing outer shield after SRC is decrypted but
-- before it is compiled. Exact/plain replacements prevent Lua pattern surprises.
local inject = string.format([[
local function __s2_replace(old,new,label)
    local p=string.find(SRC,old,1,true)
    if not p then error("[SERENITY HUB] "..label,0) end
    SRC=string.sub(SRC,1,p-1)..new..string.sub(SRC,p+#old)
end
__s2_replace(%q,"","legacy receipt shortcut mismatch")
__s2_replace(%q,"","legacy session shortcut mismatch")
local __s2_ui_marker=%q
local __s2_ui_pos=string.find(SRC,__s2_ui_marker,1,true)
if not __s2_ui_pos then error("[SERENITY HUB] Access UI marker mismatch.",0) end
SRC=string.sub(SRC,1,__s2_ui_pos-1)..%q
]],
    legacySavedShortcut,
    legacyEnvShortcut,
    uiMarker,
    uiPatch
) .. outerMarker

outer = string.sub(outer,1,outerPos-1)
    .. inject
    .. string.sub(outer,outerPos+#outerMarker)

-- Do not keep extra wrapper references to the raw key after the protected source
-- has been assembled.
currentKey = nil
uiPatch = nil

local fn,err = loadstring(outer,"@SerenityShield/AccessV2-CurrentKey-C")
outer = nil
if not fn then
    error("[SERENITY HUB] Access V2 current-key build failed: "..tostring(err),0)
end
return fn()
