-- Serenity shared entrypoint: shared V3 rollout; Phonk retains its device-approved adapter.
local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local cache={}
local CACHE_TAG="3.2.0-bsae-i18n1"

local function module(path)
    if cache[path] then return cache[path] end
    local source=game:HttpGet(BASE..path.."?serenity="..CACHE_TAG,true)
    local fn,err=loadstring(source,"@Serenity/"..path)
    if not fn then error("[SERENITY HUB] UI compile failed: "..tostring(err),0) end
    local result=fn()
    cache[path]=result
    return result
end

-- Shared supplemental dictionary. This extends the same I18N.Packs used by the
-- production adapters; canonical English values, IDs and callbacks stay unchanged.
local EXTRA_LOCALE_CODES={"fil","id","vi","th","es","pt","fr","de","ru"}
local extraLocalesApplied=setmetatable({}, {__mode="k"})

local function applySupplementalLocales(uiModule)
    if type(uiModule)~="table" or extraLocalesApplied[uiModule] then return end
    local i18n=uiModule.I18N
    local packs=i18n and i18n.Packs
    if type(packs)~="table" then return end

    for _,code in ipairs(EXTRA_LOCALE_CODES) do
        local ok,rows=pcall(module,"dist/ui/localization-extra/"..code..".lua")
        if ok and type(rows)=="table" then
            local pack=packs[code]
            if type(pack)~="table" then
                pack={}
                packs[code]=pack
            end
            for key,value in pairs(rows) do
                if type(key)=="string" and type(value)=="string" then
                    pack[key]=value
                end
            end
        end
    end

    extraLocalesApplied[uiModule]=true
end

-- Account presence: UserId is sent over HTTPS and HMAC-hashed by the Worker; one combined heartbeat.
-- Opt out before execution with getgenv().SerenityPresenceEnabled = false.
local function startPresence(app,manifest)
    local runtime=app and app.Runtime
    if not runtime or runtime.Destroyed then return end
    local cleanup=runtime.TrackCleanup or runtime.OnDestroy
    if type(cleanup)~="function" then return end
    local env=(getgenv and getgenv()) or _G
    local previous=env.__SERENITY_PRESENCE
    if previous and type(previous.Stop)=="function" then previous:Stop() end
    if env.SerenityPresenceEnabled==false then return end
    local send=request or http_request or (syn and syn.request)
    if type(send)~="function" then return end
    local player=game:GetService("Players").LocalPlayer
    if not player or player.UserId<=0 then return end
    local account=tostring(player.UserId)
    local http=game:GetService("HttpService")
    local id=env.__SERENITY_PRESENCE_ID or env.SerenityPresenceTestID
    if type(id)~="string" or #id~=36 then id=http:GenerateGUID(false) end
    env.__SERENITY_PRESENCE_ID=id
    local headers={["Content-Type"]="application/json",["X-Serenity-Account"]=account}
    local universe=tonumber(game.GameId)
    if universe and universe>0 and universe==math.floor(universe) then
        headers["X-Serenity-Game"]=tostring(universe)
        local name=type(manifest)=="table" and manifest.GameName or nil
        -- Bounded UTF-8 name; URL encoding keeps HTTP headers ASCII-only.
        if type(name)=="string" and #name>0 and #name<=96 then
            local ok,encoded=pcall(http.UrlEncode,http,name)
            if ok and type(encoded)=="string" then headers["X-Serenity-Game-Name"]=encoded end
        end
    end
    local body=http:JSONEncode({session=id})
    local executionBody=http:JSONEncode({session=id,execution=http:GenerateGUID(false)})
    local executionRecorded=false
    local interval=120 -- Keep the old expiry safe until the updated Worker is deployed.
    local window=app.Window or app
    local state={Stopped=false}
    function state:Stop()
        if self.Stopped then return end
        self.Stopped=true
        if self.Thread then pcall(task.cancel,self.Thread) end
        if env.__SERENITY_PRESENCE==self then env.__SERENITY_PRESENCE=nil end
    end
    cleanup(runtime,function() state:Stop() end)
    env.__SERENITY_PRESENCE=state
    state.Thread=task.defer(function()
        while not state.Stopped and not runtime.Destroyed do
            if env.SerenityPresenceEnabled==false then state:Stop();return end
            local beatOK,beatResponse=pcall(send,{
                Url="https://serenity-active.makimnaritn.workers.dev/heartbeat",
                Method="POST",
                Headers=headers,
                Body=executionRecorded and body or executionBody,
                Timeout=10,
            })
            local value
            if beatOK and type(beatResponse)=="table" and tonumber(beatResponse.StatusCode)==200 then
                local decoded,data=pcall(http.JSONDecode,http,beatResponse.Body or "")
                if decoded and type(data)=="table" then
                    if data.executionRecorded==true then executionRecorded=true end
                    -- Never use a five-minute interval against the old five-minute expiry.
                    if data.interval==300 and data.ttl==600 then interval=300 else interval=120 end
                    if type(data.active)=="number" and data.active>=0 and data.active<math.huge
                        and data.active==math.floor(data.active) then value=data.active end
                end
            end
            if not state.Stopped and not runtime.Destroyed and type(window.SetActiveCount)=="function" then
                pcall(window.SetActiveCount,window,value)
            end
            task.wait(interval)
        end
    end)
end

-- Startup Discord invite: at most once every 24 hours, shared across games.
-- The root loader uses this same timestamp marker, preventing duplicate copies in one execution.
local function showDiscord(app)
    local window=app and (app.Window or app)
    if not window or type(window.NotifyDiscord)~="function" then return end

    local env=(type(getgenv)=="function" and getgenv()) or _G
    local now=os.time()
    local cooldown=24*60*60
    local path="SerenityHub/discord-notice-at.txt"
    local last=tonumber(env.__SERENITY_DISCORD_NOTICE_AT) or 0

    if type(readfile)=="function" then
        local ok,value=pcall(readfile,path)
        if ok then
            last=math.max(last,tonumber(value) or 0)
        end
    end

    if last>now then last=now end
    if now-last<cooldown then return end

    local invite="https://discord.gg/pWPs7428wE"
    local providers={setclipboard,toclipboard,type(syn)=="table" and syn.write_clipboard or false}

    for i=1,3 do
        local copy=providers[i]
        if type(copy)=="function" then
            local ok,result=pcall(copy,invite)
            if ok and result~=false then
                env.__SERENITY_DISCORD_COPIED=true
                break
            end
        end
    end

    env.__SERENITY_DISCORD_NOTICE_AT=now

    if type(writefile)=="function" then
        if type(makefolder)=="function" then pcall(makefolder,"SerenityHub") end
        pcall(writefile,path,tostring(now))
    end

    window:NotifyDiscord()
end

local Serenity={Version="3.2.0",APIVersion=3}

function Serenity.Detect()
    return module("dist/ui/serenity-v3-legacy.lua").Detect()
end

function Serenity.Build(manifest,options)
    local phonk=game.PlaceId==104809044319701 or game.GameId==10544327471
    local uiModule

    if phonk and type(manifest)=="table" and manifest.GameName=="+1 Phonk Evolution" then
        uiModule=module("dist/ui/phonk-v3-1-0.lua")
    elseif type(manifest)=="table" and manifest.SerenityAPIVersion==3 then
        uiModule=module("dist/ui/universal-v3-2-0.lua")
    else
        uiModule=module("dist/ui/serenity-v3-legacy.lua")
    end

    pcall(applySupplementalLocales,uiModule)

    local app=uiModule.Build(manifest,options)
    pcall(startPresence,app,manifest)
    pcall(showDiscord,app)
    return app
end

return Serenity
