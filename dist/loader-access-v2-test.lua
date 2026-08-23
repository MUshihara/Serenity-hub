-- SERENITY HUB // ACCESS V2 PUBLIC WRAPPER
-- Keeps the tested protected Access V2 core untouched and applies the familiar Serenity key-system skin.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local CORE_URL = "https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/dist/access-v2/core.lua"

local function findAccessGui()
    local roots = {}

    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and typeof(hui) == "Instance" then
            roots[#roots + 1] = hui
        end
    end

    roots[#roots + 1] = CoreGui

    local player = Players.LocalPlayer
    if player then
        local pg = player:FindFirstChildOfClass("PlayerGui")
        if pg then
            roots[#roots + 1] = pg
        end
    end

    for _, root in ipairs(roots) do
        local gui = root:FindFirstChild("SerenityAccessV2", true)
        if gui and gui:IsA("ScreenGui") then
            return gui
        end
    end
end

local function findMain(gui)
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("Frame") then
            local box = obj:FindFirstChildWhichIsA("TextBox", true)
            local button = obj:FindFirstChildWhichIsA("TextButton", true)
            if box and button then
                return obj
            end
        end
    end
end

local function strokeOf(obj)
    if not obj then return nil end
    return obj:FindFirstChildOfClass("UIStroke")
end

local function cornerOf(obj)
    if not obj then return nil end
    return obj:FindFirstChildOfClass("UICorner")
end

local function applySerenitySkin(gui)
    local main = findMain(gui)
    if not main then return false end
    if main:GetAttribute("SerenityMainSkinV2") then return true end
    main:SetAttribute("SerenityMainSkinV2", true)

    local bg = Color3.fromRGB(11, 15, 19)
    local panel = Color3.fromRGB(16, 21, 27)
    local control = Color3.fromRGB(23, 30, 38)
    local border = Color3.fromRGB(48, 61, 72)
    local text = Color3.fromRGB(238, 244, 247)
    local muted = Color3.fromRGB(143, 158, 168)
    local cyan = Color3.fromRGB(75, 219, 235)
    local mint = Color3.fromRGB(83, 231, 184)
    local lavender = Color3.fromRGB(177, 148, 255)

    main.BackgroundColor3 = bg
    main.BackgroundTransparency = 0.08

    local mainStroke = strokeOf(main)
    if mainStroke then
        mainStroke.Color = border
        mainStroke.Transparency = 0.18
        mainStroke.Thickness = 1
    end

    local mainCorner = cornerOf(main)
    if mainCorner then
        mainCorner.CornerRadius = UDim.new(0, 12)
    end

    for _, obj in ipairs(main:GetDescendants()) do
        if obj:IsA("TextLabel") then
            obj.Font = Enum.Font.GothamMedium
            obj.TextColor3 = muted

            local upper = string.upper(obj.Text or "")
            if upper == "SERENITY ACCESS" or upper == "SERENITY HUB" then
                obj.Text = "SERENITY HUB"
                obj.Font = Enum.Font.GothamBold
                obj.TextColor3 = text
            elseif string.find(upper, "ONE%-TIME VERIFICATION") or string.find(upper, "LIFETIME ACCESS") then
                if string.find(upper, "•") or string.find(upper, "KEY SYSTEM") then
                    obj.Text = "KEY SYSTEM • LIFETIME ACCESS"
                    obj.TextColor3 = cyan
                    obj.Font = Enum.Font.GothamMedium
                else
                    obj.Text = "Don't worry — you only get the key once.\nOnce verified, your Serenity access is lifetime!"
                    obj.TextColor3 = muted
                end
            elseif string.find(upper, "DON'T WORRY") or string.find(upper, "YOU ONLY GET THE KEY ONCE") then
                obj.Text = "Don't worry — you only get the key once.\nOnce verified, your Serenity access is lifetime!"
                obj.TextColor3 = muted
            elseif string.find(upper, "CHOOSE A KEY PROVIDER") then
                obj.TextColor3 = muted
            end
        elseif obj:IsA("TextBox") then
            obj.Font = Enum.Font.GothamMedium
            obj.BackgroundColor3 = control
            obj.BackgroundTransparency = 0.08
            obj.TextColor3 = text
            obj.PlaceholderColor3 = Color3.fromRGB(105, 119, 130)
            obj.PlaceholderText = "Enter Serenity key"

            local s = strokeOf(obj)
            if s then
                s.Color = border
                s.Transparency = 0.2
            end
        elseif obj:IsA("TextButton") then
            obj.Font = Enum.Font.GothamBold
            local upper = string.upper(obj.Text or "")

            if upper == "LINKVERTISE" then
                obj.BackgroundColor3 = panel
                obj.TextColor3 = cyan
            elseif upper == "LOOTLABS" then
                obj.BackgroundColor3 = panel
                obj.TextColor3 = mint
            elseif upper == "DISCORD" then
                obj.BackgroundColor3 = panel
                obj.TextColor3 = lavender
            elseif upper == "VERIFY & UNLOCK" or upper == "UNLOCK SERENITY" or upper == "VERIFYING..." or upper == "ACCESS VERIFIED" then
                if upper == "VERIFY & UNLOCK" then
                    obj.Text = "UNLOCK SERENITY"
                end
                obj.BackgroundColor3 = mint
                obj.TextColor3 = Color3.fromRGB(8, 22, 19)

                if not obj:GetAttribute("SerenityVerifySkinV2") then
                    obj:SetAttribute("SerenityVerifySkinV2", true)
                    obj:GetPropertyChangedSignal("Text"):Connect(function()
                        if obj.Parent and obj.Text == "VERIFY & UNLOCK" then
                            obj.Text = "UNLOCK SERENITY"
                        end
                    end)
                end
            else
                obj.BackgroundColor3 = panel
                obj.TextColor3 = text
            end

            local s = strokeOf(obj)
            if s then
                s.Color = border
                s.Transparency = 0.22
            end
        elseif obj:IsA("ImageLabel") then
            obj.BackgroundTransparency = 1
        elseif obj:IsA("Frame") and obj ~= main then
            -- Preserve the tested layout. Only neutralize existing card/control surfaces.
            local sizeY = obj.Size.Y.Offset
            if sizeY > 4 and sizeY < 120 and obj.BackgroundTransparency < 1 then
                obj.BackgroundColor3 = panel
            elseif sizeY <= 4 and obj.BackgroundTransparency < 1 then
                obj.BackgroundColor3 = cyan
            end
        end
    end

    return true
end

if not getgenv().__SERENITY_ACCESS_V2_SKIN_WATCH then
    getgenv().__SERENITY_ACCESS_V2_SKIN_WATCH = true
    task.spawn(function()
        local deadline = os.clock() + 12
        while os.clock() < deadline do
            local gui = findAccessGui()
            if gui then
                if applySerenitySkin(gui) then
                    break
                end
            end
            task.wait(0.05)
        end
        getgenv().__SERENITY_ACCESS_V2_SKIN_WATCH = nil
    end)
end

local source = game:HttpGet(
    CORE_URL .. "?accessv2=" .. tostring(os.time()),
    true
)

local chunk, compileError = loadstring(
    source,
    "@SerenityHub/AccessV2Core"
)

if not chunk then
    error(
        "[SERENITY HUB] Access V2 core load failed: " .. tostring(compileError),
        0
    )
end

return chunk()
