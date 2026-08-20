local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local SalientAim = {}

SalientAim.Variables = {
    enabled = false,
    fov = 120,
    showFOVCircle = true,
    showSnapline = true,
    wallCheck = true,
    fovColor = Color3.fromRGB(255, 255, 255),
    fovTransparency = 0.8,
    fovThickness = 1.5,
    lineColor = Color3.fromRGB(255, 0, 0),
    lineTransparency = 0.9,
    lineThickness = 1.5,
    fovCircle = nil,
    snapLine = nil,
    bulletHandler = nil,
    oldFire = nil,
}

local function CreateDrawings()
    if not SalientAim.Variables.fovCircle then
        SalientAim.Variables.fovCircle = Drawing.new("Circle")
        SalientAim.Variables.fovCircle.Thickness = SalientAim.Variables.fovThickness
        SalientAim.Variables.fovCircle.Color = SalientAim.Variables.fovColor
        SalientAim.Variables.fovCircle.Transparency = SalientAim.Variables.fovTransparency
        SalientAim.Variables.fovCircle.Filled = false
        SalientAim.Variables.fovCircle.NumSides = 64
        SalientAim.Variables.fovCircle.Visible = false
    end
    
    if not SalientAim.Variables.snapLine then
        SalientAim.Variables.snapLine = Drawing.new("Line")
        SalientAim.Variables.snapLine.Thickness = SalientAim.Variables.lineThickness
        SalientAim.Variables.snapLine.Color = SalientAim.Variables.lineColor
        SalientAim.Variables.snapLine.Transparency = SalientAim.Variables.lineTransparency
        SalientAim.Variables.snapLine.Visible = false
    end
end

local function IsVisible(targetHead)
    if not SalientAim.Variables.wallCheck then return true end
    local origin = camera.CFrame.Position
    local direction = (targetHead.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    local result = Workspace:Raycast(origin, direction, raycastParams)
    return result == nil or result.Instance:IsDescendantOf(targetHead.Parent)
end

local function GetClosestTarget()
    local closestPart, closestDist = nil, SalientAim.Variables.fov

    for _, p in Players:GetPlayers() do
        if p == player then continue end
        local character = p.Character
        if not character then continue end
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        if not head or not humanoid or humanoid.Health <= 0 then continue end

        local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
        if not onScreen then continue end

        local screenCenter = camera.ViewportSize / 2
        local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

        if distance < closestDist and IsVisible(head) then
            closestPart = head
            closestDist = distance
        end
    end
    return closestPart
end

local function UpdateDrawings(target)
    local center = camera.ViewportSize / 2
    
    if SalientAim.Variables.showFOVCircle then
        SalientAim.Variables.fovCircle.Visible = true
        SalientAim.Variables.fovCircle.Position = center
        SalientAim.Variables.fovCircle.Radius = SalientAim.Variables.fov
        SalientAim.Variables.fovCircle.Color = SalientAim.Variables.fovColor
        SalientAim.Variables.fovCircle.Transparency = SalientAim.Variables.fovTransparency
        SalientAim.Variables.fovCircle.Thickness = SalientAim.Variables.fovThickness
    else
        SalientAim.Variables.fovCircle.Visible = false
    end
    
    if SalientAim.Variables.showSnapline and target then
        local screenPos = camera:WorldToViewportPoint(target.Position)
        SalientAim.Variables.snapLine.Visible = true
        SalientAim.Variables.snapLine.From = center
        SalientAim.Variables.snapLine.To = Vector2.new(screenPos.X, screenPos.Y)
        SalientAim.Variables.snapLine.Color = SalientAim.Variables.lineColor
        SalientAim.Variables.snapLine.Transparency = SalientAim.Variables.lineTransparency
        SalientAim.Variables.snapLine.Thickness = SalientAim.Variables.lineThickness
    else
        SalientAim.Variables.snapLine.Visible = false
    end
end

local function HookBulletHandler()
    if SalientAim.Variables.bulletHandler then
        SalientAim.Variables.oldFire = SalientAim.Variables.bulletHandler.Fire
    else
        pcall(function()
            SalientAim.Variables.bulletHandler = require(game:GetService("ReplicatedStorage").ModuleScripts.GunModules.BulletHandler)
            SalientAim.Variables.oldFire = SalientAim.Variables.bulletHandler.Fire
        end)
    end
    
    if not SalientAim.Variables.bulletHandler then return end
    
    SalientAim.Variables.bulletHandler.Fire = function(p6)
        if not SalientAim.Variables.enabled or not p6 or typeof(p6) ~= "table" or not p6.Origin then
            return SalientAim.Variables.oldFire(p6)
        end

        local targetHead = GetClosestTarget()

        if targetHead then
            local direction = (targetHead.Position - p6.Origin).Unit
            p6.Direction = direction
            if p6.Force then
                p6.Force = p6.Force * 20.224489795918366
            end
            if p6.Gravity then
                p6.Gravity = p6.Gravity * 0.6
            end
        end

        return SalientAim.Variables.oldFire(p6)
    end
end

local function UnhookBulletHandler()
    if SalientAim.Variables.bulletHandler and SalientAim.Variables.oldFire then
        SalientAim.Variables.bulletHandler.Fire = SalientAim.Variables.oldFire
    end
end

local RenderConnection = nil

function SalientAim.Toggle(value)
    SalientAim.Variables.enabled = value
    
    if value then
        CreateDrawings()
        HookBulletHandler()
        
        if RenderConnection then
            RenderConnection:Disconnect()
        end
        
        RenderConnection = RunService.RenderStepped:Connect(function()
            if not SalientAim.Variables.enabled then
                if SalientAim.Variables.fovCircle then SalientAim.Variables.fovCircle.Visible = false end
                if SalientAim.Variables.snapLine then SalientAim.Variables.snapLine.Visible = false end
                return
            end
            local target = GetClosestTarget()
            UpdateDrawings(target)
        end)
        print("✅ Salient Aim ENABLED")
    else
        if RenderConnection then
            RenderConnection:Disconnect()
            RenderConnection = nil
        end
        if SalientAim.Variables.fovCircle then SalientAim.Variables.fovCircle.Visible = false end
        if SalientAim.Variables.snapLine then SalientAim.Variables.snapLine.Visible = false end
        UnhookBulletHandler()
        print("❌ Salient Aim DISABLED")
    end
end

function SalientAim.SetFOV(value)
    SalientAim.Variables.fov = value
end

function SalientAim.SetShowFOV(value)
    SalientAim.Variables.showFOVCircle = value
end

function SalientAim.SetShowSnapline(value)
    SalientAim.Variables.showSnapline = value
end

function SalientAim.SetWallCheck(value)
    SalientAim.Variables.wallCheck = value
end

function SalientAim.SetFOVColor(value)
    SalientAim.Variables.fovColor = value
end

function SalientAim.SetFOVTransparency(value)
    SalientAim.Variables.fovTransparency = value
end

function SalientAim.SetFOVThickness(value)
    SalientAim.Variables.fovThickness = value
end

function SalientAim.SetLineColor(value)
    SalientAim.Variables.lineColor = value
end

function SalientAim.SetLineTransparency(value)
    SalientAim.Variables.lineTransparency = value
end

function SalientAim.SetLineThickness(value)
    SalientAim.Variables.lineThickness = value
end

return SalientAim