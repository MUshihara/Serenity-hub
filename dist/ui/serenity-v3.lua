-- Serenity shared entrypoint: shared V3 rollout; Phonk retains its device-approved adapter.
local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local cache={}
local function module(path)
    if cache[path] then return cache[path] end
    local source=game:HttpGet(BASE..path.."?serenity=3.2.0-presence5",true)
    local fn,err=loadstring(source,"@Serenity/"..path)
    if not fn then error("[SERENITY HUB] UI compile failed: "..tostring(err),0) end
    local result=fn()
    cache[path]=result
    return result
end
-- Anonymous active-session estimate: one combined request per 300 seconds after server negotiation, no player identifiers.
-- Opt out before execution with getgenv().SerenityPresenceEnabled = false.
local function startPresence(app)
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
    local http=game:GetService("HttpService")
    local id=env.__SERENITY_PRESENCE_ID or env.SerenityPresenceTestID
    if type(id)~="string" or #id~=36 then id=http:GenerateGUID(false) end
    env.__SERENITY_PRESENCE_ID=id
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
                Headers={["Content-Type"]="application/json"},
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
    if not env.__SERENITY_PRESENCE_NOTICE and type(window.Notify)=="function" then
        local ok=pcall(window.Notify,window,"Anonymous session and execution counts are enabled. No username is sent.")
        if ok then env.__SERENITY_PRESENCE_NOTICE=true end
    end
end

local Serenity={Version="3.2.0",APIVersion=3}
function Serenity.Detect()
    return module("dist/ui/serenity-v3-legacy.lua").Detect()
end
function Serenity.Build(manifest,options)
    local phonk=game.PlaceId==104809044319701 or game.GameId==10544327471
    local app
    if phonk and type(manifest)=="table" and manifest.GameName=="+1 Phonk Evolution" then
        app=module("dist/ui/phonk-v3-1-0.lua").Build(manifest,options)
    elseif type(manifest)=="table" and manifest.SerenityAPIVersion==3 then
        app=module("dist/ui/universal-v3-2-0.lua").Build(manifest,options)
    else
        app=module("dist/ui/serenity-v3-legacy.lua").Build(manifest,options)
    end
    pcall(startPresence,app)
    return app
end
return Serenity
