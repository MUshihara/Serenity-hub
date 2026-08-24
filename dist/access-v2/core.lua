--[[
    SERENITY HUB // ACCESS V2 DYNAMIC REMOTE-KEY GATE

    Canonical behavior:
      * The shared remote raw key is the only current-key authority.
      * SerenityHub/.access stores only a derived receipt, never the raw key.
      * Every loader launch re-fetches the CURRENT remote key.
      * Changing the remote key invalidates old receipts and reopens the key UI.
      * Legacy .access-v2.dat and old in-memory shortcuts cannot authorize.
      * No fixed plaintext/transformed fallback key is embedded in this gate.
]]

local Players=game:GetService("Players")
local LP=Players.LocalPlayer or Players.PlayerAdded:Wait()

local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local PROTECTED=BASE.."dist/access-v2/core-protected.lua"
local UIPATCH=BASE.."dist/access-v2/ui-mainstyle-keyfix.lua.txt"
local ACCESS_DIR="SerenityHub"
local ACCESS_FILE=ACCESS_DIR.."/.access"
local MOD=4294967291

local function trim(s)
    s=tostring(s or "")
    if #s>=3 and string.byte(s,1)==239 and string.byte(s,2)==187 and string.byte(s,3)==191 then
        s=string.sub(s,4)
    end
    s=string.gsub(s,"^%s+","")
    s=string.gsub(s,"%s+$","")
    local line=s:match("([^\r\n]+)")
    if line then s=string.gsub(line,"^%s+",""):gsub("%s+$","") end
    if #s>=2 then
        local a=string.sub(s,1,1)
        local b=string.sub(s,#s,#s)
        if (a=='\"' and b=='\"') or (a=="'" and b=="'") then
            s=string.sub(s,2,#s-1)
            s=string.gsub(s,"^%s+",""):gsub("%s+$","")
        end
    end
    return s
end

local function accessHash(s)
    local q=5381
    for i=1,#s do
        q=(q*33+string.byte(s,i)+17)%MOD
    end
    return q
end

local function receiptFor(rawKey,userId)
    rawKey=trim(rawKey)
    local uid=tostring(userId or 0)
    local a=accessHash("SERENITY|ACCESS|V2|"..uid.."|"..rawKey)
    local b=accessHash(rawKey.."|"..uid.."|"..tostring(a).."|RECEIPT")
    return string.format("%08x%08x",a,b)
end

local function validRemoteKey(s)
    if type(s)~="string" then return false end
    s=trim(s)
    if s=="" or #s>256 then return false end
    local low=string.lower(s)
    if string.find(low,"<html",1,true)
        or string.find(low,"<!doctype",1,true)
        or string.find(low,"not found",1,true)
        or string.find(low,"bad gateway",1,true) then
        return false
    end
    return true
end

local KEY_DATA={
    {206,104,130,88,213,166,169,255,166,189,117,124,19,190,127,142,104,63,25,165,169,110,135,231,121,93,113,152,167,182,174,145,18},
    {206,104,130,88,213,166,169,255,166,189,117,124,19,190,127,142,104,63,25,165,169,110,135,231,120,108,78,216,201,181,235,129,113,108,167,194,222,13,114},
    {206,104,130,88,213,166,169,255,166,189,117,124,19,190,127,142,104,63,25,165,169,120,138,191,23,75,22,249,156,164,135,244}
}
local function decodeKeyUrl(row)
    local out={}
    local q=137
    for i=1,#row do
        q=(q*73+41)%256
        out[i]=string.char(bit32.bxor(row[i],q,((i*19+137)%256)))
    end
    return table.concat(out)
end

local function fetchCurrentKey()
    for _,row in ipairs(KEY_DATA) do
        local url=decodeKeyUrl(row)
        local attempts={
            function() return game:HttpGet(url,false) end,
            function() return game:HttpGet(url,true) end,
            function() return game:HttpGet(url) end,
        }
        for _,call in ipairs(attempts) do
            local ok,body=pcall(call)
            if ok then
                body=trim(body)
                if validRemoteKey(body) then
                    url=nil
                    attempts=nil
                    return body
                end
            end
        end
        url=nil
        attempts=nil
    end
    return nil
end

local function fsReady()
    return type(isfile)=="function"
        and type(readfile)=="function"
        and type(writefile)=="function"
end

local function readReceipt()
    if not fsReady() then return nil end
    local ok,exists=pcall(isfile,ACCESS_FILE)
    if not ok or not exists then return nil end
    local rok,body=pcall(readfile,ACCESS_FILE)
    if not rok then return nil end
    return trim(body)
end

local function removeStaleReceipt()
    if type(delfile)~="function" then return end
    pcall(function()
        if isfile(ACCESS_FILE) then delfile(ACCESS_FILE) end
    end)
end

local function replacePlain(source,old,new,label)
    local p=string.find(source,old,1,true)
    if not p then error("[SERENITY HUB] "..tostring(label),0) end
    return string.sub(source,1,p-1)..new..string.sub(source,p+#old)
end

local currentKey=fetchCurrentKey()
local expectedReceipt=currentKey and receiptFor(currentKey,LP.UserId) or nil
local savedReceipt=readReceipt()
local preverified=expectedReceipt~=nil and savedReceipt~=nil and savedReceipt==expectedReceipt

if savedReceipt and expectedReceipt and not preverified then
    removeStaleReceipt()
end
savedReceipt=nil
expectedReceipt=nil

local outer=game:HttpGet(PROTECTED.."?v=dynamic-key-v2-20260824f",true)
local uiPatch=game:HttpGet(UIPATCH.."?v=dynamic-key-v2-20260824f",true)

if type(outer)~="string" or outer=="" then
    error("[SERENITY HUB] Access V2 protected core is unavailable.",0)
end
if type(uiPatch)~="string" or uiPatch=="" then
    error("[SERENITY HUB] Access V2 UI is unavailable.",0)
end

local oldVerify=[[        local embeddedOk=(H(entered)==((2100000000+2027360581)%4294967291))
        local valid=(remoteUsable and secureEq(entered,remote)) or embeddedOk
        remote=nil
]]
local newVerify=[[        local valid=(remoteUsable and secureEq(entered,remote))
        remote=nil
]]
uiPatch=replacePlain(uiPatch,oldVerify,newVerify,"Access V2 verifier patch mismatch.")

local oldFetch=[[        local keyUrl=R(ID_KEY)
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
local newFetch=[[        local ok=true
        local remote=__S2_CURRENT_KEY and trim(__S2_CURRENT_KEY) or nil
]]
uiPatch=replacePlain(uiPatch,oldFetch,newFetch,"Access V2 current-key UI patch mismatch.")

uiPatch=replacePlain(
    uiPatch,
    "Key server returned an invalid response. Check the key or try again.",
    "Key service is unavailable. Try again in a moment.",
    "Access V2 status-message patch mismatch."
)

local oldSave=[[        local saved,proof=saveReceipt(entered)
        proof=proof or proofFor(LP.UserId)
        applyCompat(entered,proof)
]]
local newSave=[[        local saved=false
        if __S2_FS_READY then
            pcall(function()
                if type(makefolder)=="function" then
                    if type(isfolder)=="function" then
                        if not isfolder("SerenityHub") then makefolder("SerenityHub") end
                    else
                        makefolder("SerenityHub")
                    end
                end
            end)
            local receipt=__S2_RECEIPT_FOR(entered,LP.UserId)
            saved=pcall(writefile,"SerenityHub/.access",receipt)
            receipt=nil
        end
        local proof=proofFor(LP.UserId)
        applyCompat(entered,proof)
        __S2_CURRENT_KEY=nil
]]
uiPatch=replacePlain(uiPatch,oldSave,newSave,"Access V2 receipt-save patch mismatch.")

local uiMarker="local function New(class,props)"
local uiPos=string.find(uiPatch,uiMarker,1,true)
if not uiPos then error("[SERENITY HUB] Access V2 UI marker mismatch.",0) end

local preamble=string.format([[
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
]],
    tostring(fsReady()),
    tostring(preverified),
    currentKey and string.format("%q",currentKey) or "nil"
)

uiPatch=string.sub(uiPatch,1,uiPos-1)..preamble..string.sub(uiPatch,uiPos)

local legacySavedShortcut=[[local savedKey,savedProof=readReceipt() if savedKey and savedProof then applyCompat(savedKey,savedProof) return launch(savedKey,savedProof) end]]
local legacyEnvShortcut=[[if type(ENV.__SERENITY_ACCESS_V2)=="string" and ENV.__SERENITY_ACCESS_V2==proofFor(LP.UserId) then return launch(nil,ENV.__SERENITY_ACCESS_V2) end]]

local outerMarker='local FN,ER=L(SRC,"@SerenityShield/ACCESSV2-92C8406BEAB4-FINAL2")'
local outerPos=string.find(outer,outerMarker,1,true)
if not outerPos then error("[SERENITY HUB] Access V2 protected-core marker mismatch.",0) end

local inject=string.format([[
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
)..outerMarker

outer=string.sub(outer,1,outerPos-1)..inject..string.sub(outer,outerPos+#outerMarker)

currentKey=nil
uiPatch=nil
KEY_DATA=nil

local fn,err=loadstring(outer,"@SerenityShield/AccessV2-DynamicKey-F")
outer=nil
if not fn then
    error("[SERENITY HUB] Access V2 dynamic-key build failed: "..tostring(err),0)
end
return fn()
