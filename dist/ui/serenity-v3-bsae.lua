-- BSAE-scoped Serenity V3 entrypoint.
-- Keeps the shared entrypoint intact, then injects only the current BSAE exact-string locale patch before UI.Build.
local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local source=game:HttpGet(BASE.."dist/ui/serenity-v3.lua?serenity=bsae-i18n2",true)

local marker="    pcall(applySupplementalLocales,uiModule)\n"
local first,last=source:find(marker,1,true)
if not first then
    error("[SERENITY HUB] BSAE localization hook not found",0)
end

local injected=[[
    pcall(applySupplementalLocales,uiModule)

    if type(manifest)=="table" and manifest.GameName=="Break and Steal an Egg" then
        local i18n=uiModule and uiModule.I18N
        local packs=i18n and i18n.Packs
        if type(packs)=="table" then
            local ok,rows=pcall(module,"dist/ui/localization-extra/bsae-v10-current.lua")
            if ok and type(rows)=="table" then
                for code,localeRows in pairs(rows) do
                    if type(code)=="string" and type(localeRows)=="table" then
                        local pack=packs[code]
                        if type(pack)~="table" then
                            pack={}
                            packs[code]=pack
                        end
                        for key,value in pairs(localeRows) do
                            if type(key)=="string" and type(value)=="string" and value~="" then
                                pack[key]=value
                            end
                        end
                    end
                end
            end
        end
    end
]]

source=source:sub(1,first-1)..injected..source:sub(last+1)
local fn,err=loadstring(source,"@Serenity/serenity-v3-bsae.lua")
if not fn then
    error("[SERENITY HUB] BSAE UI compile failed: "..tostring(err),0)
end
return fn()
