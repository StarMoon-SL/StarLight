local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "StarLight"
Junkie.identifier = "1091"
Junkie.provider = "StarLight"

if getgenv().SCRIPT_KEY then
    local validation = Junkie.check_key(getgenv().SCRIPT_KEY)
    if validation and validation.valid then
        loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/dc15b5edf02bae8de414c6de43570d863cf3cf9b20b621c1d2c40270ed558aa2/download"))()
        return
    end
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Colors = {
    background = Color3.fromRGB(13, 17, 23),
    surface = Color3.fromRGB(22, 27, 34),
    surfaceLight = Color3.fromRGB(30, 36, 44),
    primary = Color3.fromRGB(88, 166, 255),
    primaryDark = Color3.fromRGB(58, 136, 225),
    primaryGlow = Color3.fromRGB(120, 180, 255),
    accent = Color3.fromRGB(136, 87, 224),
    success = Color3.fromRGB(47, 183, 117),
    error = Color3.fromRGB(248, 81, 73),
    textPrimary = Color3.fromRGB(230, 237, 243),
    textSecondary = Color3.fromRGB(139, 148, 158),
    textMuted = Color3.fromRGB(110, 118, 129),
    border = Color3.fromRGB(48, 54, 61),
    glass = Color3.fromRGB(255, 255, 255)
}

local function createIcon(name, size, color)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0, size or 18, 0, size or 18)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    local icons = {shield = "🛡️", key = "🔑", link = "🔗", x = "✕", check = "✓"}
    lbl.Text = icons[name] or "●"
    return lbl
end

local gui = Instance.new("ScreenGui")
gui.Name = "StarLightKeySystem"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

local backdrop = Instance.new("Frame")
backdrop.Name = "Backdrop"
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 0.6
backdrop.BorderSizePixel = 0
backdrop.Parent = gui

local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0, 400, 0, 280)
container.Position = UDim2.new(0.5, 0, 0.5, 0)
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.BackgroundColor3 = Colors.surface
container.BackgroundTransparency = 0.3
container.BorderSizePixel = 0
container.Parent = backdrop

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 16)
containerCorner.Parent = container

local containerStroke = Instance.new("UIStroke")
containerStroke.Color = Colors.primary
containerStroke.Thickness = 1
containerStroke.Transparency = 0.5
containerStroke.Parent = container

local glass = Instance.new("Frame")
glass.Name = "Glass"
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Colors.glass
glass.BackgroundTransparency = 0.95
glass.BorderSizePixel = 0
glass.Parent = container

local glassCorner = Instance.new("UICorner")
glassCorner.CornerRadius = UDim.new(0, 16)
glassCorner.Parent = glass

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 166, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(136, 87, 224))
})
gradient.Rotation = 45
gradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.9),
    NumberSequenceKeypoint.new(1, 1)
})
gradient.Parent = glass

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = Colors.background
topBar.BackgroundTransparency = 0.5
topBar.BorderSizePixel = 0
topBar.Parent = container

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 16)
topBarCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "StarLight Key System"
title.TextColor3 = Colors.textPrimary
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0.5, 0)
closeBtn.AnchorPoint = Vector2.new(0, 0.5)
closeBtn.BackgroundColor3 = Colors.error
closeBtn.BackgroundTransparency = 0.8
closeBtn.Text = ""
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

local closeIcon = createIcon("x", 14, Colors.textPrimary)
closeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
closeIcon.Parent = closeBtn

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -40, 1, -70)
content.Position = UDim2.new(0, 20, 0, 60)
content.BackgroundTransparency = 1
content.Parent = container

local iconFrame = Instance.new("Frame")
iconFrame.Name = "IconFrame"
iconFrame.Size = UDim2.new(0, 60, 0, 60)
iconFrame.Position = UDim2.new(0.5, 0, 0, 10)
iconFrame.AnchorPoint = Vector2.new(0.5, 0)
iconFrame.BackgroundColor3 = Colors.primary
iconFrame.BackgroundTransparency = 0.8
iconFrame.Parent = content

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 12)
iconCorner.Parent = iconFrame

local mainIcon = createIcon("shield", 28, Color3.fromRGB(255, 255, 255))
mainIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
mainIcon.AnchorPoint = Vector2.new(0.5, 0.5)
mainIcon.Parent = iconFrame

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 80)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Enter your key to continue"
subtitle.TextColor3 = Colors.textSecondary
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = content

local inputFrame = Instance.new("Frame")
inputFrame.Name = "InputFrame"
inputFrame.Size = UDim2.new(1, 0, 0, 44)
inputFrame.Position = UDim2.new(0, 0, 0, 110)
inputFrame.BackgroundColor3 = Colors.surfaceLight
inputFrame.BackgroundTransparency = 0.5
inputFrame.BorderSizePixel = 0
inputFrame.Parent = content

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = inputFrame

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Colors.border
inputStroke.Thickness = 1
inputStroke.Parent = inputFrame

local keyIcon = createIcon("key", 16, Colors.primary)
keyIcon.Position = UDim2.new(0, 12, 0.5, 0)
keyIcon.AnchorPoint = Vector2.new(0, 0.5)
keyIcon.Parent = inputFrame

local keyInput = Instance.new("TextBox")
keyInput.Name = "KeyInput"
keyInput.Size = UDim2.new(1, -50, 1, 0)
keyInput.Position = UDim2.new(0, 40, 0, 0)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "Enter your verification key"
keyInput.PlaceholderColor3 = Colors.textMuted
keyInput.Text = ""
keyInput.TextColor3 = Colors.textPrimary
keyInput.TextSize = 14
keyInput.Font = Enum.Font.Gotham
keyInput.ClearTextOnFocus = false
keyInput.Parent = inputFrame

local buttonFrame = Instance.new("Frame")
buttonFrame.Name = "ButtonFrame"
buttonFrame.Size = UDim2.new(1, 0, 0, 40)
buttonFrame.Position = UDim2.new(0, 0, 0, 170)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = content

local getLinkBtn = Instance.new("TextButton")
getLinkBtn.Name = "GetLink"
getLinkBtn.Size = UDim2.new(0.48, 0, 1, 0)
getLinkBtn.BackgroundColor3 = Colors.primary
getLinkBtn.BackgroundTransparency = 0.2
getLinkBtn.Text = "Get Link"
getLinkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getLinkBtn.TextSize = 14
getLinkBtn.Font = Enum.Font.GothamSemibold
getLinkBtn.Parent = buttonFrame

local linkCorner = Instance.new("UICorner")
linkCorner.CornerRadius = UDim.new(0, 10)
linkCorner.Parent = getLinkBtn

local verifyBtn = Instance.new("TextButton")
verifyBtn.Name = "Verify"
verifyBtn.Size = UDim2.new(0.48, 0, 1, 0)
verifyBtn.Position = UDim2.new(0.52, 0, 0, 0)
verifyBtn.BackgroundColor3 = Colors.success
verifyBtn.BackgroundTransparency = 0.2
verifyBtn.Text = "Verify Key"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.TextSize = 14
verifyBtn.Font = Enum.Font.GothamSemibold
verifyBtn.Parent = buttonFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 10)
verifyCorner.Parent = verifyBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 220)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Colors.textSecondary
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = content

gui.Parent = game:GetService("CoreGui")

local function updateStatus(msg, color)
    statusLabel.Text = msg
    statusLabel.TextColor3 = color or Colors.textSecondary
end

local function closeUI()
    TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(backdrop, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.wait(0.2)
    gui:Destroy()
end

local function verifyKey(key)
    if not key or #key == 0 then
        updateStatus("Please enter a key", Colors.error)
        return false
    end
    
    updateStatus("Verifying...", Colors.primary)
    verifyBtn.Interactable = false
    
    local result = Junkie.check_key(key)
    
    if result and result.valid then
        getgenv().SCRIPT_KEY = key
        updateStatus("Success! Loading...", Colors.success)
        task.wait(0.5)
        closeUI()
        loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/dc15b5edf02bae8de414c6de43570d863cf3cf9b20b621c1d2c40270ed558aa2/download"))()
        return true
    else
        local err = result and result.message or "Invalid key"
        updateStatus("Error: " .. err, Colors.error)
        verifyBtn.Interactable = true
        return false
    end
end

getLinkBtn.MouseButton1Click:Connect(function()
    local link = Junkie.get_key_link()
    if link then
        if setclipboard then
            setclipboard(link)
            updateStatus("Link copied to clipboard!", Colors.success)
        else
            updateStatus("Link: " .. link, Colors.primary)
        end
    else
        updateStatus("Failed to get link", Colors.error)
    end
end)

verifyBtn.MouseButton1Click:Connect(function()
    verifyKey(keyInput.Text:gsub("%s+", ""))
end)

keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        verifyKey(keyInput.Text:gsub("%s+", ""))
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    closeUI()
end)

keyInput.Focused:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = Colors.primary, Thickness = 2}):Play()
end)

keyInput.FocusLost:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = Colors.border, Thickness = 1}):Play()
end)
