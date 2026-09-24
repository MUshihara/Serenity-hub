-- Isolated Phonk community test. Adapted API contract from TripNation/announcement.
-- Manual test only: never referenced by Serenity's production loader or UI.
return function(Core)
if game.PlaceId~=104809044319701 and game.GameId~=10544327471 then
    warn("[Serenity test] Open +1 Phonk Evolution to test this module.")
    return
end
local env=(getgenv and getgenv()) or _G
local prior=env.__SERENITY_PHONK_COMMUNITY_TEST
if prior and prior.Stop then prior:Stop() end
local http=game:GetService("HttpService")
local players=game:GetService("Players")
local player=players.LocalPlayer
local send=request or http_request or (syn and syn.request) or (type(env.http)=="table" and env.http.request)
if not player or type(send)~="function" then warn("[Serenity test] HTTP request support is required.");return end
local S={Stopped=false,threads={},connections={},opened=false,muted=false,banned=false,globalMuted=false}
env.__SERENITY_PHONK_COMMUNITY_TEST=S
env.__SERENITY_COMMUNITY_SEEN=env.__SERENITY_COMMUNITY_SEEN or {}
local seen=env.__SERENITY_COMMUNITY_SEEN
local function connect(signal,fn) local c=signal:Connect(fn);S.connections[#S.connections+1]=c;return c end
local function spawn(fn)
    local thread
    thread=task.defer(function() local ok,e=pcall(fn);S.threads[coroutine.running()]=nil;if not ok and not S.Stopped then warn("[Serenity community test] "..tostring(e)) end end)
    S.threads[thread]=true
    return thread
end
function S:Stop()
    if self.Stopped then return end
    self.Stopped=true
    for _,c in ipairs(self.connections) do pcall(function() c:Disconnect() end) end
    for t in pairs(self.threads) do if t~=coroutine.running() then pcall(task.cancel,t) end end
    if self.gui then self.gui:Destroy() end
    if env.__SERENITY_PHONK_COMMUNITY_TEST==self then env.__SERENITY_PHONK_COMMUNITY_TEST=nil end
end
local parent
pcall(function() parent=(gethui and gethui()) or game:GetService("CoreGui") end)
parent=parent or player:WaitForChild("PlayerGui")
local function make(class,props,parentObject)
    local o=Instance.new(class)
    for k,v in pairs(props) do o[k]=v end
    o.Parent=parentObject
    return o
end
local gui=make("ScreenGui",{Name="SerenityPhonkCommunityTest",ResetOnSpawn=false,DisplayOrder=950,IgnoreGuiInset=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},parent)
S.gui=gui
local bg=Color3.fromRGB(18,18,25)
local white=Color3.fromRGB(238,238,245)
local muted=Color3.fromRGB(159,161,181)
local orange=Color3.fromRGB(255,178,83)
local function corner(o,n) make("UICorner",{CornerRadius=UDim.new(0,n or 10)},o) end
local function label(parentObject,text,pos,size,color,fontSize)
    return make("TextLabel",{Text=text,Position=pos,Size=size,BackgroundTransparency=1,TextColor3=color or white,Font=Enum.Font.Gotham,TextSize=fontSize or 13,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true},parentObject)
end
local function button(parentObject,text,pos,size)
    local b=make("TextButton",{Text=text,Position=pos,Size=size,BackgroundColor3=Color3.fromRGB(40,39,54),TextColor3=white,Font=Enum.Font.Gotham,TextSize=13,AutoButtonColor=true,BorderSizePixel=0},parentObject)
    corner(b,8);return b
end
-- One compact top-center banner. Warnings take priority over announcements.
local banner=make("Frame",{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,0,12),Size=UDim2.fromOffset(440,100),BackgroundColor3=bg,BorderSizePixel=0,Visible=false},gui)
corner(banner)
local border=make("UIStroke",{Color=orange,Thickness=1},banner)
local title=label(banner,"",UDim2.fromOffset(14,8),UDim2.new(1,-60,0,22),orange,14)
title.Font=Enum.Font.GothamBold
local message=label(banner,"",UDim2.fromOffset(14,34),UDim2.new(1,-28,1,-43),white,13)
message.TextYAlignment=Enum.TextYAlignment.Top
message.TextTruncate=Enum.TextTruncate.AtEnd
local dismiss=button(banner,"X",UDim2.new(1,-40,0,6),UDim2.fromOffset(34,30))
local noticeQueue,current={},nil
local function notify(heading,text,duration,warning)
    local item={heading=heading,text=tostring(text or ""),duration=Core.Duration(duration),warning=warning}
    if warning then table.insert(noticeQueue,1,item);current=nil;banner.Visible=false else noticeQueue[#noticeQueue+1]=item end
    if #noticeQueue>5 then table.remove(noticeQueue) end
end
connect(dismiss.Activated,function() current=nil;banner.Visible=false end)
spawn(function()
    while not S.Stopped do
        if current and os.clock()>=current.untilTime then current=nil;banner.Visible=false end
        if not current and #noticeQueue>0 then
            current=table.remove(noticeQueue,1);current.untilTime=os.clock()+current.duration
            title.Text=current.heading;message.Text=current.text
            title.TextColor3=current.warning and orange or Color3.fromRGB(183,160,239)
            border.Color=title.TextColor3;banner.Visible=true
        end
        task.wait(.2)
    end
end)
local panel=make("Frame",{AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-12,1,-56),Size=UDim2.fromOffset(440,400),BackgroundColor3=bg,BorderSizePixel=0,Visible=false},gui)
corner(panel)
label(panel,"Community · Test",UDim2.fromOffset(12,8),UDim2.new(1,-160,0,24),white,13)
local close=button(panel,"–",UDim2.new(1,-44,0,6),UDim2.fromOffset(34,30))
local room=button(panel,"English",UDim2.fromOffset(12,38),UDim2.fromOffset(112,30))
local preview=button(panel,"Test warning",UDim2.fromOffset(132,38),UDim2.fromOffset(114,30))
local stop=button(panel,"Stop test",UDim2.new(1,-132,0,6),UDim2.fromOffset(80,30))
local status=label(panel,"Open chat to connect.",UDim2.fromOffset(12,72),UDim2.new(1,-24,0,32),muted,12)
local scroll=make("ScrollingFrame",{Position=UDim2.fromOffset(12,108),Size=UDim2.new(1,-24,1,-165),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y},panel)
make("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},scroll)
local input=make("TextBox",{Position=UDim2.new(0,12,1,-45),Size=UDim2.new(1,-94,0,34),Text="",PlaceholderText="Message the live global chat…",ClearTextOnFocus=false,BackgroundColor3=Color3.fromRGB(30,30,41),TextColor3=white,PlaceholderColor3=muted,TextSize=13,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0},panel)
corner(input,7)
make("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},input)
local sendButton=button(panel,"Send",UDim2.new(1,-74,1,-45),UDim2.fromOffset(62,34))
local pill=button(gui,"Community · Test",UDim2.new(1,-178,1,-44),UDim2.fromOffset(166,34))
local function resize()
    local camera=workspace.CurrentCamera
    if not camera then return end
    local v=camera.ViewportSize
    panel.Size=UDim2.fromOffset(math.min(440,math.max(240,v.X-24)),math.min(400,math.max(220,v.Y-100)))
    banner.Size=UDim2.fromOffset(math.min(440,math.max(200,v.X-24)),100)
end
resize()
local cameraConnection
local function watchCamera()
    if cameraConnection then cameraConnection:Disconnect() end
    if workspace.CurrentCamera then cameraConnection=connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),resize) end
    resize()
end
connect(workspace:GetPropertyChangedSignal("CurrentCamera"),watchCamera);watchCamera()
local function toggle() S.opened=not S.opened;panel.Visible=S.opened end
connect(pill.Activated,toggle);connect(close.Activated,toggle)
connect(stop.Activated,function() S:Stop() end)
connect(preview.Activated,function() notify("Community warning · Preview","Please keep the chat respectful. This preview is visible only to you.",8,true) end)
local rooms={{"English","en"},{"spanish","es"},{"indonesian","id"},{"philippines","fil"},{"vietnam","vi"},{"brazilian","pt"}}
local roomIndex=1
local messages,ids,cursor={}, {},0
local function render()
    for _,child in ipairs(scroll:GetChildren()) do if child:IsA("TextLabel") then child:Destroy() end end
    local lang=rooms[roomIndex][2]
    for i,m in ipairs(messages) do
        local text=tostring(m.message or "")
        if type(m.translations)=="table" and type(m.translations[lang])=="string" then text=m.translations[lang] end
        local row=label(scroll,tostring(m.displayName or m.username or "User").." · "..tostring(m.gameName or "").."\n"..text,UDim2.new(),UDim2.new(1,-8,0,0),white,13)
        row.AutomaticSize=Enum.AutomaticSize.Y;row.LayoutOrder=i;row.TextYAlignment=Enum.TextYAlignment.Top
    end
end
connect(room.Activated,function() roomIndex=roomIndex%#rooms+1;room.Text=rooms[roomIndex][1];render() end)
local BASE="https://serenityhub.site/api"
local function api(path,body)
    if S.Stopped then return nil end
    local ok,response=pcall(send,{Url=BASE..path,Method=body and "POST" or "GET",Headers={["Content-Type"]="application/json"},Body=body and http:JSONEncode(body) or nil,Timeout=10})
    if S.Stopped then return nil end
    if not ok or type(response)~="table" then return nil end
    local code=tonumber(response.StatusCode or response.Status)
    local decoded,data=pcall(http.JSONDecode,http,response.Body or response.body or "")
    if not decoded or type(data)~="table" then return nil,code end
    return data,code
end
local function moderation()
    local d,code=api("/moderation/status?userId="..tostring(player.UserId))
    if not d or not Core.Status(code) or d.success~=true then return false end
    S.muted=d.isMuted==true;S.banned=d.isBanned==true
    if S.banned then
        if Core.Remember(seen,"chat-ban:"..player.UserId,os.time()) then notify("Chat access restricted","Contact staff to appeal. Your game and other Serenity features remain available.",10,true) end
    end
    local key=Core.WarningKey(d.warning)
    if key and Core.Remember(seen,key,os.time()) then notify("Community warning",d.warning.message,8,true) end
    return true
end
local nextMod=0
spawn(function()
    local delay=4
    while not S.Stopped do
        if S.opened then
            if os.clock()>=nextMod then moderation();nextMod=os.clock()+15 end
            if not S.banned then
                local data,code=api("/chat/messages?after="..cursor.."&limit=100")
                if data and Core.Status(code) and data.success==true and type(data.messages)=="table" then
                    delay=4;S.globalMuted=data.isChatMuted==true
                    if data.cleared then messages={};ids={};cursor=0 end
                    local changed=data.cleared==true
                    for _,m in ipairs(data.messages) do
                        local id=tonumber(m.id)
                        if id and id>=0 and id==math.floor(id) and not ids[id] then
                            ids[id]=true;cursor=math.max(cursor,id);messages[#messages+1]=m;changed=true
                        end
                    end
                    table.sort(messages,function(a,b)return tonumber(a.id)<tonumber(b.id) end)
                    while #messages>100 do local old=table.remove(messages,1);ids[tonumber(old.id)]=nil end
                    if changed then render() end
                    status.Text=(S.muted or S.globalMuted) and "Chat muted · You can still read messages." or "Live chat · Sends are visible to other users."
                else
                    delay=math.min(delay*2,60);status.Text="Chat unavailable · Retrying automatically."
                end
            else status.Text="Chat access restricted · Contact staff." end
            task.wait(delay)
        else task.wait(1) end
    end
end)
local sending,lastSend=false,-math.huge
local function sendMessage()
    if sending or S.Stopped or os.clock()-lastSend<3 then return end
    local text=input.Text:match("^%s*(.-)%s*$")
    if text=="" then return end
    local n=utf8.len(text)
    if not n or n>200 then notify("Message too long","Use 200 characters or fewer.",5,true);return end
    sending=true;lastSend=os.clock();sendButton.Text="…"
    spawn(function()
        local verified=moderation()
        if not verified then status.Text="Unable to check chat permissions. Try again."
        elseif S.banned or S.muted or S.globalMuted then notify("Chat unavailable","Your account or the global chat is currently restricted.",6,true)
        else
            local d,code=api("/chat/messages",{userId=tostring(player.UserId),username=player.Name,displayName=player.DisplayName,gameName="+1 Phonk Evolution",room=rooms[roomIndex][1],message=text})
            if d and Core.Status(code) and d.success~=false then if input.Text==text then input.Text="" end
            elseif code==403 then notify("Message blocked","Your message was rejected by chat moderation.",6,true)
            elseif code==429 then notify("Please wait","You are sending messages too quickly. Try again shortly.",5,true)
            else status.Text="Message could not be confirmed. Check the feed before retrying." end
        end
        sending=false;if not S.Stopped then sendButton.Text="Send" end
    end)
end
connect(sendButton.Activated,sendMessage)
connect(input.FocusLost,function(enter) if enter then sendMessage() end end)
local categories={announcement="Announcement",update="Update",important="Important",warning="Important",urgent="Urgent",maintenance="Maintenance"}
spawn(function()
    local delay=10
    while not S.Stopped do
        local a,code=api("/announcements/latest")
        if Core.Status(code) then
            delay=10
            if a and a.id and Core.Target(a,game.PlaceId,game.GameId,"+1 Phonk Evolution") then
                local eligible=true
                if a.expiresAt then
                    local ok,expiry=pcall(function() return DateTime.fromIsoDate(tostring(a.expiresAt)).UnixTimestamp end)
                    eligible=ok and expiry>os.time()
                end
                if eligible and Core.Remember(seen,"announcement:"..tostring(a.id),os.time()) then
                    notify("Serenity · "..(categories[tostring(a.type):lower()] or "Announcement"),a.message,a.duration,false)
                end
            end
        else delay=math.min(delay*2,120) end
        task.wait(delay)
    end
end)
notify("Community test · Phonk only","Open Community to try chat, or tap Test warning for a local banner preview.",8,false)
return S
end
