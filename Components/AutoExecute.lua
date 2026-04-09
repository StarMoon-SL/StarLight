return [[
    local DataManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/AbysallHubNew/refs/heads/main/Components/DataManager.lua"))()
    if DataManager:GetData("AutoExecute") == "true" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/AbysallHubNew/refs/heads/main/Loader.lua"))()
        DataManager:SaveData("AutoExecute", "false")
    end
]]
