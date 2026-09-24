local DIR=debug.getinfo(1,"S").source:gsub("^@", ""):match("^(.*[/])") or "./"
local Core=dofile(DIR..'core.lua')
local function target(a) return Core.Target(a,104809044319701,10544327471,'+1 Phonk Evolution') end
assert(target({active=true,target='all'}))
assert(not target({active=true}))
assert(not target({active=true,target='everyone',targetPlaceId='123',targetModule=''}))
assert(target({active=true,target='game',targetPlaceId='104809044319701'}))
assert(target({active=true,targetModule='phonkevolution'}))
assert(not target({active=true,targetModule='evolution'}))
assert(not target({active=false,target='all'}))
assert(target({active=true,targetUniverseId=10544327471}))
assert(not target({active=true,targetUniverseId=5}))
local seen={}
local key=Core.WarningKey({id=1,message='Be respectful'})
assert(Core.Remember(seen,key,1));assert(not Core.Remember(seen,key,2))
assert(Core.Remember(seen,Core.WarningKey({id=2,message='Be respectful'}),3))
for i=1,300 do Core.Remember(seen,'a'..i,i) end
local n=0;for _ in pairs(seen) do n=n+1 end;assert(n<=256)
assert(Core.Duration(0)==4 and Core.Duration(500)==12)
assert(Core.Status(200) and not Core.Status(500) and not Core.Status(nil))
-- Both downloadable entrypoints refuse other games before networking or UI creation.
game={PlaceId=1,GameId=2,HttpGet=function()error('Unexpected network')end}
warn=function()end
assert(dofile(DIR..'loader.lua')==nil)
assert(dofile(DIR..'client.lua')(Core)==nil)
print('PASS: Phonk-only guards, strict announcement targeting, warning deduplication, bounded cache, duration, HTTP status handling.')
