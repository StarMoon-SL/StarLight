local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "StarLight"
Junkie.identifier = "1091"
Junkie.provider = "StarLight"

if _G.StarLight_LoaderExecuted then return end
_G.StarLight_LoaderExecuted = true

local function validateKey(key)
    if not key or type(key) ~= "string" or #key == 0 then
        return false, "Empty key"
    end
    
    local success, result = pcall(function()
        return Junkie.check_key(key)
    end)
    
    if not success then
        return false, "Validation failed"
    end
    
    return result.valid, result.message
end

local presetKey = getgenv().SCRIPT_KEY
if presetKey then
    local isValid, message = validateKey(presetKey)
    if isValid then
        return loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/dc15b5edf02bae8de414c6de43570d863cf3cf9b20b621c1d2c40270ed558aa2/download"))()
    else
        getgenv().SCRIPT_KEY = nil
    end
end

loadstring(game:HttpGet("https://your-keysystem-url/KeySystem.lua"))()
