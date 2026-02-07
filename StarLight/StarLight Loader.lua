local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "StarLight"
Junkie.identifier = "1091"
Junkie.provider = "StarLight"

local function saveKey(key)
    if type(writefile) == "function" then
        pcall(function() writefile("starlight_key.txt", key) end)
    end
end

local function loadKey()
    if type(readfile) == "function" and type(isfile) == "function" then
        local ok, exists = pcall(function() return isfile("starlight_key.txt") end)
        if ok and exists then
            local ok2, content = pcall(function() return readfile("starlight_key.txt") end)
            if ok2 and content and #content > 0 then return content end
        end
    end
    return nil
end

local presetKey = getgenv().SCRIPT_KEY
if type(presetKey) ~= "string" or #presetKey == 0 then
    presetKey = loadKey()
end

if type(presetKey) == "string" and #presetKey > 0 then
    local ok, validation = pcall(function() return Junkie.check_key(presetKey) end)
    if ok and validation and validation.valid then
        getgenv().SCRIPT_KEY = presetKey
        saveKey(presetKey)
        loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/dc15b5edf02bae8de414c6de43570d863cf3cf9b20b621c1d2c40270ed558aa2/download"))()
        return
    end
end

getgenv().SCRIPT_KEY = nil
