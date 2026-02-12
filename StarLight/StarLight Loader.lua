if LoadingScriptDoor then return end
LoadingScriptDoor = true

if game.Players.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and game.Players.LocalPlayer.PlayerGui.LoadingUI.Enabled == true then
    repeat task.wait() until game.Players.LocalPlayer.PlayerGui.LoadingUI.Enabled == false
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/Test.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/addons/ThemeManagerCopy.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/addons/SaveManagerCopy.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library:SetWatermarkVisibility(false)

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local PFS = game:GetService("PathfindingService")
local Storage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = game.Players.LocalPlayer
local playergui = player:WaitForChild("PlayerGui")
local pack = player:WaitForChild("Backpack")
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart") 
local cam = game:GetService("Workspace").Camera

local MobileOn = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())

_G.GetOldBright = {
    ["Old"] = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        GlobalShadows = Lighting.GlobalShadows,
        OutdoorAmbient = Lighting.OutdoorAmbient
    },
    ["New"] = {
        Brightness = 2,
        ClockTime = 14,
        FogEnd = 200000,
        FogStart = 100000,
        GlobalShadows = false,
        OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    }
}

if not HookLoading then
    HookLoading = true
    local old
    old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "FireServer" then
            if self.Name == "ClutchHeartbeat" and Toggles["Heart Win"].Value then
                return
            end
            if self.Name == "Crouch" and Toggles["Crouch Spoofing"].Value then
                args[1] = true
                return old(self,unpack(args))
            end
        end
        return old(self,...)
    end))
end

function Distance(pos)
    if root then
        return (root.Position - pos).Magnitude
    end
end

function Distance2(pos)
    if root then
        return (pos - root.Position).Magnitude
    end
end

function Deciphercode(v)
    local Hints = playergui:WaitForChild("PermUI"):WaitForChild("Hints")
    local code = {[1] = "_",[2] = "_", [3] = "_", [4] = "_", [5] = "_"}
    for i, v in pairs(v:WaitForChild("UI"):GetChildren()) do
        if v:IsA("ImageLabel") and v.Name ~= "Image" then
            for b, n in pairs(Hints:GetChildren()) do
                if n:IsA("ImageLabel") and n.Visible and v.ImageRectOffset == n.ImageRectOffset then
                    code[tonumber(v.Name)] = n:FindFirstChild("TextLabel").Text 
                end
            end
        end
    end 
    return code
end

function NotifyDoor(Notify)
    if MainUi:FindFirstChild("AchievementsHolder") and MainUi.AchievementsHolder:FindFirstChild("Achievement") then
        local acheivement = MainUi.AchievementsHolder.Achievement:Clone()
        acheivement.Size = UDim2.new(0, 0, 0, 0)
        acheivement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
        acheivement.Name = "LiveAchievement"
        acheivement.Visible = true
        acheivement.Frame.TextLabel.Text = Notify.NotificationType or "NOTIFICATION"

        if Notify.Color ~= nil then
            acheivement.Frame.TextLabel.TextColor3 = Notify.Color
            acheivement.Frame.UIStroke.Color = Notify.Color
            acheivement.Frame.Glow.ImageColor3 = Notify.Color
        end

        acheivement.Frame.Details.Desc.Text = tostring(Notify.Description)
        acheivement.Frame.Details.Title.Text = tostring(Notify.Title)
        acheivement.Frame.Details.Reason.Text = tostring(Notify.Reason or "")

        if Notify.Image:match("rbxthumb://") or Notify.Image:match("rbxassetid://") then
            acheivement.Frame.ImageLabel.Image = tostring(Notify.Image or "rbxassetid://0")
        else
            acheivement.Frame.ImageLabel.Image = "rbxassetid://" .. tostring(Notify.Image or "0")
        end
        if Notify.Image ~= nil then acheivement.Frame.ImageLabel.BackgroundTransparency = 1 end
        acheivement.Parent = MainUi.AchievementsHolder
        acheivement.Sound.SoundId = "rbxassetid://10469938989"
        acheivement.Sound.Volume = 1
        if Notify.SoundToggle then
            acheivement.Sound:Play()
        end

        task.spawn(function()
            acheivement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", 0.8, true)
            task.wait(0.8)
            acheivement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)
            TweenService:Create(acheivement.Frame.Glow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{ImageTransparency = 1}):Play()
            if Notify.Time ~= nil then
                if typeof(Notify.Time) == "number" then
                    task.wait(Notify.Time)
                elseif typeof(Notify.Time) == "Instance" then
                    Notify.Time.Destroying:Wait()
                end
            else
                task.wait(5)
            end
            acheivement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
            task.wait(0.5)
            acheivement:TweenSize(UDim2.new(1, 0, -0.1, 0), "InOut", "Quad", 0.5, true)
            task.wait(0.5)
            acheivement:Destroy()
        end)
    end
end

_G.EntityTable = {
    Entity = {
        ["FigureRig"] = "Figure",
        ["SallyMoving"] = "Window",
        ["RushMoving"] = "Rush",
        ["Eyes"] = "Eyes",
        ["Groundskeeper"] = "Skeeper",
        ["BackdoorLookman"] = "Lookman",
        ["BackdoorRush"] = "Blitz",
        ["MandrakeLive"] = "Mandrake",
        ["GloomPile"] = "Egg",
        ["Snare"] = "Snare",
        ["MonumentEntity"] = "Monument",
        ["LiveEntityBramble"] = "Bramble",
        ["GrumbleRig"] = "Grumble",
        ["GiggleCeiling"] = "Giggle",
        ["AmbushMoving"] = "Ambush",
        ["A60"] = "A-60",
        ["A120"] = "A-120"
    },
    EntityNotify = {
        RushMoving = {"Rush", "Find a hiding spot."},
        AmbushMoving = {"Ambush", "Hide multiple times!"},
        A60 = {"A-60", "Hide immediately!"},
        A120 = {"A-120", "Find A HidingSpot!"},
        JeffTheKiller = {"Jeff", "Keep distance and avoid."},
        SeekMovingNewClone = {"Seek", "Run and dodge obstacles!"},
        BackdoorRush = {"Blitz", "Find a hiding spot."},
        GlitchRush = {"GlitchRush", "Find a hiding spot."},
        GlitchAmbush = {"Glitch Ambush", "Find HidingSpot!"},
        GiggleCeiling = {"Giggle", "Avoid it."},
        Groundskeeper = {"Skeeper", "Don't touch grass"},
        MonumentEntity = {"Monument", "You go a distance and have to look back to check."}
    },
    Closet = {
        ["A60"] = 190,
        ["A120"] = 90,
        ["RushMoving"] = 150,
        ["AmbushMoving"] = 200,
        ["GlitchRush"] = 190,
        ["GlitchAmbush"] = 200,
        ["BackdoorRush"] = 160
    }
}

function EntityFond()
    for i, v in pairs(workspace:GetChildren()) do
        for j, b in pairs(_G.EntityTable.Closet) do
            if v.Name == j and v.PrimaryPart then
                return v
            end
        end
    end
end

local function CreateOxygenBar()
    local gui = Instance.new("ScreenGui")
    gui.Name = "OxygenBarGUI"
    gui.Parent = game.CoreGui

    local barFrame = Instance.new("Frame")
    barFrame.Name = "OxygenBar"
    barFrame.Size = UDim2.new(0.2, 0, 0.04, 0)
    barFrame.Position = UDim2.new(0.02, 0, 0.8, 0)
    barFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    barFrame.BackgroundTransparency = 1
    barFrame.BorderSizePixel = 0
    barFrame.Parent = gui

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = barFrame

    local barStroke = Instance.new("UIStroke")
    barStroke.Color = Color3.fromRGB(200, 230, 255)
    barStroke.Thickness = 1.5
    barStroke.Parent = barFrame

    local fillFrame = Instance.new("Frame")
    fillFrame.Name = "Fill"
    fillFrame.Size = UDim2.new(1, 0, 1, 0)
    fillFrame.Position = UDim2.new(0, 0, 0, 0)
    fillFrame.BackgroundColor3 = Color3.fromRGB(173, 216, 230)
    fillFrame.BackgroundTransparency = 0.2
    fillFrame.BorderSizePixel = 0
    fillFrame.Parent = barFrame

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fillFrame

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Oxygen: 100"
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextSize = 16
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Parent = barFrame

    return gui
end

local oxygenBarGui = CreateOxygenBar()
oxygenBarGui.Enabled = false

function UpdateOxygen(value, max)
    if not oxygenBarGui then return end
    local barFrame = oxygenBarGui.OxygenBar
    if not barFrame then return end
    local fillFrame = barFrame.Fill
    local textLabel = barFrame.Text
    local percent = value / max
    fillFrame.Size = UDim2.new(percent, 0, 1, 0)
    textLabel.Text = string.format("Oxygen: %.1f", value)
end

local EntityModules = Storage.ModulesClient.EntityModules
gameData = Storage:WaitForChild("GameData")
local RoomLate = gameData.LatestRoom
local floor = gameData:WaitForChild("Floor")
local isMines = floor.Value == "Mines"
local isHotel = floor.Value == "Hotel"
local isBackdoor = floor.Value == "Backdoor"
local isGarden = floor.Value == "Garden"
local isRoom = floor.Value == "Rooms"
local isParty = floor.Value == "Party"

for i, v in pairs(playergui:GetChildren()) do
    if v.Name == "MainUI" and v:FindFirstChild("Initiator") and v.Initiator:FindFirstChild("Main_Game") then
        requireGui = require(v.Initiator.Main_Game)
        MainUi = v
    end
end

playergui.ChildAdded:Connect(function(v)
    if v.Name == "MainUI" and v:FindFirstChild("Initiator") and v.Initiator:FindFirstChild("Main_Game") then
        requireGui = require(v.Initiator.Main_Game)
        MainUi = v
    end
end)

local FrameTimer = tick()
local CurrentRooms = 0
local FrameCounter = 0
local FPS = 60

game:GetService("RunService").RenderStepped:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    
    if isMines then 
        CurrentRooms = 100 + RoomLate.Value 
    elseif isBackdoor then 
        CurrentRooms = -50 + RoomLate.Value 
    else 
        CurrentRooms = RoomLate.Value 
    end
    
    Library:SetWatermark(("%s Current Rooms | %s FPS | %s MS"):format(
        math.floor(CurrentRooms),
        math.floor(FPS),
        math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    ))
    
    for i, v in pairs(_G.GetOldBright.New) do
        if _G.FullBright then
            Lighting[i] = v
        end
    end
    
    if _G.AntiCheatBruh and char then
        char:PivotTo(char:GetPivot() * CFrame.new(0, 0, 1000))
    end
    
    if game:GetService("Workspace"):FindFirstChild("Camera") then
        local CAM = game:GetService("Workspace").Camera
        if requireGui then
            if _G.ThirdCamera then
                CAM.CFrame = requireGui.finalCamCFrame * CFrame.new(1.5, -0.5, 6.5)
            end
            if _G.NoShake then
                requireGui.csgo = CFrame.new()
            end
        end
        
        if char:FindFirstChild("Head") and not (requireGui and requireGui.stopcam or char.HumanoidRootPart.Anchored and not char:GetAttribute("Hiding")) then
            char:SetAttribute("ShowInFirstPerson", _G.ThirdCamera)
            char.Head.LocalTransparencyModifier = _G.ThirdCamera and 0 or 1
        end
        
        if _G.FovOPCamera then
            if not requireGui then
                CAM.FieldOfView = _G.FovOP or 71
            else
                requireGui.fovtarget = _G.FovOP or 70
            end
        end
    end
end)

_G.RemoveLag = {"Leaves", "HidingShrub", "Flowers"}
local OriginalSettings = {
    Terrain = {
        WaterWaveSize = workspace.Terrain.WaterWaveSize,
        WaterWaveSpeed = workspace.Terrain.WaterWaveSpeed,
        WaterReflectance = workspace.Terrain.WaterReflectance,
        WaterTransparency = workspace.Terrain.WaterTransparency
    },
    Lighting = {
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart
    }
}

local AntiLagConnection

function RemoveLagTo(v)
    if _G.AntiLag == true then
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
        if v:IsA("ForceField") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Beam") then
            v:Destroy()
        end
        for i, n in pairs(_G.RemoveLag) do
            if v.Name == n or v.Name:find("grass") then
                v:Destroy()
            end
        end
        if v:IsA("PostEffect") then
            v.Enabled = false
        end
        if v:IsA("BasePart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.BackSurface = "SmoothNoOutlines"
            v.BottomSurface = "SmoothNoOutlines"
            v.FrontSurface = "SmoothNoOutlines"
            v.LeftSurface = "SmoothNoOutlines"
            v.RightSurface = "SmoothNoOutlines"
            v.TopSurface = "SmoothNoOutlines"
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        end
    end
end

function RestoreOriginalSettings()
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterWaveSize = OriginalSettings.Terrain.WaterWaveSize
        Terrain.WaterWaveSpeed = OriginalSettings.Terrain.WaterWaveSpeed
        Terrain.WaterReflectance = OriginalSettings.Terrain.WaterReflectance
        Terrain.WaterTransparency = OriginalSettings.Terrain.WaterTransparency
    end
    Lighting.GlobalShadows = OriginalSettings.Lighting.GlobalShadows
    Lighting.FogEnd = OriginalSettings.Lighting.FogEnd
    Lighting.FogStart = OriginalSettings.Lighting.FogStart
end

if isRoom then
    if workspace:FindFirstChild("PathFindPartsFolder") == nil then
        local Folder = Instance.new("Folder")
        Folder.Parent = workspace
        Folder.Name = "PathFindPartsFolder"
    end
end

function Notification(notifyFu)
    if _G.ChooseNotify == "Obsidian" then
        Library:Notify({
            Title = notifyFu.title or "",
            Description = notifyFu.content or "",
            Time = notifyFu.duration or 5,
        })
    elseif _G.ChooseNotify == "Roblox" then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = notifyFu.title,
            Text = notifyFu.content,
            Icon = ("rbxassetid://"..notifyFu.icon) or "",
            Duration = notifyFu.duration or 5
        })
    elseif _G.ChooseNotify == "Door" then
        NotifyDoor({
            Title = notifyFu.title or "",
            Description = notifyFu.content or "",
            Time = notifyFu.duration or 5,
            Image = ("rbxassetid://"..notifyFu.icon) or "",
            SoundToggle = true,
        })
    end
    if _G.ChooseNotify ~= "Door" then
        local sound = Instance.new("Sound", workspace)
        sound.SoundId = "rbxassetid://4590662766"
        sound.Volume = _G.VolumeTime or 2
        sound.PlayOnRemove = true
        sound:Destroy()
    end
end

Library:SetDPIScale(100)
local Window = Library:CreateWindow({
    Title = "Starlight Hub",
    Center = true,
    AutoShow = true,
    Resizable = true,
    Footer = "by tanhoangvn and gianghub",
    Icon = 134430677550422,
    ShowCustomCursor = true,
    NotifySide = "Right",
    TabPadding = 2,
    MenuFadeTime = 0
})

Tabs = {
    Main = Window:AddTab("Main", "house"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Player = Window:AddTab("Player", "user"),
    Automation = Window:AddTab("Automation", "bot"),
    ESP = Window:AddTab("ESP", "target"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings")
}

local Main = Tabs.Main:AddLeftGroupbox("Main Features")

Main:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false,
    Callback = function(Value)
        _G.FullBright = Value
        if _G.FullBright then
            for i, v in pairs(_G.GetOldBright.New) do
                Lighting[i] = v
            end
        else
            for i, v in pairs(_G.GetOldBright.Old) do
                Lighting[i] = v
            end
        end
    end
})

Main:AddToggle("Nofog", {
    Text = "No Fog",
    Default = false,
    Callback = function(Value)
        _G.Nofog = Value
        while _G.Nofog do
            for i, v in pairs(Lighting:GetChildren()) do
                if v.ClassName == "Atmosphere" then
                    v.Density = 0
                    v.Haze = 0
                end
            end
            task.wait()
        end
        for i, v in pairs(Lighting:GetChildren()) do
            if v.ClassName == "Atmosphere" then
                v.Density = 0.3
                v.Haze = 1
            end
        end
    end
})

Main:AddToggle("Instant Prompt", {
    Text = "Instant Prompt",
    Default = false,
    Callback = function(Value)
        _G.NoCooldownProximity = Value
        if _G.NoCooldownProximity == true then
            for i, v in pairs(workspace:GetDescendants()) do
                if v.ClassName == "ProximityPrompt" then
                    v.HoldDuration = 0
                end
            end
            CooldownProximity = workspace.DescendantAdded:Connect(function(Cooldown)
                if _G.NoCooldownProximity == true then
                    if Cooldown:IsA("ProximityPrompt") then
                        Cooldown.HoldDuration = 0
                    end
                end
            end)
        else
            if CooldownProximity then
                CooldownProximity:Disconnect()
                CooldownProximity = nil
            end
        end
    end
})

Main:AddToggle("Anti Lag", {
    Text = "Anti Lag",
    Default = false,
    Callback = function(Value)
        _G.AntiLag = Value
        if _G.AntiLag == true then
            if not OriginalSettings.Stored then
                local Terrain = workspace:FindFirstChildOfClass("Terrain")
                if Terrain then
                    OriginalSettings.Terrain.WaterWaveSize = Terrain.WaterWaveSize
                    OriginalSettings.Terrain.WaterWaveSpeed = Terrain.WaterWaveSpeed
                    OriginalSettings.Terrain.WaterReflectance = Terrain.WaterReflectance
                    OriginalSettings.Terrain.WaterTransparency = Terrain.WaterTransparency
                end
                OriginalSettings.Lighting.GlobalShadows = Lighting.GlobalShadows
                OriginalSettings.Lighting.FogEnd = Lighting.FogEnd
                OriginalSettings.Lighting.FogStart = Lighting.FogStart
                OriginalSettings.Stored = true
            end

            for i,v in pairs(workspace:GetDescendants()) do
                RemoveLagTo(v)
            end

            AntiLagConnection = workspace.DescendantAdded:Connect(RemoveLagTo)
        else
            if AntiLagConnection then
                AntiLagConnection:Disconnect()
                AntiLagConnection = nil
            end
            RestoreOriginalSettings()
        end
    end
})

local Main2 = Tabs.Main:AddRightGroupbox("Entity Protection")

Main2:AddToggle("AntiScreech", {
    Text = "Anti Screech",
    Default = false,
    Callback = function(Value)
        _G.AntiScreech = Value
        if MainUi:FindFirstChild("Initiator") and MainUi.Initiator:FindFirstChild("Main_Game") and MainUi.Initiator.Main_Game:FindFirstChild("RemoteListener") and MainUi.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules") then
            local ScreechScript = MainUi.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("Screech") or MainUi.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("_Screech")
            if ScreechScript then
                ScreechScript.Name = _G.AntiScreech and "_Screech" or "Screech"
            end
        end
    end
})

Main2:AddToggle("Heart Win", {
    Text = "Anti Clutch Heart",
    Default = false
})

Main2:AddToggle("Anti Halt", {
    Text = "Anti Halt",
    Default = false,
    Callback = function(Value)
        _G.NoHalt = Value
        local HaltShade = EntityModules:FindFirstChild("Shade") or EntityModules:FindFirstChild("_Shade")
        if HaltShade then
            HaltShade.Name = _G.NoHalt and "_Shade" or "Shade"
        end
    end
})

Main2:AddToggle("AntiEyes", {
    Text = "Anti Eyes / Lookman",
    Default = false,
    Callback = function(Value)
        _G.NoEyes = Value
        while _G.NoEyes do
            if workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("BackdoorLookman") then
                if Storage:FindFirstChild("RemotesFolder") then
                    Storage:WaitForChild("RemotesFolder"):WaitForChild("MotorReplication"):FireServer(-649)
                end
            end
            task.wait()
        end
    end
})

Main2:AddToggle("Anti Snare", {
    Text = "Anti Snare",
    Default = false,
    Callback = function(Value)
        for i, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "Snare" then
                if v:FindFirstChild("Hitbox") then
                    v.Hitbox:Destroy()
                end
            end
        end
    end
})

if isGarden then
    Main2:AddToggle("Anti Monument", {
        Text = "Anti Monument",
        Default = false,
        Callback = function(Value)
            _G.NoMonument = Value
            while _G.NoMonument do
                for i, v in pairs(game.Workspace:GetChildren()) do
                    if v.Name == "MonumentEntity" and v:FindFirstChild("Top") then
                        for _, x in pairs(v.Top:GetChildren()) do
                            if x.Name:find("Hitbox") then
                                x:Destroy()
                            end
                        end
                    end
                end
                task.wait()
            end
        end
    })
end

if isRoom or isParty then
    Main2:AddToggle("Anti A90", {
        Text = "Anti A-90",
        Default = false,
        Callback = function(Value)
            _G.NoA90 = Value
            if MainUi:FindFirstChild("Initiator") and MainUi.Initiator:FindFirstChild("Main_Game") and MainUi.Initiator.Main_Game:FindFirstChild("RemoteListener") and MainUi.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules") then
                local A90Script = MainUi.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("A90") or MainUi.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("_A90")
                if A90Script then
                    A90Script.Name = _G.NoA90 and "_A90" or "A90"
                end
            end
        end
    })
end

local Visuals = Tabs.Visuals:AddLeftGroupbox("Camera")

Visuals:AddToggle("3rd Cam", {
    Text = "Third Camera",
    Default = false,
    Callback = function(Value)
        _G.ThirdCamera = Value
    end
}):AddKeyPicker("ThirdCameraKey", {
    Default = "V",
    Text = "Third Person",
    Mode = "Toggle",
    SyncToggleState = true
})

Visuals:AddSlider("FovCam", {
    Text = "FOV Camera",
    Default = 80,
    Min = 70,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        _G.FovOP = Value
    end
})

Visuals:AddToggle("FOVCam", {
    Text = "FOV Camera",
    Default = false,
    Callback = function(Value)
        _G.FovOPCamera = Value
    end
})

Visuals:AddToggle("NoShake", {
    Text = "No Camera Shake",
    Default = false,
    Callback = function(Value)
        _G.NoShake = Value
    end
})

local Visuals2 = Tabs.Visuals:AddRightGroupbox("Environment")

if isMines or isParty then
    Visuals2:AddToggle("Guide Path", {
        Text = "Guide Path",
        Default = false,
        Callback = function(Value)
            _G.GuideNah = Value
            if _G.GuideNah then
                local function PathLights()
                    if workspace:FindFirstChild("PathLights") then
                        local function GuideMine(v)
                            if v:IsA("Part") then
                                local CLONEGUIDE = v:Clone()
                                CLONEGUIDE.CFrame = CLONEGUIDE.CFrame
                                CLONEGUIDE.Color = Color3.fromRGB(0, 255, 0)
                                CLONEGUIDE.Name = "GuideClone"
                                CLONEGUIDE.Shape = Enum.PartType.Ball
                                CLONEGUIDE.Size = Vector3.new(1, 1, 1)
                                CLONEGUIDE.Transparency = 0
                                CLONEGUIDE.Anchored = true
                                CLONEGUIDE.Parent = v
                                for i, n in pairs(CLONEGUIDE:GetChildren()) do
                                    n:Destroy()
                                end
                            end
                        end
                        for _, v in ipairs(workspace.PathLights:GetChildren()) do
                            GuideMine(v)
                        end
                        GuideMineReal = workspace.PathLights.ChildAdded:Connect(function(v)
                            GuideMine(v)
                        end)
                    end
                end
                for _, v in ipairs(workspace:GetChildren()) do
                    PathLights()
                end
                GoLightPath = workspace.ChildAdded:Connect(function(v)
                    PathLights()
                end)
            else
                if GuideMineReal then
                    GuideMineReal:Disconnect()
                    GuideMineReal = nil
                end
                if GoLightPath then
                    GoLightPath:Disconnect()
                    GoLightPath = nil
                end
                if workspace:FindFirstChild("PathLights") then
                    for i, v in pairs(workspace:FindFirstChild("PathLights"):GetChildren()) do
                        if v:IsA("Part") then
                            for _, d in pairs(v:GetChildren()) do
                                if d.Name == "GuideClone" then
                                    d:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        end
    })
end

Visuals2:AddSlider("Hiding Transparency", {
    Text = "Hiding Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        _G.TransparencyHide = Value
    end
})

Visuals2:AddToggle("Transparency Hiding", {
    Text = "Transparency Hiding",
    Default = false,
    Callback = function(Value)
        _G.HidingTransparency = Value
        while _G.HidingTransparency do
            if char:GetAttribute("Hiding") then
                for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
                    if v:IsA("ObjectValue") and v.Name == "HiddenPlayer" then
                        if v.Value == char then
                            local hidePart = {}
                            for _, i in pairs(v.Parent:GetChildren()) do
                                if i:IsA("BasePart") then
                                    i.Transparency = _G.TransparencyHide or 0.5
                                    table.insert(hidePart, i)
                                end
                            end
                            repeat task.wait()
                                for _, h in pairs(hidePart) do
                                    h.Transparency = _G.TransparencyHide or 0.5
                                    task.wait()
                                end
                            until not char:GetAttribute("Hiding") or not _G.HidingTransparency
                            for _, n in pairs(hidePart) do
                                n.Transparency = 0
                                task.wait()
                            end
                            break
                        end
                    end
                end
            end
            task.wait()
        end
    end
})

local Player = Tabs.Player:AddLeftGroupbox("Movement")

Player:AddToggle("NoAcceleration", {
    Text = "No Acceleration",
    Default = false,
    Callback = function(Value)
        _G.NoAcceleration = Value
        while _G.NoAcceleration do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(100,0.5,0.2)
                if player.Character:FindFirstChild("Collision") then
                    player.Character.Collision.CustomPhysicalProperties = PhysicalProperties.new(100,0.5,0.2)
                end
            end
            task.wait()
        end
    end
})

Player:AddSlider("WS", {
    Text = "WalkSpeed",
    Default = 20,
    Min = 16,
    Max = (isParty and 80 or 21),
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        _G.WalkSpeedTp = Value
    end
})

if isMines or isParty then
    Player:AddSlider("Ladder", {
        Text = "Ladder Speed",
        Default = 20,
        Min = 16,
        Max = 75,
        Rounding = 0,
        Compact = false,
        Callback = function(Value)
            _G.LadderSpeed = Value
        end
    })
end

Player:AddSlider("Vitamin", {
    Text = "Vitamin Speed",
    Default = 3,
    Min = 1,
    Max = 6,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        _G.VitaminSpeed = Value
    end
})

Player:AddDropdown("WalkSpeed", {
    Text = "WalkSpeed",
    Multi = false,
    Values = {"Vitamin", "Speed Hack"},
    Callback = function(Value)
        _G.WalkSpeedChose = Value
        if Value ~= "Vitamin" then
            if char then
                char:SetAttribute("SpeedBoost", 0)
            end
        end
    end
})

local antiSpeedEnabled = false
local antiSpeedLoop = nil
local clonedCollision = nil

if not isParty then
    Player:AddToggle("Bypass Speed", {
        Text = "Bypass Speed",
        Default = false,
        Callback = function(Value)
            _G.BypassSpeed = Value
            antiSpeedEnabled = Value
            
            if antiSpeedEnabled then
                local LocalPlayer = game:GetService("Players").LocalPlayer
                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local CollisionPart = Character:WaitForChild("CollisionPart")
                
                clonedCollision = CollisionPart:Clone()
                clonedCollision.Name = "_CollisionClone"
                clonedCollision.Massless = true
                clonedCollision.Parent = Character
                clonedCollision.CanCollide = false
                clonedCollision.CanQuery = false
                clonedCollision.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.7, 0, 1, 1)
                
                antiSpeedLoop = task.spawn(function()
                    while antiSpeedEnabled do
                        task.wait(0.23)
                        if clonedCollision then
                            clonedCollision.Massless = false
                            task.wait(0.23)
                            local root = Character:FindFirstChild("HumanoidRootPart")
                            if root and root.Anchored then
                                clonedCollision.Massless = true
                                task.wait(1)
                            end
                            clonedCollision.Massless = true
                        end
                    end
                end)
                
                Options.WS:SetMax(60)
                Options.Vitamin:SetMax(40)
            else
                if antiSpeedLoop then
                    task.cancel(antiSpeedLoop)
                    antiSpeedLoop = nil
                end
                
                if clonedCollision then
                    clonedCollision:Destroy()
                    clonedCollision = nil
                end
                
                if not _G.AntiCheatBruh and not LoadingInstant then
                    Options.WS:SetMax(21)
                    Options.Vitamin:SetMax(6)
                end
            end
        end
    })
end

Player:AddToggle("WalkSpeed", {
    Text = "WalkSpeed",
    Default = false,
    Callback = function(Value)
        _G.SpeedWalk = Value
        while _G.SpeedWalk do
            if _G.WalkSpeedChose == "Speed Hack" then
                if char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = (char:GetAttribute("Climbing") and (_G.LadderSpeed or 30) or _G.WalkSpeedTp)
                end
            elseif _G.WalkSpeedChose == "Vitamin" then
                if char then
                    if not char:GetAttribute("Climbing") then
                        char:SetAttribute("SpeedBoost", _G.VitaminSpeed or 3)
                    else
                        char:SetAttribute("SpeedBoost", 0)
                        char.Humanoid.WalkSpeed = _G.LadderSpeed or 30
                    end
                end
            end
            task.wait()
        end
        if char then
            char:SetAttribute("SpeedBoost", 0)
        end
    end
})

local figureGodModeEnabled = false
local figureGodModeLoop = nil
local isFigureGodModeActive = false
local fakeCameraConnection = nil
local originalCameraType = nil
local originalCameraSubject = nil

local function getFigurePosition(figureRig)
    if not figureRig then return nil end
    local ok, pivot = pcall(function()
        return figureRig:GetPivot()
    end)
    if ok and pivot then
        return pivot.Position
    end
    local part = figureRig:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position or nil
end

local function enableFakeCamera(character)
    if fakeCameraConnection then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    originalCameraType = cam.CameraType
    originalCameraSubject = cam.CameraSubject
    cam.CameraType = Enum.CameraType.Scriptable
    fakeCameraConnection = RunService.RenderStepped:Connect(function()
        if not head or not head.Parent then return end
        cam.CFrame = head.CFrame * CFrame.new(0, -10, 0)
    end)
end

local function disableFakeCamera()
    if fakeCameraConnection then
        fakeCameraConnection:Disconnect()
        fakeCameraConnection = nil
    end
    if cam then
        cam.CameraType = originalCameraType or Enum.CameraType.Custom
        if originalCameraSubject then
            cam.CameraSubject = originalCameraSubject
        end
    end
end

local function invertedGodModeDown(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = hrp.CFrame - Vector3.new(0, 13, 0)
end

local function enableFigureGodMode(character)
    local humanoid = character:FindFirstChild("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not (humanoid and hrp) then return end
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 13, 0)
    humanoid.HipHeight = 13
    enableFakeCamera(character)
    isFigureGodModeActive = true
    Library:Notify("Figure GodMode Activated", 2)
end

local function disableFigureGodMode(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.HipHeight = 2
    end
    disableFakeCamera()
    invertedGodModeDown(character)
    isFigureGodModeActive = false
    Library:Notify("Figure GodMode Deactivated", 2)
end

local function checkFigureDistance()
    if not figureGodModeEnabled then return end
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local figureNearby = false
    for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
        local setup = room:FindFirstChild("FigureSetup")
        if setup then
            local rig = setup:FindFirstChild("FigureRig")
            if rig then
                local pos = getFigurePosition(rig)
                if pos and (hrp.Position - pos).Magnitude <= 28 then
                    figureNearby = true
                    break
                end
            end
        end
    end
    if figureNearby and not isFigureGodModeActive then
        enableFigureGodMode(character)
    elseif not figureNearby and isFigureGodModeActive then
        disableFigureGodMode(character)
    end
end

Player:AddToggle("Figure GodMode", {
    Text = "Figure GodMode",
    Default = false,
    Callback = function(enabled)
        figureGodModeEnabled = enabled
        if enabled then
            figureGodModeLoop = task.spawn(function()
                while figureGodModeEnabled do
                    task.wait(0.1)
                    checkFigureDistance()
                end
            end)
        else
            if figureGodModeLoop then
                task.cancel(figureGodModeLoop)
                figureGodModeLoop = nil
            end
            if isFigureGodModeActive then
                local character = player.Character
                if character then
                    disableFigureGodMode(character)
                end
            end
        end
    end
})

local Player2 = Tabs.Player:AddRightGroupbox("Abilities")

Player2:AddToggle("Crouch Spoofing", {
    Text = "Crouch Spoofing",
    Default = false
})

Player2:AddToggle("Use Jump", {
    Text = "Use Jump",
    Default = false,
    Callback = function(Value)
        _G.ButtonJump = Value 
        while _G.ButtonJump do 
            if char then
                char:SetAttribute("CanJump", true)
            end
            task.wait()
        end 
        if char then
            char:SetAttribute("CanJump", false)
        end
    end
})

Player2:AddToggle("Check Fool", {
    Text = "Check "..(isBackdoor and "Haste Clock" or "Oxygen"),
    Default = false,
    Callback = function(Value)
        _G.ActiveCheck = Value
        if _G.ActiveCheck then
            if isBackdoor then
                if Storage:FindFirstChild("FloorReplicated") and game:GetService("ReplicatedStorage").FloorReplicated:FindFirstChild("DigitalTimer") and game:GetService("ReplicatedStorage").FloorReplicated:FindFirstChild("ScaryStartsNow") then
                    local function getTimeFormat(sec)
                        local min = math.floor(sec / 60)
                        local remSec = sec % 60
                        return string.format("%02d:%02d", min, remSec)
                    end
                    getCheck = Storage.FloorReplicated.DigitalTimer:GetPropertyChangedSignal("Value"):Connect(function()
                        if _G.ActiveCheck and game:GetService("ReplicatedStorage").FloorReplicated.ScaryStartsNow.Value then
                            if Storage.FloorReplicated.DigitalTimer.Value <= 60 then
                                SizeTime = (Storage.FloorReplicated.DigitalTimer.Value / 60)
                            else
                                SizeTime = 1
                            end
                        end
                    end)
                end
            else
                oxygenBarGui.Enabled = true
                UpdateOxygen(char:GetAttribute("Oxygen") or 100, 100)
                getCheck = char:GetAttributeChangedSignal("Oxygen"):Connect(function()
                    UpdateOxygen(char:GetAttribute("Oxygen") or 100, 100)
                end)
            end
        else
            if getCheck then
                getCheck:Disconnect()
                getCheck = nil
            end
            oxygenBarGui.Enabled = false
        end
    end
})

local Player3 = Tabs.Player:AddLeftGroupbox("Godmode")

local function setGodmode(state)
    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local collision = char:FindFirstChild("Collision")
    if not (hum and root and collision) then return end

    local crouch = collision:FindFirstChild("CollisionCrouch")

    if state then
        Storage.RemotesFolder.Crouch:FireServer(true)
        collision.Size = Vector3.new(1, 0.001, 3)
        if crouch then
            crouch.Size = Vector3.new(1, 0.001, 3)
            crouch.Position = root.Position - Vector3.new(0, 1, 0)
        end
        hum.HipHeight = 0.0001
    else
        Storage.RemotesFolder.Crouch:FireServer(false)
        root.CFrame = root.CFrame + Vector3.new(0, 3, 0)
        collision.Size = Vector3.new(5.5, 3, 3)
        if crouch then
            crouch.Size = Vector3.new(3, 3, 3)
            crouch.Position = root.Position - Vector3.new(0, 1, 0)
        end
        hum.HipHeight = 2.4
    end
end

Player3:AddToggle("Godmode", {
    Text = "Godmode",
    Default = false,
    Callback = function(Value)
        _G.Godmode = Value
        if _G.Godmode then
            setGodmode(true)
        else
            setGodmode(false)
        end
    end
}):AddKeyPicker("GodmodeKey", {
    Default = "G",
    Text = "Godmode",
    Mode = "Toggle",
    SyncToggleState = true
})

local Player4 = Tabs.Player:AddRightGroupbox("Environment")

if isHotel then
    Player4:AddToggle("Anti Seek Obstruction", {
        Text = "Anti Seek Obstruction",
        Default = false,
        Callback = function(Value)
            for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
                if v.Name == "ChandelierObstruction" or v.Name == "Seek_Arm" then
                    for b, h in pairs(v:GetDescendants()) do
                        if h:IsA("BasePart") then 
                            h.CanTouch = not Value
                        end
                    end
                end
            end
        end
    })
end

if not isGarden and not isRoom then
    Player4:AddToggle("Anti Fake Door", {
        Text = "Anti Fake Door",
        Default = false,
        Callback = function(Value)
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "DoorFake" then
                    local CollisionFake = v:FindFirstChild("Hidden", true)
                    local Prompt = v:FindFirstChild("UnlockPrompt", true)
                    if CollisionFake then
                        CollisionFake.CanTouch = not Value
                    end
                    if Prompt then
                        Prompt:Destroy()
                    end
                end
            end
        end
    })
end

if isMines or isParty then
    Player4:AddToggle("Anti Egg Gloom", {
        Text = "Anti Egg Gloom",
        Default = false,
        Callback = function(Value)
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "Egg" then
                    v.CanTouch = not Value
                end
            end
        end
    })

    Player4:AddToggle("Anti Giggle", {
        Text = "Anti Giggle",
        Default = false,
        Callback = function(Value)
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name == "GiggleCeiling" then
                    repeat task.wait() until v:FindFirstChild("Hitbox")
                    wait(0.1)
                    if v:FindFirstChild("Hitbox") then
                        v.Hitbox:Destroy()
                    end
                end
            end
        end
    })

    Player4:AddToggle("Anti Seek Flood", {
        Text = "Anti Seek Flood",
        Default = false,
        Callback = function(Value)
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "_DamHandler" then
                    repeat task.wait() until v:FindFirstChild("SeekFloodline")
                    wait(0.1)
                    if v:FindFirstChild("SeekFloodline") then
                        v.SeekFloodline.CanCollide = Value
                    end
                end
            end
        end
    })

    Player4:AddToggle("Anti Fall Barrier", {
        Text = "Anti Fall Barrier",
        Default = false,
        Callback = function(Value)
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "PlayerBarrier" and v.Size.Y == 2.75 and (v.Rotation.X == 0 or v.Rotation.X == 180) then
                    local CLONEBARRIER = v:Clone()
                    CLONEBARRIER.CFrame = CLONEBARRIER.CFrame * CFrame.new(0, 0, -5)
                    CLONEBARRIER.Color = Color3.new(1, 1, 1)
                    CLONEBARRIER.Name = "CLONEBARRIER_ANTI"
                    CLONEBARRIER.Size = Vector3.new(CLONEBARRIER.Size.X, CLONEBARRIER.Size.Y, 11)
                    CLONEBARRIER.Transparency = 0
                    CLONEBARRIER.Parent = v.Parent
                end
            end
        end
    })
end

local Player5 = Tabs.Player:AddRightGroupbox("Notifications")

local EntityName = {}
for i, v in pairs(_G.EntityTable.EntityNotify) do
    table.insert(EntityName, v[1])
end

Player5:AddDropdown("EntityNotify", {
    Text = "Entity Notify",
    Values = EntityName,
    Default = {"Rush"},
    Multi = true,
    Callback = function(Value)
        _G.EntityNotifyNow = {}
        for i, v in next, Options.EntityNotify.Value do
            table.insert(_G.EntityNotifyNow, i)
        end
    end
})

Player5:AddToggle("Notification Entity", {
    Text = "Notification Entity",
    Default = false,
    Callback = function(Value)
        _G.NotifyEntity = Value
        if _G.NotifyEntity then
            EntityChild = workspace.DescendantAdded:Connect(function(child)
                for i, v in pairs(_G.EntityNotifyNow or {"Rush"}) do
                    if child:IsA("Model") and child.Name:find(v) then
                        repeat task.wait() until not child:IsDescendantOf(workspace) or Distance(child:GetPivot().Position) < 10000
                        local EntityName = _G.EntityTable.EntityNotify[child.Name][1]
                        local EntityWa = _G.EntityTable.EntityNotify[child.Name][2]
                        if child:IsDescendantOf(workspace) then
                            child.AncestryChanged:Connect(function()
                                if not child.Parent then
                                    if _G.GoodbyeBro then
                                        Notification({title = "Starlight", content = "Entity: Goodbye "..EntityName.."!!", duration = 5, icon = "82357489459031"})
                                        if _G.NotifyEntityChat then
                                            local text = _G.ChatNotifyGoodBye or "Goodbye "
                                            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(text..EntityName)
                                        end
                                    end
                                end
                            end)
                            Notification({title = "Starlight", content = "Entity: "..EntityName.." has spawned! "..EntityWa, duration = 5, icon = "82357489459031"})
                            if _G.NotifyEntityChat then
                                local text = _G.ChatNotify or " Spawn!!"
                                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(EntityName..text)
                            end
                        end
                    end
                end
            end)
        else
            if EntityChild then
                EntityChild:Disconnect()
                EntityChild = nil
            end
        end
    end
})

Player5:AddInput("ChatGodbye", {
    Text = "Input Chat GoodBye",
    Default = "Goodbye!!",
    Numeric = false,
    Finished = true,
    Placeholder = "Your Chat GoodBye...",
    Callback = function(Value)
        _G.ChatNotifyGoodBye = Value
    end
})

Player5:AddInput("Input Chat Entity", {
    Text = "Input Chat Entity",
    Default = "Spawn!!",
    Numeric = false,
    Finished = true,
    Placeholder = "Your Chat...",
    Callback = function(Value)
        _G.ChatNotify = Value
    end
})

Player5:AddToggle("Notification Chat", {
    Text = "Notification Chat Entity",
    Default = false,
    Callback = function(Value)
        _G.NotifyEntityChat = Value
    end
})

Player5:AddToggle("Notification Goodbye", {
    Text = "Notification Goodbye",
    Default = false,
    Callback = function(Value)
        _G.GoodbyeBro = Value
    end
})

if isGarden then
    Player5:AddToggle("Notification Bramble Light", {
        Text = "Notification Bramble Light",
        Default = false,
        Callback = function(Value)
            _G.BrambleLight = Value
            if _G.BrambleLight then
                local function BrambleLight(v)
                    if v.Name == "LiveEntityBramble" and v:FindFirstChild("Head") and v.Head:FindFirstChild("LanternNeon") then
                        for i, x in pairs(v.Head.LanternNeon:GetChildren()) do
                            if x.Name == "Attachment" and x:FindFirstChild("PointLight") then
                                LightningNotifyBr = x.PointLight:GetPropertyChangedSignal("Enabled"):Connect(function()
                                    if x.PointLight.Enabled then turn = "ON" else turn = "OFF" end
                                    Notification({title = "Starlight", content = "Bramble Light ("..turn..")", duration = 3, icon = "82357489459031"})
                                    if _G.NotifyEntityChat then
                                        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("Bramble Light ("..turn..")")
                                    end
                                end)
                            end
                        end
                    end
                end
                for _, v in ipairs(workspace:GetDescendants()) do
                    BrambleLight(v)
                end
                BrambleSpawn = workspace.DescendantAdded:Connect(function(v)
                    BrambleLight(v)
                end)
            else
                if LightningNotifyBr then
                    LightningNotifyBr:Disconnect()
                    LightningNotifyBr = nil
                end
                if BrambleSpawn then
                    BrambleSpawn:Disconnect()
                    BrambleSpawn = nil
                end
            end
        end
    })
end

local Automation = Tabs.Automation:AddLeftGroupbox("Auto Farm")

if isRoom then
    Automation:AddToggle("Auto Room", {
        Text = "Auto Room",
        Default = false,
        Callback = function(Value)
            _G.AutoRoom = Value
            if _G.AutoRoom then
                if MainUi:FindFirstChild("Initiator") and MainUi.Initiator:FindFirstChild("Main_Game") and MainUi.Initiator.Main_Game:FindFirstChild("RemoteListener") and MainUi.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules") then
                    local A90Script = MainUi.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("A90")
                    if A90Script then
                        A90Script.Name = "_A90"
                    end
                end
                function Locker()
                    local LockerRooms
                    for i,v in pairs(workspace.CurrentRooms:GetDescendants()) do
                        if v.Name == "Rooms_Locker" then
                            if v:FindFirstChild("Door") and v:FindFirstChild("HiddenPlayer") then
                                if v.HiddenPlayer.Value == nil and v.Door.Position.Y > -3 then
                                    if LockerRooms == nil then
                                        LockerRooms = v.Door
                                    else
                                        if Distance(v.Door.Position) < (LockerRooms.Position - root.Position).Magnitude then
                                            LockerRooms = v.Door
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return LockerRooms
                end
                function getPathRooms()
                    local Part
                    local Entity = (workspace:FindFirstChild("A60") or workspace:FindFirstChild("A120"))
                    if Entity and Entity.Main.Position.Y > -6.5 then
                        Part = Locker()
                    else
                        if RoomLate.Value ~= 1000 then
                            if char:GetAttribute("Hiding") then
                                Storage:WaitForChild("RemotesFolder"):WaitForChild("CamLock"):FireServer() 
                            end
                            Part = workspace.CurrentRooms[RoomLate.Value].Door.Door
                        end
                    end
                    return Part
                end
                function getHide()
                    local Path = getPathRooms()
                    local Entity = (workspace:FindFirstChild("A60") or workspace:FindFirstChild("A120"))
                    if Entity then
                        if Path then
                            if Path.Parent.Name:find("Rooms_Locker") and Entity:FindFirstChild("Main") and Entity.Main.Position.Y > -6.5 then
                                if (root.Position - Path.Position).Magnitude <= 30 then
                                    if not char:GetAttribute("Hiding") then
                                        fireproximityprompt(Path.Parent:FindFirstChild("HidePrompt"))
                                    end
                                end
                            end
                        end
                    end
                end
            end
            spawn(function() 
                while _G.AutoRoom do 
                    getHide()
                    _G.SpeedWalk = false
                    _G.BypassSpeed = false
                    char:SetAttribute("CanJump", false)
                    if char:FindFirstChild("Humanoid") then
                        char.Humanoid.WalkSpeed = 21.5
                    end
                    if char:FindFirstChild("CloneCollisionPart1") then
                        char:FindFirstChild("CloneCollisionPart1"):Destroy()
                    end
                    task.wait() 
                end 
            end)
            while _G.AutoRoom do 
                Destination = getPathRooms()
                local path = PFS:CreatePath({WaypointSpacing = 0.25, AgentRadius = 1.55, AgentCanJump = false})
                path:ComputeAsync(root.Position - Vector3.new(0, 2.5, 0), Destination.Position)
                if path and path.Status == Enum.PathStatus.Success then
                    local Waypoints = path:GetWaypoints()
                    workspace:FindFirstChild("PathFindPartsFolder"):ClearAllChildren()
                    for _, Waypoint in pairs(Waypoints) do
                        local part = Instance.new("Part")
                        part.Size = Vector3.new(0.5, 0.5, 0.5)
                        part.Position = Waypoint.Position
                        part.Shape = "Cylinder"
                        part.Material = "SmoothPlastic"
                        part.Shape = Enum.PartType.Ball
                        part.Anchored = true
                        part.CanCollide = false
                        part.Parent = workspace:FindFirstChild("PathFindPartsFolder")
                    end
                    for _, Waypoint in pairs(Waypoints) do
                        if not char:GetAttribute("Hiding") then
                            char.Humanoid:MoveTo(Waypoint.Position)
                            char.Humanoid.MoveToFinished:Wait()
                        end
                    end
                end
            end
            wait(0.3)
            workspace:FindFirstChild("PathFindPartsFolder"):ClearAllChildren()
        end
    })
end

local autoFinishDailyEnabled = false
local autoFinishDailyLoop = nil

Automation:AddToggle("Auto Finish Daily Run", {
    Text = "Auto Finish Daily Run",
    Default = false,
    Callback = function(enabled)
        autoFinishDailyEnabled = enabled
        if enabled then
            Library:Notify("[Finish Daily Run]: To finish the daily run go through some rooms it'll automatically finish everything else after some time", 8)
            autoFinishDailyLoop = task.spawn(function()
                while autoFinishDailyEnabled do
                    task.wait(1)
                    local Character = player.Character
                    if not Character then return end
                    local hrp = Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    local currentRooms = workspace:FindFirstChild("CurrentRooms")
                    if not currentRooms then return end
                    for _, room in pairs(currentRooms:GetChildren()) do
                        local rippleExitDoor = room:FindFirstChild("RippleExitDoor", true)
                        if rippleExitDoor then
                            local doorPart = rippleExitDoor:IsA("BasePart") and rippleExitDoor or rippleExitDoor:FindFirstChildWhichIsA("BasePart", true)
                            if doorPart then
                                hrp.CFrame = doorPart.CFrame + Vector3.new(0, 3, 0)
                                Library:Notify("Teleported to Daily Run Exit!", 3)
                            end
                        end
                    end
                end
            end)
        else
            if autoFinishDailyLoop then
                task.cancel(autoFinishDailyLoop)
                autoFinishDailyLoop = nil
            end
        end
    end
})

if not isRoom then
    Automation:AddToggle("Auto Closet", {
        Text = "Auto Closet",
        Default = false,
        Callback = function(Value)
            _G.AutoCloset = Value
            while _G.AutoCloset do
                local EntityCl = EntityFond()
                if EntityCl and EntityCl.PrimaryPart then
                    local distanceCloset = _G.EntityTable.Closet[EntityCl.Name]
                    local distance = Distance2(EntityCl.PrimaryPart.Position)
                    if distanceCloset and distance then
                        if distance <= distanceCloset then
                            if not char:GetAttribute("Hiding") then
                                for i, v in pairs(_G.AddedGet) do
                                    if v:FindFirstChild("HiddenPlayer") and v:FindFirstChildWhichIsA("BasePart") and v:FindFirstChild("Main") and not v.Main:FindFirstChild("HideEntityOnSpot") then
                                        if Distance2(v:FindFirstChildWhichIsA("BasePart").Position) <= 20 then
                                            local Pro = v:FindFirstChild("HidePrompt", true)
                                            if Pro and Pro.Enabled == true then
                                                fireproximityprompt(Pro)
                                            end
                                        end
                                    end
                                end
                            end
                        elseif distance > distanceCloset + 10 then
                            if char:GetAttribute("Hiding") then
                                Storage:WaitForChild("RemotesFolder"):WaitForChild("CamLock"):FireServer()
                            end
                        end
                    end
                end
                task.wait()
            end
        end
    })
end

if isMines then
    Automation:AddToggle("Auto Mines Anchor", {
        Text = "Auto Mines Anchor",
        Default = false,
        Callback = function(Value)
            _G.MinesAnchorOh = Value
            while _G.MinesAnchorOh do
                if _G.AddedGet then
                    if MainUi:FindFirstChild("AnchorHintFrame") and MainUi.AnchorHintFrame:FindFirstChild("Code") then
                        for i, v in pairs(_G.AddedGet) do
                            if v.Name == "MinesAnchor" and v:FindFirstChild("AnchorRemote") and Distance(v:GetPivot().Position) <= 15 then
                                v.AnchorRemote:InvokeServer(MainUi.AnchorHintFrame.Code.Text)
                            end
                        end
                    end
                end
                task.wait()
            end
        end
    })
end

if isHotel then
    Automation:AddToggle("Auto Get Code Library", {
        Text = "Auto Get Code Library",
        Default = false,
        Callback = function(Value)
            _G.NotifyEntity = Value
            if _G.NotifyEntity then
                local function CodeAll(v)
                    if v:IsA("Tool") and v.Name == "LibraryHintPaper" then
                        code = table.concat(Deciphercode(v))
                        if code then
                            Notification({title = "Starlight", content = "Code: "..code, duration = 15, icon = "82357489459031"})
                            if _G.NotifyEntityChat then
                                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("Library Code: "..code)
                            end
                            if _G.AutoUnlockPadlock then
                                game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("PL"):FireServer(code)
                            end
                        end
                    end
                end
                Getpaper = char.ChildAdded:Connect(function(v)
                    CodeAll(v)
                end)
            else
                if Getpaper then
                    Getpaper:Disconnect()
                    Getpaper = nil
                end
            end
        end
    })

    Automation:AddToggle("Auto Unlock Padlock", {
        Text = "Auto Unlock Padlock",
        Default = false,
        Callback = function(Value)
            _G.AutoUnlockPadlock = Value
        end
    })
end

Automation:AddDropdown("Auto Loot type", {
    Text = "No Loot",
    Multi = true,
    Values = {"Unlock Lockpick", "Jeff Shop", "Gold", "Light Items", "Skull Prompt"}
})

_G.Aura = {
    ["AuraPrompt"] = {
        "ActivateEventPrompt",
        "HerbPrompt",
        "LootPrompt",
        "SkullPrompt",
        "ValvePrompt",
        "LongPushPrompt",
        "LeverPrompt",
        "FusesPrompt",
        "UnlockPrompt",
        "AwesomePrompt",
        "ModulePrompt",
        "PartyDoorPrompt",
    },
    ["AutoLootInteractions"] = {
        "ActivateEventPrompt",
        "HerbPrompt",
        "LootPrompt",
        "SkullPrompt",
        "ValvePrompt"
    },
    ["AutoLootNotInter"] = {
        "LongPushPrompt",
        "LeverPrompt",
        "FusesPrompt",
        "UnlockPrompt",
        "AwesomePrompt",
        "ModulePrompt",
        "PartyDoorPrompt",
    }
}

Automation:AddToggle("Auto Loot", {
    Text = "Auto Loot",
    Default = false,
    Callback = function(Value)
        _G.AutoLoot = Value
        while _G.AutoLoot do
            for i, v in pairs(_G.AddedGet) do
                if v:IsA("ProximityPrompt") and v.Enabled == true then
                    if Distance(v.Parent:GetPivot().Position) <= 12 then
                        if Options["Auto Loot type"].Value["Unlock Lockpick"] and (v.Name == "UnlockPrompt" or v.Parent:GetAttribute("Locked")) and char:FindFirstChild("Lockpick") then continue end
                        if Options["Auto Loot type"].Value["Gold"] and v.Name == "LootPrompt" then continue end
                        if Options["Auto Loot type"].Value["Light Items"] and v.Parent:GetAttribute("Tool_LightSource") and not v.Parent:GetAttribute("Tool_CanCutVines") then continue end
                        if Options["Auto Loot type"].Value["Skull Prompt"] and v.Name == "SkullPrompt" then continue end
                        if Options["Auto Loot type"].Value["Jeff Shop"] and v.Parent:GetAttribute("JeffShop") then continue end
                        
                        if v.Parent:GetAttribute("PropType") == "Battery" and ((char:FindFirstChildOfClass("Tool") and char:FindFirstChildOfClass("Tool"):GetAttribute("RechargeProp") ~= "Battery") or char:FindFirstChildOfClass("Tool") == nil) then continue end 
                        if v.Parent:GetAttribute("PropType") == "Heal" and char:FindFirstChild("Humanoid") and char.Humanoid.Health == char.Humanoid.MaxHealth then continue end
                        if v.Parent.Name == "MinesAnchor" then continue end
                        
                        if table.find(_G.Aura["AutoLootNotInter"], v.Name) then
                            fireproximityprompt(v)
                        end
                        if table.find(_G.Aura["AutoLootInteractions"], v.Name) and not v:GetAttribute("Interactions"..game.Players.LocalPlayer.Name) then
                            fireproximityprompt(v)
                        end
                    end
                end
            end
            task.wait()
        end
    end
}):AddKeyPicker("AutoLootKey", {
    Default = "R",
    Text = "Auto Loot",
    Mode = "Toggle",
    SyncToggleState = true
})

local Automation2 = Tabs.Automation:AddRightGroupbox("Utilities")

local anticheatManipEnabled = false
local anticheatManipLoop = nil
local isAnticheatKeyHeld = false
local anticheatManipKey = Enum.KeyCode.U

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == anticheatManipKey and not gameProcessed then
        isAnticheatKeyHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == anticheatManipKey then
        isAnticheatKeyHeld = false
    end
end)

Automation2:AddToggle("Anticheat Manipulation", {
    Text = "Anticheat Manipulation",
    Default = false,
    Callback = function(Value)
        _G.AntiCheatBruh = Value
        anticheatManipEnabled = Value
        
        if anticheatManipEnabled then
            anticheatManipLoop = task.spawn(function()
                while anticheatManipEnabled do
                    task.wait(0.00001)
                    if isAnticheatKeyHeld and player.Character then
                        player.Character:PivotTo(player.Character:GetPivot() + workspace.CurrentCamera.CFrame.LookVector * 10)
                    end
                end
            end)
        else
            if anticheatManipLoop then
                task.cancel(anticheatManipLoop)
                anticheatManipLoop = nil
            end
        end
    end
}):AddKeyPicker("AnticheatManipulationKey", {
    Default = "U",
    Text = "Anticheat Manipulation",
    Mode = "Toggle",
    SyncToggleState = true
})

if isHotel then
    Automation2:AddButton({
        Text = "Instant Cube Glitch",
        Func = function()
            LoadingInstant = true
            spawn(function()
                Toggles["Bypass Speed"]:SetValue(false)
                wait(0.3)
                repeat task.wait() until not LoadingInstant
                wait(0.5)
                Toggles["Bypass Speed"]:SetValue(true)
            end)
            local OldCollision = char:FindFirstChild("CollisionPart").CFrame 
            for i = 1, 6 do
                repeat task.wait()
                    if root and root.Position.Y > -5 and char:FindFirstChild("CollisionPart") then
                        char:FindFirstChild("CollisionPart").CFrame = OldCollision * CFrame.new(0, 90, 0)
                    end
                until cam and cam:FindFirstChild("Glitch")
                wait(0.3)
                repeat task.wait() until cam and not cam:FindFirstChild("Glitch")
                wait(0.4)
                Notification({title = "Starlight", content = "Glitch times "..i.." / 6", duration = 3, icon = "82357489459031"})
            end
            wait(0.7)
            local Cube = workspace:FindFirstChild("GlitchCube", true)
            if not Cube then
                Notification({title = "Starlight", content = "You can go find it.", duration = 5, icon = "82357489459031"})
            end
            Notification({title = "Starlight", content = "Oh look! Glitch Cube spawn here", duration = 5, icon = "82357489459031"})
            LoadingInstant = false
        end
    })
end

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau"))()
ESPLibrary.GlobalConfig.Tracers = false
ESPLibrary.GlobalConfig.Arrows = false

local ESPGlobalSettings = {
    ESPType = "Highlight",
    TextSize = 14,
    FillTransparency = 0.7,
    OutlineTransparency = 0.4,
    TracerEnabled = false,
    ArrowEnabled = false,
    Rainbow = false
}

local DoorESPObjects = {}
local LadderESPObjects = {}
local TaskESPObjects = {}
local HidingSpotESPObjects = {}
local ChestESPObjects = {}
local PlayerESPObjects = {}
local GoldESPObjects = {}
local ItemsESPObjects = {}
local StardustESPObjects = {}
local EntityESPObjects = {}

local DoorColor = Color3.fromRGB(100, 150, 255)
local LadderColor = Color3.new(1, 1, 1)
local TaskColor = Color3.new(0, 1, 1)
local HidingSpotColor = Color3.new(0, 0.5, 0)
local ChestColor = Color3.new(1, 1, 0)
local PlayerColor = Color3.new(1, 1, 1)
local GoldColor = Color3.new(1, 0.8, 0)
local ItemsColor = Color3.new(1, 0, 1)
local StardustColor = Color3.new(1, 0.5, 0.8)
local BookColor = Color3.new(1, 0.5, 0)
local BreakerColor = Color3.new(0, 0, 1)
local FuseColor = Color3.new(1, 1, 0)

local EntityData = {
    ["RushMoving"] = {
        Name = "Rush",
        Color = Color3.fromRGB(89, 102, 115)
    },
    ["BackdoorRush"] = {
        Name = "Blitz",
        Color = Color3.fromRGB(0, 175, 80)
    },
    ["AmbushMoving"] = {
        Name = "Ambush",
        Color = Color3.fromRGB(80, 255, 110)
    },
    ["A60"] = {
        Name = "A-60",
        Color = Color3.fromRGB(200, 50, 50)
    },
    ["A120"] = {
        Name = "A-120",
        Color = Color3.fromRGB(55, 55, 55)
    },
    ["Eyes"] = {
        Name = "Eyes",
        Color = Color3.fromRGB(127, 30, 220)
    },
    ["BackdoorLookman"] = {
        Name = "Lookman",
        Color = Color3.fromRGB(110, 15, 15)
    },
    ["Dread"] = {
        Name = "Dread",
        Color = Color3.fromRGB(102, 102, 102)
    },
    ["CustomEntity"] = {
        Name = "Custom Rush",
        Color = Color3.fromRGB(128, 140, 153)
    },
    ["FigureRig"] = {
        Name = "Figure",
        Color = Color3.fromRGB(191, 0, 0)
    },
    ["GrumbleRig"] = {
        Name = "Grumble",
        Color = Color3.fromRGB(217, 217, 217)
    },
    ["GlitchRush"] = {
        Name = "GlitchRush",
        Color = Color3.new(1, 0, 0)
    },
    ["GlitchAmbush"] = {
        Name = "GlitchAmbush",
        Color = Color3.new(1, 0, 0)
    },
    ["Groundskeeper"] = {
        Name = "Groundskeeper",
        Color = Color3.new(1, 0, 0)
    },
    ["MonumentEntity"] = {
        Name = "Monument",
        Color = Color3.new(1, 0, 0)
    },
    ["FigureRagdoll"] = {
        Name = "Figure",
        Color = Color3.fromRGB(191, 0, 0)
    },
    ["LiveEntityBramble"] = {
        Name = "Bramble",
        Color = Color3.new(1, 0, 0)
    }
}

local Item = {
    Flashlight = "Flashlight",
    Lockpick = "Lockpick",
    Lighter = "Lighter",
    Vitamins = "Vitamins",
    Bandage = "Bandage",
    StarVial = "Star Vial",
    StarBottle = "Star Bottle",
    StarJug = "Star Jug",
    Shakelight = "Shakelight",
    Straplight = "Straplight",
    Bulklight = "Bulklight",
    Battery = "Battery",
    Candle = "Candle",
    Crucifix = "Crucifix",
    CrucifixWall = "Crucifix",
    Glowsticks = "Glowsticks",
    SkeletonKey = "Skeleton Key",
    Candy = "Candy",
    ShieldMini = "Mini Shield",
    ShieldBig = "Big Shield",
    BandagePack = "Bandage Pack",
    BatteryPack = "Battery Pack",
    RiftCandle = "Rift Candle",
    LaserPointer = "Laser Pointer",
    HolyGrenade = "Holy Grenade",
    Shears = "Shears",
    Smoothie = "Smoothie",
    Cheese = "Cheese",
    Bread = "Bread",
    AlarmClock = "Alarm Clock",
    RiftSmoothie = "Rift Smoothie",
    GweenSoda = "Gween Soda",
    GlitchCube = "Glitch Cube",
    RiftJar = "Rift Jar",
    Compass = "Compass",
    Lantern = "Lantern",
    Multitool = "Multitool",
    Lotus = "Lotus",
    TipJar = "Tip Jar",
    LotusPetalPickup = "Lotus Petal",
    KeyIron = "Iron Key",
    CandyBag = "Candy Bag",
    Donut = "Donut"
}

local HidingSpots = {
    Wardrobe = "Wardrobe",
    Rooms_Locker = "Wardrobe",
    Backdoor_Wardrobe = "Wardrobe",
    Toolshed = "Wardrobe",
    Locker_Large = "Wardrobe",
    Bed = "Bed",
    CircularVent = "Vent",
    Rooms_Locker_Fridge = "Fridge",
    RetroWardrobe = "Wardrobe",
    Dumpster = "Dumpster",
    Double_Bed = "Bed"
}

local function shouldShowDoorESP(roomNumber)
    local currentRoom = player:GetAttribute("CurrentRoom")
    if not currentRoom then return false end
    return roomNumber == currentRoom or roomNumber == currentRoom + 1
end

local function getDoorState(doorModel)
    local isOpen = false
    local isLocked = false
    
    local doorPart = doorModel
    if doorModel:IsA("Model") then
        doorPart = doorModel:FindFirstChildWhichIsA("BasePart")
    end
    
    if doorPart then
        isOpen = not doorPart.Anchored
    end
    
    if not isOpen then
        if doorModel.Parent and doorModel.Parent:FindFirstChild("Lock") then
            isLocked = true
        end
    end
    
    return isOpen, isLocked
end

local function AddDoorESP(door, roomNumber)
    if not door or not door.Parent then return end
    local model = door
    if door:IsA("BasePart") and door.Parent and door.Parent:IsA("Model") then
        model = door.Parent
    end
    if door.Name == "Door" and door.Parent and door.Parent.Name == "Door" then
        model = door
    end
    
    if DoorESPObjects[model] then
        DoorESPObjects[model]:Hide()
    end
    
    local floorBase = 0
    local currentFloor = player:GetAttribute("Floor")
    if currentFloor then
        floorBase = (currentFloor - 1) * 1000
    end
    
    local doorNumber = floorBase + roomNumber + 1
    local roomNumberStr = ""
    
    if model.Parent and model.Parent:FindFirstChild("Sign") then
        local sign = model.Parent.Sign
        if sign:FindFirstChild("Stinker") then
            roomNumberStr = sign.Stinker.Text
        elseif sign:FindFirstChild("SignText") then
            roomNumberStr = sign.SignText.Text
        end
    end
    
    roomNumberStr = roomNumberStr:gsub("^0+", "")
    if roomNumberStr == "" then
        roomNumberStr = tostring(doorNumber)
    end
    
    local opened, locked = getDoorState(model)
    local displayText = "Door " .. roomNumberStr
    
    if locked and not opened then
        displayText = displayText .. " [Locked]"
    elseif opened then
        displayText = displayText .. " [Open]"
    end
    
    local espObject = ESPLibrary:Add({
        Name = displayText,
        Model = model,
        Color = DoorColor,
        MaxDistance = 1000,
        TextSize = ESPGlobalSettings.TextSize,
        ESPType = ESPGlobalSettings.ESPType,
        FillColor = DoorColor,
        OutlineColor = DoorColor,
        FillTransparency = ESPGlobalSettings.FillTransparency,
        OutlineTransparency = ESPGlobalSettings.OutlineTransparency,
        Tracer = { 
            Enabled = ESPGlobalSettings.TracerEnabled,
            Color = DoorColor,
            From = "Bottom"
        },
        Arrow = {
            Enabled = ESPGlobalSettings.ArrowEnabled,
            Color = DoorColor
        }
    })
    
    DoorESPObjects[model] = espObject
    espObject:Show()
end

local function AddLadderESP(ladder)
    if not ladder or not ladder.Parent then return end
    local espObject = ESPLibrary:Add({
        Name = "Ladder",
        Model = ladder,
        Color = LadderColor,
        MaxDistance = 1000,
        TextSize = ESPGlobalSettings.TextSize,
        ESPType = ESPGlobalSettings.ESPType,
        FillColor = LadderColor,
        OutlineColor = LadderColor,
        FillTransparency = ESPGlobalSettings.FillTransparency,
        OutlineTransparency = ESPGlobalSettings.OutlineTransparency,
        Tracer = { 
            Enabled = ESPGlobalSettings.TracerEnabled,
            Color = LadderColor,
            From = "Bottom"
        },
        Arrow = {
            Enabled = ESPGlobalSettings.ArrowEnabled,
            Color = LadderColor
        }
    })
    LadderESPObjects[ladder] = espObject
    espObject:Show()
end

local function AddTaskESP(item, text, color)
    if not item or not item.Parent then return end
    local model = item
    if item:IsA("BasePart") and item.Parent and item.Parent:IsA("Model") then
        model = item.Parent
    end
    
    if TaskESPObjects[model] then
        TaskESPObjects[model]:Hide()
    end
    
    local taskColor = color or TaskColor
    
    local espObject = ESPLibrary:Add({
        Name = text,
        Model = model,
        Color = taskColor,
        MaxDistance = 1000,
        TextSize = ESPGlobalSettings.TextSize,
        ESPType = ESPGlobalSettings.ESPType,
        FillColor = taskColor,
        OutlineColor = taskColor,
        FillTransparency = ESPGlobalSettings.FillTransparency,
        OutlineTransparency = ESPGlobalSettings.OutlineTransparency,
        Tracer = { 
            Enabled = ESPGlobalSettings.TracerEnabled,
            Color = taskColor,
            From = "Bottom"
        },
        Arrow = {
            Enabled = ESPGlobalSettings.ArrowEnabled,
            Color = taskColor
        }
    })
    
    TaskESPObjects[model] = espObject
    espObject:Show()
end

local function AddHidingSpotESP(model, text)
    if not model or not model.Parent then return end
    local espObject = ESPLibrary:Add({
        Name = text,
        Model = model,
        Color = HidingSpotColor,
        MaxDistance = 1000,
        TextSize = ESPGlobalSettings.TextSize,
        ESPType = ESPGlobalSettings.ESPType,
        FillColor = HidingSpotColor,
        OutlineColor = HidingSpotColor,
        FillTransparency = 0.7,
        OutlineTransparency = 0.4,
        Tracer = { 
            Enabled = ESPGlobalSettings.TracerEnabled,
            Color = HidingSpotColor,
            From = "Bottom"
        },
        Arrow = {
            Enabled = ESPGlobalSettings.ArrowEnabled,
            Color = HidingSpotColor
        }
    })
    HidingSpotESPObjects[model] = espObject
    espObject:Show()
end

local function AddChestESP(model, text)
    if not model or not model.Parent then return end
    local espObject = ESPLibrary:Add({
        Name = text,
        Model = model,
        Color = ChestColor,
        MaxDistance = 1000,
        TextSize = ESPGlobalSettings.TextSize,
        ESPType = ESPGlobalSettings.ESPType,
        FillColor = ChestColor,
        OutlineColor = ChestColor,
        FillTransparency = ESPGlobalSettings.FillTransparency,
        OutlineTransparency = ESPGlobalSettings.OutlineTransparency,
        Tracer = { 
            Enabled = ESPGlobalSettings.TracerEnabled,
            Color = ChestColor,
            From = "Bottom"
        },
        Arrow = {
            Enabled = ESPGlobalSettings.ArrowEnabled,
            Color = ChestColor
        }
    })
    ChestESPObjects[model] = espObject
    espObject:Show()
end

local function AddPlayerESP(player, character)
    if not character or not character.Parent then return end
    local displayName = player.DisplayName or player.Name
    local espObject = ESPLibrary:Add({
        Name = displayName,
        Model = character,
        Color = PlayerColor,
        MaxDistance = 1000,
        TextSize = ESPGlobalSettings.TextSize,
        ESPType = ESPGlobalSettings.ESPType,
        FillColor = PlayerColor,
        OutlineColor = PlayerColor,
        FillTransparency = ESPGlobalSettings.FillTransparency,
        OutlineTransparency = ESPGlobalSettings.OutlineTransparency,
        Tracer = { 
            Enabled = ESPGlobalSettings.TracerEnabled,
            Color = PlayerColor,
            From = "Bottom"
        },
        Arrow = {
            Enabled = ESPGlobalSettings.ArrowEnabled,
            Color = PlayerColor
        }
    })
    PlayerESPObjects[character] = {
        Object = espObject,
        Player = player
    }
    espObject:Show()
end

local function AddGoldESP(goldPile)
    if not goldPile or not goldPile.Parent then return end
    local goldValue = goldPile:GetAttribute("GoldValue") or 0
    local displayText = "Gold [" .. goldValue .. "]"
    local espObject = ESPLibrary:Add({
        Name = displayText,
        Model = goldPile,
        Color = GoldColor,
        MaxDistance = 1000,
        TextSize = ESPGlobalSettings.TextSize,
        ESPType = ESPGlobalSettings.ESPType,
        FillColor = GoldColor,
        OutlineColor = GoldColor,
        FillTransparency = ESPGlobalSettings.FillTransparency,
        OutlineTransparency = ESPGlobalSettings.OutlineTransparency,
        Tracer = { 
            Enabled = ESPGlobalSettings.TracerEnabled,
            Color = GoldColor,
            From = "Bottom"
        },
        Arrow = {
            Enabled = ESPGlobalSettings.ArrowEnabled,
            Color = GoldColor
        }
    })
    GoldESPObjects[goldPile] = espObject
    espObject:Show()
end

local function isPlayerOwnedItem(instance)
    local current = instance
    while current and current ~= Workspace do
        if current:IsA("Model") then
            local player = Players:GetPlayerFromCharacter(current)
            if player and player == LocalPlayer then
                return true
            end
            if current:IsA("Tool") then
                local owner = current:FindFirstChild("Owner")
                if owner and owner.Value then
                    return true
                end
                local parent = current.Parent
                if parent and (parent:IsA("Backpack") or (parent:IsA("Model") and Players:GetPlayerFromCharacter(parent))) then
                    return true
                end
            end
        end
        current = current.Parent
    end
    return false
end

local function AddItemESP(item, text)
    if not item or not item.Parent then return end
    if isPlayerOwnedItem(item) then
        return
    end
    
    local model = item
    if item:IsA("BasePart") and item.Parent and item.Parent:IsA("Model") then
        model = item.Parent
    end
    
    if isPlayerOwnedItem(model) then
        return
    end
    
    if ItemsESPObjects[model] then
        ItemsESPObjects[model]:Hide()
    end
    
    local espObject = ESPLibrary:Add({
        Name = text,
        Model = model,
        Color = ItemsColor,
        MaxDistance = 1000,
        TextSize = ESPGlobalSettings.TextSize,
        ESPType = ESPGlobalSettings.ESPType,
        FillColor = ItemsColor,
        OutlineColor = ItemsColor,
        FillTransparency = ESPGlobalSettings.FillTransparency,
        OutlineTransparency = ESPGlobalSettings.OutlineTransparency,
        Tracer = { 
            Enabled = ESPGlobalSettings.TracerEnabled,
            Color = ItemsColor,
            From = "Bottom"
        },
        Arrow = {
            Enabled = ESPGlobalSettings.ArrowEnabled,
            Color = ItemsColor
        }
    })
    
    ItemsESPObjects[model] = espObject
    espObject:Show()
end

local function AddStardustESP(stardust)
    if not stardust or not stardust.Parent then return end
    local espObject = ESPLibrary:Add({
        Name = "Stardust",
        Model = stardust,
        Color = StardustColor,
        MaxDistance = 1000,
        TextSize = ESPGlobalSettings.TextSize,
        ESPType = ESPGlobalSettings.ESPType,
        FillColor = StardustColor,
        OutlineColor = StardustColor,
        FillTransparency = ESPGlobalSettings.FillTransparency,
        OutlineTransparency = ESPGlobalSettings.OutlineTransparency,
        Tracer = { 
            Enabled = ESPGlobalSettings.TracerEnabled,
            Color = StardustColor,
            From = "Bottom"
        },
        Arrow = {
            Enabled = ESPGlobalSettings.ArrowEnabled,
            Color = StardustColor
        }
    })
    StardustESPObjects[stardust] = espObject
    espObject:Show()
end

local function addEntityESP(entity)
    if not entity or not entity.Parent then return end
    
    local entityInfo = EntityData[entity.Name]
    if not entityInfo then
        entityInfo = {
            Name = entity.Name,
            Color = Color3.new(1, 0, 0)
        }
    end
    
    local base = entity.PrimaryPart
    if not base then
        base = entity:FindFirstChildWhichIsA("BasePart")
        if not base then return end
    end
    
    if not entity:FindFirstChildOfClass("Humanoid") then
        local humanoid = Instance.new("Humanoid")
        humanoid.Name = "ESP_Humanoid"
        humanoid.Parent = entity
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
    
    base.Transparency = 0.99
    
    local espObject = ESPLibrary:Add({
        Name = entityInfo.Name,
        Model = entity,
        Color = entityInfo.Color,
        MaxDistance = 1000,
        TextSize = ESPGlobalSettings.TextSize,
        ESPType = "Highlight",
        FillColor = entityInfo.Color,
        OutlineColor = entityInfo.Color,
        FillTransparency = ESPGlobalSettings.FillTransparency,
        OutlineTransparency = ESPGlobalSettings.OutlineTransparency,
        Tracer = { 
            Enabled = ESPGlobalSettings.TracerEnabled,
            Color = entityInfo.Color,
            From = "Bottom"
        },
        Arrow = {
            Enabled = ESPGlobalSettings.ArrowEnabled,
            Color = entityInfo.Color
        }
    })
    
    EntityESPObjects[entity] = espObject
    espObject:Show()
end

local function scanDoors()
    if not ESPController.Enabled.Door then return end
    for _, room in ipairs(Workspace.CurrentRooms:GetChildren()) do
        local roomNumber = tonumber(room.Name)
        if roomNumber and shouldShowDoorESP(roomNumber) then
            if room:FindFirstChild("Door") and room.Door:FindFirstChild("Door") then
                local door = room.Door.Door
                AddDoorESP(door, roomNumber)
            end
        end
    end
end

local function scanLadders()
    if not ESPController.Enabled.Ladder then return end
    for _, room in ipairs(Workspace.CurrentRooms:GetChildren()) do
        local roomNumber = tonumber(room.Name)
        if roomNumber then
            for _, ladder in ipairs(room:GetDescendants()) do
                if ladder.Name == "Ladder" and ladder:IsA("Model") then
                    AddLadderESP(ladder)
                end
            end
        end
    end
end

local function scanTasks()
    if not ESPController.Enabled.Task then return end
    local currentRoom = player:GetAttribute("CurrentRoom")
    if not currentRoom then return end
    
    local roomsToCheck = {currentRoom, currentRoom + 1}
    for _, roomNumber in ipairs(roomsToCheck) do
        local room = Workspace.CurrentRooms:FindFirstChild(tostring(roomNumber))
        if room then
            local key = room:FindFirstChild("KeyObtain", true)
            if key and not key:GetAttribute("Used") then
                AddTaskESP(key, "Key")
            end
            
            for _, fuse in ipairs(room:GetDescendants()) do
                if fuse.Name == "FuseObtain" and fuse.Parent and fuse.Parent.Name == "FuseHolder" then
                    AddTaskESP(fuse, "Fuse", FuseColor)
                end
            end
            
            if roomNumber == currentRoom then
                for _, book in ipairs(room:GetDescendants()) do
                    if book.Name == "LiveHintBook" then
                        AddTaskESP(book, "Book", BookColor)
                    end
                end
            end
            
            if roomNumber == currentRoom then
                for _, breaker in ipairs(room:GetDescendants()) do
                    if breaker.Name == "LiveBreakerPolePickup" then
                        AddTaskESP(breaker, "Breaker", BreakerColor)
                    end
                end
            end
            
            for _, anchor in ipairs(room:GetDescendants()) do
                if anchor.Name == "MinesAnchor" and anchor:FindFirstChild("Sign") then
                    AddTaskESP(anchor, "Anchor " .. anchor.Sign.TextLabel.Text)
                end
            end
            
            for _, generator in ipairs(room:GetDescendants()) do
                if generator.Name == "GeneratorMain" then
                    AddTaskESP(generator, "Generator")
                end
            end
            
            if roomNumber == currentRoom then
                for _, button in ipairs(room:GetDescendants()) do
                    if button.Name == "MinesGateButton" then
                        AddTaskESP(button, "Gate Button")
                    end
                end
            end
            
            for _, pump in ipairs(room:GetDescendants()) do
                if pump.Name == "WaterPump" then
                    AddTaskESP(pump, "Water Pump")
                end
            end
            
            local timerLever = room:FindFirstChild("TimerLever", true)
            if timerLever and timerLever.Name == "TimerLever" then
                AddTaskESP(timerLever, "Timer Lever")
            end
            
            for _, lever in ipairs(room:GetDescendants()) do
                if lever.Name == "LeverForGate" then
                    AddTaskESP(lever, "Gate Lever")
                end
            end
        end
    end
end

local function scanHidingSpots()
    if not ESPController.Enabled.HidingSpot then return end
    for _, room in ipairs(Workspace.CurrentRooms:GetChildren()) do
        local roomNumber = tonumber(room.Name)
        if roomNumber then
            local assets = room:FindFirstChild("Assets")
            if assets then
                for _, spot in ipairs(assets:GetChildren()) do
                    local spotName = HidingSpots[spot.Name]
                    if spotName and spot.PrimaryPart then
                        AddHidingSpotESP(spot, spotName)
                    end
                end
            end
        end
    end
end

local function scanChests()
    if not ESPController.Enabled.Chest then return end
    for _, room in ipairs(Workspace.CurrentRooms:GetChildren()) do
        local roomNumber = tonumber(room.Name)
        if roomNumber then
            for _, v in ipairs(room:GetDescendants()) do
                if v.Name == "Toolshed_Small" or v.Name == "Chest_Vine" or 
                   v.Name == "ChestBoxLocked" or v.Name == "ChestBox" then
                    local displayText = "Chest"
                    if v.Name == "Chest_Vine" then
                        displayText = "[Vine] Chest"
                    elseif v.Name == "ChestBoxLocked" then
                        displayText = "[Locked] Chest"
                    elseif v.Name == "Toolshed_Small" then
                        displayText = "Shears Cabinet"
                    end
                    AddChestESP(v, displayText)
                end
            end
        end
    end
end

local function scanPlayers()
    if not ESPController.Enabled.Player then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            AddPlayerESP(player, player.Character)
        end
    end
end

local function scanGold()
    if not ESPController.Enabled.Gold then return end
    for _, room in ipairs(Workspace.CurrentRooms:GetChildren()) do
        local roomNumber = tonumber(room.Name)
        if roomNumber then
            for _, goldPile in ipairs(room:GetDescendants()) do
                if goldPile.Name == "GoldPile" then
                    AddGoldESP(goldPile)
                end
            end
        end
    end
end

local function scanItems()
    if not ESPController.Enabled.Item then return end
    for _, room in ipairs(Workspace.CurrentRooms:GetChildren()) do
        local roomNumber = tonumber(room.Name)
        if roomNumber then
            for _, v in ipairs(room:GetDescendants()) do
                local itemName = Item[v.Name]
                if itemName and v:IsA("Model") and v.PrimaryPart then
                    AddItemESP(v, itemName)
                end
            end
        end
    end
    
    local dropsFolder = Workspace:FindFirstChild("Drops")
    if dropsFolder then
        for _, drop in ipairs(dropsFolder:GetChildren()) do
            local itemName = Item[drop.Name]
            if itemName and drop:IsA("Model") and drop.PrimaryPart then
                AddItemESP(drop, itemName)
            end
        end
    end
end

local function scanStardust()
    if not ESPController.Enabled.Stardust then return end
    for _, room in ipairs(Workspace.CurrentRooms:GetChildren()) do
        local roomNumber = tonumber(room.Name)
        if roomNumber then
            for _, stardust in ipairs(room:GetDescendants()) do
                if stardust.Name == "StardustPickup" then
                    AddStardustESP(stardust)
                end
            end
        end
    end
end

local function scanEntities()
    if not ESPController.Enabled.Entity then return end
    for _, entity in ipairs(Workspace:GetChildren()) do
        if EntityData[entity.Name] then
            addEntityESP(entity)
        end
    end
    
    local currentRoom = player:GetAttribute("CurrentRoom")
    if currentRoom then
        local room = Workspace.CurrentRooms:FindFirstChild(tostring(currentRoom))
        if room then
            local groundskeeper = room:FindFirstChild("Groundskeeper", true)
            if groundskeeper then
                addEntityESP(groundskeeper)
            end
            
            local figure = room:FindFirstChild("FigureRig", true) or room:FindFirstChild("FigureRagdoll", true)
            if figure then
                addEntityESP(figure)
            end
            
            local bramble = room:FindFirstChild("LiveEntityBramble", true)
            if bramble then
                addEntityESP(bramble)
            end
            
            for _, descendant in ipairs(room:GetDescendants()) do
                if EntityData[descendant.Name] then
                    addEntityESP(descendant)
                end
            end
        end
    end
    
    for _, room in ipairs(Workspace.CurrentRooms:GetChildren()) do
        for _, descendant in ipairs(room:GetDescendants()) do
            if EntityData[descendant.Name] and not EntityESPObjects[descendant] then
                addEntityESP(descendant)
            end
        end
    end
end

local function clearESPType(espObjects)
    for _, obj in pairs(espObjects) do
        if obj and obj.Destroy then
            pcall(function() obj:Destroy() end)
        end
    end
    return {}
end

local function updateDoorESP()
    if not ESPController.Enabled.Door then return end
    for _, room in ipairs(Workspace.CurrentRooms:GetChildren()) do
        local roomNumber = tonumber(room.Name)
        if roomNumber and shouldShowDoorESP(roomNumber) then
            if room:FindFirstChild("Door") and room.Door:FindFirstChild("Door") then
                local door = room.Door.Door
                
                local model = door
                if door:IsA("BasePart") and door.Parent and door.Parent:IsA("Model") then
                    model = door.Parent
                end
                if door.Name == "Door" and door.Parent and door.Parent.Name == "Door" then
                    model = door
                end
                
                if not model then return end
                
                local floorBase = 0
                local currentFloor = player:GetAttribute("Floor")
                if currentFloor then
                    floorBase = (currentFloor - 1) * 1000
                end
                
                local doorNumber = floorBase + roomNumber + 1
                local roomNumberStr = ""
                
                if model.Parent and model.Parent:FindFirstChild("Sign") then
                    local sign = model.Parent.Sign
                    if sign:FindFirstChild("Stinker") then
                        roomNumberStr = sign.Stinker.Text
                    elseif sign:FindFirstChild("SignText") then
                        roomNumberStr = sign.SignText.Text
                    end
                end
                
                roomNumberStr = roomNumberStr:gsub("^0+", "")
                if roomNumberStr == "" then
                    roomNumberStr = tostring(doorNumber)
                end
                
                local opened, locked = getDoorState(model)
                local displayText = "Door " .. roomNumberStr
                
                if locked and not opened then
                    displayText = displayText .. " [Locked]"
                elseif opened then
                    displayText = displayText .. " [Open]"
                end
                
                if DoorESPObjects[model] then
                    DoorESPObjects[model].CurrentSettings.Name = displayText
                    if DoorESPObjects[model].GUI and DoorESPObjects[model].GUI.Txt then
                        DoorESPObjects[model].GUI.Txt.Text = displayText
                    end
                else
                    AddDoorESP(door, roomNumber)
                end
            end
        end
    end
end

local function updatePlayerESP()
    if not ESPController.Enabled.Player then return end
    for character, data in pairs(PlayerESPObjects) do
        if data.Object and data.Object.CurrentSettings then
            if not data.Player or not data.Player.Parent or not character or not character.Parent then
                data.Object:Destroy()
                PlayerESPObjects[character] = nil
            else
                data.Object.CurrentSettings.TextSize = ESPGlobalSettings.TextSize
                data.Object.CurrentSettings.FillTransparency = ESPGlobalSettings.FillTransparency
                data.Object.CurrentSettings.OutlineTransparency = ESPGlobalSettings.OutlineTransparency
                data.Object.CurrentSettings.Tracer.Enabled = ESPGlobalSettings.TracerEnabled
                data.Object.CurrentSettings.Tracer.Color = PlayerColor
                
                local displayName = data.Player.DisplayName or data.Player.Name
                if data.Object.CurrentSettings.Name ~= displayName then
                    data.Object.CurrentSettings.Name = displayName
                    if data.Object.GUI and data.Object.GUI.Txt then
                        data.Object.GUI.Txt.Text = displayName
                    end
                end
                
                data.Object:Hide()
                data.Object:Show()
            end
        end
    end
end

local ESPController = {
    Enabled = {
        Door = false,
        Ladder = false,
        Task = false,
        HidingSpot = false,
        Chest = false,
        Player = false,
        Gold = false,
        Item = false,
        Stardust = false,
        Entity = false
    }
}

local function initializeESP()
    scanDoors()
    scanLadders()
    scanTasks()
    scanHidingSpots()
    scanChests()
    scanPlayers()
    scanGold()
    scanItems()
    scanStardust()
    scanEntities()
    
    player:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
        if ESPController.Enabled.Door then
            DoorESPObjects = clearESPType(DoorESPObjects)
            scanDoors()
        end
        if ESPController.Enabled.Task then
            TaskESPObjects = clearESPType(TaskESPObjects)
            scanTasks()
        end
    end)
    
    player:GetAttributeChangedSignal("Floor"):Connect(function()
        if ESPController.Enabled.Door then
            DoorESPObjects = clearESPType(DoorESPObjects)
            scanDoors()
        end
    end)
    
    Players.PlayerAdded:Connect(function(p)
        if ESPController.Enabled.Player then
            p.CharacterAdded:Connect(function(character)
                AddPlayerESP(p, character)
            end)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(p)
        if ESPController.Enabled.Player then
            if p.Character then
                if PlayerESPObjects[p.Character] then
                    PlayerESPObjects[p.Character].Object:Destroy()
                    PlayerESPObjects[p.Character] = nil
                end
            end
        end
    end)
    
    Workspace.ChildAdded:Connect(function(v)
        if ESPController.Enabled.Entity then
            if EntityData[v.Name] then
                task.wait(0.5)
                addEntityESP(v)
            end
        end
    end)
    
    Workspace.ChildRemoved:Connect(function(v)
        if EntityESPObjects[v] then
            EntityESPObjects[v]:Destroy()
            EntityESPObjects[v] = nil
        end
    end)
    
    Workspace.DescendantAdded:Connect(function(v)
        task.wait(0.1)
        
        if ESPController.Enabled.Ladder and v.Name == "Ladder" and v:IsA("Model") then
            AddLadderESP(v)
        end
        
        if ESPController.Enabled.HidingSpot then
            local spotName = HidingSpots[v.Name]
            if spotName and v:IsA("Model") and v.PrimaryPart then
                AddHidingSpotESP(v, spotName)
            end
        end
        
        if ESPController.Enabled.Chest then
            if v.Name == "Toolshed_Small" or v.Name == "Chest_Vine" or 
               v.Name == "ChestBoxLocked" or v.Name == "ChestBox" then
                local displayText = "Chest"
                if v.Name == "Chest_Vine" then
                    displayText = "[Vine] Chest"
                elseif v.Name == "ChestBoxLocked" then
                    displayText = "[Locked] Chest"
                elseif v.Name == "Toolshed_Small" then
                    displayText = "Shears Cabinet"
                end
                AddChestESP(v, displayText)
            end
        end
        
        if ESPController.Enabled.Gold and v.Name == "GoldPile" then
            AddGoldESP(v)
        end
        
        if ESPController.Enabled.Item then
            local itemName = Item[v.Name]
            if itemName and v:IsA("Model") and v.PrimaryPart then
                AddItemESP(v, itemName)
            end
        end
        
        if ESPController.Enabled.Stardust and v.Name == "StardustPickup" then
            AddStardustESP(v)
        end
        
        if ESPController.Enabled.Entity then
            if EntityData[v.Name] and v:IsDescendantOf(Workspace.CurrentRooms) then
                addEntityESP(v)
            end
        end
    end)
    
    Workspace.DescendantRemoving:Connect(function(v)
        if DoorESPObjects[v] then
            DoorESPObjects[v]:Destroy()
            DoorESPObjects[v] = nil
        end
        if LadderESPObjects[v] then
            LadderESPObjects[v]:Destroy()
            LadderESPObjects[v] = nil
        end
        if TaskESPObjects[v] then
            TaskESPObjects[v]:Destroy()
            TaskESPObjects[v] = nil
        end
        if HidingSpotESPObjects[v] then
            HidingSpotESPObjects[v]:Destroy()
            HidingSpotESPObjects[v] = nil
        end
        if ChestESPObjects[v] then
            ChestESPObjects[v]:Destroy()
            ChestESPObjects[v] = nil
        end
        if GoldESPObjects[v] then
            GoldESPObjects[v]:Destroy()
            GoldESPObjects[v] = nil
        end
        if ItemsESPObjects[v] then
            ItemsESPObjects[v]:Destroy()
            ItemsESPObjects[v] = nil
        end
        if StardustESPObjects[v] then
            StardustESPObjects[v]:Destroy()
            StardustESPObjects[v] = nil
        end
        if EntityESPObjects[v] then
            EntityESPObjects[v]:Destroy()
            EntityESPObjects[v] = nil
        end
    end)
end

initializeESP()

RunService.RenderStepped:Connect(function()
    if ESPController.Enabled.Door then
        updateDoorESP()
    end
    
    if ESPController.Enabled.Player then
        updatePlayerESP()
    end
end)

local ESPGroup = Tabs.ESP:AddLeftGroupbox("ESP Controls")

ESPGroup:AddToggle("ESPDoor", {
    Text = "Door ESP",
    Default = false,
    Callback = function(v)
        ESPController.Enabled.Door = v
        if v then
            DoorESPObjects = clearESPType(DoorESPObjects)
            scanDoors()
        else
            DoorESPObjects = clearESPType(DoorESPObjects)
        end
    end
}):AddColorPicker("DoorColor", {
    Default = DoorColor,
    Callback = function(c)
        DoorColor = c
        if ESPController.Enabled.Door then
            DoorESPObjects = clearESPType(DoorESPObjects)
            scanDoors()
        end
    end
})

ESPGroup:AddToggle("ESPLadder", {
    Text = "Ladder ESP",
    Default = false,
    Callback = function(v)
        ESPController.Enabled.Ladder = v
        if v then
            LadderESPObjects = clearESPType(LadderESPObjects)
            scanLadders()
        else
            LadderESPObjects = clearESPType(LadderESPObjects)
        end
    end
}):AddColorPicker("LadderColor", {
    Default = LadderColor,
    Callback = function(c)
        LadderColor = c
        if ESPController.Enabled.Ladder then
            LadderESPObjects = clearESPType(LadderESPObjects)
            scanLadders()
        end
    end
})

ESPGroup:AddToggle("ESPTask", {
    Text = "Task ESP",
    Default = false,
    Callback = function(v)
        ESPController.Enabled.Task = v
        if v then
            TaskESPObjects = clearESPType(TaskESPObjects)
            scanTasks()
        else
            TaskESPObjects = clearESPType(TaskESPObjects)
        end
    end
}):AddColorPicker("TaskColor", {
    Default = TaskColor,
    Callback = function(c)
        TaskColor = c
        if ESPController.Enabled.Task then
            TaskESPObjects = clearESPType(TaskESPObjects)
            scanTasks()
        end
    end
})

ESPGroup:AddToggle("ESPHidingSpot", {
    Text = "Hiding Spot ESP",
    Default = false,
    Callback = function(v)
        ESPController.Enabled.HidingSpot = v
        if v then
            HidingSpotESPObjects = clearESPType(HidingSpotESPObjects)
            scanHidingSpots()
        else
            HidingSpotESPObjects = clearESPType(HidingSpotESPObjects)
        end
    end
}):AddColorPicker("HidingSpotColor", {
    Default = HidingSpotColor,
    Callback = function(c)
        HidingSpotColor = c
        if ESPController.Enabled.HidingSpot then
            HidingSpotESPObjects = clearESPType(HidingSpotESPObjects)
            scanHidingSpots()
        end
    end
})

ESPGroup:AddToggle("ESPChest", {
    Text = "Chest ESP",
    Default = false,
    Callback = function(v)
        ESPController.Enabled.Chest = v
        if v then
            ChestESPObjects = clearESPType(ChestESPObjects)
            scanChests()
        else
            ChestESPObjects = clearESPType(ChestESPObjects)
        end
    end
}):AddColorPicker("ChestColor", {
    Default = ChestColor,
    Callback = function(c)
        ChestColor = c
        if ESPController.Enabled.Chest then
            ChestESPObjects = clearESPType(ChestESPObjects)
            scanChests()
        end
    end
})

ESPGroup:AddToggle("ESPPlayer", {
    Text = "Player ESP",
    Default = false,
    Callback = function(v)
        ESPController.Enabled.Player = v
        if v then
            PlayerESPObjects = clearESPType(PlayerESPObjects)
            scanPlayers()
        else
            PlayerESPObjects = clearESPType(PlayerESPObjects)
        end
    end
}):AddColorPicker("PlayerColor", {
    Default = PlayerColor,
    Callback = function(c)
        PlayerColor = c
        if ESPController.Enabled.Player then
            PlayerESPObjects = clearESPType(PlayerESPObjects)
            scanPlayers()
        end
    end
})

ESPGroup:AddToggle("ESPGold", {
    Text = "Gold ESP",
    Default = false,
    Callback = function(v)
        ESPController.Enabled.Gold = v
        if v then
            GoldESPObjects = clearESPType(GoldESPObjects)
            scanGold()
        else
            GoldESPObjects = clearESPType(GoldESPObjects)
        end
    end
}):AddColorPicker("GoldColor", {
    Default = GoldColor,
    Callback = function(c)
        GoldColor = c
        if ESPController.Enabled.Gold then
            GoldESPObjects = clearESPType(GoldESPObjects)
            scanGold()
        end
    end
})

ESPGroup:AddToggle("ESPItem", {
    Text = "Item ESP",
    Default = false,
    Callback = function(v)
        ESPController.Enabled.Item = v
        if v then
            ItemsESPObjects = clearESPType(ItemsESPObjects)
            scanItems()
        else
            ItemsESPObjects = clearESPType(ItemsESPObjects)
        end
    end
}):AddColorPicker("ItemsColor", {
    Default = ItemsColor,
    Callback = function(c)
        ItemsColor = c
        if ESPController.Enabled.Item then
            ItemsESPObjects = clearESPType(ItemsESPObjects)
            scanItems()
        end
    end
})

ESPGroup:AddToggle("ESPStardust", {
    Text = "Stardust ESP",
    Default = false,
    Callback = function(v)
        ESPController.Enabled.Stardust = v
        if v then
            StardustESPObjects = clearESPType(StardustESPObjects)
            scanStardust()
        else
            StardustESPObjects = clearESPType(StardustESPObjects)
        end
    end
}):AddColorPicker("StardustColor", {
    Default = StardustColor,
    Callback = function(c)
        StardustColor = c
        if ESPController.Enabled.Stardust then
            StardustESPObjects = clearESPType(StardustESPObjects)
            scanStardust()
        end
    end
})

ESPGroup:AddToggle("ESPEntity", {
    Text = "Entity ESP",
    Default = false,
    Callback = function(v)
        ESPController.Enabled.Entity = v
        if v then
            EntityESPObjects = clearESPType(EntityESPObjects)
            scanEntities()
        else
            EntityESPObjects = clearESPType(EntityESPObjects)
        end
    end
}):AddColorPicker("EntityColor", {
    Default = Color3.new(1,0,0),
    Callback = function(c)
        for k, _ in pairs(EntityData) do
            EntityData[k].Color = c
        end
        if ESPController.Enabled.Entity then
            EntityESPObjects = clearESPType(EntityESPObjects)
            scanEntities()
        end
    end
})

local ESPGroup2 = Tabs.ESP:AddLeftGroupbox("ESP Settings")

ESPGroup2:AddSlider("ESPTextSize", {
    Text = "Text Size",
    Default = 14,
    Min = 8,
    Max = 30,
    Rounding = 0,
    Callback = function(v)
        ESPGlobalSettings.TextSize = v
        for _, tbl in pairs({DoorESPObjects, LadderESPObjects, TaskESPObjects, HidingSpotESPObjects, ChestESPObjects, PlayerESPObjects, GoldESPObjects, ItemsESPObjects, StardustESPObjects, EntityESPObjects}) do
            for _, obj in pairs(tbl) do
                if obj and obj.CurrentSettings then
                    obj.CurrentSettings.TextSize = v
                end
            end
        end
    end
})

ESPGroup2:AddSlider("ESPFillTransparency", {
    Text = "Fill Transparency",
    Default = 0.7,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(v)
        ESPGlobalSettings.FillTransparency = v
        for _, tbl in pairs({DoorESPObjects, LadderESPObjects, TaskESPObjects, HidingSpotESPObjects, ChestESPObjects, PlayerESPObjects, GoldESPObjects, ItemsESPObjects, StardustESPObjects, EntityESPObjects}) do
            for _, obj in pairs(tbl) do
                if obj and obj.CurrentSettings then
                    obj.CurrentSettings.FillTransparency = v
                end
            end
        end
    end
})

ESPGroup2:AddSlider("ESPOutlineTransparency", {
    Text = "Outline Transparency",
    Default = 0.4,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(v)
        ESPGlobalSettings.OutlineTransparency = v
        for _, tbl in pairs({DoorESPObjects, LadderESPObjects, TaskESPObjects, HidingSpotESPObjects, ChestESPObjects, PlayerESPObjects, GoldESPObjects, ItemsESPObjects, StardustESPObjects, EntityESPObjects}) do
            for _, obj in pairs(tbl) do
                if obj and obj.CurrentSettings then
                    obj.CurrentSettings.OutlineTransparency = v
                end
            end
        end
    end
})

ESPGroup2:AddToggle("ESPTracers", {
    Text = "Show Tracers",
    Default = false,
    Callback = function(v)
        ESPGlobalSettings.TracerEnabled = v
        for _, tbl in pairs({DoorESPObjects, LadderESPObjects, TaskESPObjects, HidingSpotESPObjects, ChestESPObjects, PlayerESPObjects, GoldESPObjects, ItemsESPObjects, StardustESPObjects, EntityESPObjects}) do
            for _, obj in pairs(tbl) do
                if obj and obj.CurrentSettings then
                    obj.CurrentSettings.Tracer.Enabled = v
                    obj.CurrentSettings.Tracer.Color = obj.CurrentSettings.Color
                end
            end
        end
    end
})

ESPGroup2:AddToggle("ESPArrows", {
    Text = "Show Arrows",
    Default = false,
    Callback = function(v)
        ESPGlobalSettings.ArrowEnabled = v
        for _, tbl in pairs({DoorESPObjects, LadderESPObjects, TaskESPObjects, HidingSpotESPObjects, ChestESPObjects, PlayerESPObjects, GoldESPObjects, ItemsESPObjects, StardustESPObjects, EntityESPObjects}) do
            for _, obj in pairs(tbl) do
                if obj and obj.CurrentSettings then
                    obj.CurrentSettings.Arrow.Enabled = v
                    obj.CurrentSettings.Arrow.Color = obj.CurrentSettings.Color
                end
            end
        end
    end
})

ESPGroup2:AddToggle("ESPRainbow", {
    Text = "Rainbow Mode",
    Default = false,
    Callback = function(v)
        ESPGlobalSettings.Rainbow = v
        if ESPLibrary then
            ESPLibrary:SetRainbow(v)
        end
    end
})

ESPGroup2:AddDropdown("ESPType", {
    Text = "ESP Type",
    Values = {"Highlight", "Box", "BoxOutline", "Chams"},
    Default = "Highlight",
    Multi = false,
    Callback = function(v)
        ESPGlobalSettings.ESPType = v
        for _, tbl in pairs({DoorESPObjects, LadderESPObjects, TaskESPObjects, HidingSpotESPObjects, ChestESPObjects, PlayerESPObjects, GoldESPObjects, ItemsESPObjects, StardustESPObjects, EntityESPObjects}) do
            for _, obj in pairs(tbl) do
                if obj and obj.CurrentSettings then
                    obj.CurrentSettings.ESPType = v
                end
            end
        end
    end
})

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
local Info = Tabs["UI Settings"]:AddRightGroupbox("Info")

MenuGroup:AddDropdown("NotifySide", {
    Text = "Notification Side",
    Values = {"Left", "Right"},
    Default = "Right",
    Multi = false,
    Callback = function(Value)
        Library.NotifySide = Value
    end
})

_G.ChooseNotify = "Door"
MenuGroup:AddDropdown("NotifyChoose", {
    Text = "Notification Choose",
    Values = {"Obsidian", "Roblox", "Door"},
    Default = "",
    Multi = false,
    Callback = function(Value)
        _G.ChooseNotify = Value
    end
})

MenuGroup:AddSlider("Volume Notification", {
    Text = "Volume Notification",
    Default = 2,
    Min = 2,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
        _G.VolumeTime = Value
    end
})

MenuGroup:AddToggle("KeybindMenuOpen", {Default = false, Text = "Open Keybind Menu", Callback = function(Value) Library.KeybindFrame.Visible = Value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddToggle("watermark", {Text = "Show Watermark", Default = false, Callback = function(Value) Library:SetWatermarkVisibility(Value) end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
_G.LinkJoin = loadstring(game:HttpGet("https://pastefy.app/2LKQlhQM/raw"))()
MenuGroup:AddButton("Copy Link Discord", function()
    if setclipboard then
        setclipboard(_G.LinkJoin["Discord"])
        Library:Notify("Copied discord link to clipboard!")
    else
        Library:Notify("Discord link: ".._G.LinkJoin["Discord"], 10)
    end
end):AddButton("Copy Link Zalo", function()
    if setclipboard then
        setclipboard(_G.LinkJoin["Zalo"])
        Library:Notify("Copied Zalo link to clipboard!")
    else
        Library:Notify("Zalo link: ".._G.LinkJoin["Zalo"], 10)
    end
end)
MenuGroup:AddButton("Unload", function()
    Library:Unload() 
    for _, tbl in pairs({DoorESPObjects, LadderESPObjects, TaskESPObjects, HidingSpotESPObjects, ChestESPObjects, PlayerESPObjects, GoldESPObjects, ItemsESPObjects, StardustESPObjects, EntityESPObjects}) do
        for _, obj in pairs(tbl) do
            pcall(function() obj:Destroy() end)
        end
    end
    ESPLibrary:Unload()
    if oxygenBarGui then oxygenBarGui:Destroy() end
    getgenv().LoadingScriptDoor = nil
end)

Info:AddLabel("Counter [ "..game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(game.Players.LocalPlayer).." ]", true)
Info:AddLabel("Executor [ "..identifyexecutor().." ]", true)
Info:AddLabel("Phone / PC [ "..(MobileOn and "Phone" or "PC").." ]", true)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

_G.AddedGet = {}
_G.Aura = _G.Aura or {
    ["AuraPrompt"] = {
        "ActivateEventPrompt",
        "HerbPrompt",
        "LootPrompt",
        "SkullPrompt",
        "ValvePrompt",
        "LongPushPrompt",
        "LeverPrompt",
        "FusesPrompt",
        "UnlockPrompt",
        "AwesomePrompt",
        "ModulePrompt",
        "PartyDoorPrompt",
    },
    ["AutoLootInteractions"] = {
        "ActivateEventPrompt",
        "HerbPrompt",
        "LootPrompt",
        "SkullPrompt",
        "ValvePrompt"
    },
    ["AutoLootNotInter"] = {
        "LongPushPrompt",
        "LeverPrompt",
        "FusesPrompt",
        "UnlockPrompt",
        "AwesomePrompt",
        "ModulePrompt",
        "PartyDoorPrompt",
    }
}

local function Added(v)
    if v.Name == "Snare" then
        if v:FindFirstChild("Hitbox") then
            if Toggles["Anti Snare"].Value then
                v.Hitbox:Destroy()
            end
        end
    end
    if v.Name == "Egg" then
        v.CanTouch = not Toggles["Anti Egg Gloom"].Value
    end
    task.spawn(function()
        if v:IsA("Model") and v.Name == "GiggleCeiling" then
            repeat task.wait() until v:FindFirstChild("Hitbox")
            wait(0.1)
            if Toggles["Anti Giggle"].Value and v:FindFirstChild("Hitbox") then
                v.Hitbox:Destroy()
            end
        end
    end)
    task.spawn(function()
        if v.Name == "_DamHandler" then
            repeat task.wait() until v:FindFirstChild("SeekFloodline")
            wait(0.1)
            if v:FindFirstChild("SeekFloodline") then
                v.SeekFloodline.CanCollide = Toggles["Anti Seek Flood"].Value
            end
        end
    end)
    if v.Name == "PlayerBarrier" and v.Size.Y == 2.75 and (v.Rotation.X == 0 or v.Rotation.X == 180) then
        if Toggles["Anti Fall Barrier"].Value then
            local CLONEBARRIER = v:Clone()
            CLONEBARRIER.CFrame = CLONEBARRIER.CFrame * CFrame.new(0, 0, -5)
            CLONEBARRIER.Color = Color3.new(1, 1, 1)
            CLONEBARRIER.Name = "CLONEBARRIER_ANTI"
            CLONEBARRIER.Size = Vector3.new(CLONEBARRIER.Size.X, CLONEBARRIER.Size.Y, 11)
            CLONEBARRIER.Transparency = 0
            CLONEBARRIER.Parent = v.Parent
        end
    end
    if v.Name == "ChandelierObstruction" or v.Name == "Seek_Arm" then
        for b, h in pairs(v:GetDescendants()) do
            if h:IsA("BasePart") then 
                h.CanTouch = not Toggles["Anti Seek Obstruction"].Value
            end
        end
    end
    if v.Name == "DoorFake" then
        local CollisionFake = v:FindFirstChild("Hidden", true)
        local Prompt = v:FindFirstChild("UnlockPrompt", true)
        if CollisionFake then
            CollisionFake.CanTouch = not Toggles["Anti Fake Door"].Value
        end
        if Prompt and Toggles["Anti Fake Door"].Value then
            Prompt:Destroy()
        end
    end
    if not table.find(_G.AddedGet, v) then
        if v:IsA("Model") and v.Name == "MinesAnchor" then
            table.insert(_G.AddedGet, v)
        end
        if v:IsA("ProximityPrompt") and table.find(_G.Aura["AuraPrompt"], v.Name) then
            table.insert(_G.AddedGet, v)
        end
        if v:IsA("ObjectValue") and v.Name == "HiddenPlayer" then
            table.insert(_G.AddedGet, v.Parent)
        end
    end
end

for _, v in ipairs(workspace:GetDescendants()) do
    Added(v)
end
workspace.DescendantAdded:Connect(function(v)
    Added(v)
end)

workspace.DescendantRemoving:Connect(function(v)
    for i = #_G.AddedGet, 1, -1 do
        if _G.AddedGet[i] == v then
            table.remove(_G.AddedGet, i)
            break
        end
    end
end)
