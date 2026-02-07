local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "StarLight"
Junkie.identifier = "1091"
Junkie.provider = "StarLight"

local maxAttempts = 5
local attempts = 0
local validated = false
local userKey = getgenv().SCRIPT_KEY

if userKey and #userKey > 0 then
    local validation = Junkie.check_key(userKey)
    if validation.valid then
        validated = true
        print("Key validated successfully!")
    else
        local errorMsg = validation.message or "Unknown error"
        warn("[ERROR] Preset key invalid: " .. errorMsg)
        getgenv().SCRIPT_KEY = nil
        userKey = nil
    end
end

while not validated and attempts < maxAttempts do
    local link = Junkie.get_key_link()
    if link then
        if setclipboard then
            setclipboard(link)
        end
    else
        warn("Please wait 5 minutes")
    end

    print("\nEnter your key:")
    userKey = getUserInput()

    if userKey and #userKey > 0 then
        attempts = attempts + 1

        local validation = Junkie.check_key(userKey)
        if validation.valid then
            validated = true
            getgenv().SCRIPT_KEY = userKey
            print("\nKey validated successfully!")
            break
        else
            local errorMsg = validation.message or "Unknown error"
            warn("[ERROR] " .. errorMsg)

            if errorMsg == "KEY_EXPIRED" then
                print("[INFO] Key expired - get a new one")
            elseif errorMsg == "HWID_BANNED" then
                game.Players.LocalPlayer:Kick("Hardware banned")
                return
            elseif errorMsg == "SERVICE_MISMATCH" then
                print("[INFO] Key is for a different service")
            elseif errorMsg == "HWID_MISMATCH" then
                print("[INFO] HWID limit reached")
            end
        end
    else
        warn("Error: No key entered")
    end

    if attempts >= maxAttempts then
        warn("Error: Too many failed attempts!")
        return
    end

    task.wait(1)
end

if not validated then
    warn("Error: Validation failed")
    return
end

loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/dc15b5edf02bae8de414c6de43570d863cf3cf9b20b621c1d2c40270ed558aa2/download"))()
