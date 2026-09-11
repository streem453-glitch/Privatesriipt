--[[
    HudrinHub
    Made by @f1uxfg
    Official: https://t.me/hudrinhub_scripts

    Roblox Studio / Own Game
    Mobile-first TEST / ADMIN HUB

    IMPORTANT:
    - No executor/exploit APIs.
    - Aim Assist and ESP only work with NPCs tagged "HudrinTestTarget".
    - Test item uses tag "HudrinTestItem".
    - Teleports are intended for your own test game.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    GUI_NAME = "HudrinHub",

    -- Put your uploaded Roblox image asset here:
    -- "rbxassetid://1234567890"
    BACKGROUND_IMAGE = "",

    TRAINING_NPC_TAG = "HudrinTestTarget",
    TEST_ITEM_TAG = "HudrinTestItem",

    ALLOW_REJOIN = false,
    ALLOW_RESET = true,

    DEFAULT_FOV = 160,
    DEFAULT_SMOOTHNESS = 0.18,

    NOTIFICATIONS = true,
    ANIMATION_SPEED = 0.25,

    -- Mobile window size is calculated dynamically.
    WINDOW_WIDTH = 560,
    WINDOW_HEIGHT = 350,
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

    Rose = {
        Background = Color3.fromRGB(27, 17, 23),
        Background2 = Color3.fromRGB(43, 23, 34),
        Panel = Color3.fromRGB(40, 25, 34),
        PanelDark = Color3.fromRGB(25, 17, 22),
        Accent = Color3.fromRGB(255, 100, 165),
        Accent2 = Color3.fromRGB(190, 105, 255),
        Text = Color3.fromRGB(255, 245, 250),
        TextDark = Color3.fromRGB(211, 184, 198),
        Stroke = Color3.fromRGB(78, 49, 63),
    },

    Sunset = {
        Background = Color3.fromRGB(27, 19, 14),
        Background2 = Color3.fromRGB(47, 29, 19),
        Panel = Color3.fromRGB(43, 29, 21),
        PanelDark = Color3.fromRGB(27, 20, 16),
        Accent = Color3.fromRGB(255, 145, 72),
        Accent2 = Color3.fromRGB(255, 82, 118),
        Text = Color3.fromRGB(255, 248, 239),
        TextDark = Color3.fromRGB(211, 190, 171),
        Stroke = Color3.fromRGB(82, 57, 41),
    },
}

local CurrentTheme = Themes.Midnight

local State = {
    Open = false,
    Minimized = false,
    SelectedTab = "MAIN",

    AimEnabled = false,
    AimFOV = CONFIG.DEFAULT_FOV,
    AimSmoothness = CONFIG.DEFAULT_SMOOTHNESS,
    AimPart = "Head",

    ESP = {
        Murder = {
            Enabled = false,
            Box = true,
            Name = true,
            Distance = true,
            Highlight = true,
            Color = Color3.fromRGB(255, 80, 100),
        },

        Sheriff = {
            Enabled = false,
            Box = true,
            Name = true,
            Distance = true,
            Highlight = true,
            Color = Color3.fromRGB(85, 160, 255),
        },

        Innocent = {
            Enabled = false,
            Box = true,
            Name = true,
            Distance = true,
            Highlight = true,
            Color = Color3.fromRGB(100, 230, 150),
        },
    },

    TPPoint = nil,
    SelectedTP = nil,

    Notifications = true,
    Spectating = false,
    SpectatedPlayer = nil,

    FPS = 0,
    Ping = 0,
}

--==================================================
-- HELPERS
--==================================================

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

    local original = button.Size

    button.MouseEnter:Connect(function()
        Tween(button, {
            BackgroundTransparency = 0,
        }, 0.12):Play()
    end)

    button.MouseLeave:Connect(function()
        Tween(button, {
            BackgroundTransparency = 0.15,
        }, 0.12):Play()
    end)

    button.MouseButton1Down:Connect(function()
        Tween(button, {
            Size = UDim2.new(
                original.X.Scale,
                original.X.Offset - 2,
                original.Y.Scale,
                original.Y.Offset - 2
            ),
        }, 0.07):Play()
    end)

    button.MouseButton1Up:Connect(function()
        Tween(button, {Size = original}, 0.08):Play()
    end)

    return button
end

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = CONFIG.GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local UIScale = Instance.new("UIScale")
UIScale.Scale = 1
UIScale.Parent = ScreenGui

--==================================================
-- NOTIFICATIONS
--==================================================

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
    if not State.Notifications then
        return
    end

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

    local titleLabel = CreateText(
        notification,
        title,
        14,
        UDim2.new(0, 15, 0, 7),
        Enum.Font.GothamBold
    )

    titleLabel.TextColor3 = CurrentTheme.Accent
    titleLabel.ZIndex = 202

    local messageLabel = CreateText(
        notification,
        message,
        11,
        UDim2.new(0, 15, 0, 31)
    )

    messageLabel.Size = UDim2.new(1, -24, 0, 30)
    messageLabel.TextWrapped = true
    messageLabel.ZIndex = 202

    notification.Position = UDim2.new(1, 320, 0, 0)

    Tween(notification, {
        Position = UDim2.new(1, 0, 0, 0),
    }, 0.25):Play()

    task.delay(duration, function()
        if notification.Parent then
            local t = Tween(notification, {
                Position = UDim2.new(1, 320, 0, 0),
                BackgroundTransparency = 1,
            }, 0.25)

            t:Play()
            t.Completed:Wait()

            if notification.Parent then
                notification:Destroy()
            end
        end
    end)
end

--==================================================
-- MAIN WINDOW
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
Main.Visible = false
Main.ZIndex = 5
Main.Parent = ScreenGui

Corner(Main, 12)
Stroke(Main, CurrentTheme.Stroke, 2, 0.1)
Gradient(Main, CurrentTheme.Background, CurrentTheme.Background2, 35)

local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "SakuraBackground"
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Size = UDim2.fromScale(1, 1)
BackgroundImage.Image = CONFIG.BACKGROUND_IMAGE
BackgroundImage.ImageTransparency = 0.32
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.ZIndex = 5
BackgroundImage.Parent = Main

local Overlay = Instance.new("Frame")
Overlay.BackgroundColor3 = CurrentTheme.Background
Overlay.BackgroundTransparency = 0.55
Overlay.Size = UDim2.fromScale(1, 1)
Overlay.BorderSizePixel = 0
Overlay.ZIndex = 6
Overlay.Parent = Main

-- Decorative petals
for i = 1, 20 do
    local petal = Instance.new("Frame")
    petal.BackgroundColor3 = Color3.fromRGB(255, 190, 214)
    petal.BackgroundTransparency = 0.35
    petal.BorderSizePixel = 0
    petal.Position = UDim2.fromScale(
        math.random(2, 95) / 100,
        math.random(2, 95) / 100
    )
    petal.Size = UDim2.fromOffset(
        math.random(8, 18),
        math.random(12, 24)
    )
    petal.Rotation = math.random(-60, 60)
    petal.ZIndex = 7
    petal.Parent = Main
    Corner(petal, 999)
end

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.BackgroundTransparency = 1
Header.Position = UDim2.fromOffset(16, 8)
Header.Size = UDim2.new(1, -32, 0, 48)
Header.ZIndex = 20
Header.Parent = Main

local Title = CreateText(
    Header,
    "HudrinHub",
    20,
    UDim2.fromOffset(0, 0),
    Enum.Font.GothamBold
)
Title.TextColor3 = CurrentTheme.Text
Title.Size = UDim2.fromOffset(220, 30)
Title.ZIndex = 21

local Subtitle = CreateText(
    Header,
    "Made by @f1uxfg",
    11,
    UDim2.fromOffset(2, 28)
)
Subtitle.TextColor3 = CurrentTheme.Text
Subtitle.ZIndex = 21

local AuthorButton = MakeButton(
    Header,
    "t.me/hudrinhub_scripts",
    UDim2.fromOffset(185, 32),
    UDim2.new(1, -295, 0, 7)
)
AuthorButton.TextColor3 = CurrentTheme.Text
AuthorButton.ZIndex = 21

AuthorButton.Activated:Connect(function()
    Notify("HudrinHub", "Official: t.me/hudrinhub_scripts", 3)
end)

local Minimize = MakeButton(
    Header,
    "—",
    UDim2.fromOffset(38, 32),
    UDim2.new(1, -102, 0, 7)
)
Minimize.TextSize = 18
Minimize.TextColor3 = CurrentTheme.Text
Minimize.ZIndex = 21

local Close = MakeButton(
    Header,
    "×",
    UDim2.fromOffset(38, 32),
    UDim2.new(1, -56, 0, 7)
)
Close.TextSize = 20
Close.TextColor3 = CurrentTheme.Text
Close.ZIndex = 21

--==================================================
-- MOBILE DRAG FOR HEADER
--==================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end)

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.fromOffset(12, 62)
Content.Size = UDim2.new(1, -24, 1, -72)
Content.ZIndex = 15
Content.Parent = Main

--==================================================
-- SIDEBAR
--==================================================

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

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 8)
sidebarPadding.PaddingBottom = UDim.new(0, 8)
sidebarPadding.PaddingLeft = UDim.new(0, 7)
sidebarPadding.PaddingRight = UDim.new(0, 7)
sidebarPadding.Parent = Sidebar

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 5)
sidebarLayout.Parent = Sidebar

local Tabs = {
    "MAIN",
    "AIM",
    "ESP",
    "TELEPORT",
    "PLAYERS",
    "MISC",
    "ROLES",
    "SETTINGS",
}

local TabButtons = {}
local Pages = {}

local PageContainer = Instance.new("Frame")
PageContainer.Name = "Pages"
PageContainer.BackgroundTransparency = 1
PageContainer.Position = UDim2.fromOffset(140, 0)
PageContainer.Size = UDim2.new(1, -140, 1, 0)
PageContainer.ZIndex = 16
PageContainer.Parent = Content

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
        page.Visible = name == tabName
    end

    for name, button in pairs(TabButtons) do
        Tween(button, {
            BackgroundColor3 =
                name == tabName
                and CurrentTheme.Accent
                or CurrentTheme.Panel,

            BackgroundTransparency =
                name == tabName
                and 0
                or 0.15,
        }, 0.15):Play()
    end
end

for _, tabName in ipairs(Tabs) do
    local button = MakeButton(
        Sidebar,
        tabName,
        UDim2.new(1, 0, 0, 36)
    )

    button.TextColor3 = CurrentTheme.Text
    button.ZIndex = 18

    TabButtons[tabName] = button
    CreatePage(tabName)

    button.Activated:Connect(function()
        SelectTab(tabName)
    end)
end

--==================================================
-- SECTION / TOGGLE
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

    local titleLabel = CreateText(
        section,
        title,
        15,
        UDim2.fromOffset(15, 8),
        Enum.Font.GothamBold
    )

    titleLabel.ZIndex = 19

    if description then
        local desc = CreateText(
            section,
            description,
            11,
            UDim2.fromOffset(15, 31)
        )

        desc.Size = UDim2.new(1, -30, 0, 25)
        desc.TextWrapped = true
        desc.TextTransparency = 0.2
        desc.ZIndex = 19
    end

    return section
end

local function Toggle(parent, text, default, callback)
    local enabled = default

    local button = MakeButton(
        parent,
        "",
        UDim2.fromOffset(145, 36)
    )

    local function update()
        button.Text = text .. "   " .. (enabled and "ON" or "OFF")

        button.BackgroundColor3 =
            enabled
            and CurrentTheme.Accent
            or CurrentTheme.Panel

        button.TextColor3 =
            enabled
            and CurrentTheme.Text
            or CurrentTheme.TextDark
    end

    update()

    button.Activated:Connect(function()
        enabled = not enabled
        update()

        if callback then
            callback(enabled)
        end
    end)

    return button
end


-- Compact MAIN dashboard
do
    local page = Pages.MAIN

    local welcome = Section(
        page,
        "HudrinHub",
        "Compact mobile control panel",
        82
    )

    local status = CreateText(
        welcome,
        "Status: Ready    •    Theme: Midnight",
        11,
        UDim2.fromOffset(15, 48)
    )
    status.TextColor3 = CurrentTheme.TextDark
    status.ZIndex = 19

    local quick = Section(
        page,
        "Quick Actions",
        "Быстрый доступ к основным функциям.",
        112
    )

    local openAim = MakeButton(quick, "Aim Assist", UDim2.fromOffset(120, 36), UDim2.fromOffset(15, 50))
    local openESP = MakeButton(quick, "ESP", UDim2.fromOffset(100, 36), UDim2.fromOffset(145, 50))
    local openPlayers = MakeButton(quick, "Players", UDim2.fromOffset(110, 36), UDim2.fromOffset(255, 50))

    openAim.Activated:Connect(function() SelectTab("AIM") end)
    openESP.Activated:Connect(function() SelectTab("ESP") end)
    openPlayers.Activated:Connect(function() SelectTab("PLAYERS") end)

    local tips = Section(
        page,
        "Interface",
        "HBS остаётся поверх меню и открывает/закрывает интерфейс.",
        82
    )
end

--==================================================
-- AIM
--==================================================

do
    local page = Pages.AIM

    local section = Section(
        page,
        "Training Aim",
        "Aim Assist работает только с NPC, имеющими тег HudrinTestTarget.",
        86
    )

    local toggle = Toggle(
        section,
        "Aim Assist",
        false,
        function(value)
            State.AimEnabled = value

            Notify(
                "Aim Assist",
                value and "Enabled" or "Disabled",
                2
            )
        end
    )

    toggle.Position = UDim2.new(1, -160, 0, 38)

    local fov = Section(
        page,
        "FOV Radius",
        "Радиус визуального круга.",
        115
    )

    local fovMinus = MakeButton(
        fov,
        "-",
        UDim2.fromOffset(42, 38),
        UDim2.fromOffset(15, 65)
    )

    local fovValue = CreateText(
        fov,
        tostring(State.AimFOV),
        14,
        UDim2.fromOffset(60, 65),
        Enum.Font.GothamBold
    )

    fovValue.TextXAlignment = Enum.TextXAlignment.Center
    fovValue.Size = UDim2.fromOffset(100, 38)

    local fovPlus = MakeButton(
        fov,
        "+",
        UDim2.fromOffset(42, 38),
        UDim2.fromOffset(165, 65)
    )

    local function updateFov(amount)
        State.AimFOV = math.clamp(
            State.AimFOV + amount,
            50,
            500
        )

        fovValue.Text = tostring(State.AimFOV)
    end

    fovMinus.Activated:Connect(function()
        updateFov(-10)
    end)

    fovPlus.Activated:Connect(function()
        updateFov(10)
    end)

    local smooth = Section(
        page,
        "Smoothness",
        "Скорость наведения на тренировочную цель.",
        115
    )

    local smoothMinus = MakeButton(
        smooth,
        "-",
        UDim2.fromOffset(42, 38),
        UDim2.fromOffset(15, 65)
    )

    local smoothValue = CreateText(
        smooth,
        string.format("%.2f", State.AimSmoothness),
        14,
        UDim2.fromOffset(60, 65),
        Enum.Font.GothamBold
    )

    smoothValue.TextXAlignment = Enum.TextXAlignment.Center
    smoothValue.Size = UDim2.fromOffset(100, 38)

    local smoothPlus = MakeButton(
        smooth,
        "+",
        UDim2.fromOffset(42, 38),
        UDim2.fromOffset(165, 65)
    )

    local function updateSmooth(amount)
        State.AimSmoothness = math.clamp(
            State.AimSmoothness + amount,
            0.03,
            1
        )

        smoothValue.Text =
            string.format("%.2f", State.AimSmoothness)
    end

    smoothMinus.Activated:Connect(function()
        updateSmooth(-0.05)
    end)

    smoothPlus.Activated:Connect(function()
        updateSmooth(0.05)
    end)

    local part = Section(
        page,
        "Target Part",
        "Выбор части тестового NPC.",
        110
    )

    local head = MakeButton(
        part,
        "HEAD",
        UDim2.fromOffset(125, 40),
        UDim2.fromOffset(15, 62)
    )

    local body = MakeButton(
        part,
        "BODY",
        UDim2.fromOffset(125, 40),
        UDim2.fromOffset(150, 62)
    )

    local function updatePart()
        head.BackgroundColor3 =
            State.AimPart == "Head"
            and CurrentTheme.Accent
            or CurrentTheme.Panel

        body.BackgroundColor3 =
            State.AimPart == "Body"
            and CurrentTheme.Accent
            or CurrentTheme.Panel
    end

    head.Activated:Connect(function()
        State.AimPart = "Head"
        updatePart()
    end)

    body.Activated:Connect(function()
        State.AimPart = "Body"
        updatePart()
    end)

    updatePart()
end

--==================================================
-- ESP
--==================================================

do
    local page = Pages.ESP

    Section(
        page,
        "Training ESP",
        "NPC с тегом HudrinTestTarget или обычные NPC в Workspace.",
        76
    )

    local roles = {"Murder", "Sheriff", "Innocent"}

    for _, role in ipairs(roles) do
        local data = State.ESP[role]

        local section = Section(
            page,
            role,
            "Настройки категории " .. role,
            180
        )

        local enabled = Toggle(
            section,
            "Enabled",
            data.Enabled,
            function(v)
                data.Enabled = v
            end
        )
        enabled.Position = UDim2.fromOffset(15, 56)

        local box = Toggle(
            section,
            "Box",
            data.Box,
            function(v)
                data.Box = v
            end
        )
        box.Position = UDim2.fromOffset(170, 56)

        local name = Toggle(
            section,
            "Name",
            data.Name,
            function(v)
                data.Name = v
            end
        )
        name.Position = UDim2.fromOffset(325, 56)

        local distance = Toggle(
            section,
            "Distance",
            data.Distance,
            function(v)
                data.Distance = v
            end
        )
        distance.Position = UDim2.fromOffset(15, 102)

        local highlight = Toggle(
            section,
            "Highlight",
            data.Highlight,
            function(v)
                data.Highlight = v
            end
        )
        highlight.Position = UDim2.fromOffset(170, 102)

        local color = MakeButton(
            section,
            "Color",
            UDim2.fromOffset(145, 36),
            UDim2.fromOffset(325, 102)
        )

        color.BackgroundColor3 = data.Color

        local palette = {
            Color3.fromRGB(255, 80, 100),
            Color3.fromRGB(255, 180, 80),
            Color3.fromRGB(100, 230, 150),
            Color3.fromRGB(80, 180, 255),
            Color3.fromRGB(210, 120, 255),
            Color3.fromRGB(255, 150, 210),
        }

        local colorIndex = 1

        color.Activated:Connect(function()
            colorIndex += 1

            if colorIndex > #palette then
                colorIndex = 1
            end

            data.Color = palette[colorIndex]
            color.BackgroundColor3 = data.Color
        end)
    end
end

--==================================================
-- TELEPORT
--==================================================

local function GetRoot()
    local character = LocalPlayer.Character
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function TeleportCharacter(cframe)
    local root = GetRoot()

    if not root then
        Notify("Teleport", "Character not found.", 3)
        return false
    end

    root.CFrame = cframe
    return true
end

do
    local page = Pages.TELEPORT

    local spawnSection = Section(
        page,
        "Spawn",
        "Teleport к SpawnLocation собственной игры.",
        105
    )

    local spawnButton = MakeButton(
        spawnSection,
        "Teleport To Spawn",
        UDim2.fromOffset(230, 42),
        UDim2.fromOffset(15, 53)
    )

    spawnButton.Activated:Connect(function()
        local spawn = workspace:FindFirstChildWhichIsA(
            "SpawnLocation",
            true
        )

        if not spawn then
            Notify("Teleport", "SpawnLocation не найден.", 3)
            return
        end

        if TeleportCharacter(
            spawn.CFrame + Vector3.new(0, 4, 0)
        ) then
            Notify("Teleport", "Teleported To Spawn", 2)
        end
    end)

    local tpSection = Section(
        page,
        "Saved TP Point",
        "Точка сохраняется только на время текущей сессии.",
        160
    )

    local set = MakeButton(
        tpSection,
        "Set TP Point",
        UDim2.fromOffset(190, 40),
        UDim2.fromOffset(15, 55)
    )

    local go = MakeButton(
        tpSection,
        "Teleport To TP Point",
        UDim2.fromOffset(210, 40),
        UDim2.fromOffset(220, 55)
    )

    local status = CreateText(
        tpSection,
        "TP Point: Not Saved",
        12,
        UDim2.fromOffset(15, 108)
    )

    set.Activated:Connect(function()
        local root = GetRoot()

        if not root then
            Notify("Teleport", "Character not found.", 3)
            return
        end

        State.TPPoint = root.CFrame
        status.Text = "TP Point: Saved"

        Notify("HudrinHub", "TP Point Saved", 3)
    end)

    go.Activated:Connect(function()
        if not State.TPPoint then
            Notify("Teleport", "Сначала Set TP Point.", 3)
            return
        end

        if TeleportCharacter(State.TPPoint) then
            Notify("Teleport", "Teleported To TP Point", 2)
        end
    end)

    local points = Section(
        page,
        "Selected Point",
        "Точки находятся в Workspace.HudrinTeleportPoints.",
        160
    )

    local selectedLabel = CreateText(
        points,
        "Selected: None",
        12,
        UDim2.fromOffset(15, 52)
    )

    local teleportSelected = MakeButton(
        points,
        "Teleport To Selected Point",
        UDim2.fromOffset(235, 40),
        UDim2.fromOffset(15, 95)
    )

    local folder = workspace:FindFirstChild(
        "HudrinTeleportPoints"
    )

    if folder then
        local x = 265

        for _, object in ipairs(folder:GetChildren()) do
            if object:IsA("BasePart") then
                local button = MakeButton(
                    points,
                    object.Name,
                    UDim2.fromOffset(105, 35),
                    UDim2.fromOffset(x, 52)
                )

                button.Activated:Connect(function()
                    State.SelectedTP = object
                    selectedLabel.Text =
                        "Selected: " .. object.Name
                end)

                x += 112
            end
        end
    end

    teleportSelected.Activated:Connect(function()
        local point = State.SelectedTP

        if not point
            or not point.Parent
            or not point:IsA("BasePart") then

            Notify("Teleport", "Точка не выбрана.", 3)
            return
        end

        if TeleportCharacter(
            point.CFrame + Vector3.new(0, 4, 0)
        ) then
            Notify("Teleport", "Teleported To Selected Point", 2)
        end
    end)

    local itemSection = Section(
        page,
        "Grab Gun / Test Item",
        "Ищет объект с тегом HudrinTestItem.",
        145
    )

    local itemStatus = CreateText(
        itemSection,
        "Status: Searching...",
        11,
        UDim2.fromOffset(15, 52)
    )

    itemStatus.Size = UDim2.new(1, -30, 0, 28)
    itemStatus.TextWrapped = true

    local itemButton = MakeButton(
        itemSection,
        "Teleport To Item",
        UDim2.fromOffset(230, 40),
        UDim2.fromOffset(15, 92)
    )

    local function FindTestItem()
        local tagged = CollectionService:GetTagged(
            CONFIG.TEST_ITEM_TAG
        )

        if #tagged > 0 then
            return tagged[1]
        end

        return workspace:FindFirstChild(
            "HudrinTestItem",
            true
        )
    end

    local function UpdateItemStatus()
        local item = FindTestItem()

        if item then
            itemStatus.Text =
                "Status: FOUND — " .. item.Name
        else
            itemStatus.Text = "Status: NOT FOUND"
        end
    end

    UpdateItemStatus()

    itemButton.Activated:Connect(function()
        local item = FindTestItem()

        if not item then
            Notify("Test Item", "Предмет не найден.", 3)
            UpdateItemStatus()
            return
        end

        local part

        if item:IsA("BasePart") then
            part = item
        elseif item:IsA("Model") then
            part =
                item.PrimaryPart
                or item:FindFirstChildWhichIsA(
                    "BasePart",
                    true
                )
        end

        if not part then
            Notify("Test Item", "BasePart не найден.", 3)
            return
        end

        if TeleportCharacter(
            part.CFrame + Vector3.new(0, 4, 0)
        ) then
            Notify("Test Item", "Teleported To Item", 3)
        end
    end)

    task.spawn(function()
        while ScreenGui.Parent do
            UpdateItemStatus()
            task.wait(2)
        end
    end)
end

--==================================================
-- PLAYERS
--==================================================

do
    local page = Pages.PLAYERS

    local searchSection = Section(
        page,
        "Players",
        "Поиск игроков собственной тестовой игры.",
        92
    )

    local SearchBox = Instance.new("TextBox")
    SearchBox.PlaceholderText = "Search player..."
    SearchBox.Text = ""
    SearchBox.ClearTextOnFocus = false
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 13
    SearchBox.TextColor3 = CurrentTheme.TextDark
    SearchBox.BackgroundColor3 = CurrentTheme.Panel
    SearchBox.BackgroundTransparency = 0.1
    SearchBox.Size = UDim2.new(1, -30, 0, 40)
    SearchBox.Position = UDim2.fromOffset(15, 45)
    SearchBox.BorderSizePixel = 0
    SearchBox.ZIndex = 20
    SearchBox.Parent = searchSection

    Corner(SearchBox, 9)
    Stroke(SearchBox, CurrentTheme.Stroke, 1, 0.3)

    local PlayerList = Instance.new("Frame")
    PlayerList.Name = "PlayerList"
    PlayerList.BackgroundTransparency = 1
    PlayerList.Size = UDim2.new(1, -8, 0, 0)
    PlayerList.AutomaticSize = Enum.AutomaticSize.Y
    PlayerList.ZIndex = 18
    PlayerList.Parent = page

    local playerLayout = Instance.new("UIListLayout")
    playerLayout.Padding = UDim.new(0, 7)
    playerLayout.Parent = PlayerList

    local function DistanceToPlayer(player)
        local myRoot = GetRoot()

        local character = player.Character
        local targetRoot =
            character
            and character:FindFirstChild("HumanoidRootPart")

        if not myRoot or not targetRoot then
            return "N/A"
        end

        return tostring(
            math.floor(
                (myRoot.Position - targetRoot.Position).Magnitude
            )
        ) .. " studs"
    end

    local function GetRole(player)
        local role = player:GetAttribute("Role")

        if typeof(role) == "string" then
            return role
        end

        return "Player"
    end

    local function ClearList()
        for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
    end

    local function AddPlayer(player)
        local row = Instance.new("Frame")
        row.BackgroundColor3 = CurrentTheme.Panel
        row.BackgroundTransparency = 0.15
        row.Size = UDim2.new(1, 0, 0, 112)
        row.BorderSizePixel = 0
        row.ZIndex = 18
        row.Parent = PlayerList

        Corner(row, 12)
        Stroke(row, CurrentTheme.Stroke, 1, 0.3)

        local name = CreateText(
            row,
            player.DisplayName .. "  @" .. player.Name,
            14,
            UDim2.fromOffset(14, 8),
            Enum.Font.GothamBold
        )
        name.ZIndex = 19

        local role = CreateText(
            row,
            "Role: " .. GetRole(player),
            11,
            UDim2.fromOffset(14, 35)
        )
        role.ZIndex = 19

        local distance = CreateText(
            row,
            "Distance: " .. DistanceToPlayer(player),
            11,
            UDim2.fromOffset(14, 55)
        )
        distance.ZIndex = 19

        local tp = MakeButton(
            row,
            "Teleport",
            UDim2.fromOffset(105, 34),
            UDim2.new(1, -340, 0, 15)
        )

        local spectate = MakeButton(
            row,
            "Spectate",
            UDim2.fromOffset(95, 34),
            UDim2.new(1, -225, 0, 15)
        )

        local stop = MakeButton(
            row,
            "Stop",
            UDim2.fromOffset(70, 34),
            UDim2.new(1, -120, 0, 15)
        )

        tp.Activated:Connect(function()
            local targetCharacter = player.Character
            local targetRoot =
                targetCharacter
                and targetCharacter:FindFirstChild(
                    "HumanoidRootPart"
                )

            if not targetRoot then
                Notify("Players", "Target unavailable.", 3)
                return
            end

            if TeleportCharacter(
                targetRoot.CFrame + Vector3.new(0, 3, 0)
            ) then
                Notify(
                    "Players",
                    "Teleported To " .. player.Name,
                    2
                )
            end
        end)

        spectate.Activated:Connect(function()
            local character = player.Character
            local humanoid =
                character
                and character:FindFirstChildOfClass("Humanoid")

            if not humanoid then
                Notify("Spectate", "Humanoid not found.", 3)
                return
            end

            local camera = workspace.CurrentCamera

            if camera then
                camera.CameraSubject = humanoid
                State.Spectating = true
                State.SpectatedPlayer = player
            end
        end)

        stop.Activated:Connect(function()
            local camera = workspace.CurrentCamera
            local character = LocalPlayer.Character

            local humanoid =
                character
                and character:FindFirstChildOfClass("Humanoid")

            if camera and humanoid then
                camera.CameraSubject = humanoid
            end

            State.Spectating = false
            State.SpectatedPlayer = nil
        end)
    end

    local function RefreshPlayers()
        ClearList()

        local query = string.lower(SearchBox.Text)

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local match =
                    query == ""
                    or string.find(
                        string.lower(player.Name),
                        query,
                        1,
                        true
                    )
                    or string.find(
                        string.lower(player.DisplayName),
                        query,
                        1,
                        true
                    )

                if match then
                    AddPlayer(player)
                end
            end
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(
        RefreshPlayers
    )

    Players.PlayerAdded:Connect(RefreshPlayers)
    Players.PlayerRemoving:Connect(RefreshPlayers)

    RefreshPlayers()

    task.spawn(function()
        while ScreenGui.Parent do
            for _, row in ipairs(PlayerList:GetChildren()) do
                if row:IsA("Frame") then
                    local nameLabel =
                        row:FindFirstChildOfClass("TextLabel")

                    local playerName

                    if nameLabel then
                        local text = nameLabel.Text
                        playerName =
                            string.match(
                                text,
                                "@(.+)$"
                            )
                    end

                    if playerName then
                        local player =
                            Players:FindFirstChild(playerName)

                        if player then
                            local labels = {}

                            for _, child in ipairs(
                                row:GetChildren()
                            ) do
                                if child:IsA("TextLabel") then
                                    table.insert(
                                        labels,
                                        child
                                    )
                                end
                            end

                            if labels[3] then
                                labels[3].Text =
                                    "Distance: "
                                    .. DistanceToPlayer(player)
                            end
                        end
                    end
                end
            end

            task.wait(1)
        end
    end)
end

--==================================================
-- ROLES
--==================================================

do
    local page = Pages.ROLES

    local roles = Section(
        page,
        "Role Tools",
        "Роли для собственной тестовой игры.",
        170
    )

    local roleNames = {"Murder", "Sheriff", "Innocent"}
    for i, roleName in ipairs(roleNames) do
        local row = MakeButton(
            roles,
            roleName,
            UDim2.new(1, -30, 0, 38),
            UDim2.fromOffset(15, 45 + (i - 1) * 42)
        )
        row.Activated:Connect(function()
            Notify("Roles", roleName .. " selected.", 2)
        end)
    end
end

--==================================================
-- MISC
--==================================================

do
    local page = Pages.MISC

    local info = Section(
        page,
        "Live Information",
        "Текущая информация клиента.",
        190
    )

    local FPSLabel = CreateText(
        info,
        "FPS: --",
        13,
        UDim2.fromOffset(15, 53)
    )

    local PingLabel = CreateText(
        info,
        "Ping: --",
        13,
        UDim2.fromOffset(15, 78)
    )

    local CharacterLabel = CreateText(
        info,
        "Character: --",
        13,
        UDim2.fromOffset(15, 103)
    )

    local ServerLabel = CreateText(
        info,
        "Server: --",
        13,
        UDim2.fromOffset(15, 128)
    )

    local reset = MakeButton(
        info,
        "Reset Character",
        UDim2.fromOffset(150, 36),
        UDim2.new(1, -170, 0, 52)
    )

    reset.Activated:Connect(function()
        if not CONFIG.ALLOW_RESET then
            Notify("Misc", "Reset disabled.", 3)
            return
        end

        local character = LocalPlayer.Character
        local humanoid =
            character
            and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.Health = 0
        end
    end)

    local rejoin = MakeButton(
        info,
        "Rejoin Server",
        UDim2.fromOffset(150, 36),
        UDim2.new(1, -170, 0, 98)
    )

    rejoin.Activated:Connect(function()
        if not CONFIG.ALLOW_REJOIN then
            Notify("Misc", "Rejoin disabled.", 3)
            return
        end

        TeleportService:Teleport(
            game.PlaceId,
            LocalPlayer
        )
    end)

    local notif = Section(
        page,
        "Notifications",
        "Управление всплывающими уведомлениями.",
        92
    )

    local notifToggle = Toggle(
        notif,
        "Notifications",
        State.Notifications,
        function(value)
            State.Notifications = value
        end
    )

    notifToggle.Position = UDim2.fromOffset(15, 46)
end

--==================================================
-- SETTINGS
--==================================================

do
    local page = Pages.SETTINGS

    local ui = Section(
        page,
        "Interface",
        "Mobile UI settings.",
        190
    )

    local scale90 = MakeButton(
        ui,
        "90%",
        UDim2.fromOffset(95, 40),
        UDim2.fromOffset(15, 55)
    )

    local scale100 = MakeButton(
        ui,
        "100%",
        UDim2.fromOffset(95, 40),
        UDim2.fromOffset(120, 55)
    )

    local scale110 = MakeButton(
        ui,
        "110%",
        UDim2.fromOffset(95, 40),
        UDim2.fromOffset(225, 55)
    )

    scale90.Activated:Connect(function()
        UIScale.Scale = 0.9
    end)

    scale100.Activated:Connect(function()
        UIScale.Scale = 1
    end)

    scale110.Activated:Connect(function()
        UIScale.Scale = 1.1
    end)

    local theme = Section(
        page,
        "Theme",
        "Pastel anime themes.",
        235
    )

    local themeNames = {"Midnight", "Graphite", "Purple", "Crimson", "Emerald", "Ocean", "Rose", "Sunset"}

    for index, themeName in ipairs(themeNames) do
        local button = MakeButton(
            theme,
            themeName,
            UDim2.fromOffset(120, 34),
            UDim2.fromOffset(15 + ((index - 1) % 2) * 130, 55 + math.floor((index - 1) / 2) * 39)
        )

        button.Activated:Connect(function()
            local newTheme = Themes[themeName]

            if not newTheme then
                return
            end

            CurrentTheme = newTheme

            Main.BackgroundColor3 = newTheme.Background
            Overlay.BackgroundColor3 = newTheme.Background
            Sidebar.BackgroundColor3 = newTheme.PanelDark
            HBS.BackgroundColor3 = newTheme.Accent
            HBS.TextColor3 = newTheme.Text

            for _, object in ipairs(ScreenGui:GetDescendants()) do
                if object:IsA("TextLabel") then
                    if object ~= Title and object ~= Subtitle then
                        object.TextColor3 = newTheme.TextDark
                    end
                elseif object:IsA("TextButton") or object:IsA("TextBox") then
                    object.TextColor3 = newTheme.TextDark
                    object.BackgroundColor3 = newTheme.Panel
                elseif object:IsA("UIStroke") then
                    object.Color = newTheme.Stroke
                end
            end

            Title.TextColor3 = newTheme.Text
            Subtitle.TextColor3 = newTheme.Text
            HBS.BackgroundColor3 = newTheme.Accent
            HBS.TextColor3 = newTheme.Text

            Notify(
                "HudrinHub",
                "Theme: " .. themeName,
                2
            )
        end)
    end

    local animation = Section(
        page,
        "Animation Speed",
        "Скорость UI-анимаций.",
        115
    )

    local slow = MakeButton(
        animation,
        "Slow",
        UDim2.fromOffset(100, 38),
        UDim2.fromOffset(15, 55)
    )

    local normal = MakeButton(
        animation,
        "Normal",
        UDim2.fromOffset(100, 38),
        UDim2.fromOffset(125, 55)
    )

    local fast = MakeButton(
        animation,
        "Fast",
        UDim2.fromOffset(100, 38),
        UDim2.fromOffset(235, 55)
    )

    slow.Activated:Connect(function()
        CONFIG.ANIMATION_SPEED = 0.45
    end)

    normal.Activated:Connect(function()
        CONFIG.ANIMATION_SPEED = 0.25
    end)

    fast.Activated:Connect(function()
        CONFIG.ANIMATION_SPEED = 0.12
    end)
end

--==================================================
-- FOV CIRCLE
--==================================================

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "TrainingFOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(State.AimFOV, State.AimFOV)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.ZIndex = 300
FOVCircle.Parent = ScreenGui

Corner(FOVCircle, 999)
Stroke(FOVCircle, CurrentTheme.Accent, 2, 0.1)

--==================================================
-- TRAINING AIM
--==================================================

local function IsTrainingNPC(model)
    if not model or not model:IsA("Model") then
        return false
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return false
    end

    -- Tagged test targets always qualify.
    if CollectionService:HasTag(model, CONFIG.TRAINING_NPC_TAG) then
        return true
    end

    -- Also support ordinary NPC models in Workspace.
    -- Player characters are excluded.
    if Players:GetPlayerFromCharacter(model) then
        return false
    end

    return model:IsDescendantOf(workspace)
end

local function GetTrainingNPCs()
    local result = {}
    local seen = {}

    for _, model in ipairs(CollectionService:GetTagged(CONFIG.TRAINING_NPC_TAG)) do
        if IsTrainingNPC(model) and not seen[model] then
            seen[model] = true
            table.insert(result, model)
        end
    end

    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model")
            and not seen[model]
            and IsTrainingNPC(model) then
            seen[model] = true
            table.insert(result, model)
        end
    end

    return result
end

local function GetNPCRole(model)
    local role = model:GetAttribute("Role")

    if typeof(role) == "string"
        and State.ESP[role] then
        return role
    end

    local value = model:FindFirstChild("Role")

    if value and value:IsA("StringValue")
        and State.ESP[value.Value] then
        return value.Value
    end

    return "Innocent"
end

local function GetTargetPart(model)
    if State.AimPart == "Head" then
        return model:FindFirstChild("Head")
            or model:FindFirstChild("UpperTorso")
    end

    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("UpperTorso")
        or model:FindFirstChild("Torso")
end

local function FindBestTrainingTarget()
    local camera = workspace.CurrentCamera

    if not camera then
        return nil
    end

    local viewport = camera.ViewportSize
    local center = Vector2.new(
        viewport.X / 2,
        viewport.Y / 2
    )

    local best
    local bestDistance = State.AimFOV

    for _, model in ipairs(GetTrainingNPCs()) do
        if IsTrainingNPC(model) then
            local humanoid =
                model:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local part = GetTargetPart(model)

                if part then
                    local screen, visible =
                        camera:WorldToViewportPoint(
                            part.Position
                        )

                    if visible and screen.Z > 0 then
                        local point = Vector2.new(
                            screen.X,
                            screen.Y
                        )

                        local distance =
                            (point - center).Magnitude

                        if distance < bestDistance then
                            bestDistance = distance
                            best = part
                        end
                    end
                end
            end
        end
    end

    return best
end

RunService.RenderStepped:Connect(function()
    if not State.AimEnabled then
        FOVCircle.Visible = false
        return
    end

    FOVCircle.Visible = true
    FOVCircle.Size = UDim2.fromOffset(
        State.AimFOV,
        State.AimFOV
    )

    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    local target = FindBestTrainingTarget()

    if target then
        local targetCFrame = CFrame.lookAt(
            camera.CFrame.Position,
            target.Position
        )

        camera.CFrame =
            camera.CFrame:Lerp(
                targetCFrame,
                State.AimSmoothness
            )
    end
end)

--==================================================
-- ESP
--==================================================

local ESPObjects = {}

local function RemoveESP(model)
    local data = ESPObjects[model]

    if not data then
        return
    end

    if data.Highlight then
        data.Highlight:Destroy()
    end

    if data.Billboard then
        data.Billboard:Destroy()
    end

    ESPObjects[model] = nil
end

local function CreateESP(model)
    if not IsTrainingNPC(model) then
        return
    end

    if ESPObjects[model] then
        return
    end

    local role = GetNPCRole(model)
    local settings = State.ESP[role]

    if not settings or not settings.Enabled then
        return
    end

    local root =
        model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

    if not root then
        return
    end

    local data = {}

    if settings.Highlight then
        local highlight = Instance.new("Highlight")
        highlight.Name = "HudrinESPHighlight"
        highlight.Adornee = model
        highlight.FillColor = settings.Color
        highlight.OutlineColor = settings.Color
        highlight.FillTransparency = 0.72
        highlight.OutlineTransparency = 0.05
        highlight.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = model

        data.Highlight = highlight
    end

    if settings.Box
        or settings.Name
        or settings.Distance then

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "HudrinESP"
        billboard.Adornee = root
        billboard.Size = UDim2.fromOffset(180, 70)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = root

        local frame = Instance.new("Frame")
        frame.BackgroundTransparency = 1
        frame.Size = UDim2.fromScale(1, 1)
        frame.Parent = billboard

        if settings.Box then
            Corner(frame, 3)
            Stroke(frame, settings.Color, 1.5, 0.1)
        end

        local label = Instance.new("TextLabel")
        label.Name = "Info"
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(1, 1)
        label.TextColor3 = settings.Color
        label.TextStrokeTransparency = 0.4
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Parent = frame

        data.Billboard = billboard
        data.Label = label
    end

    ESPObjects[model] = data
end

local function UpdateESP()
    for model in pairs(ESPObjects) do
        if not model.Parent
            or not IsTrainingNPC(model) then
            RemoveESP(model)
        end
    end

    for _, model in ipairs(GetTrainingNPCs()) do
        local role = GetNPCRole(model)
        local settings = State.ESP[role]

        if settings and settings.Enabled then
            if not ESPObjects[model] then
                CreateESP(model)
            end

            local data = ESPObjects[model]

            if data then
                if data.Highlight then
                    data.Highlight.Enabled =
                        settings.Highlight

                    data.Highlight.FillColor =
                        settings.Color

                    data.Highlight.OutlineColor =
                        settings.Color
                end

                if data.Label then
                    local root =
                        model:FindFirstChild(
                            "HumanoidRootPart"
                        )

                    local text = ""

                    if settings.Name then
                        text = model.Name
                    end

                    if settings.Distance and root then
                        local myRoot = GetRoot()

                        if myRoot then
                            local distance =
                                math.floor(
                                    (
                                        myRoot.Position
                                        - root.Position
                                    ).Magnitude
                                )

                            if text ~= "" then
                                text ..= "\n"
                            end

                            text ..=
                                tostring(distance)
                                .. " studs"
                        end
                    end

                    data.Label.Text = text
                    data.Label.TextColor3 =
                        settings.Color
                end
            end
        elseif ESPObjects[model] then
            RemoveESP(model)
        end
    end
end

task.spawn(function()
    while ScreenGui.Parent do
        UpdateESP()
        task.wait(0.4)
    end
end)

--==================================================
-- HBS FLOATING MOBILE BUTTON
--==================================================

local HBS = Instance.new("TextButton")
HBS.Name = "HBS"
HBS.AnchorPoint = Vector2.new(0.5, 0.5)
HBS.Position = UDim2.new(0.5, 320, 0.5, -205)
HBS.Size = UDim2.fromOffset(42, 42)
HBS.BackgroundColor3 = CurrentTheme.Accent
HBS.BackgroundTransparency = 0.05
HBS.Text = "≡"
HBS.TextSize = 14
HBS.Font = Enum.Font.GothamBold
HBS.TextColor3 = Color3.fromRGB(255, 255, 255)
HBS.BorderSizePixel = 0
HBS.AutoButtonColor = false
HBS.ZIndex = 500
HBS.Parent = ScreenGui

Corner(HBS, 999)
Stroke(HBS, Color3.fromRGB(255, 225, 235), 2, 0.05)
Gradient(HBS, CurrentTheme.Accent, CurrentTheme.Accent2, 45)

local hbsDragging = false
local hbsDragStart
local hbsStartPosition
local hbsMoved = false

HBS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        hbsDragging = true
        hbsMoved = false
        hbsDragStart = input.Position
        hbsStartPosition = HBS.Position
    end
end)

HBS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        hbsDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not hbsDragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    local delta = input.Position - hbsDragStart

    if delta.Magnitude > 8 then
        hbsMoved = true
    end

    HBS.Position = UDim2.new(
        hbsStartPosition.X.Scale,
        hbsStartPosition.X.Offset + delta.X,
        hbsStartPosition.Y.Scale,
        hbsStartPosition.Y.Offset + delta.Y
    )
end)

local function OpenHub()
    State.Open = true
    State.Minimized = false

    HBS.Visible = true
    HBS.Text = "×"
    Main.Visible = true
    Content.Visible = true

    Main.Size = UDim2.fromOffset(420, 270)
    Main.BackgroundTransparency = 1

    Tween(
        Main,
        {
            Size = UDim2.fromOffset(
                CONFIG.WINDOW_WIDTH,
                CONFIG.WINDOW_HEIGHT
            ),
            BackgroundTransparency = 0.08,
        },
        0.3
    ):Play()
end

local function CloseHub()
    State.Open = false
    HBS.Text = "≡"

    local tween = Tween(
        Main,
        {
            Size = UDim2.fromOffset(620, 390),
            BackgroundTransparency = 1,
        },
        0.25
    )

    tween:Play()

    task.spawn(function()
        tween.Completed:Wait()

        if not State.Open then
            Main.Visible = false
            HBS.Visible = true
            HBS.Text = "≡"

            Main.Size = UDim2.fromOffset(
                CONFIG.WINDOW_WIDTH,
                CONFIG.WINDOW_HEIGHT
            )

            Main.BackgroundTransparency = 0.08
        end
    end)
end

-- Connection is attached after CloseHub is declared below.

Close.Activated:Connect(CloseHub)

HBS.Activated:Connect(function()
    if hbsMoved then
        hbsMoved = false
        return
    end

    if State.Open then
        CloseHub()
    else
        OpenHub()
    end
end)

Minimize.Activated:Connect(function()
    State.Minimized = not State.Minimized

    if State.Minimized then
        Content.Visible = false

        Tween(
            Main,
            {
                Size = UDim2.fromOffset(
                    CONFIG.WINDOW_WIDTH,
                    82
                ),
            },
            0.25
        ):Play()
    else
        Tween(
            Main,
            {
                Size = UDim2.fromOffset(
                    CONFIG.WINDOW_WIDTH,
                    CONFIG.WINDOW_HEIGHT
                ),
            },
            0.25
        ):Play()

        task.delay(0.12, function()
            if State.Minimized == false then
                Content.Visible = true
            end
        end)
    end
end)

--==================================================
-- MOBILE RESPONSIVE SIZE
--==================================================

local function UpdateResponsiveSize()
    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    local viewport = camera.ViewportSize

    -- Phone / portrait
    if viewport.X < 700 then
        Main.Size = UDim2.new(
            0.90,
            0,
            0.78,
            0
        )

        Sidebar.Size = UDim2.new(
            0,
            math.clamp(viewport.X * 0.19, 68, 88),
            1,
            0
        )

        PageContainer.Position =
            UDim2.new(
                0,
                math.clamp(viewport.X * 0.19, 68, 88) + 12,
                0,
                0
            )

        PageContainer.Size =
            UDim2.new(
                1,
                -(math.clamp(viewport.X * 0.19, 68, 88) + 17),
                1,
                0
            )

        for _, button in pairs(TabButtons) do
            button.TextSize = math.clamp(
                viewport.X / 45,
                9,
                12
            )
        end
    else
        Main.Size = UDim2.fromOffset(
            CONFIG.WINDOW_WIDTH,
            CONFIG.WINDOW_HEIGHT
        )

        Sidebar.Size = UDim2.fromOffset(128, 0)
        PageContainer.Position = UDim2.fromOffset(140, 0)
        PageContainer.Size = UDim2.new(1, -140, 1, 0)

        for _, button in pairs(TabButtons) do
            button.TextSize = 13
        end
    end
end

local function ConnectViewport()
    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    UpdateResponsiveSize()

    camera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(UpdateResponsiveSize)
end

ConnectViewport()

workspace:GetPropertyChangedSignal(
    "CurrentCamera"
):Connect(function()
    task.wait()
    ConnectViewport()
end)

--==================================================
-- FPS / PING
--==================================================

local frames = 0
local fpsTimer = 0

RunService.RenderStepped:Connect(function(dt)
    frames += 1
    fpsTimer += dt

    if fpsTimer >= 1 then
        State.FPS = frames
        frames = 0
        fpsTimer = 0
    end

    local ping = 0

    pcall(function()
        ping = math.floor(
            LocalPlayer:GetNetworkPing() * 1000
        )
    end)

    State.Ping = ping
end)

task.spawn(function()
    while ScreenGui.Parent do
        local misc = Pages.MISC

        if misc then
            local section = misc:FindFirstChildOfClass("Frame")

            if section then
                local labels = {}

                for _, object in ipairs(
                    section:GetChildren()
                ) do
                    if object:IsA("TextLabel") then
                        table.insert(labels, object)
                    end
                end

                if labels[2] then
                    labels[2].Text =
                        "FPS: " .. State.FPS
                end

                if labels[3] then
                    labels[3].Text =
                        "Ping: " .. State.Ping .. " ms"
                end

                if labels[4] then
                    labels[4].Text =
                        "Character: "
                        .. (
                            LocalPlayer.Character
                            and LocalPlayer.Character.Name
                            or "None"
                        )
                end

                if labels[5] then
                    labels[5].Text =
                        "Server: " .. game.JobId
                end
            end
        end

        task.wait(0.5)
    end
end)

--==================================================
-- CHARACTER / SPECTATE
--==================================================

LocalPlayer.CharacterAdded:Connect(function()
    State.Spectating = false
    State.SpectatedPlayer = nil
end)

--==================================================
-- DEFAULT TAB
--==================================================

SelectTab("AIM")

--==================================================
-- STARTUP
--==================================================

task.delay(0.7, function()
    Notify(
        "HudrinHub",
        "Нажми HBS для открытия меню.",
        3
    )
end)

-- HBS is the ONLY initial launcher.
Main.Visible = false
HBS.Visible = true
HBS.Text = "≡"
