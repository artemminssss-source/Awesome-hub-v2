local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local camera = workspace.CurrentCamera

local WorldFX = {}

-- ===================== SKYBOX =====================
WorldFX.Skybox = {}

local SkyboxAssets = {
    ["HD"] = {
        Bk = "http://www.roblox.com/asset/?id=16553658937", Dn = "http://www.roblox.com/asset/?id=16553660713",
        Ft = "http://www.roblox.com/asset/?id=16553662144", Lf = "http://www.roblox.com/asset/?id=16553664042",
        Rt = "http://www.roblox.com/asset/?id=16553665766", Up = "http://www.roblox.com/asset/?id=16553667750"
    },
    ["Space"] = {
        Bk = "http://www.roblox.com/asset/?id=166509999", Dn = "http://www.roblox.com/asset/?id=166510057",
        Ft = "http://www.roblox.com/asset/?id=166510116", Lf = "http://www.roblox.com/asset/?id=166510092",
        Rt = "http://www.roblox.com/asset/?id=166510131", Up = "http://www.roblox.com/asset/?id=166510114"
    },
    ["Sunset"] = {
        Bk = "rbxassetid://600830446", Dn = "rbxassetid://600831635",
        Ft = "rbxassetid://600832720", Lf = "rbxassetid://600886090",
        Rt = "rbxassetid://600833862", Up = "rbxassetid://600835177"
    },
    ["Pink"] = {
        Bk = "rbxassetid://12216109205", Dn = "rbxassetid://12216109875",
        Ft = "rbxassetid://12216109489", Lf = "rbxassetid://12216110170",
        Rt = "rbxassetid://12216110471", Up = "rbxassetid://12216108877"
    },
}

local DefaultSky = Lighting:FindFirstChildOfClass("Sky")
local DefaultSkySettings = {}
if DefaultSky then
    DefaultSkySettings.SkyboxBk = DefaultSky.SkyboxBk
    DefaultSkySettings.SkyboxDn = DefaultSky.SkyboxDn
    DefaultSkySettings.SkyboxFt = DefaultSky.SkyboxFt
    DefaultSkySettings.SkyboxLf = DefaultSky.SkyboxLf
    DefaultSkySettings.SkyboxRt = DefaultSky.SkyboxRt
    DefaultSkySettings.SkyboxUp = DefaultSky.SkyboxUp
end

WorldFX.Skybox.Variables = {
    current = "HD",
    enabled = false,
}

local function Skybox_Apply(name)
    local sb = SkyboxAssets[name]
    if not sb then return end
    
    local assets = {sb.Bk, sb.Dn, sb.Ft, sb.Lf, sb.Rt, sb.Up}
    task.spawn(function()
        ContentProvider:PreloadAsync(assets)
    end)
    
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then 
        sky = Instance.new("Sky")
        sky.Name = "Sky" 
        sky.Parent = Lighting
    end
    
    sky.SkyboxBk = sb.Bk
    sky.SkyboxDn = sb.Dn
    sky.SkyboxFt = sb.Ft
    sky.SkyboxLf = sb.Lf
    sky.SkyboxRt = sb.Rt
    sky.SkyboxUp = sb.Up
end

local function Skybox_RestoreDefault()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky and DefaultSkySettings.SkyboxBk then
        sky.SkyboxBk = DefaultSkySettings.SkyboxBk
        sky.SkyboxDn = DefaultSkySettings.SkyboxDn
        sky.SkyboxFt = DefaultSkySettings.SkyboxFt
        sky.SkyboxLf = DefaultSkySettings.SkyboxLf
        sky.SkyboxRt = DefaultSkySettings.SkyboxRt
        sky.SkyboxUp = DefaultSkySettings.SkyboxUp
    elseif sky then
        sky:Destroy()
    end
end

function WorldFX.Skybox.Apply(name)
    WorldFX.Skybox.Variables.current = name
    if WorldFX.Skybox.Variables.enabled then
        Skybox_Apply(name)
    end
end

function WorldFX.Skybox.Toggle(value)
    WorldFX.Skybox.Variables.enabled = value
    if value then 
        Skybox_Apply(WorldFX.Skybox.Variables.current) 
    else 
        Skybox_RestoreDefault() 
    end
end

-- ===================== LIGHTING =====================
WorldFX.Lighting = {}

local defaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
}

WorldFX.Lighting.Variables = {
    timeEnabled = false,
    timeValue = 12,
    fullBrightEnabled = false,
}

function WorldFX.Lighting.SetTime(value)
    WorldFX.Lighting.Variables.timeValue = value
end

function WorldFX.Lighting.ToggleTime(value)
    WorldFX.Lighting.Variables.timeEnabled = value
end

function WorldFX.Lighting.ToggleFullBright(value)
    WorldFX.Lighting.Variables.fullBrightEnabled = value
    if not value then
        Lighting.Brightness = defaultLighting.Brightness
        Lighting.GlobalShadows = defaultLighting.GlobalShadows
        Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
    end
end

-- Heartbeat для обновления
RunService.Heartbeat:Connect(function()
    if WorldFX.Lighting.Variables.timeEnabled then 
        Lighting.ClockTime = WorldFX.Lighting.Variables.timeValue 
    end
    
    if WorldFX.Lighting.Variables.fullBrightEnabled then
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.ExposureCompensation = 0.3
    end
end)

return WorldFX