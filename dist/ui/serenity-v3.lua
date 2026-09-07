-- Serenity shared entrypoint: shared V3 rollout; Phonk retains its device-approved adapter.
local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local cache={}
local function module(path)
    if cache[path] then return cache[path] end
    local source=game:HttpGet(BASE..path.."?serenity=3.2.0",true)
    local fn,err=loadstring(source,"@Serenity/"..path)
    if not fn then error("[SERENITY HUB] UI compile failed: "..tostring(err),0) end
    local result=fn()
    cache[path]=result
    return result
end
local Serenity={Version="3.2.0",APIVersion=3}
function Serenity.Detect()
    return module("dist/ui/serenity-v3-legacy.lua").Detect()
end
function Serenity.Build(manifest,options)
    local phonk=game.PlaceId==104809044319701 or game.GameId==10544327471
    if phonk and type(manifest)=="table" and manifest.GameName=="+1 Phonk Evolution" then
        return module("dist/ui/phonk-v3-1-0.lua").Build(manifest,options)
    end
    if type(manifest)=="table" and manifest.SerenityAPIVersion==3 then
        return module("dist/ui/universal-v3-2-0.lua").Build(manifest,options)
    end
    return module("dist/ui/serenity-v3-legacy.lua").Build(manifest,options)
end
return Serenity
