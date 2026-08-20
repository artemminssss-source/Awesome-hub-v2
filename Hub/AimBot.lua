local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local AimBot = {}

AimBot.Variables = {
    enabled = false,
    rainbow = false,
    rainbowSpeed = 5,
    color = Color3.fromRGB(255, 0, 0),
    radius = 50,
    lineWidth = 2,
    targetPart = "Head",
    smoothness = 0.15,
    mode = "Classic",
    connection = nil,
    line = nil,
    target = nil,
}

local function CanSeeTarget(origin, targetPos, targetPlayer)
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local ignoreList = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Character then
            table.insert(ignoreList, p.Character)
        end
    end
    raycastParams.FilterDescendantsInstances = ignoreList
    
    local result = workspace:Raycast(origin, direction * distance, raycastParams)
    return result == nil
end

local function GetTargets()
    local targets = {}
    local character = player.Character
    if not character then return targets end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return targets end
    
    local head = character:FindFirstChild("Head")
    local origin = head and head.Position or hrp.Position
    
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherChar = otherPlayer.Character
            local otherHrp = otherChar:FindFirstChild("HumanoidRootPart")
            if otherHrp and otherChar:FindFirstChild("Humanoid") and otherChar.Humanoid.Health > 0 then
                local targetPart = otherChar:FindFirstChild(AimBot.Variables.targetPart) or otherHrp
                local distance = (hrp.Position - otherHrp.Position).Magnitude
                
                if distance <= AimBot.Variables.radius then
                    local canSee = CanSeeTarget(origin, targetPart.Position, otherPlayer)
                    if canSee then
                        table.insert(targets, {
                            Player = otherPlayer,
                            Character = otherChar,
                            Part = targetPart,
                            Distance = distance
                        })
                    end
                end
            end
        end
    end
    
    table.sort(targets, function(a, b) return a.Distance < b.Distance end)
    return targets
end

local function GetClosestToCrosshair()
    local targets = GetTargets()
    if #targets == 0 then return nil end
    
    local bestTarget = nil
    local bestScore = math.huge
    
    for _, target in ipairs(targets) do
        local screenPos, onScreen = camera:WorldToViewportPoint(target.Part.Position)
        if onScreen then
            local centerX, centerY = camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2
            local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(centerX, centerY)).Magnitude
            local distanceWeight = target.Distance / AimBot.Variables.radius
            local score = distanceFromCenter * 0.7 + distanceWeight * 0.3
            
            if score < bestScore then
                bestScore = score
                bestTarget = target
            end
        end
    end
    
    return bestTarget
end

local function UpdateLine()
    if not AimBot.Variables.line then
        AimBot.Variables.line = Drawing.new("Line")
        AimBot.Variables.line.ZIndex = 999
        AimBot.Variables.line.Thickness = AimBot.Variables.lineWidth
        AimBot.Variables.line.Color = AimBot.Variables.color
        AimBot.Variables.line.Visible = false
        AimBot.Variables.line.Transparency = 0.7
    end
    
    local line = AimBot.Variables.line
    local target = AimBot.Variables.target
    
    if not AimBot.Variables.enabled or not target then
        line.Visible = false
        return
    end
    
    local character = player.Character
    if not character then 
        line.Visible = false
        return
    end
    
    local head = character:FindFirstChild("Head")
    if not head then 
        line.Visible = false
        return
    end
    
    local targetPart = target.Part
    if not targetPart or not targetPart.Parent then
        line.Visible = false
        return
    end
    
    local headScreen = camera:WorldToViewportPoint(head.Position)
    local targetScreen = camera:WorldToViewportPoint(targetPart.Position)
    
    if headScreen and targetScreen then
        line.From = Vector2.new(headScreen.X, headScreen.Y)
        line.To = Vector2.new(targetScreen.X, targetScreen.Y)
        
        if AimBot.Variables.rainbow then
            line.Color = Color3.fromHSV(tick() % AimBot.Variables.rainbowSpeed / AimBot.Variables.rainbowSpeed, 1, 1)
        else
            line.Color = AimBot.Variables.color
        end
        
        line.Thickness = AimBot.Variables.lineWidth
        line.Visible = true
    else
        line.Visible = false
    end
end

local function Aim()
    if not AimBot.Variables.enabled then 
        AimBot.Variables.target = nil
        if AimBot.Variables.line then AimBot.Variables.line.Visible = false end
        return 
    end
    
    local character = player.Character
    if not character then 
        AimBot.Variables.target = nil
        if AimBot.Variables.line then AimBot.Variables.line.Visible = false end
        return 
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        AimBot.Variables.target = nil
        if AimBot.Variables.line then AimBot.Variables.line.Visible = false end
        return 
    end
    
    local currentTarget = AimBot.Variables.target
    local targetStillValid = false
    
    if currentTarget then
        local head = character:FindFirstChild("Head")
        local origin = head and head.Position or hrp.Position
        
        if currentTarget.Part and currentTarget.Part.Parent then
            local canSee = CanSeeTarget(origin, currentTarget.Part.Position, currentTarget.Player)
            local distance = (hrp.Position - currentTarget.Part.Position).Magnitude
            
            if canSee and distance <= AimBot.Variables.radius and currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid") and currentTarget.Character.Humanoid.Health > 0 then
                targetStillValid = true
            end
        end
    end
    
    if not targetStillValid then
        AimBot.Variables.target = GetClosestToCrosshair()
    end
    
    local target = AimBot.Variables.target
    
    if not target then 
        if AimBot.Variables.line then AimBot.Variables.line.Visible = false end
        return 
    end
    
    local targetPos = target.Part.Position
    local currentCFrame = camera.CFrame
    local lookAt = CFrame.lookAt(currentCFrame.Position, targetPos)
    
    if AimBot.Variables.mode == "Smooth" then
        camera.CFrame = camera.CFrame:Lerp(lookAt, AimBot.Variables.smoothness)
    else
        camera.CFrame = lookAt
    end
end

function AimBot.Toggle(value)
    AimBot.Variables.enabled = value
    
    if value then
        if AimBot.Variables.connection then
            AimBot.Variables.connection:Disconnect()
        end
        AimBot.Variables.connection = RunService.Heartbeat:Connect(function()
            Aim()
            UpdateLine()
        end)
        print("✅ Aim Bot ENABLED")
    else
        if AimBot.Variables.connection then
            AimBot.Variables.connection:Disconnect()
            AimBot.Variables.connection = nil
        end
        if AimBot.Variables.line then
            AimBot.Variables.line.Visible = false
        end
        AimBot.Variables.target = nil
        print("❌ Aim Bot DISABLED")
    end
end

function AimBot.SetRainbow(value)
    AimBot.Variables.rainbow = value
end

function AimBot.SetRainbowSpeed(value)
    AimBot.Variables.rainbowSpeed = value
end

function AimBot.SetRadius(value)
    AimBot.Variables.radius = value
end

function AimBot.SetLineWidth(value)
    AimBot.Variables.lineWidth = value
    if AimBot.Variables.line then
        AimBot.Variables.line.Thickness = value
    end
end

function AimBot.SetTargetPart(value)
    AimBot.Variables.targetPart = value
end

function AimBot.SetMode(value)
    AimBot.Variables.mode = value
end

function AimBot.SetSmoothness(value)
    AimBot.Variables.smoothness = value
end

function AimBot.SetColor(value)
    AimBot.Variables.color = value
    if AimBot.Variables.line then
        AimBot.Variables.line.Color = value
    end
end

return AimBot
