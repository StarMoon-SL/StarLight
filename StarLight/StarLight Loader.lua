local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "StarLight"
Junkie.identifier = "1091"
Junkie.provider = "StarLight"

local function hasFileSystem()
    return pcall(function() return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function" end)
end

local function saveKey(key)
    if not hasFileSystem() then return end
    pcall(function() writefile("starlight_key.txt", key) end)
end

local function loadKey()
    if not hasFileSystem() then return nil end
    local ok, content = pcall(function() return readfile("starlight_key.txt") end)
    if ok and content and #content > 0 then return content end
    return nil
end

local presetKey = getgenv().SCRIPT_KEY
if not presetKey or #presetKey == 0 then
    presetKey = loadKey()
end

if presetKey and #presetKey > 0 then
    local validation = Junkie.check_key(presetKey)
    if validation.valid then
        getgenv().SCRIPT_KEY = presetKey
        saveKey(presetKey)
        loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/dc15b5edf02bae8de414c6de43570d863cf3cf9b20b621c1d2c40270ed558aa2/download"))()
        return
    end
end

getgenv().SCRIPT_KEY = nil
