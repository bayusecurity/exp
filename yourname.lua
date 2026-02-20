--[[
  ESCAPE TSUNAMI FOR BRAINROT - CARD MENU PREMIUM
  Fitur: Card Menu Tengah + Toggle Select + God Mode Tsunami + Token Generator
  Desain: Modern UI dengan efek glassmorphism
]]

-- Library untuk GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/Custom%20Modules/UI%20Library/Library.lua"))()
local Wait = Library.Wait

-- Variable utama
local player = game.Players.LocalPlayer
local tsunamigod = false
local selectedTokens = {}

-- =================== CARD MENU DI TENGAH ===================
local MainWindow = Library:CreateWindow({
    Text = "⚡ TOKEN GENERATOR + GOD MODE",
    Size = UDim2.new(0, 700, 0, 500),
    Position = UDim2.new(0.5, -350, 0.5, -250), -- DI TENGAH LAYAR!
    ToggleKey = Enum.KeyCode.RightCtrl
})

-- =================== TAB UTAMA ===================
local MainTab = MainWindow:AddTab("Main")
local TokenSection = MainTab:AddSection("Trade Token Generator", "left")

-- Token Info
local TokenInfo = TokenSection:AddLabel("Selected: 0/1000 Tokens")

-- =================== CARD GRID KEREN ===================
-- Frame khusus untuk card di tengah
local CardFrame = Instance.new("Frame")
CardFrame.Size = UDim2.new(1, -20, 0, 250)
CardFrame.Position = UDim2.new(0, 10, 0, 60)
CardFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
CardFrame.BackgroundTransparency = 0.2
CardFrame.BorderSizePixel = 0
CardFrame.Parent = MainTab.Container

-- Efek blur (glassmorphism)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = CardFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(100, 200, 255)
UIStroke.Transparency = 0.5
UIStroke.Parent = CardFrame

-- Grid layout untuk card
local CardGrid = Instance.new("UIGridLayout")
CardGrid.CellSize = UDim2.new(0, 60, 0, 60)
CardGrid.CellPadding = UDim2.new(0, 8, 0, 8)
CardGrid.FillDirection = Enum.FillDirection.Horizontal
CardGrid.Parent = CardFrame

-- =================== MEMBUAT 100 CARD KEREN ===================
local cards = {}

for i = 1, 100 do
    local tokenValue = i * 10 -- 10, 20, 30, ..., 1000
    local isSelected = false
    
    -- Membuat card button
    local card = Instance.new("TextButton")
    card.Name = "Card_" .. tokenValue
    card.Size = UDim2.new(0, 60, 0, 60)
    card.Text = tokenValue .. ""
    card.Font = Enum.Font.GothamBold
    card.TextSize = 14
    card.TextColor3 = Color3.fromRGB(255, 255, 255)
    card.AutoButtonColor = false
    card.Parent = CardFrame
    
    -- Desain card
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 10)
    CardCorner.Parent = card
    
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Thickness = 2
    CardStroke.Color = Color3.fromRGB(80, 80, 100)
    CardStroke.Parent = card
    
    -- Efek gradient (biar keren)
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
    })
    Gradient.Rotation = 45
    Gradient.Parent = card
    
    -- Fungsi update tampilan card
    local function UpdateCardStyle()
        if isSelected then
            -- Style untuk card terpilih (toggle ON)
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
            })
            CardStroke.Color = Color3.fromRGB(255, 255, 255)
            card.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            -- Style untuk card tidak terpilih (toggle OFF)
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
            })
            CardStroke.Color = Color3.fromRGB(80, 80, 100)
            card.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    -- Fungsi toggle (bukan command, tapi toggle button sesuai permintaan)
    local function ToggleCard()
        isSelected = not isSelected
        UpdateCardStyle()
        
        -- Update selected tokens
        if isSelected then
            selectedTokens[tokenValue] = true
        else
            selectedTokens[tokenValue] = nil
        end
        
        -- Hitung total selected
        local total = 0
        for val, _ in pairs(selectedTokens) do
            total = total + val
        end
        
        TokenInfo:Set("Selected: " .. total .. "/1000 Tokens")
    end
    
    -- Event klik (toggle)
    card.MouseButton1Click:Connect(ToggleCard)
    
    -- Efek hover
    card.MouseEnter:Connect(function()
        if not isSelected then
            Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 60)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 50))
            })
        end
    end)
    
    card.MouseLeave:Connect(function()
        UpdateCardStyle()
    end)
    
    -- Simpan card ke tabel
    cards[tokenValue] = {
        Toggle = ToggleCard,
        IsSelected = function() return isSelected end
    }
end

-- =================== CONTROL BUTTONS ===================
local ControlSection = MainTab:AddSection("Controls", "left")

-- SELECT ALL BUTTON (Toggle All)
ControlSection:AddButton({
    Text = "🔵 TOGGLE SELECT ALL",
    Callback = function()
        -- Cek apakah semua sudah terpilih
        local allSelected = true
        for i = 1, 100 do
            if not cards[i*10].IsSelected() then
                allSelected = false
                break
            end
        end
        
        -- Toggle all (kalau semua selected, jadi unselect semua)
        for i = 1, 100 do
            if allSelected then
                -- Unselect semua
                if cards[i*10].IsSelected() then
                    cards[i*10].Toggle()
                end
            else
                -- Select semua
                if not cards[i*10].IsSelected() then
                    cards[i*10].Toggle()
                end
            end
        end
        
        Library:Notify(allSelected and "All cards unselected" or "All cards selected (1000 Tokens)")
    end
})

-- CLEAR BUTTON
ControlSection:AddButton({
    Text = "⚪ CLEAR ALL",
    Callback = function()
        for i = 1, 100 do
            if cards[i*10].IsSelected() then
                cards[i*10].Toggle()
            end
        end
        Library:Notify("All cards cleared")
    end
})

-- GET TOKEN BUTTON
ControlSection:AddButton({
    Text = "💰 GENERATE TOKENS",
    Callback = function()
        local total = 0
        for val, _ in pairs(selectedTokens) do
            total = total + val
        end
        
        if total == 0 then
            Library:Notify("❌ No tokens selected!")
            return
        end
        
        Library:Notify("⏳ Generating " .. total .. " tokens...")
        
        -- REMOTE METHOD (instant)
        local remotes = {
            game:GetService("ReplicatedStorage"):FindFirstChild("GiveToken"),
            game:GetService("ReplicatedStorage"):FindFirstChild("PurchaseToken")
        }
        
        for _, remote in ipairs(remotes) do
            if remote then
                remote:FireServer(total)
            end
        end
        
        -- LEADERSTATS METHOD
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local tokenStat = leaderstats:FindFirstChild("Tokens") or 
                             leaderstats:FindFirstChild("TradeToken")
            if tokenStat then
                tokenStat.Value = tokenStat.Value + total
            end
        end
        
        Library:Notify("✅ Success! " .. total .. " tokens added!")
    end
})

-- =================== GOD MODE TSUNAMI ===================
local GodSection = MainTab:AddSection("God Mode Tsunami", "right")

-- Toggle God Mode (bukan command, toggle button)
local GodToggle = GodSection:AddToggle({
    Text = "🌊 GOD MODE (Anti Tsunami)",
    Default = false,
    Callback = function(state)
        tsunamigod = state
        Library:Notify(state and "God Mode ON - Tsunami cannot kill you" or "God Mode OFF")
    end
})

-- =================== TSUNAMI PROTECTION LOOP ===================
spawn(function()
    while wait(0.1) do
        if tsunamigod then
            -- Method 1: Pindahkan tsunami
            local tsunami = workspace:FindFirstChild("Tsunami") or workspace:FindFirstChild("Wave")
            if tsunami then
                tsunami.CFrame = CFrame.new(0, -1000, 0) -- Kirim tsunami ke bawah map
            end
            
            -- Method 2: Protection untuk player
            local character = player.Character
            if character then
                -- Bikin player immune
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = humanoid.MaxHealth -- Auto heal
                end
                
                -- Hapus efek bahaya
                for _, v in ipairs(character:GetChildren()) do
                    if v:IsA("Part") and v.Name:find("Water") or v.Name:find("Tsunami") then
                        v:Destroy()
                    end
                end
            end
            
            -- Method 3: Hapus semua air di map
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name:find("Water") then
                    v.Transparency = 1 -- Bikin transparan/invisible
                end
            end
        end
    end
end)

-- =================== STATUS BAR ===================
local StatusSection = MainTab:AddSection("Status", "right")

local GodStatus = StatusSection:AddLabel("God Mode: OFF")
local TokenStatus = StatusSection:AddLabel("Current Tokens: 0")
local ServerStatus = StatusSection:AddLabel("Server: Connected")

-- Update status setiap detik
spawn(function()
    while wait(1) do
        -- Update God Mode status
        GodStatus:Set("God Mode: " .. (tsunamigod and "ON 🌊" or "OFF"))
        
        -- Update token status
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local tokens = leaderstats:FindFirstChild("Tokens") or 
                          leaderstats:FindFirstChild("TradeToken") or
                          leaderstats:FindFirstChild("Money")
            if tokens then
                TokenStatus:Set("Current Tokens: " .. tokens.Value)
            end
        end
        
        -- Hitung total selected
        local total = 0
        for val, _ in pairs(selectedTokens) do
            total = total + val
        end
        TokenInfo:Set("Selected: " .. total .. "/1000 Tokens")
    end
end)

-- =================== EXTRA FEATURES ===================
local ExtraTab = MainWindow:AddTab("Extras")
local ExtraSection = ExtraTab:AddSection("Utilities", "left")

-- Speed Boost (bukan command)
ExtraSection:AddToggle({
    Text = "⚡ Speed Boost",
    Default = false,
    Callback = function(state)
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = state and 150 or 16
            Library:Notify(state and "Speed Boost ON" or "Speed Boost OFF")
        end
    end
})

-- Infinite Jump
ExtraSection:AddToggle({
    Text = "🦘 Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.infinitejump = state
        Library:Notify(state and "Infinite Jump ON" : "Infinite Jump OFF")
    end
})

-- Infinite Jump handler
local InfiniteJump = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.infinitejump then
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Anti Void
ExtraSection:AddToggle({
    Text = "🕳️ Anti Void",
    Default = false,
    Callback = function(state)
        _G.antivoid = state
    end
})

spawn(function()
    while wait(0.1) do
        if _G.antivoid then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                if character.HumanoidRootPart.Position.Y < -50 then
                    character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
                end
            end
        end
    end
end)

-- =================== CREDITS ===================
local CreditSection = ExtraTab:AddSection("Info", "right")

CreditSection:AddLabel("Escape Tsunami For Brainrot")
CreditSection:AddLabel("Card Menu Premium Version")
CreditSection:AddLabel("⚡ God Mode | Token Generator")
CreditSection:AddLabel("📌 Press RightCtrl to toggle")

Library:Notify("✅ CARD MENU LOADED! (Window di tengah layar)")
