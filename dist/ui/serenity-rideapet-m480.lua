return function(rapManifest)
-- Serenity M4 Compact: generated from modular test source. One download; UI only.
-- Popup isolation also applies to hover events, which Roblox can deliver behind a shield.
local function serenityInputBlocked(object)
    while object do
        if object:GetAttribute("SerenityPopupBlocked") or object:GetAttribute("SerenityModalBlocked") then return true end
        object=object.Parent
    end
    return false
end
local function serenityColor(object,property,tokens,role)
    object:SetAttribute("ThemeRole_"..property,role)
    object[property]=tokens.Color[role]
end
local modules = {}
modules["src/core/Runtime.lua"] = (function()
local Runtime = {}
Runtime.__index = Runtime

function Runtime.new(key)
    local self = setmetatable({}, Runtime)
    self.Key = key
    self.Connections = {}
    self.Instances = {}
    self.Cleanup = {}
    self.Destroyed = false
    return self
end

function Runtime:TrackConnection(connection)
    table.insert(self.Connections, connection)
    return connection
end

function Runtime:TrackInstance(instance)
    table.insert(self.Instances, instance)
    return instance
end

function Runtime:TrackCleanup(callback)
    table.insert(self.Cleanup, callback)
end

function Runtime:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true

    for _, callback in ipairs(self.Cleanup) do
        pcall(callback)
    end

    for _, connection in ipairs(self.Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    for _, instance in ipairs(self.Instances) do
        pcall(function()
            instance:Destroy()
        end)
    end
end

return Runtime

end)()
modules["src/core/Tokens.lua"] = (function()
local Tokens = {}

-- Serenity M3: compact 1.4:1 desktop canvas inspired by professional utility panels.
Tokens.Size = {
    Window = Vector2.new(798, 546),
    Topbar = 56,
    Sidebar = 200,
    SidebarBrand = 66,
    SidebarUser = 64,
    SidebarCollapsed = 62,
    Footer = 0,

    NavGroup = 24,
    NavRow = 36,
    NavIcon = 22,
    GameContext = 64,
    MetricPill = 26,
    SegmentTabs = 34,
    InfoBanner = 62,

    SectionLabel = 36,
    SectionHeader = 50,
    Control = 40,
    ControlWithDescription = 56,
    Button = 46,
    Slider = 55,
    Select = 54,
    Status = 46,

    RadiusShell = 14,
    RadiusPanel = 10,
    RadiusSection = 10,
    RadiusControl = 7,
    RadiusPopup = 9,
    RadiusNav = 7,
    RadiusTile = 7,
}

Tokens.Type = {
    Brand = 15,
    BrandSub = 9,
    TopSelect = 13,
    Page = 17,
    PageSub = 9,
    NavGroup = 9,
    Nav = 13,
    Section = 10,
    Control = 14,
    Description = 9,
    Value = 12,
    Status = 9,
    User = 12,
    UserSub = 9,
    Metric = 9,
    BannerTitle = 11,
    BannerBody = 9,
}

Tokens.Space = {
    XXS = 3,
    XS = 5,
    S = 7,
    M = 10,
    L = 14,
    XL = 18,
}

Tokens.Color = {
    Shell = Color3.fromRGB(16, 18, 25),
    ShellDeep = Color3.fromRGB(12, 14, 20),
    ShellSoft = Color3.fromRGB(17, 19, 27),
    Sidebar = Color3.fromRGB(18, 21, 29),
    Topbar = Color3.fromRGB(16, 18, 25),

    Panel = Color3.fromRGB(23, 26, 35),
    PanelSoft = Color3.fromRGB(32, 37, 50),
    Surface = Color3.fromRGB(14, 16, 26),
    SurfaceSoft = Color3.fromRGB(17, 20, 31),
    Control = Color3.fromRGB(17, 20, 31),
    ControlHover = Color3.fromRGB(23, 27, 40),
    RowHover = Color3.fromRGB(23, 27, 40),
    Inset = Color3.fromRGB(31, 35, 47),
    InsetHover = Color3.fromRGB(24, 28, 42),
    Popup = Color3.fromRGB(13, 15, 25),

    NavActive = Color3.fromRGB(33, 38, 51),
    NavHover = Color3.fromRGB(20, 22, 33),

    Text = Color3.fromRGB(228, 231, 240),
    TextMuted = Color3.fromRGB(171, 177, 191),
    TextDim = Color3.fromRGB(161, 173, 192),

    Divider = Color3.fromRGB(38, 41, 54),
    Stroke = Color3.fromRGB(49, 55, 70),
    StrokeBright = Color3.fromRGB(112, 121, 146),

    Accent = Color3.fromRGB(72, 130, 255),
    AccentBright = Color3.fromRGB(97, 151, 255),
    Blue = Color3.fromRGB(72, 130, 255),
    Cyan = Color3.fromRGB(73, 216, 239),
    Mint = Color3.fromRGB(82, 224, 177),
    Lavender = Color3.fromRGB(173, 126, 255),
    Pink = Color3.fromRGB(241, 79, 170),
    Amber = Color3.fromRGB(242, 185, 77),
    Red = Color3.fromRGB(239, 91, 116),
    Disabled = Color3.fromRGB(66, 70, 82),
}

Tokens.Material = {
    ShellTransparency = 0.04,
    SidebarTransparency = 0.06,
    TopbarTransparency = 0.08,
    PanelTransparency = 0.06,
    SectionTransparency = 0.12,
    ControlTransparency = 1,
    PopupTransparency = 0.04,
    ShadowTransparency = 0.46,
    EdgeTransparency = 0.78,
    HighlightTransparency = 0.92,
}

Tokens.Motion = {
    Hover = 0.10,
    Toggle = 0.13,
    Popup = 0.16,
    Page = 0.12,
    Collapse = 0.14,
    Nav = 0.11,
}

return Tokens

end)()
modules["src/core/Typography.lua"] = (function()
local Typography = {}

Typography.Font = {
    Regular = Enum.Font.Gotham,
    Medium = Enum.Font.GothamMedium,
    Semibold = Enum.Font.GothamMedium,
    Bold = Enum.Font.GothamBold,
}

local function specFor(role, tokens)
    local sizes = tokens.Type
    local map = {
        Brand = {sizes.Brand, Typography.Font.Bold},
        BrandSub = {sizes.BrandSub, Typography.Font.Medium},
        TopSelect = {sizes.TopSelect, Typography.Font.Medium},
        Page = {sizes.Page, Typography.Font.Bold},
        PageSub = {sizes.PageSub, Typography.Font.Regular},
        NavGroup = {sizes.NavGroup, Typography.Font.Semibold},
        Nav = {sizes.Nav, Typography.Font.Medium},
        Section = {sizes.Section, Typography.Font.Semibold},
        Control = {sizes.Control, Typography.Font.Semibold},
        Description = {math.max(12,sizes.Description), Typography.Font.Regular},
        Value = {sizes.Value, Typography.Font.Medium},
        Status = {sizes.Status, Typography.Font.Bold},
        User = {sizes.User, Typography.Font.Semibold},
        UserSub = {sizes.UserSub, Typography.Font.Medium},
        Metric = {sizes.Metric, Typography.Font.Medium},
        BannerTitle = {sizes.BannerTitle, Typography.Font.Semibold},
        BannerBody = {sizes.BannerBody, Typography.Font.Regular},
    }
    return map[role] or map.Control
end

function Typography.Apply(label, role, tokens, color, colorRole)
    local spec = specFor(role, tokens)
    label.TextSize = spec[1] or 12
    label.Font = spec[2] or Typography.Font.Medium
    label.TextColor3 = color or tokens.Color.Text
    if colorRole or not color then label:SetAttribute("ThemeRole_TextColor3",colorRole or "Text") end
    label.BackgroundTransparency = 1
    return label
end

function Typography.Label(parent, role, tokens, text, position, size, color, colorRole)
    local label = Instance.new("TextLabel")
    label.Text = text or ""
    label.Position = position or UDim2.new()
    label.Size = size or UDim2.fromScale(1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = parent
    Typography.Apply(label, role, tokens, color, colorRole)
    return label
end

return Typography

end)()
modules["src/core/Motion.lua"] = (function()
local TweenService = game:GetService("TweenService")

local Motion = {
    Reduced = false,
    Durations = {
        Hover = 0.11,
        Toggle = 0.14,
        Select = 0.16,
        Popup = 0.18,
        Collapse = 0.18,
        Modal = 0.20,
    }
}

function Motion:Tween(instance, durationKey, props, style, direction)
    local duration = self.Reduced and 0 or (self.Durations[durationKey] or durationKey or 0.15)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

return Motion

end)()
modules["src/core/Material.lua"] = (function()
local Material = {}

local SHADOW_IMAGE = "rbxassetid://1316045217"

local function corner(parent, radius, name)
    local c = Instance.new("UICorner")
    c.Name = name or "Corner"
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function stroke(parent, color, transparency, thickness, name)
    local s = Instance.new("UIStroke")
    s.Name = name or "Stroke"
    s.Color = color
    s.Transparency = transparency
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function Material.Shadow(parent, targetSize, radius, tokens)
    -- No external shadow layer: avoids the oversized black backing on desktop.
    return nil
end

function Material.Shell(frame, tokens)
    frame:SetAttribute("GlassRole", "Shell")
    serenityColor(frame,"BackgroundColor3",tokens,"Shell")
    frame.BackgroundTransparency = tokens.Material.ShellTransparency
    frame.BorderSizePixel = 0
    corner(frame, tokens.Size.RadiusShell, "ShellCorner")
    stroke(frame, tokens.Color.Stroke, tokens.Material.EdgeTransparency, 1, "ShellEdge")

    local gradient = Instance.new("UIGradient")
    gradient.Name = "ShellTone"
    gradient.Rotation = 118
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 240, 255)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 231, 250)),
    })
    gradient.Parent = frame

    local topLine = Instance.new("Frame")
    topLine.Name = "TopGlassLine"
    topLine.BackgroundColor3 = Color3.fromRGB(186, 204, 238)
    topLine.BackgroundTransparency = 0.93
    topLine.BorderSizePixel = 0
    topLine.Position = UDim2.fromOffset(14, 0)
    topLine.Size = UDim2.new(1, -28, 0, 1)
    topLine.ZIndex = frame.ZIndex + 1
    topLine.Parent = frame
    return frame
end

function Material.Sidebar(frame, tokens)
    frame:SetAttribute("GlassRole", "Sidebar")
    serenityColor(frame,"BackgroundColor3",tokens,"Sidebar")
    frame.BackgroundTransparency = tokens.Material.SidebarTransparency
    frame.BorderSizePixel = 0

    local divider = Instance.new("Frame")
    divider.Name = "SidebarDivider"
    divider.AnchorPoint = Vector2.new(1, 0)
    divider.Position = UDim2.new(1, 0, 0, 14)
    divider.Size = UDim2.new(0, 1, 1, -28)
    serenityColor(divider,"BackgroundColor3",tokens,"Divider")
    divider.BackgroundTransparency = 0.34
    divider.BorderSizePixel = 0
    divider.Parent = frame
    return frame
end

-- Shared pointer and keyboard feedback for popup choices and filtered lists.
function Material.OptionHover(button, tokens, selected, motion)
    local pointer, focused = false, false
    local baseTransparency = button.BackgroundTransparency
    local function render()
        local active = pointer or focused
        button:SetAttribute("ThemeRole_BackgroundColor3",active and "InsetHover" or (selected and "NavActive" or "PanelSoft"))
        button:SetAttribute("ThemeRole_TextColor3",active and "Text" or (selected and "Text" or "TextMuted"))
        local properties={BackgroundColor3=active and tokens.Color.InsetHover or (selected and tokens.Color.NavActive or tokens.Color.PanelSoft),BackgroundTransparency=active and 0 or baseTransparency}
        if button.Text ~= "" then properties.TextColor3=active and tokens.Color.Text or (selected and tokens.Color.Text or tokens.Color.TextMuted) end
        if motion then motion:Tween(button,"Hover",properties) else for key,value in pairs(properties) do button[key]=value end end
    end
    button.MouseEnter:Connect(function() if serenityInputBlocked(button) then return end; pointer=true;render() end)
    button.MouseLeave:Connect(function() pointer=false;render() end)
    button.SelectionGained:Connect(function() if serenityInputBlocked(button) then return end; focused=true;render() end)
    button.SelectionLost:Connect(function() focused=false;render() end)
end

function Material.Topbar(frame, tokens)
    frame:SetAttribute("GlassRole", "Topbar")
    serenityColor(frame,"BackgroundColor3",tokens,"Topbar")
    frame.BackgroundTransparency = tokens.Material.TopbarTransparency
    frame.BorderSizePixel = 0

    local divider = Instance.new("Frame")
    divider.AnchorPoint = Vector2.new(0, 1)
    divider.Position = UDim2.new(0, 12, 1, 0)
    divider.Size = UDim2.new(1, -24, 0, 1)
    serenityColor(divider,"BackgroundColor3",tokens,"Divider")
    divider.BackgroundTransparency = 0.42
    divider.BorderSizePixel = 0
    divider.Parent = frame
    return frame
end

-- Lightweight pixel brackets for surfaces without list-managed children.
function Material.PixelCorners(parent,tokens,inset)
    local root=Instance.new("Frame");root.Name="PixelCorners"
    root.BackgroundTransparency=1;root.Size=UDim2.fromScale(1,1)
    root.ZIndex=parent.ZIndex+1;root.Parent=parent
    local parts={}
    for _,right in ipairs({false,true}) do
        for _,bottom in ipairs({false,true}) do
            for _,segment in ipairs({{0,4,2,7},{2,2,2,2},{4,0,7,2}}) do
                local x,y,w,h=table.unpack(segment)
                local f=Instance.new("Frame");f.BorderSizePixel=0
                f.Size=UDim2.fromOffset(w,h)
                f.Position=UDim2.new(right and 1 or 0,right and -(inset+x+w) or inset+x,bottom and 1 or 0,bottom and -(inset+y+h) or inset+y)
                serenityColor(f,"BackgroundColor3",tokens,"Lavender");f.BackgroundTransparency=0.72
                f.ZIndex=root.ZIndex;f.Parent=root;table.insert(parts,f)
            end
        end
    end
    return root,parts
end

-- Five non-overlapping strips form a genuine stepped silhouette without corner masks.
-- Only use on fixed control surfaces, never on containers managed by UIListLayout.
function Material.PixelSurface(frame,step)
    step=step or 2
    local opacity=frame.BackgroundTransparency
    frame.BackgroundTransparency=1
    for _,child in ipairs(frame:GetChildren()) do
        if child:IsA("UICorner") then child:Destroy() end
        if child:IsA("UIStroke") then child.Enabled=false end
    end
    local strips={}
    local specs={
        {step*2,0,1,-step*4,0,step},
        {step,step,1,-step*2,0,step},
        {0,step*2,1,0,1,-step*4},
        {step,-step*2,1,-step*2,0,step},
        {step*2,-step,1,-step*4,0,step},
    }
    for index,spec in ipairs(specs) do
        local strip=Instance.new("Frame");strip.Name="PixelSurfaceStrip"
        strip.BorderSizePixel=0;strip.Active=false
        strip.Position=UDim2.new(0,spec[1],index>=4 and 1 or 0,spec[2])
        strip.Size=UDim2.new(spec[3],spec[4],spec[5],spec[6])
        strip.BackgroundColor3=frame.BackgroundColor3;strip.BackgroundTransparency=opacity
        strip.ZIndex=frame.ZIndex;strip.Parent=frame;table.insert(strips,strip)
    end
    -- Propagate hover, on/off and theme colors only when they change.
    frame:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        for _,strip in ipairs(strips) do strip.BackgroundColor3=frame.BackgroundColor3 end
    end)
    frame:GetPropertyChangedSignal("ZIndex"):Connect(function()
        for _,strip in ipairs(strips) do strip.ZIndex=frame.ZIndex end
    end)
    return frame
end

function Material.Section(frame, tokens)
    frame:SetAttribute("GlassRole", "Section")
    serenityColor(frame,"BackgroundColor3",tokens,"Panel")
    frame.BackgroundTransparency = tokens.Material.PanelTransparency
    frame.BorderSizePixel = 0
    corner(frame, 3, "PanelCorner")
    stroke(frame, tokens.Color.Stroke, 0.56, 1, "PanelStroke")
    local sheen=Instance.new("UIGradient")
    sheen.Name="GlassSheen"
    sheen.Rotation=110
    sheen.Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(191,212,235))
    sheen.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.04),
        NumberSequenceKeypoint.new(0.42,0),
        NumberSequenceKeypoint.new(1,0.03)
    })
    sheen.Parent=frame
    return frame
end

function Material.Control(frame, tokens)
    serenityColor(frame,"BackgroundColor3",tokens,"PanelSoft")
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0

    local separator = frame:FindFirstChild("RowSeparator")
    if not separator then
        separator = Instance.new("Frame")
        separator.Name = "RowSeparator"
        separator.AnchorPoint = Vector2.new(0, 1)
        separator.Position = UDim2.new(0, 12, 1, 0)
        separator.Size = UDim2.new(1, -24, 0, 1)
        serenityColor(separator,"BackgroundColor3",tokens,"Divider")
        separator.BackgroundTransparency = 0.62
        separator.BorderSizePixel = 0
        separator.Parent = frame
    end
    return frame
end

function Material.Popup(frame, tokens)
    serenityColor(frame,"BackgroundColor3",tokens,"Popup")
    frame.BackgroundTransparency = 0
    frame.Active = true
    frame.BorderSizePixel = 0
    corner(frame, 3, "PopupCorner")
    stroke(frame, tokens.Color.Stroke, 0.52, 1, "PopupStroke")

    return frame
end

function Material.NavRow(frame, tokens, selected)
    serenityColor(frame,"BackgroundColor3",tokens,selected and "NavActive" or "NavHover")
    frame.BackgroundTransparency = selected and 0.04 or 1
    frame.BorderSizePixel = 0

    local c = frame:FindFirstChild("NavCorner")
    if not c then
        c = corner(frame, 4, "NavCorner")
    end
    return frame
end

function Material.NavTile(frame, tokens, color, selected)
    -- Kept for compatibility. M3 uses the icon itself as the strongest accent.
    serenityColor(frame,"BackgroundColor3",tokens,selected and "InsetHover" or "Inset")
    frame.BackgroundTransparency = selected and 0.10 or 0.38
    frame.BorderSizePixel = 0

    local c = frame:FindFirstChild("NavTileCorner")
    if not c then c = corner(frame, 6, "NavTileCorner") end
    local s = frame:FindFirstChild("NavTileStroke")
    if not s then s = stroke(frame, tokens.Color.Stroke, 0.90, 1, "NavTileStroke") end
    s.Color = selected and (color or tokens.Color.Accent) or tokens.Color.Stroke
    s.Transparency = selected and 0.78 or 0.93
    return frame
end

function Material.Inset(frame, tokens)
    serenityColor(frame,"BackgroundColor3",tokens,"Inset")
    frame.BackgroundTransparency = 0.04
    frame.BorderSizePixel = 0
    corner(frame, 2, "InsetCorner")
    stroke(frame, tokens.Color.Stroke, 0.88, 1, "InsetStroke")
    return frame
end

function Material.Pill(frame, tokens, accent)
    serenityColor(frame,"BackgroundColor3",tokens,"Inset")
    frame.BackgroundTransparency = 0.04
    frame.BorderSizePixel = 0
    corner(frame, 7, "PillCorner")
    stroke(frame, accent or tokens.Color.Stroke, accent and 0.76 or 0.90, 1, "PillStroke")
    return frame
end

function Material.Hover(frame, tokens, active)
    serenityColor(frame,"BackgroundColor3",tokens,active and "RowHover" or "PanelSoft")
    frame.BackgroundTransparency = active and 0.28 or 1
end

-- Four tapered rays drawn from Frames; independent of font glyph coverage.
-- Small vector emblems; no font glyphs or external image downloads.
function Material.Emblem(parent,position,size,color,kind)
    local root=Instance.new("Frame")
    root.Name="SerenityEmblem";root.BackgroundTransparency=1
    root.Position=position;root.Size=UDim2.fromOffset(size,size);root.Parent=parent
    local function line(x1,y1,x2,y2,width)
        local dx,dy=x2-x1,y2-y1
        local f=Instance.new("Frame");f.BorderSizePixel=0;f.BackgroundColor3=color
        f.AnchorPoint=Vector2.new(0.5,0.5);f.Position=UDim2.fromOffset((x1+x2)*size/2,(y1+y2)*size/2)
        f.Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy)*size,width or 1.5)
        f.Rotation=math.deg(math.atan2(dy,dx));f.ZIndex=2;f.Parent=root
        local c=Instance.new("UICorner");c.CornerRadius=UDim.new(1,0);c.Parent=f
    end
    if kind=="compass" then
        -- Open orbital arc around an asymmetric navigation needle.
        for i=0,13 do
            local a=math.rad(35+i*21);local b=math.rad(35+(i+1)*21)
            line(0.5+0.43*math.cos(a),0.5+0.43*math.sin(a),0.5+0.43*math.cos(b),0.5+0.43*math.sin(b),1.2)
        end
        line(0.68,0.23,0.57,0.58,1.8);line(0.57,0.58,0.29,0.74,1.8)
        line(0.29,0.74,0.41,0.39,1.8);line(0.41,0.39,0.68,0.23,1.8)
        line(0.41,0.39,0.57,0.58,1.2)
    else
        -- Two interlocking open loops: connection and community.
        for _,offset in ipairs({0,0.3}) do
            for i=0,11 do
                local a=math.rad(-50+i*25);local b=math.rad(-50+(i+1)*25)
                line(0.34+offset+0.25*math.cos(a),0.39+offset*0.5+0.25*math.sin(a),0.34+offset+0.25*math.cos(b),0.39+offset*0.5+0.25*math.sin(b),1.6)
            end
        end
        line(0.38,0.62,0.65,0.34,1.8)
    end
    return root
end

-- Compact stepped ornament; individual opaque pixels avoid overlapping bright rays.
function Material.PixelStar(parent, position, z)
    local root=Instance.new("Frame")
    root.Name="GrimoireStar";root.BackgroundTransparency=1
    root.Position=position;root.Size=UDim2.fromOffset(30,30);root.ZIndex=z or 5;root.Parent=parent
    local pattern={".......s.......",".......g.......",".......g.......","......sgs......","......gig......",".....sgigs.....","...sggiIiggs...","sgggiIIIiggggs","...sggiIiggs...",".....sgigs.....","......gig......","......sgs......",".......g.......",".......g.......",".......s......."}
    local palette={s=Color3.fromRGB(100,91,70),g=Color3.fromRGB(166,145,103),i=Color3.fromRGB(197,181,143),I=Color3.fromRGB(216,204,174)}
    for y,row in ipairs(pattern) do
        for x=1,#row do
            local tone=row:sub(x,x)
            if palette[tone] then
                local pixel=Instance.new("Frame");pixel.Name=tone=="I" and "StarHighlight" or "StarPixel"
                pixel.BorderSizePixel=0;pixel.Size=UDim2.fromOffset(2,2)
                pixel.Position=UDim2.fromOffset((x-1)*2,(y-1)*2)
                pixel.BackgroundColor3=palette[tone];pixel:SetAttribute("FixedPresetColor",true)
                pixel.ZIndex=root.ZIndex;pixel.Parent=root
            end
        end
    end
    return root
end

function Material.Star(parent, position, size, color, z)
    local root=Instance.new("Frame")
    root.Name="SerenityStar"
    root.BackgroundTransparency=1
    root.Position=position
    root.Size=UDim2.fromOffset(size,size)
    root.ZIndex=z or 2
    root.Parent=parent
    for i=0,11 do
        local distance=i/11
        local thickness=math.max(1, math.floor(size*0.32*(1-distance)^2))
        for _,axis in ipairs({0,1}) do
            for _,sign in ipairs({-1,1}) do
                local ray=Instance.new("Frame")
                ray.BorderSizePixel=0
                ray.BackgroundColor3=color
                ray.AnchorPoint=Vector2.new(0.5,0.5)
                ray.Size=UDim2.fromOffset(axis==0 and thickness or math.max(1,size/24),axis==0 and math.max(1,size/24) or thickness)
                ray.Position=UDim2.fromOffset(size/2+(axis==1 and sign*distance*size*0.46 or 0),size/2+(axis==0 and sign*distance*size*0.46 or 0))
                ray.ZIndex=root.ZIndex
                ray.Parent=root
            end
        end
    end
    return root
end
return Material

end)()
modules["src/core/AcrylicEngine.lua"] = (function()
local Lighting = game:GetService("Lighting")

local AcrylicEngine = {}
AcrylicEngine.__index = AcrylicEngine

function AcrylicEngine.new(runtime, options)
    options = options or {}

    local self = setmetatable({}, AcrylicEngine)
    self.Quality = "Basic"
    self.Visible = true
    self.Amount = options.BasicBlur or 3

    self.Blur = runtime:TrackInstance(Instance.new("BlurEffect"))
    self.Blur.Name = "SerenityAcrylicBlur"
    self.Blur.Size = options.BasicBlur or 3
    self.Blur.Enabled = true
    self.Blur.Parent = Lighting

    self.Depth = runtime:TrackInstance(Instance.new("DepthOfFieldEffect"))
    self.Depth.Name = "SerenityAcrylicDepth"
    self.Depth.Enabled = false
    self.Depth.FocusDistance = 35
    self.Depth.InFocusRadius = 28
    self.Depth.NearIntensity = 0.04
    self.Depth.FarIntensity = 0.08
    self.Depth.Parent = Lighting

    return self
end

function AcrylicEngine:SetQuality(quality)
    quality = quality or "Basic"
    self.Quality = quality

    if not self.Visible or quality == "Off" then
        self.Blur.Enabled = false
        self.Depth.Enabled = false
    elseif quality == "Enhanced" then
        self.Blur.Enabled = true
        self.Blur.Size = self.Amount
        self.Depth.Enabled = true
    else
        self.Blur.Enabled = true
        self.Blur.Size = self.Amount
        self.Depth.Enabled = false
        self.Quality = "Basic"
    end
end

function AcrylicEngine:SetVisible(visible)
    self.Visible = visible
    self:SetQuality(self.Quality)
end

function AcrylicEngine:SetAmount(value)
    self.Amount = math.clamp(value, 0, 8)
    self.Blur.Size = self.Amount
end

function AcrylicEngine:SetEnabled(enabled)
    self:SetQuality(enabled and "Basic" or "Off")
end

return AcrylicEngine

end)()
modules["src/core/Icons.lua"] = (function()
local Icons = {}

Icons.Map = {
    home = "rbxassetid://98755624629571",
    dashboard = "rbxassetid://98755624629571",
    about = "rbxassetid://124560466474914",
    info = "rbxassetid://124560466474914",
    automation = "rbxassetid://80451686744860",
    progression = "rbxassetid://81819858538839",
    shops = "rbxassetid://90338129673705",
    shop = "rbxassetid://90338129673705",
    configs = "rbxassetid://126791525623846",
    misc = "rbxassetid://126791525623846",
    settings = "rbxassetid://80758916183665",
    search = "rbxassetid://121018724060431",
    activity = "rbxassetid://94212016861936",
    webhook = "rbxassetid://94212016861936",
    roll = "rbxassetid://81268120302865",
    target = "rbxassetid://87563802520297",
    inventory = "rbxassetid://140420225386018",
    pets = "rbxassetid://112218825427601",
    world = "rbxassetid://95107167260947",
    server = "rbxassetid://95107167260947",
    store = "rbxassetid://90338129673705",
    shield = "rbxassetid://87354736164608",
    lock = "rbxassetid://134724289526879",
    warning = "rbxassetid://125920361880643",
    check = "rbxassetid://93898873302694",
    chevron_right = "rbxassetid://92473583511724",
    chevron_down = "rbxassetid://134243273101015",
    plus = "rbxassetid://111774323017047",
    minus = "rbxassetid://118026365011536",
    close = "rbxassetid://110786993356448",
    save = "rbxassetid://126116963775616",
}

function Icons.Get(name)
    return Icons.Map[name] or Icons.Map.info
end

local discordBytes = "\137\080\078\071\013\010\026\010\000\000\000\013\073\072\068\082\000\000\000\096\000\000\000\096\008\006\000\000\000\226\152\119\056\000\000\000\006\098\075\071\068\000\255\000\255\000\255\160\189\167\147\000\000\007\135\073\068\065\084\120\156\237\157\107\172\093\069\025\134\159\217\080\045\160\080\048\020\106\075\079\041\002\210\082\169\128\182\133\054\165\085\049\018\021\047\137\049\214\107\172\070\052\193\018\073\212\038\218\024\196\250\195\160\008\018\019\012\074\240\022\139\134\168\137\183\018\091\032\177\252\192\210\096\065\173\008\216\026\133\010\148\182\156\222\207\227\143\057\109\119\247\125\239\181\102\239\150\051\079\114\126\156\189\215\204\251\173\111\246\204\172\053\235\155\111\065\038\147\201\100\050\153\076\038\147\201\100\050\153\076\223\008\131\020\087\039\000\151\000\179\129\103\066\008\119\245\073\247\099\192\105\192\122\224\161\016\194\011\253\208\029\056\234\084\245\163\234\247\213\191\170\035\030\102\088\157\210\007\027\166\169\187\171\116\071\212\071\213\239\169\031\086\039\167\182\161\111\168\199\171\139\213\155\212\199\108\207\119\251\096\211\237\029\216\177\081\253\134\186\080\061\046\181\077\165\162\030\167\094\169\222\161\062\219\193\201\086\179\071\157\154\208\182\169\163\026\221\176\213\216\104\139\213\074\217\054\149\054\007\168\231\003\031\007\062\004\156\089\160\170\155\067\008\203\026\212\127\042\113\220\158\000\188\012\056\169\230\144\157\192\094\224\121\224\217\016\194\246\006\117\220\004\092\087\192\182\127\003\119\002\119\132\016\030\047\080\207\033\010\053\192\104\247\188\026\248\012\176\168\104\125\163\236\000\110\006\206\001\134\070\255\038\002\227\186\172\103\047\240\052\240\047\224\041\224\113\224\179\192\201\037\216\040\176\026\184\021\248\117\008\097\164\215\138\122\118\152\122\021\112\011\048\189\215\058\094\034\252\003\184\038\132\176\186\151\194\061\053\128\058\009\216\008\156\218\075\249\151\032\207\000\051\067\008\255\235\182\096\175\147\202\173\100\231\087\051\017\248\118\047\005\187\238\001\234\213\192\061\189\136\141\001\174\010\033\252\166\155\002\093\053\128\122\034\240\040\113\098\204\212\243\004\113\040\218\213\105\129\110\135\160\047\146\157\223\138\179\137\062\234\152\142\123\128\058\013\120\012\024\223\157\077\099\142\221\192\140\016\194\019\157\028\220\077\015\088\073\118\126\039\140\007\190\222\233\193\029\245\000\245\141\192\186\078\143\207\032\048\047\132\240\096\187\003\059\237\001\095\035\059\191\027\002\113\196\104\075\219\006\080\175\000\222\084\208\160\177\200\034\181\173\223\218\254\170\213\053\192\194\050\044\026\131\060\016\066\088\208\234\128\150\061\064\093\064\118\126\017\230\171\045\253\215\110\008\250\124\137\198\140\085\090\250\176\233\016\164\190\150\120\215\155\039\223\098\008\204\010\033\108\108\244\101\171\030\176\140\236\252\050\008\192\181\173\190\172\195\024\173\176\133\250\167\078\153\222\024\006\038\135\016\182\213\126\209\172\007\044\033\059\191\076\078\036\062\170\173\163\089\015\088\079\140\213\201\148\199\134\016\066\157\079\235\122\128\058\155\236\252\020\092\164\190\190\246\195\070\067\208\007\251\096\204\088\101\073\237\007\071\012\065\106\000\158\004\146\197\230\140\113\054\003\067\033\004\015\126\080\219\003\230\144\157\159\146\179\128\185\213\031\212\054\192\187\251\103\203\152\229\093\213\255\212\054\192\219\251\104\200\088\229\008\031\031\106\000\117\008\152\209\007\003\030\001\062\069\012\232\170\132\016\002\048\153\056\065\221\215\007\253\063\001\031\001\166\134\081\128\105\192\082\224\207\125\208\159\049\250\120\247\072\212\165\093\006\173\118\203\030\245\218\118\001\174\234\123\212\231\018\232\111\087\091\094\225\169\193\232\135\023\019\232\087\243\137\070\226\063\074\040\184\071\189\178\211\159\136\058\067\125\186\068\253\023\212\075\187\208\191\076\221\081\162\126\045\063\110\036\186\057\161\224\039\059\061\249\042\123\022\168\251\075\208\030\081\187\158\219\212\247\150\160\221\140\045\181\098\211\018\138\173\237\246\228\171\236\186\173\004\253\159\020\208\191\167\004\253\102\012\193\225\073\120\110\011\059\138\242\213\002\101\087\002\251\007\168\127\067\065\237\086\204\129\195\013\112\073\034\145\255\000\247\246\090\056\132\176\025\232\185\007\001\235\155\061\008\233\080\255\033\098\048\090\010\046\133\195\013\080\183\072\084\018\247\021\217\188\112\176\142\002\101\215\020\212\046\170\223\138\217\112\184\001\046\076\036\242\183\018\234\216\116\012\235\183\226\066\128\138\250\042\224\140\068\034\117\251\180\122\096\231\128\245\119\148\080\071\035\038\169\019\042\192\185\137\004\160\156\088\210\034\117\148\161\127\066\009\117\052\227\220\010\113\051\092\042\166\149\080\199\217\199\176\126\059\206\169\144\054\222\255\178\001\215\081\134\254\188\018\234\104\198\080\133\184\016\150\138\025\234\204\094\011\171\039\003\111\046\160\191\080\157\088\064\127\136\209\203\197\068\076\169\000\147\018\010\000\092\095\160\236\053\020\139\206\024\071\220\027\220\043\215\209\251\070\198\078\056\019\245\254\132\183\219\170\007\212\249\221\090\166\014\025\023\209\138\178\203\024\229\215\173\254\044\187\079\107\208\045\107\042\164\223\110\090\001\126\106\023\057\032\212\087\002\119\083\206\174\246\241\192\047\140\151\219\157\234\159\014\172\034\166\068\072\201\105\021\098\238\133\212\076\006\238\087\047\110\119\160\122\022\113\249\162\204\177\247\002\096\173\218\246\146\219\152\243\098\045\112\126\137\250\205\056\165\066\255\034\224\166\002\235\212\111\169\117\233\013\212\137\234\114\224\047\192\027\018\232\207\004\030\086\111\080\095\221\064\127\138\122\035\049\137\211\005\009\244\027\241\138\160\238\006\094\222\039\193\106\254\078\188\205\063\064\188\094\159\009\244\043\055\207\008\113\145\237\159\196\208\156\233\068\167\247\059\024\121\056\168\035\003\016\206\068\246\087\200\206\031\036\149\148\215\184\153\014\168\016\199\224\204\096\216\087\033\102\150\202\012\134\189\021\098\110\131\204\096\024\174\144\238\129\067\166\061\059\043\064\221\190\165\076\223\216\086\001\158\075\040\240\036\176\039\097\253\169\217\069\204\186\152\138\231\043\192\214\068\149\223\069\188\187\029\002\086\016\115\110\030\043\060\005\044\039\198\243\207\002\126\158\072\103\043\234\007\060\050\151\114\025\236\181\038\022\212\152\198\248\029\234\221\198\037\226\163\141\093\234\207\212\183\089\147\174\088\125\167\071\230\185\046\075\239\125\007\005\102\027\243\037\151\205\239\108\016\020\171\158\162\046\081\087\169\219\018\232\118\202\054\163\211\151\024\159\190\213\218\057\079\253\099\002\221\013\234\172\090\177\241\198\132\213\101\004\196\086\051\162\254\074\189\188\081\031\052\246\140\249\234\151\213\223\155\182\065\182\171\171\213\021\198\224\223\134\217\120\213\069\234\111\019\232\239\083\087\170\135\022\063\235\214\129\212\185\192\237\164\009\214\122\016\248\014\176\042\132\208\240\254\195\184\081\240\053\192\069\196\021\202\243\136\171\165\083\136\241\075\237\194\068\118\019\019\169\110\038\094\004\108\034\174\124\110\000\054\053\139\212\083\079\002\222\015\124\026\104\251\220\162\007\030\006\150\142\134\059\182\070\029\167\126\065\221\153\224\087\160\250\195\094\207\066\061\193\248\236\096\122\205\223\025\198\180\154\189\214\251\203\068\231\186\093\253\156\122\124\047\070\077\049\110\220\040\115\002\026\177\139\205\018\253\194\248\174\128\050\057\160\254\192\152\230\185\176\113\115\212\053\037\025\086\191\059\228\040\193\242\122\193\031\212\242\035\206\213\183\170\235\010\024\246\162\241\153\239\081\137\122\158\197\034\033\030\080\023\247\195\208\183\168\247\246\096\224\242\228\198\021\068\189\177\203\115\026\049\094\049\045\026\132\177\023\171\119\218\217\141\220\035\106\234\048\143\194\024\039\249\077\029\156\207\176\241\213\038\175\027\180\205\168\167\171\215\219\252\069\061\251\060\010\039\222\102\024\039\228\003\045\126\072\203\140\175\084\057\250\080\231\170\183\168\255\173\050\250\043\131\182\171\091\212\111\086\217\191\197\248\038\168\020\247\007\105\048\190\077\233\010\245\075\246\114\013\060\096\140\043\003\043\212\203\077\240\246\164\076\038\147\201\100\050\153\076\038\147\201\100\050\153\001\240\127\198\110\234\048\180\057\119\096\000\000\000\000\073\069\078\068\174\066\096\130" -- Simple Icons, CC0; same compact mark as existing Serenity library.
local discordUri
local function loadDiscord(image)
    local environment=type(getgenv)=="function" and getgenv() or _G
    local custom=environment.getcustomasset or getcustomasset or environment.getsynasset or getsynasset
    local write=environment.writefile or writefile
    local exists=environment.isfile or isfile
    if type(custom)~="function" or type(write)~="function" then return end
    task.spawn(function()
        local ok,uri=pcall(function()
            if discordUri then return discordUri end
            local path="Serenity_Discord_Mark_v1.png"
            if type(exists)~="function" or not exists(path) then write(path,discordBytes) end
            return custom(path)
        end)
        if ok and type(uri)=="string" and image.Parent then
            discordUri=uri;image.Image=uri;image.ImageColor3=Color3.new(1,1,1)
        end
    end)
end

function Icons.Create(parent, name, size, color, position)
    local image = Instance.new("ImageLabel")
    image.Name = "Icon_" .. tostring(name)
    image.BackgroundTransparency = 1
    image.Image = name=="discord" and "" or Icons.Get(name)
    image.ImageColor3 = color or Color3.new(1, 1, 1)
    image.ScaleType = Enum.ScaleType.Fit
    image.Size = UDim2.fromOffset(size or 18, size or 18)
    if position then image.Position = position end
    image.Parent = parent
    if name=="discord" then loadDiscord(image) end
    return image
end

return Icons

end)()
modules["src/core/PopupManager.lua"] = (function()
local PopupManager = {}
PopupManager.__index = PopupManager

function PopupManager.new()
    return setmetatable({
        Active = nil,
    }, PopupManager)
end

function PopupManager:Close()
    if self.Active then
        pcall(function()
            self.Active:Destroy()
        end)
        self.Active = nil
    end
    if self.OnChange then self.OnChange(nil) end
end

function PopupManager:Set(frame)
    self:Close()
    self.Active = frame
    frame.Active=true
    if self.OnChange then self.OnChange(frame) end
    return frame
end

return PopupManager

end)()
modules["src/components/NavItem.lua"] = (function()
local NavItem = {}
NavItem.__index = NavItem

function NavItem.new(parent, deps, props)
    local tokens = deps.Tokens
    props = props or {}

    local row = Instance.new("TextButton")
    row.Name = props.Id or props.Title or "NavItem"
    row.Size = UDim2.new(1, 0, 0, tokens.Size.NavRow)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.LayoutOrder = props.Order or 1
    row.Parent = parent
    deps.Material.NavRow(row, tokens, false)

    local tile=Instance.new("Frame")
    tile.Name="NavGlassTile";tile.Size=UDim2.fromOffset(28,28)
    tile.AnchorPoint=Vector2.new(0.5,0.5);tile.Position=UDim2.new(0,22,0.5,0)
    serenityColor(tile,"BackgroundColor3",tokens,"PanelSoft");tile.BackgroundTransparency=1
    tile.BorderSizePixel=0;tile.Parent=row
    local rounding=Instance.new("UICorner");rounding.CornerRadius=UDim.new(0,8);rounding.Parent=tile
    local rim=Instance.new("UIStroke");rim.Name="NavGlassEdge";rim.Color=Color3.new(1,1,1)
    rim.Transparency=0.72;rim.Thickness=1;rim.Parent=tile;rim.Enabled=false
    local spectrum=Instance.new("UIGradient");spectrum.Rotation=35
    spectrum.Color=ColorSequence.new(Color3.fromRGB(135,217,255),Color3.fromRGB(222,175,243));spectrum.Parent=rim
    local shine=Instance.new("UIGradient");shine.Rotation=115
    shine.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(139,167,204));shine.Parent=tile
    local scale=Instance.new("UIScale");scale.Parent=tile
    local marker=Instance.new("Frame");marker.Name="SelectionMarker";marker.BorderSizePixel=0
    marker.Size=UDim2.fromOffset(2,10);marker.Position=UDim2.new(0,3,0.5,-5)
    serenityColor(marker,"BackgroundColor3",tokens,"Accent");marker.BackgroundTransparency=1;marker.Parent=row;marker.Visible=true
    local markerTip=Instance.new("Frame");markerTip.Name="PixelTip"
    markerTip.Size=UDim2.fromOffset(2,4);markerTip.Position=UDim2.fromOffset(2,3)
    markerTip.BorderSizePixel=0;serenityColor(markerTip,"BackgroundColor3",tokens,"Accent")
    markerTip.BackgroundTransparency=1;markerTip.Parent=marker
    local icon = deps.Icons.Create(tile, props.Icon or "info", tokens.Size.NavIcon-2, tokens.Color.TextMuted)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.Position = UDim2.fromScale(0.5,0.5)

    local label = deps.Typography.Label(
        row,
        "Nav",
        tokens,
        props.Title or "Page",
        UDim2.fromOffset(44, 0),
        UDim2.new(1, -52, 1, 0),
        tokens.Color.TextMuted
    ,"TextMuted")

    local self = setmetatable({
        Row = row,
        Icon = icon,
        Label = label,
        Tile=tile, Rim=rim, Marker=marker, MarkerTip=markerTip, Scale=scale,
        Accent = props.Accent or tokens.Color.Accent,
        Selected = false,
        Callback = props.Callback,
        Deps = deps,
    }, NavItem)

    row.MouseEnter:Connect(function() if serenityInputBlocked(row) then return end;
        deps.Motion:Tween(tile,"Hover",{BackgroundTransparency=1})
        deps.Motion:Tween(rim,"Hover",{Transparency=0.25})
        deps.Motion:Tween(label,"Hover",{Position=UDim2.fromOffset(deps.Motion.Reduced and 44 or 46,0)})
        if not self.Selected then
            serenityColor(row,"BackgroundColor3",tokens,"NavHover")
            deps.Motion:Tween(row, "Hover", {BackgroundTransparency = 0.34})
            serenityColor(label,"TextColor3",tokens,"Text")
            serenityColor(icon,"ImageColor3",tokens,"Text")
        end
    end)

    row.MouseLeave:Connect(function()
        deps.Motion:Tween(tile,"Hover",{BackgroundTransparency=1})
        deps.Motion:Tween(rim,"Hover",{Transparency=self.Selected and 0.3 or 0.72})
        deps.Motion:Tween(label,"Hover",{Position=UDim2.fromOffset(44,0)})
        deps.Motion:Tween(scale,"Hover",{Scale=1})
        if not self.Selected then
            deps.Motion:Tween(row, "Hover", {BackgroundTransparency = 1})
            serenityColor(label,"TextColor3",tokens,"TextMuted")
            serenityColor(icon,"ImageColor3",tokens,"TextMuted")
        end
    end)

    row.MouseButton1Down:Connect(function()
        deps.Motion:Tween(scale,0.08,{Scale=deps.Motion.Reduced and 1 or 0.9})
    end)
    row.MouseButton1Up:Connect(function()
        deps.Motion:Tween(scale,"Select",{Scale=1})
    end)
    row.Activated:Connect(function() if serenityInputBlocked(row) then return end;
        if self.Callback then self.Callback() end
        if deps.PlayUISound then deps.PlayUISound() end
    end)

    return self
end

function NavItem:SetSelected(selected)
    self.Selected = not not selected
    local tokens = self.Deps.Tokens
    serenityColor(self.Row,"BackgroundColor3",tokens,"NavActive")
    self.Deps.Motion:Tween(self.Row,"Select",{BackgroundTransparency=self.Selected and 0.18 or 1})
    serenityColor(self.Tile,"BackgroundColor3",tokens,"PanelSoft")
    serenityColor(self.Marker,"BackgroundColor3",tokens,"Accent")
    serenityColor(self.MarkerTip,"BackgroundColor3",tokens,"Accent")
    self.Deps.Motion:Tween(self.Marker,"Select",{BackgroundTransparency=self.Selected and 0.15 or 1,Position=UDim2.new(0,self.Selected and 5 or 3,0.5,-5)})
    self.Deps.Motion:Tween(self.MarkerTip,"Select",{BackgroundTransparency=self.Selected and 0.15 or 1})
    self.Deps.Motion:Tween(self.Tile,"Select",{BackgroundTransparency=1})
    self.Deps.Motion:Tween(self.Rim,"Select",{Transparency=self.Selected and 0.3 or 0.72})
    serenityColor(self.Icon,"ImageColor3",tokens,self.Selected and "Accent" or "TextMuted")
    serenityColor(self.Label,"TextColor3",tokens,self.Selected and "Text" or "TextMuted")
end

function NavItem:SetCollapsed(collapsed)
    self.Label.Visible = not collapsed
end

return NavItem

end)()
modules["src/components/Section.lua"] = (function()
local Section = {}
Section.__index = Section

function Section.new(parent, deps, props)
    local tokens = deps.Tokens
    props = props or {}

    local frame = Instance.new("Frame")
    frame.Name = props.Id or "Section"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.Parent = parent

    local stack = Instance.new("UIListLayout")
    stack.Padding = UDim.new(0, deps.Mobile and 4 or 6)
    stack.SortOrder = Enum.SortOrder.LayoutOrder
    stack.Parent = frame

    local header = Instance.new("TextButton")
    header.BackgroundTransparency = 1
    serenityColor(header,"BackgroundColor3",tokens,"PanelSoft")
    local headerCorner=Instance.new("UICorner");headerCorner.CornerRadius=UDim.new(0,2);headerCorner.Parent=header
    local headerEdge=Instance.new("UIStroke");headerEdge.Name="SectionHeaderEdge"
    headerEdge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;headerEdge.Thickness=1
    serenityColor(headerEdge,"Color",tokens,"Stroke");headerEdge.Transparency=1;headerEdge.Parent=header
    header.Text = ""
    header.AutoButtonColor = false
    header.Size = UDim2.new(1, 0, 0, 24)
    header.LayoutOrder = 1
    header.Parent = frame

    local title = deps.Typography.Label(
        header,
        "Section",
        tokens,
        string.upper(props.Title or "SECTION"),
        UDim2.fromOffset(12, 0),
        UDim2.new(1, props.Status and -122 or -52, 1, 0),
        tokens.Color.TextDim
    ,"TextDim")
    title.TextTransparency = 0
    title.Text = props.Title or "Section"
    title.TextSize = 13
    title.Font = deps.Typography.Font.Semibold
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.Position = UDim2.fromOffset(20,0)
    serenityColor(title,"TextColor3",tokens,"Text")
    local underline = Instance.new("Frame")
    underline.Name = "SectionAccent"
    underline.Size = UDim2.fromOffset(2, 10)
    underline.AnchorPoint=Vector2.new(0,0.5);underline.Position=UDim2.new(0,10,0.5,0)
    underline.BorderSizePixel=0;underline.BackgroundColor3=props.Accent or tokens.Color.Accent
    underline.BackgroundTransparency=0.32;underline.Parent=header
    local wings={}
    for _,x in ipairs({-2,2}) do
        local wing=Instance.new("Frame");wing.BorderSizePixel=0
        wing.Size=UDim2.fromOffset(2,4);wing.Position=UDim2.fromOffset(x,3)
        wing.BackgroundColor3=props.Accent or tokens.Color.Accent;wing.BackgroundTransparency=0.45;wing.Parent=underline
        table.insert(wings,wing)
    end
    deps.SectionRunes=deps.SectionRunes or setmetatable({}, {__mode="k"})
    local rune={Mark=underline,Wings=wings,Hovered=false}
    deps.SectionRunes[header]=rune
    local function runeFeedback(active)
        rune.Hovered=active
        deps.Motion:Tween(underline,0.14,{BackgroundTransparency=active and 0 or 0.32})
        for _,wing in ipairs(wings) do deps.Motion:Tween(wing,0.14,{BackgroundTransparency=active and 0.1 or 0.45}) end
        deps.Motion:Tween(headerEdge,0.14,{Transparency=active and 0.88 or 1})
    end
    deps.Runtime:TrackConnection(header.MouseEnter:Connect(function() if serenityInputBlocked(header) then return end; runeFeedback(true) end))
    deps.Runtime:TrackConnection(header.MouseLeave:Connect(function() runeFeedback(false) end))

    -- Opt-in feature groups preserve legacy section sizing and presentation.
    local description
    if props.Description then
        title.Text = props.Title or "Section"
        serenityColor(title,"TextColor3",tokens,"Text")
        title.TextTransparency = 0
        title.Position = UDim2.fromOffset(20, 0)
        title.Size = UDim2.new(1, -45, 1, 0)
        description = deps.Typography.Label(frame, "Description", tokens, props.Description,
            UDim2.fromOffset(10, 0), UDim2.new(1, -20, 0, 34), tokens.Color.TextMuted,"TextMuted")
        description.TextSize = 12
        serenityColor(description,"TextColor3",tokens,"TextMuted")
        description.TextWrapped = true
        description.TextYAlignment = Enum.TextYAlignment.Center
        description.LayoutOrder = 2
        description.Visible = props.Open ~= false
    end
    if props.Tooltip and deps.Help then
        local help = Instance.new("TextButton")
        help.Name = "SectionHelp"
        help.AnchorPoint = Vector2.new(1, 0.5)
        help.Position = UDim2.new(1, props.Collapsible and -20 or -2, 0.5, 0)
        help.Size = UDim2.fromOffset(24, 24)
        help.Text = "?"
        help.TextSize = 13
        help.Font = Enum.Font.GothamBold
        serenityColor(help,"TextColor3",tokens,"Accent")
        help.BackgroundTransparency = 1
        help.Parent = header
        deps.Help(help, props.Tooltip)
    end

    local status
    if props.Status then
        status = deps.Typography.Label(
            header,
            "Status",
            tokens,
            string.upper(props.Status),
            UDim2.new(1, -104, 0, 0),
            UDim2.fromOffset(80, tokens.Size.SectionLabel),
            props.StatusColor or tokens.Color.TextDim
        )
        status.TextXAlignment = Enum.TextXAlignment.Right
    end

    local caret
    if props.Collapsible then
        caret = deps.Icons.Create(header, props.Open == false and "plus" or "minus", 12, tokens.Color.TextDim)
        caret.AnchorPoint = Vector2.new(1, 0.5)
        caret.Position = UDim2.new(1, -2, 0.5, 0)
    end

    local body = Instance.new("Frame")
    body.Name = "Panel"
    body.Size = UDim2.new(1, 0, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Visible = props.Open ~= false
    body.LayoutOrder = props.Description and 3 or 2
    body.Parent = frame
    deps.Material.Section(body, tokens)
    body:SetAttribute("ReadingSurface", true)

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 0)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = body

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 2)
    pad.PaddingBottom = UDim.new(0, 2)
    pad.Parent = body

    local self = setmetatable({
        Frame = frame,
        Header = header,
        Body = body,
        Description = description,
        Open = props.Open ~= false,
        Status = status,
        Caret = caret,
        Collapsible = props.Collapsible == true,
        Deps = deps,
    }, Section)

    if self.Collapsible then
        header.MouseEnter:Connect(function() if serenityInputBlocked(header) then return end; deps.Motion:Tween(header,"Hover",{BackgroundColor3=tokens.Color.InsetHover,BackgroundTransparency=0.88}) end)
        header.MouseLeave:Connect(function() deps.Motion:Tween(header,"Hover",{BackgroundColor3=tokens.Color.PanelSoft,BackgroundTransparency=1}) end)
    end
    deps.Runtime:TrackConnection(header.MouseButton1Click:Connect(function() if serenityInputBlocked(header) then return end;
        if self.Collapsible then
            self:SetOpen(not self.Open)
        end
    end))

    return self
end

function Section:SetOpen(value)
    self.Open = not not value
    self.Body.Visible = self.Open
    if self.Description then self.Description.Visible=self.Open end
    if self.Caret then
        self.Caret.Image = self.Deps.Icons.Get(self.Open and "minus" or "plus")
    end
end

function Section:SetStatus(text, color)
    if not self.Status then return end
    self.Status.Text = string.upper(tostring(text))
    if color then self.Status.TextColor3 = color end
end

return Section

end)()
modules["src/components/Toggle.lua"] = (function()
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, deps, props)
    local tokens = deps.Tokens
    props = props or {}
    local hasDescription = props.Description and props.Description ~= ""
    local height = hasDescription and tokens.Size.ControlWithDescription or tokens.Size.Control

    local row = Instance.new("CanvasGroup")
    row.Name = props.Id or "Toggle"
    row:SetAttribute("FeatureTitle", props.Title or "Toggle")
    row:SetAttribute("FeatureDescription", props.Description or "")
    row.Size = UDim2.new(1, 0, 0, height)
    row.Parent = parent
    deps.Material.Control(row, tokens)

    local titleY = hasDescription and 6 or 0
    local titleH = hasDescription and 19 or height
    local controlTitle=deps.Typography.Label(
        row,
        "Control",
        tokens,
        props.Title or "Toggle",
        UDim2.fromOffset(13, titleY),
        UDim2.new(1, props.Settings and props.OnSettings and -108 or -68, 0, titleH),
        tokens.Color.Text
    ,"Text")

    if deps.Mobile then controlTitle.TextSize=13 end
    controlTitle.TextTruncate=Enum.TextTruncate.AtEnd
    if hasDescription then
        deps.Typography.Label(
            row,
            "Description",
            tokens,
            props.Description,
            UDim2.fromOffset(13, 27),
            UDim2.new(1, -108, 0, 15),
            tokens.Color.TextDim
        ,"TextDim")
    end

    if props.Settings and props.OnSettings then
        local dots = deps.Typography.Label(row, "Value", tokens, "•••", UDim2.new(1, -96, 0, 0), UDim2.fromOffset(34, height), tokens.Color.TextDim,"TextDim")
        dots.TextXAlignment = Enum.TextXAlignment.Center
    end

    local switch = Instance.new("Frame")
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.Position = UDim2.new(1, -13, 0.5, 0)
    switch.Size = UDim2.fromOffset(38, 21)
    switch.BorderSizePixel = 0
    switch.Parent = row
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    deps.Material.PixelSurface(switch,2)

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Size = UDim2.fromOffset(15, 15)
    knob.BackgroundColor3 = Color3.fromRGB(249, 250, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    deps.Material.PixelSurface(knob,1)

    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.Size = UDim2.fromScale(1, 1)
    hit.Parent = row

    local self = setmetatable({
        Frame = row,
        Value = not not props.Default,
        Enabled = props.Enabled ~= false,
        Switch = switch,
        Knob = knob,
        Callback = props.Callback,
        Motion = deps.Motion,
        Tokens = tokens,
    }, Toggle)

    function self:_render(animate)
        serenityColor(self.Switch,"BackgroundColor3",self.Tokens,self.Value and "Accent" or "Disabled")
        local pos = self.Value and UDim2.new(1, -10.5, 0.5, 0) or UDim2.fromOffset(10.5, 10.5)
        if animate then
            self.Motion:Tween(self.Knob, "Toggle", {Position = pos})
        else
            self.Knob.Position = pos
        end
        self.Frame.GroupTransparency = self.Enabled and 0 or 0.45
    end

    self:_render(false)

    hit.MouseEnter:Connect(function() if serenityInputBlocked(hit) then return end;
        if self.Enabled then deps.Material.Hover(row, tokens, true) end
    end)
    hit.MouseLeave:Connect(function()
        deps.Material.Hover(row, tokens, false)
    end)
    hit.MouseButton1Click:Connect(function() if serenityInputBlocked(hit) then return end;
        if not self.Enabled then return end
        self:Set(not self.Value)
    end)

    return self
end

function Toggle:Set(value, silent)
    self.Value = not not value
    self:_render(true)
    if self.Callback and not silent then self.Callback(self.Value) end
end

function Toggle:SetEnabled(value)
    self.Enabled = not not value
    self:_render(false)
end

function Toggle:Get()
    return self.Value
end

function Toggle:SetVisible(value)
    self.Frame.Visible = not not value
end

function Toggle:IsVisible()
    return self.Frame.Visible
end

return Toggle

end)()
modules["src/components/Slider.lua"] = (function()
local Slider = {}
Slider.__index = Slider

function Slider.new(parent, deps, props)
    local tokens = deps.Tokens
    props = props or {}

    local min = props.Min or 0
    local max = props.Max or 100
    local step = math.max(0.000001, props.Step or 1)
    max = math.max(min, max)
    local value = math.clamp(props.Default or min, min, max)
    local suffix = props.Suffix or ""

    local row = Instance.new("CanvasGroup")
    row.Name = props.Id or "Slider"
    row:SetAttribute("FeatureTitle", props.Title or "Slider")
    row:SetAttribute("FeatureDescription", props.Description or "")
    row.Size = UDim2.new(1, 0, 0, tokens.Size.Slider)
    row.Parent = parent
    deps.Material.Control(row, tokens)

    deps.Typography.Label(
        row,
        "Control",
        tokens,
        props.Title or "Slider",
        UDim2.fromOffset(13, 0),
        UDim2.new(1, -86, 0, 29),
        tokens.Color.Text
    ,"Text")

    if props.Settings and props.OnSettings then
        local dots = deps.Typography.Label(row, "Value", tokens, "•••", UDim2.new(0.39, 0, 0, 0), UDim2.fromOffset(30, tokens.Size.Slider), tokens.Color.TextDim,"TextDim")
        dots.TextXAlignment = Enum.TextXAlignment.Center
    end

    local valueBox = Instance.new("Frame")
    valueBox.AnchorPoint = Vector2.new(1, 0.5)
    valueBox.Position = UDim2.new(1, -12, 0, 15)
    valueBox.Size = UDim2.fromOffset(48, 26)
    valueBox.Parent = row
    deps.Material.Inset(valueBox, tokens)
    deps.Material.PixelSurface(valueBox,2)

    local valueLabel = Instance.new("TextBox")
    valueLabel.Size=UDim2.fromScale(1,1)
    valueLabel.ClearTextOnFocus=false
    valueLabel.Text=tostring(value)
    valueLabel.Parent=valueBox
    deps.Typography.Apply(valueLabel,"Value",tokens,tokens.Color.TextMuted)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center

    local bar = Instance.new("Frame")
    bar.AnchorPoint = Vector2.new(1, 0.5)
    bar.Position = UDim2.new(1, -16, 0, 42)
    bar.Size = UDim2.new(1, -32, 0, 4)
    serenityColor(bar,"BackgroundColor3",tokens,"Disabled")
    bar.BackgroundTransparency = 0.34
    bar.BorderSizePixel = 0
    bar.Parent = row
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    serenityColor(fill,"BackgroundColor3",tokens,"Accent")
    fill.BorderSizePixel = 0
    fill.Parent = bar
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 0)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Size = UDim2.fromOffset(12, 12)
    knob.BackgroundColor3 = Color3.fromRGB(247, 249, 255)
    knob.BorderSizePixel = 0
    knob.Parent = bar
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    deps.Material.PixelSurface(knob,1)

    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.AnchorPoint = Vector2.new(1, 0.5)
    hit.Position = UDim2.new(1, -8, 0, 42)
    hit.Size = UDim2.new(1, -16, 0, 28)
    hit.Parent = row

    local self = setmetatable({
        Frame = row,
        Value = value,
        Enabled = props.Enabled ~= false,
        Min = min,
        Max = max,
        Step = step,
        Suffix = suffix,
        Fill = fill,
        Knob = knob,
        Label = valueLabel,
        Callback = props.Callback,
        Tokens = tokens,
    }, Slider)

    local function roundToStep(v)
        local snapped = math.floor(((v - min) / step) + 0.5) * step + min
        return math.clamp(snapped, min, max)
    end

    function self:_render()
        local alpha = (self.Value - self.Min) / math.max(0.0001, self.Max - self.Min)
        self.Fill.Size = UDim2.new(alpha, 0, 1, 0)
        self.Knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        self.Label.Text = string.format("%.3f", self.Value):gsub("0+$", ""):gsub("%.$", "") .. self.Suffix
        self.Frame.GroupTransparency = self.Enabled and 0 or 0.45
    end

    function self:_setFromX(x)
        if not self.Enabled then return end
        local alpha = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
        local raw = self.Min + (self.Max - self.Min) * alpha
        self:Set(roundToStep(raw))
    end

    local dragging = false
    hit.InputBegan:Connect(function(input)
        if deps.ModalActive or serenityInputBlocked(hit) then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            self:_setFromX(input.Position.X)
        end
    end)

    deps.Runtime:TrackConnection(deps.UserInputService.InputChanged:Connect(function(input)
        if dragging and not deps.ModalActive and not serenityInputBlocked(hit) and deps.WindowFrame.Visible and deps.WindowFrame.Parent.Visible and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            self:_setFromX(input.Position.X)
        end
    end))

    deps.Runtime:TrackConnection(deps.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    valueLabel.Focused:Connect(function()
        if not self.Enabled then valueLabel:ReleaseFocus() return end
        valueLabel.Text=tostring(self.Value)
    end)
    valueLabel.FocusLost:Connect(function()
        local number=tonumber(valueLabel.Text)
        if self.Enabled and number and number==number and math.abs(number)<math.huge then self:Set(number) end
        self:_render()
    end)
    valueBox.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseWheel and self.Enabled then
            self:Set(self.Value+input.Position.Z*self.Step)
        end
    end)
    self:_render()
    return self
end

function Slider:Set(value, silent)
    if type(value)~="number" or value~=value or math.abs(value)==math.huge then return end
    local nextValue = math.clamp(self.Min + math.floor((value - self.Min) / self.Step + 0.5) * self.Step, self.Min, self.Max)
    if nextValue == self.Value then return end
    self.Value = nextValue
    self:_render()
    if self.Callback and not silent then self.Callback(self.Value) end
end

function Slider:SetEnabled(value)
    self.Enabled = not not value
    self:_render()
end

function Slider:Get()
    return self.Value
end

function Slider:SetVisible(value)
    self.Frame.Visible = not not value
end

function Slider:IsVisible()
    return self.Frame.Visible
end

return Slider

end)()
modules["src/components/Select.lua"] = (function()
local Select = {}
Select.__index = Select

local function popupPosition(deps, button, width, height)
    local scale = (deps.UIScale and deps.UIScale.Scale) or 1
    local shell = deps.WindowFrame
    local x = (button.AbsolutePosition.X - shell.AbsolutePosition.X) / scale
    local y = (button.AbsolutePosition.Y - shell.AbsolutePosition.Y) / scale
    local bw = button.AbsoluteSize.X / scale
    local bh = button.AbsoluteSize.Y / scale
    local maxW = shell.AbsoluteSize.X / scale
    local maxH = shell.AbsoluteSize.Y / scale
    return UDim2.fromOffset(
        math.clamp(x + bw - width, 8, math.max(8, maxW - width - 8)),
        math.clamp(y + bh + height + 12 <= maxH and (y + bh + 4) or (y - height - 4), 8, math.max(8, maxH - height - 8))
    )
end

function Select.new(parent, deps, props)
    local tokens = deps.Tokens
    props = props or {}
    local hasDescription = props.Description and props.Description ~= ""
    local height = math.max(hasDescription and 76 or 58,hasDescription and tokens.Size.ControlWithDescription or tokens.Size.Select)

    local row = Instance.new("CanvasGroup")
    row.Name = props.Id or "Select"
    row:SetAttribute("FeatureTitle", props.Title or "Select")
    row:SetAttribute("FeatureDescription", props.Description or "")
    row.Size = UDim2.new(1, 0, 0, height)
    row.Parent = parent
    deps.Material.Control(row, tokens)

    local titleY = 0
    local titleH = 24
    deps.Typography.Label(row, "Control", tokens, props.Title or "Select", UDim2.fromOffset(13, titleY), UDim2.new(1, -26, 0, titleH), tokens.Color.Text,"Text")
    if hasDescription then
        deps.Typography.Label(row, "Description", tokens, props.Description, UDim2.fromOffset(13, 27), UDim2.new(0.47, -12, 0, 15), tokens.Color.TextDim,"TextDim")
    end

    local button = Instance.new("TextButton")
    button.AnchorPoint = Vector2.new(1, 0.5)
    button.Position = UDim2.new(1, -12, 1, -19)
    button.Size = UDim2.new(1, -24, 0, 30)
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = row
    deps.Material.Inset(button, tokens)
    deps.Material.PixelSurface(button,2)

    local valueLabel = deps.Typography.Label(button, "Value", tokens, tostring(props.Default or "Select"), UDim2.fromOffset(10, 0), UDim2.new(1, -34, 1, 0), tokens.Color.TextMuted,"TextMuted")
    local chevron = deps.Icons.Create(button, "chevron_down", 13, tokens.Color.TextDim)
    chevron.AnchorPoint = Vector2.new(1, 0.5)
    chevron.Position = UDim2.new(1, -9, 0.5, 0)

    local self = setmetatable({
        Frame = row,
        Button = button,
        Label = valueLabel,
        Value = props.Multi and (type(props.Default)=="table" and table.clone(props.Default) or {}) or props.Default,
        Multi = props.Multi == true,
        Options = props.Options or {},
        Enabled = props.Enabled ~= false,
        Callback = props.Callback,
        Deps = deps,
    }, Select)

    function self:_render()
        if self.Multi then
            local names={};for _,value in ipairs(self.Value) do table.insert(names,tostring(value)) end
            self.Label.Text=#names>2 and (tostring(#names).." selected") or (#names>0 and table.concat(names,", ") or "Select options")
            self.Label.TextTruncate=Enum.TextTruncate.AtEnd
        else self.Label.Text = tostring(self.Value or "Select") end
        if self.RefreshOpenChoices then self.RefreshOpenChoices() end
        self.Frame.GroupTransparency = self.Enabled and 0 or 0.45
    end

    button.MouseEnter:Connect(function() if serenityInputBlocked(button) then return end;
        if self.Enabled then button.BackgroundColor3 = tokens.Color.InsetHover end
    end)
    button.MouseLeave:Connect(function()
        serenityColor(button,"BackgroundColor3",tokens,"Inset")
    end)

    button.MouseButton1Click:Connect(function() if serenityInputBlocked(button) then return end;
        if not self.Enabled then return end
        deps.PopupManager:Close()

        local width = math.max(180, math.floor(button.AbsoluteSize.X / math.max(0.001, (deps.UIScale and deps.UIScale.Scale) or 1)))
        local searchable=props.Searchable~=false and (props.Searchable==true or #self.Options>6)
        local top=searchable and 44 or 6
        local footer=self.Multi and 36 or 0
        local heightPopup = math.min(270, top+footer+6+math.max(34,#self.Options*34))
        local popup = Instance.new("Frame")
        popup.Size = UDim2.fromOffset(width, heightPopup)
        popup.Position = popupPosition(deps, button, width, heightPopup)
        popup.ZIndex = 80
        popup.Parent = deps.PopupHost
        deps.Material.Popup(popup, tokens)

        local scroller = Instance.new("ScrollingFrame")
        scroller.BackgroundTransparency = 1
        scroller.BorderSizePixel = 0
        scroller.Position = UDim2.fromOffset(6, top)
        scroller.Size = UDim2.new(1, -12, 1, -(top+footer+6))
        scroller.CanvasSize = UDim2.new()
        scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroller.ScrollBarThickness = 2
        scroller.ScrollBarImageColor3 = tokens.Color.Accent
        scroller.ScrollBarImageTransparency = 0.35
        scroller.ZIndex = 81
        scroller.Parent = popup

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 3)
        list.Parent = scroller

        local entries={}
        local hovered,focused
        local function isSelected(option)
            if self.Multi then return table.find(self.Value,option)~=nil end
            return option==self.Value
        end
        local function refreshChoices()
            if not popup.Parent then return end
            local target=hovered or focused
            for _,entry in ipairs(entries) do
                local selected=isSelected(entry.Option)
                local active=target==entry
                local emphasized=active or (selected and (self.Multi or not target))
                local show=self.Multi and selected or (not self.Multi and (target and active or (not target and selected)))
                local state=(active and 4 or 0)+(emphasized and 2 or 0)+(show and 1 or 0)
                if entry.State~=state then
                entry.State=state
                -- Only changed rows animate; keep single-select markers exclusive.
                for _,part in ipairs(entry.Pixels) do part.BackgroundTransparency=show and 0.15 or 1 end
                serenityColor(entry.Button,"BackgroundColor3",tokens,emphasized and "NavActive" or "PanelSoft")
                deps.Motion:Tween(entry.Button,0.1,{BackgroundTransparency=active and 0 or (emphasized and 0.12 or 0.55)})
                serenityColor(entry.Button,"TextColor3",tokens,emphasized and "Text" or "TextMuted")
                end
            end
        end
        self.RefreshOpenChoices=refreshChoices
        popup.Destroying:Connect(function()
            if self.RefreshOpenChoices==refreshChoices then self.RefreshOpenChoices=nil end
        end)
        for _, option in ipairs(self.Options) do
            local selected = isSelected(option)
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, -2, 0, 31)
            serenityColor(item,"BackgroundColor3",tokens,selected and "NavActive" or "PanelSoft")
            item.BackgroundTransparency = selected and 0.08 or 0.55
            item.BorderSizePixel = 0
            item.Text = tostring(option)
            item.TextXAlignment=Enum.TextXAlignment.Left
            local padding=Instance.new("UIPadding");padding.PaddingLeft=UDim.new(0,26);padding.PaddingRight=UDim.new(0,10);padding.Parent=item
            serenityColor(item,"TextColor3",tokens,selected and "Text" or "TextMuted")
            item.TextSize = tokens.Type.Value
            item.Font = selected and deps.Typography.Font.Semibold or deps.Typography.Font.Medium
            item.AutoButtonColor = false
            item.ZIndex = 82
            item.Parent = scroller
            local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,3);c.Parent=item
            local pixels={}
            for _,segment in ipairs(self.Multi and {{0,0,2,2},{2,2,2,2},{4,0,2,2},{6,-2,2,2}} or {{0,-5,2,10},{2,-3,2,6},{4,-1,2,2}}) do
                local part=Instance.new("Frame");part.BorderSizePixel=0
                part.Position=UDim2.new(0,-18+segment[1],0.5,segment[2])
                part.Size=UDim2.fromOffset(segment[3],segment[4]);serenityColor(part,"BackgroundColor3",tokens,"Accent")
                part.BackgroundTransparency=selected and 0.15 or 1;part.ZIndex=83;part.Parent=item
                table.insert(pixels,part)
            end
            local entry={Button=item,Pixels=pixels,Option=option}
            table.insert(entries,entry)
            item.MouseEnter:Connect(function() if serenityInputBlocked(item) then return end; hovered=entry;refreshChoices() end)
            item.MouseLeave:Connect(function() if hovered==entry then hovered=nil end;refreshChoices() end)
            item.SelectionGained:Connect(function() if serenityInputBlocked(item) then return end; focused=entry;refreshChoices() end)
            item.SelectionLost:Connect(function() if focused==entry then focused=nil end;refreshChoices() end)
            item.MouseButton1Click:Connect(function() if serenityInputBlocked(item) or not self.Enabled then return end;
                if self.Multi then
                    local values=table.clone(self.Value);local index=table.find(values,option)
                    if index then table.remove(values,index) else table.insert(values,option) end
                    self:Set(values)
                else
                    self:Set(option);deps.PopupManager:Close()
                end
            end)
        end
        local empty=Instance.new("TextLabel")
        empty.BackgroundTransparency=1;empty.Size=UDim2.new(1,0,0,34)
        serenityColor(empty,"TextColor3",tokens,"TextMuted");empty.TextSize=12;empty.Font=Enum.Font.Gotham
        empty.ZIndex=82;empty.Parent=scroller
        local function filter(query)
            query=string.lower(query or "")
            hovered=nil;focused=nil
            local count=0
            for _,entry in ipairs(entries) do
                local visible=string.find(string.lower(tostring(entry.Option)),query,1,true)~=nil
                entry.Button.Visible=visible
                if visible then count=count+1 end
            end
            empty.Text=#entries==0 and "No options available" or "No matching options"
            empty.Visible=count==0
            scroller.CanvasPosition=Vector2.new()
            refreshChoices()
        end
        if searchable then
            local search=Instance.new("TextBox")
            search.Name="OptionSearch";search.Text="";search.PlaceholderText="Search options…"
            search.ClearTextOnFocus=false;search.TextSize=12;search.Font=Enum.Font.Gotham
            serenityColor(search,"TextColor3",tokens,"Text");serenityColor(search,"PlaceholderColor3",tokens,"TextMuted")
            serenityColor(search,"BackgroundColor3",tokens,"Inset");search.BorderSizePixel=0
            search.Position=UDim2.fromOffset(6,6);search.Size=UDim2.new(1,-12,0,32)
            search.ZIndex=82;search.Parent=popup
            search:GetPropertyChangedSignal("Text"):Connect(function() filter(search.Text) end)
        end
        if self.Multi then
            local function bulkButton(text,x,callback)
                local action=Instance.new("TextButton")
                action.Text=text;action.Font=Enum.Font.GothamMedium;action.TextSize=12
                serenityColor(action,"TextColor3",tokens,"Text");serenityColor(action,"BackgroundColor3",tokens,"Inset")
                action.BorderSizePixel=0;action.AutoButtonColor=true;action.ZIndex=82
                action.Position=UDim2.new(x,x==0 and 6 or 3,1,-34)
                action.Size=UDim2.new(0.5,-9,0,28);action.Parent=popup
                action.Activated:Connect(function()
                    if self.Enabled and not serenityInputBlocked(action) then callback() end
                end)
            end
            bulkButton("Select all",0,function() self:Set(table.clone(self.Options)) end)
            bulkButton("Clear",0.5,function() self:Set({}) end)
        end
        filter("")

        deps.PopupManager:Set(popup)
    end)

    self:_render()
    return self
end

function Select:Set(value, silent)
    if self.Multi then
        if type(value)~="table" then return end
        local filtered={}
        for _,option in ipairs(self.Options) do
            if table.find(value,option) and not table.find(filtered,option) then table.insert(filtered,option) end
        end
        self.Value=filtered
    else
        local found=false
        for _,option in ipairs(self.Options) do if option==value then found=true break end end
        if not found and #self.Options>0 then return end
        self.Value=value
    end
    self:_render()
    if self.Callback and not silent then self.Callback(self:Get()) end
end

function Select:Refresh(options, preserve, silent)
    local previous=self:Get()
    self.Deps.PopupManager:Close()
    self.Options=options or {}
    if self.Multi then self:Set(preserve and previous or {},silent~=false);return end
    if preserve then
        for _,option in ipairs(self.Options) do
            if option==previous then self:Set(previous,true);return end
        end
    end
    self:Set(self.Options[1],silent~=false)
end

function Select:SetEnabled(value)
    self.Enabled = not not value
    self:_render()
end

function Select:Get()
    return self.Multi and table.clone(self.Value) or self.Value
end

function Select:SetVisible(value)
    self.Frame.Visible = not not value
end

function Select:IsVisible()
    return self.Frame.Visible
end

return Select

end)()
modules["src/components/ColumnLayout.lua"] = (function()
local ColumnLayout = {}
ColumnLayout.__index = ColumnLayout

function ColumnLayout.new(parent, deps, props)
    props = props or {}
    local gap = props.Gap or 12

    local frame = Instance.new("Frame")
    frame.Name = props.Id or "ColumnLayout"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.LayoutOrder = props.LayoutOrder or 1
    frame.Parent = parent

    local left = Instance.new("Frame")
    left.Name = "Left"
    left.BackgroundTransparency = 1
    left.Position = UDim2.fromOffset(0, 0)
    left.Size = UDim2.new(0.5, -(gap / 2), 0, 0)
    left.AutomaticSize = Enum.AutomaticSize.Y
    left.Parent = frame

    local right = Instance.new("Frame")
    right.Name = "Right"
    right.BackgroundTransparency = 1
    right.Position = UDim2.new(0.5, gap / 2, 0, 0)
    right.Size = UDim2.new(0.5, -(gap / 2), 0, 0)
    right.AutomaticSize = Enum.AutomaticSize.Y
    right.Parent = frame

    local leftList = Instance.new("UIListLayout")
    leftList.Padding = UDim.new(0, props.RowGap or 10)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder
    leftList.Parent = left

    local rightList = Instance.new("UIListLayout")
    rightList.Padding = UDim.new(0, props.RowGap or 10)
    rightList.SortOrder = Enum.SortOrder.LayoutOrder
    rightList.Parent = right

    local self = setmetatable({
        Frame = frame,
        Left = left,
        Right = right,
        LeftList = leftList,
        RightList = rightList,
        Deps = deps,
    }, ColumnLayout)

    local function refresh()
        local scale = deps.UIScale and deps.UIScale.Scale or 1
        local logicalWidth=frame.AbsoluteSize.X/math.max(scale,0.001)
        local minColumnWidth=props.MinColumnWidth or (deps.Mobile and 224 or 250)
        local narrow=logicalWidth < minColumnWidth*2+gap
        left.Size = UDim2.new(narrow and 1 or 0.5, narrow and 0 or -(gap / 2), 0, 0)
        right.Size = left.Size
        local leftH = leftList.AbsoluteContentSize.Y / scale
        local rightH = rightList.AbsoluteContentSize.Y / scale
        right.Position = narrow and UDim2.fromOffset(0, leftH + gap) or UDim2.new(0.5, gap / 2, 0, 0)
        frame.Size = UDim2.new(1, 0, 0, narrow and (leftH + gap + rightH) or math.max(leftH, rightH))
    end

    -- Coalesce size/content signals into one layout pass per scheduler turn.
    local pending
    local function scheduleRefresh()
        if pending or (deps.Runtime and deps.Runtime.Destroyed) then return end
        pending=task.defer(function()
            pending=nil
            if not deps.Runtime or not deps.Runtime.Destroyed then refresh() end
        end)
    end
    local function observe(object,property)
        local connection=object:GetPropertyChangedSignal(property):Connect(scheduleRefresh)
        if deps.Runtime then deps.Runtime:TrackConnection(connection) end
    end
    observe(leftList,"AbsoluteContentSize")
    observe(rightList,"AbsoluteContentSize")
    local lastWidth
    local widthConnection=frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        local width=frame.AbsoluteSize.X
        if width~=lastWidth then lastWidth=width;scheduleRefresh() end
    end)
    if deps.Runtime then
        deps.Runtime:TrackConnection(widthConnection)
        deps.Runtime:TrackCleanup(function() if pending then pcall(task.cancel,pending);pending=nil end end)
    end
    if deps.UIScale then observe(deps.UIScale,"Scale") end
    scheduleRefresh()
    return self
end

return ColumnLayout

end)()
modules["src/components/RankedPets.lua"] = (function()
local RankedPets={}
RankedPets.__index=RankedPets
local function finite(value,fallback)
    value=tonumber(value)
    return value and value==value and math.abs(value)<math.huge and value or fallback
end
function RankedPets.Normalize(items)
    local result,seen={},{}
    for _,item in ipairs(type(items)=="table" and items or {}) do
        if type(item)=="table" then
            local name=tostring(item.Name or "Unknown pet"):sub(1,80)
            local id=tostring(item.Id or name)
            local count=math.max(0,math.floor(finite(item.Count,1)))
            if count>0 and not seen[id] then
                seen[id]=true
                local icon=tostring(item.Image or "")
                if icon:match("^%d+$") then icon="rbxassetid://"..icon end
                if not icon:match("^rbxassetid://%d+$") then icon="" end
                table.insert(result,{Id=id,Name=name,Rarity=tostring(item.Rarity or "Unknown"):sub(1,32),Count=count,
                    Score=math.max(0,finite(item.Score,0)),Location=tostring(item.Location or "Location unavailable"):sub(1,100),Image=icon})
            end
        end
    end
    return result
end
function RankedPets.Order(items,mode,query)
    local result={};query=string.lower(query or "")
    for _,item in ipairs(items) do
        if string.find(string.lower(item.Name.." "..item.Rarity.." "..item.Location),query,1,true) then table.insert(result,item) end
    end
    table.sort(result,function(a,b)
        if mode=="Name" then
            if a.Name~=b.Name then return a.Name<b.Name end
        else
            local av,bv=mode=="Count" and a.Count or a.Score,mode=="Count" and b.Count or b.Score
            if av~=bv then return av>bv end
            if a.Name~=b.Name then return a.Name<b.Name end
        end
        return a.Id<b.Id
    end)
    return result
end
local function compact(n)
    if n>=1e9 then return string.format("%.1fB",n/1e9) end
    if n>=1e6 then return string.format("%.1fM",n/1e6) end
    if n>=1e3 then return string.format("%.1fk",n/1e3) end
    return tostring(math.floor(n))
end
function RankedPets.new(parent,deps,options)
    options=options or {}
    local tokens=deps.Tokens
    local self=setmetatable({Items={},Mode="Score",Query="",Limit=20,Rows={},Demo=options.Demo==true,State="Ready"},RankedPets)
    local function label(parent,text,x,y,w,h,size,color)
        local object=deps.Typography.Label(parent,"Control",tokens,text,UDim2.fromOffset(x,y),UDim2.new(1,w,0,h),color or tokens.Color.Text)
        object.TextSize=size;object.TextTruncate=Enum.TextTruncate.AtEnd
        return object
    end
    local root=Instance.new("Frame");root.Name="AvailablePets";root.BackgroundTransparency=1
    root.Size=UDim2.new(1,0,0,0);root.AutomaticSize=Enum.AutomaticSize.Y;root.Parent=parent;self.Frame=root
    local stack=Instance.new("UIListLayout");stack.SortOrder=Enum.SortOrder.LayoutOrder;stack.Padding=UDim.new(0,4);stack.Parent=root
    local summary=Instance.new("Frame");summary.BackgroundTransparency=1;summary.Size=UDim2.new(1,0,0,48);summary.LayoutOrder=0;summary.Parent=root
    local summaryText=label(summary,"",12,3,-24,42,12,tokens.Color.TextMuted)
    summaryText.TextWrapped=true;summaryText.TextYAlignment=Enum.TextYAlignment.Top
    local toolbar=Instance.new("Frame");toolbar.BackgroundTransparency=1;toolbar.Size=UDim2.new(1,0,0,38);toolbar.LayoutOrder=1;toolbar.Parent=root
    local search=Instance.new("TextBox");search.Name="PetSearch";search.Text="";search.PlaceholderText="Search pets…";search.ClearTextOnFocus=false
    search.TextSize=12;search.Font=Enum.Font.Gotham;serenityColor(search,"TextColor3",tokens,"Text");serenityColor(search,"PlaceholderColor3",tokens,"TextMuted")
    search.Position=UDim2.fromOffset(10,0);search.Size=UDim2.new(1,-106,0,32);search.Parent=toolbar;deps.Material.Inset(search,tokens)
    local sort=Instance.new("TextButton");sort.Size=UDim2.fromOffset(80,32);sort.Position=UDim2.new(1,-90,0,0)
    sort.Text="Score ↓";sort.Font=Enum.Font.GothamMedium;sort.TextSize=11;serenityColor(sort,"TextColor3",tokens,"Accent")
    sort.AutoButtonColor=false;sort.Parent=toolbar;deps.Material.Inset(sort,tokens)
    local empty=label(root,"No pets available",12,0,-24,48,12,tokens.Color.TextMuted);empty.LayoutOrder=2
    local more=Instance.new("TextButton");more.Size=UDim2.new(1,-20,0,30);more.BackgroundTransparency=1
    more.Text="Show 20 more";more.TextSize=12;more.Font=Enum.Font.GothamMedium;serenityColor(more,"TextColor3",tokens,"Accent");more.LayoutOrder=10000;more.Parent=root
    local function makeRow()
        local row=Instance.new("TextButton");row.Name="PetEntry";row.Size=UDim2.new(1,0,0,56);row.Text="";row.AutoButtonColor=false
        serenityColor(row,"BackgroundColor3",tokens,"PanelSoft");row.BackgroundTransparency=0.65;row.BorderSizePixel=0;row.Parent=root
        deps.Material.PixelSurface(row,2)
        local mark=Instance.new("Frame");mark.BorderSizePixel=0;mark.Size=UDim2.fromOffset(2,26);mark.Position=UDim2.fromOffset(1,15)
        serenityColor(mark,"BackgroundColor3",tokens,"Accent");mark.Visible=false;mark.Parent=row
        local rank=label(row,"",8,15,0,22,12,tokens.Color.TextMuted);rank.Size=UDim2.fromOffset(24,22)
        local portrait=Instance.new("Frame");portrait.Size=UDim2.fromOffset(36,36);portrait.Position=UDim2.fromOffset(36,10)
        portrait.BorderSizePixel=0;serenityColor(portrait,"BackgroundColor3",tokens,"Inset");portrait.Parent=row;deps.Material.PixelSurface(portrait,2)
        local fallback=Instance.new("Frame");fallback.BackgroundTransparency=1;fallback.Size=UDim2.fromScale(1,1);fallback.Parent=portrait
        local pixels={}
        -- Small native pixel pet: no asset download is required for the fallback.
        for y,line in ipairs({"XX   XX","XXX XXX","XXXXXXX","XoXXXoX","XXXXXXX"," XXoXX ","  XXX  "}) do
            local x=1
            while x<=#line do
                local tone=line:sub(x,x)
                if tone==" " then x=x+1 else
                    local last=x;while last<#line and line:sub(last+1,last+1)==tone do last=last+1 end
                    local pixel=Instance.new("Frame");pixel.BorderSizePixel=0
                    pixel.Position=UDim2.fromOffset(4+(x-1)*4,4+(y-1)*4);pixel.Size=UDim2.fromOffset((last-x+1)*4,4)
                    pixel.BackgroundColor3=tone=="o" and tokens.Color.ShellDeep or tokens.Color.Accent;pixel.Parent=fallback
                    if tone~="o" then table.insert(pixels,pixel) end
                    x=last+1
                end
            end
        end
        local image=Instance.new("ImageLabel");image.BackgroundTransparency=1;image.Size=UDim2.fromScale(1,1);image.ScaleType=Enum.ScaleType.Fit;image.Parent=portrait
        image:GetPropertyChangedSignal("IsLoaded"):Connect(function() fallback.Visible=image.Image=="" or not image.IsLoaded end)
        local name=label(row,"",82,7,-146,23,13);name.Font=Enum.Font.GothamSemibold
        local rarity=label(row,"",82,30,-146,18,11,tokens.Color.TextMuted)
        local count=label(row,"",0,8,0,22,13);count.Position=UDim2.new(1,-60,0,8);count.Size=UDim2.fromOffset(48,22);count.TextXAlignment=Enum.TextXAlignment.Right
        local score=label(row,"",0,31,0,16,10,tokens.Color.TextMuted);score.Position=UDim2.new(1,-60,0,31);score.Size=UDim2.fromOffset(48,16);score.TextXAlignment=Enum.TextXAlignment.Right
        local detail=label(row,"",12,58,-24,0,12,tokens.Color.TextMuted)
        detail.TextWrapped=true;detail.TextYAlignment=Enum.TextYAlignment.Top;detail.TextTruncate=Enum.TextTruncate.None;detail.Visible=false
        local entry={Detail=detail,Frame=row,Mark=mark,Rank=rank,Name=name,Rarity=rarity,Count=count,Score=score,Image=image,Fallback=fallback,Pixels=pixels}
        local hoverTween
        local function hover(active)
            if hoverTween then hoverTween:Cancel() end
            hoverTween=deps.Motion:Tween(row,"Hover",{BackgroundTransparency=active and 0.1 or (entry.Item and self.Selected==entry.Item.Id and 0.25 or 0.65)})
        end
        row.MouseEnter:Connect(function() if not serenityInputBlocked(row) then hover(true) end end)
        row.MouseLeave:Connect(function() hover(false) end)
        row.Activated:Connect(function()
            if serenityInputBlocked(row) or not entry.Item then return end
            if self.Selected==entry.Item.Id then self.Selected=nil else self.Selected=entry.Item.Id end
            self:Render()
        end)
        deps.Runtime:TrackCleanup(function() if hoverTween then hoverTween:Cancel() end end)
        return entry
    end
    function self:Render()
        if deps.Runtime.Destroyed then return end
        local ordered=self.State=="Ready" and RankedPets.Order(self.Items,self.Mode,self.Query) or {}
        local total=0;for _,item in ipairs(self.Items) do total=total+item.Count end
        summaryText.Text=(self.Demo and "SAMPLE DATA" or "SERVER PETS").." · "..#self.Items.." types · "..compact(total).." available"
        summaryText.Text=summaryText.Text.."\n"..self.Mode.." order"..(self.UpdatedAt and (" · Updated "..os.date("%H:%M:%S",self.UpdatedAt)) or "")
        empty.Visible=#ordered==0
        empty.Text=self.State=="Loading" and "Loading available pets…" or (self.State=="Unavailable" and (self.StateMessage or "Pet data unavailable") or (#self.Items==0 and "No pets available" or "No matching pets"))
        sort.Active=self.State=="Ready";search.TextEditable=self.State=="Ready"
        local shown=math.min(self.Limit,#ordered)
        for i=1,shown do
            local entry=self.Rows[i] or makeRow();self.Rows[i]=entry
            local item=ordered[i];entry.Item=item
            entry.Frame.Visible=true;entry.Frame.LayoutOrder=10+i
            entry.Rank.Text=string.format("%02d",i);serenityColor(entry.Rank,"TextColor3",tokens,i==1 and "Accent" or "TextMuted")
            entry.Name.Text=item.Name;entry.Rarity.Text=item.Rarity
            entry.Count.Text="×"..compact(item.Count);entry.Score.Text=compact(item.Score).." pts"
            if entry.Image.Image~=item.Image then entry.Image.Image=item.Image end
            entry.Fallback.Visible=item.Image=="" or not entry.Image.IsLoaded
            local colors={Mythic=tokens.Color.Lavender,Legendary=tokens.Color.Amber,Epic=tokens.Color.Pink,Rare=tokens.Color.Cyan,Common=tokens.Color.Mint}
            local color=colors[item.Rarity] or tokens.Color.Accent
            for _,pixel in ipairs(entry.Pixels) do pixel.BackgroundColor3=color end
            entry.Mark.Visible=self.Selected==item.Id;entry.Frame.BackgroundTransparency=entry.Mark.Visible and 0.25 or 0.65
            entry.Detail.Visible=entry.Mark.Visible
            if entry.Mark.Visible then
                entry.Detail.Text=item.Name.." · "..item.Rarity.."\nLocation: "..item.Location
                local width=math.max(100,root.AbsoluteSize.X/math.max(0.001,deps.UIScale and deps.UIScale.Scale or 1)-24)
                local measured=game:GetService("TextService"):GetTextSize(entry.Detail.Text,12,entry.Detail.Font,Vector2.new(width,10000))
                local height=math.ceil(measured.Y)+6
                entry.Detail.Size=UDim2.new(1,-24,0,height);entry.Frame.Size=UDim2.new(1,0,0,58+height+8)
            else entry.Frame.Size=UDim2.new(1,0,0,56) end
        end
        for i=shown+1,#self.Rows do self.Rows[i].Frame.Visible=false;self.Rows[i].Item=nil end
        more.Visible=shown<#ordered
    end
    function self:SetItems(items,demo)
        if deps.Runtime.Destroyed then return end
        self.Items=RankedPets.Normalize(items);self.Demo=demo==true;self.State="Ready";self.StateMessage=nil;self.UpdatedAt=os.time()
        local selected
        for _,item in ipairs(self.Items) do if item.Id==self.Selected then selected=item;break end end
        if not selected then self.Selected=nil end
        self:Render()
    end
    function self:SetState(state,message)
        if state~="Ready" and state~="Loading" and state~="Unavailable" then return false end
        self.State=state;self.StateMessage=message and tostring(message):sub(1,120) or nil;self:Render();return true
    end
    local previousWidth
    deps.Runtime:TrackConnection(root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if root.AbsoluteSize.X~=previousWidth then previousWidth=root.AbsoluteSize.X;if self.Selected then self:Render() end end
    end))
    search:GetPropertyChangedSignal("Text"):Connect(function() self.Query=search.Text;self.Limit=20;self:Render() end)
    sort.Activated:Connect(function()
        if serenityInputBlocked(sort) or self.State~="Ready" then return end
        self.Mode=({Score="Count",Count="Name",Name="Score"})[self.Mode];sort.Text=self.Mode..(self.Mode=="Name" and " A–Z" or " ↓")
        self:Render()
    end)
    more.Activated:Connect(function() if serenityInputBlocked(more) then return end;self.Limit=self.Limit+20;self:Render() end)
    self:Render()
    return self
end
return RankedPets
end)()

modules["src/renderers/Desktop.lua"] = (function()
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local Desktop = {}

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function makeDraggable(runtime, frame, handles)
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local dragging, press, start, pointer, ghost, target, glide
    runtime.DragStyle = "Outline"
    local function stopTween()
        if glide then glide:Cancel(); glide=nil end
    end
    local function destroyGhost()
        if ghost then ghost:Destroy();ghost=nil end
    end
    local function begin(input)
        if dragging or runtime.ModalActive or not frame.Visible or serenityInputBlocked(frame) then return end
        if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
        stopTween();destroyGhost()
        dragging=true;pointer=input;press=input.Position;start=frame.Position;target=start
    end
    for _,handle in ipairs(handles) do runtime:TrackConnection(handle.InputBegan:Connect(begin)) end
    runtime:TrackConnection(UIS.InputChanged:Connect(function(input)
        if runtime.ModalActive then dragging=false;pointer=nil;target=nil;destroyGhost();stopTween();return end
        if not dragging then return end
        if pointer.UserInputType==Enum.UserInputType.Touch then
            if input~=pointer then return end
        elseif input.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local delta=input.Position-press
        if delta.Magnitude<4 then return end
        local parentSize,size=frame.Parent.AbsoluteSize,frame.AbsoluteSize
        local x=start.X.Scale*parentSize.X+start.X.Offset+delta.X
        local y=start.Y.Scale*parentSize.Y+start.Y.Offset+delta.Y
        target=UDim2.fromOffset(x,y)
        local style=runtime.ReducedMotion and "Direct" or runtime.DragStyle
        if style=="Outline" then
            if not ghost then
                ghost=Instance.new("Frame");ghost.Name="SerenityDragPreview"
                ghost.AnchorPoint=Vector2.new(0.5,0.5);ghost.Size=UDim2.fromOffset(size.X,size.Y)
                ghost.BackgroundColor3=Color3.fromRGB(32,100,140);ghost.BackgroundTransparency=0.93
                ghost.ZIndex=200;ghost.Parent=frame.Parent;ghost.Active=false
                local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,14);c.Parent=ghost
                local stroke=Instance.new("UIStroke");stroke.Color=Color3.fromRGB(93,190,243)
                stroke.Transparency=0.18;stroke.Thickness=1.5;stroke.Parent=ghost
            end
            ghost.Position=target
        elseif style=="Smooth" then
            stopTween();glide=TweenService:Create(frame,TweenInfo.new(0.09,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=target});glide:Play()
        else stopTween();frame.Position=target end
    end))
    local function finish()
        if not dragging then return end
        dragging=false;pointer=nil;destroyGhost();stopTween()
        if target and not runtime.Destroyed and not runtime.ModalActive then
            if runtime.ReducedMotion or runtime.DragStyle=="Direct" then frame.Position=target
            else glide=TweenService:Create(frame,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=target});glide:Play() end
        end
    end
    runtime:TrackConnection(UIS.InputEnded:Connect(function(input)
        if dragging and (input==pointer or pointer.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1) then finish() end
    end))
    runtime:TrackConnection(UIS.WindowFocusReleased:Connect(finish))
    runtime:TrackConnection(frame:GetPropertyChangedSignal("Visible"):Connect(function() if not frame.Visible then finish() end end))
    runtime:TrackCleanup(function() dragging=false;destroyGhost();stopTween() end)
end

function Desktop.Mount(deps, options)
    options = options or {}
    local tokens = deps.Tokens
    local runtime = deps.Runtime
    local localPlayer = Players.LocalPlayer

    local parentGui
    pcall(function() if gethui then parentGui = gethui() end end)
    if not parentGui then pcall(function() parentGui = game:GetService("CoreGui") end) end
    if not parentGui then parentGui = localPlayer:WaitForChild("PlayerGui") end

    local screen = runtime:TrackInstance(Instance.new("ScreenGui"))
    screen.Name = options.Name or "SerenityNextM3"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999999
    screen.Parent = parentGui
    pcall(function() if protect_gui then protect_gui(screen) end end)

    local acrylic = deps.AcrylicEngine and deps.AcrylicEngine.new(runtime, {BasicBlur = options.BlurSize or 3}) or nil

    local holder = Instance.new("Frame")
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Position = UDim2.fromScale(0.5, 0.5)
    holder.Size = UDim2.fromOffset(tokens.Size.Window.X, tokens.Size.Window.Y)
    holder.BackgroundTransparency = 1
    holder.Parent = screen

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 1
    uiScale.Parent = holder

    local scalePending=false
    local function refreshScale()
        -- Keep an open picker stable while the mobile keyboard changes the viewport.
        local focused=UserInputService:GetFocusedTextBox()
        if focused and focused:IsDescendantOf(screen) then scalePending=true;return end
        scalePending=false
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
        local inset = GuiService:GetGuiInset()
        local touchLayout=UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or viewport.Y<600)
        if touchLayout then
            -- Keep a complete logical canvas, then fit all of it into the phone.
            -- Shrinking only the frame left desktop-size controls in a short viewport.
            local availableW=math.max(1,viewport.X-32)
            local availableH=math.max(1,viewport.Y-inset.Y-32)
            local scale=math.min(1.35,availableW*0.94/tokens.Size.Window.X,availableH*0.94/tokens.Size.Window.Y)
            local tablet=math.min(viewport.X,viewport.Y)>=600
            local width=tablet and 798 or (viewport.X<viewport.Y and 430 or 700)
            local height=tablet and 546 or 420
            scale=math.min(1.35,availableW*0.94/width,availableH*0.94/height)
            holder.Size=UDim2.fromOffset(width,height)
            uiScale.Scale=scale
        else
            uiScale.Scale = 1
            holder.Size = UDim2.fromOffset(math.min(tokens.Size.Window.X, math.max(320, viewport.X - 24)), math.min(tokens.Size.Window.Y, math.max(240, viewport.Y - inset.Y - 24)))
        end
        deps.PopupManager:Close()
    end
    runtime:TrackConnection(UserInputService.TextBoxFocusReleased:Connect(function()
        if scalePending then task.defer(function() if not runtime.Destroyed then refreshScale() end end) end
    end))
    local cameraConnection
    local function bindCamera()
        if cameraConnection then cameraConnection:Disconnect() end
        if workspace.CurrentCamera then
            cameraConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshScale)
        end
        refreshScale()
    end
    runtime:TrackConnection(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera))
    runtime:TrackCleanup(function() if cameraConnection then cameraConnection:Disconnect() end deps.PopupManager:Close() end)
    bindCamera()

    deps.Material.Shadow(holder, UDim2.fromScale(1, 1), tokens.Size.RadiusShell, tokens)

    local shell = Instance.new("Frame")
    shell.Name = "Shell"
    shell.Size = UDim2.fromScale(1, 1)
    shell.ClipsDescendants = true
    shell.ZIndex = 2
    shell.Parent = holder
    deps.Material.Shell(shell, tokens)

    deps.WindowFrame = shell
    deps.UIScale = uiScale

    -- LEFT SIDEBAR ------------------------------------------------------------
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Position = UDim2.fromOffset(0, tokens.Size.Topbar)
    sidebar.Size = UDim2.new(0, tokens.Size.Sidebar, 1, -tokens.Size.Topbar)
    sidebar.ZIndex = 3
    sidebar.Parent = shell
    deps.Material.Sidebar(sidebar, tokens)
    corner(sidebar,tokens.Size.RadiusShell)

    local brand = Instance.new("Frame")
    brand.BackgroundTransparency = 1
    brand.Size = UDim2.new(1, 0, 0, tokens.Size.SidebarBrand)
    brand.ZIndex = 4
    brand.Parent = sidebar
    brand.Visible = false

    local logoWrap = Instance.new("Frame")
    logoWrap.Position = UDim2.fromOffset(14, 14)
    logoWrap.Size = UDim2.fromOffset(38, 38)
    serenityColor(logoWrap,"BackgroundColor3",tokens,"Inset")
    logoWrap.BackgroundTransparency = 0.05
    logoWrap.BorderSizePixel = 0
    logoWrap.ZIndex = 5
    logoWrap.Parent = brand
    corner(logoWrap, 9)

    local logo = Instance.new("ImageLabel")
    logo.BackgroundTransparency = 1
    logo.Position = UDim2.fromOffset(5, 5)
    logo.Size = UDim2.fromOffset(28, 28)
    logo.Image = "rbxthumb://type=Asset&id=89023606689629&w=420&h=420"
    logo.ScaleType = Enum.ScaleType.Fit
    logo.ZIndex = 6
    logo.Parent = logoWrap

    deps.Typography.Label(brand, "Brand", tokens, options.Title or "SERENITY HUB", UDim2.fromOffset(63, 12), UDim2.new(1, -70, 0, 21), tokens.Color.Text,"Text").ZIndex = 5
    local brandSub = deps.Typography.Label(brand, "BrandSub", tokens, options.Subtitle or "Interface Prototype", UDim2.fromOffset(63, 34), UDim2.new(1, -70, 0, 16), tokens.Color.TextDim,"TextDim")
    brandSub.ZIndex = 5

    local navHolder = Instance.new("ScrollingFrame")
    navHolder.Name = "Navigation"
    navHolder.BackgroundTransparency = 1
    navHolder.BorderSizePixel = 0
    navHolder.Position = UDim2.fromOffset(11, tokens.Size.SidebarBrand)
    navHolder.Size = UDim2.new(1, -22, 1, -(tokens.Size.SidebarBrand + tokens.Size.SidebarUser + 8))
    navHolder.CanvasSize = UDim2.new()
    navHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    navHolder.ScrollBarThickness = 0
    navHolder.ZIndex = 4
    navHolder.Parent = sidebar

    local navList = Instance.new("UIListLayout")
    navList.Padding = UDim.new(0, 2)
    navList.SortOrder = Enum.SortOrder.LayoutOrder
    navList.Parent = navHolder

    local userFrame = Instance.new("TextButton")
    userFrame.Name = "UserContext"
    userFrame.AnchorPoint = Vector2.new(0, 1)
    userFrame.Position = UDim2.new(0, 11, 1, -10)
    userFrame.Size = UDim2.new(1, -22, 0, tokens.Size.SidebarUser - 8)
    serenityColor(userFrame,"BackgroundColor3",tokens,"PanelSoft")
    userFrame.BackgroundTransparency = 0.62
    userFrame.BorderSizePixel = 0
    userFrame.Text = ""
    userFrame.AutoButtonColor = false
    userFrame.ZIndex = 5
    userFrame.Parent = sidebar
    corner(userFrame, 8)

    local avatar = Instance.new("ImageLabel")
    serenityColor(avatar,"BackgroundColor3",tokens,"Inset")
    avatar.BorderSizePixel = 0
    avatar.Position = UDim2.fromOffset(10, 13)
    avatar.Size = UDim2.fromOffset(34, 34)
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(localPlayer.UserId) .. "&w=150&h=150"
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.ZIndex = 6
    avatar.Parent = userFrame
    corner(avatar, 17)

    local userNameLabel=deps.Typography.Label(userFrame, "User", tokens, localPlayer.DisplayName, UDim2.fromOffset(54, 11), UDim2.new(1, -78, 0, 19), tokens.Color.Text,"Text")
    userNameLabel.ZIndex = 6
    deps.Typography.Label(userFrame, "UserSub", tokens, "UI TESTER", UDim2.fromOffset(54, 31), UDim2.new(1, -78, 0, 16), tokens.Color.TextDim,"TextDim").ZIndex = 6
    local userChevron = deps.Icons.Create(userFrame, "chevron_right", 13, tokens.Color.TextDim)
    userChevron.AnchorPoint = Vector2.new(1, 0.5)
    userChevron.Position = UDim2.new(1, -10, 0.5, 0)
    userChevron.ZIndex = 6

    -- RIGHT TOPBAR ------------------------------------------------------------
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Position = UDim2.fromOffset(0, 0)
    topbar.Size = UDim2.new(1, 0, 0, tokens.Size.Topbar)
    topbar.ZIndex = 3
    topbar.Parent = shell
    deps.Material.Topbar(topbar, tokens)
    corner(topbar,tokens.Size.RadiusShell)

    local saveTile = Instance.new("Frame")
    saveTile.Position = UDim2.fromOffset(15, 15)
    saveTile.Size = UDim2.fromOffset(32, 32)
    serenityColor(saveTile,"BackgroundColor3",tokens,"Inset")
    saveTile.BackgroundTransparency = 0.10
    saveTile.BorderSizePixel = 0
    saveTile.ZIndex = 4
    saveTile.Parent = topbar
    corner(saveTile, 7)
    local saveIcon = deps.Icons.Create(saveTile, "save", 15, tokens.Color.TextMuted)
    saveIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    saveIcon.Position = UDim2.fromScale(0.5, 0.5)
    saveIcon.ZIndex = 5

    local function createTopSelect(x, width, initial)
        local button = Instance.new("TextButton")
        button.Position = UDim2.fromOffset(x, 13)
        button.Size = UDim2.fromOffset(width, 36)
        serenityColor(button,"BackgroundColor3",tokens,"Inset")
        button.BackgroundTransparency = 0.34
        button.BorderSizePixel = 0
        button.Text = ""
        button.AutoButtonColor = false
        button.ZIndex = 4
        button.Parent = topbar
        corner(button, 7)

        local text = deps.Typography.Label(button, "TopSelect", tokens, initial, UDim2.fromOffset(12, 0), UDim2.new(1, -34, 1, 0), tokens.Color.TextMuted,"TextMuted")
        text.ZIndex = 5
        local chevron = deps.Icons.Create(button, "chevron_down", 12, tokens.Color.TextDim)
        chevron.AnchorPoint = Vector2.new(1, 0.5)
        chevron.Position = UDim2.new(1, -10, 0.5, 0)
        chevron.ZIndex = 5
        return button, text
    end

    saveTile.Visible = false
    local pageButton, pageText = createTopSelect(252, 112, "Dashboard")
    local star = deps.Material.PixelStar(topbar, UDim2.fromOffset(20, 16), 5)
    local heading = deps.Typography.Label(topbar, "Brand", tokens, "SERENITY HUB", UDim2.fromOffset(62, 0), UDim2.fromOffset(182, tokens.Size.Topbar), tokens.Color.Text,"Text")
    heading.Font = Enum.Font.GothamBold
    heading.TextSize = 19
    heading.ZIndex = 5
    local scopeButton, scopeText = createTopSelect(170, 108, "Global")
    scopeButton.Visible = false

    local searchButton = Instance.new("TextButton")
    searchButton.AnchorPoint = Vector2.new(1, 0.5)
    searchButton.Position = UDim2.new(1, -51, 0.5, 0)
    searchButton.Size = UDim2.fromOffset(34, 34)
    searchButton.BackgroundTransparency = 1
    searchButton.Text = ""
    searchButton.AutoButtonColor = false
    searchButton.ZIndex = 4
    searchButton.Parent = topbar
    local searchIcon = deps.Icons.Create(searchButton, "search", 17, tokens.Color.TextMuted)
    searchIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    searchIcon.Position = UDim2.fromScale(0.5, 0.5)
    searchIcon.ZIndex = 5

    -- CONTENT -----------------------------------------------------------------
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.fromOffset(tokens.Size.Sidebar + 14, tokens.Size.Topbar + 10)
    content.Size = UDim2.new(1, -(tokens.Size.Sidebar + 28), 1, -(tokens.Size.Topbar + 22))
    content.ZIndex = 3
    content.Parent = shell

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.ZIndex = 70
    overlay.Parent = shell
    deps.PopupHost = overlay
    local shield=Instance.new("TextButton")
    shield.Name="PopupInputShield";shield.Text="";shield.AutoButtonColor=false
    shield.BackgroundColor3=Color3.new(0,0,0);shield.BackgroundTransparency=0.75
    shield.Size=UDim2.fromScale(1,1);shield.ZIndex=71;shield.Visible=false
    shield.Active=true;shield.Parent=overlay
    shield.Activated:Connect(function() if serenityInputBlocked(shield) then return end; deps.PopupManager:Close() end)
    local lockedScrollers={}
    deps.PopupManager.OnChange=function(active)
        for frame,enabled in pairs(lockedScrollers) do
            if frame.Parent then frame.ScrollingEnabled=enabled end
        end
        table.clear(lockedScrollers)
        shield.Visible=active~=nil
        for _,child in ipairs(shell:GetChildren()) do
            if child:IsA("GuiObject") and child~=overlay then
                child:SetAttribute("SerenityPopupBlocked",active~=nil)
            end
        end
        if active then
            for _,frame in ipairs(shell:GetDescendants()) do
                if frame:IsA("ScrollingFrame") and not frame:IsDescendantOf(active) then
                    lockedScrollers[frame]=frame.ScrollingEnabled
                    frame.ScrollingEnabled=false
                end
            end
        end
    end
    -- Edge treatment sits above the surfaces, without a shadow image.
    local rim=Instance.new("Frame")
    rim.Name="GlassRim"
    rim.BackgroundTransparency=1
    rim.Size=UDim2.new(1,-4,1,-4)
    rim.Position=UDim2.fromOffset(2,2)
    rim.ZIndex=69
    rim.Parent=shell
    corner(rim,tokens.Size.RadiusShell-2)
    local edge=Instance.new("UIStroke")
    edge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    serenityColor(edge,"Color",tokens,"Stroke")
    edge.Thickness=1.4
    edge.Transparency=0.22
    edge.Parent=rim
    local edgeFade=Instance.new("UIGradient")
    edgeFade.Rotation=65
    edgeFade.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.05),
        NumberSequenceKeypoint.new(0.45,0.65),
        NumberSequenceKeypoint.new(1,0.12)
    })
    edgeFade.Parent=edge

    makeDraggable(runtime, holder, {topbar, heading})

    local pages = {}
    local navItems = {}
    local groups = {}
    local currentPage

    local app = {
        ScreenGui = screen,
        Holder = holder,
        Shell = shell,
        Sidebar = sidebar,
        Content = content,
        Overlay = overlay,
        Pages = pages,
        SearchButton = searchButton,
        PageButton = pageButton,
        ScopeButton = scopeButton,
        Acrylic = acrylic,
        ProfileButton = userFrame,
        IdentityAvatar = avatar,
        IdentityName = userNameLabel,
    }

    local function addGroupLabel(name, order)
        if not name or name == "" or groups[name] then return end
        groups[name] = true
        local label = deps.Typography.Label(navHolder, "NavGroup", tokens, string.upper(name), UDim2.new(), UDim2.new(1, 0, 0, tokens.Size.NavGroup), tokens.Color.TextDim,"TextDim")
        label.LayoutOrder = order
        label.TextYAlignment = Enum.TextYAlignment.Bottom
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 3)
        pad.Parent = label
    end

    function app:AddPage(props)
        props = props or {}
        local id = props.Id or props.Title
        local accent = props.Accent or tokens.Color.Accent
        local order = (props.Order or (#navItems + 1)) + 4

        if props.Group then addGroupLabel(props.Group, order * 10 - 1) end

        local page = Instance.new("ScrollingFrame")
        page.Name = id
        page.Visible = false
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.Size = UDim2.fromScale(1, 1)
        page.CanvasSize = UDim2.new()
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = accent
        page.ScrollBarImageTransparency = 0.56
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.Parent = content
        runtime:TrackConnection(page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if app.OnViewChanged then app.OnViewChanged() end
        end))

        local padding = Instance.new("UIPadding")
        padding.PaddingRight = UDim.new(0, 5)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.Parent = page

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 10)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = page

        local navItem = deps.NavItem.new(navHolder, deps, {
            Id = id,
            Title = props.Title or id,
            Icon = props.Icon or "info",
            Accent = accent,
            Order = order * 10,
            Callback = function() app:SelectPage(id) end,
        })

        local entry = {Id = id, Page = page, NavItem = navItem, Accent = accent, Title = props.Title or id}
        pages[id] = entry
        table.insert(navItems, entry)

        if not currentPage then app:SelectPage(id) end
        return page
    end

    function app:SelectPage(id)
        local target = pages[id]
        if not target then return end
        deps.PopupManager:Close()
        local changed=currentPage~=id
        currentPage = id
        if app.OnViewChanged then app.OnViewChanged() end
        pageText.Text = target.Title
        for pageId, entry in pairs(pages) do
            local selected = pageId == id
            if entry.Transition then entry.Transition:Cancel();entry.Transition=nil end
            entry.Page.Position=UDim2.fromOffset(0,0)
            entry.Page.Visible = selected
            entry.NavItem:SetSelected(selected)
            if selected and changed and not deps.Motion.Reduced then
                entry.Page.Position=UDim2.fromOffset(0,4)
                entry.Transition=deps.Motion:Tween(entry.Page,"Select",{Position=UDim2.fromOffset(0,0)})
            end
        end
    end

    function app:GetViewState()
        local positions={}
        for id,entry in pairs(pages) do positions[id]=entry.Page.CanvasPosition.Y end
        return {Page=currentPage,Positions=positions}
    end
    function app:RestoreViewState(view)
        if type(view)~="table" then return end
        if type(view.Page)=="string" and pages[view.Page] then self:SelectPage(view.Page) end
        task.defer(function()
            if runtime.Destroyed then return end
            if type(view.Positions)~="table" then return end
            for id,y in pairs(view.Positions) do
                local entry=pages[id]
                if entry and type(y)=="number" and y==y and math.abs(y)<1000000 then
                    local maximum=math.max(0,entry.Page.AbsoluteCanvasSize.Y-entry.Page.AbsoluteWindowSize.Y)
                    entry.Page.CanvasPosition=Vector2.new(0,math.clamp(y,0,maximum))
                end
            end
        end)
    end
    runtime:TrackCleanup(function()
        deps.PopupManager:Close()
        for _,entry in pairs(pages) do if entry.Transition then entry.Transition:Cancel() end end
    end)
    function app:SetGlassQuality(quality)
        if acrylic then acrylic:SetQuality(quality) end
    end

    function app:SetBlur(enabled)
        if acrylic then acrylic:SetEnabled(enabled) end
    end

    function app:SetVisible(visible)
        deps.PopupManager:Close()
        holder.Visible = visible
        if acrylic then acrylic:SetVisible(visible) end
    end

    local minimize = Instance.new("TextButton")
    minimize.Size = UDim2.fromOffset(28, 28)
    minimize.Position = UDim2.new(1, -40, 0.5, -14)
    minimize.BackgroundTransparency = 1
    minimize.Text = "−"
    minimize.TextSize = 24
    serenityColor(minimize,"TextColor3",tokens,"TextMuted")
    minimize.ZIndex = 5
    minimize.Parent = topbar
    local restore = Instance.new("TextButton")
    restore.Name = "SerenityRestore"
    restore.Size = UDim2.fromOffset(44, 44)
    restore.Position = UDim2.new(0, 12, 0.5, -25.41)
    restore.Text = ""
    restore.AutoButtonColor = false
    restore.BorderSizePixel = 0
    serenityColor(restore,"BackgroundColor3",tokens,"Inset")
    restore.Visible = true
    restore.ZIndex = 90
    restore.Parent = screen
    local restoreScale=Instance.new("UIScale");restoreScale.Scale=1.155;restoreScale.Parent=restore
    corner(restore, 12)
    local restoreEdge=Instance.new("UIStroke");restoreEdge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    serenityColor(restoreEdge,"Color",tokens,"Lavender");restoreEdge.Transparency=0.65;restoreEdge.Thickness=1;restoreEdge.Parent=restore
    local tileSheen=Instance.new("UIGradient");tileSheen.Rotation=65
    tileSheen.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(165,165,165));tileSheen.Parent=restore
    local emblem=Instance.new("Frame");emblem.Name="CelestialEmblem"
    emblem.ZIndex=91;emblem.BackgroundTransparency=1;emblem.AnchorPoint=Vector2.new(0.5,0.5)
    emblem.Position=UDim2.fromScale(0.5,0.5);emblem.Size=UDim2.fromOffset(44,44);emblem.Parent=restore
    local emblemScale=Instance.new("UIScale");emblemScale.Parent=emblem
    local restoreStar=deps.Material.Star(emblem,UDim2.fromOffset(22,22),30,tokens.Color.Text,92)
    restoreStar.AnchorPoint=Vector2.new(0.5,0.5)
    local idleScale=Instance.new("UIScale");idleScale.Parent=restoreStar
    local idleTween
    function app:RefreshIconMotion()
        if self.RefreshBrandMotion then self:RefreshBrandMotion() end
        if idleTween then idleTween:Cancel();idleTween=nil end
        idleScale.Scale=1
        if not deps.Motion.Reduced and not runtime.Destroyed and not self.MotionSuspended then
            idleTween=game:GetService("TweenService"):Create(idleScale,TweenInfo.new(1.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Scale=1.045})
            idleTween:Play()
        end
    end
    runtime:TrackCleanup(function() if idleTween then idleTween:Cancel();idleTween=nil end end)
    app:RefreshIconMotion()
    local glint=Instance.new("Frame");glint.Name="TileHighlight"
    glint.Size=UDim2.new(1,-22,0,1);glint.Position=UDim2.fromOffset(11,2)
    glint.ZIndex=91;serenityColor(glint,"BackgroundColor3",tokens,"Text");glint.BackgroundTransparency=0.82;glint.BorderSizePixel=0;glint.Parent=restore
    local statusDock=Instance.new("TextButton")
    statusDock.Name="SerenityStatusDock"
    statusDock.AnchorPoint=Vector2.new(0.5,0)
    statusDock.Position=UDim2.new(0.5,0,0,8)
    statusDock.Size=UDim2.fromOffset(0,52)
    statusDock.BackgroundColor3=tokens.Color.ShellDeep:Lerp(Color3.new(0,0,0),0.6)
    statusDock.BackgroundTransparency=1
    statusDock.BorderSizePixel=0;statusDock.Text=""
    statusDock.AutoButtonColor=false;statusDock.ClipsDescendants=true
    statusDock.Visible=false;statusDock.ZIndex=88;statusDock.Parent=screen
    corner(statusDock,24)
    local statusBody=Instance.new("Frame");statusBody.Name="StatusBody"
    statusBody.Position=UDim2.fromOffset(46,0);statusBody.Size=UDim2.new(1,-46,1,0)
    statusBody.BackgroundColor3=statusDock.BackgroundColor3;statusBody.BorderSizePixel=0
    statusBody.ZIndex=88;statusBody.Parent=statusDock;corner(statusBody,22)
    local dockEdge=Instance.new("UIStroke");serenityColor(dockEdge,"Color",tokens,"Stroke")
    dockEdge.Transparency=0.72;dockEdge.Parent=statusBody
    -- Compact live activity: one title, one metric line, and a quiet activity glyph.
    local statusRow=Instance.new("CanvasGroup")
    statusRow.BackgroundTransparency=1;statusRow.Position=UDim2.fromOffset(46,0);statusRow.Size=UDim2.new(1,-46,1,0)
    statusRow.ZIndex=89;statusRow.Parent=statusDock
    local activityTile=Instance.new("Frame")
    activityTile.Name="StatusActivityOrb"
    activityTile.BackgroundColor3=statusDock.BackgroundColor3;activityTile.BackgroundTransparency=0
    activityTile.BorderSizePixel=0;activityTile.Size=UDim2.fromOffset(44,44)
    activityTile.AnchorPoint=Vector2.new(0.5,0.5);activityTile.Position=UDim2.fromOffset(22,26);activityTile.ZIndex=90;activityTile.Parent=statusDock
    corner(activityTile,22)
    local orbEdge=Instance.new("UIStroke");serenityColor(orbEdge,"Color",tokens,"Accent")
    orbEdge.Transparency=0.55;orbEdge.Thickness=1;orbEdge.Parent=activityTile
    local orbInset=Instance.new("Frame");serenityColor(orbInset,"BackgroundColor3",tokens,"Accent")
    orbInset.BackgroundTransparency=0.93;orbInset.BorderSizePixel=0
    orbInset.Size=UDim2.new(1,-12,1,-12);orbInset.Position=UDim2.fromOffset(6,6)
    orbInset.ZIndex=90;orbInset.Parent=activityTile;corner(orbInset,17)
    local activityBars={}
    for i=1,4 do
        local bar=Instance.new("Frame");bar.BorderSizePixel=0
        serenityColor(bar,"BackgroundColor3",tokens,"Accent");bar.AnchorPoint=Vector2.new(0,0.5)
        bar.Position=UDim2.new(0.5,-9+(i-1)*5,0.5,0);bar.Size=UDim2.fromOffset(3,6+i*2)
        bar.ZIndex=91;bar.Parent=activityTile;corner(bar,2);activityBars[i]=bar
    end
    local dockActivity=deps.Typography.Label(statusRow,"Control",tokens,"Ride A Pet",UDim2.fromOffset(14,7),UDim2.new(1,-65,0,19),tokens.Color.Text,"Text")
    dockActivity.TextSize=13;dockActivity.Font=Enum.Font.GothamSemibold
    dockActivity.TextTruncate=Enum.TextTruncate.AtEnd;dockActivity.ZIndex=90
    local dockMetrics=deps.Typography.Label(statusRow,"Control",tokens,"0 clicks  ·  0 rewards",UDim2.fromOffset(14,27),UDim2.new(1,-50,0,16),tokens.Color.TextMuted,"TextMuted")
    dockMetrics.TextSize=11;dockMetrics.ZIndex=90;dockMetrics.TextTruncate=Enum.TextTruncate.AtEnd
    local dockTime=deps.Typography.Label(statusRow,"Control",tokens,"0s",UDim2.new(1,-52,0,8),UDim2.fromOffset(37,17),tokens.Color.Accent,"Accent")
    dockTime.TextSize=11;dockTime.TextXAlignment=Enum.TextXAlignment.Right;dockTime.ZIndex=90
    local statusEvent=Instance.new("CanvasGroup");statusEvent.GroupTransparency=1;statusEvent.BackgroundTransparency=1
    statusEvent.Position=UDim2.fromOffset(46,0);statusEvent.Size=UDim2.new(1,-46,1,0);statusEvent.Visible=false;statusEvent.ZIndex=89;statusEvent.Parent=statusDock
    local eventIcon=deps.Icons.Create(activityTile,"inventory",20,tokens.Color.Mint,UDim2.fromOffset(22,22));eventIcon.ZIndex=92
    eventIcon.AnchorPoint=Vector2.new(0.5,0.5);eventIcon.Position=UDim2.fromScale(0.5,0.5);eventIcon.Visible=false
    local restingGlyph=Instance.new("Frame");restingGlyph.BackgroundTransparency=1
    restingGlyph.Size=UDim2.fromOffset(22,22);restingGlyph.AnchorPoint=Vector2.new(0.5,0.5)
    restingGlyph.Position=UDim2.fromScale(0.5,0.5);restingGlyph.ZIndex=92
    restingGlyph.Visible=false;restingGlyph.Parent=activityTile
    local glyphParts={}
    for i=1,2 do
        local part=Instance.new("Frame");part.BorderSizePixel=0;serenityColor(part,"BackgroundColor3",tokens,"Accent")
        part.ZIndex=92;part.Parent=restingGlyph;glyphParts[i]=part;corner(part,1)
    end
    local eventTitle=deps.Typography.Label(statusEvent,"Control",tokens,"",UDim2.fromOffset(14,10),UDim2.new(1,-28,0,21),tokens.Color.Text,"Text")
    eventTitle.Font=Enum.Font.GothamBold;eventTitle.TextSize=14;eventTitle.ZIndex=90
    local eventBody=deps.Typography.Label(statusEvent,"Control",tokens,"",UDim2.fromOffset(14,36),UDim2.new(1,-28,0,30),tokens.Color.TextMuted,"TextMuted")
    eventBody.TextSize=12;eventBody.TextWrapped=true;eventBody.TextYAlignment=Enum.TextYAlignment.Top;eventBody.ZIndex=90
    local statusExpanded=false
    local statusDetails={"No active task", "Start a demo from Playground"}
    local details=Instance.new("Frame");details.BackgroundTransparency=1
    details.Position=UDim2.fromOffset(14,56);details.Size=UDim2.new(1,-28,0,60)
    details.Visible=false;details.ZIndex=90;details.Parent=statusRow
    local detailText=deps.Typography.Label(details,"Control",tokens,table.concat(statusDetails,"\n"),UDim2.fromOffset(0,0),UDim2.new(1,0,0,37),tokens.Color.TextMuted,"TextMuted")
    detailText.TextSize=12;detailText.TextWrapped=true;detailText.TextYAlignment=Enum.TextYAlignment.Top;detailText.ZIndex=91
    local detailRestore=Instance.new("TextButton");detailRestore.Size=UDim2.fromOffset(96,23)
    detailRestore.Position=UDim2.new(1,-96,0,37);detailRestore.Text="Open main UI  ›";detailRestore.TextSize=11
    detailRestore.Font=Enum.Font.GothamMedium;serenityColor(detailRestore,"TextColor3",tokens,"Accent")
    detailRestore.BackgroundTransparency=1;detailRestore.AutoButtonColor=false
    detailRestore.ZIndex=92;detailRestore.Parent=details
    local detailToggle=Instance.new("TextButton");detailToggle.Text="";detailToggle.BackgroundTransparency=1
    detailToggle.Size=UDim2.fromOffset(30,25);detailToggle.Position=UDim2.new(1,-37,0,23)
    detailToggle.ZIndex=92;detailToggle.Parent=statusRow;detailToggle.AutoButtonColor=false
    local chevron=Instance.new("Frame");chevron.BackgroundTransparency=1;chevron.Size=UDim2.fromOffset(10,6)
    chevron.Position=UDim2.fromOffset(10,9);chevron.ZIndex=93;chevron.Parent=detailToggle
    for i=1,2 do
        local bar=Instance.new("Frame");bar.BorderSizePixel=0;bar.Size=UDim2.fromOffset(6,2)
        bar.Position=UDim2.fromOffset((i-1)*4,2);bar.Rotation=i==1 and 40 or -40
        serenityColor(bar,"BackgroundColor3",tokens,"TextMuted");bar.ZIndex=93;bar.Parent=chevron
    end
    dockMetrics.Size=UDim2.new(1,-50,0,16)
    local progressTrack=Instance.new("Frame");progressTrack.Name="StatusProgress"
    serenityColor(progressTrack,"BackgroundColor3",tokens,"Stroke");progressTrack.BackgroundTransparency=0.83
    progressTrack.BorderSizePixel=0;progressTrack.Position=UDim2.new(0,14,0,47)
    progressTrack.Size=UDim2.new(1,-28,0,2);progressTrack.Visible=false
    progressTrack.ZIndex=90;progressTrack.Parent=statusRow;corner(progressTrack,1)
    local progressFill=Instance.new("Frame");progressFill.BorderSizePixel=0
    serenityColor(progressFill,"BackgroundColor3",tokens,"Accent");progressFill.BackgroundTransparency=0.18
    progressFill.Size=UDim2.fromScale(0,1);progressFill.ZIndex=91;progressFill.Parent=progressTrack
    corner(progressFill,1)
    local progressTween
    function app:SetStatusProgress(value)
        if runtime.Destroyed then return end
        if progressTween then progressTween:Cancel();progressTween=nil end
        local number=tonumber(value)
        if not number or number~=number then progressTrack.Visible=false;return end
        progressTrack.Visible=true
        local target=UDim2.fromScale(math.clamp(number,0,1),1)
        if statusDock.Visible and not deps.Motion.Reduced then
            progressTween=deps.Motion:Tween(progressFill,0.2,{Size=target})
        else progressFill.Size=target end
    end
    function app:SetStatusSummary(summary,time)
        if runtime.Destroyed then return end
        dockMetrics.Text=tostring(summary or ""):sub(1,120)
        dockTime.Text=tostring(time or ""):sub(1,12)
    end
    runtime:TrackCleanup(function() if progressTween then progressTween:Cancel();progressTween=nil end end)
    function app:SetStatusDetails(lines)
        assert(type(lines)=="table","SetStatusDetails expects an array of strings")
        statusDetails={}
        for i=1,math.min(2,#lines) do statusDetails[i]=tostring(lines[i]):sub(1,95) end
        detailText.Text=table.concat(statusDetails,"\n")
    end
    local statusNoticeActive=false
    local statusNoticeTimer
    local statusRunning=true
    local statusComplete=false
    local function refreshActivityGlyph()
        for _,bar in ipairs(activityBars) do bar.Visible=statusRunning and not statusNoticeActive end
        eventIcon.Visible=statusNoticeActive
        restingGlyph.Visible=not statusRunning and not statusNoticeActive
        if statusComplete then
            glyphParts[1].Position=UDim2.fromOffset(3,12);glyphParts[1].Size=UDim2.fromOffset(7,3);glyphParts[1].Rotation=45
            glyphParts[2].Position=UDim2.fromOffset(8,9);glyphParts[2].Size=UDim2.fromOffset(12,3);glyphParts[2].Rotation=-45
        else
            for i,part in ipairs(glyphParts) do
                part.Position=UDim2.fromOffset(5+(i-1)*8,5);part.Size=UDim2.fromOffset(3,12);part.Rotation=0
            end
        end
    end
    function app:SetStatus(value,stage)
        local text=tostring(value or "Ride A Pet · Ready")
        dockActivity.Text=text:sub(1,80)
        statusComplete=stage==3
        statusRunning=not statusComplete and not (text:lower():find("paused",1,true) or text:lower():find("idle",1,true))
        refreshActivityGlyph()
        if statusComplete then self:SetStatusProgress(nil) end
        if not statusRunning then
            for _,bar in ipairs(activityBars) do deps.Motion:Tween(bar,0.15,{Size=UDim2.fromOffset(3,4)}) end
        end
    end
    function app:SetStatusMetrics(clicks,seconds,rewards)
        dockMetrics.Text=tostring(clicks or 0).." clicks  ·  "..tostring(rewards or 0).." rewards"
        dockTime.Text=tostring(seconds or 0).."s"
        -- Reuse the bounded demo's updates; no perpetual animation or render loop.
        if statusRunning and statusDock.Visible and not statusNoticeActive and not deps.Motion.Reduced then
            for i,bar in ipairs(activityBars) do
                deps.Motion:Tween(bar,0.18,{Size=UDim2.fromOffset(3,5+((math.floor(clicks or 0)+i*3)%12))})
            end
        end
    end
    function app:IsMinimized() return not holder.Visible or self._Minimizing==true end
    local windowTween,windowScaleTween,dockTween,transition= nil,nil,nil,0
    local expandedPosition,expandedScale=holder.Position,uiScale.Scale
    local function cancelTransition()
        if windowTween then windowTween:Cancel();windowTween=nil end
        if windowScaleTween then windowScaleTween:Cancel();windowScaleTween=nil end
        if dockTween then dockTween:Cancel();dockTween=nil end
    end
    local function iconCenter()
        return UDim2.fromOffset(statusDock.AbsolutePosition.X-screen.AbsolutePosition.X+statusDock.AbsoluteSize.X/2,statusDock.AbsolutePosition.Y-screen.AbsolutePosition.Y+statusDock.AbsoluteSize.Y/2)
    end
    local function dockSize()
        return UDim2.fromOffset(math.min((statusNoticeActive or statusExpanded) and 316 or 272,math.max(120,screen.AbsoluteSize.X-24)),statusNoticeActive and 78 or (statusExpanded and 120 or 52))
    end
    -- Compact: 2px separation. Expanded/event: merge into one fluid capsule.
    local shapeTweens={}
    local function shape(object,props)
        if shapeTweens[object] then shapeTweens[object]:Cancel() end
        shapeTweens[object]=deps.Motion:Tween(object,0.24,props,Enum.EasingStyle.Quint)
    end
    local function syncStatusShape()
        local joined=statusExpanded or statusNoticeActive
        local inset=joined and 0 or 46
        shape(statusBody,{Position=UDim2.fromOffset(inset,0),Size=UDim2.new(1,-inset,1,0)})
        shape(orbEdge,{Transparency=joined and 0.86 or 0.68})
        shape(activityTile,{Position=UDim2.fromOffset(joined and 29 or 22,joined and 29 or 26),Size=UDim2.fromOffset(joined and 40 or 44,joined and 40 or 44),BackgroundTransparency=joined and 0.55 or 0})
        statusRow.Visible=true;statusEvent.Visible=true
        shape(statusRow,{GroupTransparency=statusNoticeActive and 1 or 0})
        shape(statusEvent,{GroupTransparency=statusNoticeActive and 0 or 1})
        detailToggle.Visible=not statusNoticeActive
        details.Visible=statusExpanded and not statusNoticeActive
        refreshActivityGlyph()
    end
    runtime:TrackCleanup(function() for _,tween in pairs(shapeTweens) do tween:Cancel() end;table.clear(shapeTweens) end)
    local function expandStatus(value)
        statusExpanded=value;syncStatusShape();deps.Motion:Tween(chevron,0.16,{Rotation=value and 180 or 0})
        if statusDock.Visible then
            if dockTween then dockTween:Cancel() end
            dockTween=deps.Motion:Tween(statusDock,0.22,{Size=dockSize()},Enum.EasingStyle.Quint)
        end
    end
    detailToggle.Activated:Connect(function() expandStatus(not statusExpanded) end)
    detailRestore.Activated:Connect(function() app:SetVisible(true) end)
    local petsShortcut=Instance.new("TextButton");petsShortcut.BackgroundTransparency=1
    petsShortcut.Text="Server pets  ›";petsShortcut.TextSize=11;petsShortcut.Font=Enum.Font.GothamMedium
    serenityColor(petsShortcut,"TextColor3",tokens,"Accent");petsShortcut.Size=UDim2.fromOffset(90,23)
    petsShortcut.Position=UDim2.fromOffset(0,37);petsShortcut.ZIndex=92;petsShortcut.Parent=details
    petsShortcut.Activated:Connect(function() app:SetVisible(true);app:SelectPage("Server") end)

    function app:StatusNotice(title,message,duration)
        if runtime.Destroyed then return end
        if statusNoticeTimer then pcall(task.cancel,statusNoticeTimer) end
        statusNoticeActive=true;statusRow.Visible=false;dockActivity.Visible=false;statusEvent.Visible=true
        eventTitle.Text=tostring(title or "Update"):sub(1,60)
        eventBody.Text=tostring(message or ""):sub(1,140)
        local function resize()
            syncStatusShape()
            if statusDock.Visible then
                if dockTween then dockTween:Cancel() end
                dockTween=deps.Motion:Tween(statusDock,0.24,{Size=dockSize()},Enum.EasingStyle.Quint)
            end
        end
        resize()
        statusNoticeTimer=task.delay(math.clamp(tonumber(duration) or 3,1,10),function()
            statusNoticeTimer=nil
            if runtime.Destroyed then return end
            statusNoticeActive=false;statusEvent.Visible=false;statusRow.Visible=true;dockActivity.Visible=true
            resize()
        end)
    end
    runtime:TrackCleanup(function() if statusNoticeTimer then pcall(task.cancel,statusNoticeTimer) end end)
    local function showDock()
        syncStatusShape()
        statusDock.Visible=true
        if app.OnMinimized then app.OnMinimized() end
        statusDock.Size=UDim2.fromOffset(0,52)
        if deps.Motion.Reduced then statusDock.Size=dockSize();return end
        dockTween=game:GetService("TweenService"):Create(statusDock,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=dockSize()})
        dockTween:Play()
    end
    function app:SetVisible(visible)
        if runtime.Destroyed then return end
        visible=visible==true
        transition=transition+1
        local current=transition
        cancelTransition()
        expandStatus(false)
        deps.PopupManager:Close()
        if visible then
            self._Minimizing=false
            if not holder.Visible and math.abs(uiScale.Scale-expandedScale)>0.001 then
                -- An orientation or viewport change recalculated the hidden window size.
                expandedPosition=holder.Position;expandedScale=uiScale.Scale
            end
            if statusDock.Visible then
                if deps.Motion.Reduced then statusDock.Visible=false
                else
                    dockTween=game:GetService("TweenService"):Create(statusDock,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.fromOffset(0,52)})
                    dockTween:Play()
                    dockTween.Completed:Once(function() if transition==current then statusDock.Visible=false end end)
                end
            end
            if not holder.Visible then
                holder.Position=iconCenter()
                uiScale.Scale=0.08
                holder.Visible=true
            end
            if acrylic then acrylic:SetVisible(true) end
            if deps.Motion.Reduced then
                holder.Position=expandedPosition;uiScale.Scale=expandedScale
            else
                windowTween=game:GetService("TweenService"):Create(holder,TweenInfo.new(0.34,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=expandedPosition})
                windowScaleTween=game:GetService("TweenService"):Create(uiScale,TweenInfo.new(0.34,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Scale=expandedScale})
                windowTween:Play();windowScaleTween:Play()
            end
        else
            if not self._Minimizing then
                expandedPosition=holder.Position;expandedScale=uiScale.Scale
            end
            self._Minimizing=true
            if acrylic then acrylic:SetVisible(false) end
            if deps.Motion.Reduced then
                holder.Visible=false;holder.Position=expandedPosition;uiScale.Scale=expandedScale
                showDock()
            else
                windowTween=game:GetService("TweenService"):Create(holder,TweenInfo.new(0.29,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=iconCenter()})
                windowScaleTween=game:GetService("TweenService"):Create(uiScale,TweenInfo.new(0.29,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Scale=0.08})
                windowTween.Completed:Once(function()
                    if runtime.Destroyed or transition~=current then return end
                    if windowScaleTween then windowScaleTween:Cancel();windowScaleTween=nil end
                    holder.Visible=false
                    holder.Position=expandedPosition;uiScale.Scale=expandedScale
                    showDock()
                end)
                windowTween:Play();windowScaleTween:Play()
            end
        end
    end
    runtime:TrackCleanup(cancelTransition)
    local statusDragHandle=Instance.new("TextButton")
    statusDragHandle.Name="StatusDragHandle";statusDragHandle.Text="";statusDragHandle.AutoButtonColor=false
    statusDragHandle.BackgroundTransparency=1;statusDragHandle.Size=UDim2.new(1,-38,0,52)
    statusDragHandle.Active=true;statusDragHandle.ZIndex=94;statusDragHandle.Parent=statusDock
    local statusRestoreGate=0
    local function activateStatus()
        if deps.ModalActive then return end
        if app.StatusClickSuppressed and app:StatusClickSuppressed() then return end
        if os.clock()<statusRestoreGate then return end
        statusRestoreGate=os.clock()+0.2
        if deps.PlayUISound then deps.PlayUISound() end
        app:SetVisible(true)
    end
    statusDock.Activated:Connect(activateStatus)
    statusDragHandle.Activated:Connect(activateStatus)
    statusDock.MouseEnter:Connect(function() if serenityInputBlocked(statusDock) then return end; deps.Motion:Tween(dockEdge,"Hover",{Transparency=0.3});if not UserInputService.TouchEnabled and not (app.StatusClickSuppressed and app:StatusClickSuppressed()) then expandStatus(true) end end)
    statusDock.MouseLeave:Connect(function() deps.Motion:Tween(dockEdge,"Hover",{Transparency=0.72});if not UserInputService.TouchEnabled then expandStatus(false) end end)
    do
        local pointer,press,holdTimer,follow,settle
        local dragging=false
        local suppressUntil=0
        local originX,originY,currentX,currentY,targetX,targetY
        function app:StatusClickSuppressed() return dragging or os.clock()<suppressUntil end
        local function cancelHold()
            if holdTimer then pcall(task.cancel,holdTimer);holdTimer=nil end
        end
        local function stopFollow()
            if follow then follow:Disconnect();follow=nil end
        end
        local function stopSettle()
            if settle then settle:Cancel();settle=nil end
        end
        local function finishStatusDrag()
            cancelHold();pointer=nil;stopFollow()
            if dragging then
                suppressUntil=os.clock()+0.4
                stopSettle()
                settle=deps.Motion:Tween(statusDock,0.1,{Position=UDim2.fromOffset(targetX,targetY)},Enum.EasingStyle.Quad)
            end
            dragging=false
            deps.Motion:Tween(dockEdge,0.15,{Transparency=0.72})
        end
        local function beginStatusDrag(input)
            if deps.ModalActive then return end
            if pointer or (input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch) then return end
            pointer=input;press=input.Position;dragging=false
            holdTimer=task.delay(0.35,function()
                holdTimer=nil
                if runtime.Destroyed or not pointer or not statusDock.Visible then return end
                stopSettle()
                local point=statusDock.AbsolutePosition-screen.AbsolutePosition
                -- Capture the anchor once; changing capsule width must not shift its drag origin.
                originX=point.X+statusDock.AbsoluteSize.X/2;originY=point.Y
                currentX,currentY=originX,originY;targetX,targetY=originX,originY
                dragging=true;suppressUntil=os.clock()+0.5
                expandStatus(false)
                deps.Motion:Tween(dockEdge,0.1,{Transparency=0.15})
                follow=game:GetService("RunService").RenderStepped:Connect(function(dt)
                    if runtime.Destroyed then stopFollow();return end
                    local alpha=deps.Motion.Reduced and 1 or (1-math.exp(-30*dt))
                    currentX=currentX+(targetX-currentX)*alpha
                    currentY=currentY+(targetY-currentY)*alpha
                    statusDock.Position=UDim2.fromOffset(currentX,currentY)
                end)
            end)
        end
        runtime:TrackConnection(statusDock.InputBegan:Connect(beginStatusDrag))
        runtime:TrackConnection(statusDragHandle.InputBegan:Connect(beginStatusDrag))
        runtime:TrackConnection(UserInputService.InputChanged:Connect(function(input)
            if not pointer or not dragging then return end
            if pointer.UserInputType==Enum.UserInputType.Touch and input~=pointer then return end
            if pointer.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
            local delta=input.Position-press
            targetX=originX+delta.X;targetY=originY+delta.Y
        end))
        runtime:TrackConnection(UserInputService.InputEnded:Connect(function(input)
            if input==pointer then finishStatusDrag() end
        end))
        runtime:TrackConnection(UserInputService.WindowFocusReleased:Connect(finishStatusDrag))
        runtime:TrackCleanup(function() cancelHold();stopFollow();stopSettle();pointer=nil;dragging=false end)
    end
    local function restoreFeedback(active)
        deps.Motion:Tween(restore,"Hover",{BackgroundColor3=active and tokens.Color.InsetHover or tokens.Color.Inset})
        deps.Motion:Tween(restoreEdge,"Hover",{Transparency=active and 0.25 or 0.65})
        deps.Motion:Tween(emblemScale,"Hover",{Scale=(active and not deps.Motion.Reduced) and 1.06 or 1})
    end
    runtime:TrackConnection(restore.MouseEnter:Connect(function() if serenityInputBlocked(restore) then return end; restoreFeedback(true) end))
    runtime:TrackConnection(restore.MouseLeave:Connect(function() restoreFeedback(false) end))
    runtime:TrackConnection(restore.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            restoreFeedback(true)
        end
    end))
    runtime:TrackConnection(restore.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            restoreFeedback(false)
        end
    end))
    local iconPointer,iconPress,iconStart
    local iconDragged=false
    local suppressIconClickUntil=0
    local function placeIcon(position)
        restore.Position=UDim2.fromOffset(position.X,position.Y)
    end
    runtime:TrackConnection(restore.InputBegan:Connect(function(input)
        if deps.ModalActive then return end
        if iconPointer or (input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch) then return end
        iconPointer=input;iconPress=input.Position;iconDragged=false
        iconStart=restore.AbsolutePosition-screen.AbsolutePosition
    end))
    runtime:TrackConnection(UserInputService.InputChanged:Connect(function(input)
        if not iconPointer then return end
        if iconPointer.UserInputType==Enum.UserInputType.Touch then
            if input~=iconPointer then return end
        elseif input.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local delta=input.Position-iconPress
        if delta.Magnitude<6 then return end
        iconDragged=true
        suppressIconClickUntil=os.clock()+0.35
        placeIcon(iconStart+Vector2.new(delta.X,delta.Y))
    end))
    runtime:TrackConnection(UserInputService.InputEnded:Connect(function(input)
        if input~=iconPointer then return end
        iconPointer=nil;restoreFeedback(false)
        if iconDragged then suppressIconClickUntil=os.clock()+0.35 end
        iconDragged=false
    end))
    runtime:TrackConnection(screen:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        placeIcon(restore.AbsolutePosition-screen.AbsolutePosition)
        if statusDock.Visible and app:IsMinimized() then
            if dockTween then dockTween:Cancel();dockTween=nil end
            statusDock.Size=dockSize()
        end
    end))
    function app:ResetFloatingPositions()
        holder.Position=UDim2.fromScale(0.5,0.5)
        expandedPosition=holder.Position
        statusDock.Position=UDim2.new(0.5,0,0,8)
        restore.Position=UDim2.new(0,12,0.5,-25)
        if self.ResetQuickPanelPositions then self:ResetQuickPanelPositions() end
        if not holder.Visible then self:SetVisible(true) end
    end
    minimize.Activated:Connect(function() if serenityInputBlocked(minimize) then return end;
        if deps.PlayUISound then deps.PlayUISound() end
        app:SetVisible(false)
        emblemScale.Scale=deps.Motion.Reduced and 1 or 0.85
        emblem.Rotation=deps.Motion.Reduced and 0 or -8
        deps.Motion:Tween(emblemScale,0.24,{Scale=1})
        deps.Motion:Tween(emblem,0.24,{Rotation=0})
    end)
    local lastRestoreTap=0
    restore.Activated:Connect(function() if serenityInputBlocked(restore) then return end;
        if iconDragged or os.clock()<suppressIconClickUntil then return end
        local now=os.clock()
        if lastRestoreTap>0 and now-lastRestoreTap<0.4 then
            lastRestoreTap=0;app:ResetFloatingPositions();return
        end
        lastRestoreTap=now
        if deps.PlayUISound then deps.PlayUISound() end
        app:SetVisible(app:IsMinimized())
    end)

    do
        local actions,order,observers={},{},{}
        local capturing,captureTimer
        local function sizePanel(action)
            local width=action.Minimized and 170 or 272
            local height=action.Minimized and 36 or (action.PanelBuilder and 106 or 64)
            action.Panel.Size=UDim2.fromOffset(math.min(width,math.max(100,screen.AbsoluteSize.X-12)),height)
            action.Body.Visible=not action.Minimized;action.Caption.Visible=not action.Minimized;action.KeyButton.Visible=not action.Minimized
            action.Collapse.Text=action.Minimized and "+" or "−"
        end
        local function render(action)
            action.Panel.Visible=action.PanelEnabled
            action.Caption.Text=action.Busy and "Applying change…" or (action.Value and "On · drag to move" or "Off · ready to enable")
            action.KeyButton.Text=capturing==action and "Press key" or (action.KeyCode and action.KeyCode.Name or "Bind key")
            serenityColor(action.Switch,"BackgroundColor3",tokens,action.Value and "Accent" or "Inset")
            action.Dot.Position=UDim2.fromOffset(action.Value and 16 or 3,3)
            action.Switch.Active=not action.Busy
            for _,fn in ipairs(observers[action.Id] or {}) do pcall(fn,action) end
            if app.OnViewChanged then app.OnViewChanged() end
        end
        function app:SetQuickPanelEnabled(id,value)
            local action=actions[id];if not action or action.Busy then return false end
            value=value==true
            if not value and action.Value then
                action.HideAfterDisable=true
                return self:SetQuickAction(id,false)
            end
            local changed=action.PanelEnabled~=value
            action.PanelEnabled=value;render(action)
            if changed and value and self.Notify then self:Notify(action.Title.." panel","Use its switch to turn the feature on or off.",2,"Info") end
            return true
        end
        local function setKey(action,key)
            if key~=nil then
                if typeof(key)~="EnumItem" or key.EnumType~=Enum.KeyCode or key==Enum.KeyCode.Unknown or key==Enum.KeyCode.RightControl or key==Enum.KeyCode.Escape then return false,"Reserved key" end
                for _,id in ipairs(order) do
                    if actions[id]~=action and actions[id].KeyCode==key then return false,"Already assigned" end
                end
            end
            action.KeyCode=key;render(action);if app.OnViewChanged then app.OnViewChanged() end;return true
        end
        function app:SetQuickActionKey(id,key)
            local action=actions[id];if not action then return false,"Unknown action" end
            return setKey(action,key)
        end
        function app:SetQuickPanelMinimized(id,value)
            local action=actions[id];if not action then return false end
            action.Minimized=value==true;sizePanel(action);if app.OnViewChanged then app.OnViewChanged() end;return true
        end
        function app:CancelQuickKeyCapture()
            local previous=capturing;capturing=nil
            if captureTimer then pcall(task.cancel,captureTimer);captureTimer=nil end
            if previous then render(previous) end
        end
        function app:GetQuickAction(id) return actions[id] end
        function app:ObserveQuickAction(id,fn)
            assert(type(fn)=="function","ObserveQuickAction needs a callback")
            observers[id]=observers[id] or {};table.insert(observers[id],fn)
            if actions[id] then fn(actions[id]) end
        end
        function app:SetQuickAction(id,value,silent)
            local action=actions[id];if not action or action.Busy then return false end
            value=value==true
            if value and not action.PanelEnabled and not silent then return false end
            if action.Value==value then return true end
            if silent then action.Value=value;render(action);return true end
            action.Busy=true;render(action)
            task.spawn(function()
                local ok,result,reason=pcall(action.Callback,value)
                if runtime.Destroyed then return end
                action.Busy=false
                if ok and result~=false then
                    action.Value=value
                    if action.HideAfterDisable and not value then action.PanelEnabled=false end
                elseif app.Notify then app:Notify(action.Title,ok and tostring(reason or "Action unavailable") or "Could not apply this action.",4,"Info") end
                action.HideAfterDisable=nil
                render(action)
            end)
            return true
        end
        -- Register only supported game actions. Panel(body, app, action) adds optional feature controls.
        function app:RegisterQuickAction(options)
            assert(type(options)=="table" and type(options.Id)=="string" and type(options.Callback)=="function","Quick action needs Id and Callback")
            assert(not actions[options.Id],"Quick action already registered: "..options.Id)
            assert(options.Panel==nil or type(options.Panel)=="function","Panel must be a builder function")
            local action={Id=options.Id,Title=options.Title or options.Id,Value=options.Default==true,Callback=options.Callback,Busy=false,PanelEnabled=options.PanelEnabled==true,Minimized=false,PanelBuilder=options.Panel}
            local panel=Instance.new("Frame");panel.Name="FeaturePanel_"..action.Id
            panel.Position=UDim2.new(0,14,0.5,(#order)*72-110);panel.Size=UDim2.fromOffset(272,64)
            serenityColor(panel,"BackgroundColor3",tokens,"ShellDeep");panel.BackgroundTransparency=0.02
            panel.BorderSizePixel=0;panel.Active=true;panel.ZIndex=100;panel.Parent=screen
            corner(panel,7)
            local edge=Instance.new("UIStroke");serenityColor(edge,"Color",tokens,"Stroke");edge.Transparency=0.4;edge.Parent=panel
            local accent=Instance.new("Frame");accent.Size=UDim2.fromOffset(3,16);accent.Position=UDim2.fromOffset(0,10)
            accent.BorderSizePixel=0;serenityColor(accent,"BackgroundColor3",tokens,"Accent");accent.ZIndex=101;accent.Parent=panel
            local title=deps.Typography.Label(panel,"Control",tokens,action.Title,UDim2.fromOffset(13,0),UDim2.new(1,-100,0,36),tokens.Color.Text,"Text")
            title.TextSize=13;title.Font=Enum.Font.GothamSemibold;title.Active=true;title.ZIndex=101;title.TextTruncate=Enum.TextTruncate.AtEnd
            local caption=deps.Typography.Label(panel,"Control",tokens,"Enabled · drag to move",UDim2.fromOffset(13,35),UDim2.new(1,-105,0,21),tokens.Color.TextMuted,"TextMuted")
            caption.TextSize=11;caption.ZIndex=101
            local collapse=Instance.new("TextButton");collapse.Text="−";collapse.TextSize=19
            collapse.BackgroundTransparency=1;serenityColor(collapse,"TextColor3",tokens,"TextMuted");collapse.AutoButtonColor=false
            collapse.Size=UDim2.fromOffset(28,30);collapse.Position=UDim2.new(1,-83,0,3);collapse.ZIndex=102;collapse.Parent=panel
            local switch=Instance.new("TextButton");switch.Text="";switch.AutoButtonColor=false
            switch.Size=UDim2.fromOffset(32,19);switch.Position=UDim2.new(1,-44,0,9)
            switch.BorderSizePixel=0;switch.ZIndex=102;switch.Parent=panel;corner(switch,4)
            local dot=Instance.new("Frame");dot.Size=UDim2.fromOffset(13,13);serenityColor(dot,"BackgroundColor3",tokens,"Text")
            dot.BorderSizePixel=0;dot.ZIndex=103;dot.Parent=switch;corner(dot,2)
            local body=Instance.new("Frame");body.BackgroundTransparency=1
            body.Position=UDim2.fromOffset(12,62);body.Size=UDim2.new(1,-24,0,36);body.ZIndex=101;body.Parent=panel
            local keyButton=Instance.new("TextButton");keyButton.Size=UDim2.fromOffset(76,22)
            keyButton.Position=UDim2.new(1,-88,0,35);serenityColor(keyButton,"BackgroundColor3",tokens,"PanelSoft")
            keyButton.BorderSizePixel=0;keyButton.TextSize=10;keyButton.Font=Enum.Font.GothamMedium
            serenityColor(keyButton,"TextColor3",tokens,"TextMuted");keyButton.AutoButtonColor=false
            keyButton.ZIndex=102;keyButton.Parent=panel;corner(keyButton,4)
            action.KeyButton=keyButton
            keyButton.Activated:Connect(function()
                if deps.ModalActive or serenityInputBlocked(keyButton) then return end
                if captureTimer then pcall(task.cancel,captureTimer);captureTimer=nil end
                local previous=capturing;capturing=action
                if previous then render(previous) end
                render(action)
                captureTimer=task.delay(8,function() capturing=nil;captureTimer=nil;if not runtime.Destroyed then render(action) end end)
            end)
            runtime:TrackConnection(panel:GetPropertyChangedSignal("Position"):Connect(function() if app.OnViewChanged then app.OnViewChanged() end end))
            action.Panel=panel;action.Body=body;action.Caption=caption;action.Collapse=collapse;action.Switch=switch;action.Dot=dot
            if options.Panel then
                local ok,err=pcall(options.Panel,body,self,action)
                if not ok then panel:Destroy();error("Quick action panel failed: "..tostring(err)) end
            end
            actions[action.Id]=action;table.insert(order,action.Id)
            switch.Activated:Connect(function() if deps.ModalActive or serenityInputBlocked(switch) then return end; app:SetQuickAction(action.Id,not action.Value) end)
            collapse.Activated:Connect(function()
                if deps.ModalActive or serenityInputBlocked(collapse) then return end
                app:SetQuickPanelMinimized(action.Id,not action.Minimized)
            end)
            local dragInput,origin,start
            runtime:TrackConnection(title.InputBegan:Connect(function(input)
                if deps.ModalActive or serenityInputBlocked(title) then return end
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    dragInput=input;origin=input.Position;start=panel.AbsolutePosition-screen.AbsolutePosition
                end
            end))
            runtime:TrackConnection(UserInputService.InputChanged:Connect(function(input)
                if deps.ModalActive then dragInput=nil;return end
                if not dragInput then return end
                if dragInput.UserInputType==Enum.UserInputType.Touch and input~=dragInput then return end
                if dragInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
                local delta=input.Position-origin
                panel.Position=UDim2.fromOffset(start.X+delta.X,start.Y+delta.Y)
            end))
            runtime:TrackConnection(UserInputService.InputEnded:Connect(function(input) if input==dragInput then dragInput=nil end end))
            if options.KeyCode then
                local ok,reason=setKey(action,options.KeyCode);assert(ok,reason)
            end
            sizePanel(action);render(action);return action
        end
        local function packPosition(object)
            local size=screen.AbsoluteSize
            return {X=object.Position.X.Scale+object.Position.X.Offset/math.max(1,size.X),Y=object.Position.Y.Scale+object.Position.Y.Offset/math.max(1,size.Y)}
        end
        local function restorePosition(object,data)
            if type(data)~="table" then return end
            local x,y=data.X,data.Y
            if type(x)=="number" and type(y)=="number" and x==x and y==y and math.abs(x)<100 and math.abs(y)<100 then
                object.Position=UDim2.fromScale(x,y)
            end
        end
        function app:GetUIPreferences()
            local data={Window=packPosition(holder),Status=packPosition(statusDock),Icon=packPosition(restore),Actions={}}
            -- The visible window may currently be morphing into the status capsule.
            if self._Minimizing or not holder.Visible then
                data.Window={X=expandedPosition.X.Scale+expandedPosition.X.Offset/math.max(1,screen.AbsoluteSize.X),Y=expandedPosition.Y.Scale+expandedPosition.Y.Offset/math.max(1,screen.AbsoluteSize.Y)}
            end
            for _,id in ipairs(order) do
                local action=actions[id]
                data.Actions[id]={Key=action.KeyCode and action.KeyCode.Name or false,Minimized=action.Minimized,PanelEnabled=action.PanelEnabled,Position=packPosition(action.Panel)}
            end
            return data
        end
        function app:RestoreUIPreferences(data)
            if type(data)~="table" then return end
            restorePosition(holder,data.Window);expandedPosition=holder.Position
            restorePosition(statusDock,data.Status);restorePosition(restore,data.Icon)
            local pending={}
            for _,id in ipairs(order) do
                local action=actions[id];local entry=type(data.Actions)=="table" and data.Actions[id]
                if type(entry)=="table" then
                    restorePosition(action.Panel,entry.Position)
                    action.Minimized=entry.Minimized==true
                    action.PanelEnabled=entry.PanelEnabled==true
                    -- Restore panel availability only; never invoke a game feature callback.
                    sizePanel(action);render(action)
                    local key=entry.Key
                    if key==false then pending[id]={}
                    elseif type(key)=="string" then
                        local ok,value=pcall(function() return Enum.KeyCode[key] end)
                        if ok and value and value~=Enum.KeyCode.Unknown and value~=Enum.KeyCode.Escape and value~=Enum.KeyCode.RightControl then pending[id]={Key=value} end
                    end
                end
            end
            for id in pairs(pending) do actions[id].KeyCode=nil end
            for _,id in ipairs(order) do if pending[id] then setKey(actions[id],pending[id].Key) end end
        end
        for _,object in ipairs({holder,statusDock,restore}) do
            runtime:TrackConnection(object:GetPropertyChangedSignal("Position"):Connect(function()
                if app.OnViewChanged then app.OnViewChanged() end
            end))
        end
        function app:ResetQuickPanelPositions()
            for index,id in ipairs(order) do
                actions[id].Panel.Position=UDim2.new(0,14,0.5,(index-1)*72-110)
            end
        end
        runtime:TrackConnection(screen:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            for _,id in ipairs(order) do sizePanel(actions[id]) end
        end))
        runtime:TrackCleanup(function() if captureTimer then pcall(task.cancel,captureTimer) end end)
        runtime:TrackConnection(UserInputService.InputBegan:Connect(function(input,processed)
            if deps.ModalActive then return end
            if capturing then
                if input.UserInputType~=Enum.UserInputType.Keyboard then return end
                local action=capturing
                capturing=nil
                if captureTimer then pcall(task.cancel,captureTimer);captureTimer=nil end
                if input.KeyCode~=Enum.KeyCode.Escape then
                    local ok,reason=setKey(action,input.KeyCode~=Enum.KeyCode.Backspace and input.KeyCode or nil)
                    if not ok and app.Notify then app:Notify("Shortcut",reason,3,"Info") end
                end
                render(action);return
            end
            if processed or UserInputService:GetFocusedTextBox() or deps.PopupManager.Active then return end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then return end
            for _,id in ipairs(order) do
                local action=actions[id]
                if action.PanelEnabled and action.KeyCode==input.KeyCode then app:SetQuickAction(id,not action.Value);return end
            end
        end))
    end

    local function createSearchPopup(categoriesOnly)
        if not holder.Visible then return end
        deps.PopupManager:Close()
        local popup = Instance.new("Frame")
        popup.AnchorPoint = Vector2.new(1, 0)
        popup.Position = UDim2.new(1, -16, 0, tokens.Size.Topbar - 2)
        local logicalWidth=holder.Size.X.Offset
        local popupWidth=math.min(deps.Mobile and 340 or 292,logicalWidth-24)
        local popupHeight=math.min(340,holder.Size.Y.Offset-tokens.Size.Topbar-14)
        popup.Size = UDim2.fromOffset(popupWidth,popupHeight)
        if categoriesOnly then
            popup.AnchorPoint=Vector2.new(0,0)
            popup.Position=UDim2.fromOffset(math.clamp(pageButton.Position.X.Offset,12,logicalWidth-popupWidth-12),tokens.Size.Topbar+2)
        end
        popup.ZIndex = 80
        popup.Parent = overlay
        deps.Material.Popup(popup, tokens)

        local caption=deps.Typography.Label(popup,"Value",tokens,categoriesOnly and "Categories" or "All features",UDim2.fromOffset(12,6),UDim2.new(1,-60,0,30),tokens.Color.Text,"Text")
        caption.ZIndex=81
        local close=Instance.new("TextButton")
        close.Text="×";close.TextSize=22;serenityColor(close,"TextColor3",tokens,"TextMuted")
        close.BackgroundTransparency=1;close.Size=UDim2.fromOffset(40,36)
        close.Position=UDim2.new(1,-44,0,2);close.ZIndex=82;close.Parent=popup
        close.Activated:Connect(function() if serenityInputBlocked(close) then return end; deps.PopupManager:Close() end)
        local input = Instance.new("TextBox")
        input.Position = UDim2.fromOffset(8, 42)
        input.Size = UDim2.new(1, -16, 0, 34)
        input.Text = ""
        input.PlaceholderText = categoriesOnly and "Filter categories..." or "Search all features..."
        serenityColor(input,"PlaceholderColor3",tokens,"TextDim")
        serenityColor(input,"TextColor3",tokens,"Text")
        input.TextSize = tokens.Type.Value
        input.Font = deps.Typography.Font.Medium
        input.TextXAlignment = Enum.TextXAlignment.Left
        input.ClearTextOnFocus = false
        input.ZIndex = 81
        input.Parent = popup
        deps.Material.Inset(input, tokens)
        local inputPad = Instance.new("UIPadding") inputPad.PaddingLeft = UDim.new(0, 10) inputPad.PaddingRight = UDim.new(0, 8) inputPad.Parent = input

        local listFrame = Instance.new("ScrollingFrame")
        listFrame.BackgroundTransparency = 1
        listFrame.BorderSizePixel = 0
        listFrame.Position = UDim2.fromOffset(8, 84)
        listFrame.Size = UDim2.new(1, -16, 1, -92)
        listFrame.CanvasSize = UDim2.new()
        listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        listFrame.ScrollBarThickness = deps.Mobile and 4 or 2
        listFrame.ScrollBarImageColor3 = tokens.Color.Accent
        listFrame.ZIndex = 81
        listFrame.Parent = popup
        local ll = Instance.new("UIListLayout") ll.Padding = UDim.new(0, 3) ll.Parent = listFrame

        local matches = {}
        for _, entry in ipairs(navItems) do
            if categoriesOnly then
                table.insert(matches,{Entry=entry,Title=entry.Title})
            else
                for _, target in ipairs(entry.Page:GetDescendants()) do
                    local title=target:GetAttribute("FeatureTitle")
                    if not title and target:IsA("TextButton") and target.Text~="" then title=target.Text end
                    if not title and target:IsA("TextBox") and target.PlaceholderText~="" then title=target.PlaceholderText end
                    if title then table.insert(matches,{Entry=entry,Title=title,Target=target,Description=target:GetAttribute("FeatureDescription") or ""}) end
                end
            end
        end
        table.sort(matches,function(a,b) return (a.Title..a.Entry.Title)<(b.Title..b.Entry.Title) end)
        local rows={}
        local function jump(match)
            app:SelectPage(match.Entry.Id)
            local target=match.Target
            if not target then return end
            local ancestor=target.Parent
            while ancestor and ancestor~=match.Entry.Page do
                if ancestor:IsA("GuiObject") then ancestor.Visible=true end
                ancestor=ancestor.Parent
            end
            task.defer(function()
                if runtime.Destroyed or not target.Parent then return end
                local page=match.Entry.Page
                local y=(target.AbsolutePosition.Y-page.AbsolutePosition.Y)/math.max(uiScale.Scale,0.01)+page.CanvasPosition.Y-18
                page.CanvasPosition=Vector2.new(0,math.clamp(y,0,math.max(0,page.AbsoluteCanvasSize.Y-page.AbsoluteWindowSize.Y)))
                local outline=Instance.new("UIStroke")
                outline.Name="SearchHighlight";outline.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
                serenityColor(outline,"Color",tokens,"Accent");outline.Thickness=2;outline.Parent=target
                task.delay(1.5,function() if outline.Parent then outline:Destroy() end end)
            end)
        end
        for _,match in ipairs(matches) do
            local row=Instance.new("TextButton")
            row.Size=UDim2.new(1,-2,0,categoriesOnly and (deps.Mobile and 44 or 35) or 48)
            row.BackgroundColor3=(categoriesOnly and match.Entry.Id==currentPage) and tokens.Color.Accent or tokens.Color.PanelSoft;row.BackgroundTransparency=0.12
            row.BorderSizePixel=0;row.Text="";row.AutoButtonColor=false;row.ZIndex=82;row.Parent=listFrame
            corner(row,6)
            local title=deps.Typography.Label(row,"Value",tokens,match.Title,UDim2.fromOffset(10,4),UDim2.new(1,-20,0,25),tokens.Color.Text,"Text")
            title.ZIndex=83
            if not categoriesOnly then
                local subtitle=deps.Typography.Label(row,"Description",tokens,match.Entry.Title,UDim2.fromOffset(10,28),UDim2.new(1,-20,0,15),tokens.Color.TextMuted,"TextMuted")
                subtitle.ZIndex=83
            end
            table.insert(rows,{Frame=row,Match=match,Search=string.lower(match.Title.." "..match.Entry.Title.." "..(match.Description or ""))})
            deps.Material.OptionHover(row, tokens, categoriesOnly and match.Entry.Id==currentPage, deps.Motion)
            row.Activated:Connect(function() if serenityInputBlocked(row) then return end; jump(match) end)
        end
        local empty=deps.Typography.Label(listFrame,"Value",tokens,categoriesOnly and "No matching categories" or "No matching features",UDim2.new(),UDim2.new(1,-10,0,40),tokens.Color.TextMuted,"TextMuted")
        empty.ZIndex=83;empty.Visible=false
        input:GetPropertyChangedSignal("Text"):Connect(function()
            local q=string.lower(input.Text or "")
            local count=0
            for _,data in ipairs(rows) do
                local visible=true
                for word in q:gmatch("%S+") do if not string.find(data.Search,word,1,true) then visible=false break end end
                data.Frame.Visible=visible
                if visible then count=count+1 end
            end
            empty.Visible=count==0
            listFrame.CanvasPosition=Vector2.new()
        end)
        input.FocusLost:Connect(function(enter)
            if enter then for _,data in ipairs(rows) do if data.Frame.Visible then jump(data.Match) break end end end
        end)

        deps.PopupManager:Set(popup)
        -- TextBox receives focus only from an explicit click or tap.
    end

    local function createScopePopup()
        deps.PopupManager:Close()
        local popup = Instance.new("Frame")
        popup.Position = UDim2.fromOffset(tokens.Size.Sidebar + 198, tokens.Size.Topbar - 2)
        popup.Size = UDim2.fromOffset(108, 116)
        popup.ZIndex = 80
        popup.Parent = overlay
        deps.Material.Popup(popup, tokens)

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 3)
        list.Parent = popup
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 6)
        pad.PaddingTop = UDim.new(0, 6)
        pad.Parent = popup

        for _, name in ipairs({"Global", "Session", "Safe"}) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, 0, 0, 30)
            serenityColor(item,"BackgroundColor3",tokens,"PanelSoft")
            item.BackgroundTransparency = name == scopeText.Text and 0.14 or 0.56
            item.BorderSizePixel = 0
            item.Text = name
            item.TextColor3 = name == scopeText.Text and tokens.Color.Text or tokens.Color.TextMuted
            item.TextSize = tokens.Type.Value
            item.Font = deps.Typography.Font.Medium
            item.AutoButtonColor = false
            item.ZIndex = 81
            item.Parent = popup
            corner(item, 6)
            deps.Material.OptionHover(item, tokens, name == scopeText.Text, deps.Motion)
            item.MouseButton1Click:Connect(function() if serenityInputBlocked(item) then return end;
                scopeText.Text = name
                deps.PopupManager:Close()
            end)
        end
        deps.PopupManager:Set(popup)
    end

    searchButton.Activated:Connect(function() if serenityInputBlocked(searchButton) then return end; createSearchPopup(false) end)
    pageButton.Activated:Connect(function() if serenityInputBlocked(pageButton) then return end; createSearchPopup(true) end)
    scopeButton.MouseButton1Click:Connect(createScopePopup)

    runtime:TrackConnection(UserInputService.InputBegan:Connect(function(input, processed)
        if deps.ModalActive then return end
        if input.KeyCode==Enum.KeyCode.Escape and deps.PopupManager.Active then
            deps.PopupManager:Close()
            return
        end
        if processed then return end
        if input.KeyCode == Enum.KeyCode.K and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            createSearchPopup()
        elseif input.KeyCode == Enum.KeyCode.RightControl then
            if deps.PlayUISound then deps.PlayUISound() end
            app:SetVisible(app:IsMinimized())
        elseif input.KeyCode == Enum.KeyCode.Escape then
            deps.PopupManager:Close()
        end
    end))

    task.spawn(function()
        local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
        if not runtime.Destroyed and ok and info and info.Name then
            brandSub.Text = info.Name
        end
    end)

    if deps.Mobile then
        sidebar.Visible=true
        -- Use the existing vertical categories and profile on mobile too.
        content.Position=UDim2.fromOffset(tokens.Size.Sidebar+14,tokens.Size.Topbar+8)
        content.Size=UDim2.new(1,-(tokens.Size.Sidebar+28),1,-(tokens.Size.Topbar+18))
        heading.Text="SERENITY HUB";heading.TextSize=16
        heading.Position=UDim2.fromOffset(47,0);heading.Size=UDim2.fromOffset(115,48)
        star.Position=UDim2.fromOffset(13,10);star.Size=UDim2.fromOffset(30,30)
        pageButton.Position=UDim2.fromOffset(165,5);pageButton.Size=UDim2.fromOffset(110,38)
    end
    sidebar.Position=UDim2.new();sidebar.Size=UDim2.new(0,tokens.Size.Sidebar,1,0)
    topbar.Position=UDim2.fromOffset(tokens.Size.Sidebar,0)
    topbar.Size=UDim2.new(1,-tokens.Size.Sidebar,0,tokens.Size.Topbar)
    heading.Parent=sidebar;heading.TextSize=13;heading.Position=UDim2.fromOffset(deps.Mobile and 44 or 54,15)
    heading.Size=UDim2.fromOffset(tokens.Size.Sidebar-(deps.Mobile and 50 or 64),22)
    star.Parent=sidebar;star.Position=UDim2.fromOffset(16,17);star.Size=UDim2.fromOffset(26,26)
    brandSub.Parent=sidebar;brandSub.Position=UDim2.fromOffset(54,37);brandSub.Text="Interface preview"
    brandSub.Size=UDim2.fromOffset(tokens.Size.Sidebar-64,16)
    heading.TextTruncate=Enum.TextTruncate.AtEnd
    brandSub.TextTruncate=Enum.TextTruncate.AtEnd
    if deps.Mobile then
        heading.Position=UDim2.fromOffset(46,12)
        heading.Size=UDim2.fromOffset(tokens.Size.Sidebar-50,24)
        brandSub.Position=UDim2.fromOffset(16,39)
        brandSub.Size=UDim2.fromOffset(tokens.Size.Sidebar-30,15)
        brandSub.TextSize=10
    end
    pageButton.Position=UDim2.fromOffset(18,8);pageButton.Size=UDim2.fromOffset(deps.Mobile and 160 or 190,40)
    pageButton.BackgroundTransparency=1;pageText.TextSize=17;serenityColor(pageText,"TextColor3",tokens,"Text")
    navHolder.Position=UDim2.fromOffset(10,66)
    navHolder.Size=UDim2.new(1,-20,1,-(66+tokens.Size.SidebarUser+8))
    content.Position=UDim2.fromOffset(tokens.Size.Sidebar+(deps.Mobile and 12 or 20),tokens.Size.Topbar+4)
    content.Size=UDim2.new(1,-(tokens.Size.Sidebar+(deps.Mobile and 24 or 40)),1,-(tokens.Size.Topbar+14))
    -- A static divider replaces the bright full-window glass rim.
    local divider=Instance.new("Frame");divider.BorderSizePixel=0
    divider.Position=UDim2.fromOffset(tokens.Size.Sidebar,0);divider.Size=UDim2.new(0,1,1,0)
    serenityColor(divider,"BackgroundColor3",tokens,"Divider");divider.Parent=shell
    edge.Transparency=0.7;edge.Thickness=1
    -- Small branded motion, suspended with the window and cleaned up on reload.
    star.AnchorPoint=Vector2.new(0.5,0.5)
    star.Position=UDim2.fromOffset(29,30);star.Size=UDim2.fromOffset(30,30)
    local glow=Instance.new("Frame");glow.Name="StarGlow";glow.BorderSizePixel=0
    glow.AnchorPoint=Vector2.new(0.5,0.5);glow.Position=UDim2.fromScale(0.5,0.5)
    glow.Size=UDim2.fromOffset(18,18);glow.BackgroundColor3=Color3.fromRGB(166,145,103)
    glow.BackgroundTransparency=0.94;glow.ZIndex=star.ZIndex-1;glow:SetAttribute("FixedPresetColor",true);glow.Parent=star
    local glowCorner=Instance.new("UICorner");glowCorner.CornerRadius=UDim.new(0,6);glowCorner.Parent=glow
    local brandScale=Instance.new("UIScale");brandScale.Parent=star
    local echoA=heading:Clone();echoA.Name="BrandEchoA";echoA.Visible=false;echoA.Parent=sidebar
    local echoB=heading:Clone();echoB.Name="BrandEchoB";echoB.Visible=false;echoB.Parent=sidebar
    echoA.ZIndex=heading.ZIndex+1;echoB.ZIndex=heading.ZIndex+1
    local brandTweens={}
    local glitchThread
    function app:RefreshBrandMotion()
        for _,tween in ipairs(brandTweens) do tween:Cancel() end
        table.clear(brandTweens)
        if glitchThread then pcall(task.cancel,glitchThread);glitchThread=nil end
        echoA.Visible=false;echoB.Visible=false;star.Rotation=0;brandScale.Scale=1
        for _,pixel in ipairs(star:GetChildren()) do
            if pixel:IsA("Frame") then pixel.BackgroundTransparency=pixel==glow and 0.94 or 0 end
        end
        if runtime.Destroyed or deps.Motion.Reduced or self.MotionSuspended or not holder.Visible then return end
        local service=game:GetService("TweenService")
        local halo=service:Create(glow,TweenInfo.new(2.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{BackgroundTransparency=0.86})
        table.insert(brandTweens,halo);halo:Play()
        -- Keep pixel edges still; twinkle the small highlights instead of scaling the emblem.
        for _,pixel in ipairs(star:GetChildren()) do
            if pixel:IsA("Frame") and pixel.Name=="StarHighlight" then
                local twinkle=service:Create(pixel,TweenInfo.new(2.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{BackgroundTransparency=0.32})
                table.insert(brandTweens,twinkle);twinkle:Play()
            end
        end
        glitchThread=task.spawn(function()
            while not runtime.Destroyed and holder.Visible and not deps.Motion.Reduced do
                task.wait(9)
                if runtime.Destroyed or not holder.Visible or deps.Motion.Reduced then break end
                serenityColor(echoA,"TextColor3",tokens,"Accent");serenityColor(echoB,"TextColor3",tokens,"Lavender")
                echoA.Position=heading.Position+UDim2.fromOffset(1,0)
                echoB.Position=heading.Position+UDim2.fromOffset(-1,1)
                echoA.TextTransparency=0.88;echoB.TextTransparency=0.93
                echoA.Visible=true;echoB.Visible=true
                task.wait(0.06)
                echoA.Position=heading.Position+UDim2.fromOffset(-1,0)
                echoB.Position=heading.Position+UDim2.fromOffset(1,0)
                task.wait(0.06)
                echoA.Visible=false;echoB.Visible=false
            end
        end)
    end
    runtime:TrackConnection(holder:GetPropertyChangedSignal("Visible"):Connect(function() app:RefreshBrandMotion() end))
    runtime:TrackCleanup(function()
        if glitchThread then pcall(task.cancel,glitchThread);glitchThread=nil end
        for _,tween in ipairs(brandTweens) do tween:Cancel() end
        table.clear(brandTweens)
    end)
    runtime:TrackConnection(UserInputService.WindowFocusReleased:Connect(function()
        app.MotionSuspended=true;app:RefreshIconMotion()
    end))
    runtime:TrackConnection(UserInputService.WindowFocused:Connect(function()
        app.MotionSuspended=false;app:RefreshIconMotion()
    end))
    app:RefreshBrandMotion()
    return app
end

return Desktop

end)()
-- SERENITY HUB // NEXT UI M4 COMPACT
-- M4.78 compatible with Ride A Pet manifests; all game actions remain in Ride A Pet callbacks.

local function loadModule(path) return assert(modules[path], "Missing bundled module: " .. path) end

local UserInputService = game:GetService("UserInputService")

local RuntimeClass = loadModule("src/core/Runtime.lua")
local Tokens = loadModule("src/core/Tokens.lua")
local Typography = loadModule("src/core/Typography.lua")
local Motion = loadModule("src/core/Motion.lua")
local Material = loadModule("src/core/Material.lua")
local AcrylicEngine = loadModule("src/core/AcrylicEngine.lua")
local Icons = loadModule("src/core/Icons.lua")
local PopupManagerClass = loadModule("src/core/PopupManager.lua")

local NavItem = loadModule("src/components/NavItem.lua")
local Section = loadModule("src/components/Section.lua")
local Toggle = loadModule("src/components/Toggle.lua")
local Slider = loadModule("src/components/Slider.lua")
local Select = loadModule("src/components/Select.lua")
local ColumnLayout = loadModule("src/components/ColumnLayout.lua")
local Desktop = loadModule("src/renderers/Desktop.lua")

local G = (getgenv and getgenv()) or _G
for _, oldKey in ipairs({"__SERENITY_NEW_UI_GLASS_LAB_M2", "__SERENITY_NEW_UI_PRECISION_M3", "__SERENITY_NEW_UI_COMPACT_M4"}) do
    if G[oldKey] and G[oldKey].Destroy then
        pcall(function() G[oldKey]:Destroy() end)
    end
end

local KEY = "__SERENITY_RIDE_A_PET_OFFICIAL_M480"
local runtime = RuntimeClass.new(KEY)
G[KEY] = runtime
runtime:TrackCleanup(function()
    if G[KEY] == runtime then G[KEY] = nil end
end)

local deps = {
    Runtime = runtime,
    Tokens = Tokens,
    Typography = Typography,
    Motion = Motion,
    Material = Material,
    AcrylicEngine = AcrylicEngine,
    Icons = Icons,
    PopupManager = PopupManagerClass.new(),
    UserInputService = UserInputService,
    NavItem = NavItem,
}

local camera=workspace.CurrentCamera
local viewport=camera and camera.ViewportSize or Vector2.new(1280,720)
deps.Mobile=UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or viewport.Y<600)
if deps.Mobile then
    Tokens.Size.Window=Vector2.new(viewport.X<viewport.Y and 430 or 700,420)
    Tokens.Size.Topbar=48
    Tokens.Size.Sidebar=156
    Tokens.Size.SectionLabel=28
    Tokens.Size.NavRow=34
    Tokens.Size.NavGroup=20
    Tokens.Size.Control=40
    Tokens.Size.Slider=55
    Tokens.Size.Select=58
end

local app = Desktop.Mount(deps, {
    Title = "SERENITY HUB",
    Subtitle = "RIDE A PET",
    BlurSize = 3,
})

-- One optional music reader drives visible section runes; no game audio is modified.
do
    local soundService=game:GetService("SoundService")
    local candidates=setmetatable({}, {__mode="k"})
    local enabled=false
    local explicit,source,follow,added,removed
    local amplitude,elapsed,pickElapsed=0,0,1
    local function resetRunes()
        for header,rune in pairs(deps.SectionRunes or {}) do
            if header.Parent then
                rune.Mark.BackgroundTransparency=rune.Hovered and 0 or 0.32
                for _,wing in ipairs(rune.Wings) do wing.BackgroundTransparency=rune.Hovered and 0.1 or 0.45 end
            end
        end
    end
    local function audible(sound)
        return sound and sound.Parent and sound:IsA("Sound") and sound.IsPlaying and sound.Volume>0
    end
    local function pickSource()
        if explicit then return audible(explicit) and explicit or nil end
        if audible(source) then return source end
        local chosen,rank=nil,-1
        for sound in pairs(candidates) do
            if audible(sound) then
                local name=string.lower(sound.Name)
                local named=name:find("music",1,true) or name:find("bgm",1,true) or name:find("soundtrack",1,true)
                local score=(named and 2 or 0)+(sound.Looped and 1 or 0)
                if score>0 and score>rank then chosen,rank=sound,score end
            end
        end
        return chosen
    end
    local function stop()
        if follow then follow:Disconnect();follow=nil end
        if added then added:Disconnect();added=nil end
        if removed then removed:Disconnect();removed=nil end
        table.clear(candidates);source=nil;amplitude=0;elapsed=0;pickElapsed=1
        resetRunes()
    end
    function app:SetMusicSource(sound)
        if sound~=nil and (typeof(sound)~="Instance" or not sound:IsA("Sound")) then return false end
        explicit=sound;source=nil;pickElapsed=1
        return true
    end
    function app:SetMusicReactive(value)
        enabled=value==true
        self.MusicReactive=enabled
        stop()
        if not enabled or runtime.Destroyed then return end
        -- Automatic fallback is scoped to SoundService, avoiding world-wide polling.
        for _,object in ipairs(soundService:GetDescendants()) do
            if object:IsA("Sound") then candidates[object]=true end
        end
        added=soundService.DescendantAdded:Connect(function(object)
            if object:IsA("Sound") then candidates[object]=true;pickElapsed=1 end
        end)
        removed=soundService.DescendantRemoving:Connect(function(object)
            candidates[object]=nil
            if source==object then source=nil;pickElapsed=1 end
        end)
        follow=game:GetService("RunService").Heartbeat:Connect(function(dt)
            if runtime.Destroyed then return end
            if Motion.Reduced or app.MotionSuspended or not app.Holder.Visible then
                if amplitude~=0 then amplitude=0;resetRunes() end
                return
            end
            elapsed=elapsed+dt
            if elapsed<1/30 then return end
            local step=elapsed;elapsed=0
            pickElapsed=pickElapsed+step
            if pickElapsed>=1 then source=pickSource();pickElapsed=0 end
            local target=audible(source) and math.clamp(source.PlaybackLoudness/450,0,1) or 0
            amplitude=amplitude+(target-amplitude)*(1-math.exp(-step*(target>amplitude and 18 or 7)))
            if target==0 and amplitude<0.005 then
                if amplitude~=0 then amplitude=0;resetRunes() end
                return
            end
            for header,rune in pairs(deps.SectionRunes or {}) do
                local visible=true
                local ancestor=header
                while ancestor and ancestor~=app.Holder do
                    if ancestor:IsA("GuiObject") and not ancestor.Visible then visible=false;break end
                    ancestor=ancestor.Parent
                end
                if visible and header.Parent then
                    rune.Mark.BackgroundTransparency=math.max(0,(rune.Hovered and 0 or 0.32)-amplitude*0.28)
                    for _,wing in ipairs(rune.Wings) do
                        wing.BackgroundTransparency=math.max(0.04,(rune.Hovered and 0.1 or 0.45)-amplitude*0.36)
                    end
                end
            end
        end)
    end
    runtime:TrackCleanup(stop)
end

-- TEST ONLY: do not migrate production or legacy dashboards without explicit release approval.
-- Shared interaction layer: event-driven help and one confirmation at a time.
do
    local guiService = game:GetService("GuiService")
    local tweens = {}
    local activeDialog, activeTip
    local modalBlocked={}
    local function modalLock(value)
        deps.ModalActive=value;runtime.ModalActive=value
        if value then
            if app.CancelQuickKeyCapture then app:CancelQuickKeyCapture() end
            local objects={app.Shell}
            for _,object in ipairs(app.ScreenGui:GetChildren()) do
                if object~=app.Holder and object:IsA("GuiObject") then table.insert(objects,object) end
            end
            for _,object in ipairs(objects) do
                modalBlocked[object]=object:GetAttribute("SerenityModalBlocked") or false
                object:SetAttribute("SerenityModalBlocked",true)
            end
        else
            for object,previous in pairs(modalBlocked) do
                if object.Parent then object:SetAttribute("SerenityModalBlocked",previous) end
            end
            table.clear(modalBlocked)
        end
    end
    local function animate(object, properties)
        if tweens[object] then tweens[object]:Cancel() end
        tweens[object] = Motion:Tween(object, "Modal", properties)
    end
    local function rounded(object, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or 10)
        corner.Parent = object
    end
    local function hideTip()
        if activeTip then activeTip.Card:Destroy(); activeTip = nil end
    end
    local function showTip(target, message)
        hideTip()
        if runtime.Destroyed or not app.Holder.Visible or not target:IsDescendantOf(app.ScreenGui) then return end
        local scale = math.max(deps.UIScale.Scale, 0.01)
        local width = math.min(260, Tokens.Size.Window.X - 24)
        local textService = game:GetService("TextService")
        local bounds = textService:GetTextSize(message, 12, Enum.Font.Gotham, Vector2.new(width - 24, 1000))
        local height = bounds.Y + 24
        local card = Instance.new("Frame")
        card.Name = "SerenityHelp"
        card.Size = UDim2.fromOffset(width, height)
        card.BackgroundColor3 = Color3.fromRGB(15, 33, 51)
        card.ZIndex = 110
        card.Parent = app.Holder
        rounded(card)
        local stroke = Instance.new("UIStroke")
        serenityColor(stroke,"Color",Tokens,"Accent"); stroke.Transparency = 0.5; stroke.Parent = card
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1; label.Text = message
        label.Font = Enum.Font.Gotham; label.TextSize = 12
        serenityColor(label,"TextColor3",Tokens,"Text"); label.TextWrapped = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Position = UDim2.fromOffset(12, 10)
        label.Size = UDim2.new(1, -24, 1, -20); label.Parent = card
        local x = (target.AbsolutePosition.X - app.Holder.AbsolutePosition.X) / scale
        local y = (target.AbsolutePosition.Y - app.Holder.AbsolutePosition.Y) / scale
        local below = y + target.AbsoluteSize.Y / scale + 7
        if below + height > Tokens.Size.Window.Y - 10 then below = y - height - 7 end
        card.Position = UDim2.fromOffset(math.clamp(x, 12, Tokens.Size.Window.X - width - 12),
            math.clamp(below, 8, math.max(8, Tokens.Size.Window.Y - height - 8)))
        activeTip = {Card = card, Target = target}
    end
    function app:Tooltip(target, message, tapToOpen)
        assert(type(message) == "string" and message ~= "", "Tooltip needs text")
        runtime:TrackConnection(target.MouseEnter:Connect(function() if serenityInputBlocked(target) then return end;
            if not UserInputService.TouchEnabled then showTip(target, message) end
        end))
        runtime:TrackConnection(target.MouseLeave:Connect(hideTip))
        runtime:TrackConnection(target.SelectionGained:Connect(function() if serenityInputBlocked(target) then return end; showTip(target, message) end))
        runtime:TrackConnection(target.SelectionLost:Connect(hideTip))
        if tapToOpen then
            runtime:TrackConnection(target.Activated:Connect(function() if serenityInputBlocked(target) then return end;
                if activeTip and activeTip.Target == target then hideTip() else showTip(target, message) end
            end))
        end
    end
    deps.Help = function(target, message) app:Tooltip(target, message, true) end
    runtime:TrackConnection(UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and activeTip then
            local p, s = activeTip.Target.AbsolutePosition, activeTip.Target.AbsoluteSize
            if input.Position.X < p.X or input.Position.X > p.X + s.X or
                input.Position.Y < p.Y or input.Position.Y > p.Y + s.Y then hideTip() end
        end
        if input.KeyCode == Enum.KeyCode.Escape and activeDialog then activeDialog(false) end
    end))
    runtime:TrackConnection(app.Holder:GetPropertyChangedSignal("Visible"):Connect(function()
        if not app.Holder.Visible then hideTip(); if activeDialog then activeDialog(false) end end
    end))
    runtime:TrackConnection(app.Holder:GetPropertyChangedSignal("Position"):Connect(hideTip))
    runtime:TrackConnection(deps.UIScale:GetPropertyChangedSignal("Scale"):Connect(hideTip))
    local selectPage = app.SelectPage
    function app:SelectPage(id)
        hideTip()
        if activeDialog then activeDialog(false) end
        return selectPage(self, id)
    end
    function app:Confirm(options)
        options = options or {}
        if runtime.Destroyed then return end
        if activeDialog then activeDialog(false) end
        hideTip()
        deps.PopupManager:Close()
        local overlay = Instance.new("TextButton")
        overlay.Name = "SerenityConfirmation"
        overlay.Text = ""; overlay.AutoButtonColor = false
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(5, 12, 24)
        overlay.BackgroundTransparency = 1; overlay.ZIndex = 100
        overlay.Parent = app.Holder; rounded(overlay, Tokens.Size.RadiusShell)
        local card = Instance.new("CanvasGroup")
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.new(0.5, 0, 0.5, 12)
        card.Size = UDim2.fromOffset(math.min(330, Tokens.Size.Window.X - 32), 170)
        serenityColor(card,"BackgroundColor3",Tokens,"Panel")
        card.GroupTransparency = 1; card.Parent = overlay; rounded(card, 9)
        local stroke = Instance.new("UIStroke")
        serenityColor(stroke,"Color",Tokens,"Stroke"); stroke.Transparency = 0.25; stroke.Parent = card
        local title = Typography.Label(card, "Control", Tokens, options.Title or "Confirm action",
            UDim2.fromOffset(16, 14), UDim2.new(1, -32, 0, 40), Tokens.Color.Text,"Text")
        title.TextSize = 16; title.Font = Enum.Font.GothamBold; title.TextWrapped = true
        local message = Typography.Label(card, "Control", Tokens, options.Message or "Continue with this action?",
            UDim2.fromOffset(16, 59), UDim2.new(1, -32, 0, 50), Tokens.Color.TextMuted,"TextMuted")
        message.TextSize = 12; message.TextWrapped = true; message.TextYAlignment = Enum.TextYAlignment.Top
        local function action(text, primary, x)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.5, -20, 0, 34)
            b.Position = UDim2.new(x, x == 0 and 16 or 4, 1, -48)
            b.Text = text; b.TextSize = 12; b.Font = Enum.Font.GothamBold
            b.AutoButtonColor = false
            serenityColor(b,"BackgroundColor3",Tokens,primary and "Accent" or "Inset")
            b.TextColor3 = primary and Color3.fromRGB(8, 24, 38) or Tokens.Color.Text
            b.Parent = card; rounded(b, 8)
            local resting=b.BackgroundColor3
            b.MouseEnter:Connect(function() if serenityInputBlocked(b) then return end; animate(b,{BackgroundColor3=primary and Tokens.Color.AccentBright or Tokens.Color.InsetHover}) end)
            b.MouseLeave:Connect(function() animate(b,{BackgroundColor3=resting}) end)
            b.SelectionGained:Connect(function() if serenityInputBlocked(b) then return end; animate(b,{BackgroundColor3=primary and Tokens.Color.AccentBright or Tokens.Color.InsetHover}) end)
            b.SelectionLost:Connect(function() animate(b,{BackgroundColor3=resting}) end)
            return b
        end
        local cancel = action(options.CancelText or "Cancel", false, 0)
        local accept = action(options.ConfirmText or "Confirm", true, 0.5)
        local previousFocus = guiService.SelectedObject
        local settled = false
        local function resolve(confirmed)
            if settled then return end
            settled = true
            if activeDialog == resolve then activeDialog = nil;modalLock(false) end
            if guiService.SelectedObject == cancel or guiService.SelectedObject == accept then
                guiService.SelectedObject = previousFocus and previousFocus.Parent and previousFocus or nil
            end
            animate(card, {GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 12)})
            animate(overlay, {BackgroundTransparency = 1})
            task.delay(Motion.Reduced and 0 or 0.21, function()
                for _,object in ipairs({card, overlay}) do
                    if tweens[object] then tweens[object]:Cancel(); tweens[object] = nil end
                end
                overlay:Destroy()
            end)
            if not runtime.Destroyed and options.Callback then options.Callback(confirmed) end
        end
        activeDialog = resolve
        modalLock(true)
        if deps.PlayUISound then deps.PlayUISound() end
        cancel.Activated:Connect(function() if serenityInputBlocked(cancel) then return end;
            if deps.PlayUISound then deps.PlayUISound() end
            resolve(false)
        end)
        accept.Activated:Connect(function() if serenityInputBlocked(accept) then return end;
            if deps.PlayUISound then deps.PlayUISound() end
            resolve(true)
        end)
        overlay.Activated:Connect(function() if serenityInputBlocked(overlay) then return end; resolve(false) end)
        if previousFocus then guiService.SelectedObject = cancel end
        animate(overlay, {BackgroundTransparency = 0.55})
        animate(card, {GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5)})
        return function() resolve(false) end
    end
    runtime:TrackCleanup(function()
        hideTip()
        if activeDialog then activeDialog(false) end
        modalLock(false)
        for object,tween in pairs(tweens) do tween:Cancel(); tweens[object] = nil end
    end)
end

-- What's new · 2026-10-07: bottom-right notifications, queue, slide animation, reduced-motion fade.
do
    local tweenService=game:GetService("TweenService")
    local screen=runtime:TrackInstance(Instance.new("ScreenGui"))
    screen.Name="Serenity_Test_Notifications"
    app.NotificationScreenGui=screen
    screen.ResetOnSpawn=false;screen.IgnoreGuiInset=false
    screen.DisplayOrder=app.ScreenGui.DisplayOrder+20;screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    screen.Parent=app.ScreenGui.Parent
    local root=Instance.new("Frame");root.BackgroundTransparency=1
    root.Size=UDim2.fromScale(1,1);root.ClipsDescendants=true;root.Parent=screen
    local active,queue,timers={},{},{}
    local pump,arrange
    local function later(seconds,callback)
        local thread
        thread=task.delay(seconds,function() timers[thread]=nil;if not runtime.Destroyed then callback() end end)
        timers[thread]=true;return thread
    end
    local function toastScale()
        return deps.Mobile and math.clamp(deps.UIScale.Scale*0.94,0.72,1) or 1
    end
    local function capacity() return deps.Mobile and 2 or math.clamp(math.floor((root.AbsoluteSize.Y-32)/90),1,3) end
    local function animate(entry,properties,duration)
        if entry.Tween then entry.Tween:Cancel() end
        entry.Tween=tweenService:Create(entry.Frame,TweenInfo.new(duration,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),properties)
        entry.Tween:Play()
    end
    arrange=function()
        local scale=toastScale()
        local width=math.max(100,math.min(deps.Mobile and 286 or 306,(root.AbsoluteSize.X-24)/scale))
        for i,entry in ipairs(active) do
            entry.Scale.Scale=scale
            entry.Frame.Size=UDim2.fromOffset(width,78)
            if not entry.Closing then
                animate(entry,{Position=UDim2.new(1,-12,1,-12-(i-1)*90*scale),GroupTransparency=0},Motion.Reduced and 0.12 or 0.26)
            end
        end
    end
    local function close(entry)
        if entry.Closing or runtime.Destroyed then return end
        entry.Closing=true
        if entry.Timer then pcall(task.cancel,entry.Timer);timers[entry.Timer]=nil;entry.Timer=nil end
        if entry.Progress then entry.Progress:Cancel() end
        animate(entry,Motion.Reduced and {GroupTransparency=1} or {Position=UDim2.new(1,entry.Frame.Size.X.Offset+16,entry.Frame.Position.Y.Scale,entry.Frame.Position.Y.Offset),GroupTransparency=1},0.2)
        later(0.2,function()
            if entry.Connection then entry.Connection:Disconnect() end
            entry.Frame:Destroy()
            for i,v in ipairs(active) do if v==entry then table.remove(active,i);break end end
            arrange();pump()
        end)
    end
    pump=function()
        while #active<capacity() and #queue>0 do
            local data=table.remove(queue,1)
            local card=Instance.new("CanvasGroup");card.AnchorPoint=Vector2.new(1,1)
            card.Size=UDim2.fromOffset(306,78);card.Position=UDim2.new(1,330,1,-12)
            card.GroupTransparency=1;serenityColor(card,"BackgroundColor3",Tokens,"PanelSoft")
            card.BackgroundTransparency=0.02;card.BorderSizePixel=0;card.Parent=root
            local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,3);corner.Parent=card
            local color=({Success=Tokens.Color.Mint,Warning=Tokens.Color.Amber,Error=Tokens.Color.Red})[data.Kind] or Tokens.Color.Accent
            local stroke=Instance.new("UIStroke");serenityColor(stroke,"Color",Tokens,"Stroke");stroke.Transparency=0.35;stroke.Thickness=1;stroke.Parent=card
            local mark=Instance.new("Frame");mark.Size=UDim2.fromOffset(13,2);mark.Position=UDim2.fromOffset(16,12)
            mark.BorderSizePixel=0;mark.BackgroundColor3=color;mark.Parent=card
            local notch=Instance.new("Frame");notch.Size=UDim2.fromOffset(3,3);notch.Position=UDim2.fromOffset(16,16)
            notch.BorderSizePixel=0;notch.BackgroundColor3=color;notch.BackgroundTransparency=0.3;notch.Parent=card
            local title=Typography.Label(card,"Control",Tokens,data.Title,UDim2.fromOffset(37,9),UDim2.new(1,-76,0,23),Tokens.Color.Text,"Text")
            title.Font=Enum.Font.GothamBold;title.TextSize=14;title.TextTruncate=Enum.TextTruncate.AtEnd
            local body=Typography.Label(card,"Control",Tokens,data.Message,UDim2.fromOffset(16,34),UDim2.new(1,-48,0,29),Tokens.Color.TextMuted,"TextMuted")
            body.TextWrapped=true;body.TextYAlignment=Enum.TextYAlignment.Top;body.TextSize=12;body.TextTruncate=Enum.TextTruncate.AtEnd
            local dismiss=Instance.new("TextButton");dismiss.Size=UDim2.fromOffset(30,30)
            dismiss.Position=UDim2.new(1,-34,0,5);dismiss.BackgroundTransparency=1;dismiss.AutoButtonColor=false
            dismiss.Text="×";dismiss.Font=Enum.Font.GothamMedium;serenityColor(dismiss,"TextColor3",Tokens,"TextMuted");dismiss.TextSize=18;dismiss.Parent=card
            dismiss.MouseEnter:Connect(function() if serenityInputBlocked(dismiss) then return end; dismiss.TextColor3=Tokens.Color.Text end)
            dismiss.MouseLeave:Connect(function() dismiss.TextColor3=Tokens.Color.TextMuted end)
            local track=Instance.new("Frame");track.Size=UDim2.new(1,-32,0,1);track.Position=UDim2.new(0,16,1,-7)
            track.BorderSizePixel=0;track.BackgroundTransparency=0.75;track.BackgroundColor3=color;track.Parent=card
            local fill=Instance.new("Frame");fill.Size=UDim2.fromScale(1,1);fill.BorderSizePixel=0;fill.BackgroundColor3=color;fill.Parent=track
            local cardScale=Instance.new("UIScale");cardScale.Scale=toastScale();cardScale.Parent=card
            local entry={Frame=card,Scale=cardScale};table.insert(active,entry)
            if Motion.Reduced then card.Position=UDim2.new(1,-12,1,-12-(#active-1)*90*toastScale()) end
            entry.Connection=dismiss.Activated:Connect(function() if serenityInputBlocked(dismiss) then return end; close(entry) end)
            entry.Progress=tweenService:Create(fill,TweenInfo.new(data.Duration,Enum.EasingStyle.Linear),{Size=UDim2.fromScale(0,1)})
            entry.Progress:Play();entry.Timer=later(data.Duration,function() entry.Timer=nil;close(entry) end)
            arrange()
        end
    end
    function app:Notify(title,message,duration,kind)
        local data=type(title)=="table" and title or {Title=title,Message=message,Duration=duration,Kind=kind}
        local seconds=tonumber(data.Duration) or 5
        if seconds~=seconds then seconds=5 end
        local item={Title=tostring(data.Title or "Serenity"):sub(1,100),Message=tostring(data.Message or data.Text or ""):sub(1,300),Duration=math.clamp(seconds,3,30),Kind=data.Kind or "Info"}
        if runtime.Destroyed then return false end
        if #queue>=20 then table.remove(queue,1) end
        table.insert(queue,item);pump();return true
    end
    runtime:TrackConnection(root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() arrange();pump() end))
    runtime:TrackCleanup(function()
        for thread in pairs(timers) do pcall(task.cancel,thread) end
        for _,entry in ipairs(active) do
            if entry.Tween then entry.Tween:Cancel() end
            if entry.Progress then entry.Progress:Cancel() end
            if entry.Connection then entry.Connection:Disconnect() end
        end
        table.clear(queue);table.clear(active)
    end)
end


-- RIDE A PET / M4.80 OFFICIAL ADAPTER
-- Builds the real Ride A Pet V3 manifest with M4.78 primitives, not sample pages.
-- No gameplay is performed by the UI. All game callbacks come from the manifest.
if type(rapManifest)=="table" and type(rapManifest.Pages)=="table" then
    return (function()
        local window={Screen=app.ScreenGui,Controls={}}
        local adapter={Controls=window.Controls}
        local values={}
        local pending={}
        local pageEntries={}
        local built={}
        local activeCallbacks=true

        local function friendlyError(err)
            app:Notify("Ride A Pet",tostring(err or "UI action failed"):sub(1,260),5,"Error")
        end

        local function sendChanged(desc,value)
            if not activeCallbacks or runtime.Destroyed or type(desc.Changed)~="function" then return end
            local ok,err=pcall(desc.Changed,value,window,adapter)
            if not ok then friendlyError(err) end
        end
        local function textLabel(parent,message,height,color,size)
            local l=Typography.Label(parent,"Control",Tokens,tostring(message or ""),
                UDim2.fromOffset(12,3),UDim2.new(1,-24,0,height or 26),
                color or Tokens.Color.TextMuted,color and "TextMuted" or "Text")
            l.TextSize=size or 12
            l.TextWrapped=true
            l.TextYAlignment=Enum.TextYAlignment.Top
            return l
        end
        local function container(parent,kind,height)
            local f=Instance.new("Frame")
            f.Name=kind
            f.Size=UDim2.new(1,0,0,height)
            f.Parent=parent
            Material.Control(f,Tokens)
            return f
        end
        local function makeInput(parent,desc,proxy)
            local row=container(parent,"Input_"..tostring(desc.Id),desc.Description and 83 or 64)
            local title=textLabel(row,desc.Title,22,Tokens.Color.Text,13)
            title.Position=UDim2.fromOffset(12,4)
            local field=Instance.new("TextBox")
            field.Name="Input"
            field.ClearTextOnFocus=false
            field.Text=tostring(proxy.Value or "")
            field.PlaceholderText=tostring(desc.Placeholder or "Enter value")
            field.TextXAlignment=Enum.TextXAlignment.Left
            field.TextSize=12
            field.Font=Enum.Font.Gotham
            field.Size=UDim2.new(1,-24,0,29)
            field.Position=UDim2.fromOffset(12,29)
            serenityColor(field,"TextColor3",Tokens,"Text")
            serenityColor(field,"PlaceholderColor3",Tokens,"TextDim")
            field.Parent=row
            Material.Inset(field,Tokens)
            local pad=Instance.new("UIPadding")
            pad.PaddingLeft=UDim.new(0,8);pad.PaddingRight=UDim.new(0,8);pad.Parent=field
            if desc.Description then
                local note=textLabel(row,desc.Description,18,Tokens.Color.TextMuted,10)
                note.Position=UDim2.fromOffset(12,62);note.TextTruncate=Enum.TextTruncate.AtEnd
            end
            runtime:TrackConnection(field.FocusLost:Connect(function()
                if serenityInputBlocked(field) then return end
                if proxy.Value==field.Text then return end
                proxy.Value=field.Text
                sendChanged(desc,field.Text)
            end))
            function proxy:Set(value,silent)
                self.Value=tostring(value or "")
                if field.Parent then field.Text=self.Value end
                if not silent then sendChanged(desc,self.Value) end
            end
            proxy.Frame=row
            return proxy
        end
        local function makeParagraph(parent,desc,proxy)
            local body=tostring(proxy.Value~=nil and proxy.Value or desc.Text or "")
            local lines=select(2,body:gsub("\n","\n"))+1
            local height=math.max(75,48+math.min(160,math.ceil(#body/55)*15+lines*9))
            local frame=container(parent,"Paragraph_"..tostring(desc.Id),height)
            local title=textLabel(frame,desc.Title or "Information",22,Tokens.Color.Text,13)
            title.Position=UDim2.fromOffset(12,8)
            local label=textLabel(frame,body,height-37,Tokens.Color.TextMuted,11)
            label.Name=desc.Title=="Fuse Status" and "SerenityFuseStatusBody" or "ParagraphBody"
            label.Position=UDim2.fromOffset(12,33)
            function proxy:Set(value)
                self.Value=tostring(value or "")
                if not label.Parent then return end
                label.Text=self.Value
                local count=select(2,self.Value:gsub("\n","\n"))+1
                local updated=math.max(75,48+math.min(160,
                    math.ceil(#self.Value/55)*15+count*9))
                frame.Size=UDim2.new(1,0,0,updated)
                label.Size=UDim2.new(1,-24,0,updated-37)
            end
            proxy.Label=label
            proxy.Frame=frame
            return proxy
        end
        local function makeAction(parent,desc,proxy)
            local row=container(parent,"Action_"..tostring(desc.Id),desc.Description and 65 or 45)
            local btn=Instance.new("TextButton")
            btn.Name="RunAction"
            btn.Position=UDim2.fromOffset(7,5)
            btn.Size=UDim2.new(1,-14,0,35)
            btn.Text=tostring(desc.Title or desc.Id or "Action")
            btn.TextSize=12
            btn.Font=Enum.Font.GothamMedium
            btn.AutoButtonColor=false
            serenityColor(btn,"TextColor3",Tokens,"Text")
            btn.Parent=row
            Material.Inset(btn,Tokens)
            if desc.Description then
                local note=textLabel(row,desc.Description,17,Tokens.Color.TextMuted,10)
                note.Position=UDim2.fromOffset(12,45)
                note.TextTruncate=Enum.TextTruncate.AtEnd
            end
            runtime:TrackConnection(btn.Activated:Connect(function()
                if runtime.Destroyed or serenityInputBlocked(btn) then return end
                if type(desc.Callback)=="function" then
                    local ok,err=pcall(desc.Callback,window,adapter)
                    if not ok then friendlyError(err) end
                end
            end))
            proxy.Frame=row
            return proxy
        end

        -- Proxy controls exist even for pages not rendered yet. Runtime updates to
        -- selectors/values are therefore not lost during lazy page construction.
        for _,pageDesc in ipairs(rapManifest.Pages) do
            for _,feature in ipairs(pageDesc.Features or {}) do
                for _,desc in ipairs(feature.Controls or {}) do
                    local id=tostring(pageDesc.Id).."."..tostring(feature.Id).."."..tostring(desc.Id)
                    local proxy={Value=desc.Default,Options=desc.Options or {},Descriptor=desc}
                    function proxy:Get() return self.Value end
                    function proxy:Set(value,silent)
                        self.Value=value
                        if self.Widget and type(self.Widget.Set)=="function" then
                            self.Widget:Set(value,true)
                        end
                        if self.QuickId then app:SetQuickAction(self.QuickId,value,true) end
                        if not silent then sendChanged(self.Descriptor,value) end
                    end
                    function proxy:Refresh(options,preserve)
                        if type(options)~="table" then return end
                        self.Options=options
                        self.Descriptor.Options=options
                        if self.Widget and type(self.Widget.Refresh)=="function" then
                            self.Widget:Refresh(options,preserve,true)
                            self.Value=self.Widget:Get()
                        elseif not preserve then self.Value=self.Descriptor.Type=="MultiSelect" and {} or options[1] end
                    end
                    proxy.SetOptions=proxy.Refresh
                    window.Controls[id]=proxy
                end
            end
        end

        adapter.Config={}
        function adapter.Config:Set(id,value,silent)
            values[id]=value
            local proxy=window.Controls[id]
            if proxy then proxy:Set(value,silent~=false) end
            return true
        end
        function adapter.Config:Get(id)
            local proxy=window.Controls[id]
            return proxy and proxy:Get() or values[id]
        end
        function adapter.Config:SaveNow()
            -- Ride A Pet already saves gameplay settings via its Changed callbacks.
            return true
        end
        function adapter:SetLive(id,value)
            local proxy=window.Controls[id]
            if proxy then proxy:Set(value,true);return true end
            return false
        end
        window.Adapter=adapter
        function window:Notify(message)
            app:Notify("Ride A Pet",tostring(message or ""),5,"Info")
        end

        local function makeControl(body,desc,proxy)
            local typ=tostring(desc.Type or "")
            local options=proxy.Options
            if typ=="Switch" then
                local widget=Toggle.new(body,deps,{
                    Id=desc.Id,Title=desc.Title,Description=desc.Description,
                    Default=proxy.Value==true,
                    Callback=function(value)
                        proxy.Value=value
                        if proxy.QuickId then app:SetQuickAction(proxy.QuickId,value,true) end
                        sendChanged(desc,value)
                    end,
                })
                proxy.Widget=widget;proxy.Frame=widget.Frame
            elseif typ=="Slider" then
                local widget=Slider.new(body,deps,{
                    Id=desc.Id,Title=desc.Title,Description=desc.Description,
                    Min=desc.Min or 0,Max=desc.Max or 100,Step=desc.Step or 1,
                    Default=tonumber(proxy.Value) or tonumber(desc.Min) or 0,
                    Suffix=desc.Suffix or "",
                    Callback=function(value)
                        proxy.Value=value
                        if proxy.QuickId then app:SetQuickAction(proxy.QuickId,value,true) end
                        sendChanged(desc,value)
                    end,
                })
                proxy.Widget=widget;proxy.Frame=widget.Frame
            elseif typ=="Select" or typ=="MultiSelect" then
                local widget=Select.new(body,deps,{
                    Id=desc.Id,Title=desc.Title,Description=desc.Description,
                    Options=options,Default=proxy.Value,
                    Multi=typ=="MultiSelect",Searchable=#options>5,
                    Callback=function(value)
                        proxy.Value=value
                        if proxy.QuickId then app:SetQuickAction(proxy.QuickId,value,true) end
                        sendChanged(desc,value)
                    end,
                })
                proxy.Widget=widget;proxy.Frame=widget.Frame
            elseif typ=="Input" then
                makeInput(body,desc,proxy)
            elseif typ=="Action" then
                makeAction(body,desc,proxy)
            elseif typ=="Paragraph" then
                makeParagraph(body,desc,proxy)
            end
        end

        -- V3 icon names are Lucide names. M4.79 maps them explicitly to
        -- actual asset-backed M4 icons instead of the generic "info" fallback.
        local pageIcon={
            ["layout-dashboard"]="dashboard",["egg"]="inventory",
            ["sparkles"]="activity",["git-merge"]="progression",
            ["send"]="webhook",["shopping-cart"]="shop",
            ["paw-print"]="pets",["eye"]="target",
            ["menu"]="misc",["trending-up"]="progression",
        }
        local function iconForTitle(title)
            local n=string.lower(tostring(title or ""))
            if n:find("steal",1,true) or n:find("target",1,true)
                or n:find("filter",1,true) then return "target" end
            if n:find("egg",1,true) or n:find("hatch",1,true)
                or n:find("place",1,true) then return "inventory" end
            if n:find("fuse",1,true) or n:find("fusion",1,true)
                or n:find("upgrade",1,true) then return "progression" end
            if n:find("event",1,true) or n:find("candy",1,true)
                or n:find("ritual",1,true) then return "activity" end
            if n:find("pet",1,true) or n:find("ride",1,true)
                or n:find("mount",1,true) then return "pets" end
            if n:find("shop",1,true) or n:find("sell",1,true)
                or n:find("buy",1,true) then return "shop" end
            if n:find("webhook",1,true) or n:find("discord",1,true)
                then return "webhook" end
            if n:find("esp",1,true) or n:find("player",1,true)
                then return "target" end
            if n:find("speed",1,true) or n:find("movement",1,true)
                then return "activity" end
            if n:find("rebirth",1,true) then return "world" end
            if n:find("safe",1,true) or n:find("protection",1,true)
                then return "shield" end
            if n:find("config",1,true) or n:find("setting",1,true)
                then return "settings" end
            return "activity"
        end
        local function decorateSection(section,title)
            local header=section.Frame:FindFirstChildWhichIsA("TextButton")
            if not header then return end
            Icons.Create(header,iconForTitle(title),14,Tokens.Color.Accent,UDim2.fromOffset(18,5))
            for _,child in ipairs(header:GetChildren()) do
                if child:IsA("TextLabel") and child.Text==tostring(title) then
                    child.Position=UDim2.fromOffset(39,0)
                    child.Size=UDim2.new(1,-88,1,0)
                    break
                end
            end
        end
        local function decorateControl(proxy,desc)
            local frame=proxy and proxy.Frame
            if not frame then return end
            local title=tostring(desc.Title or "")
            if desc.Type=="Action" then
                local btn=frame:FindFirstChild("RunAction")
                if btn then
                    Icons.Create(btn,iconForTitle(title),15,Tokens.Color.Accent,
                        UDim2.fromOffset(12,9))
                end
                return
            end
            local label
            for _,child in ipairs(frame:GetChildren()) do
                if child:IsA("TextLabel") and child.Text==title then
                    label=child;break
                end
            end
            if not label then return end
            Icons.Create(frame,iconForTitle(title),13,Tokens.Color.TextMuted,
                UDim2.fromOffset(10,
                    (desc.Type=="Input" or desc.Type=="Paragraph") and 10 or
                    (desc.Description and 9 or 13)))
            label.Position=UDim2.new(0,32,0,label.Position.Y.Offset)
            label.Size=UDim2.new(label.Size.X.Scale,label.Size.X.Offset-21,
                label.Size.Y.Scale,label.Size.Y.Offset)
        end
        local function fillPage(pageDesc)
            local entry=pageEntries[pageDesc.Id]
            if not entry or built[pageDesc.Id] then return end
            built[pageDesc.Id]=true
            local page=entry.Page
            local features=pageDesc.Features or {}
            -- One-section pages take full available width. Other pages balance
            -- estimated rendered control heights, then stack on narrow screens.
            local columns= #features>1 and ColumnLayout.new(page,deps,{
                Gap=12,RowGap=10,MinColumnWidth=238,
            }) or nil
            local leftWeight,rightWeight=0,0
            for i,feature in ipairs(features) do
                local side=page
                local left
                if columns then
                    left=leftWeight<=rightWeight
                    side=left and columns.Left or columns.Right
                end
                local section=Section.new(side,deps,{
                    Id=feature.Id,Title=feature.Title or feature.Id,
                    Description=feature.Description,Collapsible=true,
                })
                if not columns then section.Frame.LayoutOrder=i+9 end
                decorateSection(section,feature.Title or feature.Id)
                for _,desc in ipairs(feature.Controls or {}) do
                    local id=tostring(pageDesc.Id).."."..tostring(feature.Id).."."..tostring(desc.Id)
                    local proxy=window.Controls[id]
                    if proxy then
                        makeControl(section.Body,desc,proxy)
                        decorateControl(proxy,desc)
                    end
                end
                if columns then
                    local w=48
                    for _,desc in ipairs(feature.Controls or {}) do
                        if desc.Type=="Paragraph" then w=w+96
                        elseif desc.Type=="Select" or desc.Type=="MultiSelect" then w=w+64
                        elseif desc.Type=="Input" then w=w+70
                        elseif desc.Type=="Slider" then w=w+58
                        else w=w+52 end
                    end
                    if left then leftWeight=leftWeight+w
                    else rightWeight=rightWeight+w end
                end
            end
        end

        for _,pageDesc in ipairs(rapManifest.Pages) do
            local page=app:AddPage({
                Id=pageDesc.Id,
                Title=pageDesc.Title or pageDesc.Id,
                Icon=pageIcon[pageDesc.Icon] or "activity",
                Accent=Tokens.Color.Accent,
            })
            pageEntries[pageDesc.Id]={Page=page,Descriptor=pageDesc}
        end


        -- Presentation preferences only. Never alter or reset game configs.
        local player=game:GetService("Players").LocalPlayer
        local dashboardGreeting,dashboardPortrait
        local privacyEnabled=false
        local selectedAccent="Serenity Grimoire"
        local preferredGlass="Basic"
        local preferredMotion=false
        local persistUI
        local appearanceOptions={
            ["Serenity Grimoire"]=Tokens.Color.Accent,
            ["Aurora"]=Color3.fromRGB(104,194,186),
            ["Deep Ocean"]=Color3.fromRGB(76,176,222),
            ["Moonstone"]=Color3.fromRGB(182,183,237),
            ["Violet"]=Color3.fromRGB(171,136,241),
            ["Rose Quartz"]=Color3.fromRGB(235,158,190),
            ["Jade"]=Color3.fromRGB(101,196,156),
            ["Ember"]=Color3.fromRGB(238,155,102),
            ["Frost"]=Color3.fromRGB(167,206,248),
            ["Graphite"]=Color3.fromRGB(164,179,199),
            ["Garnet"]=Color3.fromRGB(207,105,119),
            ["Antique Gold"]=Color3.fromRGB(216,179,118),
            ["Petrol"]=Color3.fromRGB(84,170,169),
            ["Dusk"]=Color3.fromRGB(158,153,196),
            ["Espresso"]=Color3.fromRGB(184,154,129),
        }
        local settingsEntry
        local settingsWidgets={}
        local function applyAccent(name)
            if not appearanceOptions[name] then return end
            selectedAccent=name
            local color=appearanceOptions[name]
            Tokens.Color.Accent=color
            for _,node in ipairs(app.ScreenGui:GetDescendants()) do
                for _,prop in ipairs({"BackgroundColor3","TextColor3","ImageColor3","Color"}) do
                    if node:GetAttribute("ThemeRole_"..prop)=="Accent" then
                        pcall(function() node[prop]=color end)
                    end
                end
            end
        end
        local function applyPrivacy(value)
            privacyEnabled=value==true
            local identity=app.IdentityName
            if identity then
                identity.Text=privacyEnabled and "Private profile" or player.DisplayName
            end
            local avatar=app.IdentityAvatar
            if avatar then avatar.ImageTransparency=privacyEnabled and 1 or 0 end
            if dashboardGreeting then
                dashboardGreeting.Text=privacyEnabled and "Welcome back" or
                    ("Welcome back, "..player.DisplayName)
            end
            if dashboardPortrait then
                dashboardPortrait.ImageTransparency=privacyEnabled and 1 or 0
            end
        end
        local function buildSettings()
            if not settingsEntry or built["Settings"] then return end
            built["Settings"]=true
            local page=settingsEntry
            local columns=ColumnLayout.new(page,deps,{
                Gap=12,RowGap=10,MinColumnWidth=250,
            })
            local appearance=Section.new(columns.Left,deps,{
                Title="Appearance",
                Description="Personalize Serenity without changing your Ride A Pet automation.",
            })
            settingsWidgets.Accent=Select.new(appearance.Body,deps,{
                Title="Color theme accent",
                Options={"Serenity Grimoire","Aurora","Deep Ocean","Moonstone","Violet",
                    "Rose Quartz","Jade","Ember","Frost","Graphite","Garnet",
                    "Antique Gold","Petrol","Dusk","Espresso"},
                Default=selectedAccent,
                Callback=function(value)
                    applyAccent(value)
                    if persistUI then persistUI() end
                end,
            })
            settingsWidgets.Glass=Select.new(appearance.Body,deps,{
                Title="Glass material",Options={"Off","Basic","Enhanced"},
                Default=preferredGlass,
                Callback=function(value)
                    preferredGlass=value
                    app:SetGlassQuality(value)
                    if persistUI then persistUI() end
                end,
            })
            settingsWidgets.Motion=Toggle.new(appearance.Body,deps,{
                Title="Reduced motion",
                Description="Stops optional UI animations for low-end/mobile devices.",
                Default=preferredMotion,
                Callback=function(value)
                    preferredMotion=value
                    Motion.Reduced=value
                    runtime.ReducedMotion=value
                    if app.RefreshIconMotion then app:RefreshIconMotion() end
                    if persistUI then persistUI() end
                end,
            })
            local privacy=Section.new(columns.Right,deps,{
                Title="Identity & layout",
                Description="Appearance changes are local. Gameplay config is untouched.",
            })
            settingsWidgets.Privacy=Toggle.new(privacy.Body,deps,{
                Title="Hide player identity",
                Description="Hide your name and avatar on the new UI.",
                Default=privacyEnabled,
                Callback=function(value)
                    applyPrivacy(value)
                    if persistUI then persistUI() end
                end,
            })
            local reset=Instance.new("TextButton")
            reset.Name="ResetFloatingPositions"
            reset.Text="Reset floating star / status / Quick Menu positions"
            reset.TextWrapped=true
            reset.Size=UDim2.new(1,0,0,46)
            reset.Font=Enum.Font.GothamMedium
            reset.TextSize=12
            reset.AutoButtonColor=false
            serenityColor(reset,"TextColor3",Tokens,"Text")
            reset.Parent=privacy.Body
            Material.Control(reset,Tokens)
            runtime:TrackConnection(reset.Activated:Connect(function()
                if runtime.Destroyed or serenityInputBlocked(reset) then return end
                app:ResetFloatingPositions()
                if persistUI then persistUI() end
                app:Notify("Layout restored","Floating controls moved back to their default positions.",4,"Success")
            end))
            local appearanceReset=Instance.new("TextButton")
            appearanceReset.Name="RestoreSerenityAppearance"
            appearanceReset.Text="Restore Serenity appearance"
            appearanceReset.Size=UDim2.new(1,0,0,39)
            appearanceReset.Font=Enum.Font.GothamMedium
            appearanceReset.TextSize=12
            appearanceReset.AutoButtonColor=false
            serenityColor(appearanceReset,"TextColor3",Tokens,"Text")
            appearanceReset.Parent=appearance.Body
            Material.Control(appearanceReset,Tokens)
            runtime:TrackConnection(appearanceReset.Activated:Connect(function()
                if runtime.Destroyed or serenityInputBlocked(appearanceReset) then return end
                app:Confirm({
                    Title="Restore appearance",
                    Message="Reset theme accent, glass, reduced motion and privacy? Game settings are not affected.",
                    ConfirmText="Restore",
                    Callback=function(ok)
                        if not ok then return end
                        applyAccent("Serenity Grimoire")
                        preferredGlass="Basic"
                        app:SetGlassQuality("Basic")
                        preferredMotion=false
                        Motion.Reduced=false
                        runtime.ReducedMotion=false
                        if app.RefreshIconMotion then app:RefreshIconMotion() end
                        applyPrivacy(false)
                        settingsWidgets.Accent:Set("Serenity Grimoire",true)
                        settingsWidgets.Glass:Set("Basic",true)
                        settingsWidgets.Motion:Set(false,true)
                        settingsWidgets.Privacy:Set(false,true)
                        if persistUI then persistUI() end
                        app:Notify("Appearance restored","Your game automation settings were not changed.",4,"Success")
                    end,
                })
            end))
            local session=Section.new(columns.Right,deps,{Title="UI information"})
            textLabel(session.Body,
                "Serenity Hub for Ride A Pet · Official UI. Display settings are separate from your gameplay configuration.",
                65,Tokens.Color.TextMuted,12)
        end
        -- New About directory, isolated from gameplay. A configured loader route
        -- is not a guarantee that its payload is healthy.
        local aboutEntry
        local function buildAbout()
            if not aboutEntry or built["About"] then return end
            built["About"]=true
            local page=aboutEntry
            local head=Section.new(page,deps,{Title="Supported Games"})
            textLabel(head.Body,"Serenity Hub game directory. Search configured routes and README listings.",40,Tokens.Color.TextMuted,11)
            local search=Instance.new("TextBox")
            search.Name="SearchSupportedGames"
            search.Size=UDim2.new(1,0,0,38)
            search.Text=""
            search.ClearTextOnFocus=false
            search.TextXAlignment=Enum.TextXAlignment.Left
            search.PlaceholderText="Search 28 games..."
            search.TextSize=12;search.Font=Enum.Font.Gotham
            serenityColor(search,"TextColor3",Tokens,"Text")
            serenityColor(search,"PlaceholderColor3",Tokens,"TextDim")
            search.Parent=head.Body
            Material.Inset(search,Tokens)
            local pad=Instance.new("UIPadding");pad.PaddingLeft=UDim.new(0,10);pad.Parent=search
            local results=Section.new(page,deps,{Title="Game Directory"})
            local names={
                {"Steal A Seed",122216176958450},
                {"Lift a Cube",109530157755211},
                {"Steal An Anime Egg",76377501906469},
                {"Break and Steal an Egg",114326934417838},
                {"Ride A Pet",124216119978534},
                {"+1 Strength to Grow Your Arm",86259628805375},
                {"Anime Dice",113290951185459},
                {"+1 Loot to Forge",118805555015549},
                {"Lift Rock for Eggs",76731343328034},
                {"+1 Drain Water Per Click",103883942725157},
                {"Sell Ores",122572082932179},
                {"+1 Cut Grass Adventure",90086669327265},
                {"Greedy Growers",74102906764176},
                {"Chicken Farm",137233438285284},
                {"+1 Monkey Evolution",91701030914075},
                {"+1 Superhero Evolution",97824450589417},
                {"Heroes RNG",108307565942574},
                {"Throw a Coin",115681808123944},
                {"Cheating During Testing",98894876188248},
                {"Roll Anime to Fight",107653945083776},
                {"+1 Dino Evolution",103138601755519},
                {"+1 Phonk Evolution",104809044319701},
                {"Unscathed RNG",122951224417794},
                {"Mine a Mountain",125927821145949},
                {"Search for the Needle",77108422251420},
                {"+1 Tongue Escape",122245938604556},
                {"Collect All the Leaves",nil},
                {"Jump To Steal Soccer Players",nil},
            }
            local rows={}
            for i,record in ipairs(names) do
                local btn=Instance.new("TextButton")
                btn.Name="Game"..i
                btn.Text=""
                btn.Size=UDim2.new(1,0,0,46)
                btn.LayoutOrder=i
                btn.AutoButtonColor=false
                btn.Parent=results.Body
                Material.Control(btn,Tokens)
                Icons.Create(btn,record[2] and "world" or "info",17,Tokens.Color.Accent,
                    UDim2.fromOffset(10,13))
                local txt=textLabel(btn,record[1],23,Tokens.Color.Text,12)
                txt.Position=UDim2.fromOffset(35,4)
                txt.Size=UDim2.new(1,-47,0,23)
                txt.TextTruncate=Enum.TextTruncate.AtEnd
                local current=record[2]==game.PlaceId
                local sub=textLabel(btn,current and "CURRENT GAME  ·  Route configured"
                  or (record[2] and "ROUTED  ·  Tap to copy game link"
                  or "README ONLY  ·  Route unverified"),16,Tokens.Color.TextMuted,10)
                sub.Position=UDim2.fromOffset(35,26)
                sub.Size=UDim2.new(1,-47,0,16)
                runtime:TrackConnection(btn.Activated:Connect(function()
                    if serenityInputBlocked(btn) or runtime.Destroyed then return end
                    if not record[2] then
                        app:Notify("Route unverified","This README listing has no confirmed link in inspected loaders.",5,"Info")
                        return
                    end
                    local url="https://www.roblox.com/games/"..tostring(record[2])
                    local copy=setclipboard or toclipboard
                    if type(copy)=="function" and pcall(copy,url) then
                        app:Notify("Game link copied",record[1],4,"Success")
                    else app:Notify("Game URL",url,7,"Info") end
                end))
                rows[#rows+1]={btn,record[1]}
            end
            runtime:TrackConnection(search:GetPropertyChangedSignal("Text"):Connect(function()
                local query=string.lower(search.Text or "")
                for _,entry in ipairs(rows) do
                    entry[1].Visible=query=="" or string.find(string.lower(entry[2]),query,1,true)~=nil
                end
            end))
            local footer=Section.new(page,deps,{Title="About Serenity"})
            textLabel(footer.Body,"M4.78 Ride A Pet UI · Directory snapshot 2026-10-20. Configured route is not live support verification.",56,Tokens.Color.TextMuted,11)
        end
        aboutEntry=app:AddPage({Id="About",Title="About",Icon="info",Order=19})
        settingsEntry=app:AddPage({
            Id="Settings",Title="Settings",Icon="settings",Order=20,Group="System",
        })
        -- Build dashboard immediately; other pages only when selected.
        local oldSelect=app.SelectPage
        function app:SelectPage(pageId)
            local entry=pageEntries[pageId]
            if pageId=="About" then buildAbout() end
            if pageId=="Settings" then buildSettings() end
            if entry then fillPage(entry.Descriptor) end
            return oldSelect(self,pageId)
        end

        -- Restored M4 dashboard: hero + avatar, grounded session information,
        -- Quick Menu cards, What is New, and the original Discord tile.
        local dashboard=pageEntries["Dashboard"].Page
        local player=game:GetService("Players").LocalPlayer
        local sessionStart=os.clock()
        local function widthOf(frame)
            return frame.AbsoluteSize.X/math.max(0.01,(deps.UIScale and deps.UIScale.Scale or 1))
        end
        local function card(parent,height,order)
            local f=Instance.new("Frame")
            f.Size=UDim2.new(1,-4,0,height)
            f.LayoutOrder=order
            f.Parent=parent
            Material.Section(f,Tokens)
            return f
        end
        local function headline(parent,text,x,y,w,h,size,role)
            local l=Typography.Label(parent,"Control",Tokens,text,
                UDim2.fromOffset(x,y),UDim2.new(1,w,0,h),
                (Tokens.Color[role or "Text"] or Tokens.Color.Text),
                role or "Text")
            l.TextSize=size or 12
            l.TextTruncate=Enum.TextTruncate.AtEnd
            if size and size>=14 then l.Font=Enum.Font.GothamBold end
            return l
        end
        local function button(parent,title,x,y,w,callback)
            local b=Instance.new("TextButton")
            b.Name="DashboardAction"
            b.Position=UDim2.fromOffset(x,y)
            b.Size=UDim2.fromOffset(w,34)
            b.Text=title
            b.Font=Enum.Font.GothamMedium
            b.TextSize=12
            b.AutoButtonColor=false
            serenityColor(b,"TextColor3",Tokens,"Text")
            b.Parent=parent
            Material.Inset(b,Tokens)
            runtime:TrackConnection(b.Activated:Connect(function()
                if not runtime.Destroyed and not serenityInputBlocked(b) then callback() end
            end))
            return b
        end

        local heroHeading=Instance.new("Frame")
        heroHeading.Name="DashboardHeading"
        heroHeading.BackgroundTransparency=1
        heroHeading.Size=UDim2.new(1,-4,0,46)
        heroHeading.LayoutOrder=1
        heroHeading.Parent=dashboard
        headline(heroHeading,"Dashboard",0,0,-118,27,23)
        headline(heroHeading,"Your Ride A Pet grimoire",0,27,-118,19,12,"TextMuted")
        local testBadge=headline(heroHeading,"OFFICIAL · v152",-120,9,-4,20,10,"Accent")
        testBadge.AnchorPoint=Vector2.new(1,0)
        testBadge.Position=UDim2.new(1,0,0,7)
        testBadge.Size=UDim2.fromOffset(117,24)
        testBadge.TextXAlignment=Enum.TextXAlignment.Center
        Material.Inset(testBadge,Tokens)

        local hero=card(dashboard,139,2)
        hero.Name="DashboardHero"
        hero.ClipsDescendants=true
        local greeting=headline(hero,"Welcome back, "..player.DisplayName,18,14,-125,28,20)
        dashboardGreeting=greeting
        local guide=headline(hero,"Auto Steal, Fusion and Halloween in one workspace.",18,46,-127,34,12,"TextMuted")
        guide.TextWrapped=true
        local portrait=Instance.new("ImageLabel")
        portrait.Name="DashboardAvatar"
        portrait.Size=UDim2.fromOffset(68,68)
        portrait.AnchorPoint=Vector2.new(1,0)
        portrait.Position=UDim2.new(1,-18,0,18)
        portrait.BackgroundTransparency=0.16
        portrait.Image="rbxthumb://type=AvatarHeadShot&id="..tostring(player.UserId).."&w=420&h=420"
        portrait.Parent=hero
        serenityColor(portrait,"BackgroundColor3",Tokens,"PanelSoft")
        dashboardPortrait=portrait
        local cir=Instance.new("UICorner")
        cir.CornerRadius=UDim.new(1,0)
        cir.Parent=portrait
        local avatarEdge=Instance.new("UIStroke")
        serenityColor(avatarEdge,"Color",Tokens,"Accent")
        avatarEdge.Transparency=0.48
        avatarEdge.Parent=portrait
        local openEggs=button(hero,"Manage eggs  ›",18,94,150,function() app:SelectPage("Eggs") end)
        local openFusion=button(hero,"Customize  ›",178,94,142,function() app:SelectPage("Settings") end)
        local function arrangeHero()
            local w=widthOf(hero)
            portrait.Visible=w>=380
            greeting.Size=UDim2.new(1,portrait.Visible and -125 or -35,0,28)
            guide.Size=UDim2.new(1,portrait.Visible and -125 or -35,0,36)
            openEggs.Size=UDim2.fromOffset(math.max(105,math.min(150,(w-44)/2)),34)
            openFusion.Position=UDim2.fromOffset(26+openEggs.Size.X.Offset,94)
            openFusion.Size=UDim2.fromOffset(math.max(105,math.min(142,(w-44)/2)),34)
        end
        runtime:TrackConnection(hero:GetPropertyChangedSignal("AbsoluteSize"):Connect(arrangeHero))
        arrangeHero()

        local metrics=Instance.new("Frame")
        metrics.Name="DashboardSessionMetrics"
        metrics.BackgroundTransparency=1
        metrics.Size=UDim2.new(1,-4,0,61)
        metrics.LayoutOrder=3
        metrics.Parent=dashboard
        local metricTiles,metricValues={},{}
        for i,data in ipairs({
            {"SESSION","00:00","activity"},
            {"CURRENT PLACE",tostring(game.PlaceId),"world"},
            {"AUTOMATION","See controls","target"},
        }) do
            local tile=card(metrics,60,i)
            metricTiles[i]=tile
            Icons.Create(tile,data[3],16,Tokens.Color.Accent,UDim2.fromOffset(12,10))
            headline(tile,data[1],35,8,-47,18,10,"TextMuted")
            metricValues[i]=headline(tile,data[2],13,31,-25,20,13)
        end
        local function arrangeMetrics()
            local w=widthOf(metrics)
            if w<=0 then return end
            local count=w>=480 and 3 or (w>=330 and 2 or 1)
            local gap=8
            local colWidth=(w-gap*(count-1))/count
            for i,tile in ipairs(metricTiles) do
                tile.Size=UDim2.fromOffset(colWidth,60)
                tile.Position=UDim2.fromOffset(((i-1)%count)*(colWidth+gap),
                    math.floor((i-1)/count)*68)
            end
            metrics.Size=UDim2.new(1,-4,0,math.ceil(3/count)*68-8)
        end
        runtime:TrackConnection(metrics:GetPropertyChangedSignal("AbsoluteSize"):Connect(arrangeMetrics))
        arrangeMetrics()
        local clockThread
        -- Status comes from the same shared runtime as the game workers.
        local function getLiveActivity()
            local hub=shared and shared.SerenityRideAPet
            local cfg=hub and hub.Config or {}
            local fusion=hub and hub.AutoFusionFeature
            local steal=hub and hub.StealActionRuntime
            local busy=type(steal)=="table" and steal.Busy==true
            if hub and type(hub.IsStealActionBusy)=="function" then
                local ok,value=pcall(hub.IsStealActionBusy)
                if ok and value then busy=true end
            end
            local recollect=hub and type(hub.ForcedRecollectRuntime)=="table"
                and hub.ForcedRecollectRuntime.Active==true
            local fBusy=fusion and fusion.Busy==true
            local fPending=fusion and fusion.PriorityPending==true
            local eventEnabled=cfg.AutoCollectHalloweenCandy==true or
                cfg.AutoHalloweenRitual==true or cfg.AutoBuyHalloweenEgg==true
            local inHalloween=player:GetAttribute("InHalloweenZone")==true
            local count=0
            for _,flag in ipairs({
                cfg.AutoSteal,cfg.AutoFusion,cfg.AutoCollectHalloweenCandy,
                cfg.AutoHalloweenRitual,cfg.AutoBuyHalloweenEgg,cfg.AutoSell,
            }) do if flag==true then count=count+1 end end
            if busy or recollect then
                return "Auto Steal · Working",
                    recollect and "Recovering selected egg" or "Pickup / claim in progress",count
            end
            if fBusy then
                return "Auto Fusion · Working",
                    tostring(fusion.LastStatus or "Fusion transaction in progress"),count
            end
            if inHalloween and eventEnabled then
                return "Halloween Event · Active","Inside Halloween event",count
            end
            if fPending then
                return "Auto Fusion · Pending",
                    tostring(fusion.LastStatus or "Waiting for priority"),count
            end
            if cfg.AutoSteal==true then
                return "Auto Steal · Watching eggs","Waiting for eligible eggs",count
            end
            if cfg.AutoFusion==true then
                return "Auto Fusion · Waiting",
                    tostring(fusion and fusion.LastStatus or "Waiting for four matching pets"),count
            end
            if eventEnabled then
                return "Halloween Event · Waiting","Waiting for available Halloween activities",count
            end
            if cfg.AutoSell==true then
                return "Auto Sell · Waiting","Waiting for eligible selling action",count
            end
            return "Ride A Pet · Idle","Main automations are turned off",count
        end
        local activityLabel
        local activityDetailLabel
        local lastTitle,lastDetail
        local function updateActivity()
            local title,detail,count=getLiveActivity()
            if title~=lastTitle then
                lastTitle=title
                app:SetStatus(title)
                if activityLabel and activityLabel.Parent then activityLabel.Text=title end
            end
            if detail~=lastDetail then
                lastDetail=detail
                if activityDetailLabel and activityDetailLabel.Parent then
                    activityDetailLabel.Text=detail
                end
                app:SetStatusDetails({detail,"Steal → Fusion → Halloween → Sell"})
            end
            return title,detail,count
        end
        local function updateClock()
            clockThread=nil
            if runtime.Destroyed then return end
            local t=math.floor(os.clock()-sessionStart)
            local displayTime=string.format("%02d:%02d",math.floor(t/60),t%60)
            local liveTitle,liveDetail,enabledCount=updateActivity()
            app:SetStatusSummary(tostring(enabledCount).." enabled",displayTime)
            -- Do not stop status when minimized. Only visible dashboard
            -- widgets are refreshed, while one shared 1 Hz clock stays alive.
            if dashboard.Visible and app.Holder.Visible then
                metricValues[1].Text=displayTime
                metricValues[3].Text=liveTitle
            end
            clockThread=task.delay(1,updateClock)
        end
        runtime:TrackCleanup(function()
            if clockThread then pcall(task.cancel,clockThread);clockThread=nil end
        end)
        updateClock()

        local quick=card(dashboard,122,4)
        quick.Name="QuickMenuDashboard"
        Icons.Create(quick,"activity",16,Tokens.Color.Accent,UDim2.fromOffset(14,12))
        headline(quick,"Quick Menu",38,8,-48,24,15)
        headline(quick,"Floating panel visibility · independent from automation",14,31,-28,19,11,"TextMuted")
        local quickCards={}
        local quickSetup={
            {"steal","Auto Steal","Eggs.Steal.Enabled","target"},
            {"fusion","Auto Fusion","Fuse.AutoFuse.Enabled","progression"},
            {"candy","Auto Candy","Event.Halloween.AutoCollectCandy","activity"},
        }
        for _,setting in ipairs(quickSetup) do
            local id,title,path,icon=setting[1],setting[2],setting[3],setting[4]
            local proxy=window.Controls[path]
            if proxy and type(proxy.Descriptor.Changed)=="function" then
                proxy.QuickId=id
                app:RegisterQuickAction({
                    Id=id,Title=title,Default=proxy.Value==true,
                    PanelEnabled=false,
                    Callback=function(value)
                        proxy.Value=value
                        if proxy.Widget then proxy.Widget:Set(value,true) end
                        sendChanged(proxy.Descriptor,value)
                        return true
                    end,
                })
                local tile=Instance.new("TextButton")
                tile.Name="QuickPanel_"..id
                tile.Text=""
                tile.AutoButtonColor=false
                tile.Parent=quick
                Material.Inset(tile,Tokens)
                Icons.Create(tile,icon,19,Tokens.Color.Accent,UDim2.fromOffset(12,11))
                local tileTitle=headline(tile,title,38,7,-68,22,12)
                local state=headline(tile,"Panel hidden",38,30,-68,17,10,"TextMuted")
                local onDot=Instance.new("Frame")
                onDot.Name="AvailabilityIndicator"
                onDot.Size=UDim2.fromOffset(9,9)
                onDot.Position=UDim2.new(1,-18,0,14)
                onDot.BorderSizePixel=0
                onDot.Parent=tile
                local dotCorner=Instance.new("UICorner")
                dotCorner.CornerRadius=UDim.new(1,0);dotCorner.Parent=onDot
                runtime:TrackConnection(tile.Activated:Connect(function()
                    if runtime.Destroyed or serenityInputBlocked(tile) then return end
                    local action=app:GetQuickAction(id)
                    if action then app:SetQuickPanelEnabled(id,not action.PanelEnabled) end
                end))
                app:ObserveQuickAction(id,function(action)
                    state.Text=action.PanelEnabled and (action.Value and "ON  ·  Panel visible" or "OFF  ·  Panel visible")
                        or (action.Value and "ON  ·  Panel hidden" or "OFF  ·  Panel hidden")
                    serenityColor(onDot,"BackgroundColor3",Tokens,action.PanelEnabled and "Accent" or "Disabled")
                end)
                quickCards[#quickCards+1]=tile
            end
        end
        local function arrangeQuick()
            local w=widthOf(quick)
            if w<=0 then return end
            local n=w>=480 and 3 or 1
            local gap=8
            local tileWidth=(w-28-gap*(n-1))/n
            for i,tile in ipairs(quickCards) do
                tile.Size=UDim2.fromOffset(tileWidth,56)
                tile.Position=UDim2.fromOffset(14+((i-1)%n)*(tileWidth+gap),
                    61+math.floor((i-1)/n)*65)
            end
            quick.Size=UDim2.new(1,-4,0,66+math.ceil(#quickCards/n)*65)
        end
        runtime:TrackConnection(quick:GetPropertyChangedSignal("AbsoluteSize"):Connect(arrangeQuick))
        arrangeQuick()

        local activityPanel=card(dashboard,154,5)
        activityPanel.Name="RideAPetLiveStatus"
        Icons.Create(activityPanel,"activity",18,Tokens.Color.Accent,UDim2.fromOffset(14,12))
        headline(activityPanel,"Live Activity",42,8,-56,23,15)
        activityLabel=headline(activityPanel,"Ride A Pet · Ready",14,39,-28,29,19)
        activityLabel.Name="RideAPetStatusText"
        activityDetailLabel=headline(activityPanel,"Connecting to game runtime",14,72,-28,23,12,"TextMuted")
        headline(activityPanel,"PRIORITY   STEAL   →   FUSION   →   HALLOWEEN",14,101,-28,20,10,"TextMuted")
        local statusButtons=Instance.new("Frame")
        statusButtons.Size=UDim2.new(1,-24,0,36)
        statusButtons.Position=UDim2.fromOffset(12,123)
        statusButtons.BackgroundTransparency=1
        statusButtons.Parent=activityPanel
        local eggs=button(statusButtons,"Eggs  ›",0,1,98,function() app:SelectPage("Eggs") end)
        local fuse=button(statusButtons,"Fusion  ›",106,1,98,function() app:SelectPage("Fuse") end)
        local event=button(statusButtons,"Event  ›",212,1,98,function() app:SelectPage("Event") end)
        activityPanel.Size=UDim2.new(1,-4,0,168)
        runtime:TrackConnection(statusButtons:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            local w=widthOf(statusButtons)
            local gap=7
            local tileWidth=(w-2*gap)/3
            for i,b in ipairs({eggs,fuse,event}) do
                b.Size=UDim2.fromOffset(tileWidth,34)
                b.Position=UDim2.fromOffset((i-1)*(tileWidth+gap),1)
            end
        end))
        updateActivity()

        local news=Section.new(dashboard,deps,{Title="What's New · v152"})
        news.Frame.LayoutOrder=6
        decorateSection(news,"What's New")
        for _,item in ipairs({
            {"Live activity","Status stays current even when the window is minimized."},
            {"Responsive game pages","Your existing game controls now fit desktop and mobile layouts."},
            {"Refined Serenity interface","New icons, themed settings and saved Quick Menu positions."},
        }) do
            local itemFrame=Instance.new("Frame")
            itemFrame.Size=UDim2.new(1,0,0,44)
            itemFrame.BackgroundTransparency=1
            itemFrame.Parent=news.Body
            local tick=Instance.new("Frame")
            tick.Position=UDim2.fromOffset(10,11)
            tick.Size=UDim2.fromOffset(3,19)
            tick.BackgroundColor3=Tokens.Color.Accent
            tick.BorderSizePixel=0
            tick.Parent=itemFrame
            headline(itemFrame,item[1],23,0,-32,22,12)
            local sub=headline(itemFrame,item[2],23,21,-32,20,11,"TextMuted")
            sub.TextTruncate=Enum.TextTruncate.AtEnd
        end

        local community=card(dashboard,85,7)
        Icons.Create(community,"discord",24,Tokens.Color.Accent,UDim2.fromOffset(14,15))
        headline(community,"Serenity Hub Discord",48,10,-180,23,15)
        local communityDesc=headline(community,"Support, news and community.",48,35,-180,31,11,"TextMuted")
        communityDesc.TextWrapped=true
        local join=button(community,"Join Discord  ↗",0,0,126,function()
            app:Confirm({
                Title="Serenity Hub Discord",
                Message="Copy the community invite to open it in Discord or your browser?",
                ConfirmText="Copy invite",
                Callback=function(confirmed)
                    if not confirmed then return end
                    local copy=setclipboard or toclipboard
                    local ok=type(copy)=="function" and pcall(copy,"https://discord.gg/pWPs7428wE")
                    app:Notify("Serenity Hub",ok and "Invite copied." or
                        "discord.gg/pWPs7428wE",5,ok and "Success" or "Info")
                end,
            })
        end)
        local function arrangeCommunity()
            local w=widthOf(community)
            local wide=w>=440
            community.Size=UDim2.new(1,-4,0,wide and 82 or 128)
            communityDesc.Size=UDim2.new(1,wide and -187 or -65,0,32)
            join.Position=wide and UDim2.new(1,-141,0.5,-17) or UDim2.fromOffset(14,82)
        end
        runtime:TrackConnection(community:GetPropertyChangedSignal("AbsoluteSize"):Connect(arrangeCommunity))
        arrangeCommunity()

        -- Keep the original Dashboard manifest help/status data as a real
        -- full-width section at the bottom, rather than a half-width ghost.
        -- The Dashboard is purpose-built, not a stack of static V3 paragraphs.
        built["Dashboard"]=true
        app:SelectPage("Dashboard")

        -- No gameplay state is written by presentation restores.
        local prefsPath="SerenityHub/RideAPet_M478_UI_Prefs.json"
        local http=game:GetService("HttpService")
        local canRead=type(readfile)=="function" and type(isfile)=="function"
        if canRead then
            local ok,data=pcall(function()
                return isfile(prefsPath) and http:JSONDecode(readfile(prefsPath)) or nil
            end)
            if ok and type(data)=="table" then
                if type(data.Appearance)=="table" then
                    local a=data.Appearance
                    if appearanceOptions[a.Accent] then applyAccent(a.Accent) end
                    if a.Glass=="Off" or a.Glass=="Basic" or a.Glass=="Enhanced" then
                        preferredGlass=a.Glass;app:SetGlassQuality(preferredGlass)
                    end
                    preferredMotion=a.ReducedMotion==true
                    Motion.Reduced=preferredMotion
                    runtime.ReducedMotion=preferredMotion
                    applyPrivacy(a.HideIdentity==true)
                end
                if type(data.UI)=="table" then
                    app:RestoreUIPreferences(data.UI)
                end
                if type(data.View)=="table" then app:RestoreViewState(data.View) end
            end
        end
        local saveThread
        local function saveView()
            if saveThread then pcall(task.cancel,saveThread);saveThread=nil end
            if type(writefile)~="function" or runtime.Destroyed then return end
            saveThread=task.delay(1.2,function()
                saveThread=nil
                if runtime.Destroyed then return end
                pcall(function()
                    if type(makefolder)=="function" then makefolder("SerenityHub") end
                    writefile(prefsPath,http:JSONEncode({
                        View=app:GetViewState(),
                        UI=app:GetUIPreferences(),
                        Appearance={
                            Accent=selectedAccent,Glass=preferredGlass,
                            ReducedMotion=preferredMotion,HideIdentity=privacyEnabled,
                        },
                    }))
                end)
            end)
        end
        persistUI=saveView
        app.OnViewChanged=saveView
        runtime:TrackCleanup(function()
            activeCallbacks=false
            if saveThread then pcall(task.cancel,saveThread) end
        end)
        local result={Window=window,Adapter=adapter,Runtime=runtime}
        function result:Destroy()
            runtime:Destroy()
        end
        return result
    end)()
end

error("[SERENITY HUB] Official Ride A Pet UI requires a valid manifest",0)
end
