-- Hub/Interface.lua
-- Полный интерфейс для AWESOME HUB

local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_НИК/ТВОЙ_РЕПО/main/Config.lua"))()

-- Загрузка библиотеки
local Library = loadstring(game:HttpGet(Config.LibraryURL))()
local ThemeManager = loadstring(game:HttpGet(Config.ThemeURL))()
local SaveManager = loadstring(game:HttpGet(Config.SaveURL))()

-- Загрузка модулей логики
local AimBot = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_НИК/ТВОЙ_РЕПО/main/Hub/AimBot.lua"))()
local SalientAim = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_НИК/ТВОЙ_РЕПО/main/Hub/SalientAim.lua"))()
local Visuals = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_НИК/ТВОЙ_РЕПО/main/Hub/Visuals.lua"))()
local WorldFX = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_НИК/ТВОЙ_РЕПО/main/Hub/WorldFX.lua"))()
local Utilities = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_НИК/ТВОЙ_РЕПО/main/Hub/Utilities.lua"))()

Library.ShowToggleFrameInKeybinds = true

-- Создание окна
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

-- ===================== TABS =====================
local MainTab = Window:AddTab("Main", "home")
local RageTab = Window:AddTab("Rage", "target")
local VisualTab = Window:AddTab("Visual", "palette")
local SettingsTab = Window:AddTab("Settings", "settings")

-- ===================== MAIN TAB =====================
local MainGroup = MainTab:AddLeftGroupbox("Information")
MainGroup:AddLabel("Awesome script in development")
MainGroup:AddLabel("Visuals & Combat features")
MainGroup:AddLabel("(More features coming soon)")

-- ===================== RAGE TAB (AIMBOT & SALIENT) =====================

-- AimBot Group
local AimBotGroup = RageTab:AddLeftGroupbox("Aim Bot")

AimBotGroup:AddToggle("AimBotToggle", {
    Text = "Enable Aim Bot",
    Default = false,
    Callback = function(Value)
        AimBot.Toggle(Value)
    end,
})

AimBotGroup:AddToggle("AimBotRainbow", {
    Text = "Rainbow Line",
    Default = false,
    Callback = function(Value)
        AimBot.SetRainbow(Value)
    end,
})

AimBotGroup:AddSlider("AimBotRainbowSpeed", {
    Text = "Rainbow Speed",
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        AimBot.SetRainbowSpeed(Value)
    end,
})

AimBotGroup:AddSlider("AimBotRadius", {
    Text = "Search Radius",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        AimBot.SetRadius(Value)
    end,
})

AimBotGroup:AddSlider("AimBotLineWidth", {
    Text = "Line Width",
    Default = 2,
    Min = 1,
    Max = 5,
    Rounding = 0,
    Callback = function(Value)
        AimBot.SetLineWidth(Value)
    end,
})

AimBotGroup:AddDropdown("AimBotTargetPart", {
    Values = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"},
    Default = "Head",
    Text = "Target Part",
    Callback = function(Value)
        AimBot.SetTargetPart(Value)
    end,
})

AimBotGroup:AddDropdown("AimBotMode", {
    Values = {"Classic", "Smooth"},
    Default = "Classic",
    Text = "Aim Mode",
    Callback = function(Value)
        AimBot.SetMode(Value)
    end,
})

AimBotGroup:AddSlider("AimBotSmoothness", {
    Text = "Smoothness",
    Default = 0.15,
    Min = 0.01,
    Max = 0.5,
    Rounding = 2,
    Callback = function(Value)
        AimBot.SetSmoothness(Value)
    end,
})

AimBotGroup:AddLabel("Line Color"):AddColorPicker("AimBotColor", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Line Color",
    Callback = function(Value)
        AimBot.SetColor(Value)
    end,
})

-- Salient Aim Group
local SalientGroup = RageTab:AddRightGroupbox("Salient Aim")

SalientGroup:AddToggle("SalientAimToggle", {
    Text = "Enable Salient Aim",
    Default = false,
    Callback = function(Value)
        SalientAim.Toggle(Value)
    end,
})

SalientGroup:AddDivider()

SalientGroup:AddSlider("SalientAimFOV", {
    Text = "FOV Radius",
    Default = 120,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        SalientAim.SetFOV(Value)
    end,
})

SalientGroup:AddToggle("SalientAimShowFOV", {
    Text = "Show FOV Circle",
    Default = true,
    Callback = function(Value)
        SalientAim.SetShowFOV(Value)
    end,
})

SalientGroup:AddToggle("SalientAimShowSnapline", {
    Text = "Show Snapline",
    Default = true,
    Callback = function(Value)
        SalientAim.SetShowSnapline(Value)
    end,
})

SalientGroup:AddToggle("SalientAimWallCheck", {
    Text = "Wall Check",
    Default = true,
    Callback = function(Value)
        SalientAim.SetWallCheck(Value)
    end,
})

SalientGroup:AddDivider()

SalientGroup:AddLabel("FOV Circle Color"):AddColorPicker("SalientAimFOVColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "FOV Circle Color",
    Callback = function(Value)
        SalientAim.SetFOVColor(Value)
    end,
})

SalientGroup:AddSlider("SalientAimFOVTransparency", {
    Text = "FOV Transparency",
    Default = 0.8,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        SalientAim.SetFOVTransparency(Value)
    end,
})

SalientGroup:AddSlider("SalientAimFOVThickness", {
    Text = "FOV Thickness",
    Default = 1.5,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        SalientAim.SetFOVThickness(Value)
    end,
})

SalientGroup:AddDivider()

SalientGroup:AddLabel("Snapline Color"):AddColorPicker("SalientAimLineColor", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Snapline Color",
    Callback = function(Value)
        SalientAim.SetLineColor(Value)
    end,
})

SalientGroup:AddSlider("SalientAimLineTransparency", {
    Text = "Snapline Transparency",
    Default = 0.9,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        SalientAim.SetLineTransparency(Value)
    end,
})

SalientGroup:AddSlider("SalientAimLineThickness", {
    Text = "Snapline Thickness",
    Default = 1.5,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        SalientAim.SetLineThickness(Value)
    end,
})


-- ===================== VISUAL TAB =====================

-- Chinese Hat
local HatGroupBox = VisualTab:AddLeftGroupbox("Chinese Hat")

HatGroupBox:AddToggle("HatToggle", {
    Text = "Enable Hat",
    Default = false,
    Callback = function(Value)
        Visuals.Hat.Toggle(Value)
    end,
})

HatGroupBox:AddDropdown("HatStyle", {
    Values = {"Classic", "Drawing"},
    Default = "Classic",
    Text = "Hat Style",
    Callback = function(Value)
        Visuals.Hat.SetStyle(Value)
    end,
})

HatGroupBox:AddToggle("HatRainbow", {
    Text = "Rainbow Mode",
    Default = false,
    Callback = function(Value)
        Visuals.Hat.Variables.rainbow = Value -- Прямой доступ к переменной для простоты
    end,
})

HatGroupBox:AddSlider("HatRainbowSpeed", {
    Text = "Rainbow Speed",
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        Visuals.Hat.Variables.rainbowSpeed = Value
    end,
})

HatGroupBox:AddSlider("HatTransparency", {
    Text = "Transparency",
    Default = 0.3,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        Visuals.Hat.Variables.transparency = Value
    end,
})

HatGroupBox:AddSlider("HatRadius", {
    Text = "Radius",
    Default = 2.4,
    Min = 0.5,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Visuals.Hat.Variables.radius = Value
    end,
})

HatGroupBox:AddSlider("HatHeight", {
    Text = "Height",
    Default = 1.6,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        Visuals.Hat.Variables.height = Value
    end,
})

HatGroupBox:AddSlider("HatReflectance", {
    Text = "Reflectance",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        Visuals.Hat.Variables.reflectance = Value
    end,
})

HatGroupBox:AddSlider("HatSides", {
    Text = "Sides",
    Default = 25,
    Min = 3,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        Visuals.Hat.UpdateSides(Value)
    end,
})

HatGroupBox:AddLabel("Hat Color"):AddColorPicker("HatColor", {
    Default = Color3.fromRGB(0, 255, 255),
    Title = "Hat Color",
    Callback = function(Value)
        Visuals.Hat.Variables.color = Value
    end,
})

-- Trail
local TrailGroupBox = VisualTab:AddLeftGroupbox("Trail")
TrailGroupBox:AddToggle("TrailToggle", {
    Text = "Enable Trail",
    Default = false,
    Callback = function(Value)
        Visuals.Trail.Toggle(Value)
    end,
})
TrailGroupBox:AddToggle("TrailGradient", {
    Text = "Gradient Mode",
    Default = false,
    Callback = function(Value)
        Visuals.Trail.Variables.isGradient = Value
    end,
})
TrailGroupBox:AddSlider("TrailLifetime", {
    Text = "Lifetime",
    Default = 0.5,
    Min = 0.1,
    Max = 3,
    Rounding = 1,
    Callback = function(Value)
        Visuals.Trail.Variables.lifetime = Value
    end,
})
TrailGroupBox:AddSlider("TrailTransparency", {
    Text = "Start Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        Visuals.Trail.Variables.transparencyStart = Value
    end,
})
TrailGroupBox:AddToggle("TrailRainbow", {
    Text = "Rainbow",
    Default = false,
    Callback = function(Value)
        Visuals.Trail.Variables.rainbow = Value
    end,
})
TrailGroupBox:AddLabel("Static Color"):AddColorPicker("TrailColor", {
    Default = Color3.fromRGB(0, 255, 255),
    Title = "Trail Color",
    Callback = function(Value)
        Visuals.Trail.Variables.colorStatic = Value
    end,
})
TrailGroupBox:AddLabel("Gradient 1"):AddColorPicker("TrailGradient1", {
    Default = Color3.fromRGB(0, 86, 255),
    Title = "Gradient Color 1",
    Callback = function(Value)
        Visuals.Trail.Variables.gradient1 = Value
    end,
})
TrailGroupBox:AddLabel("Gradient 2"):AddColorPicker("TrailGradient2", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Gradient Color 2",
    Callback = function(Value)
        Visuals.Trail.Variables.gradient2 = Value
    end,
})

-- Force Field
local FFGroupBox = VisualTab:AddRightGroupbox("Force Field")
FFGroupBox:AddToggle("FFToggle", {
    Text = "Enable Force Field",
    Default = false,
    Callback = function(Value)
        Visuals.ForceField.Toggle(Value)
    end,
})
FFGroupBox:AddToggle("FFRainbow", {
    Text = "Rainbow Mode",
    Default = false,
    Callback = function(Value)
        Visuals.ForceField.Variables.rainbow = Value
    end,
})
FFGroupBox:AddLabel("Color"):AddColorPicker("FFColor", {
    Default = Color3.fromRGB(128, 128, 128),
    Title = "Force Field Color",
    Callback = function(Value)
        Visuals.ForceField.Variables.color = Value
    end,
})

-- Aura Trailer
local AuraTrailerGroupBox = VisualTab:AddRightGroupbox("Aura Trailer")
AuraTrailerGroupBox:AddToggle("AuraTrailerToggle", {
    Text = "Enable Aura Trailer",
    Default = false,
    Callback = function(Value)
        Visuals.AuraTrailer.Variables.enabled = Value
        Visuals.AuraTrailer.Toggle(Value)
    end,
})
AuraTrailerGroupBox:AddLabel("Color"):AddColorPicker("AuraTrailerColor", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Aura Trailer Color",
    Callback = function(Value)
        Visuals.AuraTrailer.Variables.color = Value
        if Visuals.AuraTrailer.Variables.enabled then Visuals.AuraTrailer.Update() end
    end,
})
AuraTrailerGroupBox:AddSlider("AuraTrailerLife", {
    Text = "Lifetime",
    Default = 0.5,
    Min = 0.1,
    Max = 3,
    Rounding = 1,
    Callback = function(Value)
        Visuals.AuraTrailer.Variables.lifetime = Value
        if Visuals.AuraTrailer.Variables.enabled then Visuals.AuraTrailer.Update() end
    end,
})

-- Classic Aura
local ClassicAuraGb = VisualTab:AddRightGroupbox('Classic Aura')
ClassicAuraGb:AddToggle('ClassicAuraEnabled', {
    Text = 'Enable Classic Aura',
    Default = false,
    Callback = function(Value)
        if Value then
            Visuals.ClassicAura.Refresh(Library.Options.ClassicAuraDropdown.Value)
        else
            Visuals.ClassicAura.Refresh({})
        end
    end,
})
ClassicAuraGb:AddDropdown('ClassicAuraDropdown', {
    Values = {'Godly', 'Super Sayien', 'North Star', 'Blue Lord', 'Pink Aura', 'Angel Wing', 'Sweet Heart', 'Ethereal Aura'},
    Default = {},
    Multi = true,
    Text = 'Select Auras',
    Callback = function(Value)
        if Library.Toggles.ClassicAuraEnabled and Library.Toggles.ClassicAuraEnabled.Value then
            Visuals.ClassicAura.Refresh(Value)
        end
    end,
})

-- Particle Aura
local ParticleAuraGb = VisualTab:AddLeftGroupbox('Particle Aura')
ParticleAuraGb:AddToggle('ParticleAuraEnabled', {
    Text = 'Enable Particle Aura',
    Default = false,
    Callback = function(Value)
        if Value then
            Visuals.ParticleAura.Refresh(Library.Options.ParticleAuraDropdown.Value, Library.Options.ParticleAuraColor.Value)
        else
            Visuals.ParticleAura.Refresh({})
        end
    end,
})
ParticleAuraGb:AddLabel('Aura Color'):AddColorPicker('ParticleAuraColor', {
    Default = Color3.fromRGB(133, 220, 255),
    Title = 'Particle Aura Color',
    Callback = function()
        if Library.Toggles.ParticleAuraEnabled and Library.Toggles.ParticleAuraEnabled.Value then
            Visuals.ParticleAura.Refresh(Library.Options.ParticleAuraDropdown.Value, Library.Options.ParticleAuraColor.Value)
        end
    end,
})
ParticleAuraGb:AddDropdown('ParticleAuraDropdown', {
    Values = {"starlight", "heavenly", "ribbon", "sakura", "angel", "wind", "flow", "star", "neon"},
    Default = {},
    Multi = true,
    Text = 'Select Auras',
    Callback = function(Value)
        if Library.Toggles.ParticleAuraEnabled and Library.Toggles.ParticleAuraEnabled.Value then
            Visuals.ParticleAura.Refresh(Value, Library.Options.ParticleAuraColor.Value)
        end
    end,
})

-- Screen Effect
local ScreenGroupBox = VisualTab:AddLeftGroupbox("Screen Effect")
ScreenGroupBox:AddToggle("ScreenToggle", {
    Text = "Enable Screen Effect",
    Default = false,
    Callback = function(Value)
        Utilities.Screen.Toggle(Value)
    end,
})
ScreenGroupBox:AddSlider("ScreenIntensity", {
    Text = "Screen Stretch",
    Default = 0,
    Min = 0,
    Max = 0.2,
    Rounding = 3,
    Callback = function(Value)
        Utilities.Screen.SetIntensity(Value)
    end,
})

-- Utilities (Anime & FPS)
local UtilsGroupBox = VisualTab:AddLeftGroupbox("Utilities")
UtilsGroupBox:AddToggle("AnimeImageToggle", {
    Text = "Anime Image",
    Default = false,
    Callback = function(Value)
        Utilities.Anime.Toggle(Value)
    end,
})
UtilsGroupBox:AddButton("FPS/Ping Counter 1", function()
    Utilities.FPS.LoadCounter1()
end)
UtilsGroupBox:AddButton("FPS/Ping Counter 2", function()
    Utilities.FPS.LoadCounter2()
end)

-- Skybox
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

-- Lighting
local LightingGroupBox = VisualTab:AddLeftGroupbox("Lighting")
LightingGroupBox:AddToggle("TimeToggle", {
    Text = "Enable Time Changer",
    Default = false,
    Callback = function(Value)
        WorldFX.Lighting.ToggleTime(Value)
    end,
})
LightingGroupBox:AddSlider("TimeSlider", {
    Text = "Time (0-24 hours)",
    Default = 12,
    Min = 0,
    Max = 24,
    Rounding = 1,
    Callback = function(Value)
        WorldFX.Lighting.SetTime(Value)
    end,
})
LightingGroupBox:AddToggle("FullBright", {
    Text = "Full Bright",
    Default = false,
    Callback = function(Value)
        WorldFX.Lighting.ToggleFullBright(Value)
    end,
})


-- ===================== SETTINGS TAB =====================
local MenuGroup = SettingsTab:AddLeftGroupbox("Menu Settings")
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})
MenuGroup:AddDivider()
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
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("AwesomeHub")
SaveManager:SetFolder("AwesomeHub")
SaveManager:BuildConfigSection(SettingsTab)
ThemeManager:ApplyToTab(SettingsTab)
SaveManager:LoadAutoloadConfig()

print("✅ AWESOME HUB MENU LOADED SUCCESSFULLY!")
print("📌 Press RightShift to open menu")