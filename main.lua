-- Точка входа
local Repo = "https://raw.githubusercontent.com/ТВОЙ_НИК/ТВОЙ_РЕПО/main/"

-- Загружаем конфиг
local Config = loadstring(game:HttpGet(Repo .. "Config.lua"))()

-- Загружаем систему ключей
local KeySystem = loadstring(game:HttpGet(Repo .. "KeySystem.lua"))()

-- Запускаем проверку ключей
KeySystem.Start(Config.DropBoxURL, function()
    print("✅ Key Verified! Loading AWESOME HUB...")
    
    -- Если ключ верный, загружаем интерфейс
    loadstring(game:HttpGet(Repo .. "Hub/Interface.lua"))()
end)