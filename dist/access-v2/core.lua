--[[ Serenity Access V2 // source-level UI + key repair ]]
local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local PROTECTED=BASE.."dist/access-v2/core-protected.lua"
local UIPATCH=BASE.."dist/access-v2/ui-mainstyle-keyfix.lua.txt"

local outer=game:HttpGet(PROTECTED.."?v=mainstyle-keyfix-20260824d",true)
local uiPatch=game:HttpGet(UIPATCH.."?v=mainstyle-keyfix-20260824d",true)

if type(outer)~="string" or outer=="" then
    error("[SERENITY HUB] Access V2 protected core is unavailable.",0)
end
if type(uiPatch)~="string" or uiPatch=="" then
    error("[SERENITY HUB] Access V2 UI patch is unavailable.",0)
end

-- The public UI patch never stores the lifetime key itself. Keep only its
-- transformed verifier here so Pastebin outages do not lock out valid users.
local oldVerifier="((2100000000+2027360581)%4294967291)"
local currentVerifier="((356135586+356135587)%4294967291)"
local verifierPos=string.find(uiPatch,oldVerifier,1,true)
if not verifierPos then
    error("[SERENITY HUB] Access verifier patch mismatch.",0)
end
if string.find(uiPatch,oldVerifier,verifierPos+#oldVerifier,true) then
    error("[SERENITY HUB] Access verifier patch is ambiguous.",0)
end
uiPatch=string.sub(uiPatch,1,verifierPos-1)
    ..currentVerifier
    ..string.sub(uiPatch,verifierPos+#oldVerifier)

uiPatch=uiPatch:gsub(
    "Key server returned an invalid response%. Check the key or try again%.",
    "Key service is unavailable or the key is incorrect. Try again.",
    1
)

local outerMarker='local FN,ER=L(SRC,"@SerenityShield/ACCESSV2-92C8406BEAB4-FINAL2")'
local innerMarker='local function New(class,props)'
local pos=string.find(outer,outerMarker,1,true)
if not pos then
    error("[SERENITY HUB] Access V2 protected-core marker mismatch.",0)
end

local inject=
    'local __s2_ui_marker='..string.format("%q",innerMarker)..
    ' local __s2_ui_pos=string.find(SRC,__s2_ui_marker,1,true)'..
    ' if not __s2_ui_pos then error("[SERENITY HUB] Access UI marker mismatch.",0) end'..
    ' SRC=string.sub(SRC,1,__s2_ui_pos-1)..'..string.format("%q",uiPatch)..' ' ..
    outerMarker

outer=string.sub(outer,1,pos-1)..inject..string.sub(outer,pos+#outerMarker)
uiPatch=nil

local fn,err=loadstring(outer,"@SerenityShield/AccessV2-MainStyle-KeyFix-D-Literal")
outer=nil
if not fn then
    error("[SERENITY HUB] Access V2 repaired core compile failed: "..tostring(err),0)
end
return fn()
