local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "StarLight"
Junkie.identifier = "1091"
Junkie.provider = "StarLight"

local presetKey = getgenv().SCRIPT_KEY
local loaded = false

if presetKey and #presetKey > 0 then
    local validation = Junkie.check_key(presetKey)
    if validation.valid then
        getgenv().SCRIPT_KEY = presetKey
        print("Key validated successfully!")
        loaded = true
        loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/dc15b5edf02bae8de414c6de43570d863cf3cf9b20b621c1d2c40270ed558aa2/download"))()
    else
        warn("Preset key invalid: " .. (validation.message or "Unknown error"))
        getgenv().SCRIPT_KEY = nil
    end
end

if not loaded then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/StarMoon-SL/StarLight/refs/heads/main/StarLight/KeySystem.lua"))()
end
