-- SERENITY HUB // V13 DESKTOP TRANSPORT
local BASE = "https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/dist/ui/v13-desktop/"
local names = {
    "head-01.txt",
    "head-02.txt",
    "head-03.txt",
    "part-02.txt",
    "part-03.txt",
    "part-04.txt",
    "part-05.txt",
    "part-06.txt",
    "part-07.txt",
    "part-08.txt",
    "part-09.txt",
}
local parts = {}

for i, path in ipairs(names) do
    local ok, src = pcall(function()
        return game:HttpGet(BASE .. path)
    end)

    if not ok or type(src) ~= "string" or src == "" then
        error("[SERENITY HUB] Failed to load V13 desktop part: " .. path, 0)
    end

    parts[i] = src
end

local source = table.concat(parts)
local fn, err = loadstring(source, "@Serenity/V13/Desktop")

if not fn then
    error("[SERENITY HUB] Failed to compile V13 desktop renderer: " .. tostring(err), 0)
end

return fn()
