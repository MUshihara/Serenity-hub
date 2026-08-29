-- SERENITY HUB // THROW A COIN // PRODUCTION READABLE V1
-- PlaceId 115681808123944 | GameId 10131390815
-- Paid/Robux/gamepass injection, Luck Inject, Worlds, Throw Speed, and admin/mod paths are intentionally excluded.

if game.PlaceId~=115681808123944 then
    error("[SERENITY HUB] Throw a Coin: unsupported PlaceId.",0)
end

local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local LP=Players.LocalPlayer
local Events=RS:WaitForChild("Assets"):WaitForChild("Events")
local SellAll=Events:WaitForChild("SellAll")
local BuyCoin=Events:WaitForChild("BuyCoin")
local SyncCoins=Events:WaitForChild("SyncCoins")
local RequestUpgrade=Events:WaitForChild("RequestUpgrade")
local SyncUpgrades=Events:WaitForChild("SyncUpgrades")

local BASE="https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local State={
    Running=true,
    OwnedCoins={},
    Upgrades={["Luck Multiplier"]=0,["Value Multiplier"]=0},
    AutoSell=false,AutoLuck=false,AutoValue=false,AutoBuyCoins=false,
    LastSellAt=0,SpendBusy=false,SpendScheduled=false,PendingSpend=nil,
    ActionGate={},CacheDirty=true,CoinShop=nil,CoinCards={},LuckCard=nil,ValueCard=nil,
    SerenityEnabledAutoThrow=false,
}

local GameAPI={}
local Controller={Runtime=nil}

local function cash()
    local ls=LP:FindFirstChild("leaderstats")
    local v=ls and ls:FindFirstChild("Cash")
    return v and tonumber(v.Value) or 0
end

local function rap()
    return tonumber(LP:GetAttribute("RAP")) or 0
end

function GameAPI.GetGameAutoThrowUI()
    local pg=LP:FindFirstChild("PlayerGui")
    local ui=pg and pg:FindFirstChild("UiFolder")
    local main=ui and ui:FindFirstChild("Main")
    local hud=main and main:FindFirstChild("HUD")
    local coin=hud and hud:FindFirstChild("Coin")
    local button=coin and coin:FindFirstChild("AutoButton")
    return button,button and button:FindFirstChild("OffOn")
end

function GameAPI.IsAutoThrowOn()
    local _,label=GameAPI.GetGameAutoThrowUI()
    return label and label:IsA("TextLabel") and string.upper(tostring(label.Text))=="ON" or false
end

local function clickAutoThrowButton()
    local button=GameAPI.GetGameAutoThrowUI()
    if not button then return false,"AutoButton not found" end
    if firesignal then
        local ok=pcall(function() firesignal(button.MouseButton1Click) end)
        if ok then return true end
    end
    if getconnections then
        local ok,list=pcall(getconnections,button.MouseButton1Click)
        if ok and type(list)=="table" then
            local called=false
            for _,c in ipairs(list) do
                if type(c.Function)=="function" and pcall(c.Function) then called=true end
            end
            if called then return true end
        end
    end
    return false,"executor cannot invoke the exact AutoButton callback"
end

function GameAPI.SetAutoThrow(on)
    on=on==true
    if GameAPI.IsAutoThrowOn()==on then return true end
    local ok,err=clickAutoThrowButton()
    if not ok then warn("[SERENITY HUB] Auto Throw: "..tostring(err)); return false end
    local deadline=os.clock()+1.5
    repeat
        task.wait(.05)
        if GameAPI.IsAutoThrowOn()==on then return true end
    until os.clock()>=deadline
    return GameAPI.IsAutoThrowOn()==on
end

function GameAPI.SellAll()
    if rap()<=0 then return false end
    local now=os.clock()
    if now-State.LastSellAt<.4 then return false end
    State.LastSellAt=now
    SellAll:FireServer()
    return true
end

local function parseMoneyText(text)
    if type(text)~="string" then return nil end
    local raw=text
    text=text:gsub(",",""):gsub("%s+","")
    if text:find("%%",1,true) or text:match("^[xX]%d") or text:match("%([xX]%d+%)") then return nil end
    local hasDollar=text:find("%$")~=nil
    text=text:gsub("%$","")
    local n,s=text:match("^([%d%.]+)([%a]*)$")
    n=tonumber(n)
    if not n then return nil end
    local m={['']=1,k=1e3,m=1e6,b=1e9,t=1e12,qa=1e15,qi=1e18,sx=1e21,sp=1e24,oc=1e27,no=1e30,dc=1e33}
    local mult=m[string.lower(s or "")]
    if not mult then return nil end
    return n*mult,hasDollar,raw
end

local function bestCashPrice(root)
    if not root then return nil end
    local bestValue,bestScore,bestText
    local function inspect(o)
        if not (o:IsA("TextLabel") or o:IsA("TextButton")) then return end
        local path=string.lower(o:GetFullName())
        if path:find(".rbx",1,true) or path:find("robux",1,true) or path:find("doublethrow",1,true)
            or path:find("passes",1,true) or path:find("productholder",1,true)
            or path:find("starterpack",1,true) or path:find("propack",1,true) then return end
        local value,dollar,raw=parseMoneyText(o.Text)
        if not value then return end
        local name=string.lower(o.Name)
        local score=0
        if dollar then score+=100 end
        if name:find("price",1,true) then score+=50 end
        if name:find("cost",1,true) then score+=50 end
        if name:find("cash",1,true) then score+=40 end
        if name:find("amount",1,true) then score+=15 end
        if name:find("level",1,true) or name:find("luck",1,true) or name:find("odds",1,true)
            or name:find("stock",1,true) or name:find("count",1,true) then score-=80 end
        if not bestScore or score>bestScore then bestValue,bestScore,bestText=value,score,raw end
    end
    inspect(root)
    for _,o in ipairs(root:GetDescendants()) do inspect(o) end
    if bestScore and bestScore>=40 then return bestValue,bestText end
    return nil
end

local function mainFrames()
    local pg=LP:FindFirstChild("PlayerGui")
    local ui=pg and pg:FindFirstChild("UiFolder")
    local main=ui and ui:FindFirstChild("Main")
    return main and main:FindFirstChild("Frames")
end

local function coinCardForObject(obj,shop)
    local p=obj
    while p and p~=shop do
        if p.Parent==shop then return p end
        p=p.Parent
    end
end

function GameAPI.RebuildShopCache()
    State.CacheDirty=false
    State.CoinCards={}
    local frames=mainFrames()
    local shop=frames and frames:FindFirstChild("CoinShop")
    local upgrades=frames and frames:FindFirstChild("Upgrades")
    local holder=upgrades and upgrades:FindFirstChild("SFHolder")
    State.CoinShop=shop
    State.LuckCard=holder and holder:FindFirstChild("Luck Multiplier")
    State.ValueCard=holder and holder:FindFirstChild("Value Multiplier")
    if not shop then return end
    local seen={}
    for _,o in ipairs(shop:GetDescendants()) do
        local id=o:GetAttribute("CoinId")
        if type(id)=="string" and id~="" and not seen[id] then
            local card=coinCardForObject(o,shop)
            if card then
                local path=string.lower(card:GetFullName())
                local paid=path:find("doublethrow",1,true) or path:find("pack",1,true)
                    or path:find("robux",1,true) or card:GetAttribute("PromptId")~=nil
                if not paid then seen[id]=true; State.CoinCards[id]=card end
            end
        end
    end
end

local function ensureCache()
    if State.CacheDirty or not State.CoinShop or not State.CoinShop.Parent then GameAPI.RebuildShopCache() end
end

function GameAPI.GetCashCoinOptions()
    ensureCache()
    local options={}
    for id,card in pairs(State.CoinCards) do
        if not State.OwnedCoins[id] and card and card.Parent then
            local price,text=bestCashPrice(card)
            if price then options[#options+1]={Id=id,Price=price,PriceText=text} end
        end
    end
    table.sort(options,function(a,b) return a.Price==b.Price and a.Id<b.Id or a.Price<b.Price end)
    return options
end

function GameAPI.GetUpgradePrice(name)
    ensureCache()
    local card=name=="Luck Multiplier" and State.LuckCard or State.ValueCard
    if not card or not card.Parent then
        State.CacheDirty=true; ensureCache()
        card=name=="Luck Multiplier" and State.LuckCard or State.ValueCard
    end
    return card and bestCashPrice(card) or nil
end

local function clearSpend()
    State.PendingSpend=nil
    State.SpendBusy=false
end

local function gateAllows(key,price,sig)
    local affordable=cash()>=price
    local old=State.ActionGate[key]
    if not affordable then State.ActionGate[key]={Price=price,Sig=sig,Affordable=false}; return false end
    if old and old.Affordable and old.Price==price and old.Sig==sig then return false end
    State.ActionGate[key]={Price=price,Sig=sig,Affordable=true}
    return true
end

local function requestCoin(id,price,manual)
    if cash()<price then return false end
    local sig=State.OwnedCoins[id]==true
    if not manual and not gateAllows("coin:"..id,price,sig) then return false end
    State.SpendBusy=true
    State.PendingSpend={Kind="Coin",Id=id,Before=sig}
    BuyCoin:FireServer(id)
    task.delay(2.5,function()
        local p=State.PendingSpend
        if p and p.Kind=="Coin" and p.Id==id then clearSpend() end
    end)
    return true
end

local function requestUpgrade(name,price,manual)
    if cash()<price then return false end
    local sig=tonumber(State.Upgrades[name]) or 0
    if not manual and not gateAllows("upgrade:"..name,price,sig) then return false end
    State.SpendBusy=true
    State.PendingSpend={Kind="Upgrade",Id=name,Before=sig}
    RequestUpgrade:FireServer(name)
    task.delay(2.5,function()
        local p=State.PendingSpend
        if p and p.Kind=="Upgrade" and p.Id==name then clearSpend() end
    end)
    return true
end

local function scheduleSpendCheck()
    if not State.Running or State.SpendScheduled then return end
    State.SpendScheduled=true
    task.defer(function()
        State.SpendScheduled=false
        if not State.Running or State.SpendBusy then return end
        if State.AutoBuyCoins then
            local nextCoin=GameAPI.GetCashCoinOptions()[1]
            if nextCoin and requestCoin(nextCoin.Id,nextCoin.Price,false) then return end
        end
        local choices={}
        if State.AutoLuck then
            local p=GameAPI.GetUpgradePrice("Luck Multiplier")
            if p then choices[#choices+1]={Name="Luck Multiplier",Price=p} end
        end
        if State.AutoValue then
            local p=GameAPI.GetUpgradePrice("Value Multiplier")
            if p then choices[#choices+1]={Name="Value Multiplier",Price=p} end
        end
        table.sort(choices,function(a,b) return a.Price<b.Price end)
        for _,c in ipairs(choices) do if requestUpgrade(c.Name,c.Price,false) then return end end
    end)
end

function Controller.SetAutoThrow(v)
    v=v==true
    local before=GameAPI.IsAutoThrowOn()
    local ok=GameAPI.SetAutoThrow(v)
    if ok and v and not before then State.SerenityEnabledAutoThrow=true end
    if ok and not v then State.SerenityEnabledAutoThrow=false end
    return ok
end
function Controller.SetAutoSell(v) State.AutoSell=v==true; if State.AutoSell then GameAPI.SellAll() end end
function Controller.SetAutoLuck(v) State.AutoLuck=v==true; if State.AutoLuck then scheduleSpendCheck() end end
function Controller.SetAutoValue(v) State.AutoValue=v==true; if State.AutoValue then scheduleSpendCheck() end end
function Controller.SetAutoBuyCoins(v) State.AutoBuyCoins=v==true; if State.AutoBuyCoins then scheduleSpendCheck() end end
function Controller.SellNow() GameAPI.SellAll() end
function Controller.BuyNextCoin()
    if State.SpendBusy then return end
    local c=GameAPI.GetCashCoinOptions()[1]
    if c then requestCoin(c.Id,c.Price,true) end
end
function Controller.UpgradeOnce(name)
    if State.SpendBusy then return end
    local p=GameAPI.GetUpgradePrice(name)
    if p then requestUpgrade(name,p,true) end
end
function Controller.StopAll()
    State.AutoSell=false; State.AutoLuck=false; State.AutoValue=false; State.AutoBuyCoins=false; clearSpend()
    if State.SerenityEnabledAutoThrow and GameAPI.IsAutoThrowOn() then pcall(function() GameAPI.SetAutoThrow(false) end) end
    State.SerenityEnabledAutoThrow=false
end

local earlyConnections={}
local function early(c) earlyConnections[#earlyConnections+1]=c; return c end

early(SyncCoins.OnClientEvent:Connect(function(list)
    local owned={}
    for _,name in ipairs(list or {}) do owned[tostring(name)]=true end
    State.OwnedCoins=owned
    local p=State.PendingSpend
    if p and p.Kind=="Coin" and owned[p.Id] then clearSpend() end
    scheduleSpendCheck()
end))

early(SyncUpgrades.OnClientEvent:Connect(function(levels)
    if type(levels)~="table" then return end
    State.Upgrades["Luck Multiplier"]=tonumber(levels["Luck Multiplier"]) or State.Upgrades["Luck Multiplier"]
    State.Upgrades["Value Multiplier"]=tonumber(levels["Value Multiplier"]) or State.Upgrades["Value Multiplier"]
    local p=State.PendingSpend
    if p and p.Kind=="Upgrade" and (tonumber(State.Upgrades[p.Id]) or 0)>(tonumber(p.Before) or 0) then clearSpend() end
    scheduleSpendCheck()
end))

early(LP:GetAttributeChangedSignal("RAP"):Connect(function()
    if State.AutoSell and rap()>0 then GameAPI.SellAll() end
end))

local ls=LP:FindFirstChild("leaderstats")
local cv=ls and ls:FindFirstChild("Cash")
if cv then early(cv.Changed:Connect(scheduleSpendCheck)) end

task.defer(function()
    GameAPI.RebuildShopCache()
    if State.CoinShop then
        early(State.CoinShop.DescendantAdded:Connect(function() State.CacheDirty=true end))
        early(State.CoinShop.DescendantRemoving:Connect(function() State.CacheDirty=true end))
    end
end)
pcall(function() SyncCoins:FireServer() end)

local app
local manifest={
    SerenityAPIVersion=3,ConfigVersion=1,RuntimeKey="__SERENITY_THROW_A_COIN_V1",
    ConfigPath="SerenityHub/throw-a-coin.json",GameName="[W5] Throw a Coin",
    DesktopWidth=920,DesktopHeight=570,MobileWidth=650,MobileHeight=420,
    Pages={
        {Id="Dashboard",Title="Dashboard",Icon="layout-dashboard",Features={
            {Id="Quick",Title="Quick Actions",Description="Validated one-time game actions.",Accent="cyan",Controls={
                {Type="Action",Id="SellNow",Title="Sell Now",Description="Sell current inventory value.",ButtonText="SELL",Callback=Controller.SellNow},
                {Type="Action",Id="BuyCoin",Title="Buy Next Affordable Coin",Description="Buy one missing cash coin only after an exact non-paid affordability check.",ButtonText="BUY",Callback=Controller.BuyNextCoin},
            }},
            {Id="Safety",Title="Production Safety",Description="Paid and unvalidated paths are excluded.",Accent="purple",Controls={
                {Type="Paragraph",Title="Excluded",Text="No Luck Inject, gamepass injection, Robux prompts, Worlds, Throw Speed, or admin/mod remotes."},
            }},
        }},
        {Id="Automation",Title="Automation",Icon="bot",Features={
            {Id="Throwing",Title="Throwing",Description="Uses the game's exact normal Auto Throw callback.",Accent="cyan",Controls={
                {Type="Switch",Id="AutoThrow",Title="In-Game Auto Throw",Description="Toggle the game's own normal Auto Throw.",Default=false,Changed=Controller.SetAutoThrow},
            }},
            {Id="Selling",Title="Selling",Description="Event-driven inventory selling.",Accent="mint",Controls={
                {Type="Switch",Id="AutoSell",Title="Auto Sell",Description="Sell when RAP becomes available.",Default=false,Changed=Controller.SetAutoSell},
            }},
            {Id="Coins",Title="Coins",Description="Live cash-price affordability checks.",Accent="purple",Controls={
                {Type="Switch",Id="AutoBuyCoins",Title="Auto Buy Cash Coins",Description="Buy missing cash coins only when affordable.",Default=false,Changed=Controller.SetAutoBuyCoins},
            }},
        }},
        {Id="Progression",Title="Progression",Icon="trending-up",Features={
            {Id="Upgrades",Title="Upgrades",Description="Serialized cash upgrades with live price checks.",Accent="mint",Controls={
                {Type="Switch",Id="AutoLuck",Title="Auto Luck Upgrade",Description="Buy Luck Multiplier only when affordable.",Default=false,Changed=Controller.SetAutoLuck},
                {Type="Switch",Id="AutoValue",Title="Auto Value Upgrade",Description="Buy Value Multiplier only when affordable.",Default=false,Changed=Controller.SetAutoValue},
                {Type="Action",Id="LuckOnce",Title="Luck +1",Description="Request one affordable Luck Multiplier upgrade.",ButtonText="+1",Callback=function() Controller.UpgradeOnce("Luck Multiplier") end},
                {Type="Action",Id="ValueOnce",Title="Value +1",Description="Request one affordable Value Multiplier upgrade.",ButtonText="+1",Callback=function() Controller.UpgradeOnce("Value Multiplier") end},
            }},
        }},
        {Id="Settings",Title="Settings",Icon="settings",Features={
            {Id="Runtime",Title="Runtime",Description="Serenity runtime controls.",Accent="purple",Controls={
                {Type="Action",Id="StopAll",Title="Stop All",Description="Stop all active Throw a Coin automation and close Serenity.",ButtonText="STOP",Danger=true,Callback=function() Controller.StopAll(); if app then app:Destroy() end end},
                {Type="Action",Id="SaveConfig",Title="Save Settings",Description="Save current Serenity settings now.",ButtonText="SAVE",CoreAction="SaveConfig"},
            }},
        }},
    },
}

local bootstrapSource=game:HttpGet(BASE.."dist/core/bootstrap.lua?throwcoin="..tostring(os.time()))
local bootstrapChunk,err=loadstring(bootstrapSource,"@Serenity/ThrowACoin/Bootstrap")
bootstrapSource=nil
if not bootstrapChunk then error("[SERENITY HUB] Bootstrap compile failed: "..tostring(err),0) end
local bootstrap=bootstrapChunk()
app=bootstrap(manifest,{RuntimeKey=manifest.RuntimeKey,ConfigPath=manifest.ConfigPath})
Controller.Runtime=app.Runtime
for _,c in ipairs(earlyConnections) do app.Runtime:TrackConnection(c) end
table.clear(earlyConnections)
app.Runtime:TrackCleanup(function() State.Running=false; Controller.StopAll() end)
Controller.SetAutoSell(app.Config:Get("Automation.Selling.AutoSell",false))
Controller.SetAutoLuck(app.Config:Get("Progression.Upgrades.AutoLuck",false))
Controller.SetAutoValue(app.Config:Get("Progression.Upgrades.AutoValue",false))
Controller.SetAutoBuyCoins(app.Config:Get("Automation.Coins.AutoBuyCoins",false))
if app.Config:Get("Automation.Throwing.AutoThrow",false) then Controller.SetAutoThrow(true) end
return app
