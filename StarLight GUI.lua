local StarLight = {}
local Services = {
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    CoreGui = game:GetService("CoreGui"),
    TextService = game:GetService("TextService"),
    HttpService = game:GetService("HttpService"),
    Workspace = game:GetService("Workspace")
}

local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local IsMobile = Services.UserInputService.TouchEnabled and not Services.UserInputService.MouseEnabled
local ScaleFactor = IsMobile and 1.25 or 1.0
local IsStudio = Services.RunService:IsStudio()

local Theme = {
    MainColor = Color3.fromRGB(25, 25, 35),
    SecondaryColor = Color3.fromRGB(30, 30, 45),
    AccentColor = Color3.fromRGB(60, 180, 255),
    TextColor = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150),
    Outline = Color3.fromRGB(60, 60, 80),
    HoverColor = Color3.fromRGB(40, 40, 55),
    Success = Color3.fromRGB(100, 255, 100),
    Error = Color3.fromRGB(255, 100, 100),
    Warning = Color3.fromRGB(255, 200, 50),
    Font = Enum.Font.GothamMedium,
    BoldFont = Enum.Font.GothamBold,
    CodeFont = Enum.Font.Code,
    AnimationSpeed = 0.3,
    HoverSpeed = 0.15,
    RippleSpeed = 0.5
}

local IconLib = {
    Settings = "rbxassetid://6031068431",
    Palette = "rbxassetid://6031068419",
    ChevronDown = "rbxassetid://6031091004",
    ChevronUp = "rbxassetid://6031090990",
    Search = "rbxassetid://6034297516",
    Close = "rbxassetid://6031094678",
    Check = "rbxassetid://6031068433",
    Copy = "rbxassetid://6031068421",
    Lock = "rbxassetid://6031068425",
    Unlock = "rbxassetid://6031068427",
    Download = "rbxassetid://6031068417",
    Upload = "rbxassetid://6031068441",
    Trash = "rbxassetid://6031068429",
    Plus = "rbxassetid://6031068423",
    Minus = "rbxassetid://6031068426",
    Edit = "rbxassetid://6031068415",
    Code = "rbxassetid://6031068411",
    Info = "rbxassetid://6031068413",
    Warning = "rbxassetid://6031068443",
    Error = "rbxassetid://6031068412",
    Bell = "rbxassetid://6031068408",
    Clock = "rbxassetid://6031068410",
    Folder = "rbxassetid://6031068420",
    File = "rbxassetid://6031068414",
    Save = "rbxassetid://6031068437",
    Key = "rbxassetid://6031068428",
    Mouse = "rbxassetid://6031068432",
    Keyboard = "rbxassetid://6031068424",
    Gamepad = "rbxassetid://6031068418",
    Touch = "rbxassetid://6031068440",
    Move = "rbxassetid://6031068430",
    Menu = "rbxassetid://6031068434",
    List = "rbxassetid://6031068436",
    Grid = "rbxassetid://6031068422",
    Star = "rbxassetid://6031068438",
    Heart = "rbxassetid://6031068429",
    Refresh = "rbxassetid://6031068433",
    Sync = "rbxassetid://6031068444",
    Power = "rbxassetid://6031068427",
    Play = "rbxassetid://6031068426",
    Pause = "rbxassetid://6031068425",
    Stop = "rbxassetid://6031068441",
    Volume = "rbxassetid://6031068445",
    Mute = "rbxassetid://6031068431",
    Mic = "rbxassetid://6031068430",
    MicOff = "rbxassetid://6031068429",
    Camera = "rbxassetid://6031068405",
    CameraOff = "rbxassetid://6031068404",
    Image = "rbxassetid://6031068416",
    Video = "rbxassetid://6031068446",
    Mail = "rbxassetid://6031068428",
    Send = "rbxassetid://6031068438",
    Link = "rbxassetid://6031068422",
    ExternalLink = "rbxassetid://6031068417",
    Share = "rbxassetid://6031068435",
    User = "rbxassetid://6031068444",
    Users = "rbxassetid://6031068445",
    Login = "rbxassetid://6031068421",
    Logout = "rbxassetid://6031068420"
}

local function GetIcon(Name)
    local Icon = IconLib[Name] or IconLib.Info
    return {
        Image = Icon,
        ImageRectSize = Vector2.new(20, 20),
        ImageRectOffset = Vector2.new(0, 0)
    }
end

local function Make(ClassName, Properties, Children)
    local Instance = Instance.new(ClassName)
    for Property, Value in pairs(Properties or {}) do
        Instance[Property] = Value
    end
    if Children then
        for _, Child in ipairs(Children) do
            if typeof(Child) == "Instance" then
                Child.Parent = Instance
            end
        end
    end
    return Instance
end

local function Tween(Object, Time, Properties, EasingStyle, EasingDirection)
    local TweenInfo = TweenInfo.new(
        Time or Theme.AnimationSpeed,
        EasingStyle or Enum.EasingStyle.Quart,
        EasingDirection or Enum.EasingDirection.Out
    )
    local Tween = Services.TweenService:Create(Object, TweenInfo, Properties)
    Tween:Play()
    return Tween
end

local function Ripple(Obj, Input)
    task.spawn(function()
        local RippleCircle = Make("ImageLabel", {
            Name = "Ripple",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Image = "rbxassetid://4031889928",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.8,
            Size = UDim2.new(0, 0, 0, 0),
            ZIndex = 10,
        })
        
        local Size = Obj.AbsoluteSize
        local Position = Input.Position
        local RelativePosition = Position - Obj.AbsolutePosition
        local MaxSize = math.max(Size.X, Size.Y) * 2
        
        RippleCircle.Position = UDim2.new(0, RelativePosition.X - MaxSize/2, 0, RelativePosition.Y - MaxSize/2)
        RippleCircle.Size = UDim2.new(0, MaxSize, 0, MaxSize)
        RippleCircle.Parent = Obj
        
        Tween(RippleCircle, Theme.RippleSpeed, {ImageTransparency = 1}):Completed:Wait()
        RippleCircle:Destroy()
    end)
end

local function Drag(Frame, DragArea)
    local Dragging, DragInput, DragStart, StartPos
    
    DragArea.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPos = Frame.Position
            
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    DragArea.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Tween(Frame, 0.05, {Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)})
        end
    end)
end

local NotificationManager = {}
function NotificationManager:New(Parent)
    local self = setmetatable({}, {__index = NotificationManager})
    
    self.ScreenGui = Make("ScreenGui", {
        Name = "StarLightNotifications",
        Parent = Parent,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })
    
    self.Container = Make("Frame", {
        Name = "NotificationContainer",
        Parent = self.ScreenGui,
        Size = UDim2.new(0, 350, 1, 0),
        Position = UDim2.new(1, -370, 0, 20),
        BackgroundTransparency = 1
    })
    
    Make("UIListLayout", {
        Parent = self.Container,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 10)
    })
    
    self.Notifications = {}
    return self
end

function NotificationManager:Notify(Config)
    Config = Config or {}
    local Title = Config.Title or "Notification"
    local Content = Config.Content or ""
    local Duration = Config.Duration or 5
    local Icon = Config.Icon or "Bell"
    local Type = Config.Type or "info"
    
    local NotificationFrame = Make("CanvasGroup", {
        Parent = self.Container,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.SecondaryColor,
        BorderSizePixel = 0,
        GroupTransparency = 1
    })
    
    Make("UICorner", {Parent = NotificationFrame, CornerRadius = UDim.new(0, 8)})
    Make("UIStroke", {Parent = NotificationFrame, Color = Theme.Outline, Thickness = 1, Transparency = 0.5})
    
    local IconImg = Make("ImageLabel", {
        Parent = NotificationFrame,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 15, 0, 15),
        BackgroundTransparency = 1,
        Image = GetIcon(Icon).Image,
        ImageColor3 = Theme.AccentColor
    })
    
    local TitleLabel = Make("TextLabel", {
        Parent = NotificationFrame,
        Size = UDim2.new(1, -60, 0, 20),
        Position = UDim2.new(0, 50, 0, 12),
        BackgroundTransparency = 1,
        Text = Title,
        Font = Theme.BoldFont,
        TextColor3 = Theme.TextColor,
        TextSize = 16 * ScaleFactor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local ContentLabel = Make("TextLabel", {
        Parent = NotificationFrame,
        Size = UDim2.new(1, -60, 0, 0),
        Position = UDim2.new(0, 50, 0, 35),
        BackgroundTransparency = 1,
        Text = Content,
        Font = Theme.Font,
        TextColor3 = Theme.TextDark,
        TextSize = 14 * ScaleFactor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    local CloseBtn = Make("ImageButton", {
        Parent = NotificationFrame,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0, 10),
        BackgroundTransparency = 1,
        Image = GetIcon("Close").Image,
        ImageColor3 = Theme.TextDark
    })
    
    local function Close()
        Tween(NotificationFrame, 0.3, {GroupTransparency = 1, Size = UDim2.new(1, 0, 0, 0)})
        task.wait(0.3)
        NotificationFrame:Destroy()
    end
    
    CloseBtn.MouseButton1Click:Connect(Close)
    
    task.spawn(function()
        task.wait(0.1)
        local ContentSize = ContentLabel.TextBounds.Y + 60
        Tween(NotificationFrame, 0.4, {GroupTransparency = 0, Size = UDim2.new(1, 0, 0, ContentSize)})
        
        if Duration > 0 then
            task.wait(Duration)
            Close()
        end
    end)
end

local TooltipManager = {}
function TooltipManager:New(Parent)
    local self = setmetatable({}, {__index = TooltipManager})
    
    self.ScreenGui = Make("ScreenGui", {
        Name = "StarLightTooltips",
        Parent = Parent,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 1000
    })
    
    self.Tooltip = nil
    self.Active = true
    
    return self
end

function TooltipManager:Show(Text, Position)
    if self.Tooltip then
        self.Tooltip:Destroy()
    end
    
    self.Tooltip = Make("CanvasGroup", {
        Parent = self.ScreenGui,
        Position = UDim2.new(0, Position.X + 10, 0, Position.Y - 30),
        BackgroundColor3 = Theme.SecondaryColor,
        BorderSizePixel = 0,
        GroupTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        ZIndex = 1000
    })
    
    Make("UICorner", {Parent = self.Tooltip, CornerRadius = UDim.new(0, 6)})
    Make("UIStroke", {Parent = self.Tooltip, Color = Theme.AccentColor, Thickness = 1})
    
    local Label = Make("TextLabel", {
        Parent = self.Tooltip,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        Text = Text,
        Font = Theme.Font,
        TextColor3 = Theme.TextColor,
        TextSize = 14 * ScaleFactor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    Make("UIPadding", {
        Parent = self.Tooltip,
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    Tween(self.Tooltip, 0.2, {GroupTransparency = 0})
end

function TooltipManager:Hide()
    if self.Tooltip then
        Tween(self.Tooltip, 0.2, {GroupTransparency = 1})
        task.wait(0.2)
        self.Tooltip:Destroy()
        self.Tooltip = nil
    end
end

function TooltipManager:UpdatePosition(Position)
    if self.Tooltip then
        self.Tooltip.Position = UDim2.new(0, Position.X + 10, 0, Position.Y - 30)
    end
end

function TooltipManager:SetActive(Active)
    self.Active = Active
end

local ConfigManager = {}
function ConfigManager:New(FolderName)
    local self = setmetatable({}, {__index = ConfigManager})
    
    self.Folder = FolderName or "StarLightConfigs"
    self.Path = "StarLight/" .. self.Folder .. "/"
    self.CurrentConfig = nil
    self.Configs = {}
    
    if not isfolder("StarLight") then
        makefolder("StarLight")
    end
    
    if not isfolder(self.Path) then
        makefolder(self.Path)
    end
    
    self:LoadAllConfigs()
    return self
end

function ConfigManager:LoadAllConfigs()
    if not listfiles then return end
    
    local Files = listfiles(self.Path)
    for _, File in ipairs(Files) do
        local Name = File:match("([^/]+)%.json$")
        if Name then
            local Content = readfile(File)
            local Success, Data = pcall(function()
                return Services.HttpService:JSONDecode(Content)
            end)
            if Success then
                self.Configs[Name] = Data
            end
        end
    end
end

function ConfigManager:SaveConfig(Name, Data)
    local FullPath = self.Path .. Name .. ".json"
    local Json = Services.HttpService:JSONEncode(Data)
    
    if writefile then
        writefile(FullPath, Json)
        self.Configs[Name] = Data
        return true
    end
    return false
end

function ConfigManager:LoadConfig(Name)
    local FullPath = self.Path .. Name .. ".json"
    
    if isfile and isfile(FullPath) then
        local Content = readfile(FullPath)
        local Success, Data = pcall(function()
            return Services.HttpService:JSONDecode(Content)
        end)
        if Success then
            self.CurrentConfig = Data
            return Data
        end
    end
    return nil
end

function ConfigManager:DeleteConfig(Name)
    local FullPath = self.Path .. Name .. ".json"
    
    if isfile and isfile(FullPath) and delfile then
        delfile(FullPath)
        self.Configs[Name] = nil
        return true
    end
    return false
end

function ConfigManager:GetConfigNames()
    local Names = {}
    for Name, _ in pairs(self.Configs) do
        table.insert(Names, Name)
    end
    return Names
end

local CodeEditor = {}
function CodeEditor:New(Parent, Code, Title, OnCopy)
    local self = setmetatable({}, {__index = CodeEditor})
    
    self.Code = Code or ""
    self.Title = Title or "Code Editor"
    self.OnCopy = OnCopy or function() end
    
    self.Frame = Make("CanvasGroup", {
        Parent = Parent,
        Size = UDim2.new(1, 0, 0, 200),
        BackgroundColor3 = Theme.MainColor,
        BorderSizePixel = 0,
        GroupTransparency = 0
    })
    
    Make("UICorner", {Parent = self.Frame, CornerRadius = UDim.new(0, 6)})
    Make("UIStroke", {Parent = self.Frame, Color = Theme.Outline, Thickness = 1})
    
    self.Header = Make("Frame", {
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.SecondaryColor,
        BorderSizePixel = 0
    })
    
    Make("UICorner", {Parent = self.Header, CornerRadius = UDim.new(0, 6)})
    
    local TitleLabel = Make("TextLabel", {
        Parent = self.Header,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Title,
        Font = Theme.Font,
        TextColor3 = Theme.TextColor,
        TextSize = 14 * ScaleFactor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local CopyBtn = Make("ImageButton", {
        Parent = self.Header,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -35, 0.5, -12),
        BackgroundTransparency = 1,
        Image = GetIcon("Copy").Image,
        ImageColor3 = Theme.TextDark
    })
    
    self.ScrollFrame = Make("ScrollingFrame", {
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 1, -45),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.AccentColor,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    self.CodeLabel = Make("TextLabel", {
        Parent = self.ScrollFrame,
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = self.Code,
        Font = Theme.CodeFont,
        TextColor3 = Theme.TextColor,
        TextSize = 13 * ScaleFactor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        RichText = true
    })
    
    Make("UIPadding", {
        Parent = self.ScrollFrame,
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    })
    
    CopyBtn.MouseButton1Click:Connect(function()
        if copyclipboard then
            copyclipboard(self.Code)
            self.OnCopy()
        end
    end)
    
    CopyBtn.MouseEnter:Connect(function()
        Tween(CopyBtn, 0.1, {ImageColor3 = Theme.AccentColor})
    end)
    
    CopyBtn.MouseLeave:Connect(function()
        Tween(CopyBtn, 0.1, {ImageColor3 = Theme.TextDark})
    end)
    
    return self
end

function CodeEditor:SetCode(NewCode)
    self.Code = NewCode
    self.CodeLabel.Text = NewCode
end

local KeybindManager = {}
function KeybindManager:New(Parent)
    local self = setmetatable({}, {__index = KeybindManager})
    
    self.ScreenGui = Make("ScreenGui", {
        Name = "StarLightKeybinds",
        Parent = IsStudio and LocalPlayer.PlayerGui or Services.CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    self.Keybinds = {}
    self.Active = true
    
    Services.UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        if not self.Active then return end
        
        for _, Keybind in ipairs(self.Keybinds) do
            if Keybind.Key == Input.KeyCode or Keybind.Key == Input.UserInputType then
                local Success, Error = pcall(Keybind.Callback)
                if not Success then
                    warn("[StarLight] Keybind error: " .. tostring(Error))
                end
            end
        end
    end)
    
    return self
end

function KeybindManager:Add(Key, Callback, Description)
    table.insert(self.Keybinds, {
        Key = Key,
        Callback = Callback,
        Description = Description or ""
    })
end

function KeybindManager:Remove(Key)
    for i, Keybind in ipairs(self.Keybinds) do
        if Keybind.Key == Key then
            table.remove(self.Keybinds, i)
            break
        end
    end
end

function KeybindManager:Clear()
    self.Keybinds = {}
end

function KeybindManager:SetActive(Active)
    self.Active = Active
end

local ContentDetector = {}
function ContentDetector:DetectEmptyPages(Window)
    local HasContent = false
    
    for _, Tab in pairs(Window.Tabs or {}) do
        if Tab.Components and #Tab.Components > 0 then
            HasContent = true
            break
        end
    end
    
    if not HasContent then
        local DefaultTab = Window:Tab("开始使用", "Info")
        DefaultTab:Section("欢迎使用StarLight")
        DefaultTab:Button({
            Name = "创建你的第一个标签页",
            Callback = function()
                Window:Notify({
                    Title = "提示",
                    Content = "使用 Window:Tab() 创建新标签页",
                    Duration = 3
                })
            end
        })
        DefaultTab:Toggle({
            Name = "启用示例功能",
            Default = true,
            Callback = function(Value)
                Window:Notify({
                    Title = "示例功能",
                    Content = Value and "功能已启用" or "功能已关闭",
                    Duration = 2
                })
            end
        })
    end
end

function StarLight:Window(Settings)
    Settings = Settings or {}
    local Config = {
        Title = Settings.Title or "StarLight Pro",
        Keybind = Settings.Keybind or Enum.KeyCode.RightControl,
        Folder = Settings.Folder or "StarLight",
        Debug = Settings.Debug or false,
        SaveConfigs = Settings.SaveConfigs or false
    }
    
    local ScreenGui = Make("ScreenGui", {
        Name = "StarLightUI",
        Parent = IsStudio and LocalPlayer.PlayerGui or Services.CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })
    
    local MainFrame = Make("CanvasGroup", {
        Name = "MainFrame",
        Parent = ScreenGui,
        Size = UDim2.fromOffset(650 * ScaleFactor, 450 * ScaleFactor),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.MainColor,
        GroupTransparency = 0,
        BorderSizePixel = 0,
        Active = true
    })
    
    Make("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 6)})
    Make("UIStroke", {Parent = MainFrame, Color = Theme.Outline, Thickness = 1, Transparency = 0.4})
    
    local Sidebar = Make("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        Size = UDim2.new(0, 180 * ScaleFactor, 1, 0),
        BackgroundColor3 = Theme.SecondaryColor,
        BorderSizePixel = 0
    })
    
    Make("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 6)})
    
    local SidebarSeparator = Make("Frame", {
        Parent = Sidebar,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Theme.Outline,
        BorderSizePixel = 0
    })
    
    local TitleLabel = Make("TextLabel", {
        Parent = Sidebar,
        Size = UDim2.new(1, -20, 0, 45 * ScaleFactor),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = Config.Title,
        Font = Theme.BoldFont,
        TextColor3 = Theme.AccentColor,
        TextSize = 18 * ScaleFactor,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local TabContainer = Make("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Sidebar,
        Size = UDim2.new(1, 0, 1, -65 * ScaleFactor),
        Position = UDim2.new(0, 0, 0, 65 * ScaleFactor),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        BorderSizePixel = 0
    })
    
    Make("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    Make("UIPadding", {
        Parent = TabContainer,
        PaddingLeft = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10)
    })
    
    local ContentArea = Make("Frame", {
        Name = "ContentArea",
        Parent = MainFrame,
        Size = UDim2.new(1, -(180 * ScaleFactor), 1, 0),
        Position = UDim2.new(0, 180 * ScaleFactor, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })
    
    Drag(MainFrame, Sidebar)
    
    local IsOpen = true
    local Tabs = {}
    local FirstTab = true
    
    local NotificationSys = NotificationManager:New(ScreenGui)
    local TooltipSys = TooltipManager:New(ScreenGui)
    local KeybindSys = KeybindManager:New(ScreenGui)
    local ConfigSys = Config.SaveConfigs and ConfigManager:New(Config.Folder) or nil
    
    local function ToggleUI()
        IsOpen = not IsOpen
        if IsOpen then
            MainFrame.Visible = true
            Tween(MainFrame, 0.3, {GroupTransparency = 0, Size = UDim2.fromOffset(650 * ScaleFactor, 450 * ScaleFactor)})
        else
            Tween(MainFrame, 0.3, {GroupTransparency = 1, Size = UDim2.fromOffset(650 * ScaleFactor, 440 * ScaleFactor)})
            task.delay(0.3, function() if not IsOpen then MainFrame.Visible = false end end)
        end
    end
    
    Services.UserInputService.InputBegan:Connect(function(Input, GPE)
        if not GPE and Input.KeyCode == Config.Keybind then
            ToggleUI()
        end
    end)
    
    if IsMobile then
        local MobileBtn = Make("TextButton", {
            Parent = ScreenGui,
            Name = "MobileToggle",
            Size = UDim2.fromOffset(55, 55),
            Position = UDim2.new(0.9, -65, 0.5, -27),
            BackgroundColor3 = Theme.SecondaryColor,
            Text = "UI",
            TextColor3 = Theme.AccentColor,
            Font = Theme.BoldFont,
            TextSize = 18 * ScaleFactor,
            ZIndex = 100
        })
        Make("UICorner", {Parent = MobileBtn, CornerRadius = UDim.new(1, 0)})
        Make("UIStroke", {Parent = MobileBtn, Color = Theme.AccentColor, Thickness = 2})
        Drag(MobileBtn, MobileBtn)
        MobileBtn.MouseButton1Click:Connect(ToggleUI)
    end
    
    local WindowFunctions = {
        Tabs = Tabs,
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        NotificationManager = NotificationSys,
        TooltipManager = TooltipSys,
        KeybindManager = KeybindSys,
        ConfigManager = ConfigSys,
        Settings = Config,
        ScaleFactor = ScaleFactor,
        IsMobile = IsMobile
    }
    
    function WindowFunctions:Tab(Name, Icon)
        Icon = Icon or "Menu"
        
        local TabButton = Make("TextButton", {
            Parent = TabContainer,
            Name = Name,
            Size = UDim2.new(1, -20, 0, 36 * ScaleFactor),
            BackgroundColor3 = Theme.SecondaryColor,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = #Tabs
        })
        
        Make("UICorner", {Parent = TabButton, CornerRadius = UDim.new(0, 4)})
        
        local Title = Make("TextLabel", {
            Parent = TabButton,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = Name,
            Font = Theme.Font,
            TextColor3 = Theme.TextDark,
            TextSize = 14 * ScaleFactor,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local TabIcon = Make("ImageLabel", {
            Parent = TabButton,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -30, 0.5, -10),
            BackgroundTransparency = 1,
            Image = GetIcon(Icon).Image,
            ImageColor3 = Theme.TextDark
        })
        
        local Page = Make("ScrollingFrame", {
            Name = Name .. "Page",
            Parent = ContentArea,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.AccentColor,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        
        Make("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        
        Make("UIPadding", {
            Parent = Page,
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
        
        local TabData = {
            Name = Name,
            Button = TabButton,
            Page = Page,
            Components = {},
            Sections = {}
        }
        
        table.insert(Tabs, TabData)
        
        local function Activate()
            for _, Item in pairs(TabContainer:GetChildren()) do
                if Item:IsA("TextButton") then
                    Tween(Item, 0.2, {BackgroundTransparency = 1})
                    Tween(Item:FindFirstChild("TextLabel"), 0.2, {TextColor3 = Theme.TextDark})
                    Tween(Item:FindFirstChild("ImageLabel"), 0.2, {ImageColor3 = Theme.TextDark})
                end
            end
            for _, P in pairs(ContentArea:GetChildren()) do
                if P:IsA("ScrollingFrame") then P.Visible = false end
            end
            
            Page.Visible = true
            Tween(TabButton, 0.2, {BackgroundTransparency = 0.9, BackgroundColor3 = Theme.AccentColor})
            Tween(Title, 0.2, {TextColor3 = Theme.TextColor})
            Tween(TabIcon, 0.2, {ImageColor3 = Theme.TextColor})
        end
        
        TabButton.MouseButton1Click:Connect(Activate)
        
        if FirstTab then
            FirstTab = false
            Activate()
        end
        
        local TabFunctions = {}
        
        function TabFunctions:Section(Text)
            local SectionFrame = Make("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 25 * ScaleFactor),
                BackgroundTransparency = 1
            })
            
            Make("TextLabel", {
                Parent = SectionFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = Text,
                Font = Theme.BoldFont,
                TextColor3 = Theme.AccentColor,
                TextSize = 12 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            return SectionFrame
        end
        
        function TabFunctions:Button(Config)
            Config = Config or {}
            local Name = Config.Name or "Button"
            local Callback = Config.Callback or function() end
            local Icon = Config.Icon or "Plus"
            
            local BtnFrame = Make("TextButton", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 38 * ScaleFactor),
                BackgroundColor3 = Theme.SecondaryColor,
                AutoButtonColor = false,
                Text = ""
            })
            
            Make("UICorner", {Parent = BtnFrame, CornerRadius = UDim.new(0, 4)})
            Make("UIStroke", {Parent = BtnFrame, Color = Theme.Outline, Thickness = 1})
            
            local BtnIcon = Make("ImageLabel", {
                Parent = BtnFrame,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 12, 0.5, -9),
                BackgroundTransparency = 1,
                Image = GetIcon(Icon).Image,
                ImageColor3 = Theme.TextColor
            })
            
            local Title = Make("TextLabel", {
                Parent = BtnFrame,
                Size = UDim2.new(1, -50, 0, 20),
                Position = UDim2.new(0, 40, 0.5, -10),
                BackgroundTransparency = 1,
                Text = Name,
                Font = Theme.Font,
                TextColor3 = Theme.TextColor,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            BtnFrame.MouseButton1Click:Connect(function()
                Ripple(BtnFrame, Services.UserInputService:GetLastInputObject())
                task.spawn(Callback)
            end)
            
            BtnFrame.MouseEnter:Connect(function()
                Tween(BtnFrame, Theme.HoverSpeed, {BackgroundColor3 = Theme.HoverColor})
            end)
            
            BtnFrame.MouseLeave:Connect(function()
                Tween(BtnFrame, Theme.HoverSpeed, {BackgroundColor3 = Theme.SecondaryColor})
            end)
            
            table.insert(TabData.Components, BtnFrame)
            return BtnFrame
        end
        
        function TabFunctions:Toggle(Config)
            Config = Config or {}
            local Name = Config.Name or "Toggle"
            local Default = Config.Default or false
            local Callback = Config.Callback or function() end
            local Icon = Config.Icon or "Check"
            
            local State = Default
            
            local ToggleFrame = Make("TextButton", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 38 * ScaleFactor),
                BackgroundColor3 = Theme.SecondaryColor,
                AutoButtonColor = false,
                Text = ""
            })
            
            Make("UICorner", {Parent = ToggleFrame, CornerRadius = UDim.new(0, 4)})
            Make("UIStroke", {Parent = ToggleFrame, Color = Theme.Outline, Thickness = 1})
            
            local Title = Make("TextLabel", {
                Parent = ToggleFrame,
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 10, 0.5, -10),
                BackgroundTransparency = 1,
                Text = Name,
                Font = Theme.Font,
                TextColor3 = Theme.TextColor,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Switch = Make("Frame", {
                Parent = ToggleFrame,
                Size = UDim2.new(0, 44 * ScaleFactor, 0, 24 * ScaleFactor),
                Position = UDim2.new(1, -54 * ScaleFactor, 0.5, -12 * ScaleFactor),
                BackgroundColor3 = Theme.MainColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
            Make("UIStroke", {Parent = Switch, Color = Theme.Outline, Thickness = 1})
            
            local Dot = Make("Frame", {
                Parent = Switch,
                Size = UDim2.new(0, 18 * ScaleFactor, 0, 18 * ScaleFactor),
                Position = UDim2.new(0, 3, 0.5, -9 * ScaleFactor),
                BackgroundColor3 = Theme.TextDark,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = Dot, CornerRadius = UDim.new(1, 0)})
            
            local function Update()
                if State then
                    Tween(Dot, 0.2, {Position = UDim2.new(1, -21 * ScaleFactor, 0.5, -9 * ScaleFactor), BackgroundColor3 = Theme.AccentColor})
                    Tween(Switch, 0.2, {BackgroundColor3 = Theme.AccentColor})
                else
                    Tween(Dot, 0.2, {Position = UDim2.new(0, 3, 0.5, -9 * ScaleFactor), BackgroundColor3 = Theme.TextDark})
                    Tween(Switch, 0.2, {BackgroundColor3 = Theme.MainColor})
                end
                task.spawn(Callback, State)
            end
            
            ToggleFrame.MouseButton1Click:Connect(function()
                State = not State
                Ripple(ToggleFrame, Services.UserInputService:GetLastInputObject())
                Update()
            end)
            
            if Icon then
                local BtnIcon = Make("ImageLabel", {
                    Parent = ToggleFrame,
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(0, 12, 0.5, -9),
                    BackgroundTransparency = 1,
                    Image = GetIcon(Icon).Image,
                    ImageColor3 = Theme.TextColor
                })
            end
            
            Update()
            
            table.insert(TabData.Components, ToggleFrame)
            return ToggleFrame
        end
        
        function TabFunctions:Slider(Config)
            Config = Config or {}
            local Name = Config.Name or "Slider"
            local Min = Config.Min or 0
            local Max = Config.Max or 100
            local Default = Config.Default or Min
            local Step = Config.Step or 1
            local Callback = Config.Callback or function() end
            local Suffix = Config.Suffix or ""
            
            local Value = Default
            local IsDragging = false
            
            local SliderFrame = Make("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 60 * ScaleFactor),
                BackgroundColor3 = Theme.SecondaryColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = SliderFrame, CornerRadius = UDim.new(0, 4)})
            Make("UIStroke", {Parent = SliderFrame, Color = Theme.Outline, Thickness = 1})
            
            local Title = Make("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 8),
                BackgroundTransparency = 1,
                Text = Name,
                Font = Theme.Font,
                TextColor3 = Theme.TextColor,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Make("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -70, 0, 8),
                BackgroundTransparency = 1,
                Text = tostring(Value) .. Suffix,
                Font = Theme.Font,
                TextColor3 = Theme.AccentColor,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local Bar = Make("Frame", {
                Parent = SliderFrame,
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 36),
                BackgroundColor3 = Theme.MainColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = Bar, CornerRadius = UDim.new(1, 0)})
            
            local Fill = Make("Frame", {
                Parent = Bar,
                Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0),
                BackgroundColor3 = Theme.AccentColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
            
            local Thumb = Make("Frame", {
                Parent = Fill,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(1, -7, 0.5, -7),
                BackgroundColor3 = Theme.TextColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = Thumb, CornerRadius = UDim.new(1, 0)})
            
            local function UpdateValue(NewValue, CallCallback)
                NewValue = math.clamp(NewValue, Min, Max)
                NewValue = math.floor(NewValue / Step + 0.5) * Step
                Value = NewValue
                
                local Percent = (Value - Min) / (Max - Min)
                Tween(Fill, 0.05, {Size = UDim2.new(Percent, 0, 1, 0)})
                ValueLabel.Text = tostring(Value) .. Suffix
                
                if CallCallback ~= false then
                    task.spawn(Callback, Value)
                end
            end
            
            local function OnInput(Input)
                if not IsDragging then return end
                local Position = Input.Position
                local Percent = math.clamp((Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local NewValue = Min + (Max - Min) * Percent
                UpdateValue(NewValue)
            end
            
            Bar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsDragging = true
                    OnInput(Input)
                    Ripple(Bar, Input)
                end
            end)
            
            Services.UserInputService.InputChanged:Connect(function(Input)
                if IsDragging then
                    OnInput(Input)
                end
            end)
            
            Services.UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    IsDragging = false
                end
            end)
            
            UpdateValue(Value, false)
            
            table.insert(TabData.Components, SliderFrame)
            return SliderFrame
        end
        
        function TabFunctions:Dropdown(Config)
            Config = Config or {}
            local Name = Config.Name or "Dropdown"
            local Options = Config.Options or {}
            local Default = Config.Default
            local Callback = Config.Callback or function() end
            local MultiSelect = Config.MultiSelect or false
            local ShowSearch = Config.ShowSearch or false
            
            local IsOpen = false
            local SelectedValues = MultiSelect and {} or nil
            
            local DropdownFrame = Make("TextButton", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 38 * ScaleFactor),
                BackgroundColor3 = Theme.SecondaryColor,
                AutoButtonColor = false,
                Text = "",
                ClipsDescendants = true
            })
            
            Make("UICorner", {Parent = DropdownFrame, CornerRadius = UDim.new(0, 4)})
            Make("UIStroke", {Parent = DropdownFrame, Color = Theme.Outline, Thickness = 1})
            
            local Title = Make("TextLabel", {
                Parent = DropdownFrame,
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 10, 0.5, -10),
                BackgroundTransparency = 1,
                Text = Name .. ": " .. (MultiSelect and "Select..." or (Default or "Select...")),
                Font = Theme.Font,
                TextColor3 = Theme.TextColor,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ArrowIcon = Make("ImageLabel", {
                Parent = DropdownFrame,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(1, -28, 0.5, -9),
                BackgroundTransparency = 1,
                Image = GetIcon("ChevronDown").Image,
                ImageColor3 = Theme.TextDark
            })
            
            local Menu = Make("Frame", {
                Parent = DropdownFrame,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 38 * ScaleFactor),
                BackgroundColor3 = Theme.SecondaryColor,
                BorderSizePixel = 0,
                ZIndex = 2
            })
            
            Make("UICorner", {Parent = Menu, CornerRadius = UDim.new(0, 4)})
            Make("UIListLayout", {
                Parent = Menu,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 0)
            })
            
            local SearchBox = nil
            if ShowSearch then
                SearchBox = Make("TextBox", {
                    Parent = Menu,
                    Size = UDim2.new(1, 0, 0, 30 * ScaleFactor),
                    BackgroundColor3 = Theme.MainColor,
                    BorderSizePixel = 0,
                    PlaceholderText = "Search...",
                    Font = Theme.Font,
                    TextColor3 = Theme.TextColor,
                    TextSize = 13 * ScaleFactor,
                    PlaceholderColor3 = Theme.TextDark,
                    ZIndex = 3
                })
                
                Make("UICorner", {Parent = SearchBox, CornerRadius = UDim.new(0, 4)})
                Make("UIPadding", {
                    Parent = SearchBox,
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10)
                })
            end
            
            local OptionContainer = Make("ScrollingFrame", {
                Parent = Menu,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Theme.AccentColor,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ZIndex = 3
            })
            
            Make("UIListLayout", {
                Parent = OptionContainer,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2)
            })
            
            Make("UIPadding", {
                Parent = OptionContainer,
                PaddingTop = UDim.new(0, 2),
                PaddingBottom = UDim.new(0, 2)
            })
            
            local function CreateOption(OptionData)
                local OptionName = type(OptionData) == "string" and OptionData or OptionData.Name
                local OptionDesc = type(OptionData) == "table" and OptionData.Desc
                
                local OptionBtn = Make("TextButton", {
                    Parent = OptionContainer,
                    Size = UDim2.new(1, 0, 0, 32 * ScaleFactor),
                    BackgroundColor3 = Theme.MainColor,
                    AutoButtonColor = false,
                    Text = "",
                    ZIndex = 3
                })
                
                Make("UICorner", {Parent = OptionBtn, CornerRadius = UDim.new(0, 3)})
                
                local OptTitle = Make("TextLabel", {
                    Parent = OptionBtn,
                    Size = UDim2.new(1, -10, 0, 20),
                    Position = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1,
                    Text = OptionName,
                    Font = Theme.Font,
                    TextColor3 = Theme.TextColor,
                    TextSize = 13 * ScaleFactor,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                if OptionDesc then
                    local OptDesc = Make("TextLabel", {
                        Parent = OptionBtn,
                        Size = UDim2.new(1, -10, 0, 20),
                        Position = UDim2.new(0, 10, 0, 18),
                        BackgroundTransparency = 1,
                        Text = OptionDesc,
                        Font = Theme.Font,
                        TextColor3 = Theme.TextDark,
                        TextSize = 11 * ScaleFactor,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                end
                
                if MultiSelect then
                    local CheckBox = Make("ImageLabel", {
                        Parent = OptionBtn,
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(1, -26, 0.5, -8),
                        BackgroundTransparency = 1,
                        Image = GetIcon("Check").Image,
                        ImageColor3 = Theme.AccentColor,
                        ImageTransparency = 1
                    })
                    
                    OptionBtn.CheckBox = CheckBox
                end
                
                return OptionBtn
            end
            
            local function RefreshOptions()
                for _, Child in ipairs(OptionContainer:GetChildren()) do
                    if Child:IsA("TextButton") then
                        Child:Destroy()
                    end
                end
                
                for _, Option in ipairs(Options) do
                    local OptionBtn = CreateOption(Option)
                    
                    OptionBtn.MouseButton1Click:Connect(function()
                        local OptionName = type(Option) == "string" and Option or Option.Name
                        
                        if MultiSelect then
                            local IsSelected = false
                            for i, Selected in ipairs(SelectedValues) do
                                local SelectedName = type(Selected) == "string" and Selected or Selected.Name
                                if SelectedName == OptionName then
                                    table.remove(SelectedValues, i)
                                    IsSelected = true
                                    break
                                end
                            end
                            
                            if not IsSelected then
                                table.insert(SelectedValues, Option)
                            end
                            
                            local SelectedNames = {}
                            for _, V in ipairs(SelectedValues) do
                                table.insert(SelectedNames, type(V) == "string" and V or V.Name)
                            end
                            
                            Title.Text = Name .. ": " .. (#SelectedNames > 0 and table.concat(SelectedNames, ", ") or "Select...")
                            
                            task.spawn(Callback, SelectedValues)
                        else
                            SelectedValues = Option
                            Title.Text = Name .. ": " .. OptionName
                            task.spawn(Callback, Option)
                        end
                        
                        if not MultiSelect then
                            IsOpen = false
                            Tween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 38 * ScaleFactor)})
                            Tween(ArrowIcon, 0.2, {Rotation = 0})
                        end
                    end)
                end
            end
            
            local function FilterOptions(SearchTerm)
                SearchTerm = string.lower(SearchTerm)
                for _, Child in ipairs(OptionContainer:GetChildren()) do
                    if Child:IsA("TextButton") then
                        local Text = string.lower(Child:FindFirstChild("TextLabel") and Child.TextLabel.Text or "")
                        Child.Visible = string.find(Text, SearchTerm, 1, true) ~= nil
                    end
                end
            end
            
            if SearchBox then
                SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    FilterOptions(SearchBox.Text)
                end)
            end
            
            DropdownFrame.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                RefreshOptions()
                
                if IsOpen then
                    local VisibleOptions = 0
                    for _, Child in ipairs(OptionContainer:GetChildren()) do
                        if Child:IsA("TextButton") and Child.Visible then
                            VisibleOptions = VisibleOptions + 1
                        end
                    end
                    
                    local MenuHeight = math.min(VisibleOptions * 32 * ScaleFactor + (SearchBox and 30 * ScaleFactor or 0), 250 * ScaleFactor)
                    Tween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, (38 + MenuHeight) * ScaleFactor)})
                    Tween(ArrowIcon, 0.2, {Rotation = 180})
                else
                    Tween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 38 * ScaleFactor)})
                    Tween(ArrowIcon, 0.2, {Rotation = 0})
                end
            end)
            
            RefreshOptions()
            
            table.insert(TabData.Components, DropdownFrame)
            return DropdownFrame
        end
        
        function TabFunctions:ColorPicker(Config)
            Config = Config or {}
            local Name = Config.Name or "Color Picker"
            local Default = Config.Default or Color3.fromRGB(255, 255, 255)
            local Transparency = Config.Transparency or false
            local Callback = Config.Callback or function() end
            
            local IsOpen = false
            local CurrentColor = Default
            local CurrentTransparency = Transparency and 0 or nil
            
            local PickerFrame = Make("TextButton", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 38 * ScaleFactor),
                BackgroundColor3 = Theme.SecondaryColor,
                AutoButtonColor = false,
                Text = "",
                ClipsDescendants = true
            })
            
            Make("UICorner", {Parent = PickerFrame, CornerRadius = UDim.new(0, 4)})
            Make("UIStroke", {Parent = PickerFrame, Color = Theme.Outline, Thickness = 1})
            
            local Title = Make("TextLabel", {
                Parent = PickerFrame,
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 10, 0.5, -10),
                BackgroundTransparency = 1,
                Text = Name,
                Font = Theme.Font,
                TextColor3 = Theme.TextColor,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Preview = Make("Frame", {
                Parent = PickerFrame,
                Size = UDim2.new(0, 24, 0, 24),
                Position = UDim2.new(1, -34, 0.5, -12),
                BackgroundColor3 = CurrentColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = Preview, CornerRadius = UDim.new(0, 4)})
            
            local TransparencyFrame = nil
            if Transparency then
                TransparencyFrame = Make("ImageLabel", {
                    Parent = Preview,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = CurrentTransparency,
                    Image = "rbxassetid://14204231522",
                    ImageTransparency = 0.45,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0, 10, 0, 10)
                })
                
                Make("UICorner", {Parent = TransparencyFrame, CornerRadius = UDim.new(0, 4)})
            end
            
            local Hue, Sat, Val = Color3.toHSV(CurrentColor)
            
            local PickerContent = Make("Frame", {
                Parent = PickerFrame,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 38 * ScaleFactor),
                BackgroundTransparency = 1,
                ZIndex = 2
            })
            
            local PickerLayout = Make("UIListLayout", {
                Parent = PickerContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            })
            
            Make("UIPadding", {
                Parent = PickerContent,
                PaddingTop = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10)
            })
            
            local ColorWheel = Make("ImageButton", {
                Parent = PickerContent,
                Size = UDim2.new(0, 150 * ScaleFactor, 0, 150 * ScaleFactor),
                BackgroundTransparency = 1,
                Image = "rbxassetid://12522852558",
                ZIndex = 2
            })
            
            local ColorWheelHandle = Make("Frame", {
                Parent = ColorWheel,
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0.5, -6, 0.5, -6),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 3
            })
            
            Make("UICorner", {Parent = ColorWheelHandle, CornerRadius = UDim.new(1, 0)})
            Make("UIStroke", {Parent = ColorWheelHandle, Color = Color3.new(0, 0, 0), Thickness = 2})
            
            local HueSlider = Make("Frame", {
                Parent = PickerContent,
                Size = UDim2.new(0, 20 * ScaleFactor, 0, 150 * ScaleFactor),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 2
            })
            
            local HueGradient = Make("UIGradient", {
                Parent = HueSlider,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }),
                Rotation = 90
            })
            
            local HueHandle = Make("Frame", {
                Parent = HueSlider,
                Size = UDim2.new(1, 0, 0, 4),
                Position = UDim2.new(0, 0, 0, -2),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 3
            })
            
            Make("UICorner", {Parent = HueHandle, CornerRadius = UDim.new(0, 2)})
            Make("UIStroke", {Parent = HueHandle, Color = Color3.new(0, 0, 0), Thickness = 1})
            
            local InputContainer = Make("Frame", {
                Parent = PickerContent,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2
            })
            
            Make("UIListLayout", {
                Parent = InputContainer,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
                FillDirection = Enum.FillDirection.Horizontal
            })
            
            local function CreateInput(Label, Value, OnChanged)
                local InputFrame = Make("Frame", {
                    Parent = InputContainer,
                    Size = UDim2.new(0, 80, 0, 30),
                    BackgroundColor3 = Theme.MainColor,
                    BorderSizePixel = 0,
                    ZIndex = 3
                })
                
                Make("UICorner", {Parent = InputFrame, CornerRadius = UDim.new(0, 4)})
                Make("UIStroke", {Parent = InputFrame, Color = Theme.Outline, Thickness = 1})
                
                local InputLabel = Make("TextLabel", {
                    Parent = InputFrame,
                    Size = UDim2.new(1, 0, 0, 12),
                    Position = UDim2.new(0, 5, 0, 2),
                    BackgroundTransparency = 1,
                    Text = Label,
                    Font = Theme.Font,
                    TextColor3 = Theme.TextDark,
                    TextSize = 10 * ScaleFactor,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local TextBox = Make("TextBox", {
                    Parent = InputFrame,
                    Size = UDim2.new(1, -10, 0, 16),
                    Position = UDim2.new(0, 5, 0, 14),
                    BackgroundTransparency = 1,
                    Text = tostring(Value),
                    Font = Theme.Font,
                    TextColor3 = Theme.TextColor,
                    TextSize = 12 * ScaleFactor,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                TextBox.FocusLost:Connect(function()
                    OnChanged(TextBox.Text)
                end)
                
                return TextBox
            end
            
            local RBox = CreateInput("R", math.floor(CurrentColor.R * 255), function(Value)
                local NewR = math.clamp(tonumber(Value) or 0, 0, 255)
                CurrentColor = Color3.fromRGB(NewR, math.floor(CurrentColor.G * 255), math.floor(CurrentColor.B * 255))
                Hue, Sat, Val = Color3.toHSV(CurrentColor)
                UpdateColor()
            end)
            
            local GBox = CreateInput("G", math.floor(CurrentColor.G * 255), function(Value)
                local NewG = math.clamp(tonumber(Value) or 0, 0, 255)
                CurrentColor = Color3.fromRGB(math.floor(CurrentColor.R * 255), NewG, math.floor(CurrentColor.B * 255))
                Hue, Sat, Val = Color3.toHSV(CurrentColor)
                UpdateColor()
            end)
            
            local BBox = CreateInput("B", math.floor(CurrentColor.B * 255), function(Value)
                local NewB = math.clamp(tonumber(Value) or 0, 0, 255)
                CurrentColor = Color3.fromRGB(math.floor(CurrentColor.R * 255), math.floor(CurrentColor.G * 255), NewB)
                Hue, Sat, Val = Color3.toHSV(CurrentColor)
                UpdateColor()
            end)
            
            local function UpdateColor()
                Preview.BackgroundColor3 = CurrentColor
                
                if Transparency and TransparencyFrame then
                    TransparencyFrame.BackgroundTransparency = CurrentTransparency
                end
                
                task.spawn(Callback, CurrentColor, CurrentTransparency)
            end
            
            local function OnColorWheel(Input)
                local Position = Input.Position
                local Center = ColorWheel.AbsolutePosition + ColorWheel.AbsoluteSize / 2
                local Direction = (Position - Center)
                local Distance = math.min(Direction.Magnitude / (ColorWheel.AbsoluteSize.X / 2), 1)
                
                Sat = Distance
                Val = 1
                
                local Angle = math.atan2(Direction.Y, Direction.X) + math.pi
                Hue = Angle / (math.pi * 2)
                
                CurrentColor = Color3.fromHSV(Hue, Sat, Val)
                UpdateColor()
                
                local HandlePos = UDim2.new(0.5, Direction.X / (ColorWheel.AbsoluteSize.X / 2) * 75 - 6, 0.5, Direction.Y / (ColorWheel.AbsoluteSize.Y / 2) * 75 - 6)
                Tween(ColorWheelHandle, 0.05, {Position = HandlePos})
                
                RBox.Text = math.floor(CurrentColor.R * 255)
                GBox.Text = math.floor(CurrentColor.G * 255)
                BBox.Text = math.floor(CurrentColor.B * 255)
            end
            
            local function OnHueSlider(Input)
                local Position = Input.Position
                local Percent = math.clamp((Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                
                Hue = Percent
                CurrentColor = Color3.fromHSV(Hue, Sat, Val)
                UpdateColor()
                
                local HandlePos = UDim2.new(0, -2, 0, Percent * HueSlider.AbsoluteSize.Y - 2)
                Tween(HueHandle, 0.05, {Position = HandlePos})
                
                RBox.Text = math.floor(CurrentColor.R * 255)
                GBox.Text = math.floor(CurrentColor.G * 255)
                BBox.Text = math.floor(CurrentColor.B * 255)
            end
            
            ColorWheel.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    OnColorWheel(Input)
                    
                    local Connection
                    Connection = Services.UserInputService.InputChanged:Connect(function(Input2)
                        if Input2.UserInputType == Enum.UserInputType.MouseMovement or Input2.UserInputType == Enum.UserInputType.Touch then
                            OnColorWheel(Input2)
                        end
                    end)
                    
                    Services.UserInputService.InputEnded:Connect(function(Input2)
                        if Input2.UserInputType == Enum.UserInputType.MouseButton1 or Input2.UserInputType == Enum.UserInputType.Touch then
                            if Connection then Connection:Disconnect() end
                        end
                    end)
                end
            end)
            
            HueSlider.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    OnHueSlider(Input)
                    
                    local Connection
                    Connection = Services.UserInputService.InputChanged:Connect(function(Input2)
                        if Input2.UserInputType == Enum.UserInputType.MouseMovement or Input2.UserInputType == Enum.UserInputType.Touch then
                            OnHueSlider(Input2)
                        end
                    end)
                    
                    Services.UserInputService.InputEnded:Connect(function(Input2)
                        if Input2.UserInputType == Enum.UserInputType.MouseButton1 or Input2.UserInputType == Enum.UserInputType.Touch then
                            if Connection then Connection:Disconnect() end
                        end
                    end)
                end
            end)
            
            PickerFrame.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                if IsOpen then
                    local ContentHeight = 150 * ScaleFactor + 30 * ScaleFactor + (Transparency and 30 * ScaleFactor or 0) + 40
                    Tween(PickerFrame, 0.2, {Size = UDim2.new(1, 0, 0, (38 + ContentHeight) * ScaleFactor)})
                else
                    Tween(PickerFrame, 0.2, {Size = UDim2.new(1, 0, 0, 38 * ScaleFactor)})
                end
            end)
            
            UpdateColor()
            
            table.insert(TabData.Components, PickerFrame)
            return PickerFrame
        end
        
        function TabFunctions:Input(Config)
            Config = Config or {}
            local Name = Config.Name or "Input"
            local Default = Config.Default or ""
            local Placeholder = Config.Placeholder or ""
            local Callback = Config.Callback or function() end
            local Type = Config.Type or "text"
            
            local InputFrame = Make("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 38 * ScaleFactor),
                BackgroundColor3 = Theme.SecondaryColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = InputFrame, CornerRadius = UDim.new(0, 4)})
            Make("UIStroke", {Parent = InputFrame, Color = Theme.Outline, Thickness = 1})
            
            local Title = Make("TextLabel", {
                Parent = InputFrame,
                Size = UDim2.new(1, -150, 0, 20),
                Position = UDim2.new(0, 10, 0.5, -10),
                BackgroundTransparency = 1,
                Text = Name .. ":",
                Font = Theme.Font,
                TextColor3 = Theme.TextColor,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local TextBox = Make("TextBox", {
                Parent = InputFrame,
                Size = UDim2.new(0, 120, 0, 26),
                Position = UDim2.new(1, -130, 0.5, -13),
                BackgroundColor3 = Theme.MainColor,
                BorderSizePixel = 0,
                Text = Default,
                Font = Theme.Font,
                TextColor3 = Theme.TextColor,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = Placeholder,
                ClearTextOnFocus = false
            })
            
            Make("UICorner", {Parent = TextBox, CornerRadius = UDim.new(0, 3)})
            Make("UIPadding", {Parent = TextBox, PaddingLeft = UDim.new(0, 6)})
            
            TextBox.FocusLost:Connect(function()
                task.spawn(Callback, TextBox.Text)
            end)
            
            table.insert(TabData.Components, InputFrame)
            return InputFrame
        end
        
        function TabFunctions:Keybind(Config)
            Config = Config or {}
            local Name = Config.Name or "Keybind"
            local Default = Config.Default or Enum.KeyCode.F
            local Callback = Config.Callback or function() end
            
            local KeybindFrame = Make("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 38 * ScaleFactor),
                BackgroundColor3 = Theme.SecondaryColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = KeybindFrame, CornerRadius = UDim.new(0, 4)})
            Make("UIStroke", {Parent = KeybindFrame, Color = Theme.Outline, Thickness = 1})
            
            local Title = Make("TextLabel", {
                Parent = KeybindFrame,
                Size = UDim2.new(1, -150, 0, 20),
                Position = UDim2.new(0, 10, 0.5, -10),
                BackgroundTransparency = 1,
                Text = Name .. ":",
                Font = Theme.Font,
                TextColor3 = Theme.TextColor,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local KeybindBtn = Make("TextButton", {
                Parent = KeybindFrame,
                Size = UDim2.new(0, 80, 0, 26),
                Position = UDim2.new(1, -90, 0.5, -13),
                BackgroundColor3 = Theme.MainColor,
                BorderSizePixel = 0,
                Font = Theme.Font,
                TextColor3 = Theme.TextColor,
                TextSize = 12 * ScaleFactor,
                Text = Default.Name or "F",
                AutoButtonColor = false
            })
            
            Make("UICorner", {Parent = KeybindBtn, CornerRadius = UDim.new(0, 3)})
            
            local Listening = false
            KeybindBtn.MouseButton1Click:Connect(function()
                Listening = true
                KeybindBtn.Text = "Listening..."
                
                local Connection
                Connection = Services.UserInputService.InputBegan:Connect(function(Input, GPE)
                    if GPE then return end
                    if not Listening then return end
                    
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        KeybindBtn.Text = Input.KeyCode.Name
                        Default = Input.KeyCode
                        Listening = false
                        Connection:Disconnect()
                        
                        Window.KeybindManager:Remove(Default)
                        Window.KeybindManager:Add(Default, function()
                            task.spawn(Callback)
                        end, Name)
                    end
                end)
                
                task.wait(5)
                if Listening then
                    Listening = false
                    KeybindBtn.Text = Default.Name
                    Connection:Disconnect()
                end
            end)
            
            Window.KeybindManager:Add(Default, function()
                task.spawn(Callback)
            end, Name)
            
            table.insert(TabData.Components, KeybindFrame)
            return KeybindFrame
        end
        
        function TabFunctions:Label(Config)
            Config = Config or {}
            local Text = Config.Text or "Label"
            local Icon = Config.Icon
            
            local LabelFrame = Make("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 38 * ScaleFactor),
                BackgroundColor3 = Theme.SecondaryColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = LabelFrame, CornerRadius = UDim.new(0, 4)})
            Make("UIStroke", {Parent = LabelFrame, Color = Theme.Outline, Thickness = 1})
            
            if Icon then
                local LabelIcon = Make("ImageLabel", {
                    Parent = LabelFrame,
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(0, 12, 0.5, -9),
                    BackgroundTransparency = 1,
                    Image = GetIcon(Icon).Image,
                    ImageColor3 = Theme.TextColor
                })
            end
            
            local Label = Make("TextLabel", {
                Parent = LabelFrame,
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, Icon and 40 or 10, 0.5, -10),
                BackgroundTransparency = 1,
                Text = Text,
                Font = Theme.Font,
                TextColor3 = Theme.TextColor,
                TextSize = 14 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            table.insert(TabData.Components, LabelFrame)
            return LabelFrame
        end
        
        function TabFunctions:CodeEditor(Config)
            Config = Config or {}
            local Code = Config.Code or "-- Your code here"
            local Title = Config.Title or "Code Editor"
            
            local Editor = CodeEditor:New(Page, Code, Title, function()
                Window:Notify({
                    Title = "Code Copied",
                    Content = "Code has been copied to clipboard",
                    Duration = 2
                })
            end)
            
            table.insert(TabData.Components, Editor.Frame)
            return Editor
        end
        
        function TabFunctions:DataView(Config)
            Config = Config or {}
            local Data = Config.Data or {}
            local Columns = Config.Columns or {"Key", "Value"}
            
            local DataFrame = Make("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 200),
                BackgroundColor3 = Theme.SecondaryColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = DataFrame, CornerRadius = UDim.new(0, 6)})
            Make("UIStroke", {Parent = DataFrame, Color = Theme.Outline, Thickness = 1})
            
            local Header = Make("Frame", {
                Parent = DataFrame,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Theme.MainColor,
                BorderSizePixel = 0
            })
            
            Make("UICorner", {Parent = Header, CornerRadius = UDim.new(0, 4)})
            
            local HeaderLayout = Make("UIListLayout", {
                Parent = Header,
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 5)
            })
            
            Make("UIPadding", {
                Parent = Header,
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
            
            for _, Column in ipairs(Columns) do
                local HeaderLabel = Make("TextLabel", {
                    Parent = Header,
                    Size = UDim2.new(0, 100, 0, 30),
                    BackgroundTransparency = 1,
                    Text = Column,
                    Font = Theme.BoldFont,
                    TextColor3 = Theme.TextColor,
                    TextSize = 13 * ScaleFactor,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end
            
            local ScrollFrame = Make("ScrollingFrame", {
                Parent = DataFrame,
                Size = UDim2.new(1, 0, 1, -30),
                Position = UDim2.new(0, 0, 0, 30),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Theme.AccentColor,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0, 0, 0, 0)
            })
            
            Make("UIListLayout", {
                Parent = ScrollFrame,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 1)
            })
            
            local function AddRow(RowData)
                local Row = Make("Frame", {
                    Parent = ScrollFrame,
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = #ScrollFrame:GetChildren() % 2 == 0 and Theme.MainColor or Theme.SecondaryColor,
                    BorderSizePixel = 0
                })
                
                local RowLayout = Make("UIListLayout", {
                    Parent = Row,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 5)
                })
                
                Make("UIPadding", {
                    Parent = Row,
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10)
                })
                
                for _, Value in ipairs(RowData) do
                    local Cell = Make("TextLabel", {
                        Parent = Row,
                        Size = UDim2.new(0, 100, 0, 28),
                        BackgroundTransparency = 1,
                        Text = tostring(Value),
                        Font = Theme.Font,
                        TextColor3 = Theme.TextColor,
                        TextSize = 12 * ScaleFactor,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd
                    })
                end
                
                return Row
            end
            
            for _, Row in ipairs(Data) do
                AddRow(Row)
            end
            
            table.insert(TabData.Components, DataFrame)
            
            return {
                Frame = DataFrame,
                AddRow = AddRow,
                Clear = function()
                    for _, Child in ipairs(ScrollFrame:GetChildren()) do
                        if Child:IsA("Frame") then
                            Child:Destroy()
                        end
                    end
                end
            }
        end
        
        function TabFunctions:Paragraph(Config)
            Config = Config or {}
            local Title = Config.Title or "Paragraph"
            local Content = Config.Content or "This is a paragraph component."
            
            local ParagraphFrame = Make("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Theme.SecondaryColor,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y
            })
            
            Make("UICorner", {Parent = ParagraphFrame, CornerRadius = UDim.new(0, 4)})
            Make("UIStroke", {Parent = ParagraphFrame, Color = Theme.Outline, Thickness = 1})
            
            Make("UIPadding", {
                Parent = ParagraphFrame,
                PaddingTop = UDim.new(0, 15),
                PaddingBottom = UDim.new(0, 15),
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15)
            })
            
            local UILayout = Make("UIListLayout", {
                Parent = ParagraphFrame,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            })
            
            if Title ~= "" then
                local TitleLabel = Make("TextLabel", {
                    Parent = ParagraphFrame,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = Title,
                    Font = Theme.BoldFont,
                    TextColor3 = Theme.TextColor,
                    TextSize = 16 * ScaleFactor,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end
            
            local ContentLabel = Make("TextLabel", {
                Parent = ParagraphFrame,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = Content,
                Font = Theme.Font,
                TextColor3 = Theme.TextDark,
                TextSize = 13 * ScaleFactor,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y
            })
            
            table.insert(TabData.Components, ParagraphFrame)
            return ParagraphFrame
        end
        
        return TabFunctions
    end
    
    function WindowFunctions:Notify(Config)
        self.NotificationManager:Notify(Config)
    end
    
    function WindowFunctions:Open()
        IsOpen = true
        MainFrame.Visible = true
        Tween(MainFrame, 0.3, {GroupTransparency = 0, Size = UDim2.fromOffset(650 * ScaleFactor, 450 * ScaleFactor)})
    end
    
    function WindowFunctions:Close()
        IsOpen = false
        Tween(MainFrame, 0.3, {GroupTransparency = 1, Size = UDim2.fromOffset(650 * ScaleFactor, 440 * ScaleFactor)})
        task.delay(0.3, function() if not IsOpen then MainFrame.Visible = false end end)
    end
    
    function WindowFunctions:SetTheme(NewTheme)
        Theme = NewTheme
        for _, Tab in pairs(Tabs) do
            for _, Component in ipairs(Tab.Components) do
                if Component:IsA("Frame") then
                    Tween(Component, 0.2, {BackgroundColor3 = Theme.SecondaryColor})
                end
            end
        end
    end
    
    function WindowFunctions:SaveConfig(Name, Data)
        if self.ConfigManager then
            return self.ConfigManager:SaveConfig(Name, Data)
        end
        return false
    end
    
    function WindowFunctions:LoadConfig(Name)
        if self.ConfigManager then
            return self.ConfigManager:LoadConfig(Name)
        end
        return nil
    end
    
    function WindowFunctions:DeleteConfig(Name)
        if self.ConfigManager then
            return self.ConfigManager:DeleteConfig(Name)
        end
        return false
    end
    
    function WindowFunctions:GetConfigNames()
        if self.ConfigManager then
            return self.ConfigManager:GetConfigNames()
        end
        return {}
    end
    
    function WindowFunctions:AddKeybind(Key, Callback, Description)
        self.KeybindManager:Add(Key, Callback, Description)
    end
    
    function WindowFunctions:RemoveKeybind(Key)
        self.KeybindManager:Remove(Key)
    end
    
    function WindowFunctions:ShowTooltip(Text, Position)
        self.TooltipManager:Show(Text, Position)
    end
    
    function WindowFunctions:HideTooltip()
        self.TooltipManager:Hide()
    end
    
    task.spawn(function()
        task.wait(0.5)
        ContentDetector:DetectEmptyPages(WindowFunctions)
    end)
    
    if Config.SaveConfigs then
        ScreenGui.AncestryChanged:Connect(function()
            if not ScreenGui.Parent then
                if WindowFunctions.CurrentConfig then
                    WindowFunctions:SaveConfig("autosave", WindowFunctions.CurrentConfig)
                end
            end
        end)
    end
    
    return WindowFunctions
end

return StarLight