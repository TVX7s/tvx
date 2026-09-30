local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local UIS = UserInputService
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local LP = LocalPlayer
local player = LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomScriptUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local BLOOD_MOON_NAME = "BloodMoonSky"
local COLOR_NAME = "BloodMoonColor"
local ATMOSPHERE_NAME = "BloodMoonAtmosphere"

local function createBloodMoon()
    local Sky = Lighting:FindFirstChild(BLOOD_MOON_NAME)

    if not Sky or not Sky:IsA("Sky") then
        if Sky then
            Sky:Destroy()
        end

        Sky = Instance.new("Sky")
        Sky.Name = BLOOD_MOON_NAME
        Sky.Parent = Lighting
    end

    Sky.SkyboxBk = "rbxassetid://159454299"
    Sky.SkyboxDn = "rbxassetid://159454299"
    Sky.SkyboxFt = "rbxassetid://159454299"
    Sky.SkyboxLf = "rbxassetid://159454299"
    Sky.SkyboxRt = "rbxassetid://159454299"
    Sky.SkyboxUp = "rbxassetid://159454299"

    Sky.SunAngularSize = 0
    Sky.MoonAngularSize = 20
    Sky.MoonTextureId = "rbxasset://sky/moon.jpg"

    Lighting.ClockTime = 0
    Lighting.Brightness = 3
    Lighting.ExposureCompensation = 0.7
    Lighting.Ambient = Color3.fromRGB(170, 70, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 60, 60)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 80, 80)
    Lighting.ColorShift_Bottom = Color3.fromRGB(120, 50, 50)

    local ColorCorrection = Lighting:FindFirstChild(COLOR_NAME)

    if not ColorCorrection or not ColorCorrection:IsA("ColorCorrectionEffect") then
        if ColorCorrection then
            ColorCorrection:Destroy()
        end

        ColorCorrection = Instance.new("ColorCorrectionEffect")
        ColorCorrection.Name = COLOR_NAME
        ColorCorrection.Parent = Lighting
    end

    ColorCorrection.TintColor = Color3.fromRGB(255, 150, 150)
    ColorCorrection.Contrast = 0.05
    ColorCorrection.Saturation = 0
    ColorCorrection.Brightness = 0.1

    local Atmosphere = Lighting:FindFirstChild(ATMOSPHERE_NAME)

    if not Atmosphere or not Atmosphere:IsA("Atmosphere") then
        if Atmosphere then
            Atmosphere:Destroy()
        end

        Atmosphere = Instance.new("Atmosphere")
        Atmosphere.Name = ATMOSPHERE_NAME
        Atmosphere.Parent = Lighting
    end

    Atmosphere.Density = 0.2
    Atmosphere.Offset = 0.1
    Atmosphere.Color = Color3.fromRGB(255, 100, 100)
    Atmosphere.Decay = Color3.fromRGB(120, 20, 20)
    Atmosphere.Glare = 0.15
    Atmosphere.Haze = 0.5
end

createBloodMoon()

Lighting.ChildAdded:Connect(function()
    task.wait()
    createBloodMoon()
end)

Lighting.ChildRemoved:Connect(function()
    task.wait()
    createBloodMoon()
end)

task.spawn(function()
    while task.wait(0.5) do
        createBloodMoon()
    end
end)

local lp = Players.LocalPlayer

local STEAL_RADIUS = 60
local STEAL_DURATION = 1.4
local isStealing = false
local StealData = {}
local progressBarBg = nil
local progressFill = nil
local percentLabel = nil
local bannerFrame = nil
local infoLabel = nil

local THEME_COLOR = Color3.fromRGB(139, 0, 0)
local DARK_BG = Color3.fromRGB(15, 0, 0)

local function AddCorner(Object, Radius)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = Radius or UDim.new(0, 8)
    Corner.Parent = Object
end

local function CreateTextGlowStroke(Object)
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Object
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 2
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    Stroke.LineJoinMode = Enum.LineJoinMode.Round

    local Gradient = Instance.new("UIGradient")
    Gradient.Parent = Stroke
    Gradient.Rotation = 0
    Gradient.Offset = Vector2.new(-1, 0)

    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 180, 180)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }

    local AnimationInfo = TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    local Track = TweenService:Create(Gradient, AnimationInfo, {Offset = Vector2.new(1, 0)})
    Track:Play()
end

local function CreateMainBorderStroke(Object)
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Object
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 3
    Stroke.Transparency = 0
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.LineJoinMode = Enum.LineJoinMode.Round

    local Gradient = Instance.new("UIGradient")
    Gradient.Parent = Stroke
    Gradient.Rotation = 0

    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.15, Color3.fromRGB(30, 0, 0)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.85, Color3.fromRGB(30, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    }

    local AnimationInfo = TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    local Track = TweenService:Create(Gradient, AnimationInfo, {Rotation = 360})
    Track:Play()
end

local function updateTopBar()
    if not infoLabel then return end
    local fps = 60
    local ping = 0
    local framesCount = 0
    local last = tick()
    RunService.RenderStepped:Connect(function()
        framesCount = framesCount + 1
        if tick() - last >= 1 then
            fps = framesCount
            framesCount = 0
            last = tick()
        end
        local network = Stats:FindFirstChild("Network")
        if network and network:FindFirstChild("ServerStatsItem") then
            local dataPing = network.ServerStatsItem:FindFirstChild("Data Ping")
            if dataPing then ping = math.floor(dataPing:GetValue()) end
        end
        infoLabel.Text = "7z Steal For Brainrot| Ping: " .. ping .. "ms | FPS: " .. fps
    end)
end

local function setupUI()
    local sg = lp.PlayerGui:FindFirstChild("7z Steal")
    if not sg then
        sg = Instance.new("ScreenGui")
        sg.Name = "7z Steal"
        sg.ResetOnSpawn = false
        sg.Parent = lp.PlayerGui
    end

    if not progressBarBg then
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0, 320, 0, 70)
        container.Position = UDim2.new(0.5, -160, 0, 35)
        container.BackgroundTransparency = 1
        container.ZIndex = 10
        container.Parent = sg

        bannerFrame = Instance.new("Frame")
        bannerFrame.Size = UDim2.new(1, 0, 0, 30)
        bannerFrame.Position = UDim2.new(0, 0, 0, 0)
        bannerFrame.BackgroundColor3 = THEME_COLOR
        bannerFrame.BackgroundTransparency = 0.85
        bannerFrame.BorderSizePixel = 0
        bannerFrame.ZIndex = 10
        bannerFrame.Parent = container
        AddCorner(bannerFrame, UDim.new(0, 6))
        CreateMainBorderStroke(bannerFrame)

        local iconImage = Instance.new("ImageLabel")
        iconImage.Name = "IconImage"
        iconImage.Size = UDim2.new(0, 22, 0, 22)
        iconImage.Position = UDim2.new(0, 6, 0.5, -11)
        iconImage.BackgroundTransparency = 1
        iconImage.Image = "rbxassetid://136450335437647"
        iconImage.ZIndex = 12
        iconImage.Parent = bannerFrame

        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(1, 0)
        iconCorner.Parent = iconImage
        CreateMainBorderStroke(iconImage)

        infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, -34, 1, 0)
        infoLabel.Position = UDim2.new(0, 30, 0, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.TextSize = 14
        infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoLabel.Text = "7z Steal For Brainrot | Ping: 0ms | FPS: 0"
        infoLabel.TextXAlignment = Enum.TextXAlignment.Center
        infoLabel.ZIndex = 11
        infoLabel.Parent = bannerFrame
        CreateTextGlowStroke(infoLabel)

        progressBarBg = Instance.new("Frame")
        progressBarBg.Size = UDim2.new(1, 0, 0, 14)
        progressBarBg.Position = UDim2.new(0, 0, 0, 34)
        progressBarBg.BackgroundColor3 = DARK_BG
        progressBarBg.BackgroundTransparency = 0.25
        progressBarBg.Visible = true
        progressBarBg.ZIndex = 10
        progressBarBg.Parent = container
        AddCorner(progressBarBg, UDim.new(0, 6))
        CreateMainBorderStroke(progressBarBg)

        progressFill = Instance.new("Frame")
        progressFill.Size = UDim2.new(0, 0, 1, 0)
        progressFill.BackgroundColor3 = THEME_COLOR
        progressFill.ZIndex = 11
        progressFill.Parent = progressBarBg
        AddCorner(progressFill, UDim.new(0, 6))
        CreateMainBorderStroke(progressFill)

        percentLabel = Instance.new("TextLabel")
        percentLabel.Size = UDim2.new(1, 0, 1, 0)
        percentLabel.BackgroundTransparency = 1
        percentLabel.Font = Enum.Font.GothamBold
        percentLabel.TextSize = 11
        percentLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        percentLabel.Text = "0%"
        percentLabel.ZIndex = 12
        percentLabel.Parent = progressBarBg
        CreateTextGlowStroke(percentLabel)

        updateTopBar()
    end
end

local function getHRP()
    local c = lp.Character
    if c then return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso") end
    return nil
end

local function isMyPlotByName(pn)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(pn)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function findNearestPrompt()
    local hrp = getHRP()
    if not hrp then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        pcall(function()
            if isMyPlotByName(plot.Name) then return end
            local pods = plot:FindFirstChild("AnimalPodiums")
            if not pods then return end
            for _, pod in ipairs(pods:GetChildren()) do
                local base = pod:FindFirstChild("Base")
                if not base then continue end
                local spawn = base:FindFirstChild("Spawn")
                if not spawn then continue end
                local d = (spawn.Position - hrp.Position).Magnitude
                if d <= STEAL_RADIUS and d < dist then
                    local att = spawn:FindFirstChild("PromptAttachment")
                    if att then
                        for _, p in ipairs(att:GetChildren()) do
                            if p:IsA("ProximityPrompt") and p.ActionText and p.ActionText:lower():find("steal") then
                                nearest, dist = p, d
                            end
                        end
                    end
                end
            end
        end)
    end
    return nearest
end

local function updateProgressBar(p)
    if progressFill then
        progressFill.Size = UDim2.new(p, 0, 1, 0)
    end
    if percentLabel then
        percentLabel.Text = math.floor(p * 100) .. "%"
    end
end

local function executeSteal(prompt)
    if isStealing then return end
    if not StealData[prompt] then
        StealData[prompt] = {hold = {}, trigger = {}, ready = true}
        if getconnections then
            pcall(function()
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(StealData[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(StealData[prompt].trigger, c.Function) end
                end
            end)
        end
    end
    local data = StealData[prompt]
    if not data or not data.ready then return end
    data.ready = false
    isStealing = true
    local startTime = tick()
    task.spawn(function()
        for _, f in ipairs(data.hold) do pcall(f) end
        while tick() - startTime < STEAL_DURATION do
            local elapsed = tick() - startTime
            local p = math.clamp(elapsed / STEAL_DURATION, 0, 1)
            updateProgressBar(p)
            task.wait()
        end
        updateProgressBar(1)
        for _, f in ipairs(data.trigger) do pcall(f) end
        task.wait(0.05)
        updateProgressBar(0)
        data.ready = true
        isStealing = false
    end)
end

local heartbeatConn
local function startAutoSteal()
    setupUI()
    if heartbeatConn then return end
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if isStealing then return end
        local success, prompt = pcall(findNearestPrompt)
        if success and prompt then pcall(executeSteal, prompt) end
    end)
end

local function stopAutoSteal()
    if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
    isStealing = false
    updateProgressBar(0)
end

startAutoSteal()

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 365, 0, 220)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
AddCorner(MainFrame, UDim.new(0, 12))

local Dragging, DragInput, DragStart, StartPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

if MainFrame then
    MainFrame.ClipsDescendants = true

    local BackgroundImage = Instance.new("ImageLabel")
    BackgroundImage.Name = "BackgroundImage"
    BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
    BackgroundImage.AnchorPoint = Vector2.new(0, 0)
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.BorderSizePixel = 0
    BackgroundImage.Image = "rbxassetid://136450335437647"
    BackgroundImage.ScaleType = Enum.ScaleType.Crop
    BackgroundImage.ZIndex = 0
    BackgroundImage.Parent = MainFrame
    AddCorner(BackgroundImage, UDim.new(0, 12))
end

CreateMainBorderStroke(MainFrame)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 200, 0, 30)
TitleLabel.Position = UDim2.new(0, 15, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "7z | ALSAFI"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

CreateTextGlowStroke(TitleLabel)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 26, 0, 26)
ToggleButton.Position = UDim2.new(1, -38, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.Text = "-"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.FredokaOne
ToggleButton.AutoButtonColor = true
ToggleButton.Parent = MainFrame
AddCorner(ToggleButton, UDim.new(0, 6))

CreateMainBorderStroke(ToggleButton)
CreateTextGlowStroke(ToggleButton)

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, 0, 1, -50)
ContentContainer.Position = UDim2.new(0, 0, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local AntiMenuButton = Instance.new("TextButton")
AntiMenuButton.Name = "AntiMenuButton"
AntiMenuButton.Size = UDim2.new(0, 45, 0, 20)
AntiMenuButton.Position = UDim2.new(0, 15, 0, 0)
AntiMenuButton.BackgroundTransparency = 1
AntiMenuButton.Text = "Anti"
AntiMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiMenuButton.TextSize = 14
AntiMenuButton.Font = Enum.Font.FredokaOne
AntiMenuButton.Parent = ContentContainer
AddCorner(AntiMenuButton, UDim.new(0, 4))

CreateTextGlowStroke(AntiMenuButton)

local TopLine1 = Instance.new("Frame")
TopLine1.Name = "TopLine"
TopLine1.Size = UDim2.new(1, 0, 0, 1)
TopLine1.Position = UDim2.new(0, 0, 0, 0)
TopLine1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopLine1.BorderSizePixel = 0
TopLine1.Parent = AntiMenuButton

local BottomLine1 = Instance.new("Frame")
BottomLine1.Name = "BottomLine"
BottomLine1.Size = UDim2.new(1, 0, 0, 1)
BottomLine1.Position = UDim2.new(0, 0, 1, -1)
BottomLine1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BottomLine1.BorderSizePixel = 0
BottomLine1.Parent = AntiMenuButton

local PlayerMenuButton = Instance.new("TextButton")
PlayerMenuButton.Name = "PlayerMenuButton"
PlayerMenuButton.Size = UDim2.new(0, 55, 0, 20)
PlayerMenuButton.Position = UDim2.new(0, 70, 0, 0)
PlayerMenuButton.BackgroundTransparency = 1
PlayerMenuButton.Text = "Player"
PlayerMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerMenuButton.TextSize = 14
PlayerMenuButton.Font = Enum.Font.FredokaOne
PlayerMenuButton.Parent = ContentContainer
AddCorner(PlayerMenuButton, UDim.new(0, 4))

CreateTextGlowStroke(PlayerMenuButton)

local TopLine2 = Instance.new("Frame")
TopLine2.Name = "TopLine"
TopLine2.Size = UDim2.new(1, 0, 0, 1)
TopLine2.Position = UDim2.new(0, 0, 0, 0)
TopLine2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopLine2.BorderSizePixel = 0
TopLine2.Parent = PlayerMenuButton

local BottomLine2 = Instance.new("Frame")
BottomLine2.Name = "BottomLine"
BottomLine2.Size = UDim2.new(1, 0, 0, 1)
BottomLine2.Position = UDim2.new(0, 0, 1, -1)
BottomLine2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BottomLine2.BorderSizePixel = 0
BottomLine2.Parent = PlayerMenuButton

local AutoMenuButton = Instance.new("TextButton")
AutoMenuButton.Name = "AutoMenuButton"
AutoMenuButton.Size = UDim2.new(0, 45, 0, 20)
AutoMenuButton.Position = UDim2.new(0, 135, 0, 0)
AutoMenuButton.BackgroundTransparency = 1
AutoMenuButton.Text = "Auto"
AutoMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoMenuButton.TextSize = 14
AutoMenuButton.Font = Enum.Font.FredokaOne
AutoMenuButton.Parent = ContentContainer
AddCorner(AutoMenuButton, UDim.new(0, 4))

CreateTextGlowStroke(AutoMenuButton)

local TopLine3 = Instance.new("Frame")
TopLine3.Name = "TopLine"
TopLine3.Size = UDim2.new(1, 0, 0, 1)
TopLine3.Position = UDim2.new(0, 0, 0, 0)
TopLine3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopLine3.BorderSizePixel = 0
TopLine3.Parent = AutoMenuButton

local BottomLine3 = Instance.new("Frame")
BottomLine3.Name = "BottomLine"
BottomLine3.Size = UDim2.new(1, 0, 0, 1)
BottomLine3.Position = UDim2.new(0, 0, 1, -1)
BottomLine3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BottomLine3.BorderSizePixel = 0
BottomLine3.Parent = AutoMenuButton

local HeplarMenuButton = Instance.new("TextButton")
HeplarMenuButton.Name = "HeplarMenuButton"
HeplarMenuButton.Size = UDim2.new(0, 55, 0, 20)
HeplarMenuButton.Position = UDim2.new(0, 190, 0, 0)
HeplarMenuButton.BackgroundTransparency = 1
HeplarMenuButton.Text = "Heplar"
HeplarMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HeplarMenuButton.TextSize = 14
HeplarMenuButton.Font = Enum.Font.FredokaOne
HeplarMenuButton.Parent = ContentContainer
AddCorner(HeplarMenuButton, UDim.new(0, 4))

CreateTextGlowStroke(HeplarMenuButton)

local TopLine4 = Instance.new("Frame")
TopLine4.Name = "TopLine"
TopLine4.Size = UDim2.new(1, 0, 0, 1)
TopLine4.Position = UDim2.new(0, 0, 0, 0)
TopLine4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopLine4.BorderSizePixel = 0
TopLine4.Parent = HeplarMenuButton

local BottomLine4 = Instance.new("Frame")
BottomLine4.Name = "BottomLine"
BottomLine4.Size = UDim2.new(1, 0, 0, 1)
BottomLine4.Position = UDim2.new(0, 0, 1, -1)
BottomLine4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BottomLine4.BorderSizePixel = 0
BottomLine4.Parent = HeplarMenuButton

local SettingsMenuButton = Instance.new("TextButton")
SettingsMenuButton.Name = "SettingsMenuButton"
SettingsMenuButton.Size = UDim2.new(0, 60, 0, 20)
SettingsMenuButton.Position = UDim2.new(0, 255, 0, 0)
SettingsMenuButton.BackgroundTransparency = 1
SettingsMenuButton.Text = "Settings"
SettingsMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsMenuButton.TextSize = 14
SettingsMenuButton.Font = Enum.Font.FredokaOne
SettingsMenuButton.Parent = ContentContainer
AddCorner(SettingsMenuButton, UDim.new(0, 4))

CreateTextGlowStroke(SettingsMenuButton)

local TopLine5 = Instance.new("Frame")
TopLine5.Name = "TopLine"
TopLine5.Size = UDim2.new(1, 0, 0, 1)
TopLine5.Position = UDim2.new(0, 0, 0, 0)
TopLine5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopLine5.BorderSizePixel = 0
TopLine5.Parent = SettingsMenuButton

local BottomLine5 = Instance.new("Frame")
BottomLine5.Name = "BottomLine"
BottomLine5.Size = UDim2.new(1, 0, 0, 1)
BottomLine5.Position = UDim2.new(0, 0, 1, -1)
BottomLine5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BottomLine5.BorderSizePixel = 0
BottomLine5.Parent = SettingsMenuButton

local AntiMenuList = Instance.new("Frame")
AntiMenuList.Name = "AntiMenuList"
AntiMenuList.Size = UDim2.new(1, -30, 1, -30)
AntiMenuList.Position = UDim2.new(0, 15, 0, 28)
AntiMenuList.BackgroundTransparency = 1
AntiMenuList.Visible = true
AntiMenuList.Parent = ContentContainer

local PlayerMenuList = Instance.new("Frame")
PlayerMenuList.Name = "PlayerMenuList"
PlayerMenuList.Size = UDim2.new(1, -30, 1, -30)
PlayerMenuList.Position = UDim2.new(0, 15, 0, 28)
PlayerMenuList.BackgroundTransparency = 1
PlayerMenuList.Visible = false
PlayerMenuList.Parent = ContentContainer

local AutoMenuList = Instance.new("Frame")
AutoMenuList.Name = "AutoMenuList"
AutoMenuList.Size = UDim2.new(1, -30, 1, -30)
AutoMenuList.Position = UDim2.new(0, 15, 0, 28)
AutoMenuList.BackgroundTransparency = 1
AutoMenuList.Visible = false
AutoMenuList.Parent = ContentContainer

local HeplarMenuList = Instance.new("Frame")
HeplarMenuList.Name = "HeplarMenuList"
HeplarMenuList.Size = UDim2.new(1, -30, 1, -30)
HeplarMenuList.Position = UDim2.new(0, 15, 0, 28)
HeplarMenuList.BackgroundTransparency = 1
HeplarMenuList.Visible = false
HeplarMenuList.Parent = ContentContainer

local SettingsMenuList = Instance.new("Frame")
SettingsMenuList.Name = "SettingsMenuList"
SettingsMenuList.Size = UDim2.new(1, -30, 1, -30)
SettingsMenuList.Position = UDim2.new(0, 15, 0, 28)
SettingsMenuList.BackgroundTransparency = 1
SettingsMenuList.Visible = false
SettingsMenuList.Parent = ContentContainer

local SettingsButtonFrame1 = Instance.new("Frame")
SettingsButtonFrame1.Name = "SettingsButtonFrame1"
SettingsButtonFrame1.Size = UDim2.new(1, 0, 0, 40)
SettingsButtonFrame1.Position = UDim2.new(0, 0, 0, 0)
SettingsButtonFrame1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SettingsButtonFrame1.BackgroundTransparency = 0.4
SettingsButtonFrame1.BorderSizePixel = 0
SettingsButtonFrame1.Parent = SettingsMenuList
AddCorner(SettingsButtonFrame1, UDim.new(0, 8))

CreateMainBorderStroke(SettingsButtonFrame1)

local SettingsButtonLabel1 = Instance.new("TextLabel")
SettingsButtonLabel1.Name = "SettingsButtonLabel1"
SettingsButtonLabel1.Size = UDim2.new(1, -60, 1, 0)
SettingsButtonLabel1.Position = UDim2.new(0, 12, 0, 0)
SettingsButtonLabel1.BackgroundTransparency = 1
SettingsButtonLabel1.Text = "Save"
SettingsButtonLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsButtonLabel1.TextSize = 14
SettingsButtonLabel1.Font = Enum.Font.FredokaOne
SettingsButtonLabel1.TextXAlignment = Enum.TextXAlignment.Left
SettingsButtonLabel1.Parent = SettingsButtonFrame1

CreateTextGlowStroke(SettingsButtonLabel1)

local SettingsSwitchBackground1 = Instance.new("TextButton")
SettingsSwitchBackground1.Name = "SettingsSwitchBackground1"
SettingsSwitchBackground1.Size = UDim2.new(0, 36, 0, 20)
SettingsSwitchBackground1.Position = UDim2.new(1, -48, 0.5, -10)
SettingsSwitchBackground1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SettingsSwitchBackground1.BorderSizePixel = 0
SettingsSwitchBackground1.Text = ""
SettingsSwitchBackground1.AutoButtonColor = false
SettingsSwitchBackground1.Parent = SettingsButtonFrame1
AddCorner(SettingsSwitchBackground1, UDim.new(1, 0))

local SettingsSwitchCircle1 = Instance.new("Frame")
SettingsSwitchCircle1.Name = "SettingsSwitchCircle1"
SettingsSwitchCircle1.Size = UDim2.new(0, 16, 0, 16)
SettingsSwitchCircle1.Position = UDim2.new(0, 2, 0.5, -8)
SettingsSwitchCircle1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SettingsSwitchCircle1.BorderSizePixel = 0
SettingsSwitchCircle1.Parent = SettingsSwitchBackground1
AddCorner(SettingsSwitchCircle1, UDim.new(1, 0))

local saveEnabled = false
local SaveSettings

local function ToggleSave(override)
    if override ~= nil then
        saveEnabled = override
    else
        saveEnabled = not saveEnabled
    end
    
    local targetBgColor = saveEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
    local targetCircleColor = saveEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 0, 0)
    local targetCirclePos = saveEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    
    TweenService:Create(SettingsSwitchBackground1, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor}):Play()
    TweenService:Create(SettingsSwitchCircle1, TweenInfo.new(0.2), {BackgroundColor3 = targetCircleColor, Position = targetCirclePos}):Play()
    if SaveSettings then SaveSettings() end
end

SettingsSwitchBackground1.MouseButton1Click:Connect(function() ToggleSave() end)

local ButtonFrame0 = Instance.new("Frame")
ButtonFrame0.Name = "ButtonFrame0"
ButtonFrame0.Size = UDim2.new(1, 0, 0, 40)
ButtonFrame0.Position = UDim2.new(0, 0, 0, 0)
ButtonFrame0.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ButtonFrame0.BackgroundTransparency = 0.4
ButtonFrame0.BorderSizePixel = 0
ButtonFrame0.Parent = AntiMenuList
AddCorner(ButtonFrame0, UDim.new(0, 8))

CreateMainBorderStroke(ButtonFrame0)

local ButtonLabel0 = Instance.new("TextLabel")
ButtonLabel0.Name = "ButtonLabel0"
ButtonLabel0.Size = UDim2.new(1, -60, 1, 0)
ButtonLabel0.Position = UDim2.new(0, 12, 0, 0)
ButtonLabel0.BackgroundTransparency = 1
ButtonLabel0.Text = "Anti LAG"
ButtonLabel0.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonLabel0.TextSize = 14
ButtonLabel0.Font = Enum.Font.FredokaOne
ButtonLabel0.TextXAlignment = Enum.TextXAlignment.Left
ButtonLabel0.Parent = ButtonFrame0

CreateTextGlowStroke(ButtonLabel0)

local SwitchBackground0 = Instance.new("TextButton")
SwitchBackground0.Name = "SwitchBackground0"
SwitchBackground0.Size = UDim2.new(0, 36, 0, 20)
SwitchBackground0.Position = UDim2.new(1, -48, 0.5, -10)
SwitchBackground0.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SwitchBackground0.BorderSizePixel = 0
SwitchBackground0.Text = ""
SwitchBackground0.AutoButtonColor = false
SwitchBackground0.Parent = ButtonFrame0
AddCorner(SwitchBackground0, UDim.new(1, 0))

local SwitchCircle0 = Instance.new("Frame")
SwitchCircle0.Name = "SwitchCircle0"
SwitchCircle0.Size = UDim2.new(0, 16, 0, 16)
SwitchCircle0.Position = UDim2.new(0, 2, 0.5, -8)
SwitchCircle0.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SwitchCircle0.BorderSizePixel = 0
SwitchCircle0.Parent = SwitchBackground0
AddCorner(SwitchCircle0, UDim.new(1, 0))

local ButtonFrame1 = Instance.new("Frame")
ButtonFrame1.Name = "ButtonFrame1"
ButtonFrame1.Size = UDim2.new(1, 0, 0, 40)
ButtonFrame1.Position = UDim2.new(0, 0, 0, 0)
ButtonFrame1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ButtonFrame1.BackgroundTransparency = 0.4
ButtonFrame1.BorderSizePixel = 0
ButtonFrame1.Parent = AutoMenuList
AddCorner(ButtonFrame1, UDim.new(0, 8))

CreateMainBorderStroke(ButtonFrame1)

local ButtonLabel1 = Instance.new("TextLabel")
ButtonLabel1.Name = "ButtonLabel1"
ButtonLabel1.Size = UDim2.new(1, -60, 1, 0)
ButtonLabel1.Position = UDim2.new(0, 12, 0, 0)
ButtonLabel1.BackgroundTransparency = 1
ButtonLabel1.Text = "Auto Grab all"
ButtonLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonLabel1.TextSize = 14
ButtonLabel1.Font = Enum.Font.FredokaOne
ButtonLabel1.TextXAlignment = Enum.TextXAlignment.Left
ButtonLabel1.Parent = ButtonFrame1

CreateTextGlowStroke(ButtonLabel1)

local SwitchBackground1 = Instance.new("TextButton")
SwitchBackground1.Name = "SwitchBackground1"
SwitchBackground1.Size = UDim2.new(0, 36, 0, 20)
SwitchBackground1.Position = UDim2.new(1, -48, 0.5, -10)
SwitchBackground1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SwitchBackground1.BorderSizePixel = 0
SwitchBackground1.Text = ""
SwitchBackground1.AutoButtonColor = false
SwitchBackground1.Parent = ButtonFrame1
AddCorner(SwitchBackground1, UDim.new(1, 0))

local SwitchCircle1 = Instance.new("Frame")
SwitchCircle1.Name = "SwitchCircle1"
SwitchCircle1.Size = UDim2.new(0, 16, 0, 16)
SwitchCircle1.Position = UDim2.new(0, 2, 0.5, -8)
SwitchCircle1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SwitchCircle1.BorderSizePixel = 0
SwitchCircle1.Parent = SwitchBackground1
AddCorner(SwitchCircle1, UDim.new(1, 0))

local ButtonFrame2 = Instance.new("Frame")
ButtonFrame2.Name = "ButtonFrame2"
ButtonFrame2.Size = UDim2.new(1, 0, 0, 40)
ButtonFrame2.Position = UDim2.new(0, 0, 0, 48)
ButtonFrame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ButtonFrame2.BackgroundTransparency = 0.4
ButtonFrame2.BorderSizePixel = 0
ButtonFrame2.Parent = AntiMenuList
AddCorner(ButtonFrame2, UDim.new(0, 8))

CreateMainBorderStroke(ButtonFrame2)

local ButtonLabel2 = Instance.new("TextLabel")
ButtonLabel2.Name = "ButtonLabel2"
ButtonLabel2.Size = UDim2.new(1, -60, 1, 0)
ButtonLabel2.Position = UDim2.new(0, 12, 0, 0)
ButtonLabel2.BackgroundTransparency = 1
ButtonLabel2.Text = "Anti kick"
ButtonLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonLabel2.TextSize = 14
ButtonLabel2.Font = Enum.Font.FredokaOne
ButtonLabel2.TextXAlignment = Enum.TextXAlignment.Left
ButtonLabel2.Parent = ButtonFrame2

CreateTextGlowStroke(ButtonLabel2)

local SwitchBackground2 = Instance.new("TextButton")
SwitchBackground2.Name = "SwitchBackground2"
SwitchBackground2.Size = UDim2.new(0, 36, 0, 20)
SwitchBackground2.Position = UDim2.new(1, -48, 0.5, -10)
SwitchBackground2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SwitchBackground2.BorderSizePixel = 0
SwitchBackground2.Text = ""
SwitchBackground2.AutoButtonColor = false
SwitchBackground2.Parent = ButtonFrame2
AddCorner(SwitchBackground2, UDim.new(1, 0))

local SwitchCircle2 = Instance.new("Frame")
SwitchCircle2.Name = "SwitchCircle2"
SwitchCircle2.Size = UDim2.new(0, 16, 0, 16)
SwitchCircle2.Position = UDim2.new(0, 2, 0.5, -8)
SwitchCircle2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SwitchCircle2.BorderSizePixel = 0
SwitchCircle2.Parent = SwitchBackground2
AddCorner(SwitchCircle2, UDim.new(1, 0))

local ButtonFrame3 = Instance.new("Frame")
ButtonFrame3.Name = "ButtonFrame3"
ButtonFrame3.Size = UDim2.new(1, 0, 0, 40)
ButtonFrame3.Position = UDim2.new(0, 0, 0, 96)
ButtonFrame3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ButtonFrame3.BackgroundTransparency = 0.4
ButtonFrame3.BorderSizePixel = 0
ButtonFrame3.Parent = AntiMenuList
AddCorner(ButtonFrame3, UDim.new(0, 8))

CreateMainBorderStroke(ButtonFrame3)

local ButtonLabel3 = Instance.new("TextLabel")
ButtonLabel3.Name = "ButtonLabel3"
ButtonLabel3.Size = UDim2.new(1, -60, 1, 0)
ButtonLabel3.Position = UDim2.new(0, 12, 0, 0)
ButtonLabel3.BackgroundTransparency = 1
ButtonLabel3.Text = "Anti Ragdoll"
ButtonLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonLabel3.TextSize = 14
ButtonLabel3.Font = Enum.Font.FredokaOne
ButtonLabel3.TextXAlignment = Enum.TextXAlignment.Left
ButtonLabel3.Parent = ButtonFrame3

CreateTextGlowStroke(ButtonLabel3)

local SwitchBackground3 = Instance.new("TextButton")
SwitchBackground3.Name = "SwitchBackground3"
SwitchBackground3.Size = UDim2.new(0, 36, 0, 20)
SwitchBackground3.Position = UDim2.new(1, -48, 0.5, -10)
SwitchBackground3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SwitchBackground3.BorderSizePixel = 0
SwitchBackground3.Text = ""
SwitchBackground3.AutoButtonColor = false
SwitchBackground3.Parent = ButtonFrame3
AddCorner(SwitchBackground3, UDim.new(1, 0))

local SwitchCircle3 = Instance.new("Frame")
SwitchCircle3.Name = "SwitchCircle3"
SwitchCircle3.Size = UDim2.new(0, 16, 0, 16)
SwitchCircle3.Position = UDim2.new(0, 2, 0.5, -8)
SwitchCircle3.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SwitchCircle3.BorderSizePixel = 0
SwitchCircle3.Parent = SwitchBackground3
AddCorner(SwitchCircle3, UDim.new(1, 0))

local PlayerButtonFrame1 = Instance.new("Frame")
PlayerButtonFrame1.Name = "PlayerButtonFrame1"
PlayerButtonFrame1.Size = UDim2.new(1, 0, 0, 40)
PlayerButtonFrame1.Position = UDim2.new(0, 0, 0, 0)
PlayerButtonFrame1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerButtonFrame1.BackgroundTransparency = 0.4
PlayerButtonFrame1.BorderSizePixel = 0
PlayerButtonFrame1.Parent = PlayerMenuList
AddCorner(PlayerButtonFrame1, UDim.new(0, 8))

CreateMainBorderStroke(PlayerButtonFrame1)

local PlayerButtonLabel1 = Instance.new("TextLabel")
PlayerButtonLabel1.Name = "PlayerButtonLabel1"
PlayerButtonLabel1.Size = UDim2.new(1, -60, 1, 0)
PlayerButtonLabel1.Position = UDim2.new(0, 12, 0, 0)
PlayerButtonLabel1.BackgroundTransparency = 1
PlayerButtonLabel1.Text = "Infinite Jump"
PlayerButtonLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerButtonLabel1.TextSize = 14
PlayerButtonLabel1.Font = Enum.Font.FredokaOne
PlayerButtonLabel1.TextXAlignment = Enum.TextXAlignment.Left
PlayerButtonLabel1.Parent = PlayerButtonFrame1

CreateTextGlowStroke(PlayerButtonLabel1)

local PlayerSwitchBackground1 = Instance.new("TextButton")
PlayerSwitchBackground1.Name = "PlayerSwitchBackground1"
PlayerSwitchBackground1.Size = UDim2.new(0, 36, 0, 20)
PlayerSwitchBackground1.Position = UDim2.new(1, -48, 0.5, -10)
PlayerSwitchBackground1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PlayerSwitchBackground1.BorderSizePixel = 0
PlayerSwitchBackground1.Text = ""
PlayerSwitchBackground1.AutoButtonColor = false
PlayerSwitchBackground1.Parent = PlayerButtonFrame1
AddCorner(PlayerSwitchBackground1, UDim.new(1, 0))

local PlayerSwitchCircle1 = Instance.new("Frame")
PlayerSwitchCircle1.Name = "PlayerSwitchCircle1"
PlayerSwitchCircle1.Size = UDim2.new(0, 16, 0, 16)
PlayerSwitchCircle1.Position = UDim2.new(0, 2, 0.5, -8)
PlayerSwitchCircle1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
PlayerSwitchCircle1.BorderSizePixel = 0
PlayerSwitchCircle1.Parent = PlayerSwitchBackground1
AddCorner(PlayerSwitchCircle1, UDim.new(1, 0))

local PlayerButtonFrame2 = Instance.new("Frame")
PlayerButtonFrame2.Name = "PlayerButtonFrame2"
PlayerButtonFrame2.Size = UDim2.new(1, 0, 0, 40)
PlayerButtonFrame2.Position = UDim2.new(0, 0, 0, 48)
PlayerButtonFrame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerButtonFrame2.BackgroundTransparency = 0.4
PlayerButtonFrame2.BorderSizePixel = 0
PlayerButtonFrame2.Parent = PlayerMenuList
AddCorner(PlayerButtonFrame2, UDim.new(0, 8))

CreateMainBorderStroke(PlayerButtonFrame2)

local PlayerButtonLabel2 = Instance.new("TextLabel")
PlayerButtonLabel2.Name = "PlayerButtonLabel2"
PlayerButtonLabel2.Size = UDim2.new(1, -60, 1, 0)
PlayerButtonLabel2.Position = UDim2.new(0, 12, 0, 0)
PlayerButtonLabel2.BackgroundTransparency = 1
PlayerButtonLabel2.Text = "Invisible Player | SOON !"
PlayerButtonLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerButtonLabel2.TextSize = 14
PlayerButtonLabel2.Font = Enum.Font.FredokaOne
PlayerButtonLabel2.TextXAlignment = Enum.TextXAlignment.Left
PlayerButtonLabel2.Parent = PlayerButtonFrame2

CreateTextGlowStroke(PlayerButtonLabel2)

local PlayerSwitchBackground2 = Instance.new("TextButton")
PlayerSwitchBackground2.Name = "PlayerSwitchBackground2"
PlayerSwitchBackground2.Size = UDim2.new(0, 36, 0, 20)
PlayerSwitchBackground2.Position = UDim2.new(1, -48, 0.5, -10)
PlayerSwitchBackground2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PlayerSwitchBackground2.BorderSizePixel = 0
PlayerSwitchBackground2.Text = ""
PlayerSwitchBackground2.AutoButtonColor = false
PlayerSwitchBackground2.Parent = PlayerButtonFrame2
AddCorner(PlayerSwitchBackground2, UDim.new(1, 0))

local PlayerSwitchCircle2 = Instance.new("Frame")
PlayerSwitchCircle2.Name = "PlayerSwitchCircle2"
PlayerSwitchCircle2.Size = UDim2.new(0, 16, 0, 16)
PlayerSwitchCircle2.Position = UDim2.new(0, 2, 0.5, -8)
PlayerSwitchCircle2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
PlayerSwitchCircle2.BorderSizePixel = 0
PlayerSwitchCircle2.Parent = PlayerSwitchBackground2
AddCorner(PlayerSwitchCircle2, UDim.new(1, 0))

local PlayerButtonFrame3 = Instance.new("Frame")
PlayerButtonFrame3.Name = "PlayerButtonFrame3"
PlayerButtonFrame3.Size = UDim2.new(1, 0, 0, 40)
PlayerButtonFrame3.Position = UDim2.new(0, 0, 0, 96)
PlayerButtonFrame3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerButtonFrame3.BackgroundTransparency = 0.4
PlayerButtonFrame3.BorderSizePixel = 0
PlayerButtonFrame3.Parent = PlayerMenuList
AddCorner(PlayerButtonFrame3, UDim.new(0, 8))

CreateMainBorderStroke(PlayerButtonFrame3)

local PlayerButtonLabel3 = Instance.new("TextLabel")
PlayerButtonLabel3.Name = "PlayerButtonLabel3"
PlayerButtonLabel3.Size = UDim2.new(1, -60, 1, 0)
PlayerButtonLabel3.Position = UDim2.new(0, 12, 0, 0)
PlayerButtonLabel3.BackgroundTransparency = 1
PlayerButtonLabel3.Text = "Unwalk"
PlayerButtonLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerButtonLabel3.TextSize = 14
PlayerButtonLabel3.Font = Enum.Font.FredokaOne
PlayerButtonLabel3.TextXAlignment = Enum.TextXAlignment.Left
PlayerButtonLabel3.Parent = PlayerButtonFrame3

CreateTextGlowStroke(PlayerButtonLabel3)

local PlayerSwitchBackground3 = Instance.new("TextButton")
PlayerSwitchBackground3.Name = "PlayerSwitchBackground3"
PlayerSwitchBackground3.Size = UDim2.new(0, 36, 0, 20)
PlayerSwitchBackground3.Position = UDim2.new(1, -48, 0.5, -10)
PlayerSwitchBackground3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PlayerSwitchBackground3.BorderSizePixel = 0
PlayerSwitchBackground3.Text = ""
PlayerSwitchBackground3.AutoButtonColor = false
PlayerSwitchBackground3.Parent = PlayerButtonFrame3
AddCorner(PlayerSwitchBackground3, UDim.new(1, 0))

local PlayerSwitchCircle3 = Instance.new("Frame")
PlayerSwitchCircle3.Name = "PlayerSwitchCircle3"
PlayerSwitchCircle3.Size = UDim2.new(0, 16, 0, 16)
PlayerSwitchCircle3.Position = UDim2.new(0, 2, 0.5, -8)
PlayerSwitchCircle3.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
PlayerSwitchCircle3.BorderSizePixel = 0
PlayerSwitchCircle3.Parent = PlayerSwitchBackground3
AddCorner(PlayerSwitchCircle3, UDim.new(1, 0))

local HeplarButtonFrame1 = Instance.new("Frame")
HeplarButtonFrame1.Name = "HeplarButtonFrame1"
HeplarButtonFrame1.Size = UDim2.new(1, 0, 0, 40)
HeplarButtonFrame1.Position = UDim2.new(0, 0, 0, 0)
HeplarButtonFrame1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
HeplarButtonFrame1.BackgroundTransparency = 0.4
HeplarButtonFrame1.BorderSizePixel = 0
HeplarButtonFrame1.Parent = HeplarMenuList
AddCorner(HeplarButtonFrame1, UDim.new(0, 8))

CreateMainBorderStroke(HeplarButtonFrame1)

local HeplarButtonLabel1 = Instance.new("TextLabel")
HeplarButtonLabel1.Name = "HeplarButtonLabel1"
HeplarButtonLabel1.Size = UDim2.new(1, -60, 1, 0)
HeplarButtonLabel1.Position = UDim2.new(0, 12, 0, 0)
HeplarButtonLabel1.BackgroundTransparency = 1
HeplarButtonLabel1.Text = "XRay Base"
HeplarButtonLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
HeplarButtonLabel1.TextSize = 14
HeplarButtonLabel1.Font = Enum.Font.FredokaOne
HeplarButtonLabel1.TextXAlignment = Enum.TextXAlignment.Left
HeplarButtonLabel1.Parent = HeplarButtonFrame1

CreateTextGlowStroke(HeplarButtonLabel1)

local HeplarSwitchBackground1 = Instance.new("TextButton")
HeplarSwitchBackground1.Name = "HeplarSwitchBackground1"
HeplarSwitchBackground1.Size = UDim2.new(0, 36, 0, 20)
HeplarSwitchBackground1.Position = UDim2.new(1, -48, 0.5, -10)
HeplarSwitchBackground1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HeplarSwitchBackground1.BorderSizePixel = 0
HeplarSwitchBackground1.Text = ""
HeplarSwitchBackground1.AutoButtonColor = false
HeplarSwitchBackground1.Parent = HeplarButtonFrame1
AddCorner(HeplarSwitchBackground1, UDim.new(1, 0))

local HeplarSwitchCircle1 = Instance.new("Frame")
HeplarSwitchCircle1.Name = "HeplarSwitchCircle1"
HeplarSwitchCircle1.Size = UDim2.new(0, 16, 0, 16)
HeplarSwitchCircle1.Position = UDim2.new(0, 2, 0.5, -8)
HeplarSwitchCircle1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
HeplarSwitchCircle1.BorderSizePixel = 0
HeplarSwitchCircle1.Parent = HeplarSwitchBackground1
AddCorner(HeplarSwitchCircle1, UDim.new(1, 0))

AntiMenuButton.MouseButton1Click:Connect(function()
    AntiMenuList.Visible = true
    PlayerMenuList.Visible = false
    AutoMenuList.Visible = false
    HeplarMenuList.Visible = false
    SettingsMenuList.Visible = false
end)

PlayerMenuButton.MouseButton1Click:Connect(function()
    AntiMenuList.Visible = false
    PlayerMenuList.Visible = true
    AutoMenuList.Visible = false
    HeplarMenuList.Visible = false
    SettingsMenuList.Visible = false
end)

AutoMenuButton.MouseButton1Click:Connect(function()
    AntiMenuList.Visible = false
    PlayerMenuList.Visible = false
    AutoMenuList.Visible = true
    HeplarMenuList.Visible = false
    SettingsMenuList.Visible = false
end)

HeplarMenuButton.MouseButton1Click:Connect(function()
    AntiMenuList.Visible = false
    PlayerMenuList.Visible = false
    AutoMenuList.Visible = false
    HeplarMenuList.Visible = true
    SettingsMenuList.Visible = false
end)

SettingsMenuButton.MouseButton1Click:Connect(function()
    AntiMenuList.Visible = false
    PlayerMenuList.Visible = false
    AutoMenuList.Visible = false
    HeplarMenuList.Visible = false
    SettingsMenuList.Visible = true
end)

local AutoBatBtn = Instance.new("TextButton")
AutoBatBtn.Name = "AutoBatBtn"
AutoBatBtn.Size = UDim2.new(0, 120, 0, 70)
AutoBatBtn.Position = UDim2.new(1, -140, 0.4, 0)
AutoBatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AutoBatBtn.BackgroundTransparency = 1
AutoBatBtn.Text = ""
AutoBatBtn.AutoButtonColor = false
AutoBatBtn.Parent = ScreenGui
AddCorner(AutoBatBtn, UDim.new(0, 10))

local AutoBatImg = Instance.new("ImageLabel")
AutoBatImg.Name = "AutoBatImg"
AutoBatImg.Size = UDim2.new(1, 0, 1, 0)
AutoBatImg.Position = UDim2.new(0, 0, 0, 0)
AutoBatImg.BackgroundTransparency = 1
AutoBatImg.Image = "rbxassetid://136450335437647"
AutoBatImg.ScaleType = Enum.ScaleType.Crop
AutoBatImg.Parent = AutoBatBtn
AddCorner(AutoBatImg, UDim.new(0, 10))

local AutoBatText = Instance.new("TextLabel")
AutoBatText.Name = "AutoBatText"
AutoBatText.Size = UDim2.new(1, 0, 1, 0)
AutoBatText.Position = UDim2.new(0, 0, 0, 0)
AutoBatText.BackgroundTransparency = 1
AutoBatText.Text = "Auto\nBat"
AutoBatText.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBatText.TextSize = 20
AutoBatText.Font = Enum.Font.FredokaOne
AutoBatText.ZIndex = 3
AutoBatText.Parent = AutoBatBtn

local AutoBatOverlay = Instance.new("Frame")
AutoBatOverlay.Name = "AutoBatOverlay"
AutoBatOverlay.Size = UDim2.new(1, 0, 1, 0)
AutoBatOverlay.Position = UDim2.new(0, 0, 0, 0)
AutoBatOverlay.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AutoBatOverlay.BackgroundTransparency = 1
AutoBatOverlay.BorderSizePixel = 0
AutoBatOverlay.ZIndex = 2
AutoBatOverlay.Parent = AutoBatBtn
AddCorner(AutoBatOverlay, UDim.new(0, 10))

CreateMainBorderStroke(AutoBatBtn)
CreateTextGlowStroke(AutoBatText)

local FloorStealBtn = Instance.new("TextButton")
FloorStealBtn.Name = "FloorStealBtn"
FloorStealBtn.Size = UDim2.new(0, 120, 0, 70)
FloorStealBtn.Position = UDim2.new(1, -140, 0.4, -80)
FloorStealBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloorStealBtn.BackgroundTransparency = 1
FloorStealBtn.Text = ""
FloorStealBtn.AutoButtonColor = false
FloorStealBtn.Parent = ScreenGui
AddCorner(FloorStealBtn, UDim.new(0, 10))

local FloorStealImg = Instance.new("ImageLabel")
FloorStealImg.Name = "FloorStealImg"
FloorStealImg.Size = UDim2.new(1, 0, 1, 0)
FloorStealImg.Position = UDim2.new(0, 0, 0, 0)
FloorStealImg.BackgroundTransparency = 1
FloorStealImg.Image = "rbxassetid://136450335437647"
FloorStealImg.ScaleType = Enum.ScaleType.Crop
FloorStealImg.Parent = FloorStealBtn
AddCorner(FloorStealImg, UDim.new(0, 10))

local FloorStealText = Instance.new("TextLabel")
FloorStealText.Name = "FloorStealText"
FloorStealText.Size = UDim2.new(1, 0, 1, 0)
FloorStealText.Position = UDim2.new(0, 0, 0, 0)
FloorStealText.BackgroundTransparency = 1
FloorStealText.Text = "Floor\nSteal"
FloorStealText.TextColor3 = Color3.fromRGB(255, 255, 255)
FloorStealText.TextSize = 20
FloorStealText.Font = Enum.Font.FredokaOne
FloorStealText.ZIndex = 3
FloorStealText.Parent = FloorStealBtn

local FloorStealOverlay = Instance.new("Frame")
FloorStealOverlay.Name = "FloorStealOverlay"
FloorStealOverlay.Size = UDim2.new(1, 0, 1, 0)
FloorStealOverlay.Position = UDim2.new(0, 0, 0, 0)
FloorStealOverlay.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
FloorStealOverlay.BackgroundTransparency = 1
FloorStealOverlay.BorderSizePixel = 0
FloorStealOverlay.ZIndex = 2
FloorStealOverlay.Parent = FloorStealBtn
AddCorner(FloorStealOverlay, UDim.new(0, 10))

CreateMainBorderStroke(FloorStealBtn)
CreateTextGlowStroke(FloorStealText)

local TPDownBtn = Instance.new("TextButton")
TPDownBtn.Name = "TPDownBtn"
TPDownBtn.Size = UDim2.new(0, 120, 0, 70)
TPDownBtn.Position = UDim2.new(1, -140, 0.4, -160)
TPDownBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TPDownBtn.BackgroundTransparency = 1
TPDownBtn.Text = ""
TPDownBtn.AutoButtonColor = false
TPDownBtn.Parent = ScreenGui
AddCorner(TPDownBtn, UDim.new(0, 10))

local TPDownImg = Instance.new("ImageLabel")
TPDownImg.Name = "TPDownImg"
TPDownImg.Size = UDim2.new(1, 0, 1, 0)
TPDownImg.Position = UDim2.new(0, 0, 0, 0)
TPDownImg.BackgroundTransparency = 1
TPDownImg.Image = "rbxassetid://136450335437647"
TPDownImg.ScaleType = Enum.ScaleType.Crop
TPDownImg.Parent = TPDownBtn
AddCorner(TPDownImg, UDim.new(0, 10))

local TPDownText = Instance.new("TextLabel")
TPDownText.Name = "TPDownText"
TPDownText.Size = UDim2.new(1, 0, 1, 0)
TPDownText.Position = UDim2.new(0, 0, 0, 0)
TPDownText.BackgroundTransparency = 1
TPDownText.Text = "TP\nDown"
TPDownText.TextColor3 = Color3.fromRGB(255, 255, 255)
TPDownText.TextSize = 20
TPDownText.Font = Enum.Font.FredokaOne
TPDownText.ZIndex = 3
TPDownText.Parent = TPDownBtn

local TPDownOverlay = Instance.new("Frame")
TPDownOverlay.Name = "TPDownOverlay"
TPDownOverlay.Size = UDim2.new(1, 0, 1, 0)
TPDownOverlay.Position = UDim2.new(0, 0, 0, 0)
TPDownOverlay.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TPDownOverlay.BackgroundTransparency = 1
TPDownOverlay.BorderSizePixel = 0
TPDownOverlay.ZIndex = 2
TPDownOverlay.Parent = TPDownBtn
AddCorner(TPDownOverlay, UDim.new(0, 10))

CreateMainBorderStroke(TPDownBtn)
CreateTextGlowStroke(TPDownText)

local isFloorStealActive = false

local function tpDown()
    local character = LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local rayResult = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), raycastParams)

    if rayResult then
        hrp.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
    else
        hrp.CFrame = CFrame.new(hrp.Position.X, -6.84, hrp.Position.Z)
    end
end

TPDownBtn.MouseButton1Click:Connect(tpDown)

local function createElevator()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HRP = Character:WaitForChild("HumanoidRootPart")

    local old = workspace:FindFirstChild("BOKA_Elevator")
    if old then
        old:Destroy()
    end

    local Platform = Instance.new("Part")
    Platform.Name = "BOKA_Elevator"
    Platform.Size = Vector3.new(5, 0.35, 5)
    Platform.Anchored = true
    Platform.CanCollide = true
    Platform.Material = Enum.Material.Neon
    Platform.Color = Color3.fromRGB(255, 0, 0)
    Platform.Parent = workspace

    local startPosition = HRP.Position + Vector3.new(0, -3.05, 0)
    Platform.Position = startPosition

    task.spawn(function()
        while Platform and Platform.Parent do
            local tween = TweenService:Create(
                Platform,
                TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Color = Color3.fromRGB(15, 0, 0)}
            )

            tween:Play()
            tween.Completed:Wait()

            if not (Platform and Platform.Parent) then break end

            tween = TweenService:Create(
                Platform,
                TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Color = Color3.fromRGB(255, 0, 0)}
            )

            tween:Play()
            tween.Completed:Wait()
        end
    end)

    local maxHeight = 9

    local RayParams = RaycastParams.new()
    RayParams.FilterType = Enum.RaycastFilterType.Exclude
    RayParams.FilterDescendantsInstances = {
        Character,
        Platform
    }

    local RayResult = workspace:Raycast(
        startPosition,
        Vector3.new(0, maxHeight, 0),
        RayParams
    )

    local height = maxHeight

    if RayResult then
        height = math.max(0, RayResult.Distance - 0.5)
    end

    local targetPosition = startPosition + Vector3.new(0, height, 0)

    local UpTween = TweenService:Create(
        Platform,
        TweenInfo.new(
            3,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Position = targetPosition
        }
    )

    UpTween:Play()
    UpTween.Completed:Wait()

    if Platform and Platform.Parent then
        Platform.Position = targetPosition
    end
end

local function removeElevator()
    local old = workspace:FindFirstChild("BOKA_Elevator")
    if old then
        old:Destroy()
    end
end

FloorStealBtn.MouseButton1Click:Connect(function()
    isFloorStealActive = not isFloorStealActive
    if isFloorStealActive then
        FloorStealOverlay.BackgroundTransparency = 0.8
        task.spawn(createElevator)
    else
        FloorStealOverlay.BackgroundTransparency = 1
        removeElevator()
    end
end)

local State = {
    autoBatToggled = false,
    hittingCooldown = false,
    guiVisible = true
}

local Keys = {
    autoBat = Enum.KeyCode.E,
    guiHide = Enum.KeyCode.RightControl
}

local h = nil
local hrp = nil

local function getBat()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp2 = LP:FindFirstChild("Backpack")
    if bp2 then
        tool = bp2:FindFirstChild("Bat")
        if tool then tool.Parent = char; return tool end
    end
    return nil
end

local function tryHitBat()
    if State.hittingCooldown then return end
    State.hittingCooldown = true
    pcall(function()
        local bat = getBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() State.hittingCooldown = false end)
end

local function getClosestPlayer()
    if not hrp then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end

local function setupChar(char)
    task.wait(0.1)
    h = char:WaitForChild("Humanoid", 5)
    hrp = char:WaitForChild("HumanoidRootPart", 5)
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

RunService.Heartbeat:Connect(function()
    if not (State.autoBatToggled and h and hrp) then return end
    local target, dist = getClosestPlayer()
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(hrp, "PhysicsRepRootPart", tr)
                end)
            end
            local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
            if (hrp.Position - targetPos).Magnitude > 8 then
                hrp.CFrame = CFrame.new(targetPos)
            end
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
            tryHitBat()
        end
    end
end)

local function setToggleVisual(enabled)
    if enabled then
        AutoBatOverlay.BackgroundTransparency = 0.8
    else
        AutoBatOverlay.BackgroundTransparency = 1
    end
end

AutoBatBtn.MouseButton1Click:Connect(function()
    State.autoBatToggled = not State.autoBatToggled
    setToggleVisual(State.autoBatToggled)
end)

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard then
        if inp.KeyCode == Keys.autoBat then
            State.autoBatToggled = not State.autoBatToggled
            setToggleVisual(State.autoBatToggled)
        elseif inp.KeyCode == Keys.guiHide then
            State.guiVisible = not State.guiVisible
            MainFrame.Visible = State.guiVisible
        end
    end
end)

local autoGrabEnabled = false
local activeHolds = {}
local promptConnection = nil

local function HandlePrompt(prompt)
    if autoGrabEnabled and prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
        pcall(function()
            local actionText = prompt.ActionText and prompt.ActionText:lower() or ""
            local objectText = prompt.ObjectText and prompt.ObjectText:lower() or ""
            if actionText:find("grab") or objectText:find("grab") or actionText:find("purchase") or objectText:find("purchase") or actionText:find("tack") or objectText:find("tack") or actionText == "" then
                if not activeHolds[prompt] then
                    activeHolds[prompt] = true
                    task.spawn(function()
                        if fireproximityprompt then
                            while autoGrabEnabled and prompt and prompt.Parent and prompt.Enabled do
                                pcall(function()
                                    fireproximityprompt(prompt)
                                end)
                                task.wait(0.1)
                            end
                        else
                            local holdTime = (prompt.HoldDuration and prompt.HoldDuration > 0) and prompt.HoldDuration or 0.1
                            local startTime = tick()
                            
                            pcall(function()
                                prompt:InputHoldBegin()
                            end)
                            
                            while autoGrabEnabled and prompt and prompt.Parent and prompt.Enabled and (tick() - startTime < holdTime + 0.05) do
                                task.wait(0.02)
                            end
                            
                            pcall(function()
                                if prompt and prompt.Parent then
                                    prompt:InputHoldEnd()
                                end
                            end)
                        end
                        
                        activeHolds[prompt] = nil
                    end)
                end
            end
        end)
    end
end

local antiLagEnabled = false
local antiKickEnabled = false
local antiRagdollEnabled = false
local infJumpEnabled = false
local invisiblePlayerEnabled = false
local unWalkEnabled = false
local xrayBaseEnabled = false

SaveSettings = function()
    if writefile and saveEnabled then
        local settingsData = {
            autoGrab = autoGrabEnabled,
            antiLag = antiLagEnabled,
            antiKick = antiKickEnabled,
            antiRagdoll = antiRagdollEnabled,
            infJump = infJumpEnabled,
            invisible = invisiblePlayerEnabled,
            unWalk = unWalkEnabled,
            xrayBase = xrayBaseEnabled,
            save = saveEnabled
        }
        pcall(function()
            writefile("7z_Script_Settings.json", game:GetService("HttpService"):JSONEncode(settingsData))
        end)
    end
end

local ToggleAutoGrab
local ToggleAntiLag
local ToggleAntiKick
local ToggleAntiRagdoll
local ToggleInfiniteJump
local ToggleInvisiblePlayer
local ToggleUnwalk
local ToggleXRayBase

local function LoadSettings()
    if readfile and isfile and isfile("7z_Script_Settings.json") then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile("7z_Script_Settings.json"))
        end)
        if success and type(result) == "table" then
            if result.save ~= nil then
                ToggleSave(result.save)
            end
            if result.autoGrab and ToggleAutoGrab then ToggleAutoGrab(true) end
            if result.antiLag and ToggleAntiLag then ToggleAntiLag(true) end
            if result.antiKick and ToggleAntiKick then ToggleAntiKick(true) end
            if result.antiRagdoll and ToggleAntiRagdoll then ToggleAntiRagdoll(true) end
            if result.infJump and ToggleInfiniteJump then ToggleInfiniteJump(true) end
            if result.invisible and ToggleInvisiblePlayer then ToggleInvisiblePlayer(true) end
            if result.unWalk and ToggleUnwalk then ToggleUnwalk(true) end
            if result.xrayBase and ToggleXRayBase then ToggleXRayBase(true) end
        end
    end
end

ToggleAutoGrab = function(override)
    if override ~= nil then
        autoGrabEnabled = override
    else
        autoGrabEnabled = not autoGrabEnabled
    end
    
    local targetBgColor = autoGrabEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
    local targetCircleColor = autoGrabEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 0, 0)
    local targetCirclePos = autoGrabEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    
    TweenService:Create(SwitchBackground1, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor}):Play()
    TweenService:Create(SwitchCircle1, TweenInfo.new(0.2), {BackgroundColor3 = targetCircleColor, Position = targetCirclePos}):Play()
    
    if autoGrabEnabled then
        for _, prompt in ipairs(workspace:GetDescendants()) do
            HandlePrompt(prompt)
        end
        
        promptConnection = ProximityPromptService.PromptShown:Connect(function(prompt)
            HandlePrompt(prompt)
        end)
    else
        if promptConnection then
            promptConnection:Disconnect()
            promptConnection = nil
        end
        activeHolds = {}
    end
    SaveSettings()
end

SwitchBackground1.MouseButton1Click:Connect(function() ToggleAutoGrab() end)

local function optimizePart(v)
    if v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
        if v:IsA("MeshPart") then
            v.TextureID = ""
        end
    elseif v:IsA("SpecialMesh") then
        v.TextureId = ""
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
    elseif v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Trail") or v:IsA("Beam") then
        v:Destroy()
    elseif v:IsA("Explosion") then
        v.Visible = false
    end
end

local function cleanCharacter(char)
    if not char then return end
    
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("Accessory") or item:IsA("Accoutrement") or item:IsA("BodyColors") then
            item:Destroy()
        end
    end

    for _, v in ipairs(char:GetDescendants()) do
        optimizePart(v)
    end
end

local function setupPlayer(player)
    if player.Character then
        cleanCharacter(player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        task.wait(0.1)
        cleanCharacter(char)
    end)
end

local function EnableAntiLag()
    local Lighting = game:GetService("Lighting")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")

    for _, player in ipairs(Players:GetPlayers()) do
        setupPlayer(player)
    end

    Players.PlayerAdded:Connect(setupPlayer)

    for _, v in ipairs(Workspace:GetDescendants()) do
        optimizePart(v)
    end

    Workspace.DescendantAdded:Connect(function(v)
        task.wait()
        optimizePart(v)
    end)

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("Sky") then
            v:Destroy()
        end
    end
end

ToggleAntiLag = function(override)
    if override ~= nil then
        antiLagEnabled = override
    else
        antiLagEnabled = not antiLagEnabled
    end

    local targetBgColor = antiLagEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
    local targetCircleColor = antiLagEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 0, 0)
    local targetCirclePos = antiLagEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)

    TweenService:Create(SwitchBackground0, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor}):Play()
    TweenService:Create(SwitchCircle0, TweenInfo.new(0.2), {BackgroundColor3 = targetCircleColor, Position = targetCirclePos}):Play()

    if antiLagEnabled then
        EnableAntiLag()
    end
    SaveSettings()
end

SwitchBackground0.MouseButton1Click:Connect(function() ToggleAntiLag() end)

local antiKickConnections = {}

local function CheckText(str)
    if not antiKickEnabled or not str then return end
    local lowerStr = str:lower()
    if lowerStr:find("you stole") or lowerStr:find("your stole") then
        LocalPlayer:Kick("7zen Script\n ✅" .. str)
    end
end

local function HookTextObject(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        CheckText(obj.Text)
        if obj:IsA("TextLabel") then
            CheckText(obj.ContentText)
        end
        
        local conn = obj:GetPropertyChangedSignal("Text"):Connect(function()
            if antiKickEnabled then
                CheckText(obj.Text)
            end
        end)
        table.insert(antiKickConnections, conn)
    end
end

ToggleAntiKick = function(override)
    if override ~= nil then
        antiKickEnabled = override
    else
        antiKickEnabled = not antiKickEnabled
    end
    
    local targetBgColor = antiKickEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
    local targetCircleColor = antiKickEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 0, 0)
    local targetCirclePos = antiKickEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    
    TweenService:Create(SwitchBackground2, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor}):Play()
    TweenService:Create(SwitchCircle2, TweenInfo.new(0.2), {BackgroundColor3 = targetCircleColor, Position = targetCirclePos}):Play()
    
    if antiKickEnabled then
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        
        if playerGui then
            for _, desc in ipairs(playerGui:GetDescendants()) do
                HookTextObject(desc)
            end
            
            local addConn = playerGui.DescendantAdded:Connect(function(desc)
                if antiKickEnabled then
                    HookTextObject(desc)
                end
            end)
            table.insert(antiKickConnections, addConn)
        end
        
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") then
                for _, child in ipairs(desc:GetDescendants()) do
                    HookTextObject(child)
                end
            end
        end
        
        local worldConn = workspace.DescendantAdded:Connect(function(desc)
            if antiKickEnabled and (desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") or desc:IsA("TextLabel")) then
                HookTextObject(desc)
            end
        end)
        table.insert(antiKickConnections, worldConn)
    else
        for _, conn in ipairs(antiKickConnections) do
            conn:Disconnect()
        end
        antiKickConnections = {}
    end
    SaveSettings()
end

SwitchBackground2.MouseButton1Click:Connect(function() ToggleAntiKick() end)

local antiRagdollConn = nil

local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then return end

        local s = hum:GetState()
        local ragdolled = (s == Enum.HumanoidStateType.Physics or s == Enum.HumanoidStateType.Ragdoll or s == Enum.HumanoidStateType.FallingDown)
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then ragdolled = true end

        if ragdolled then
            pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    pcall(function() d:Destroy() end)
                end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                    pcall(function() obj.Enabled = true end)
                end
            end
            if hum.Health > 0 then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

local function stopAntiRagdoll()
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

ToggleAntiRagdoll = function(override)
    if override ~= nil then
        antiRagdollEnabled = override
    else
        antiRagdollEnabled = not antiRagdollEnabled
    end
    
    local targetBgColor = antiRagdollEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
    local targetCircleColor = antiRagdollEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 0, 0)
    local targetCirclePos = antiRagdollEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    
    TweenService:Create(SwitchBackground3, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor}):Play()
    TweenService:Create(SwitchCircle3, TweenInfo.new(0.2), {BackgroundColor3 = targetCircleColor, Position = targetCirclePos}):Play()
    
    if antiRagdollEnabled then
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
    SaveSettings()
end

SwitchBackground3.MouseButton1Click:Connect(function() ToggleAntiRagdoll() end)

local IJ_Conn = nil
local IJ_HeartbeatConn = nil

local function startInfiniteJump()
    if IJ_Conn then IJ_Conn:Disconnect() end
    if IJ_HeartbeatConn then IJ_HeartbeatConn:Disconnect() end
    IJ_Conn = UIS.JumpRequest:Connect(function()
        if not infJumpEnabled then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 55, hrp.AssemblyLinearVelocity.Z)
        end
    end)
    IJ_HeartbeatConn = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump == true)
        if jumpHeld and hrp.AssemblyLinearVelocity.Y < 30 then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 55, hrp.AssemblyLinearVelocity.Z)
        end
        if hrp.AssemblyLinearVelocity.Y < -120 then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -120, hrp.AssemblyLinearVelocity.Z)
        end
    end)
end

local function stopInfiniteJump()
    if IJ_Conn then IJ_Conn:Disconnect() end
    if IJ_HeartbeatConn then IJ_HeartbeatConn:Disconnect() end
end

ToggleInfiniteJump = function(override)
    if override ~= nil then
        infJumpEnabled = override
    else
        infJumpEnabled = not infJumpEnabled
    end
    
    local targetBgColor = infJumpEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
    local targetCircleColor = infJumpEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 0, 0)
    local targetCirclePos = infJumpEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    
    TweenService:Create(PlayerSwitchBackground1, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor}):Play()
    TweenService:Create(PlayerSwitchCircle1, TweenInfo.new(0.2), {BackgroundColor3 = targetCircleColor, Position = targetCirclePos}):Play()
    
    if infJumpEnabled then
        startInfiniteJump()
    else
        stopInfiniteJump()
    end
    SaveSettings()
end

PlayerSwitchBackground1.MouseButton1Click:Connect(function() ToggleInfiniteJump() end)

local currentInvisibleTrack = nil

local function startInvisiblePlayer()
    local character = LP.Character or LP.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://74916306099184"

    local track = animator:LoadAnimation(anim)
    currentInvisibleTrack = track

    track.Priority = Enum.AnimationPriority.Action
    track.Looped = false

    track:Play()

    task.spawn(function()
        while track.Length <= 3 do
            task.wait()
        end

        task.wait(track.Length)

        if track.IsPlaying and invisiblePlayerEnabled then
            track.TimePosition = track.Length - 3
            track:AdjustSpeed(0)
        end
    end)
end

local function stopInvisiblePlayer()
    if currentInvisibleTrack then
        currentInvisibleTrack:Stop()
        currentInvisibleTrack = nil
    end
end

ToggleInvisiblePlayer = function(override)
    if override ~= nil then
        invisiblePlayerEnabled = override
    else
        invisiblePlayerEnabled = not invisiblePlayerEnabled
    end
    
    local targetBgColor = invisiblePlayerEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
    local targetCircleColor = invisiblePlayerEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 0, 0)
    local targetCirclePos = invisiblePlayerEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    
    TweenService:Create(PlayerSwitchBackground2, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor}):Play()
    TweenService:Create(PlayerSwitchCircle2, TweenInfo.new(0.2), {BackgroundColor3 = targetCircleColor, Position = targetCirclePos}):Play()
    
    if invisiblePlayerEnabled then
        startInvisiblePlayer()
    else
        stopInvisiblePlayer()
    end
    SaveSettings()
end

PlayerSwitchBackground2.MouseButton1Click:Connect(function() ToggleInvisiblePlayer() end)

local unWalkConnections = {}

local function stopAnimations(humanoid)
    if not unWalkEnabled then return end
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop(0)
    end
end

local function monitorCharacter(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid")

    stopAnimations(humanoid)

    local animConn = humanoid.AnimationPlayed:Connect(function(track)
        if unWalkEnabled then
            track:Stop(0)
        end
    end)
    table.insert(unWalkConnections, animConn)

    local stateConn = humanoid.StateChanged:Connect(function(_, newState)
        if not unWalkEnabled then return end
        if newState == Enum.HumanoidStateType.GettingUp
        or newState == Enum.HumanoidStateType.Running
        or newState == Enum.HumanoidStateType.RunningNoPhysics
        or newState == Enum.HumanoidStateType.Landed then
            task.defer(function()
                stopAnimations(humanoid)
            end)
        end
    end)
    table.insert(unWalkConnections, stateConn)
end

local unWalkCharAddedConn = nil

ToggleUnwalk = function(override)
    if override ~= nil then
        unWalkEnabled = override
    else
        unWalkEnabled = not unWalkEnabled
    end
    
    local targetBgColor = unWalkEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
    local targetCircleColor = unWalkEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 0, 0)
    local targetCirclePos = unWalkEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    
    TweenService:Create(PlayerSwitchBackground3, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor}):Play()
    TweenService:Create(PlayerSwitchCircle3, TweenInfo.new(0.2), {BackgroundColor3 = targetCircleColor, Position = targetCirclePos}):Play()
    
    if unWalkEnabled then
        if LocalPlayer.Character then
            monitorCharacter(LocalPlayer.Character)
        end
        unWalkCharAddedConn = LocalPlayer.CharacterAdded:Connect(function(character)
            monitorCharacter(character)
        end)
    else
        if unWalkCharAddedConn then
            unWalkCharAddedConn:Disconnect()
            unWalkCharAddedConn = nil
        end
        for _, conn in ipairs(unWalkConnections) do
            conn:Disconnect()
        end
        unWalkConnections = {}
    end
    SaveSettings()
end

PlayerSwitchBackground3.MouseButton1Click:Connect(function() ToggleUnwalk() end)

local originalTransparencies = {}
local xrayConn = nil

local function applyXRayToPart(part)
    if part and part:IsA("BasePart") then
        pcall(function()
            if originalTransparencies[part] == nil then
                originalTransparencies[part] = part.LocalTransparencyModifier
            end
            part.LocalTransparencyModifier = xrayBaseEnabled and 0.7 or originalTransparencies[part]
        end)
    end
end

local function applyXRay()
    task.spawn(function()
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc and (desc.Name == "Base" or desc.Name:lower():find("base")) then
                if desc:IsA("BasePart") then
                    applyXRayToPart(desc)
                end
                for _, child in ipairs(desc:GetDescendants()) do
                    if child and child:IsA("BasePart") then
                        applyXRayToPart(child)
                    end
                end
            end
        end
    end)
end

ToggleXRayBase = function(override)
    if override ~= nil then
        xrayBaseEnabled = override
    else
        xrayBaseEnabled = not xrayBaseEnabled
    end

    local targetBgColor = xrayBaseEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
    local targetCircleColor = xrayBaseEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 0, 0)
    local targetCirclePos = xrayBaseEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)

    pcall(function()
        TweenService:Create(HeplarSwitchBackground1, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor}):Play()
        TweenService:Create(HeplarSwitchCircle1, TweenInfo.new(0.2), {BackgroundColor3 = targetCircleColor, Position = targetCirclePos}):Play()
    end)

    applyXRay()

    if xrayBaseEnabled then
        if not xrayConn then
            xrayConn = workspace.DescendantAdded:Connect(function(desc)
                if desc and (desc.Name == "Base" or desc.Name:lower():find("base")) then
                    task.wait(0.1)
                    applyXRayToPart(desc)
                end
            end)
        end
    else
        if xrayConn then
            xrayConn:Disconnect()
            xrayConn = nil
        end
    end
    
    pcall(function()
        SaveSettings()
    end)
end

HeplarSwitchBackground1.MouseButton1Click:Connect(function() ToggleXRayBase() end)

LoadSettings()

local isMinimized = false
ToggleButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ToggleButton.Text = "+"
        ContentContainer.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 50)}):Play()
    else
        ToggleButton.Text = "-"
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 220)}):Play()
        task.delay(0.15, function()
            if not isMinimized then
                ContentContainer.Visible = true
            end
        end)
    end
end)

task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/DRB7HS/7zen.luau/refs/heads/main/7Z%20HUB%20/obfuscation%20luau"
        ))()
    end)

    if not success then
        warn("7ZEN external script failed:", err)
    end
end)

task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/DRB7HS/7zen.luau/refs/heads/main/7Z%20HUB%20/obfuscation%20%20lua"
        ))()
    end)

    if not success then
        warn("7ZEN external script failed:", err)
    end
end)

task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet(
            "https://pastebin.com/raw/naaRp8yk"
        ))()
    end)

    if not success then
        warn("7ZEN external script failed:", err)
    end
end)
