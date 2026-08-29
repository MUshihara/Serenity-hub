--[[
    SERENITY HUB // THROW A COIN
    Readable Production Candidate V2

    Game:
      [W5] Throw a Coin
      PlaceId: 115681808123944
      UniverseId: 10131390815

    Included proven/free mechanics:
      - In-Game Auto Throw (exact game AutoButton callback)
      - Auto Sell
      - Auto Luck Upgrade
      - Auto Value Upgrade
      - Auto Buy Cash Coins
      - Sell Now
      - Buy Next Affordable Coin
      - Luck +1
      - Value +1
      - All Gamepasses (attribute injection, re-applied continuously)
      - Luck Inject (DesiredLuck=999999, re-applied continuously)

    Excluded:
      - Robux / paid prompts
      - Worlds / map
      - Throw Speed upgrade
      - Admin / moderator remotes
]]

local EXPECTED_PLACE = 115681808123944
if game.PlaceId ~= EXPECTED_PLACE then
    error("[SERENITY HUB] Throw a Coin: unsupported PlaceId.", 0)
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Events = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Events")

local SellAll        = Events:WaitForChild("SellAll")
local BuyCoin        = Events:WaitForChild("BuyCoin")
local SyncCoins      = Events:WaitForChild("SyncCoins")
local RequestUpgrade = Events:WaitForChild("RequestUpgrade")
local SyncUpgrades   = Events:WaitForChild("SyncUpgrades")

local BASE           = "https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/"
local BOOTSTRAP_PATH = "dist/core/bootstrap.lua"

----------------------------------------------------------------
-- GAMEPASS ATTRIBUTE INJECTION
-- All confirmed gamepass/premium flags from live attribute dump.
-- Server does not reset these after join — they stick.
----------------------------------------------------------------
local GAMEPASS_ATTRS = {
    VIP                  = true,
    MoreLuck             = true,
    InsaneLuck           = true,
    DoubleCash           = true,
    DoubleThrow          = true,
    BetterPlacement      = true,
    DynamicCoinOwned     = true,
    DragonBooth          = true,
    CC                   = true,
    TradeWorldUnlocked   = true,
    MutationSkips        = 999,
    ThrowSpeedLevel      = 10,
    PaidRandomRestricted = false,
}

local function applyAllGamepasses()
    for k, v in pairs(GAMEPASS_ATTRS) do
        LocalPlayer:SetAttribute(k, v)
    end
end

local function applyLuckInject()
    LocalPlayer:SetAttribute("DesiredLuck", 999999)
end

local function clearLuckInject()
    LocalPlayer:SetAttribute("DesiredLuck", nil)
end

----------------------------------------------------------------
-- GAME API
----------------------------------------------------------------

local GameAPI = {}

local State = {
    Running = true,

    OwnedCoins = {},
    Upgrades = {
        ["Luck Multiplier"]  = 0,
        ["Value Multiplier"] = 0,
    },

    AutoSell       = false,
    AutoLuck       = false,
    AutoValue      = false,
    AutoBuyCoins   = false,
    AllGamepasses  = false,
    LuckInject     = false,

    LastSellAt     = 0,

    CoinShop   = nil,
    CoinCards  = {},
    LuckCard   = nil,
    ValueCard  = nil,

    SpendBusy      = false,
    SpendScheduled = false,
    PendingSpend   = nil,
    ActionGate     = {},
    CacheDirty     = true,

    SerenityEnabledAutoThrow = false,
}

local function getLeaderstats()
    return LocalPlayer:FindFirstChild("leaderstats")
end

function GameAPI.GetCash()
    local ls   = getLeaderstats()
    local cash = ls and ls:FindFirstChild("Cash")
    return cash and tonumber(cash.Value) or 0
end

function GameAPI.GetRAP()
    return tonumber(LocalPlayer:GetAttribute("RAP")) or 0
end

function GameAPI.GetOwnedCoinCount()
    local count = 0
    for _ in pairs(State.OwnedCoins) do count += 1 end
    return count
end

function GameAPI.GetUpgradeLevel(name)
    return tonumber(State.Upgrades[name]) or 0
end

function GameAPI.GetGameAutoThrowUI()
    local pg   = LocalPlayer:FindFirstChild("PlayerGui")
    local ui   = pg   and pg:FindFirstChild("UiFolder")
    local main = ui   and ui:FindFirstChild("Main")
    local hud  = main and main:FindFirstChild("HUD")
    local coin = hud  and hud:FindFirstChild("Coin")
    local ab   = coin and coin:FindFirstChild("AutoButton")
    local oo   = ab   and ab:FindFirstChild("OffOn")
    return ab, oo
end

function GameAPI.IsGameAutoThrowOn()
    local _, offOn = GameAPI.GetGameAutoThrowUI()
    if offOn and offOn:IsA("TextLabel") then
        return string.upper(tostring(offOn.Text)) == "ON"
    end
    return false
end

local function fireExactAutoThrowButton()
    local autoButton = GameAPI.GetGameAutoThrowUI()
    if not autoButton then return false, "AutoButton not found" end

    if firesignal then
        local ok = pcall(function() firesignal(autoButton.MouseButton1Click) end)
        if ok then return true end
    end

    if getconnections then
        local ok, connections = pcall(getconnections, autoButton.MouseButton1Click)
        if ok and type(connections) == "table" then
            local called = false
            for _, c in ipairs(connections) do
                local fn = c.Function
                if type(fn) == "function" then
                    local ran = pcall(fn)
                    if ran then called = true end
                end
            end
            if called then return true end
        end
    end

    return false, "executor cannot activate the exact AutoButton callback"
end

function GameAPI.SetGameAutoThrow(on)
    on = on == true
    local current = GameAPI.IsGameAutoThrowOn()
    if current == on then return true end

    local ok, err = fireExactAutoThrowButton()
    if not ok then
        warn("[SERENITY HUB] Auto Throw: " .. tostring(err))
        return false
    end

    local deadline = os.clock() + 1.5
    repeat
        task.wait(0.05)
        if GameAPI.IsGameAutoThrowOn() == on then return true end
    until os.clock() >= deadline

    return GameAPI.IsGameAutoThrowOn() == on
end

function GameAPI.SellAll()
    if GameAPI.GetRAP() <= 0 then return false, "EMPTY" end
    local now = os.clock()
    if now - State.LastSellAt < 0.4 then return false, "DEBOUNCE" end
    State.LastSellAt = now
    SellAll:FireServer()
    return true, "REQUESTED"
end

local function parseMoneyText(text)
    if type(text) ~= "string" then return nil end
    local original = text
    text = text:gsub(",",""):gsub("%s+","")
    if text:find("%%",1,true)
    or text:match("^[xX]%d")
    or text:match("%([xX]%d+%)") then return nil end
    local hasDollar = text:find("%$") ~= nil
    text = text:gsub("%$","")
    local numberText, suffix = text:match("^([%d%.]+)([%a]*)$")
    local number = tonumber(numberText)
    if not number then return nil end
    local multipliers = {
        [""]=1,["k"]=1e3,["m"]=1e6,["b"]=1e9,["t"]=1e12,
        ["qa"]=1e15,["qi"]=1e18,["sx"]=1e21,["sp"]=1e24,
        ["oc"]=1e27,["no"]=1e30,["dc"]=1e33,
    }
    local multiplier = multipliers[string.lower(suffix or "")]
    if not multiplier then return nil end
    return number * multiplier, hasDollar, original
end

local function bestCashPrice(root)
    if not root then return nil end
    local bestValue, bestScore, bestText
    local function inspect(object)
        if not (object:IsA("TextLabel") or object:IsA("TextButton")) then return end
        local path = string.lower(object:GetFullName())
        if path:find(".rbx",1,true) or path:find("robux",1,true)
        or path:find("doublethrow",1,true) or path:find("passes",1,true)
        or path:find("productholder",1,true) or path:find("starterpack",1,true)
        or path:find("propack",1,true) then return end
        local value, hasDollar, raw = parseMoneyText(object.Text)
        if not value then return end
        local name  = string.lower(object.Name)
        local score = 0
        if hasDollar then score += 100 end
        if name:find("price",1,true) then score += 50 end
        if name:find("cost",1,true)  then score += 50 end
        if name:find("cash",1,true)  then score += 40 end
        if name:find("amount",1,true) then score += 15 end
        if name:find("level",1,true) or name:find("luck",1,true)
        or name:find("odds",1,true)  or name:find("stock",1,true)
        or name:find("count",1,true) then score -= 80 end
        if not bestScore or score > bestScore then
            bestValue, bestScore, bestText = value, score, raw
        end
    end
    inspect(root)
    for _, o in ipairs(root:GetDescendants()) do inspect(o) end
    if bestScore and bestScore >= 40 then return bestValue, bestText end
    return nil
end

local function getMainFrames()
    local pg   = LocalPlayer:FindFirstChild("PlayerGui")
    local ui   = pg   and pg:FindFirstChild("UiFolder")
    local main = ui   and ui:FindFirstChild("Main")
    return main and main:FindFirstChild("Frames")
end

local function coinCardForObject(object, shop)
    local current = object
    while current and current ~= shop do
        if current.Parent == shop then return current end
        current = current.Parent
    end
    return nil
end

function GameAPI.RebuildShopCache()
    State.CacheDirty = false
    State.CoinCards  = {}
    local frames   = getMainFrames()
    local shop     = frames and frames:FindFirstChild("CoinShop")
    local upgrades = frames and frames:FindFirstChild("Upgrades")
    local holder   = upgrades and upgrades:FindFirstChild("SFHolder")
    State.CoinShop  = shop
    State.LuckCard  = holder and holder:FindFirstChild("Luck Multiplier")
    State.ValueCard = holder and holder:FindFirstChild("Value Multiplier")
    if not shop then return end
    local seen = {}
    for _, object in ipairs(shop:GetDescendants()) do
        local coinId = object:GetAttribute("CoinId")
        if type(coinId)=="string" and coinId~="" and not seen[coinId] then
            local card = coinCardForObject(object, shop)
            if card then
                local path = string.lower(card:GetFullName())
                local paid = path:find("doublethrow",1,true)
                    or path:find("pack",1,true)
                    or path:find("robux",1,true)
                    or card:GetAttribute("PromptId") ~= nil
                if not paid then
                    seen[coinId] = true
                    State.CoinCards[coinId] = card
                end
            end
        end
    end
end

local function ensureShopCache()
    if State.CacheDirty or not State.CoinShop or not State.CoinShop.Parent then
        GameAPI.RebuildShopCache()
    end
end

function GameAPI.GetCashCoinOptions()
    ensureShopCache()
    local options = {}
    for coinId, card in pairs(State.CoinCards) do
        if not State.OwnedCoins[coinId] and card and card.Parent then
            local price, priceText = bestCashPrice(card)
            if price then
                options[#options+1] = {Id=coinId, Price=price, PriceText=priceText}
            end
        end
    end
    table.sort(options, function(a,b)
        return a.Price==b.Price and a.Id<b.Id or a.Price<b.Price
    end)
    return options
end

function GameAPI.GetUpgradePrice(name)
    ensureShopCache()
    local card = name=="Luck Multiplier" and State.LuckCard or State.ValueCard
    if not card or not card.Parent then
        State.CacheDirty = true
        ensureShopCache()
        card = name=="Luck Multiplier" and State.LuckCard or State.ValueCard
    end
    if not card then return nil end
    return bestCashPrice(card)
end

function GameAPI.BuyCoin(coinId)
    if type(coinId)~="string" or coinId=="" then return false end
    BuyCoin:FireServer(coinId)
    return true
end

function GameAPI.RequestUpgrade(name)
    if name~="Luck Multiplier" and name~="Value Multiplier" then return false end
    RequestUpgrade:FireServer(name)
    return true
end

----------------------------------------------------------------
-- CONTROLLERS
----------------------------------------------------------------

local Controller = { Runtime = nil }

local function clearPendingSpend()
    State.PendingSpend = nil
    State.SpendBusy    = false
end

local function actionGateAllows(key, price, stateSignature)
    local affordable = GameAPI.GetCash() >= price
    local old = State.ActionGate[key]
    if not affordable then
        State.ActionGate[key] = {Price=price, Signature=stateSignature, Affordable=false}
        return false
    end
    if old and old.Affordable and old.Price==price and old.Signature==stateSignature then
        return false
    end
    State.ActionGate[key] = {Price=price, Signature=stateSignature, Affordable=true}
    return true
end

local function scheduleSpendCheck()
    if not State.Running or State.SpendScheduled then return end
    State.SpendScheduled = true
    task.defer(function()
        State.SpendScheduled = false
        if not State.Running or State.SpendBusy then return end
        local money = GameAPI.GetCash()
        if State.AutoBuyCoins then
            local coins    = GameAPI.GetCashCoinOptions()
            local nextCoin = coins[1]
            if nextCoin then
                local key = "coin:"..nextCoin.Id
                local sig = State.OwnedCoins[nextCoin.Id]==true
                if money>=nextCoin.Price and actionGateAllows(key,nextCoin.Price,sig) then
                    State.SpendBusy    = true
                    State.PendingSpend = {Kind="Coin",Id=nextCoin.Id,Before=sig,StartedAt=os.clock()}
                    GameAPI.BuyCoin(nextCoin.Id)
                    task.delay(2.5,function()
                        local p=State.PendingSpend
                        if p and p.Kind=="Coin" and p.Id==nextCoin.Id then clearPendingSpend() end
                    end)
                    return
                elseif money<nextCoin.Price then
                    actionGateAllows(key,nextCoin.Price,sig)
                end
            end
        end
        local choices = {}
        if State.AutoLuck then
            local p,t = GameAPI.GetUpgradePrice("Luck Multiplier")
            if p then choices[#choices+1]={Key="upgrade:Luck Multiplier",Name="Luck Multiplier",Price=p,PriceText=t,Signature=GameAPI.GetUpgradeLevel("Luck Multiplier")} end
        end
        if State.AutoValue then
            local p,t = GameAPI.GetUpgradePrice("Value Multiplier")
            if p then choices[#choices+1]={Key="upgrade:Value Multiplier",Name="Value Multiplier",Price=p,PriceText=t,Signature=GameAPI.GetUpgradeLevel("Value Multiplier")} end
        end
        table.sort(choices,function(a,b) return a.Price<b.Price end)
        for _,choice in ipairs(choices) do
            if money>=choice.Price and actionGateAllows(choice.Key,choice.Price,choice.Signature) then
                State.SpendBusy    = true
                State.PendingSpend = {Kind="Upgrade",Id=choice.Name,Before=choice.Signature,StartedAt=os.clock()}
                GameAPI.RequestUpgrade(choice.Name)
                task.delay(2.5,function()
                    local p=State.PendingSpend
                    if p and p.Kind=="Upgrade" and p.Id==choice.Name then clearPendingSpend() end
                end)
                return
            elseif money<choice.Price then
                actionGateAllows(choice.Key,choice.Price,choice.Signature)
            end
        end
    end)
end

function Controller.SetAutoThrow(enabled)
    enabled = enabled==true
    local before = GameAPI.IsGameAutoThrowOn()
    local ok     = GameAPI.SetGameAutoThrow(enabled)
    if ok and enabled and not before then
        State.SerenityEnabledAutoThrow = true
    elseif ok and not enabled then
        State.SerenityEnabledAutoThrow = false
    end
    return ok
end

function Controller.SetAutoSell(enabled)
    State.AutoSell = enabled==true
    if State.AutoSell then GameAPI.SellAll() end
end

function Controller.SetAutoLuck(enabled)
    State.AutoLuck = enabled==true
    if State.AutoLuck then scheduleSpendCheck() end
end

function Controller.SetAutoValue(enabled)
    State.AutoValue = enabled==true
    if State.AutoValue then scheduleSpendCheck() end
end

function Controller.SetAutoBuyCoins(enabled)
    State.AutoBuyCoins = enabled==true
    if State.AutoBuyCoins then scheduleSpendCheck() end
end

function Controller.SetAllGamepasses(enabled)
    State.AllGamepasses = enabled==true
    if State.AllGamepasses then applyAllGamepasses() end
end

function Controller.SetLuckInject(enabled)
    State.LuckInject = enabled==true
    if State.LuckInject then
        applyLuckInject()
    else
        clearLuckInject()
    end
end

function Controller.SellNow()
    GameAPI.SellAll()
end

function Controller.BuyNextAffordableCoin()
    local previous     = State.AutoBuyCoins
    State.AutoBuyCoins = true
    scheduleSpendCheck()
    task.defer(function() State.AutoBuyCoins = previous end)
end

function Controller.UpgradeOnce(name)
    if State.SpendBusy then return end
    local price = GameAPI.GetUpgradePrice(name)
    if not price then return end
    local money     = GameAPI.GetCash()
    local signature = GameAPI.GetUpgradeLevel(name)
    local key       = "manual-upgrade:"..name
    if money<price then actionGateAllows(key,price,signature); return end
    if not actionGateAllows(key,price,signature) then return end
    State.SpendBusy    = true
    State.PendingSpend = {Kind="Upgrade",Id=name,Before=signature,StartedAt=os.clock()}
    GameAPI.RequestUpgrade(name)
    task.delay(2.5,function()
        local p=State.PendingSpend
        if p and p.Kind=="Upgrade" and p.Id==name then clearPendingSpend() end
    end)
end

function Controller.StopAll()
    State.AutoSell      = false
    State.AutoLuck      = false
    State.AutoValue     = false
    State.AutoBuyCoins  = false
    State.AllGamepasses = false
    State.LuckInject    = false
    clearLuckInject()
    clearPendingSpend()
    if State.SerenityEnabledAutoThrow and GameAPI.IsGameAutoThrowOn() then
        pcall(function() GameAPI.SetGameAutoThrow(false) end)
    end
    State.SerenityEnabledAutoThrow = false
end

----------------------------------------------------------------
-- CONTINUOUS RE-APPLY LOOP
-- Keeps gamepass attributes and luck inject active
-- Server never resets them so 5s interval is enough
----------------------------------------------------------------
task.spawn(function()
    while State.Running do
        task.wait(5)
        if State.AllGamepasses then applyAllGamepasses() end
        if State.LuckInject    then applyLuckInject()    end
    end
end)

----------------------------------------------------------------
-- REMOTE / STATE CONFIRMATION
----------------------------------------------------------------

local preBootstrapConnections = {}
local function preTrack(connection)
    preBootstrapConnections[#preBootstrapConnections+1] = connection
    return connection
end

preTrack(SyncCoins.OnClientEvent:Connect(function(list)
    local nextOwned = {}
    for _, name in ipairs(list or {}) do nextOwned[tostring(name)]=true end
    State.OwnedCoins = nextOwned
    local p = State.PendingSpend
    if p and p.Kind=="Coin" and State.OwnedCoins[p.Id]==true then clearPendingSpend() end
    scheduleSpendCheck()
end))

preTrack(SyncUpgrades.OnClientEvent:Connect(function(levels)
    if type(levels)~="table" then return end
    local oldLuck  = State.Upgrades["Luck Multiplier"]
    local oldValue = State.Upgrades["Value Multiplier"]
    State.Upgrades["Luck Multiplier"]  = tonumber(levels["Luck Multiplier"])  or oldLuck
    State.Upgrades["Value Multiplier"] = tonumber(levels["Value Multiplier"]) or oldValue
    local p = State.PendingSpend
    if p and p.Kind=="Upgrade" then
        local nowLevel = GameAPI.GetUpgradeLevel(p.Id)
        if nowLevel>tonumber(p.Before or 0) then clearPendingSpend() end
    end
    scheduleSpendCheck()
end))

preTrack(LocalPlayer:GetAttributeChangedSignal("RAP"):Connect(function()
    if State.AutoSell and GameAPI.GetRAP()>0 then GameAPI.SellAll() end
end))

local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
local cashValue   = leaderstats and leaderstats:FindFirstChild("Cash")
if cashValue then
    preTrack(cashValue.Changed:Connect(function() scheduleSpendCheck() end))
end

task.defer(function()
    GameAPI.RebuildShopCache()
    if State.CoinShop then
        preTrack(State.CoinShop.DescendantAdded:Connect(function()
            State.CacheDirty = true
        end))
        preTrack(State.CoinShop.DescendantRemoving:Connect(function()
            State.CacheDirty = true
        end))
    end
end)

pcall(function() SyncCoins:FireServer() end)

----------------------------------------------------------------
-- SERENITY MANIFEST
----------------------------------------------------------------

local app

local manifest = {
    SerenityAPIVersion = 3,
    ConfigVersion      = 1,
    RuntimeKey         = "__SERENITY_THROW_A_COIN_V2",
    ConfigPath         = "SerenityHub/throw-a-coin.json",

    GameName      = "[W5] Throw a Coin",
    DesktopWidth  = 920,
    DesktopHeight = 620,
    MobileWidth   = 650,
    MobileHeight  = 460,

    Pages = {
        ----------------------------------------------------------------
        -- DASHBOARD
        ----------------------------------------------------------------
        {
            Id          = "Dashboard",
            Title       = "Dashboard",
            Icon        = "layout-dashboard",
            Description = "Throw a Coin runtime overview.",
            Features = {
                {
                    Id          = "QuickActions",
                    Title       = "Quick Actions",
                    Description = "Safe one-time actions using validated game paths.",
                    Accent      = "cyan",
                    Controls = {
                        {
                            Type        = "Action",
                            Id          = "SellNow",
                            Title       = "Sell Now",
                            Description = "Sell the current local inventory value.",
                            ButtonText  = "SELL",
                            Callback    = function() Controller.SellNow() end,
                        },
                        {
                            Type        = "Action",
                            Id          = "BuyNextCoin",
                            Title       = "Buy Next Affordable Coin",
                            Description = "Buy one missing cash coin only when its exact current price is affordable.",
                            ButtonText  = "BUY",
                            Callback    = function() Controller.BuyNextAffordableCoin() end,
                        },
                    },
                },
                {
                    Id          = "Safety",
                    Title       = "Production Safety",
                    Description = "Paid and unvalidated paths are excluded.",
                    Accent      = "purple",
                    Controls = {
                        {
                            Type  = "Paragraph",
                            Title = "Excluded",
                            Text  = "No Robux prompts, Worlds, Throw Speed, or admin/mod remotes.",
                        },
                    },
                },
            },
        },

        ----------------------------------------------------------------
        -- AUTOMATION
        ----------------------------------------------------------------
        {
            Id          = "Automation",
            Title       = "Automation",
            Icon        = "bot",
            Description = "Independent low-lag automation.",
            Features = {
                {
                    Id          = "Throwing",
                    Title       = "Throwing",
                    Description = "Uses the game's exact normal Auto Throw button callback.",
                    Accent      = "cyan",
                    Controls = {
                        {
                            Type        = "Switch",
                            Id          = "AutoThrow",
                            Title       = "In-Game Auto Throw",
                            Description = "Toggle the game's own normal Auto Throw.",
                            Default     = false,
                            Changed     = function(value) Controller.SetAutoThrow(value) end,
                        },
                    },
                },
                {
                    Id          = "Selling",
                    Title       = "Selling",
                    Description = "Event-driven selling when inventory value appears.",
                    Accent      = "mint",
                    Controls = {
                        {
                            Type        = "Switch",
                            Id          = "AutoSell",
                            Title       = "Auto Sell",
                            Description = "Sell when RAP becomes available.",
                            Default     = false,
                            Changed     = function(value) Controller.SetAutoSell(value) end,
                        },
                    },
                },
                {
                    Id          = "Purchasing",
                    Title       = "Purchasing",
                    Description = "Exact affordability checks before any cash purchase.",
                    Accent      = "purple",
                    Controls = {
                        {
                            Type        = "Switch",
                            Id          = "AutoBuyCoins",
                            Title       = "Auto Buy Cash Coins",
                            Description = "Buy missing cash coins only after the live non-paid price is affordable.",
                            Default     = false,
                            Changed     = function(value) Controller.SetAutoBuyCoins(value) end,
                        },
                    },
                },
            },
        },

        ----------------------------------------------------------------
        -- PROGRESSION
        ----------------------------------------------------------------
        {
            Id          = "Progression",
            Title       = "Progression",
            Icon        = "trending-up",
            Description = "Cash upgrades with serialized spending.",
            Features = {
                {
                    Id          = "Upgrades",
                    Title       = "Upgrades",
                    Description = "Reads the current game price before requesting an upgrade.",
                    Accent      = "mint",
                    Controls = {
                        {
                            Type        = "Switch",
                            Id          = "AutoLuck",
                            Title       = "Auto Luck Upgrade",
                            Description = "Buy Luck Multiplier only when affordable.",
                            Default     = false,
                            Changed     = function(value) Controller.SetAutoLuck(value) end,
                        },
                        {
                            Type        = "Switch",
                            Id          = "AutoValue",
                            Title       = "Auto Value Upgrade",
                            Description = "Buy Value Multiplier only when affordable.",
                            Default     = false,
                            Changed     = function(value) Controller.SetAutoValue(value) end,
                        },
                        {
                            Type        = "Action",
                            Id          = "LuckOnce",
                            Title       = "Luck +1",
                            Description = "Request one affordable Luck Multiplier upgrade.",
                            ButtonText  = "+1",
                            Callback    = function() Controller.UpgradeOnce("Luck Multiplier") end,
                        },
                        {
                            Type        = "Action",
                            Id          = "ValueOnce",
                            Title       = "Value +1",
                            Description = "Request one affordable Value Multiplier upgrade.",
                            ButtonText  = "+1",
                            Callback    = function() Controller.UpgradeOnce("Value Multiplier") end,
                        },
                    },
                },
            },
        },

        ----------------------------------------------------------------
        -- EXTRAS (new page — gamepass injection + luck inject)
        ----------------------------------------------------------------
        {
            Id          = "Extras",
            Title       = "Extras",
            Icon        = "star",
            Description = "Attribute-based gamepass injection and luck override.",
            Features = {
                {
                    Id          = "Gamepasses",
                    Title       = "Gamepass Injection",
                    Description = "Sets all gamepass attribute flags on the local player. Server does not reset these. Re-applied every 5 seconds.",
                    Accent      = "cyan",
                    Controls = {
                        {
                            Type        = "Switch",
                            Id          = "AllGamepasses",
                            Title       = "All Gamepasses",
                            Description = "Injects VIP, MoreLuck, InsaneLuck, DoubleCash, DoubleThrow, BetterPlacement, DynamicCoin, DragonBooth, MutationSkips=999, ThrowSpeedLevel=10.",
                            Default     = false,
                            Changed     = function(value) Controller.SetAllGamepasses(value) end,
                        },
                        {
                            Type        = "Action",
                            Id          = "ApplyOnce",
                            Title       = "Apply Once",
                            Description = "Immediately inject all gamepass attributes once without enabling the continuous re-apply.",
                            ButtonText  = "APPLY",
                            Callback    = function() applyAllGamepasses() end,
                        },
                    },
                },
                {
                    Id          = "LuckInject",
                    Title       = "Luck Inject",
                    Description = "Sets DesiredLuck=999999 on the local player. Sent as arg5 in CoinLanded. Re-applied every 5 seconds.",
                    Accent      = "mint",
                    Controls = {
                        {
                            Type        = "Switch",
                            Id          = "LuckInject",
                            Title       = "Luck Inject",
                            Description = "Keep DesiredLuck at 999999 for every throw.",
                            Default     = false,
                            Changed     = function(value) Controller.SetLuckInject(value) end,
                        },
                        {
                            Type        = "Action",
                            Id          = "LuckInjectOnce",
                            Title       = "Apply Once",
                            Description = "Set DesiredLuck=999999 immediately once.",
                            ButtonText  = "APPLY",
                            Callback    = function() applyLuckInject() end,
                        },
                    },
                },
            },
        },

        ----------------------------------------------------------------
        -- SETTINGS
        ----------------------------------------------------------------
        {
            Id          = "Settings",
            Title       = "Settings",
            Icon        = "settings",
            Description = "Runtime and configuration.",
            Features = {
                {
                    Id          = "Runtime",
                    Title       = "Runtime",
                    Description = "Stop active Throw a Coin automation.",
                    Accent      = "purple",
                    Controls = {
                        {
                            Type        = "Action",
                            Id          = "StopAll",
                            Title       = "Stop All",
                            Description = "Stop workers, clear luck inject, and remove the Serenity runtime.",
                            ButtonText  = "STOP",
                            Danger      = true,
                            Callback    = function()
                                Controller.StopAll()
                                if app then app:Destroy() end
                            end,
                        },
                        {
                            Type       = "Action",
                            Id         = "SaveConfig",
                            Title      = "Save Settings",
                            Description= "Save current Serenity settings now.",
                            CoreAction = "SaveConfig",
                            ButtonText = "SAVE",
                        },
                    },
                },
            },
        },
    },
}

----------------------------------------------------------------
-- BOOTSTRAP
----------------------------------------------------------------

local bootstrapSource = game:HttpGet(BASE .. BOOTSTRAP_PATH .. "?throwcoin=" .. tostring(os.time()))
local bootstrapChunk, bootstrapError = loadstring(bootstrapSource, "@Serenity/ThrowACoin/Bootstrap")
bootstrapSource = nil

if not bootstrapChunk then
    error("[SERENITY HUB] Bootstrap compile failed: " .. tostring(bootstrapError), 0)
end

local bootstrap = bootstrapChunk()

app = bootstrap(manifest, {
    RuntimeKey = manifest.RuntimeKey,
    ConfigPath = manifest.ConfigPath,
})

Controller.Runtime = app.Runtime

for _, connection in ipairs(preBootstrapConnections) do
    app.Runtime:TrackConnection(connection)
end
table.clear(preBootstrapConnections)

app.Runtime:TrackCleanup(function()
    State.Running = false
    Controller.StopAll()
end)

-- Restore saved config
Controller.SetAutoSell(app.Config:Get("Automation.Selling.AutoSell", false))
Controller.SetAutoLuck(app.Config:Get("Progression.Upgrades.AutoLuck", false))
Controller.SetAutoValue(app.Config:Get("Progression.Upgrades.AutoValue", false))
Controller.SetAutoBuyCoins(app.Config:Get("Automation.Purchasing.AutoBuyCoins", false))
Controller.SetAllGamepasses(app.Config:Get("Extras.Gamepasses.AllGamepasses", false))
Controller.SetLuckInject(app.Config:Get("Extras.LuckInject.LuckInject", false))

if app.Config:Get("Automation.Throwing.AutoThrow", false) then
    Controller.SetAutoThrow(true)
end

return app