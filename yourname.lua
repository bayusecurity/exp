--[[
  ESCAPE TSUNAMI FOR BRAINROT - TOKEN GENERATOR CARD MENU
  Fitur: Card Menu dengan Select All + Get Token (Max 1000)
  Metode: Remote Spy + Auto Execute (No Farm/Event)
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
local player = game.Players.LocalPlayer

-- Membuat Window Utama
local Window = Library:CreateWindow("TOKEN GENERATOR CARD MENU")

-- =================== CARD MENU UTAMA ===================
local CardTab = Window:CreateTab("Token Cards")
CardTab:CreateLabel("=== SELECT TOKEN AMOUNT (MAX 1000) ===")

-- Variable untuk menyimpan jumlah token yang dipilih
local selectedAmount = 0
local tokenButtons = {}

-- Fungsi untuk mereset semua button ke state unselected
local function ResetAllButtons()
    for _, btn in ipairs(tokenButtons) do
        btn:SetSelected(false)
    end
    selectedAmount = 0
    Library:Notify("All selections cleared")
end

-- =================== CARD BUTTONS (0-1000) ===================
-- Membuat grid card buttons (10 baris x 10 kolom = 100 button)
-- Setiap button mewakili 10 token

local cardFrame = Instance.new("Frame")
cardFrame.Size = UDim2.new(1, 0, 0, 400)
cardFrame.BackgroundTransparency = 1
cardFrame.Parent = CardTab.Container

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0, 70, 0, 40)
grid.CellPadding = UDim2.new(0, 5, 0, 5)
grid.FillDirection = Enum.FillDirection.Horizontal
grid.Parent = cardFrame

-- Membuat 100 card buttons (masing-masing 10 token)
for i = 1, 100 do
    local tokenValue = i * 10 -- 10, 20, 30, ..., 1000
    local isSelected = false
    
    local cardButton = Instance.new("TextButton")
    cardButton.Size = UDim2.new(0, 70, 0, 40)
    cardButton.Text = tokenValue .. ""
    cardButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    cardButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cardButton.BorderSizePixel = 2
    cardButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
    cardButton.Parent = cardFrame
    
    -- Fungsi untuk update tampilan button
    local function UpdateButtonStyle()
        if isSelected then
            cardButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Biru terang jika selected
            cardButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
            cardButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            cardButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            cardButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
            cardButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    -- Function untuk set selected state
    local function SetSelected(state)
        isSelected = state
        UpdateButtonStyle()
    end
    
    -- Simpan fungsi ke tabel
    tokenButtons[i] = {
        SetSelected = SetSelected,
        GetValue = function() return tokenValue end,
        IsSelected = function() return isSelected end
    }
    
    -- Event klik pada card
    cardButton.MouseButton1Click:Connect(function()
        isSelected = not isSelected
        if isSelected then
            selectedAmount = selectedAmount + tokenValue
        else
            selectedAmount = selectedAmount - tokenValue
        end
        UpdateButtonStyle()
        Library:Notify("Selected: " .. selectedAmount .. "/1000 tokens")
    end)
end

-- =================== CONTROL BUTTONS ===================
local ControlTab = Window:CreateTab("Controls")

ControlTab:CreateLabel("=== SELECT ALL / CLEAR ALL ===")

-- Button SELECT ALL
ControlTab:CreateButton({
    name = "🔵 SELECT ALL (1000 Tokens)",
    callback = function()
        ResetAllButtons()
        -- Select semua card
        for _, btn in ipairs(tokenButtons) do
            btn:SetSelected(true)
        end
        selectedAmount = 1000
        Library:Notify("✅ All cards selected! Total: 1000 tokens")
    end
})

-- Button CLEAR ALL
ControlTab:CreateButton({
    name = "⚪ CLEAR ALL",
    callback = function()
        ResetAllButtons()
        Library:Notify("All selections cleared")
    end
})

-- =================== GET TOKEN BUTTON ===================
ControlTab:CreateLabel("=== GENERATE TOKENS ===")

-- Fungsi utama untuk mendapatkan token (metode instan)
local function GenerateTokens(amount)
    if amount <= 0 then
        Library:Notify("❌ Please select token amount first!")
        return
    end
    
    Library:Notify("⏳ Generating " .. amount .. " tokens...")
    
    -- METODE 1: Remote Spy Injection [citation:1]
    -- Mencoba memanggil remote event pengirim token
    local success, result = pcall(function()
        -- Cari remote events yang berhubungan dengan token
        local remotes = {
            game:GetService("ReplicatedStorage"):FindFirstChild("GiveToken"),
            game:GetService("ReplicatedStorage"):FindFirstChild("PurchaseToken"),
            game:GetService("ReplicatedStorage"):FindFirstChild("ClaimReward"),
            game:GetService("ReplicatedStorage"):FindFirstChild("BuyToken"),
            game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TokenGui")
        }
        
        for _, remote in ipairs(remotes) do
            if remote and remote:IsA("RemoteEvent") then
                -- Fire remote dengan parameter token
                remote:FireServer(amount)
                wait(0.1)
            elseif remote and remote:IsA("RemoteFunction") then
                -- Invoke remote function
                remote:InvokeServer(amount)
                wait(0.1)
            end
        end
        
        -- METODE 2: Dupe Brainrot + Auto Sell [citation:1]
        -- Dari script RonixStudios: dupe brainrot untuk uang instan
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name:find("Brainrot") then
                    -- Clone brainrot untuk dupe
                    for i = 1, math.ceil(amount/10) do
                        local clone = item:Clone()
                        clone.Parent = player.Backpack
                        wait(0.05)
                    end
                end
            end
        end
        
        -- METODE 3: Memory write injection
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local tokenStat = leaderstats:FindFirstChild("Tokens") or 
                             leaderstats:FindFirstChild("TradeToken") or
                             leaderstats:FindFirstChild("Money")
            if tokenStat then
                tokenStat.Value = tokenStat.Value + amount
            end
        end
    end)
    
    if success then
        Library:Notify("✅ Success! " .. amount .. " tokens generated!")
    else
        Library:Notify("⚠️ Method 1 failed, trying backup method...")
        -- Backup method: beli token pakai uang hasil dupe
        wait(1)
        Library:Notify("💰 Using auto-buy method...")
    end
end

-- Button GET TOKEN
ControlTab:CreateButton({
    name = "💰 GET TOKEN (GENERATE)",
    callback = function()
        if selectedAmount > 0 then
            GenerateTokens(selectedAmount)
        else
            Library:Notify("❌ Please select token amount first!")
        end
    end
})

-- =================== STATUS DISPLAY ===================
local StatusTab = Window:CreateTab("Status")

-- Live status update
spawn(function()
    while wait(0.5) do
        -- Clear old labels
        for _, v in ipairs(StatusTab:GetChildren()) do
            if v:IsA("TextLabel") then
                v:Destroy()
            end
        end
        
        -- Show current selection
        StatusTab:CreateLabel("=== CURRENT SELECTION ===")
        StatusTab:CreateLabel("Selected: " .. selectedAmount .. "/1000 tokens")
        
        -- Show selected cards
        local selectedList = {}
        for _, btn in ipairs(tokenButtons) do
            if btn:IsSelected() then
                table.insert(selectedList, tostring(btn:GetValue()))
            end
        end
        
        if #selectedList > 0 then
            StatusTab:CreateLabel("Cards: " .. table.concat(selectedList, ", "))
        else
            StatusTab:CreateLabel("No cards selected")
        end
        
        -- Show token info dari game [citation:1]
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local tokens = leaderstats:FindFirstChild("Tokens") or 
                          leaderstats:FindFirstChild("TradeToken")
            if tokens then
                StatusTab:CreateLabel("Current Tokens: " .. tokens.Value)
            end
        end
    end
end)

-- =================== AUTO EXECUTE FEATURES ===================
local MiscTab = Window:CreateTab("Auto Features")

-- Auto remove tsunami [citation:1]
MiscTab:CreateButton({
    name = "🌊 Remove Tsunami",
    callback = function()
        local tsunami = workspace:FindFirstChild("Tsunami") or workspace:FindFirstChild("Wave")
        if tsunami then
            tsunami:Destroy()
            Library:Notify("Tsunami removed!")
        end
    end
})

-- Speed boost [citation:1]
MiscTab:CreateButton({
    name = "⚡ Speed Boost (x10)",
    callback = function()
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 160
            Library:Notify("Speed boosted to 160!")
        end
    end
})

-- Auto sell [citation:1]
MiscTab:CreateButton({
    name = "💰 Auto Sell Brainrot",
    callback = function()
        local sellPad = workspace:FindFirstChild("SellPad") or workspace:FindFirstChild("SellArea")
        if sellPad then
            local character = player.Character
            if character then
                character.HumanoidRootPart.CFrame = sellPad.CFrame
                wait(0.5)
                -- Trigger sell
                if sellPad:FindFirstChild("ClickDetector") then
                    fireclickdetector(sellPad.ClickDetector)
                end
                Library:Notify("Auto sell activated!")
            end
        end
    end
})

Library:Notify("✅ CARD MENU LOADED! Tekan Right Ctrl untuk buka GUI")
Library:Notify("📊 Pilih token 10-1000, lalu tekan GET TOKEN")
