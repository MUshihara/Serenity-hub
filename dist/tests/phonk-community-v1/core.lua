local Core={}
local function norm(v) return tostring(v or ""):lower():gsub("^%s+",""):gsub("%s+$","") end
local function all(v) return v=="all" or v=="everyone" end
function Core.Target(a,place,universe,name)
    if type(a)~="table" or a.active~=true then return false end
    local p,u,m,t=norm(a.targetPlaceId),norm(a.targetUniverseId),norm(a.targetModule),norm(a.target)
    -- Specific identifiers always constrain broader/default target fields.
    if p~="" and not all(p) then return p==tostring(place) end
    if u~="" and not all(u) then return u==tostring(universe) end
    if m~="" and not all(m) then
        return m==tostring(place) or m==tostring(universe) or m==norm(name) or m=="phonkevolution"
    end
    return all(t) or all(m) or all(p) or all(u)
end
function Core.Status(code) return type(code)=="number" and code>=200 and code<300 end
function Core.WarningKey(w)
    if type(w)~="table" or type(w.message)~="string" or w.message=="" then return nil end
    return "warning:"..tostring(w.id or w.createdAt or w.message)
end
function Core.Duration(value) return math.max(4,math.min(12,tonumber(value) or 8)) end
function Core.Escape(v)
    return tostring(v or ""):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"):gsub('"',"&quot;")
end
function Core.Remember(cache,key,now,limit)
    if cache[key] then return false end
    cache[key]=now
    local count,oldest,at=0,nil,math.huge
    for k,v in pairs(cache) do count=count+1;if v<at then oldest,at=k,v end end
    if count>(limit or 256) and oldest then cache[oldest]=nil end
    return true
end
return Core
