-- Finite contract tests. No HTTP, real filesystem, or Roblox side effects.
local function copy(v)
    if type(v)~='table' then return v end
    local o={}; for k,x in pairs(v) do o[k]=copy(x) end; return o
end
math.clamp=function(v,lo,hi) assert(lo<=hi,'invalid clamp range'); return math.max(lo,math.min(hi,v)) end
Enum=setmetatable({Font={SourceSans='SourceSans',Gotham='Gotham',GothamMedium='GothamMedium',GothamBold='GothamBold'}},{__index=function(t,k)
    local values=setmetatable({},{__index=function(a,b) rawset(a,b,k..'.'..b);return rawget(a,b) end});rawset(t,k,values);return values
end})
Color3={fromRGB=function(r,g,b) return {R=r/255,G=g/255,B=b/255} end,new=function(r,g,b)return{R=r,G=g,B=b}end}
Vector2={new=function(x,y) return {X=x,Y=y} end}
UDim={new=function(s,o)return{Scale=s or 0,Offset=o or 0}end}
UDim2={new=function(xs,xo,ys,yo)return{X=UDim.new(xs,xo),Y=UDim.new(ys,yo)}end}
UDim2.fromScale=function(x,y)return UDim2.new(x,0,y,0)end
UDim2.fromOffset=function(x,y)return UDim2.new(0,x,0,y)end
Rect={new=function(...)return {...}end}; TweenInfo={new=function(...)return {...}end}
local delayed,deferred={},{}
task={delay=function(_,f)delayed[#delayed+1]=f end,defer=function(f)deferred[#deferred+1]=f end,spawn=function(f)f()end}
local function flushDeferred()
    local current=deferred;deferred={};for _,f in ipairs(current)do f()end
end
local activeConnections=0
local function signal()
    local s={Slots={}}
    function s:Connect(f)
        local c={Connected=true,Kind='RBXScriptConnection',Callback=f};activeConnections=activeConnections+1
        function c:Disconnect() if self.Connected then self.Connected=false;activeConnections=activeConnections-1 end end
        self.Slots[#self.Slots+1]=c;return c
    end
    function s:Fire(...)
        local slots={};for i,c in ipairs(self.Slots)do slots[i]=c end
        for _,c in ipairs(slots)do if c.Connected then c.Callback(...) end end
    end
    return s
end
local focus=nil
local methods={}
local signals={Destroying=true,Activated=true,InputBegan=true,InputChanged=true,InputEnded=true,FocusLost=true,MouseEnter=true,MouseLeave=true}
local viewport=Vector2.new(1280,720)
local mt={}
local function parentSize(o) return o.Props.Parent and o.Props.Parent.AbsoluteSize or Vector2.new(1280,720) end
function mt.__index(o,k)
    if methods[k] then return methods[k] end
    if signals[k] then if not o.Events[k]then o.Events[k]=signal()end;return o.Events[k]end
    if k=='AbsoluteSize' then
        if o.ClassName=='ScreenGui' or o.ClassName=='PlayerGui' then return viewport end
        local p=parentSize(o);local s=o.Props.Size or UDim2.new();return Vector2.new(p.X*s.X.Scale+s.X.Offset,p.Y*s.Y.Scale+s.Y.Offset)
    end
    if k=='AbsolutePosition' then
        if not o.Props.Parent then return Vector2.new(0,0)end
        local p=o.Props.Parent.AbsolutePosition;local z=parentSize(o);local s=o.Props.Position or UDim2.new();local a=o.Props.AnchorPoint or Vector2.new(0,0)
        return Vector2.new(p.X+z.X*s.X.Scale+s.X.Offset-o.AbsoluteSize.X*a.X,p.Y+z.Y*s.Y.Scale+s.Y.Offset-o.AbsoluteSize.Y*a.Y)
    end
    if k=='AbsoluteContentSize' then
        if o.Props.TestContentSize then return o.Props.TestContentSize end
        local h=0
        if o.Parent then for _,child in ipairs(o.Parent.Children)do if child~=o and child.Props.Size and child.Visible~=false then h=h+child.AbsoluteSize.Y end end end
        return Vector2.new(0,h)
    end
    return o.Props[k]
end
function mt.__newindex(o,k,v)
    if k=='Parent' then
        if o.Props.Parent then for i,c in ipairs(o.Props.Parent.Children)do if c==o then table.remove(o.Props.Parent.Children,i);break end end end
        if v then v.Children[#v.Children+1]=o end
    end
    local old=o.Props[k];o.Props[k]=v
    if old~=v and o.Events['Changed:'..k] then o.Events['Changed:'..k]:Fire() end
end
function methods:GetPropertyChangedSignal(k)
    local name='Changed:'..k;if not self.Events[name]then self.Events[name]=signal()end;return self.Events[name]
end
function methods:Destroy()
    if self.Props.Destroyed then return end;self.Props.Destroyed=true;self.Destroying:Fire()
    local children={};for i,c in ipairs(self.Children)do children[i]=c end
    for _,c in ipairs(children)do c:Destroy()end
    for _,s in pairs(self.Events)do for _,c in ipairs(s.Slots)do c:Disconnect()end end
    self.Parent=nil
end
function methods:IsDescendantOf(target)local p=self.Parent;while p do if p==target then return true end;p=p.Parent end;return false end
function methods:CaptureFocus()focus=self end
function methods:ReleaseFocus()focus=nil;self.FocusLost:Fire()end
function methods:GetChildren()return self.Children end
function methods:IsA(kind)return kind==self.ClassName end
Instance={new=function(kind)return setmetatable({ClassName=kind,Kind='Instance',Props={BackgroundTransparency=0,CanvasPosition=Vector2.new(0,0),Visible=true},Children={},Events={}},mt)end}
typeof=function(v)return type(v)=='table' and v.Kind or type(v)end
local pg=Instance.new('PlayerGui')
local input={InputChanged=signal(),InputEnded=signal(),InputBegan=signal(),GetFocusedTextBox=function()return focus end,IsKeyDown=function()return false end}
local keyboardSignals={}
function input:GetPropertyChangedSignal(name)
    keyboardSignals[name]=keyboardSignals[name] or signal();return keyboardSignals[name]
end
local files,json,seq={}, {},0
readfile=function(p)return files[p]end;writefile=function(p,v)assert(p=='SerenityHub/ui-phonk-language-preview-v1.json','production config write');files[p]=v end
isfile=function(p)return files[p]~=nil end;makefolder=function(p)assert(p=='SerenityConcept02' or p=='SerenityHub')end
local holdTweens=false
local pendingTweens={}
local loc=Instance.new('LocalizationService');loc.RobloxLocaleId='es-es'
local services={LocalizationService=loc,
    UserInputService=input,
    Players={LocalPlayer={Name='Tester',DisplayName='Tester',UserId=123,WaitForChild=function()return pg end},GetUserThumbnailAsync=function()return '' end},
    MarketplaceService={GetProductInfo=function()return{Name='Mock Game'}end},
    HttpService={JSONEncode=function(_,v)seq=seq+1;local k=tostring(seq);json[k]=copy(v);return k end,JSONDecode=function(_,v)return copy(json[v])end},
    TweenService={Create=function(_,obj,_,props)local t={Completed=signal()};function t:Play() for k,v in pairs(props)do obj[k]=v end;if holdTweens then pendingTweens[#pendingTweens+1]=self else self.Completed:Fire(Enum.PlaybackState.Completed) end end;function t:Cancel()self.Completed:Fire(Enum.PlaybackState.Cancelled)end;return t end},
}
game={GameId=42,PlaceId=123,GetService=function(_,k)return assert(services[k],k)end,HttpGet=function()error('Unexpected network call')end}
getgenv=function()return _G end
local production={Destroy=function()error('Production destroyed')end};_G.__SERENITY_RUNTIME_V3=production

local manifest=dofile('preview/phonk-language/phonk-language-manifest.lua')
local function start() local lib=dofile('preview/phonk-language/phonk-language-ui.lua');local app=lib.Build(manifest);flushDeferred();return app end
local productionPhonk={Destroy=function()error('Live Phonk destroyed')end}
_G.__SERENITY_PHONK_EVOLUTION_V3=productionPhonk
local app=start()
local function texts(object,out)
    out=out or {};if object.Text then out[object.Text]=true end
    for _,child in ipairs(object:GetChildren())do texts(child,out)end
    return out
end
assert(texts(app.Screen)['Settings'],'fresh preview must default to English even with Spanish Roblox locale')
local language=assert(app.Controls['Settings.Appearance.Language'])
local accent=app.Controls['Settings.Appearance.Accent'];accent:Set('Cyan')
local count=activeConnections
for _,name in ipairs({'English','Filipino','Bahasa Indonesia','Tiếng Việt','ไทย','Español','Português (Brasil)','Français','Deutsch','Русский','English'})do
    language:Set(name);assert(accent:Get()=='Cyan','option value translated');assert(language:Get()==name)
end
assert(texts(app.Screen)['Settings'],'English restoration failed')
language:Set('Deutsch');assert(texts(app.Screen)['Einstellungen'])
app:SelectPage('Automation');assert(texts(app.Screen)['Automatisierung'],'dynamic page title failed')
app.Feedback.Draft.Text='Settings is my original report';app.Feedback.Submit();assert(app.Feedback.Draft.Text=='Settings is my original report')
language:Set('Français');assert(app.Feedback.Draft.Text=='Settings is my original report','report rewritten')
assert(app.Config:Save(),'save failed')
local nextApp=start();assert(app.Runtime.Destroyed,'preview runtime leaked');app=nextApp
assert(app.Controls['Settings.Appearance.Language']:Get()=='Français','language did not persist')
assert(texts(app.Screen)['Paramètres'])
app.Controls['Settings.Appearance.Language']:Set('Automatic (Roblox)');assert(texts(app.Screen)['Settings'],'old automatic choice must become English')
loc.RobloxLocaleId='fil-ph';assert(texts(app.Screen)['Settings'],'Roblox locale must not change English')
app.Controls['Settings.Appearance.Language']:Set('Deutsch');loc.RobloxLocaleId='es-es';assert(texts(app.Screen)['Einstellungen'],'manual language overwritten')
-- Reproduce Roblox deferred property events: selection summary must survive Refresh.
local originalNewIndex=mt.__newindex
mt.__newindex=function(o,k,v)
 if k=='Text' and o.Events['Changed:Text'] then
   local old=o.Props[k];o.Props[k]=v
   if old~=v then task.defer(function() if not o.Destroyed then o.Events['Changed:Text']:Fire() end end) end
 else originalNewIndex(o,k,v) end
end
local language=app.Controls['Settings.Appearance.Language']
for _,name in ipairs({'Filipino','Español','English','Deutsch','Filipino'})do
 language:Set(name)
 assert(texts(language.Frame)[name],'selection field is stale: '..name)
 flushDeferred();assert(texts(language.Frame)[name],'deferred event reverted selected language')
end
assert(texts(app.Toast)['Napalitan ang wika: Filipino'],'confirmation must name Filipino')
mt.__newindex=originalNewIndex
local farm=app.Controls['Automation.Farm.AutoClick'];assert(farm.Frame.Size.Y.Offset==44,'desktop rows no longer original compact height')
local baseline=activeConnections
for i=1,10 do app:Search();flushDeferred();app.Popup:Close(true)end
assert(activeConnections==baseline,'search leaked connections')
for _,size in ipairs({{390,844},{844,390},{1280,720}})do viewport=Vector2.new(size[1],size[2]);app:Fit();assert(app.LayoutWidth>0);end
app:Destroy();assert(_G.__SERENITY_PHONK_EVOLUTION_V3==productionPhonk)
assert(activeConnections==0,'connections remain after destroy: '..activeConnections)
print('PASS: full mocked Phonk UI, ten languages, English default, deferred selection display, switching, unchanged values/drafts, persistence, fallback, popup cleanup, viewport sizing, live runtime isolation.')
