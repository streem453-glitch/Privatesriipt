-- ДОЖИДАЕМСЯ ПОЛНОЙ ЗАГРУЗКИ ИГРЫ
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- CONFIG & THEMES SYSTEM
--==================================================

local CONFIG = {
    GUI_NAME = "HardinHub_v3_Fixed",
    DEFAULT_FOV = 160,
    ANIMATION_SPEED = 0.2,
    WINDOW_WIDTH = 560,
    WINDOW_HEIGHT = 360,
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
    Cyberpunk = {
        Background = Color3.fromRGB(18, 12, 28),
        Background2 = Color3.fromRGB(32, 18, 48),
        Panel = Color3.fromRGB(36, 22, 54),
        PanelDark = Color3.fromRGB(22, 14, 34),
        Accent = Color3.fromRGB(255, 0, 128),
        Accent2 = Color3.fromRGB(0, 240, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 180, 220),
        Stroke = Color3.fromRGB(90, 30, 110),
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
    }
}

local CurrentTheme = Themes.Midnight

local State = {
    Open = true,
    SelectedTab = "AUTO-FARM",
    CornerRadius = 10,
    TransparencyValue = 0.08,

    -- Auto-Farm State
    AutoFarmCoins = false,
    FarmDelay = 0.3,

    -- Combat State
    AimbotEnabled = false,
    AimTargetMurderOnly = true,
    AimVisibleCheck = true,
    AimFOV = CONFIG.DEFAULT_FOV,
    AimSmoothness = 0.25,
    AimPart = "Head",

    -- ESP State
    ESP = {
        Master = true,
        HealthBar = true,
        ShowHardinText = true,
        GunESP = true,

        Murder = { Enabled = true, Box = true, Name = true, Distance = true, Color = Color3.fromRGB(255, 50, 50) },
        Sheriff = { Enabled = true, Box = true, Name = true, Distance = true, Color = Color3.fromRGB(50, 150, 255) },
        Innocent = { Enabled = true, Box = true, Name = true, Distance = true, Color = Color3.fromRGB(100, 230, 150) },
    },

    -- Player Mods
    WalkSpeed = 16,
    SpeedHackEnabled = false,
    InfJumpEnabled = false,
    NoclipEnabled = false,
    Fullbright = false,
    PotatoGraphics = false,
    Notifications = true,
}

-- БЕЗОПАСНАЯ ИНЪЕКЦИЯ
local function GetSafeParent()
    if gethui then return gethui() end
    local success, core = pcall(function() return game:GetService("CoreGui") end)
    if success and core then return core end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = GetSafeParent()
if GuiParent:FindFirstChild(CONFIG.GUI_NAME) then
    GuiParent[CONFIG.GUI_NAME]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = CONFIG.GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = GuiParent

--==================================================
-- UI UTILITIES & BUILDERS
--==================================================

local UIObjects = { Panels = {}, PanelsDark = {}, Accents = {}, Strokes = {}, Texts = {}, Corners = {}, MainFrames = {} }

local function RegisterThemeObj(obj, category)
    if UIObjects[category] then table.insert(UIObjects[category], obj) end
end

local function UpdateTheme(theme)
    CurrentTheme = theme
    for _, obj in ipairs(UIObjects.Panels) do if obj and obj.Parent then obj.BackgroundColor3 = theme.Panel end end
    for _, obj in ipairs(UIObjects.PanelsDark) do if obj and obj.Parent then obj.BackgroundColor3 = theme.PanelDark end end
    for _, obj in ipairs(UIObjects.Accents) do if obj and obj.Parent then obj.BackgroundColor3 = theme.Accent end end
    for _, obj in ipairs(UIObjects.Strokes) do if obj and obj.Parent then obj.Color = theme.Stroke end end
    for _, obj in ipairs(UIObjects.Texts) do if obj and obj.Parent then obj.TextColor3 = theme.Text end end
    for _, obj in ipairs(UIObjects.MainFrames) do if obj and obj.Parent then obj.BackgroundColor3 = theme.Background end end
end

local function UpdateCorners(radius)
    State.CornerRadius = radius
    for _, c in ipairs(UIObjects.Corners) do if c and c.Parent then c.CornerRadius = UDim.new(0, radius) end end
end

local function UpdateTransparency(val)
    State.TransparencyValue = val
    for _, obj in ipairs(UIObjects.MainFrames) do if obj and obj.Parent then obj.BackgroundTransparency = val end end
end

local function Tween(object, properties, duration)
    return TweenService:Create(object, TweenInfo.new(duration or CONFIG.ANIMATION_SPEED, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties)
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or State.CornerRadius)
    c.Parent = parent
    RegisterThemeObj(c, "Corners")
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
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = CurrentTheme.TextDark
    button.BackgroundColor3 = CurrentTheme.Panel
    button.BackgroundTransparency = 0.05
    button.Size = size
    button.Position = position or UDim2.new()
    button.BorderSizePixel = 0
    button.Parent = parent

    Corner(button, State.CornerRadius)
    Stroke(button, CurrentTheme.Stroke, 1, 0.35)
    RegisterThemeObj(button, "Panels")

    button.MouseEnter:Connect(function() Tween(button, { BackgroundTransparency = 0 }, 0.12):Play() end)
    button.MouseLeave:Connect(function() Tween(button, { BackgroundTransparency = 0.1 }, 0.12):Play() end)
    return button
end

--==================================================
-- NOTIFICATIONS ENGINE
--==================================================

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Container"
ESPFolder.Parent = ScreenGui

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "Notifications"
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.AnchorPoint = Vector2.new(1, 0)
NotificationHolder.Position = UDim2.new(1, -12, 0, 12)
NotificationHolder.Size = UDim2.new(0, 280, 1, -24)
NotificationHolder.ZIndex = 200
NotificationHolder.Parent = ScreenGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotificationLayout.Padding = UDim.new(0, 6)
NotificationLayout.Parent = NotificationHolder

function Notify(title, message, duration)
    if not State.Notifications then return end
    duration = duration or 3

    local notification = Instance.new("Frame")
    notification.BackgroundColor3 = CurrentTheme.Panel
    notification.BackgroundTransparency = 0.05
    notification.Size = UDim2.fromOffset(260, 54)
    notification.BorderSizePixel = 0
    notification.ZIndex = 201
    notification.Parent = NotificationHolder

    Corner(notification, 8)
    Stroke(notification, CurrentTheme.Stroke, 1.5, 0.1)

    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = CurrentTheme.Accent
    bar.BorderSizePixel = 0
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.ZIndex = 202
    bar.Parent = notification
    Corner(bar, 4)

    local titleLabel = CreateText(notification, title, 12, UDim2.new(0, 12, 0, 4), Enum.Font.GothamBold)
    titleLabel.TextColor3 = CurrentTheme.Accent

    local messageLabel = CreateText(notification, message, 10, UDim2.new(0, 12, 0, 22))
    messageLabel.Size = UDim2.new(1, -20, 0, 24)

    notification.Position = UDim2.new(1, 300, 0, 0)
    Tween(notification, { Position = UDim2.new(1, 0, 0, 0) }, 0.2):Play()

    task.delay(duration, function()
        if notification and notification.Parent then
            local t = Tween(notification, { Position = UDim2.new(1, 300, 0, 0), BackgroundTransparency = 1 }, 0.2)
            t:Play()
            t.Completed:Wait()
            if notification.Parent then notification:Destroy() end
        end
    end)
end

--==================================================
-- MAIN WINDOW FRAME & DRAG ENGINE
--==================================================

local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromOffset(CONFIG.WINDOW_WIDTH, CONFIG.WINDOW_HEIGHT)
Main.BackgroundColor3 = CurrentTheme.Background
Main.BackgroundTransparency = State.TransparencyValue
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = true
Main.ZIndex = 5
Main.Parent = ScreenGui

Corner(Main, 12)
Stroke(Main, CurrentTheme.Stroke, 2, 0.1)
RegisterThemeObj(Main, "MainFrames")

local Header = Instance.new("Frame")
Header.BackgroundTransparency = 1
Header.Position = UDim2.fromOffset(16, 6)
Header.Size = UDim2.new(1, -32, 0, 40)
Header.ZIndex = 20
Header.Parent = Main

local Title = CreateText(Header, "hardinhub", 20, UDim2.fromOffset(0, 2), Enum.Font.GothamBold)
Title.TextColor3 = CurrentTheme.Accent
Title.Size = UDim2.fromOffset(180, 26)
RegisterThemeObj(Title, "Accents")

local Subtitle = CreateText(Header, "MM2 Fixed Ultimate GUI", 10, UDim2.fromOffset(2, 24))

local Minimize = MakeButton(Header, "—", UDim2.fromOffset(34, 28), UDim2.new(1, -80, 0, 4))
local Close = MakeButton(Header, "×", UDim2.fromOffset(34, 28), UDim2.new(1, -40, 0, 4))

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
-- SIDEBAR & PAGES CONTAINER
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.fromOffset(12, 52)
Content.Size = UDim2.new(1, -24, 1, -62)
Content.ZIndex = 15
Content.Parent = Main

local SidebarScroll = Instance.new("ScrollingFrame")
SidebarScroll.Name = "SidebarScroll"
SidebarScroll.BackgroundColor3 = CurrentTheme.PanelDark
SidebarScroll.BackgroundTransparency = 0.2
SidebarScroll.Size = UDim2.new(0, 135, 1, 0)
SidebarScroll.BorderSizePixel = 0
SidebarScroll.CanvasSize = UDim2.new()
SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SidebarScroll.ScrollBarThickness = 3
SidebarScroll.ZIndex = 16
SidebarScroll.Parent = Content

Corner(SidebarScroll, State.CornerRadius)
Stroke(SidebarScroll, CurrentTheme.Stroke, 1, 0.3)
RegisterThemeObj(SidebarScroll, "PanelsDark")

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 6)
sidebarPadding.PaddingBottom = UDim.new(0, 6)
sidebarPadding.PaddingLeft = UDim.new(0, 6)
sidebarPadding.PaddingRight = UDim.new(0, 6)
sidebarPadding.Parent = SidebarScroll

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 5)
sidebarLayout.Parent = SidebarScroll

local PageContainer = Instance.new("Frame")
PageContainer.Name = "Pages"
PageContainer.BackgroundTransparency = 1
PageContainer.Position = UDim2.fromOffset(145, 0)
PageContainer.Size = UDim2.new(1, -145, 1, 0)
PageContainer.ZIndex = 16
PageContainer.Parent = Content

local Tabs = {"AUTO-FARM", "MAIN", "AIM", "ESP", "TELEPORT", "ANIMATION", "PLAYERS", "MISC", "SETTINGS"}
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
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = CurrentTheme.Accent
    page.Visible = false
    page.ZIndex = 17
    page.Parent = PageContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page

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
    local button = MakeButton(SidebarScroll, tabName, UDim2.new(1, 0, 0, 28))
    button.TextColor3 = CurrentTheme.Text
    button.ZIndex = 18
    TabButtons[tabName] = button
    CreatePage(tabName)

    button.Activated:Connect(function()
        SelectTab(tabName)
    end)
end

--==================================================
-- UI HELPER FUNCTIONS
--==================================================

local function Section(parent, title, description, height)
    local section = Instance.new("Frame")
    section.BackgroundColor3 = CurrentTheme.Panel
    section.BackgroundTransparency = 0.05
    section.Size = UDim2.new(1, -6, 0, height or 90)
    section.BorderSizePixel = 0
    section.ZIndex = 18
    section.Parent = parent

    Corner(section, State.CornerRadius)
    Stroke(section, CurrentTheme.Stroke, 1, 0.3)
    RegisterThemeObj(section, "Panels")

    local titleLabel = CreateText(section, title, 13, UDim2.fromOffset(10, 5), Enum.Font.GothamBold)
    titleLabel.ZIndex = 19

    if description then
        local desc = CreateText(section, description, 10, UDim2.fromOffset(10, 22))
        desc.Size = UDim2.new(1, -20, 0, 20)
        desc.TextTransparency = 0.35
        desc.ZIndex = 19
    end

    return section
end

local function Toggle(parent, text, default, callback)
    local enabled = default
    local button = MakeButton(parent, "", UDim2.fromOffset(130, 30))

    local function update()
        button.Text = text .. "   " .. (enabled and "[ON]" or "[OFF]")
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
    local btn = MakeButton(parent, text, size or UDim2.fromOffset(130, 30), position)
    btn.TextColor3 = CurrentTheme.Text
    btn.Activated:Connect(function()
        if callback then callback() end
    end)
    return btn
end

--==================================================
-- REWRITTEN AUTO-FARM ENGINE (MM2 COINS)
--==================================================

local function GetCoinsList()
    local coins = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj.Name == "Coin" or obj.Name == "CoinContainer" or obj.Name == "GoldCoin") and obj:IsA("BasePart") and obj.Transparency < 1 then
            table.insert(coins, obj)
        elseif obj.Name == "CoinContainer" or obj.Name == "CoinArea" then
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("BasePart") and child.Transparency < 1 then
                    table.insert(coins, child)
                end
            end
        end
    end
    return coins
end

task.spawn(function()
    while true do
        task.wait(State.FarmDelay)
        if State.AutoFarmCoins then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if root then
                local coins = GetCoinsList()
                if #coins > 0 then
                    local closest = nil
                    local minDist = math.huge

                    for _, coin in ipairs(coins) do
                        if coin and coin.Parent and coin.Transparency < 1 then
                            local dist = (root.Position - coin.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                closest = coin
                            end
                        end
                    end

                    if closest and closest.Parent then
                        -- Включаем ноклип для защиты от застопоривания
                        for _, p in ipairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end

                        root.CFrame = closest.CFrame

                        -- Вызов TouchInterest если поддерживается экзекутором
                        if firetouchinterest then
                            firetouchinterest(root, closest, 0)
                            task.wait(0.05)
                            firetouchinterest(root, closest, 1)
                        end
                    end
                end
            end
        end
    end
end)

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

local function IsPartVisible(part, targetChar)
    if not State.AimVisibleCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = part.Position - origin

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local ignoreList = {Camera}
    if LocalPlayer.Character then table.insert(ignoreList, LocalPlayer.Character) end
    raycastParams.FilterDescendantsInstances = ignoreList

    local result = workspace:Raycast(origin, direction, raycastParams)
    return not result or (result.Instance and result.Instance:IsDescendantOf(targetChar))
end

local function GetAimbotTarget()
    local closest = nil
    local maxDist = State.AimFOV

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local role = GetPlayerRole(p)
            local isValid = State.AimTargetMurderOnly and (role == "Murder") or not State.AimTargetMurderOnly

            if isValid then
                local part = p.Character:FindFirstChild(State.AimPart) or p.Character:FindFirstChild("Head")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")

                if part and hum and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist <= maxDist and IsPartVisible(part, p.Character) then
                            maxDist = dist
                            closest = part
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if State.AimbotEnabled then
        local targetPart = GetAimbotTarget()
        if targetPart then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, State.AimSmoothness)
        end
    end

    if State.NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if State.SpeedHackEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = State.WalkSpeed end
    end
end)

--==================================================
-- ESP ENGINE
--==================================================

local ESPCache = {}

local function ClearESP(player)
    if ESPCache[player] then
        if ESPCache[player].BoxFrame then ESPCache[player].BoxFrame:Destroy() end
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

    local hardinLabel = Instance.new("TextLabel")
    hardinLabel.Name = "HardinTag"
    hardinLabel.BackgroundTransparency = 1
    hardinLabel.Size = UDim2.new(1, 100, 0, 16)
    hardinLabel.Position = UDim2.new(0, -50, 0, -18)
    hardinLabel.Font = Enum.Font.GothamBold
    hardinLabel.TextSize = 11
    hardinLabel.Text = "hardinhub"
    hardinLabel.TextColor3 = CurrentTheme.Accent
    hardinLabel.TextStrokeTransparency = 0.2
    hardinLabel.TextXAlignment = Enum.TextXAlignment.Center
    hardinLabel.Parent = boxFrame

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
    nameLabel.Size = UDim2.new(1, 200, 0, 18)
    nameLabel.Position = UDim2.new(0, -100, 1, 2)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 10
    nameLabel.TextColor3 = CurrentTheme.Text
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Parent = boxFrame

    ESPCache[player] = {
        BoxFrame = boxFrame,
        BoxStroke = boxStroke,
        HardinLabel = hardinLabel,
        HealthBg = healthBg,
        HealthFill = healthFill,
        NameLabel = nameLabel
    }
end

local function UpdateESP()
    if not State.ESP.Master then
        for p, _ in pairs(ESPCache) do ClearESP(p) end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")

            local role = GetPlayerRole(player)
            local roleSettings = State.ESP[role]

            if char and root and head and humanoid and humanoid.Health > 0 and roleSettings and roleSettings.Enabled then
                if not ESPCache[player] then CreateESPComponents(player) end

                local cache = ESPCache[player]
                local rootPos, rootVisible = Camera:WorldToViewportPoint(root.Position)

                if rootVisible then
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.8, 0))
                    local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height * 0.55

                    if roleSettings.Box then
                        cache.BoxFrame.Visible = true
                        cache.BoxFrame.Size = UDim2.fromOffset(width, height)
                        cache.BoxFrame.Position = UDim2.fromOffset(rootPos.X - (width / 2), headPos.Y)
                        cache.BoxStroke.Color = roleSettings.Color
                        cache.HardinLabel.Visible = State.ESP.ShowHardinText
                        cache.HardinLabel.TextColor3 = CurrentTheme.Accent
                    else
                        cache.BoxFrame.Visible = false
                    end

                    if State.ESP.HealthBar and roleSettings.Box then
                        cache.HealthBg.Visible = true
                        local hpPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        cache.HealthFill.Size = UDim2.new(1, 0, hpPercent, 0)
                        cache.HealthFill.Position = UDim2.new(0, 0, 1 - hpPercent, 0)
                    else
                        cache.HealthBg.Visible = false
                    end

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
                else
                    if cache then cache.BoxFrame.Visible = false end
                end
            else
                ClearESP(player)
            end
        end
    end
end

RunService.RenderStepped:Connect(function() pcall(UpdateESP) end)
Players.PlayerRemoving:Connect(ClearESP)

--==================================================
-- FILL ALL TABS COMPLETELY
--==================================================

-- 1. AUTO-FARM TAB
do
    local page = Pages["AUTO-FARM"]
    local farmSec = Section(page, "Авто-Ферма Монет", "Мгновенная сборка монет по всей карте.", 120)

    local farmToggle = Toggle(farmSec, "Auto-Farm Coins", State.AutoFarmCoins, function(v)
        State.AutoFarmCoins = v
        Notify("Auto-Farm", v and "Фарм включен" or "Фарм выключен", 2)
    end)
    farmToggle.Position = UDim2.fromOffset(10, 42)

    ActionButton(farmSec, "Собрать 1 монету", UDim2.fromOffset(150, 42), UDim2.fromOffset(130, 30), function()
        local coins = GetCoinsList()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and #coins > 0 then
            root.CFrame = coins[1].CFrame
            if firetouchinterest then firetouchinterest(root, coins[1], 0) end
            Notify("Auto-Farm", "Телепортирован к монете!", 2)
        end
    end)
end

-- 2. MAIN TAB
do
    local page = Pages.MAIN
    local mainSec = Section(page, "Информация о сервере", "Статус ролей игроков на карте.", 140)

    local roleInfo = CreateText(mainSec, "Мардер: Сканирование...", 11, UDim2.fromOffset(10, 40))
    local sheriffInfo = CreateText(mainSec, "Шериф: Сканирование...", 11, UDim2.fromOffset(10, 60))

    task.spawn(function()
        while task.wait(1) do
            if page.Visible then
                local m, s = "Не найден", "Не найден"
                for _, p in ipairs(Players:GetPlayers()) do
                    local r = GetPlayerRole(p)
                    if r == "Murder" then m = p.DisplayName end
                    if r == "Sheriff" then s = p.DisplayName end
                end
                roleInfo.Text = "Мардер: " .. m
                sheriffInfo.Text = "Шериф: " .. s
            end
        end
    end)

    ActionButton(mainSec, " Подобрать пистолет", UDim2.fromOffset(10, 90), UDim2.fromOffset(160, 30), function()
        local gun = workspace:FindFirstChild("GunDrop", true)
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if gun and root then
            root.CFrame = gun.CFrame
            Notify("Main", "Пистолет подобран!", 2)
        else
            Notify("Main", "Выпавший пистолет не найден", 2)
        end
    end)
end

-- 3. AIM TAB
do
    local page = Pages.AIM
    local aimSec = Section(page, "Настройки Аимбота", "Авто-наведение на врагов.", 140)

    local aimToggle = Toggle(aimSec, "Aimbot", State.AimbotEnabled, function(v) State.AimbotEnabled = v end)
    aimToggle.Position = UDim2.fromOffset(10, 42)

    local murdToggle = Toggle(aimSec, "Только Мардер", State.AimTargetMurderOnly, function(v) State.AimTargetMurderOnly = v end)
    murdToggle.Position = UDim2.fromOffset(150, 42)

    local visToggle = Toggle(aimSec, "Проверка стен", State.AimVisibleCheck, function(v) State.AimVisibleCheck = v end)
    visToggle.Position = UDim2.fromOffset(10, 80)

    ActionButton(aimSec, "Цель: Head / Torso", UDim2.fromOffset(150, 80), UDim2.fromOffset(130, 30), function()
        State.AimPart = (State.AimPart == "Head") and "HumanoidRootPart" or "Head"
        Notify("Aim", "Цель изменена на: " .. State.AimPart, 2)
    end)
end

-- 4. ESP TAB
do
    local page = Pages.ESP
    local espSec = Section(page, "Кастомизация ESP", "Настройка визуалов.", 180)

    Toggle(espSec, "Включить ESP", State.ESP.Master, function(v) State.ESP.Master = v end).Position = UDim2.fromOffset(10, 42)
    Toggle(espSec, "Текст hardinhub", State.ESP.ShowHardinText, function(v) State.ESP.ShowHardinText = v end).Position = UDim2.fromOffset(150, 42)

    Toggle(espSec, "ESP Мардера", State.ESP.Murder.Enabled, function(v) State.ESP.Murder.Enabled = v end).Position = UDim2.fromOffset(10, 80)
    Toggle(espSec, "ESP Шерифа", State.ESP.Sheriff.Enabled, function(v) State.ESP.Sheriff.Enabled = v end).Position = UDim2.fromOffset(150, 80)

    Toggle(espSec, "ESP Мирных", State.ESP.Innocent.Enabled, function(v) State.ESP.Innocent.Enabled = v end).Position = UDim2.fromOffset(10, 118)
    Toggle(espSec, "Полоска ХП", State.ESP.HealthBar, function(v) State.ESP.HealthBar = v end).Position = UDim2.fromOffset(150, 118)
end

-- 5. TELEPORT TAB
do
    local page = Pages.TELEPORT
    local tpSec = Section(page, "Мгновенный телепорт", "Быстрое перемещение.", 140)

    ActionButton(tpSec, "В Лобби", UDim2.fromOffset(10, 42), UDim2.fromOffset(130, 30), function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local lobby = workspace:FindFirstChild("Lobby", true) or workspace:FindFirstChild("LobbySpawn", true)
        if root and lobby then
            root.CFrame = (lobby:IsA("Model") and lobby:GetPivot() or lobby.CFrame) + Vector3.new(0, 4, 0)
        end
    end)

    ActionButton(tpSec, "К Мардеру", UDim2.fromOffset(150, 42), UDim2.fromOffset(130, 30), function()
        for _, p in ipairs(Players:GetPlayers()) do
            if GetPlayerRole(p) == "Murder" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
            end
        end
    end)

    ActionButton(tpSec, "К Шерифу", UDim2.fromOffset(10, 80), UDim2.fromOffset(130, 30), function()
        for _, p in ipairs(Players:GetPlayers()) do
            if GetPlayerRole(p) == "Sheriff" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
            end
        end
    end)
end

-- 6. ANIMATION TAB
do
    local page = Pages.ANIMATION
    local animSec = Section(page, "Анимации", "Эмоции персонажа.", 120)

    ActionButton(animSec, "Dance 1", UDim2.fromOffset(10, 42), UDim2.fromOffset(130, 30), function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://507771019"
            hum:LoadAnimation(anim):Play()
        end
    end)

    ActionButton(animSec, "Sit Chill", UDim2.fromOffset(150, 42), UDim2.fromOffset(130, 30), function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://250622329"
            hum:LoadAnimation(anim):Play()
        end
    end)
end

-- 7. PLAYERS TAB (ПОЛНОСТЬЮ ВОССТАНОВЛЕНО)
do
    local page = Pages.PLAYERS
    local plSec = Section(page, "Список игроков", "Выберите игрока для действий.", 240)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 0, 170)
    scroll.Position = UDim2.fromOffset(10, 42)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.CanvasSize = UDim2.new()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = plSec

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scroll

    local function RefreshPlayers()
        for _, c in ipairs(scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -6, 0, 28)
                frame.BackgroundColor3 = CurrentTheme.PanelDark
                frame.Parent = scroll
                Corner(frame, 6)

                CreateText(frame, p.DisplayName .. " (@" .. p.Name .. ")", 10, UDim2.fromOffset(8, 2))

                ActionButton(frame, "TP", UDim2.new(1, -75, 0, 2), UDim2.fromOffset(32, 24), function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                    end
                end)

                ActionButton(frame, "Spec", UDim2.new(1, -38, 0, 2), UDim2.fromOffset(34, 24), function()
                    if p.Character and p.Character:FindFirstChild("Head") then
                        Camera.CameraSubject = p.Character.Head
                    end
                end)
            end
        end
    end

    RefreshPlayers()
    Players.PlayerAdded:Connect(RefreshPlayers)
    Players.PlayerRemoving:Connect(RefreshPlayers)
end

-- 8. MISC TAB
do
    local page = Pages.MISC
    local miscSec = Section(page, "Дополнительно (Misc)", "Утилиты для игрока.", 140)

    Toggle(miscSec, "Speedhack", State.SpeedHackEnabled, function(v) State.SpeedHackEnabled = v end).Position = UDim2.fromOffset(10, 42)
    Toggle(miscSec, "Noclip", State.NoclipEnabled, function(v) State.NoclipEnabled = v end).Position = UDim2.fromOffset(150, 42)

    ActionButton(miscSec, "Potato Graphics", UDim2.fromOffset(10, 80), UDim2.fromOffset(130, 30), function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        end
        Notify("Misc", "Графика упрощена!", 2)
    end)

    ActionButton(miscSec, "Fullbright", UDim2.fromOffset(150, 80), UDim2.fromOffset(130, 30), function()
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Notify("Misc", "Яркость включена!", 2)
    end)
end

-- 9. SETTINGS TAB
do
    local page = Pages.SETTINGS
    local themeSec = Section(page, "Темы UI", "Выбор цветовой темы.", 170)

    local themeList = {
        { Name = "Midnight", Data = Themes.Midnight },
        { Name = "Cyberpunk", Data = Themes.Cyberpunk },
        { Name = "Crimson", Data = Themes.Crimson },
        { Name = "Emerald", Data = Themes.Emerald },
        { Name = "Ocean", Data = Themes.Ocean },
        { Name = "Graphite", Data = Themes.Graphite },
    }

    local xPos, yPos = 10, 42
    for i, tData in ipairs(themeList) do
        ActionButton(themeSec, tData.Name, UDim2.fromOffset(xPos, yPos), UDim2.fromOffset(130, 30), function()
            UpdateTheme(tData.Data)
        end)
        if i % 2 == 0 then xPos = 10 yPos = yPos + 36 else xPos = 150 end
    end
end

--==================================================
-- FLOATING TOGGLE BUTTON (HBS)
--==================================================

local HBS = Instance.new("TextButton")
HBS.Name = "HBS"
HBS.AnchorPoint = Vector2.new(0.5, 0.5)
HBS.Position = UDim2.new(0.5, 200, 0.5, -100)
HBS.Size = UDim2.fromOffset(42, 42)
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

SelectTab("AUTO-FARM")
Notify("hardinhub", "Полный скрипт готов!", 3)