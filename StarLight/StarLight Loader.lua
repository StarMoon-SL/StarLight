local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "StarLight"
Junkie.identifier = "1091"
Junkie.provider = "StarLight"

local presetKey = getgenv().SCRIPT_KEY

if presetKey and #presetKey > 0 then
    local validation = Junkie.check_key(presetKey)
    if validation.valid then
        print("Key validated successfully!")
        getgenv().SCRIPT_KEY = presetKey
        task.wait(0.1)
        local scriptUrl = "https://api.jnkie.com/api/v1/luascripts/public/dc15b5edf02bae8de414c6de43570d863cf3cf9b20b621c1d2c40270ed558aa2/download"
        print("Loading main script...")
        local scriptContent = game:HttpGet(scriptUrl)
        if scriptContent and #scriptContent > 0 then
            print("Main script downloaded, executing...")
            loadstring(scriptContent)()
            print("Main script executed!")
        else
            warn("Main script is empty or failed to download")
        end
        return
    else
        warn("Preset key invalid: " .. (validation.message or "Unknown error"))
        getgenv().SCRIPT_KEY = nil
    end
end

print("No valid preset key, loading official key system...")
loadstring(game:HttpGet("https://raw.githubusercontent.com/StarMoon-SL/StarLight/refs/heads/main/StarLight/StarLight%20Loader.lua"))()
