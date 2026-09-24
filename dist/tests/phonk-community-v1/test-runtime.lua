local DIR=debug.getinfo(1,"S").source:gsub("^@", ""):match("^(.*[/])") or "./"
local Core=dofile(DIR..'core.lua')
local env={};getgenv=function()return env end
local signals={}
local function signal()
 local s={listeners={}}
 function s:Connect(fn)local c={Connected=true,fn=fn};function c:Disconnect()self.Connected=false end;self.listeners[#self.listeners+1]=c;signals[#signals+1]=c;return c end
 function s:Fire(...)for _,c in ipairs(self.listeners)do if c.Connected then c.fn(...)end end end
 return s
end
local nodes={}
local methods={}
function methods:GetChildren()local a={};for _,n in ipairs(nodes)do if n.Parent==self then a[#a+1]=n end end;return a end
function methods:IsA(c)return self.ClassName==c end
function methods:Destroy()for _,c in ipairs(self:GetChildren())do c:Destroy()end;self.Parent=nil end
function methods:GetPropertyChangedSignal(k)self.signals=self.signals or {};self.signals[k]=self.signals[k] or signal();return self.signals[k] end
Instance={new=function(class)local o={ClassName=class};setmetatable(o,{__index=function(t,k)if methods[k]then return methods[k]end;if k=='Activated' or k=='FocusLost' then local s=signal();rawset(t,k,s);return s end end});nodes[#nodes+1]=o;return o end}
local function vec(...)return {...}end
UDim={new=vec};UDim2={new=vec,fromOffset=vec};Vector2={new=vec};Color3={fromRGB=vec}
Enum=setmetatable({},{__index=function(t,k)local v=setmetatable({},{__index=function(_,x)return x end});rawset(t,k,v);return v end})
local camera=Instance.new('Camera');camera.ViewportSize={X=360,Y=740}
workspace=Instance.new('Workspace');workspace.CurrentCamera=camera
local root=Instance.new('CoreGui')
local player={UserId=123,Name='Tester',DisplayName='Tester'}
local responseMap={};local index=0
local Http={JSONDecode=function(_,key)return responseMap[key]end,JSONEncode=function(_,body)return body end}
game={PlaceId=104809044319701,GameId=10544327471,GetService=function(_,name)if name=='HttpService'then return Http elseif name=='Players'then return {LocalPlayer=player}else return root end end}
local requests={};local warning={id='one',message='Be respectful'}
request=function(r)
 requests[#requests+1]=r
 local data
 if r.Url:find('/moderation/')then data={success=true,warning=warning}
 elseif r.Url:find('/chat/messages')then data={success=true,messages={}}
 else data={id='unrelated',active=true,target='everyone',targetPlaceId='999',message='Wrong game'}end
 index=index+1;responseMap[tostring(index)]=data;return {StatusCode=200,Body=tostring(index)}
end
local threads={}
task={defer=function(fn)local t=coroutine.create(fn);threads[#threads+1]=t;return t end,wait=function()coroutine.yield()end,cancel=function(t)coroutine.close(t)end}
warn=print
local function tick()local snapshot={table.unpack(threads)};for _,t in ipairs(snapshot)do if coroutine.status(t)=='suspended'then local ok,e=coroutine.resume(t);assert(ok,e)end end end
local start=dofile(DIR..'client.lua')
local a=start(Core);tick()
assert(#requests==1 and requests[1].Url:find('/announcements/')) -- closed chat does not poll
local function find(text)for i=#nodes,1,-1 do local n=nodes[i];if n.Parent and n.Text==text then return n end end end
find('Community · Test').Activated:Fire();tick();tick()
assert(#requests>=3)
assert(env.__SERENITY_COMMUNITY_SEEN['warning:one'])
for _,n in ipairs(nodes)do assert(n.ClassName~='BlurEffect')end
find('Test warning').Activated:Fire();tick()
assert(find('Community warning · Preview'))
local b=start(Core);assert(a.Stopped);tick()
local count=#requests;b:Stop();tick();assert(#requests==count)
for _,c in ipairs(signals)do assert(not c.Connected)end
print('PASS: closed-chat request suppression, moderation banner, no blur, rerun cancellation, stop cleanup, mobile viewport construction.')
