local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "StarLight"
Junkie.identifier = "1091"
Junkie.provider = "StarLight"

local presetKey = getgenv().SCRIPT_KEY

if presetKey and #presetKey > 0 then
    local validation = Junkie.check_key(presetKey)
    if validation.valid then
        loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/dc15b5edf02bae8de414c6de43570d863cf3cf9b20b621c1d2c40270ed558aa2/download"))()
        return
    end
end

loadstring(game:HttpGet("https://your-keysystem-url/KeySystem.lua"))()
