local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local KeySystem = {}

function KeySystem.Start(keysURL, onSuccess)
    -- Загрузка ключей с GitHub
    local validKeys = {}
    local loaded = false
    
    task.spawn(function()
        pcall(function()
            if HttpService.HttpEnabled then
                local response = HttpService:GetAsync(keysURL)
                if response then
                    -- Читаем построчно
                    for line in response:gmatch("[^\r\n]+") do
                        local k = line:gsub("%s+", "") -- Убираем пробелы
                        if #k > 0 then
                            table.insert(validKeys, k)
                        end
                    end
                    print("✅ Loaded " .. #validKeys .. " keys from GitHub")
                end
            end
        end)
        loaded = true
    end)

    -- Создание GUI (БЕЗ БЛЮРА, ПРОСТО ЧЕРНОЕ ОКНО)
    if game.CoreGui:FindFirstChild("KeySystemUI") then
        game.CoreGui.KeySystemUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystemUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = game.CoreGui

    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 380, 0, 260)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.BorderSizePixel = 0
    MainFrame.ZIndex = 2
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(30, 30, 30)
    Stroke.Thickness = 1

    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = "Awesome"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 36
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 3
    Title.Parent = MainFrame

    -- Подзаголовок
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, 0, 0, 25)
    Subtitle.Position = UDim2.new(0, 0, 0, 70)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Key System"
    Subtitle.TextColor3 = Color3.fromRGB(140, 140, 140)
    Subtitle.TextSize = 16
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.ZIndex = 3
    Subtitle.Parent = MainFrame

    -- Поле ввода
    local InputBg = Instance.new("Frame")
    InputBg.Size = UDim2.new(1, -40, 0, 42)
    InputBg.Position = UDim2.new(0, 20, 0, 115)
    InputBg.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    InputBg.BorderSizePixel = 0
    InputBg.ZIndex = 3
    InputBg.Parent = MainFrame
    Instance.new("UICorner", InputBg).CornerRadius = UDim.new(0, 8)
    local InputStroke = Instance.new("UIStroke", InputBg)
    InputStroke.Color = Color3.fromRGB(40, 40, 40)
    InputStroke.Thickness = 1

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.fromScale(1, 1)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter key here..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(70, 70, 70)
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 15
    KeyInput.Font = Enum.Font.GothamMedium
    KeyInput.ClearTextOnFocus = false
    KeyInput.ZIndex = 4
    KeyInput.Parent = InputBg

    -- Кнопка Verify
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(1, -40, 0, 40)
    VerifyBtn.Position = UDim2.new(0, 20, 0, 170)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(180, 90, 220)
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.TextSize = 15
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.AutoButtonColor = false
    VerifyBtn.BorderSizePixel = 0
    VerifyBtn.ZIndex = 3
    VerifyBtn.Parent = MainFrame
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)

    -- Статус
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -40, 0, 20)
    StatusLabel.Position = UDim2.new(0, 20, 0, 220)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.ZIndex = 3
    StatusLabel.Parent = MainFrame

    -- Функция проверки
    local function verifyKey()
        if not loaded then
            StatusLabel.Text = "⚠ Loading keys..."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 50)
            return
        end

        local enteredKey = KeyInput.Text:gsub("%s+", "")
        if enteredKey == "" then
            StatusLabel.Text = "⚠ Please enter a key"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 50)
            return
        end

        for _, k in ipairs(validKeys) do
            if enteredKey == k then
                StatusLabel.Text = "✓ Access granted!"
                StatusLabel.TextColor3 = Color3.fromRGB(80, 220, 120)
                VerifyBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
                
                task.delay(0.8, function()
                    ScreenGui:Destroy()
                    onSuccess()
                end)
                return
            end
        end

        StatusLabel.Text = "✗ Invalid key. Try again."
        StatusLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
    end

    VerifyBtn.MouseButton1Click:Connect(verifyKey)
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then verifyKey() end
    end)

    print("🔑 Key System loaded")
end

return KeySystem