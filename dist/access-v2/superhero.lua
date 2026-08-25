-- SERENITY HUB // +1 SUPERHERO EVOLUTION ACCESS V2 BRIDGE
local Players=game:GetService("Players")
local CoreGui=game:GetService("CoreGui")
local LP=Players.LocalPlayer or Players.PlayerAdded:Wait()

local TARGET_PLACE=97824450589417
local TARGET_GAME=10577588270
if game.PlaceId~=TARGET_PLACE and game.GameId~=TARGET_GAME then
    error("[SERENITY HUB] This bridge is only for +1 Superhero Evolution.",0)
end

local ACCESS_DIR="SerenityHub"
local ACCESS_FILE=ACCESS_DIR.."/.access"
local KEY_URLS={
    "https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/access_key.txt",
    "https://raw.githubusercontent.com/MUshihara/Serenity-hub/refs/heads/main/access_key.txt",
    "https://github.com/MUshihara/Serenity-hub/raw/refs/heads/main/access_key.txt",
}
local GAME_URL="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/dist/games/plus-1-superhero-evolution.lua"
local MOD=4294967291

local function trim(s)
    s=tostring(s or "")
    if #s>=3 and string.byte(s,1)==239 and string.byte(s,2)==187 and string.byte(s,3)==191 then s=string.sub(s,4) end
    s=s:gsub("^%s+",""):gsub("%s+$","")
    local line=s:match("([^\r\n]+)")
    if line then s=line:gsub("^%s+",""):gsub("%s+$","") end
    if #s>=2 then
        local a,b=s:sub(1,1),s:sub(-1)
        if (a=='\"' and b=='\"') or (a=="'" and b=="'") then s=s:sub(2,-2):gsub("^%s+",""):gsub("%s+$","") end
    end
    return s
end

local function validRemoteKey(s)
    if type(s)~="string" then return false end
    s=trim(s)
    if s=="" or #s>256 then return false end
    local low=s:lower()
    return not (low:find("<html",1,true) or low:find("<!doctype",1,true) or low:find("not found",1,true) or low:find("bad gateway",1,true) or low:find("rate limit",1,true))
end

local function accessHash(s)
    local q=5381
    for i=1,#s do q=(q*33+string.byte(s,i)+17)%MOD end
    return q
end

local function receiptFor(rawKey,userId)
    rawKey=trim(rawKey)
    local uid=tostring(userId or 0)
    local a=accessHash("SERENITY|ACCESS|V2|"..uid.."|"..rawKey)
    local b=accessHash(rawKey.."|"..uid.."|"..tostring(a).."|RECEIPT")
    return string.format("%08x%08x",a,b)
end

local function fsReady()
    return type(isfile)=="function" and type(readfile)=="function" and type(writefile)=="function"
end

local function readReceipt()
    if not fsReady() then return nil end
    local ok,exists=pcall(isfile,ACCESS_FILE)
    if not ok or not exists then return nil end
    local rok,body=pcall(readfile,ACCESS_FILE)
    return rok and trim(body) or nil
end

local function writeReceipt(rawKey)
    if not fsReady() then return false end
    pcall(function()
        if type(makefolder)=="function" then
            if type(isfolder)=="function" then
                if not isfolder(ACCESS_DIR) then makefolder(ACCESS_DIR) end
            else
                makefolder(ACCESS_DIR)
            end
        end
    end)
    return pcall(writefile,ACCESS_FILE,receiptFor(rawKey,LP.UserId))
end

local function fetchCurrentKey()
    local nonce=tostring(os.time())..tostring(math.random(100000,999999))
    for _,url in ipairs(KEY_URLS) do
        local sep=url:find("?",1,true) and "&" or "?"
        local fresh=url..sep.."s2="..nonce
        local attempts={
            function() return game:HttpGet(fresh,false) end,
            function() return game:HttpGet(fresh,true) end,
            function() return game:HttpGet(url,false) end,
            function() return game:HttpGet(url,true) end,
            function() return game:HttpGet(url) end,
        }
        for _,call in ipairs(attempts) do
            local ok,body=pcall(call)
            if ok then
                body=trim(body)
                if validRemoteKey(body) then return body end
            end
        end
    end
    return nil
end

local function launchGame()
    local url=GAME_URL.."?s2game="..tostring(os.time())..tostring(math.random(100000,999999))
    local ok,source=pcall(function() return game:HttpGet(url,true) end)
    if not ok or type(source)~="string" or source=="" then
        error("[SERENITY HUB] +1 Superhero Evolution payload is unavailable.",0)
    end
    local fn,err=loadstring(source,"@Serenity/Games/Plus1SuperheroEvolution")
    source=nil
    if not fn then error("[SERENITY HUB] Game payload compile failed: "..tostring(err),0) end
    return fn()
end

local currentKey=fetchCurrentKey()
if not currentKey then error("[SERENITY HUB] Key service is unavailable. Try again in a moment.",0) end

local saved=readReceipt()
if saved and saved==receiptFor(currentKey,LP.UserId) then
    currentKey=nil
    return launchGame()
end

pcall(function()
    local old=(type(gethui)=="function" and gethui() or CoreGui):FindFirstChild("SerenityAccessV2")
    if old then old:Destroy() end
end)

local parent=CoreGui
if type(gethui)=="function" then local ok,r=pcall(gethui); if ok and r then parent=r end end
if not parent then parent=LP:WaitForChild("PlayerGui") end

local gui=Instance.new("ScreenGui")
gui.Name="SerenityAccessV2"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.DisplayOrder=999999
gui.Parent=parent

local shade=Instance.new("Frame")
shade.BackgroundColor3=Color3.fromRGB(3,6,8)
shade.BackgroundTransparency=.32
shade.BorderSizePixel=0
shade.Size=UDim2.fromScale(1,1)
shade.Parent=gui

local main=Instance.new("Frame")
main.AnchorPoint=Vector2.new(.5,.5)
main.Position=UDim2.fromScale(.5,.5)
main.Size=UDim2.fromOffset(440,230)
main.BackgroundColor3=Color3.fromRGB(12,16,20)
main.BorderSizePixel=0
main.Parent=shade
Instance.new("UICorner",main).CornerRadius=UDim.new(0,14)
local stroke=Instance.new("UIStroke",main)
stroke.Color=Color3.fromRGB(61,72,83)
stroke.Transparency=.35

local title=Instance.new("TextLabel")
title.BackgroundTransparency=1
title.Position=UDim2.fromOffset(22,18)
title.Size=UDim2.new(1,-44,0,30)
title.Font=Enum.Font.GothamBold
title.Text="SERENITY HUB"
title.TextColor3=Color3.fromRGB(244,247,250)
title.TextSize=18
title.TextXAlignment=Enum.TextXAlignment.Left
title.Parent=main

local sub=Instance.new("TextLabel")
sub.BackgroundTransparency=1
sub.Position=UDim2.fromOffset(22,48)
sub.Size=UDim2.new(1,-44,0,20)
sub.Font=Enum.Font.Gotham
sub.Text="KEY SYSTEM • +1 SUPERHERO EVOLUTION"
sub.TextColor3=Color3.fromRGB(55,215,232)
sub.TextSize=10
sub.TextXAlignment=Enum.TextXAlignment.Left
sub.Parent=main

local input=Instance.new("TextBox")
input.ClearTextOnFocus=false
input.PlaceholderText="Enter your Serenity key..."
input.Text=""
input.Position=UDim2.fromOffset(22,84)
input.Size=UDim2.new(1,-44,0,42)
input.BackgroundColor3=Color3.fromRGB(24,30,37)
input.BorderSizePixel=0
input.Font=Enum.Font.GothamMedium
input.TextColor3=Color3.fromRGB(242,246,249)
input.PlaceholderColor3=Color3.fromRGB(121,133,146)
input.TextSize=12
input.Parent=main
Instance.new("UICorner",input).CornerRadius=UDim.new(0,9)
local pad=Instance.new("UIPadding",input); pad.PaddingLeft=UDim.new(0,12); pad.PaddingRight=UDim.new(0,12)

local status=Instance.new("TextLabel")
status.BackgroundTransparency=1
status.Position=UDim2.fromOffset(24,132)
status.Size=UDim2.new(1,-48,0,18)
status.Font=Enum.Font.Gotham
status.Text="Enter the same Serenity Access V2 key."
status.TextColor3=Color3.fromRGB(130,143,156)
status.TextSize=9
status.TextXAlignment=Enum.TextXAlignment.Left
status.Parent=main

local verify=Instance.new("TextButton")
verify.AutoButtonColor=false
verify.Position=UDim2.fromOffset(22,162)
verify.Size=UDim2.new(1,-44,0,42)
verify.BackgroundColor3=Color3.fromRGB(38,194,173)
verify.BorderSizePixel=0
verify.Font=Enum.Font.GothamBold
verify.Text="UNLOCK SERENITY"
verify.TextColor3=Color3.fromRGB(7,18,19)
verify.TextSize=11
verify.Parent=main
Instance.new("UICorner",verify).CornerRadius=UDim.new(0,9)

local busy=false
verify.MouseButton1Click:Connect(function()
    if busy then return end
    local entered=trim(input.Text)
    if entered=="" then status.Text="Enter your key first."; status.TextColor3=Color3.fromRGB(235,105,120); return end
    busy=true
    verify.Text="VERIFYING..."
    if entered~=currentKey then
        busy=false
        verify.Text="UNLOCK SERENITY"
        status.Text="Invalid Serenity key."
        status.TextColor3=Color3.fromRGB(235,105,120)
        return
    end
    writeReceipt(entered)
    status.Text="Access verified. Loading Serenity..."
    status.TextColor3=Color3.fromRGB(72,224,177)
    verify.Text="ACCESS VERIFIED"
    task.wait(.35)
    if gui then gui:Destroy() end
    currentKey=nil
    launchGame()
end)

return nil
