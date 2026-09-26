local I18N={}
I18N.Options={'English','Filipino','Bahasa Indonesia','Tiếng Việt','ไทย','Español','Português (Brasil)','Français','Deutsch','Русский'}
local codes={'en','fil','id','vi','th','es','pt','fr','de','ru'}
local supported={en=true,fil=true,id=true,vi=true,th=true,es=true,pt=true,fr=true,de=true,ru=true}
local aliases={tl='fil',['in']='id'}
function I18N.Resolve(locale)
    local code=tostring(locale or ''):lower():gsub('_','-'):match('^([a-z]+)')
    code=aliases[code] or code
    return supported[code] and code or 'en'
end
function I18N.Code(selection)
    for i,name in ipairs(I18N.Options) do if name==selection then return codes[i] end end
    return 'en'
end
function I18N.new(selection,detected)
    local self={Bindings={},Selection=selection,Detected=detected,Destroyed=false}
    function self:Language()
        local chosen=I18N.Code(self.Selection)
        return chosen
    end
    function self:T(source)
        if type(source)~='string' or source=='' then return source end
        local pack=I18N.Packs[self:Language()] or {}
        if pack[source] then return pack[source] end
        -- Only translate dictionary-backed labels with numeric values. Never rewrite names.
        local label,separator,value=source:match('^(.-)(: )([%d][%d,%.]*)$')
        if not label then label,separator,value=source:match('^(.-)( · )([%d][%d,%.]*)$') end
        if label and pack[label] then return pack[label]..separator..value end
        local selected=source:match('^Language changed: (.+)$')
        if selected then return (pack['Language changed'] or 'Language changed')..': '..selected end
        -- Translate only known UI patterns; never edit a user's text or arbitrary values.
        local time=source:match('^Session · (%d+:%d%d:%d%d)$')
        if time then return (pack.Session or 'Session')..' · '..time end
        local count=source:match('^(%d+ / 1800) characters$')
        if count then return count..' '..(pack.characters or 'characters') end
-- BEGIN LOOT TO FORGE DYNAMIC LOCALIZATION
        local function ltfFormat(key,...)
            local template=pack[key]
            if not template then return nil end
            local ok,result=pcall(string.format,template,...)
            return ok and result or nil
        end
        local equipType,equipName=source:match('^(.-) → (.+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if equipType and equipName and pack[equipType] then return pack[equipType]..' → '..equipName end
        local bestType=source:match('^(.-) already best
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if bestType and pack[bestType] then return ltfFormat('%s already best',pack[bestType]) or source end
        local noType=source:match('^No (.-) owned
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if noType and pack[noType] then return ltfFormat('No %s owned',pack[noType]) or source end
        local equipping=source:match('^Equipping (.+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if equipping then return ltfFormat('Equipping %s',equipping) or source end
        local stageOnly=source:match('^Stage_(%d+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if stageOnly and pack.Stage then return pack.Stage..'_'..stageOnly end
        local stageLabel=source:match('^Stage (%d+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if stageLabel and pack.Stage then return pack.Stage..' '..stageLabel end
        local starting=source:match('^Starting Stage_(%d+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if starting then return ltfFormat('Starting Stage_%s',starting) or source end
        local fighting=source:match('^Fighting Stage_(%d+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if fighting then return ltfFormat('Fighting Stage_%s',fighting) or source end
        local collecting=source:match('^Collecting Stage_(%d+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if collecting then return ltfFormat('Collecting Stage_%s',collecting) or source end
        local doneStage,doneOre=source:match('^Completed Stage_(%d+) • ([%d][%d,%.]*) ore
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if doneStage then return ltfFormat('Completed Stage_%s • %s ore',doneStage,doneOre) or source end
        local slowStage=source:match('^Stage_(%d+) too slow; demoted
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if slowStage then return ltfFormat('Stage_%s too slow; demoted',slowStage) or source end
        local startFail=source:match('^Start failed: (.+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if startFail then return ltfFormat('Start failed: %s',self:T(startFail)) or source end
        local collectFail=source:match('^Collect failed: (.+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if collectFail then return ltfFormat('Collect failed: %s',self:T(collectFail)) or source end
        local stoppedReason=source:match('^Stopped: (.+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if stoppedReason then return ltfFormat('Stopped: %s',self:T(stoppedReason)) or source end
        local pausedReason=source:match('^Paused: (.-) • toggle OFF/ON to retry
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if pausedReason then return ltfFormat('Paused: %s • toggle OFF/ON to retry',self:T(pausedReason)) or source end
        local using=source:match('^Using (.+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if using then return ltfFormat('Using %s',using) or source end
        local floorNow,floorMax=source:match('^Floor (%d+)/(%d+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if floorNow then return ltfFormat('Floor %s/%s',floorNow,floorMax) or source end
        local ticketDelta,maxRound=source:match('^Complete • ticket ([%-]?[%d][%d,%.]*) • max ([%d][%d,%.]*)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if ticketDelta then return ltfFormat('Complete • ticket %s • max %s',ticketDelta,maxRound) or source end
        local roundNumber=source:match('^Round (%d+) transition failed
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if roundNumber then return ltfFormat('Round %s transition failed',roundNumber) or source end
        local towerBlock,rewardText=source:match('^(%d+%-%d+) • (.+)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
        if towerBlock and rewardText then
            local parts={}
            for part in (rewardText..' • '):gmatch('(.-) • ') do
                local label,n=part:match('^(.-) x([%d][%d,%.]*)
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
)
                if label and n and pack[label] then parts[#parts+1]=pack[label]..' x'..n else parts[#parts+1]=part end
            end
            return towerBlock..' • '..table.concat(parts,' • ')
        end
        -- END LOOT TO FORGE DYNAMIC LOCALIZATION
        -- BEGIN ANIME DICE DYNAMIC LOCALIZATION
        -- Translate only dictionary-backed Anime Dice status fragments. Unknown names/values stay canonical.
        if source:find(' • ',1,true) then
            local parts={}
            local changed=false
            for part in (source..' • '):gmatch('(.-) • ') do
                local translated=pack[part]
                if not translated then
                    local n,label=part:match('^([%d][%d,%.]*) (.+)$')
                    if n and label and pack[label] then
                        translated=n..' '..pack[label]
                    else
                        local label2,n2=part:match('^(.-) ([%d][%d,%.]*)$')
                        if label2 and n2 and pack[label2] then translated=pack[label2]..' '..n2 end
                    end
                end
                if translated then changed=true;parts[#parts+1]=translated else parts[#parts+1]=part end
            end
            if changed then return table.concat(parts,' • ') end
        end
        local sold=source:match('^Sold (.+)$')
        if sold and pack.Sold then return pack.Sold..' '..sold end
        local floor=source:match('^Floor (%d+)$')
        if floor and pack.Floor then return pack.Floor..' '..floor end
        local number,suffix=source:match('^([%d][%d,%.]*) (.+)$')
        if number and suffix and pack[suffix] then return number..' '..pack[suffix] end
        -- END ANIME DICE DYNAMIC LOCALIZATION
        if source:find(' / ',1,true) then
            local parts={}; for part in (source..' / '):gmatch('(.-) / ') do parts[#parts+1]=pack[part] or part end
            return table.concat(parts,' / ')
        end
        return source
    end
    function self:Refresh()
        for _,binding in pairs(self.Bindings) do binding.Render() end
    end
    function self:Set(selection)
        self.Selection='English'
        for _,name in ipairs(I18N.Options) do if name==selection then self.Selection=name end end
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        -- Explicit user choice; Roblox locale never changes the selected language.
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font,Wrapped=object.TextWrapped,Truncate=object.TextTruncate}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            -- Roblox may defer property events: capture a pending canonical write before refreshing.
            if binding.Last~=nil and object[property]~=binding.Last then binding.Source=object[property] end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
            if property=='Text' then
                local translated=binding.Last~=binding.Source
                object.TextWrapped=translated or binding.Wrapped
                object.TextTruncate=translated and Enum.TextTruncate.None or binding.Truncate
            end
        end
        binding.Change=object:GetPropertyChangedSignal(property):Connect(function()
            if object[property]==binding.Last then return end
            binding.Source=object[property];binding.Render()
        end)
        binding.Destroy=object.Destroying:Connect(function()
            binding.Change:Disconnect();binding.Destroy:Disconnect();self.Bindings[id]=nil
        end)
        binding.Render()
    end
    function self:Destroy()
        self.Destroyed=true
        for _,b in pairs(self.Bindings) do b.Change:Disconnect();b.Destroy:Disconnect() end
        self.Bindings={}
    end
    self:Set(selection)
    return self
end
return I18N
