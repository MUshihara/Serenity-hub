-- SERENITY HUB // OFFICIAL MANIFEST RENDERER V3
local Adapter = {}
Adapter.__index = Adapter

local function platformVisible(node, layout)
    if node.DesktopOnly and layout ~= "Desktop" then return false end
    if node.MobileOnly and layout ~= "Mobile" then return false end
    if node.Platforms then
        local ok = false
        for _,v in ipairs(node.Platforms) do
            if v == layout then ok = true break end
        end
        if not ok then return false end
    end
    return true
end

local function safeCallback(callback, ...)
    if type(callback) ~= "function" then return true end
    local args = table.pack(...)
    task.spawn(function()
        local ok, err = xpcall(function()
            callback(table.unpack(args,1,args.n))
        end,debug.traceback)
        if not ok then
            warn("[SERENITY HUB] Control callback failed:\n"..tostring(err))
        end
    end)
    return true
end

function Adapter.new(options)
    local self = setmetatable({},Adapter)
    self.Layout = assert(options.Layout)
    self.Library = assert(options.Library)
    self.Config = assert(options.Config)
    self.Runtime = assert(options.Runtime)
    self.Manifest = assert(options.Manifest)
    self.Window = nil
    self.Controls = {}
    self.Features = {}
    return self
end

function Adapter:_key(page, feature, control)
    return table.concat({page.Id,feature.Id,control.Id},".")
end

function Adapter:_defaultValue(page,feature,control)
    local key = self:_key(page,feature,control)
    local current = self.Config:Get(key,nil)
    if current ~= nil then return current end
    self.Config:Set(key,control.Default,true)
    return control.Default
end

function Adapter:_changed(page,feature,control,value)
    local key = self:_key(page,feature,control)
    self.Config:Set(key,value,false)
    safeCallback(control.Changed or control.Callback,value,self.Window,self)
end

function Adapter:_makeControl(parent,page,feature,control)
    if not platformVisible(control,self.Layout) then return end
    local W = self.Window
    local key = self:_key(page,feature,control)
    local opts = {
        Accent = control.Accent or feature.Accent,
        ButtonText = control.ButtonText,
        Confirm = control.Confirm,
        ConfirmText = control.ConfirmText,
        ConfirmTimeout = control.ConfirmTimeout,
        Danger = control.Danger,
        EmptyMeansAll = control.EmptyMeansAll,
        EmptyText = control.EmptyText,
        SummaryCharacters = control.SummaryCharacters,
        Numeric = control.Numeric,
        Integer = control.Integer,
        Min = control.Min,
        Max = control.Max,
        Suffix = control.Suffix,
        Placeholder = control.Placeholder,
    }

    local item
    if control.Type == "Action" then
        item = W:Action(parent,control.Title,control.Description,function()
            if control.CoreAction == "SaveConfig" then
                local ok = self.Config:SaveNow()
                if type(W.Notify) == "function" then
                    W:Notify("Config",ok and "Settings saved." or "File save unavailable.",ok)
                end
            elseif control.CoreAction == "ResetConfig" then
                self:ResetAll()
                if type(W.Notify) == "function" then
                    W:Notify("Config","Settings reset to defaults.",true)
                end
            else
                safeCallback(control.Callback,W,self)
            end
        end,opts)
    elseif control.Type == "Switch" then
        local value = self:_defaultValue(page,feature,control) == true
        item = W:Switch(parent,key,control.Title,control.Description,value,function(v)
            self:_changed(page,feature,control,v)
        end,opts)
    elseif control.Type == "Select" then
        local value = self:_defaultValue(page,feature,control)
        item = W:Select(parent,key,control.Title,control.Description,control.Options,value,function(v)
            self:_changed(page,feature,control,v)
        end,opts)
    elseif control.Type == "MultiSelect" then
        local value = self:_defaultValue(page,feature,control) or {}
        item = W:MultiSelect(parent,key,control.Title,control.Description,control.Options,value,function(v)
            self:_changed(page,feature,control,v)
        end,opts)
    elseif control.Type == "Slider" then
        local value = self:_defaultValue(page,feature,control)
        if self.Layout == "Desktop" then
            item = W:Slider(parent,key,control.Title,control.Min,control.Max,value,function(v)
                self:_changed(page,feature,control,v)
            end,control.Suffix or "")
        else
            item = W:Slider(parent,key,control.Title,control.Description,control.Min,control.Max,value,function(v)
                self:_changed(page,feature,control,v)
            end,opts)
        end
    elseif control.Type == "Input" then
        local value = self:_defaultValue(page,feature,control)
        item = W:Input(parent,key,control.Title,control.Description,value,function(v)
            self:_changed(page,feature,control,v)
        end,opts)
    elseif control.Type == "Live" then
        item = W:Live(parent,control.Title,control.Value or control.Default or "--")
    elseif control.Type == "Progress" then
        if self.Layout == "Desktop" then
            item = W:Progress(parent,key,control.Title,control.Description,control.Value or control.Default or 0,{
                Accent=opts.Accent,Min=control.Min or 0,Max=control.Max or 100
            })
        else
            item = W:Progress(parent,control.Title,control.Value or control.Default or 0,{
                Accent=opts.Accent,Min=control.Min or 0,Max=control.Max or 100
            })
        end
    elseif control.Type == "Paragraph" then
        item = W:Paragraph(parent,control.Title or "Information",control.Text or control.Description or "")
    end

    if control.Id then self.Controls[key] = item end
    return item
end

-- Shared Dashboard identity is intentionally NOT owned by a game
-- manifest. Every supported game receives it automatically so a new game
-- cannot accidentally ship without the experience/player identity cards.
function Adapter:_addDefaultDashboardIdentity(pageObject, leftColumn)
    local W = self.Window

    if self.Layout == "Desktop" then
        local group = W:Group(
            leftColumn,
            "Account",
            "Current experience and player identity.",
            {Accent="cyan"}
        )

        if type(W.GameCard) == "function" then
            W:GameCard(group,{
                FallbackName=self.Manifest.GameName or "Current Experience",
                Description="Current supported experience",
                Status="SUPPORTED",
                Accent=Color3.fromRGB(56,220,235),
            })
        end

        if type(W.PlayerCard) == "function" then
            W:PlayerCard(group,{
                Kicker="PLAYER",
                Accent=Color3.fromRGB(73,235,190),
            })
        end

        self.Features["Dashboard.__SerenityAccount"] = group
        return group
    end

    local content = W:Feature(
        pageObject,
        "Account",
        "Current game and player identity.",
        {
            Accent="cyan",
            Expanded=true,
        }
    )

    if type(W.GameCard) == "function" then
        W:GameCard(content)
    end

    if type(W.PlayerCard) == "function" then
        W:PlayerCard(content)
    end

    self.Features["Dashboard.__SerenityAccount"] = content
    return content
end

function Adapter:Build()
    local createOptions
    if self.Layout == "Desktop" then
        createOptions = {
            Width = self.Manifest.DesktopWidth or 920,
            Height = self.Manifest.DesktopHeight or 570,
            DiscordInvite = self.Library.DiscordInvite,
            ShowTopProfile = true,
            PremiumMotion = true,
        }
    else
        createOptions = {
            Width = self.Manifest.MobileWidth or 650,
            Height = self.Manifest.MobileHeight or 420,
            Theme = "Serenity",
            DisableInternalConfig = true,
            ConfigPath = "SerenityHub/_renderer-internal-disabled.json",
        }
    end

    local W = self.Library.Create(createOptions)
    self.Window = W
    self.Runtime:TrackChild(W)

    for _,page in ipairs(self.Manifest.Pages) do
        if platformVisible(page,self.Layout) then
            local pageObject
            if self.Layout == "Desktop" then
                pageObject = W:AddPage(page.Title,page.Icon)
                local isDashboard = page.Id == "Dashboard" or page.Title == "Dashboard"
                local left = W:Section(
                    pageObject,
                    isDashboard and "Account & Features" or (page.LeftTitle or "Features"),
                    false
                )
                local right = W:Section(pageObject,page.RightTitle or "More",true)

                -- Account identity is a shared Serenity default rather than
                -- duplicated in every individual game manifest.
                local visibleIndex = 0
                if isDashboard then
                    self:_addDefaultDashboardIdentity(pageObject,left)

                    -- Start manifest features on the opposite column so the
                    -- desktop dashboard remains visually balanced.
                    visibleIndex = 1
                end

                for _,feature in ipairs(page.Features or {}) do
                    if platformVisible(feature,self.Layout) then
                        visibleIndex += 1
                        local column = feature.Column == "Right" and right
                            or feature.Column == "Left" and left
                            or (visibleIndex % 2 == 0 and right or left)
                        local group = W:Group(column,feature.Title,feature.Description,{
                            Accent=feature.Accent
                        })
                        self.Features[page.Id.."."..feature.Id] = group
                        for _,control in ipairs(feature.Controls or {}) do
                            self:_makeControl(group,page,feature,control)
                        end
                    end
                end
            else
                pageObject = W:AddPage(page.Title,{Icon=page.Icon})

                if page.Id == "Dashboard" or page.Title == "Dashboard" then
                    self:_addDefaultDashboardIdentity(pageObject,nil)
                end

                for _,feature in ipairs(page.Features or {}) do
                    if platformVisible(feature,self.Layout) then
                        local content = W:Feature(pageObject,feature.Title,feature.Description,{
                            Accent=feature.Accent,
                            Expanded=feature.Expanded == true,
                        })
                        self.Features[page.Id.."."..feature.Id] = content
                        for _,control in ipairs(feature.Controls or {}) do
                            self:_makeControl(content,page,feature,control)
                        end
                    end
                end
            end
        end
    end

    local firstPage
    for _,page in ipairs(self.Manifest.Pages) do
        if platformVisible(page,self.Layout) then firstPage = page.Title break end
    end
    if firstPage then W:SwitchPage(firstPage) end
    if self.Layout == "Desktop" and type(W.Open)=="function" then W:Open() end
    if type(W.SetStatus)=="function" then W:SetStatus("READY","idle") end

    return W
end

function Adapter:ResetAll()
    -- Apply defaults through the normal control Set path so running
    -- controllers receive the same state changes as a real user action.
    for _,page in ipairs(self.Manifest.Pages or {}) do
        for _,feature in ipairs(page.Features or {}) do
            for _,control in ipairs(feature.Controls or {}) do
                if control.Id and control.Default ~= nil then
                    local key = self:_key(page,feature,control)
                    local item = self.Controls[key]
                    if item and type(item.Set) == "function" then
                        pcall(function() item:Set(control.Default,false) end)
                    else
                        self.Config:Set(key,control.Default,true)
                    end
                end
            end
        end
    end
    self.Config:SaveNow()
end

function Adapter:SetLive(fullId,value)
    local item = self.Controls[fullId]
    if typeof(item) == "Instance" and item:IsA("TextLabel") then
        item.Text = tostring(value)
        return true
    end
    if type(item) == "table" and type(item.Set)=="function" then
        item:Set(value)
        return true
    end
    return false
end

return Adapter
