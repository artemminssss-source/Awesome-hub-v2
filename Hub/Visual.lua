local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Visuals = {}

-- ===================== HAT (КИТАЙСКАЯ ШЛЯПА) =====================
Visuals.Hat = {}
Visuals.Hat.Variables = {
    enabled = false,
    style = "Classic", -- Classic или Drawing
    transparency = 0.3,
    rainbow = false,
    rainbowSpeed = 5,
    color = Color3.fromRGB(0, 255, 255),
    radius = 2.4,
    height = 1.6,
    reflectance = 0,
    sides = 25,
    parts = {},
    connection = nil,
}

local tau = math.pi * 2
local hatDrawings = {}

for i = 1, Visuals.Hat.Variables.sides do
    hatDrawings[i] = {Drawing.new('Line'), Drawing.new('Triangle')}
    hatDrawings[i][1].ZIndex = 2
    hatDrawings[i][1].Thickness = 2
    hatDrawings[i][2].ZIndex = 1
    hatDrawings[i][2].Filled = true
end

local function Hat_RemoveClassic()
    if Visuals.Hat.Variables.parts[player.Character] then 
        Visuals.Hat.Variables.parts[player.Character]:Destroy()
        Visuals.Hat.Variables.parts[player.Character] = nil 
    end
end

local function Hat_AddClassic(char)
    task.wait(0.1)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    Hat_RemoveClassic()

    local hat = Instance.new("Part")
    hat.Name = "ChineseHat"
    hat.Transparency = Visuals.Hat.Variables.transparency
    hat.Color = Visuals.Hat.Variables.color
    hat.Material = Enum.Material.Neon
    hat.CanCollide = false
    hat.Reflectance = Visuals.Hat.Variables.reflectance

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = "rbxassetid://1033714"
    mesh.Scale = Vector3.new(Visuals.Hat.Variables.radius, Visuals.Hat.Variables.height, Visuals.Hat.Variables.radius)
    mesh.Parent = hat

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = hat
    weld.Parent = hat

    hat.CFrame = head.CFrame * CFrame.new(0, 1.1, 0)
    hat.Parent = char
    Visuals.Hat.Variables.parts[char] = hat
end

local function Hat_UpdateClassic()
    for char, hat in pairs(Visuals.Hat.Variables.parts) do
        if hat and hat.Parent and char == player.Character then
            hat.Transparency = Visuals.Hat.Variables.transparency
            hat.Reflectance = Visuals.Hat.Variables.reflectance
            
            if Visuals.Hat.Variables.rainbow then
                hat.Color = Color3.fromHSV(tick() % Visuals.Hat.Variables.rainbowSpeed / Visuals.Hat.Variables.rainbowSpeed, 1, 1)
            else
                hat.Color = Visuals.Hat.Variables.color
            end
            
            local mesh = hat:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh.Scale = Vector3.new(Visuals.Hat.Variables.radius, Visuals.Hat.Variables.height, Visuals.Hat.Variables.radius)
            end
        end
    end
end

local function Hat_UpdateDrawing()
    local pass = Visuals.Hat.Variables.enabled and player.Character and player.Character:FindFirstChild('Head') ~= nil
    
    for i = 1, #hatDrawings do
        local line, triangle = hatDrawings[i][1], hatDrawings[i][2]
        if pass then
            local color
            if Visuals.Hat.Variables.rainbow then
                color = Color3.fromHSV((tick() % Visuals.Hat.Variables.rainbowSpeed / Visuals.Hat.Variables.rainbowSpeed - (i / #hatDrawings)) % 1, 0.5, 1)
            else
                color = Visuals.Hat.Variables.color
            end
            
            local pos = player.Character.Head.Position + Vector3.new(0, 0.75, 0)
            local topWorld = pos + Vector3.new(0, 0.75, 0)

            local last, next = (i / Visuals.Hat.Variables.sides) * tau, ((i + 1) / Visuals.Hat.Variables.sides) * tau
            local lastWorld = pos + (Vector3.new(math.cos(last), 0, math.sin(last)) * Visuals.Hat.Variables.radius)
            local nextWorld = pos + (Vector3.new(math.cos(next), 0, math.sin(next)) * Visuals.Hat.Variables.radius)
            local lastScreen = camera:WorldToViewportPoint(lastWorld)
            local nextScreen = camera:WorldToViewportPoint(nextWorld)
            local topScreen = camera:WorldToViewportPoint(topWorld)

            line.From = Vector2.new(lastScreen.X, lastScreen.Y)
            line.To = Vector2.new(nextScreen.X, nextScreen.Y)
            line.Color = color
            line.Transparency = 1 - Visuals.Hat.Variables.transparency
            line.Visible = true

            triangle.PointA = Vector2.new(topScreen.X, topScreen.Y)
            triangle.PointB = line.From
            triangle.PointC = line.To
            triangle.Color = color
            triangle.Transparency = 0.35
            triangle.Visible = true
        else
            line.Visible = false
            triangle.Visible = false
        end
    end
end

function Visuals.Hat.Toggle(value)
    Visuals.Hat.Variables.enabled = value
    if value then
        if Visuals.Hat.Variables.style == "Classic" and player.Character then
            Hat_AddClassic(player.Character)
        end
        if Visuals.Hat.Variables.connection then Visuals.Hat.Variables.connection:Disconnect() end
        Visuals.Hat.Variables.connection = RunService.Heartbeat:Connect(function()
            if Visuals.Hat.Variables.style == "Classic" then Hat_UpdateClassic() end
        end)
        -- Для Drawing стиля используется RenderStepped в основном цикле
    else
        if player.Character then Hat_RemoveClassic() end
        for i = 1, #hatDrawings do
            hatDrawings[i][1].Visible = false
            hatDrawings[i][2].Visible = false
        end
        if Visuals.Hat.Variables.connection then 
            Visuals.Hat.Variables.connection:Disconnect()
            Visuals.Hat.Variables.connection = nil 
        end
    end
end

function Visuals.Hat.SetStyle(style)
    Visuals.Hat.Variables.style = style
    if Visuals.Hat.Variables.enabled then
        Visuals.Hat.Toggle(false)
        task.wait(0.1)
        Visuals.Hat.Toggle(true)
    end
end

function Visuals.Hat.UpdateSides(sides)
    Visuals.Hat.Variables.sides = sides
    for i = 1, #hatDrawings do
        hatDrawings[i][1]:Remove()
        hatDrawings[i][2]:Remove()
    end
    hatDrawings = {}
    for i = 1, sides do
        hatDrawings[i] = {Drawing.new('Line'), Drawing.new('Triangle')}
        hatDrawings[i][1].ZIndex = 2
        hatDrawings[i][1].Thickness = 2
        hatDrawings[i][2].ZIndex = 1
        hatDrawings[i][2].Filled = true
    end
end

-- Подключение Drawing стиля к рендеру
RunService.RenderStepped:Connect(function()
    if Visuals.Hat.Variables.enabled and Visuals.Hat.Variables.style == "Drawing" then
        Hat_UpdateDrawing()
    end
end)


-- ===================== TRAIL (ТРЕЙЛЫ) =====================
Visuals.Trail = {}
Visuals.Trail.Variables = {
    enabled = false,
    isGradient = false,
    lifetime = 0.5,
    transparencyStart = 0,
    rainbow = false,
    colorStatic = Color3.fromRGB(0, 255, 255),
    gradient1 = Color3.fromRGB(0, 86, 255),
    gradient2 = Color3.fromRGB(255, 0, 0),
    parts = {},
    connection = nil,
}

local function Trail_RemoveFromCharacter(char)
    if Visuals.Trail.Variables.parts[char] then 
        Visuals.Trail.Variables.parts[char]:Destroy()
        Visuals.Trail.Variables.parts[char] = nil 
    end
    if char and char:FindFirstChild("HumanoidRootPart") then
        local torso = char.HumanoidRootPart
        if torso:FindFirstChild("TrailAttach0") then torso.TrailAttach0:Destroy() end
        if torso:FindFirstChild("TrailAttach1") then torso.TrailAttach1:Destroy() end
    end
end

local function Trail_AddToCharacter(character)
    local torso = character:WaitForChild("HumanoidRootPart", 5)
    if not torso then return end
    Trail_RemoveFromCharacter(character)

    local a0 = Instance.new("Attachment")
    a0.Name = "TrailAttach0"
    a0.Position = Vector3.new(0, 2, 0)
    a0.Parent = torso

    local a1 = Instance.new("Attachment")
    a1.Name = "TrailAttach1"
    a1.Position = Vector3.new(0, -2, 0)
    a1.Parent = torso

    local trail = Instance.new("Trail")
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Lifetime = Visuals.Trail.Variables.lifetime
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, Visuals.Trail.Variables.transparencyStart),
        NumberSequenceKeypoint.new(1, 1)
    })
    
    if Visuals.Trail.Variables.isGradient then
        trail.Color = ColorSequence.new(Visuals.Trail.Variables.gradient1, Visuals.Trail.Variables.gradient2)
    else
        trail.Color = ColorSequence.new(Visuals.Trail.Variables.colorStatic)
    end
    
    trail.LightEmission = 0.2
    trail.Enabled = true
    trail.Parent = character
    Visuals.Trail.Variables.parts[character] = trail
end

local function Trail_UpdateAll()
    for char, trail in pairs(Visuals.Trail.Variables.parts) do
        if trail and trail.Parent and char == player.Character then
            trail.Lifetime = Visuals.Trail.Variables.lifetime
            trail.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, Visuals.Trail.Variables.transparencyStart),
                NumberSequenceKeypoint.new(1, 1)
            })
            
            if Visuals.Trail.Variables.isGradient then
                trail.Color = ColorSequence.new(Visuals.Trail.Variables.gradient1, Visuals.Trail.Variables.gradient2)
            else
                if Visuals.Trail.Variables.rainbow then
                    trail.Color = ColorSequence.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
                else
                    trail.Color = ColorSequence.new(Visuals.Trail.Variables.colorStatic)
                end
            end
        end
    end
end

function Visuals.Trail.Toggle(value)
    Visuals.Trail.Variables.enabled = value
    if value and player.Character then
        Trail_AddToCharacter(player.Character)
        if Visuals.Trail.Variables.connection then Visuals.Trail.Variables.connection:Disconnect() end
        Visuals.Trail.Variables.connection = RunService.Heartbeat:Connect(Trail_UpdateAll)
    else
        if player.Character then Trail_RemoveFromCharacter(player.Character) end
        if Visuals.Trail.Variables.connection then 
            Visuals.Trail.Variables.connection:Disconnect()
            Visuals.Trail.Variables.connection = nil 
        end
    end
end


-- ===================== CLASSIC AURA (МОДЕЛЬКИ) =====================
Visuals.ClassicAura = {}

local AuraModels = {
    'Godly', 'Super Sayien', 'North Star', 'Blue Lord', 
    'Pink Aura', 'Angel Wing', 'Sweet Heart', 'Ethereal Aura',
}

local AuraModelIDs = {
    ['Godly'] = 'rbxassetid://16699750981',
    ['Super Sayien'] = 'rbxassetid://116109508364297',
    ['North Star'] = 'rbxassetid://83945069652732',
    ['Blue Lord'] = 'rbxassetid://10974316799',
    ['Pink Aura'] = 'rbxassetid://115980859615239',
    ['Angel Wing'] = 'rbxassetid://90022969696073',
    ['Sweet Heart'] = 'rbxassetid://91724768175470',
    ['Ethereal Aura'] = 'rbxassetid://97041568674250',
}

local activeClassicAuras = {}

local function ClassicAura_LoadModel(id)
    local success, result = pcall(function() 
        return game:GetObjects(id)[1] 
    end)
    if not success then return nil end
    return result
end

local function ClassicAura_DisableOne(auraName)
    if activeClassicAuras[auraName] then
        for _, v in pairs(activeClassicAuras[auraName]) do 
            if v and v.Parent then pcall(function() v:Destroy() end) end 
        end
        activeClassicAuras[auraName] = nil
    end
end

local function ClassicAura_EnableOne(char, auraName)
    if not char or not char.Parent then return end
    ClassicAura_DisableOne(auraName)
    
    local id = AuraModelIDs[auraName]
    if not id then return end
    
    local model = ClassicAura_LoadModel(id)
    if not model then return end
    
    local effects = {}
    for _, obj in pairs(model:GetDescendants()) do
        if not obj:IsA('BasePart') then
            pcall(function()
                local clone = obj:Clone()
                local parentName = obj.Parent and obj.Parent.Name
                local target = char:FindFirstChild(parentName)
                if not target then 
                    target = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA('BasePart')
                end
                if target then
                    clone.Parent = target
                    table.insert(effects, clone)
                end
            end)
        end
    end
    pcall(function() model:Destroy() end)
    
    if #effects > 0 then
        activeClassicAuras[auraName] = effects
    end
end

function Visuals.ClassicAura.Refresh(selectedAuras)
    local char = player.Character
    if not char then return end
    
    -- Сначала выключаем все
    for _, auraName in ipairs(AuraModels) do
        ClassicAura_DisableOne(auraName)
    end
    
    -- Включаем выбранные
    if type(selectedAuras) == "table" then
        for auraName, isSelected in pairs(selectedAuras) do
            if isSelected then
                task.spawn(function()
                    ClassicAura_EnableOne(char, auraName)
                end)
            end
        end
    end
end


-- ===================== PARTICLE AURA (ЧАСТИЦЫ) =====================
Visuals.ParticleAura = {}

local PARTICLE_AURA_DATA = {
    { "starlight", "rbxassetid://134645216613107" },
    { "heavenly", "rbxassetid://139300897520961" },
    { "ribbon", "rbxassetid://132069507632161" },
    { "sakura", "rbxassetid://81755778619404" },
    { "angel", "rbxassetid://97658130917593" },
    { "wind", "rbxassetid://80694081850877" },
    { "flow", "rbxassetid://119913533725648" },
    { "star", "rbxassetid://73754563740680" },
    { "neon", "rbxassetid://18498709246" },
}

local particleAuraIdByName = {}
for _, row in ipairs(PARTICLE_AURA_DATA) do
    particleAuraIdByName[row[1]] = row[2]
end

local loadedParticleAuras = {}
local activeParticleAuras = {}

local function mapCharacterParts(character)
    local parts = {}
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("BasePart") then
            parts[child.Name] = child
        end
    end
    return parts
end

local function getParticleAuraTemplate(name)
    local cached = loadedParticleAuras[name]
    if cached then return cached end
    local id = particleAuraIdByName[name]
    if not id then return nil end
    local ok, result = pcall(function()
        return game:GetObjects(id)[1]
    end)
    if ok and result then
        loadedParticleAuras[name] = result
        return result
    end
    return nil
end

local function tintParticleSubtree(root, color)
    if not color or not root then return end
    local seq = ColorSequence.new(color)
    local function tintOne(obj)
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                obj.Color = seq
            elseif obj:IsA("PointLight") then
                obj.Color = color
            end
        end)
    end
    tintOne(root)
    for _, d in ipairs(root:GetDescendants()) do
        tintOne(d)
    end
end

local function applyParticleAuraToCharacter(character, auraName, color)
    local auraObj = getParticleAuraTemplate(auraName)
    if not auraObj then return {} end

    local localParts = mapCharacterParts(character)
    local cloned = auraObj:Clone()
    local created = {}

    for _, part in ipairs(cloned:GetChildren()) do
        local targetPart = localParts[part.Name]
        if targetPart then
            for _, child in ipairs(part:GetChildren()) do
                pcall(function()
                    local inst = child:Clone()
                    inst.Name = "LarpticAuraParticle"
                    inst.Parent = targetPart
                    if color then
                        tintParticleSubtree(inst, color)
                    end
                    table.insert(created, inst)
                end)
            end
        end
    end
    pcall(function() cloned:Destroy() end)
    return created
end

local function ParticleAura_DisableOne(auraName)
    if activeParticleAuras[auraName] then
        for _, p in ipairs(activeParticleAuras[auraName]) do
            if p then pcall(function() p:Destroy() end) end
        end
        activeParticleAuras[auraName] = nil
    end
end

function Visuals.ParticleAura.Refresh(selectedAuras, color)
    local char = player.Character
    if not char then return end
    
    for _, auraName in pairs(particleAuraIdByName) do
        -- Находим имя по ID (упрощенно)
        for name, id in pairs(particleAuraIdByName) do
            if id == auraName then ParticleAura_DisableOne(name) end
        end
    end
    
    if type(selectedAuras) == "table" then
        for auraName, isSelected in pairs(selectedAuras) do
            if isSelected then
                task.spawn(function()
                    local particles = applyParticleAuraToCharacter(char, auraName, color)
                    activeParticleAuras[auraName] = particles
                end)
            end
        end
    end
end


-- ===================== FORCE FIELD =====================
Visuals.ForceField = {}
Visuals.ForceField.Variables = {
    enabled = false,
    color = Color3.fromRGB(128, 128, 128),
    rainbow = false,
    originalColors = {},
    connection = nil,
}

local function ForceField_SaveOriginalColors(char)
    Visuals.ForceField.Variables.originalColors[char] = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "ChineseHat" then
            Visuals.ForceField.Variables.originalColors[char][part] = {
                Color = part.Color,
                Material = part.Material
            }
        end
    end
end

local function ForceField_Apply(char)
    ForceField_SaveOriginalColors(char)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "ChineseHat" then
            part.Color = Visuals.ForceField.Variables.color
            part.Material = Enum.Material.ForceField
        end
    end
end

local function ForceField_Update()
    if player.Character and Visuals.ForceField.Variables.enabled then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "ChineseHat" and part.Material == Enum.Material.ForceField then
                if Visuals.ForceField.Variables.rainbow then
                    part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                else
                    part.Color = Visuals.ForceField.Variables.color
                end
            end
        end
    end
end

local function ForceField_Remove(char)
    if Visuals.ForceField.Variables.originalColors[char] then
        for part, data in pairs(Visuals.ForceField.Variables.originalColors[char]) do
            if part and part.Parent and part:IsA("BasePart") then
                part.Color = data.Color
                part.Material = data.Material
            end
        end
        Visuals.ForceField.Variables.originalColors[char] = {}
    end
end

function Visuals.ForceField.Toggle(value)
    Visuals.ForceField.Variables.enabled = value
    if player.Character then
        if value then
            ForceField_Apply(player.Character)
            if Visuals.ForceField.Variables.connection then Visuals.ForceField.Variables.connection:Disconnect() end
            Visuals.ForceField.Variables.connection = RunService.Heartbeat:Connect(ForceField_Update)
        else
            if Visuals.ForceField.Variables.connection then 
                Visuals.ForceField.Variables.connection:Disconnect()
                Visuals.ForceField.Variables.connection = nil 
            end
            ForceField_Remove(player.Character)
        end
    end
end


-- ===================== AURA TRAILER =====================
Visuals.AuraTrailer = {}
Visuals.AuraTrailer.Variables = {
    enabled = false,
    color = Color3.fromRGB(255, 0, 0),
    lifetime = 0.5,
}

function Visuals.AuraTrailer.Toggle(enabled)
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, v in pairs(character:GetChildren()) do
        if v:IsA("BasePart") and v ~= hrp then
            if enabled then
                if not v:FindFirstChild("AuraTrailer") then
                    local trail = Instance.new("Trail")
                    trail.Name = "AuraTrailer"
                    trail.Texture = "rbxassetid://1390780157"
                    trail.Parent = v

                    local p1 = Instance.new("Attachment", v)
                    p1.Name = "AuraPointer1"

                    local p2 = Instance.new("Attachment", hrp)
                    p2.Name = "AuraPointer2"

                    trail.Attachment0 = p1
                    trail.Attachment1 = p2
                    trail.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Visuals.AuraTrailer.Variables.color),
                        ColorSequenceKeypoint.new(1, Visuals.AuraTrailer.Variables.color)
                    })
                    trail.Lifetime = Visuals.AuraTrailer.Variables.lifetime
                end
            else
                if v:FindFirstChild("AuraTrailer") then v.AuraTrailer:Destroy() end
                if v:FindFirstChild("AuraPointer1") then v.AuraPointer1:Destroy() end
            end
        end
    end

    if not enabled then
        for _, obj in pairs(hrp:GetChildren()) do
            if obj.Name == "AuraPointer2" then obj:Destroy() end
        end
    end
end

function Visuals.AuraTrailer.Update()
    local character = player.Character
    if not character then return end
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("Trail") and v.Name == "AuraTrailer" then
            v.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Visuals.AuraTrailer.Variables.color),
                ColorSequenceKeypoint.new(1, Visuals.AuraTrailer.Variables.color)
            })
            v.Lifetime = Visuals.AuraTrailer.Variables.lifetime
        end
    end
end

return Visuals