local I18N={}
I18N.Options={'Automatic (Roblox)','English','Filipino','Bahasa Indonesia','Tiếng Việt','ไทย','Español','Português (Brasil)','Français','Deutsch','Русский'}
local codes={'auto','en','fil','id','vi','th','es','pt','fr','de','ru'}
local supported={en=true,fil=true,id=true,vi=true,th=true,es=true,pt=true,fr=true,de=true,ru=true}
local aliases={tl='fil',['in']='id'}
function I18N.Resolve(locale)
    local code=tostring(locale or ''):lower():gsub('_','-'):match('^([a-z]+)')
    code=aliases[code] or code
    return supported[code] and code or 'en'
end
function I18N.Code(selection)
    for i,name in ipairs(I18N.Options) do if name==selection then return codes[i] end end
    return 'auto'
end
function I18N.new(selection,detected)
    local self={Bindings={},Selection=selection,Detected=detected,Destroyed=false}
    function self:Language()
        local chosen=I18N.Code(self.Selection)
        return chosen=='auto' and I18N.Resolve(self.Detected) or chosen
    end
    function self:T(source)
        if type(source)~='string' or source=='' then return source end
        local pack=I18N.Packs[self:Language()] or {}
        if pack[source] then return pack[source] end
        -- Translate only known UI patterns; never edit a user's text or arbitrary values.
        local time=source:match('^Session · (%d+:%d%d:%d%d)$')
        if time then return (pack.Session or 'Session')..' · '..time end
        local count=source:match('^(%d+ / 1800) characters$')
        if count then return count..' '..(pack.characters or 'characters') end
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
        self.Selection=I18N.Code(selection)=='auto' and I18N.Options[1] or selection
        self:Refresh()
    end
    function self:Detect(locale)
        self.Detected=locale
        if I18N.Code(self.Selection)=='auto' then self:Refresh() end
    end
    function self:Bind(object,property)
        local binding={Source=object[property],Last=nil,Font=object.Font}
        local id={};self.Bindings[id]=binding
        function binding.Render()
            if self.Destroyed then return end
            binding.Last=self:T(binding.Source)
            if object[property]~=binding.Last then object[property]=binding.Last end
            -- SourceSans provides Roblox's fallback glyph handling, including Thai.
            object.Font=self:Language()=='th' and Enum.Font.SourceSans or binding.Font
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
