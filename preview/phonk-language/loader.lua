-- Serenity Phonk language preview. UI only; no automation or analytics requests.
if not game:IsLoaded() then game.Loaded:Wait() end
if game.PlaceId~=104809044319701 and game.GameId~=10544327471 then
    warn('[Serenity] Open +1 Phonk Evolution to test this language preview.')
    return
end
local BASE='https://raw.githubusercontent.com/MUshihara/Serenity-hub/phonk-language-preview-v1/preview/phonk-language/'
local function module(name)
    local source=game:HttpGet(BASE..name..'?version=language-preview-1',true)
    local run,err=loadstring(source,'@SerenityLanguagePreview/'..name)
    if not run then error(err,0) end
    return run()
end
local library=module('phonk-language-ui.lua')
local manifest=module('phonk-language-manifest.lua')
local app=library.Build(manifest)
app:SetVisible(true)
app:SelectPage('Settings')
app.Tabs.Settings.Select('Appearance')
app:Notify('Preview only — game actions are disabled.')
return app
