-- BSAE-scoped Serenity V3 entrypoint.
-- Keeps the shared entrypoint intact, then injects only BSAE exact-string locale patches before UI.Build.
local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local source=game:HttpGet(BASE.."dist/ui/serenity-v3.lua?serenity=bsae-i18n4",true)

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
            local extraFiles={
                "dist/ui/localization-extra/bsae-v10-current.lua",
                "dist/ui/localization-extra/bsae-v10-ui-fix.lua",
                "dist/ui/localization-extra/bsae-v10-v18-33.lua",
                "dist/ui/localization-extra/bsae-v10-v33.lua",
            }
            for _,path in ipairs(extraFiles) do
                local ok,rows=pcall(module,path)
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

        -- The shared translator intentionally avoids arbitrary dynamic text.
        -- BSAE's MultiSelect summary is a known UI-owned pattern, so translate it here
        -- without changing the canonical selected option values.
        if type(i18n)=="table" and type(i18n.new)=="function" and not i18n.__BSAESelectedCountPatch then
            local originalNew=i18n.new
            i18n.new=function(selection,detected)
                local obj=originalNew(selection,detected)
                local originalT=obj and obj.T
                if type(obj)=="table" and type(originalT)=="function" then
                    function obj:T(text)
                        if type(text)=="string" then
                            local count=text:match("^([%d][%d,%.]*) selected$")
                            if count then
                                local pack=i18n.Packs and i18n.Packs[self:Language()] or nil
                                local word=type(pack)=="table" and pack.selected or nil
                                if type(word)=="string" and word~="" then
                                    return count.." "..word
                                end
                            end
                        end
                        return originalT(self,text)
                    end
                end
                return obj
            end
            i18n.__BSAESelectedCountPatch=true
        end
    end
]]

source=source:sub(1,first-1)..injected..source:sub(last+1)
local fn,err=loadstring(source,"@Serenity/serenity-v3-bsae.lua")
if not fn then
    error("[SERENITY HUB] BSAE UI compile failed: "..tostring(err),0)
end
return fn()
