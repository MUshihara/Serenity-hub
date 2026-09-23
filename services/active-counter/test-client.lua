local env,queue,waits,bodies={}, {},{},{}
getgenv=function()return env end
local response={interval=120,executionRecorded=true},requests
requests=0
local fail=false
request=function(r)assert(r.Headers['X-Serenity-Game']==tostring(game.GameId));assert(r.Headers['X-Serenity-Account']=='12345');assert(r.Method=='POST' and r.Url:find('/heartbeat$'));assert(r.Headers['X-Serenity-Game-Name']);requests=requests+1;bodies[#bodies+1]=r.Body;if fail then error('offline')end;return {StatusCode=200,Body='response'}end
local seq=0
local http={UrlEncode=function(_,s)return s:gsub(' ', '%%20')end,GenerateGUID=function()seq=seq+1;return string.format('%08d-1111-4111-8111-111111111111',seq)end,JSONEncode=function(_,b)return b.session..(b.execution and ':'..b.execution or '')end,JSONDecode=function()return response end}
task={defer=function(fn)local co=coroutine.create(fn);queue[#queue+1]=co;return co end,wait=function(n)waits[#waits+1]=n;coroutine.yield()end,cancel=function(co)coroutine.close(co)end}
local route
loadstring=function(path)return function()return {Build=function()
 route=path
 local runtime={Destroyed=false,cleanups={}}
 local function track(self,fn)self.cleanups[#self.cleanups+1]=fn end
 if path:find('phonk') then runtime.OnDestroy=track else runtime.TrackCleanup=track end
 function runtime:Destroy()self.Destroyed=true;for _,fn in ipairs(self.cleanups)do fn()end end
 return {Runtime=runtime,Window={Visible=false,Current='Automation',SetActiveCount=function(self,n)self.count=n end,Notify=function()end}}
end}end end
game={PlaceId=1,GameId=1,GetService=function(_,name)if name=='Players' then return {LocalPlayer={UserId=12345}} end;return http end,HttpGet=function(_,p)return p end}
local ui=dofile('game-ranking/dist/ui/serenity-v3.lua')
local function tick(co)assert(coroutine.resume(co))end
local a=ui.Build({SerenityAPIVersion=3,GameName='Ride A Pet'});assert(route:find('universal'));tick(queue[1]);assert(waits[1]==120 and requests==1 and a.Window.count==nil)
response={interval=300,ttl=600,active=52,executionRecorded=true};tick(queue[1]);assert(waits[2]==300 and a.Window.count==52 and requests==2)
assert(not bodies[2]:find(':')) -- execution acknowledged once
fail=true;tick(queue[1]);assert(waits[3]==300 and a.Window.count==nil);fail=false
response={interval=300,ttl=300,active=-1};tick(queue[1]);assert(waits[4]==120 and a.Window.count==nil)
response={interval=300,ttl=600,active=0};tick(queue[1]);assert(waits[5]==300 and a.Window.count==0)
local session=env.__SERENITY_PRESENCE_ID;game.PlaceId=104809044319701
local b=ui.Build({GameName='+1 Phonk Evolution'});assert(route:find('phonk'));assert(coroutine.status(queue[1])=='dead' and env.__SERENITY_PRESENCE_ID==session)
a.Runtime:Destroy();response={interval=300,ttl=600,active=1};tick(queue[2]);assert(b.Window.count==1)
local first=bodies[#bodies];tick(queue[2]);assert(bodies[#bodies]==first) -- missing acknowledgment retries identical event
b.Runtime:Destroy();assert(coroutine.status(queue[2])=='dead')
env.SerenityPresenceEnabled=false;ui.Build({SerenityAPIVersion=3});assert(#queue==2)
env.SerenityPresenceEnabled=true;request=nil;ui.Build({SerenityAPIVersion=3});assert(#queue==2)
print('PASS: no count GET, interval negotiation/rollback, hidden UI cache, failure clearing, analytics retries, rerun deduplication and both cleanup adapters.')
