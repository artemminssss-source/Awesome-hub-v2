-- Загрузка библиотеки
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/artemminssss-source/Awesome-hub-v2/refs/heads/main/config.lua"))()
local Library = loadstring(game:HttpGet(Config.LibraryURL))()
local ThemeManager = loadstring(game:HttpGet(Config.ThemeURL))()
local SaveManager = loadstring(game:HttpGet(Config.SaveURL))()

-- Загрузка модулей
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/artemminssss-source/Awesome-hub-v2/main/Config.lua"))()

local AimBot = loadstring(game:HttpGet("https://raw.githubusercontent.com/artemminssss-source/Awesome-hub-v2/main/Hub/AimBot.lua"))()

local SalientAim = loadstring(game:HttpGet("https://raw.githubusercontent.com/artemminssss-source/Awesome-hub-v2/main/Hub/SalientAim.lua"))()

local Visuals = loadstring(game:HttpGet("https://raw.githubusercontent.com/artemminssss-source/Awesome-hub-v2/main/Hub/Visuals.lua"))()

local WorldFX = loadstring(game:HttpGet("https://raw.githubusercontent.com/artemminssss-source/Awesome-hub-v2/main/Hub/WorldFX.lua"))()

local Utilities = loadstring(game:HttpGet("https://raw.githubusercontent.com/artemminssss-source/Awesome-hub-v2/main/Hub/Utilities.lua"))()

local Window = Library:CreateWindow({
    Title = Config.MenuTitle,
    Footer = Config.MenuFooter,
    Icon = Config.MenuIcon,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Center = true,
    AutoShow = true,
    Resizable = true,
    TabPadding = 10,
    CornerRadius = 10,
    Animations = {
        ToggleWindow = true,
        TabSwitch = true,
        Groupbox = true,
        Dropdown = true,
        KeyPicker = true
    },
    TabTransitionTime = 0.22,
    EnableSidebarResize = true,
    MinSidebarWidth = 200,
    SidebarCompactWidth = 56,
})

Library.ShowToggleFrameInKeybinds = true

-- ===================== TABS =====================
local MainTab = Window:AddTab("Main", "home")
local RageTab = Window:AddTab("Rage", "target")
local VisualTab = Window:AddTab("Visual", "palette")
local SettingsTab = Window:AddTab("Settings", "settings")

-- ===================== MAIN TAB =====================
local MainGroup = MainTab:AddLeftGroupbox("Information")
MainGroup:AddLabel("Awesome script in development")
MainGroup:AddLabel("Visuals only for now")
MainGroup:AddLabel("(More features coming soon)")

-- ===================== RAGE TAB =====================
local RageGroup = RageTab:AddLeftGroupbox("Salient Aim")

RageGroup:AddToggle("SalientAimToggle", {
    Text = "Enable Salient Aim",
    Default = false,
    Callback = function(Value)
        SalientAim.Toggle(Value)
    end,
})

RageGroup:AddSlider("SalientAimFOV", {
    Text = "FOV Radius",
    Default = 120,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        SalientAim.SetFOV(Value)
    end,
})

-- ===================== VISUAL TAB =====================
-- Hat Groupbox
local HatGroupBox = VisualTab:AddLeftGroupbox("Chinese Hat")

HatGroupBox:AddToggle("HatToggle", {
    Text = "Enable Hat",
    Default = false,
    Callback = function(Value)
        Visuals.Hat.Toggle(Value)
    end,
})

HatGroupBox:AddSlider("HatRadius", {
    Text = "Radius",
    Default = 2.4,
    Min = 0.5,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Visuals.Hat.SetRadius(Value)
    end,
})

-- Trail Groupbox
local TrailGroupBox = VisualTab:AddLeftGroupbox("Trail")

TrailGroupBox:AddToggle("TrailToggle", {
    Text = "Enable Trail",
    Default = false,
    Callback = function(Value)
        Visuals.Trail.Toggle(Value)
    end,
})

TrailGroupBox:AddSlider("TrailLifetime", {
    Text = "Lifetime",
    Default = 0.5,
    Min = 0.1,
    Max = 3,
    Rounding = 1,
    Callback = function(Value)
        Visuals.Trail.SetLifetime(Value)
    end,
})

-- Skybox Groupbox
local SkyboxGroupBox = VisualTab:AddRightGroupbox("Skybox")

SkyboxGroupBox:AddDropdown("SkyboxDropdown", {
    Values = {"HD", "Space", "Sunset", "Pink"},
    Default = "HD",
    Text = "Select Skybox",
    Callback = function(Value)
        WorldFX.Skybox.Apply(Value)
    end,
})

SkyboxGroupBox:AddToggle("SkyboxToggle", {
    Text = "Enable Skybox",
    Default = false,
    Callback = function(Value)
        WorldFX.Skybox.Toggle(Value)
    end,
})

-- ===================== SETTINGS TAB =====================
local MenuGroup = SettingsTab:AddLeftGroupbox("Menu Settings")

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu Keybind"
})

MenuGroup:AddButton("Unload Script", function()
    Library:Unload()
end)

Library.ToggleKeybind = Library.Options.MenuKeybind

-- ===================== THEME & SAVE =====================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("AwesomeHub")
SaveManager:SetFolder("AwesomeHub")
SaveManager:BuildConfigSection(SettingsTab)
ThemeManager:ApplyToTab(SettingsTab)
SaveManager:LoadAutoloadConfig()

print("✅ AWESOME HUB MENU LOADED!")
print("📌 Press RightShift to open menu")
