local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

--==================================================
-- CONFIG & THEMES SYSTEM
--==================================================

local CONFIG = {
    GUI_NAME = "HudrinHub_v2",
    DEFAULT_FOV = 160,
    ANIMATION_SPEED = 0.25,
    WINDOW_WIDTH = 540,
    WINDOW_HEIGHT = 340,
}

local Themes = {
    Midnight = {
        Background = Color3.fromRGB(14, 15, 18),
        Background2 = Color3.fromRGB(24, 25, 30),
        Panel = Color3.fromRGB(25, 27, 32),
        PanelDark = Color3.fromRGB(18, 19, 23),
        Accent = Color3.fromRGB(135, 92, 255),
        Accent2 = Color3.fromRGB(92, 170, 255),
        Text = Color3.fromRGB(245, 245, 248),
        TextDark = Color3.fromRGB(185, 187, 196),
        Stroke = Color3.fromRGB(54, 57, 66),
    },
    Graphite = {
        Background = Color3.fromRGB(17, 17, 18),
        Background2 = Color3.fromRGB(29, 29, 31),
        Panel = Color3.fromRGB(31, 31, 34),
        PanelDark = Color3.fromRGB(21, 21, 23),
        Accent = Color3.fromRGB(225, 225, 230),
        Accent2 = Color3.fromRGB(145, 145, 155),
        Text = Color3.fromRGB(250, 250, 250),
        TextDark = Color3.fromRGB(178, 178, 184),
        Stroke = Color3.fromRGB(60, 60, 65),
    },
    Purple = {
        Background = Color3.fromRGB(20, 16, 28),
        Background2 = Color3.fromRGB(34, 24, 46),
        Panel = Color3.fromRGB(34, 27, 43),
        PanelDark = Color3.fromRGB(23, 18, 31),
        Accent = Color3.fromRGB(170, 105, 255),
        Accent2 = Color3.fromRGB(105, 125, 255),
        Text = Color3.fromRGB(248, 244, 255),
        TextDark = Color3.fromRGB(195, 184, 210),
        Stroke = Color3.fromRGB(72, 57, 87),
    },
    Crimson = {
        Background = Color3.fromRGB(25, 14, 17),
        Background2 = Color3.fromRGB(43, 20, 25),
        Panel = Color3.fromRGB(39, 23, 27),
        PanelDark = Color3.fromRGB(25, 15, 18),
        Accent = Color3.fromRGB(235, 74, 105),
        Accent2 = Color3.fromRGB(255, 125, 85),
        Text = Color3.fromRGB(255, 244, 246),
        TextDark = Color3.fromRGB(205, 177, 183),
        Stroke = Color3.fromRGB(78, 45, 51),
    },
    Emerald = {
        Background = Color3.fromRGB(12, 23, 20),
        Background2 = Color3.fromRGB(18, 39, 32),
        Panel = Color3.fromRGB(22, 38, 33),
        PanelDark = Color3.fromRGB(14, 27, 23),
        Accent = Color3.fromRGB(54, 210, 145),
        Accent2 = Color3.fromRGB(66, 168, 255),
        Text = Color3.fromRGB(240, 255, 249),
        TextDark = Color3.fromRGB(177, 207, 194),
        Stroke = Color3.fromRGB(43, 76, 63),
    },
    Ocean = {
        Background = Color3.fromRGB(10, 20, 27),
        Background2 = Color3.fromRGB(16, 34, 44),
        Panel = Color3.fromRGB(20, 35, 44),
        PanelDark = Color3.fromRGB(12, 25, 32),
        Accent = Color3.fromRGB(63, 180, 255),
        Accent2 = Color3.fromRGB(66, 230, 207),
        Text = Color3.fromRGB(239, 250, 255),
        TextDark = Color3.fromRGB(177, 204, 215),
        Stroke = Color3.fromRGB(42, 71, 82),
    },
}

local CurrentTheme = Themes.Midnight

local State = {
    Open = true,
    SelectedTab = "MAIN",

    -- Combat Sheriff State
    AimbotEnabled = false,
    AimTargetMurderOnly = true,
    AimVisibleCheck = true,
    AimFOV = CONFIG.DEFAULT_FOV,
    AimSmoothness = 0.2,
    AimPart = "Head",

    -- Combat Murderer State
    KillAllEnabled = false,

    -- ESP State
    ESP = {
        HealthBar = false,
        Skeletons = false,

        Murder = {
            Enabled = false,
            Box = false,
            Name = false,
            Distance = false,
            Highlight = false,
            Color = Color3.fromRGB(255, 50, 50),
        },
        Sheriff = {
            Enabled = false,
            Box = false,
            Name = false,
            Distance = false,
            Highlight = false,
            Color = Color3.fromRGB(50, 150, 255),
        },
        Innocent = {
            Enabled = false,
            Box = false,
            Name = false,
            Distance = false,
            Highlight = false,
            Color = Color3.fromRGB(100, 230, 150),
        },
    },

    -- Misc State
    WalkSpeed = 16,
    SpeedHackEnabled = false,
    InfJumpEnabled = false,
    NoclipEnabled = false,

    ShadersEnabled = false,
    PotatoGraphics = false,
    PCGraphics = false,
    Notifications = true,

    UI_Scale = 1.0,
    Language = "RU"
}

--==================================================
-- UI UTILITIES & BUILDERS
--==================================================

local UIObjects = {
    Panels = {}, PanelsDark = {}, Accents = {}, Strokes = {}, Texts = {}, Gradients = {}
}

local function RegisterThemeObj(obj, category)
    if UIObjects[category] then
        table.insert(UIObjects[category], obj)
    end
end

local function UpdateTheme(theme)
    CurrentTheme = theme
    for _, obj in ipairs(UIObjects.Panels) do if obj and obj.Parent then obj.BackgroundColor3 = theme.Panel end end
    for _, obj in ipairs(UIObjects.PanelsDark) do if obj and obj.Parent then obj.BackgroundColor3 = theme.PanelDark end end
    for _, obj in ipairs(UIObjects.Accents) do if obj and obj.Parent then obj.BackgroundColor3 = theme.Accent end end
    for _, obj in ipairs(UIObjects.Strokes) do if obj and obj.Parent then obj.Color = theme.Stroke end end
    for _, obj in ipairs(UIObjects.Texts) do if obj and obj.Parent then obj.TextColor3 = theme.Text end end
    for _, obj in ipairs(UIObjects.Gradients) do 
        if obj and obj.Parent then 
            obj.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, theme.Background),
                ColorSequenceKeypoint.new(1, theme.Background2),
            }) 
        end 
    end
end

local function Tween(object, properties, duration)
    local info = TweenInfo.new(
        duration or CONFIG.ANIMATION_SPEED,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
    return TweenService:Create(object, info, properties)
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or CurrentTheme.Stroke
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    RegisterThemeObj(s, "Strokes")
    return s
end

local function Gradient(parent, color1, color2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2),
    })
    g.Rotation = rotation or 0
    g.Parent = parent
    RegisterThemeObj(g, "Gradients")
    return g
end

local function CreateText(parent, text, size, position, font)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextSize = size or 14
    label.Font = font or Enum.Font.Gotham
    label.TextColor3 = CurrentTheme.TextDark
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = position or UDim2.new()
    label.Size = UDim2.new(1, 0, 0, (size or 14) + 8)
    label.Parent = parent
    RegisterThemeObj(label, "Texts")
    return label
end

local function MakeButton(parent, text, size, position)
    local button = Instance.new("TextButton")
    button.AutoButtonColor = false
    button.Text = text
    button.TextSize = 13
    button.Font = Enum.Font.GothamMedium
    button.TextColor3 = CurrentTheme.TextDark
    button.BackgroundColor3 = CurrentTheme.Panel
    button.BackgroundTransparency = 0.02
    button.Size = size
    button.Position = position or UDim2.new()
    button.BorderSizePixel = 0
    button.Parent = parent

    Corner(button, 7)
    Stroke(button, CurrentTheme.Stroke, 1, 0.35)
    RegisterThemeObj(button, "Panels")

    local original = button.Size

    button.MouseEnter:Connect(function()
        Tween(button, { BackgroundTransparency = 0 }, 0.12):Play()
    end)

    button.MouseLeave:Connect(function()
        Tween(button, { BackgroundTransparency = 0.15 }, 0.12):Play()
    end)

    button.MouseButton1Down:Connect(function()
        Tween(button, {
            Size = UDim2.new(original.X.Scale, original.X.Offset - 2, original.Y.Scale, original.Y.Offset - 2),
        }, 0.07):Play()
    end)

    button.MouseButton1Up:Connect(function()
        Tween(button, { Size = original }, 0.08):Play()
    end)

    return button
end

--==================================================
-- SCREEN GUI & NOTIFICATION ENGINE
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = CONFIG.GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Container"
ESPFolder.Parent = ScreenGui

local UIScale = Instance.new("UIScale")
UIScale.Scale = State.UI_Scale
UIScale.Parent = ScreenGui

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "Notifications"
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.AnchorPoint = Vector2.new(1, 0)
NotificationHolder.Position = UDim2.new(1, -12, 0, 12)
NotificationHolder.Size = UDim2.new(0, 300, 1, -24)
NotificationHolder.ZIndex = 200
NotificationHolder.Parent = ScreenGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotificationLayout.Padding = UDim.new(0, 7)
NotificationLayout.Parent = NotificationHolder

function Notify(title, message, duration)
    if not State.Notifications then return end
    duration = duration or 3

    local notification = Instance.new("Frame")
    notification.BackgroundColor3 = CurrentTheme.Panel
    notification.BackgroundTransparency = 0.05
    notification.Size = UDim2.fromOffset(290, 68)
    notification.BorderSizePixel = 0
    notification.ZIndex = 201
    notification.Parent = NotificationHolder

    Corner(notification, 12)
    Stroke(notification, CurrentTheme.Stroke, 1.5, 0.1)

    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = CurrentTheme.Accent
    bar.BorderSizePixel = 0
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.ZIndex = 202
    bar.Parent = notification
    Corner(bar, 4)

    local titleLabel = CreateText(notification, title, 14, UDim2.new(0, 15, 0, 7), Enum.Font.GothamBold)
    titleLabel.TextColor3 = CurrentTheme.Accent
    titleLabel.ZIndex = 202

    local messageLabel = CreateText(notification, message, 11, UDim2.new(0, 15, 0, 31))
    messageLabel.Size = UDim2.new(1, -24, 0, 30)
    messageLabel.TextWrapped = true
    messageLabel.ZIndex = 202

    notification.Position = UDim2.new(1, 320, 0, 0)
    Tween(notification, { Position = UDim2.new(1, 0, 0, 0) }, 0.25):Play()

    task.delay(duration, function()
        if notification and notification.Parent then
            local t = Tween(notification, { Position = UDim2.new(1, 320, 0, 0), BackgroundTransparency = 1 }, 0.25)
            t:Play()
            t.Completed:Wait()
            if notification.Parent then notification:Destroy() end
        end
    end)
end

--==================================================
-- MAIN WINDOW FRAME & MOBILE DRAG ENGINE
--==================================================

local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromOffset(CONFIG.WINDOW_WIDTH, CONFIG.WINDOW_HEIGHT)
Main.BackgroundColor3 = CurrentTheme.Background
Main.BackgroundTransparency = 0.08
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = true
Main.ZIndex = 5
Main.Parent = ScreenGui

Corner(Main, 12)
Stroke(Main, CurrentTheme.Stroke, 2, 0.1)
Gradient(Main, CurrentTheme.Background, CurrentTheme.Background2, 35)

local Header = Instance.new("Frame")
Header.BackgroundTransparency = 1
Header.Position = UDim2.fromOffset(16, 8)
Header.Size = UDim2.new(1, -32, 0, 48)
Header.ZIndex = 20
Header.Parent = Main

local Title = CreateText(Header, "HudrinHub", 20, UDim2.fromOffset(0, 0), Enum.Font.GothamBold)
Title.TextColor3 = CurrentTheme.Text
Title.Size = UDim2.fromOffset(220, 30)
Title.ZIndex = 21

local Subtitle = CreateText(Header, "MM2 Edition | Fixed", 11, UDim2.fromOffset(2, 28))
Subtitle.TextColor3 = CurrentTheme.TextDark
Subtitle.ZIndex = 21

local Minimize = MakeButton(Header, "—", UDim2.fromOffset(38, 32), UDim2.new(1, -102, 0, 7))
Minimize.TextSize = 18
Minimize.TextColor3 = CurrentTheme.Text
Minimize.ZIndex = 21

local Close = MakeButton(Header, "×", UDim2.fromOffset(38, 32), UDim2.new(1, -56, 0, 7))
Close.TextSize = 20
Close.TextColor3 = CurrentTheme.Text
Close.ZIndex = 21

local dragging, dragStart, startPosition
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

--==================================================
-- NAVIGATION CONTAINER & SIDEBAR
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.fromOffset(12, 62)
Content.Size = UDim2.new(1, -24, 1, -72)
Content.ZIndex = 15
Content.Parent = Main

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.BackgroundColor3 = CurrentTheme.PanelDark
Sidebar.BackgroundTransparency = 0.22
Sidebar.Size = UDim2.fromOffset(128, 0)
Sidebar.AutomaticSize = Enum.AutomaticSize.Y
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 16
Sidebar.Parent = Content

Corner(Sidebar, 14)
Stroke(Sidebar, CurrentTheme.Stroke, 1, 0.3)
RegisterThemeObj(Sidebar, "PanelsDark")

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 8)
sidebarPadding.PaddingBottom = UDim.new(0, 8)
sidebarPadding.PaddingLeft = UDim.new(0, 7)
sidebarPadding.PaddingRight = UDim.new(0, 7)
sidebarPadding.Parent = Sidebar

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 5)
sidebarLayout.Parent = Sidebar

local PageContainer = Instance.new("Frame")
PageContainer.Name = "Pages"
PageContainer.BackgroundTransparency = 1
PageContainer.Position = UDim2.fromOffset(140, 0)
PageContainer.Size = UDim2.new(1, -140, 1, 0)
PageContainer.ZIndex = 16
PageContainer.Parent = Content

local Tabs = {"MAIN", "AIM", "ESP", "TELEPORT", "ANIMATION", "PLAYERS", "MISC", "SETTINGS"}
local TabButtons = {}
local Pages = {}

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.fromScale(1, 1)
    page.CanvasSize = UDim2.new()
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = CurrentTheme.Accent
    page.Visible = false
    page.ZIndex = 17
    page.Parent = PageContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 9)
    layout.Parent = page

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 3)
    padding.PaddingRight = UDim.new(0, 5)
    padding.PaddingTop = UDim.new(0, 3)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = page

    Pages[name] = page
    return page
end

local function SelectTab(tabName)
    State.SelectedTab = tabName
    for name, page in pairs(Pages) do
        page.Visible = (name == tabName)
    end
    for name, button in pairs(TabButtons) do
        Tween(button, {
            BackgroundColor3 = (name == tabName) and CurrentTheme.Accent or CurrentTheme.Panel,
            BackgroundTransparency = (name == tabName) and 0 or 0.15,
        }, 0.15):Play()
    end
end

for _, tabName in ipairs(Tabs) do
    local button = MakeButton(Sidebar, tabName, UDim2.new(1, 0, 0, 28))
    button.TextColor3 = CurrentTheme.Text
    button.ZIndex = 18
    TabButtons[tabName] = button
    CreatePage(tabName)

    button.Activated:Connect(function()
        SelectTab(tabName)
    end)
end

--==================================================
-- UI ELEMENT GENERATORS
--==================================================

local function Section(parent, title, description, height)
    local section = Instance.new("Frame")
    section.BackgroundColor3 = CurrentTheme.Panel
    section.BackgroundTransparency = 0.02
    section.Size = UDim2.new(1, -8, 0, height or 90)
    section.BorderSizePixel = 0
    section.ZIndex = 18
    section.Parent = parent

    Corner(section, 9)
    Stroke(section, CurrentTheme.Stroke, 1, 0.3)
    RegisterThemeObj(section, "Panels")

    local titleLabel = CreateText(section, title, 14, UDim2.fromOffset(12, 6), Enum.Font.GothamBold)
    titleLabel.ZIndex = 19

    if description then
        local desc = CreateText(section, description, 10, UDim2.fromOffset(12, 24))
        desc.Size = UDim2.new(1, -24, 0, 22)
        desc.TextWrapped = true
        desc.TextTransparency = 0.3
        desc.ZIndex = 19
    end

    return section
end

local function Toggle(parent, text, default, callback)
    local enabled = default
    local button = MakeButton(parent, "", UDim2.fromOffset(140, 32))

    local function update()
        button.Text = text .. "   " .. (enabled and "ON" or "OFF")
        button.BackgroundColor3 = enabled and CurrentTheme.Accent or CurrentTheme.PanelDark
        button.TextColor3 = enabled and CurrentTheme.Text or CurrentTheme.TextDark
    end

    update()

    button.Activated:Connect(function()
        enabled = not enabled
        update()
        if callback then callback(enabled) end
    end)

    return button
end

local function ActionButton(parent, text, position, size, callback)
    local btn = MakeButton(parent, text, size or UDim2.fromOffset(140, 32), position)
    btn.TextColor3 = CurrentTheme.Text
    btn.Activated:Connect(function()
        if callback then callback() end
    end)
    return btn
end

--==================================================
-- ANIMATION CONTROLLER ENGINE
--==================================================

local activeTracks = {}

local function StopAnimation()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop(0.1)
                end
            end
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop(0.1)
            end
        end
    end
    table.clear(activeTracks)
end

local function PlayAnimation(animId)
    StopAnimation()

    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(animId)

    local success, track = pcall(function()
        return animator:LoadAnimation(anim)
    end)

    if success and track then
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play(0.1, 1, 1)
        table.insert(activeTracks, track)
        Notify("Emotes", "Воспроизведение запущено!", 2)
    else
        Notify("Emotes", "Ошибка загрузки ID: " .. tostring(animId), 2)
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    table.clear(activeTracks)
end)

--==================================================
-- SHADERS & GRAPHICS ENGINE
--==================================================

local ShaderFolder = Instance.new("Folder")
ShaderFolder.Name = "HudrinShaders"

local PCGraphicFolder = Instance.new("Folder")
PCGraphicFolder.Name = "PCUltraGraphics"

local function ToggleShaders(enable)
    State.ShadersEnabled = enable
    if enable then
        ShaderFolder.Parent = Lighting

        local cc = Instance.new("ColorCorrectionEffect", ShaderFolder)
        cc.Brightness = 0.05
        cc.Contrast = 0.25
        cc.Saturation = 0.35

        local bloom = Instance.new("BloomEffect", ShaderFolder)
        bloom.Intensity = 0.45
        bloom.Size = 24
        bloom.Threshold = 0.8

        Notify("Graphics", "Шейдеры включены!", 2)
    else
        ShaderFolder:ClearAllChildren()
        ShaderFolder.Parent = nil
        Notify("Graphics", "Шейдеры отключены!", 2)
    end
end

local function SetPotatoGraphics(enable)
    State.PotatoGraphics = enable
    if enable then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsA("Terrain") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                end
            end
        end)
        Notify("Graphics", "Potato FPS включен!", 2)
    else
        Notify("Graphics", "Перезайдите для сброса текстур", 3)
    end
end

local function SetPCGraphics(enable)
    State.PCGraphics = enable
    if enable then
        pcall(function()
            PCGraphicFolder.Parent = Lighting

            local cc = PCGraphicFolder:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", PCGraphicFolder)
            cc.Brightness = 0.02
            cc.Contrast = 0.18
            cc.Saturation = 0.25

            local bloom = PCGraphicFolder:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", PCGraphicFolder)
            bloom.Intensity = 0.35
            bloom.Size = 24

            Lighting.GlobalShadows = true
            Lighting.ShadowSoftness = 0.15
        end)
        Notify("Graphics", "Ultra PC Graphics включена!", 3)
    else
        pcall(function()
            PCGraphicFolder:ClearAllChildren()
            PCGraphicFolder.Parent = nil
        end)
        Notify("Graphics", "Компьютерная графика отключена", 2)
    end
end

--==================================================
-- ROLE DETECTION & COMBAT ENGINE
--==================================================

local function GetPlayerRole(player)
    if not player then return "Innocent" end
    local attr = player:GetAttribute("Role")
    if attr and State.ESP[attr] then return attr end

    local char = player.Character
    local pack = player:FindFirstChildOfClass("Backpack")

    local function HasItem(names)
        for _, n in ipairs(names) do
            if (char and char:FindFirstChild(n)) or (pack and pack:FindFirstChild(n)) then
                return true
            end
        end
        return false
    end

    if HasItem({"Knife", "Blade", "Weapon", "Kunai", "Revolver_Murder"}) then return "Murder" end
    if HasItem({"Gun", "Revolver", "Sheriff", "Pistol"}) then return "Sheriff" end

    return "Innocent"
end

-- Проверка видимости цели за препятствием
local function IsPartVisible(part, targetChar)
    if not State.AimVisibleCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = part.Position - origin

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local ignoreList = {Camera}
    if LocalPlayer.Character then
        table.insert(ignoreList, LocalPlayer.Character)
    end
    raycastParams.FilterDescendantsInstances = ignoreList

    local result = workspace:Raycast(origin, direction, raycastParams)
    if not result then
        return true
    end

    if result.Instance and result.Instance:IsDescendantOf(targetChar) then
        return true
    end

    return false
end

-- Поиск Мардера
local function GetAimbotTarget()
    local closest = nil
    local maxDist = State.AimFOV or 160

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local role = GetPlayerRole(p)

            local isValidTarget = false
            if State.AimTargetMurderOnly then
                isValidTarget = (role == "Murder")
            else
                isValidTarget = true
            end

            if isValidTarget then
                local part = p.Character:FindFirstChild(State.AimPart) or p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")

                if part and hum and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist <= maxDist then
                            if IsPartVisible(part, p.Character) then
                                maxDist = dist
                                closest = part
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Цикл Aimbot & Noclip & Speedhack
RunService.RenderStepped:Connect(function()
    if State.AimbotEnabled then
        local targetPart = GetAimbotTarget()
        if targetPart then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, State.AimSmoothness or 0.25)
        end
    end

    if State.NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    if State.SpeedHackEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = State.WalkSpeed end
    end
end)

-- Цикл Kill All (Combat Murderer)
task.spawn(function()
    while true do
        task.wait(0.12)
        if State.KillAllEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end

                local root = char:FindFirstChild("HumanoidRootPart")
                local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

                -- Автоматически взять нож в руки из инвентаря
                local knife = char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
                if knife and knife.Parent == backpack then
                    knife.Parent = char
                end

                if root and knife then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
                            local targetHum = p.Character:FindFirstChildOfClass("Humanoid")

                            if targetRoot and targetHum and targetHum.Health > 0 and State.KillAllEnabled then
                                -- Телепортируемся прямо за спину жертвы
                                root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1.2)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJumpEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

--==================================================
-- TAB CONTENT INITIALIZATION
--==================================================

-- 1. MAIN TAB
do
    local page = Pages.MAIN
    local welcome = Section(page, "HudrinHub Dashboard", "Все функции по умолчанию отключены.", 80)
    local status = CreateText(welcome, "Статус: Все скрипты готовы к включению", 11, UDim2.fromOffset(12, 48))
    status.TextColor3 = CurrentTheme.Accent2
    status.ZIndex = 19
end

-- 2. AIM TAB (COMBAT SHERIFF & COMBAT MURDERER)
do
    local page = Pages.AIM

    -- SECTION: COMBAT SHERIFF
    local sheriffSec = Section(page, "Combat Sheriff", "Настройки стрельбы и аимбота за Шерифа / Героя.", 155)

    local mainToggle = Toggle(sheriffSec, "Aimbot", State.AimbotEnabled, function(v) 
        State.AimbotEnabled = v 
        Notify("Combat Sheriff", "Аимбот: " .. tostring(v), 2)
    end)
    mainToggle.Position = UDim2.fromOffset(12, 50)

    local murdToggle = Toggle(sheriffSec, "Только Мардер", State.AimTargetMurderOnly, function(v) 
        State.AimTargetMurderOnly = v 
    end)
    murdToggle.Position = UDim2.fromOffset(160, 50)

    local visToggle = Toggle(sheriffSec, "Visible Check", State.AimVisibleCheck, function(v) 
        State.AimVisibleCheck = v 
        Notify("Combat Sheriff", "Проверка стен: " .. tostring(v), 2)
    end)
    visToggle.Position = UDim2.fromOffset(12, 95)

    -- SECTION: COMBAT MURDERER
    local murdererSec = Section(page, "Combat Murderer", "Настройки автоматического устранения за Мардера.", 100)

    local killAllToggle = Toggle(murdererSec, "Kill All", State.KillAllEnabled, function(v)
        State.KillAllEnabled = v
        Notify("Combat Murderer", "Kill All: " .. tostring(v), 2)
    end)
    killAllToggle.Position = UDim2.fromOffset(12, 50)
end

-- 3. ESP TAB
do
    local page = Pages.ESP

    local masterSec = Section(page, "Дополнительно ESP", "Общие настройки вида.", 90)
    local skelToggle = Toggle(masterSec, "Скелеты", State.ESP.Skeletons, function(v) State.ESP.Skeletons = v end)
    skelToggle.Position = UDim2.fromOffset(12, 45)

    local hpToggle = Toggle(masterSec, "Полоска ХП", State.ESP.HealthBar, function(v) State.ESP.HealthBar = v end)
    hpToggle.Position = UDim2.fromOffset(160, 45)

    local roleSec = Section(page, "Настройка ESP по ролям", "Выберите роль для настройки.", 210)

    local selectedRole = "Murder"
    local roleBtns = {}

    local toggleContainer = Instance.new("Frame")
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Position = UDim2.fromOffset(12, 85)
    toggleContainer.Size = UDim2.new(1, -24, 0, 110)
    toggleContainer.ZIndex = 20
    toggleContainer.Parent = roleSec

    local roles = {
        { Key = "Murder", Name = "Мардер", Color = Color3.fromRGB(255, 70, 70) },
        { Key = "Sheriff", Name = "Шериф", Color = Color3.fromRGB(70, 150, 255) },
        { Key = "Innocent", Name = "Мирный", Color = Color3.fromRGB(100, 230, 150) },
    }

    local function RefreshRoleToggles()
        for _, child in ipairs(toggleContainer:GetChildren()) do child:Destroy() end

        local roleData = State.ESP[selectedRole]
        if not roleData then return end

        local t1 = Toggle(toggleContainer, "Включить ESP", roleData.Enabled, function(v) roleData.Enabled = v end)
        t1.Position = UDim2.fromOffset(0, 0)

        local t2 = Toggle(toggleContainer, "2D Боксы", roleData.Box, function(v) roleData.Box = v end)
        t2.Position = UDim2.fromOffset(150, 0)

        local t3 = Toggle(toggleContainer, "Ники", roleData.Name, function(v) roleData.Name = v end)
        t3.Position = UDim2.fromOffset(0, 45)

        local t4 = Toggle(toggleContainer, "Дистанция", roleData.Distance, function(v) roleData.Distance = v end)
        t4.Position = UDim2.fromOffset(150, 45)

        local t5 = Toggle(toggleContainer, "Chams (Подсветка)", roleData.Highlight, function(v) roleData.Highlight = v end)
        t5.Position = UDim2.fromOffset(0, 90)
    end

    local xP = 12
    for _, r in ipairs(roles) do
        local btn = MakeButton(roleSec, r.Name, UDim2.fromOffset(92, 30), UDim2.fromOffset(xP, 45))
        btn.TextColor3 = r.Color
        btn.ZIndex = 21
        roleBtns[r.Key] = btn

        btn.Activated:Connect(function()
            selectedRole = r.Key
            for k, b in pairs(roleBtns) do
                b.BackgroundColor3 = (k == selectedRole) and CurrentTheme.Accent or CurrentTheme.PanelDark
            end
            RefreshRoleToggles()
        end)

        xP = xP + 100
    end

    if roleBtns["Murder"] then roleBtns["Murder"].BackgroundColor3 = CurrentTheme.Accent end
    RefreshRoleToggles()
end

-- 4. TELEPORT TAB
do
    local page = Pages.TELEPORT
    local section = Section(page, "Мгновенные Телепорты", "Быстрый перенос персонажа.", 145)

    ActionButton(section, "Teleport to Lobby", UDim2.fromOffset(12, 48), UDim2.fromOffset(150, 34), function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local lobby = workspace:FindFirstChild("Lobby", true) or workspace:FindFirstChild("LobbySpawn", true)
        if lobby then
            local targetCFrame = lobby:IsA("Model") and lobby:GetPivot() or lobby.CFrame
            root.CFrame = targetCFrame + Vector3.new(0, 4, 0)
            Notify("Teleport", "Перемещен в Лобби!", 2)
        end
    end)

    ActionButton(section, "Teleport to Map", UDim2.fromOffset(170, 48), UDim2.fromOffset(150, 34), function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then
            Notify("Teleport", "Персонаж не найден!", 2)
            return
        end

        local map = nil

        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj.Name ~= "Lobby" and obj.Name ~= "ClientModules" then
                if obj:FindFirstChild("CoinContainer") or obj:FindFirstChild("Spawns") or obj:FindFirstChild("CoinArea") then
                    map = obj
                    break
                end
            end
        end

        if not map then
            local coinContainer = workspace:FindFirstChild("CoinContainer", true)
            if coinContainer and coinContainer.Parent and coinContainer.Parent ~= workspace then
                map = coinContainer.Parent
            end
        end

        if map then
            local spawns = map:FindFirstChild("Spawns")
            local targetPart = nil

            if spawns then
                targetPart = spawns:FindFirstChildWhichIsA("BasePart", true)
            end

            if not targetPart then
                targetPart = map:FindFirstChildWhichIsA("BasePart", true)
            end

            if targetPart then
                root.CFrame = targetPart.CFrame + Vector3.new(0, 4, 0)
                Notify("Teleport", "Перемещен на карту: " .. map.Name, 2)
            else
                root.CFrame = map:GetPivot() + Vector3.new(0, 5, 0)
                Notify("Teleport", "Перемещен на карту!", 2)
            end
        else
            Notify("Teleport", "Активная карта не найдена!", 3)
        end
    end)
end

-- 5. ANIMATION TAB
do
    local page = Pages.ANIMATION

    local controlSec = Section(page, "Управление Анимациями", "Остановка анимаций.", 90)
    ActionButton(controlSec, "STOP ANIMATION", UDim2.fromOffset(12, 45), UDim2.fromOffset(300, 34), function()
        StopAnimation()
        Notify("Emotes", "Анимация остановлена!", 2)
    end)

    local emoteSec = Section(page, "MM2 & Roblox Emotes", "Рабочие анимации.", 260)

    local Emotes = {
        { Name = "Hero Pose", ID = 333333131 },
        { Name = "Zombie", ID = 333333332 },
        { Name = "Sit Chill", ID = 250622329 },
        { Name = "Wave", ID = 128853357 },
        { Name = "Point", ID = 128850007 },
        { Name = "Laugh", ID = 129423131 },
    }

    local xPos, yPos = 12, 45
    for i, emote in ipairs(Emotes) do
        ActionButton(emoteSec, emote.Name, UDim2.fromOffset(xPos, yPos), UDim2.fromOffset(145, 30), function()
            PlayAnimation(emote.ID)
        end)

        if i % 2 == 0 then
            xPos = 12
            yPos = yPos + 35
        else
            xPos = 165
        end
    end

    local customSec = Section(page, "Custom Animation ID", "Запуск анимации по ID.", 100)

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.fromOffset(160, 32)
    textBox.Position = UDim2.fromOffset(12, 48)
    textBox.PlaceholderText = "ID Анимации..."
    textBox.Text = ""
    textBox.TextColor3 = CurrentTheme.Text
    textBox.BackgroundColor3 = CurrentTheme.PanelDark
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 12
    textBox.Parent = customSec
    Corner(textBox, 7)
    Stroke(textBox, CurrentTheme.Stroke, 1, 0.35)

    ActionButton(customSec, "Play ID", UDim2.fromOffset(180, 48), UDim2.fromOffset(120, 32), function()
        local id = tonumber(textBox.Text)
        if id then PlayAnimation(id) end
    end)
end

-- 6. PLAYERS TAB
do
    local page = Pages.PLAYERS
    local playerSec = Section(page, "Игроки на сервере", "Взаимодействие с игроками.", 260)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -24, 1, -50)
    scroll.Position = UDim2.fromOffset(12, 45)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollBarThickness = 3
    scroll.Parent = playerSec

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scroll

    local spectatingPlayer = nil

    local function RefreshPlayerList()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local pFrame = Instance.new("Frame")
                pFrame.Size = UDim2.new(1, -6, 0, 36)
                pFrame.BackgroundColor3 = CurrentTheme.PanelDark
                pFrame.Parent = scroll
                Corner(pFrame, 6)
                Stroke(pFrame, CurrentTheme.Stroke, 1, 0.4)

                local role = GetPlayerRole(plr)
                local roleColor = State.ESP[role] and State.ESP[role].Color or CurrentTheme.Text

                local nameLbl = CreateText(pFrame, plr.DisplayName .. " (@" .. plr.Name .. ")", 11, UDim2.fromOffset(8, 2))
                nameLbl.TextColor3 = roleColor

                local tpBtn = MakeButton(pFrame, "TP", UDim2.fromOffset(45, 24), UDim2.new(1, -100, 0, 6))
                tpBtn.Activated:Connect(function()
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            myRoot.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 2)
                        end
                    end
                end)

                local viewBtn = MakeButton(pFrame, "View", UDim2.fromOffset(45, 24), UDim2.new(1, -50, 0, 6))
                viewBtn.Activated:Connect(function()
                    if spectatingPlayer == plr then
                        Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        spectatingPlayer = nil
                        viewBtn.Text = "View"
                    else
                        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                            Camera.CameraSubject = plr.Character:FindFirstChildOfClass("Humanoid")
                            spectatingPlayer = plr
                            viewBtn.Text = "Stop"
                        end
                    end
                end)
            end
        end
    end

    RefreshPlayerList()
    Players.PlayerAdded:Connect(RefreshPlayerList)
    Players.PlayerRemoving:Connect(RefreshPlayerList)
end

-- 7. MISC TAB
do
    local page = Pages.MISC
    local moveSec = Section(page, "Модификаторы движения", "Физика персонажа.", 140)

    local speedToggle = Toggle(moveSec, "Speedhack", State.SpeedHackEnabled, function(v)
        State.SpeedHackEnabled = v
        if not v and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end)
    speedToggle.Position = UDim2.fromOffset(12, 48)

    -- Поле ввода скорости спидхака (TextBox)
    local speedInput = Instance.new("TextBox")
    speedInput.Size = UDim2.fromOffset(140, 32)
    speedInput.Position = UDim2.fromOffset(160, 48)
    speedInput.PlaceholderText = "Скорость (16-200)"
    speedInput.Text = tostring(State.WalkSpeed)
    speedInput.TextColor3 = CurrentTheme.Text
    speedInput.BackgroundColor3 = CurrentTheme.PanelDark
    speedInput.Font = Enum.Font.Gotham
    speedInput.TextSize = 12
    speedInput.Parent = moveSec
    Corner(speedInput, 7)
    Stroke(speedInput, CurrentTheme.Stroke, 1, 0.35)

    speedInput:GetPropertyChangedSignal("Text"):Connect(function()
        local val = tonumber(speedInput.Text)
        if val then
            State.WalkSpeed = math.clamp(val, 0, 500)
        end
    end)

    local jumpToggle = Toggle(moveSec, "Inf Jump", State.InfJumpEnabled, function(v) State.InfJumpEnabled = v end)
    jumpToggle.Position = UDim2.fromOffset(12, 90)

    local noclipToggle = Toggle(moveSec, "Noclip", State.NoclipEnabled, function(v) State.NoclipEnabled = v end)
    noclipToggle.Position = UDim2.fromOffset(160, 90)

    local shaderSec = Section(page, "Shaders & Visuals", "Графика.", 135)

    local shaderToggle = Toggle(shaderSec, "RTX Shaders", State.ShadersEnabled, function(v) ToggleShaders(v) end)
    shaderToggle.Position = UDim2.fromOffset(12, 45)

    local potatoToggle = Toggle(shaderSec, "Potato FPS", State.PotatoGraphics, function(v) SetPotatoGraphics(v) end)
    potatoToggle.Position = UDim2.fromOffset(160, 45)

    local pcGraphicsToggle = Toggle(shaderSec, "PC Graphics", State.PCGraphics, function(v) SetPCGraphics(v) end)
    pcGraphicsToggle.Position = UDim2.fromOffset(12, 90)
end

-- 8. SETTINGS TAB
do
    local page = Pages.SETTINGS
    local themeSec = Section(page, "Выбор темы GUI", "Смена цветовой гаммы.", 210)

    local themeList = {
        { Name = "Midnight", Data = Themes.Midnight },
        { Name = "Graphite", Data = Themes.Graphite },
        { Name = "Purple", Data = Themes.Purple },
        { Name = "Crimson", Data = Themes.Crimson },
        { Name = "Emerald", Data = Themes.Emerald },
        { Name = "Ocean", Data = Themes.Ocean },
    }

    local xPos, yPos = 12, 45
    for i, tData in ipairs(themeList) do
        ActionButton(themeSec, tData.Name, UDim2.fromOffset(xPos, yPos), UDim2.fromOffset(145, 32), function()
            UpdateTheme(tData.Data)
        end)

        if i % 2 == 0 then xPos = 12 yPos = yPos + 38 else xPos = 165 end
    end
end

--==================================================
-- FULL 2D ESP ENGINE
--==================================================

local ESPCache = {}

local SKELETON_R15 = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"}
}

local SKELETON_R6 = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

local function ClearESP(player)
    if ESPCache[player] then
        if ESPCache[player].BoxFrame then ESPCache[player].BoxFrame:Destroy() end
        if ESPCache[player].Highlight then ESPCache[player].Highlight:Destroy() end
        if ESPCache[player].SkeletonFolder then ESPCache[player].SkeletonFolder:Destroy() end
        ESPCache[player] = nil
    end
end

local function CreateESPComponents(player)
    local boxFrame = Instance.new("Frame")
    boxFrame.Name = "2DBox_" .. player.Name
    boxFrame.BackgroundTransparency = 1
    boxFrame.BorderSizePixel = 0
    boxFrame.Parent = ESPFolder

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Parent = boxFrame

    local healthBg = Instance.new("Frame")
    healthBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    healthBg.BorderSizePixel = 0
    healthBg.Position = UDim2.new(0, -6, 0, 0)
    healthBg.Size = UDim2.new(0, 3, 1, 0)
    healthBg.Parent = boxFrame

    local healthFill = Instance.new("Frame")
    healthFill.BackgroundColor3 = Color3.fromRGB(50, 220, 110)
    healthFill.BorderSizePixel = 0
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.Parent = healthBg

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 200, 0, 20)
    nameLabel.Position = UDim2.new(0, -100, 1, 2)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 10
    nameLabel.TextColor3 = CurrentTheme.Text
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Parent = boxFrame

    local skelFolder = Instance.new("Folder")
    skelFolder.Name = "Skel_" .. player.Name
    skelFolder.Parent = ESPFolder

    ESPCache[player] = {
        BoxFrame = boxFrame,
        BoxStroke = boxStroke,
        HealthBg = healthBg,
        HealthFill = healthFill,
        NameLabel = nameLabel,
        SkeletonFolder = skelFolder,
        Lines = {},
        Highlight = nil
    }
end

local function DrawLine(parent, p1, p2, color)
    local line = parent:FindFirstChildOfClass("Frame") or Instance.new("Frame")
    line.BorderSizePixel = 0
    line.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Parent = parent

    local distance = (p1 - p2).Magnitude
    local angle = math.atan2(p2.Y - p1.Y, p2.X - p1.X)

    line.Size = UDim2.fromOffset(distance, 1.5)
    line.Position = UDim2.fromOffset((p1.X + p2.X) / 2, (p1.Y + p2.Y) / 2)
    line.Rotation = math.deg(angle)
    line.Visible = true
    return line
end

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")

            local role = GetPlayerRole(player)
            local roleSettings = State.ESP[role]

            local isRoleESPActive = roleSettings and roleSettings.Enabled and (roleSettings.Box or roleSettings.Name or roleSettings.Distance or roleSettings.Highlight or State.ESP.Skeletons)

            if char and root and head and humanoid and humanoid.Health > 0 and isRoleESPActive then
                if not ESPCache[player] then
                    CreateESPComponents(player)
                end

                local cache = ESPCache[player]
                local rootPos, rootVisible = Camera:WorldToViewportPoint(root.Position)

                if rootVisible then
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.8, 0))
                    local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height * 0.55

                    -- 1. 2D Box
                    if roleSettings.Box then
                        cache.BoxFrame.Visible = true
                        cache.BoxFrame.Size = UDim2.fromOffset(width, height)
                        cache.BoxFrame.Position = UDim2.fromOffset(rootPos.X - (width / 2), headPos.Y)
                        cache.BoxStroke.Color = roleSettings.Color
                    else
                        cache.BoxFrame.Visible = false
                    end

                    -- 2. Healthbar
                    if State.ESP.HealthBar and roleSettings.Box then
                        cache.HealthBg.Visible = true
                        local hpPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        cache.HealthFill.Size = UDim2.new(1, 0, hpPercent, 0)
                        cache.HealthFill.Position = UDim2.new(0, 0, 1 - hpPercent, 0)
                        cache.HealthFill.BackgroundColor3 = Color3.fromRGB(230, 50, 50):Lerp(Color3.fromRGB(50, 220, 110), hpPercent)
                    else
                        cache.HealthBg.Visible = false
                    end

                    -- 3. Name & Distance
                    if roleSettings.Name or roleSettings.Distance then
                        cache.NameLabel.Visible = true
                        local infoText = ""
                        if roleSettings.Name then infoText = player.DisplayName end
                        if roleSettings.Distance then
                            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local dist = myRoot and math.floor((myRoot.Position - root.Position).Magnitude) or 0
                            infoText = infoText .. string.format(" [%dm]", dist)
                        end
                        cache.NameLabel.Text = infoText
                        cache.NameLabel.TextColor3 = roleSettings.Color
                    else
                        cache.NameLabel.Visible = false
                    end

                    -- 4. Skeleton ESP
                    if State.ESP.Skeletons then
                        local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
                        local skelMap = isR15 and SKELETON_R15 or SKELETON_R6

                        for idx, pair in ipairs(skelMap) do
                            local partA = char:FindFirstChild(pair[1])
                            local partB = char:FindFirstChild(pair[2])

                            if partA and partB then
                                local posA, visA = Camera:WorldToViewportPoint(partA.Position)
                                local posB, visB = Camera:WorldToViewportPoint(partB.Position)

                                if visA and visB then
                                    local lineObj = cache.Lines[idx]
                                    if not lineObj or lineObj.Parent ~= cache.SkeletonFolder then
                                        lineObj = Instance.new("Frame")
                                        lineObj.Parent = cache.SkeletonFolder
                                        cache.Lines[idx] = lineObj
                                    end
                                    DrawLine(lineObj, Vector2.new(posA.X, posA.Y), Vector2.new(posB.X, posB.Y), roleSettings.Color)
                                elseif cache.Lines[idx] then
                                    cache.Lines[idx].Visible = false
                                end
                            elseif cache.Lines[idx] then
                                cache.Lines[idx].Visible = false
                            end
                        end
                    else
                        for _, lineObj in pairs(cache.Lines) do lineObj.Visible = false end
                    end
                else
                    if cache then
                        cache.BoxFrame.Visible = false
                        for _, lineObj in pairs(cache.Lines) do lineObj.Visible = false end
                    end
                end

                -- 5. Highlight (Chams)
                if roleSettings.Highlight then
                    if not cache.Highlight or cache.Highlight.Parent ~= char then
                        if cache.Highlight then cache.Highlight:Destroy() end
                        local hl = Instance.new("Highlight")
                        hl.Adornee = char
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.FillTransparency = 0.45
                        hl.OutlineTransparency = 0
                        hl.Parent = char
                        cache.Highlight = hl
                    end
                    cache.Highlight.FillColor = roleSettings.Color
                    cache.Highlight.OutlineColor = roleSettings.Color
                    cache.Highlight.Enabled = true
                elseif cache.Highlight then
                    cache.Highlight.Enabled = false
                end
            else
                ClearESP(player)
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    pcall(UpdateESP)
end)

Players.PlayerRemoving:Connect(ClearESP)

--==================================================
-- FLOATING TOGGLE BUTTON (HBS)
--==================================================

local HBS = Instance.new("TextButton")
HBS.Name = "HBS"
HBS.AnchorPoint = Vector2.new(0.5, 0.5)
HBS.Position = UDim2.new(0.5, 200, 0.5, -100)
HBS.Size = UDim2.fromOffset(45, 45)
HBS.BackgroundColor3 = CurrentTheme.Accent
HBS.Text = "×"
HBS.TextSize = 18
HBS.Font = Enum.Font.GothamBold
HBS.TextColor3 = Color3.fromRGB(255, 255, 255)
HBS.ZIndex = 500
HBS.Parent = ScreenGui

Corner(HBS, 999)
Stroke(HBS, Color3.fromRGB(255, 255, 255), 1.5, 0.2)
RegisterThemeObj(HBS, "Accents")

HBS.Activated:Connect(function()
    State.Open = not State.Open
    Main.Visible = State.Open
    HBS.Text = State.Open and "×" or "≡"
end)

Close.Activated:Connect(function()
    State.Open = false
    Main.Visible = false
    HBS.Text = "≡"
end)

Minimize.Activated:Connect(function()
    State.Open = false
    Main.Visible = false
    HBS.Text = "≡"
end)

SelectTab("MAIN")
Notify("HudrinHub", "Запущено! Все функции отключены по умолчанию.", 4)
