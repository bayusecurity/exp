--[[
  ESCAPE TSUNAMI FOR BRAINROT - CARD MENU + DUPE + AUTO ACCEPT
  Fitur: Auto Accept Trade (bisa dimatikan/dinyalakan)
]]

-- Library Alternatif (LinoriaLib)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violinsss/GUI-Library/main/source.lua"))()
local Wait = Library.Wait

-- Variable utama
local player = game.Players.LocalPlayer
local tsunamigod = false
local selectedTokens = {}
local dupeActive = false
local autoAcceptActive = false  -- <-- VARIABLE BARU

-- =================== WINDOW UTAMA ===================
local MainWindow = Library:CreateWindow({
    Title = "⚡ TOKEN GEN + GOD MODE + DUPE",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- =================== TAB UTAMA (TOKEN) ===================
local MainTab = MainWindow:AddTab("Main")
local TokenSection = MainTab:AddLeftGroupbox("Trade Token Generator")

-- Token Info
local TokenInfo = TokenSection:AddLabel("Selected: 0/1000 Tokens")

-- Selector Manual
local amountInput = TokenSection:AddInput("Jumlah Token", {
    Default = "100",
    Type = "Number",
    Placeholder = "Masukkan jumlah (max 1000)"
})

-- SELECT ALL BUTTON
TokenSection:AddButton({
    Text = "Select 1000 Tokens",
    Func = function()
        selectedTokens = {["1000"] = true}
        TokenInfo:Set("Selected: 1000/1000 Tokens")
        Library:Notify("1000 tokens selected!")
    end
})

-- CLEAR BUTTON
TokenSection:AddButton({
    Text = "Clear Selection",
    Func = function()
        selectedTokens = {}
        TokenInfo:Set("Selected: 0/1000 Tokens")
        Library:Notify("Selection cleared")
    end
})

-- GET TOKEN BUTTON
TokenSection:AddButton({
    Text = "💰 GENERATE TOKENS",
    Func = function()
        local total = 0
        for val, _ in pairs(selectedTokens) do
            total = total + tonumber(val)
        end
        
        if total == 0 then
            total = tonumber(amountInput.Value) or 0
            if total <= 0 or total > 1000 then
                Library:Notify("❌ Masukkan jumlah 1-1000!")
                return
            end
        end
        
        Library:Notify("⏳ Generating " .. total .. " tokens...")
        
        -- REMOTE METHOD
        local remotes = {
            game:GetService("ReplicatedStorage"):FindFirstChild("GiveToken"),
            game:GetService("ReplicatedStorage"):FindFirstChild("PurchaseToken"),
            game:GetService("ReplicatedStorage"):FindFirstChild("ClaimToken")
        }
        
        for _, remote in ipairs(remotes) do
            if remote then
                pcall(function()
                    remote:FireServer(total)
                end)
            end
        end
        
        -- LEADERSTATS METHOD
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local tokenStat = leaderstats:FindFirstChild("Tokens") or 
                             leaderstats:FindFirstChild("TradeToken") or
                             leaderstats:FindFirstChild("Money")
            if tokenStat then
                tokenStat.Value = tokenStat.Value + total
            end
        end
        
        Library:Notify("✅ Success! " .. total .. " tokens added!")
    end
})

-- =================== TAB AUTO ACCEPT (BARU) ===================
local TradeTab = MainWindow:AddTab("Trade")
local TradeSection = TradeTab:AddLeftGroupbox("🤝 AUTO ACCEPT TRADE")

TradeSection:AddLabel("Fitur auto-accept trade request")
TradeSection:AddLabel("Bisa dimatikan/dinyalakan kapan saja")

-- TOGGLE AUTO ACCEPT (BISA DIMATIKAN!)
local AutoAcceptToggle = TradeSection:AddToggle("Auto Accept Trade", {
    Text = "✅ Auto Accept ON/OFF",
    Default = false,
    Callback = function(state)
        autoAcceptActive = state
        Library:Notify(state and "Auto Accept AKTIF - Akan auto-accept semua trade" or "Auto Accept NONAKTIF")
    end
})

-- Filter pemain (opsional)
local filterList = {}
local filterInput = TradeSection:AddInput("Filter Pemain (opsional)", {
    Default = "",
    Placeholder = "Nama pemain, pisahkan dengan koma"
})

TradeSection:AddButton({
    Text = "Terapkan Filter",
    Func = function()
        local input = filterInput.Value
        if input and input ~= "" then
            filterList = {}
            for name in string.gmatch(input, "([^,]+)") do
                table.insert(filterList, string.lower(name:match("^%s*(.-)%s*$")))
            end
            Library:Notify("Filter diterapkan: " .. #filterList .. " pemain")
        else
            filterList = {}
            Library:Notify("Filter dihapus (accept semua)")
        end
    end
})

TradeSection:AddLabel("Status:")
local AcceptStatus = TradeSection:AddLabel("Auto Accept: OFF")

-- =================== AUTO ACCEPT LOOP ===================
-- Fungsi untuk mengecek apakah pemain masuk filter
local function IsPlayerAllowed(playerName)
    if #filterList == 0 then
        return true -- Tidak ada filter, accept semua
    end
    
    local lowerName = string.lower(playerName)
    for _, allowed in ipairs(filterList) do
        if string.find(lowerName, allowed) then
            return true
        end
    end
    return false
end

-- Hook ke event trade request
local function SetupTradeDetection()
    -- Method 1: Remote spy untuk trade request
    local replicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Cari remote event yang berhubungan dengan trade
    local tradeRemotes = {
        replicatedStorage:FindFirstChild("TradeRequest"),
        replicatedStorage:FindFirstChild("TradeSystem"),
        replicatedStorage:FindFirstChild("TradeRemote"),
        replicatedStorage:FindFirstChild("AcceptTrade"),
        game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TradeGui")
    }
    
    for _, remote in ipairs(tradeRemotes) do
        if remote and remote:IsA("RemoteEvent") then
            -- Hook OnClientEvent
            remote.OnClientEvent:Connect(function(...)
                if autoAcceptActive then
                    local args = {...}
                    -- Detect siapa yang mengirim trade request
                    local trader = nil
                    for _, v in ipairs(args) do
                        if type(v) == "string" and game.Players:FindFirstChild(v) then
                            trader = v
                            break
                        elseif type(v) == "table" and v.Name then
                            trader = v.Name
                            break
                        end
                    end
                    
                    if trader then
                        if IsPlayerAllowed(trader) then
                            Library:Notify("✅ Auto Accept trade dari " .. trader)
                            -- Accept trade
                            pcall(function()
                                remote:FireServer("Accept", trader)
                                -- atau method lain tergantung sistem trade
                            end)
                        else
                            Library:Notify("⛔ Trade dari " .. trader .. " ditolak (filter)")
                        end
                    end
                end
            end)
        end
    end
end

-- Method 2: GUI Detection (jika trade pake GUI)
local function SetupGuiDetection()
    local playerGui = player:PlayerGui
    
    -- Tunggu sampai trade GUI muncul
    playerGui.ChildAdded:Connect(function(child)
        if autoAcceptActive and child.Name:find("Trade") or child.Name:find("Trading") then
            -- Cari tombol Accept di GUI
            wait(0.5) -- Tunggu GUI selesai loading
            local acceptButton = child:FindFirstChild("Accept", true) or 
                                child:FindFirstChild("AcceptButton", true) or
                                child:FindFirstChild("Yes", true)
            
            if acceptButton and acceptButton:IsA("TextButton") then
                -- Cek siapa pengirim (biasanya ada label nama)
                local senderLabel = child:FindFirstChild("Sender", true) or 
                                   child:FindFirstChild("From", true) or
                                   child:FindFirstChild("PlayerName", true)
                
                local senderName = ""
                if senderLabel and senderLabel:IsA("TextLabel") then
                    senderName = senderLabel.Text
                end
                
                if senderName == "" or IsPlayerAllowed(senderName) then
                    Library:Notify("✅ Auto Accept trade dari " .. (senderName ~= "" and senderName or "pemain"))
                    fireclickdetector(acceptButton)
                else
                    Library:Notify("⛔ Trade ditolak (filter)")
                    -- Cari tombol Decline/Close
                    local declineButton = child:FindFirstChild("Decline", true) or 
                                         child:FindFirstChild("No", true) or
                                         child:FindFirstChild("Close", true)
                    if declineButton then
                        fireclickdetector(declineButton)
                    end
                end
            end
        end
    end)
end

-- Method 3: Detect via Players service
local function SetupPlayerDetection()
    -- Cek ketika ada yang memulai trade dengan local player
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player then
            -- Coba cek apakah ada remote khusus untuk trade dengan player ini
            plr.ChildAdded:Connect(function(child)
                if autoAcceptActive and child.Name:find("TradeRequest") then
                    if IsPlayerAllowed(plr.Name) then
                        Library:Notify("✅ Auto Accept trade dari " .. plr.Name)
                        -- Accept logic
                        local remote = child:FindFirstChild("Accept")
                        if remote and remote:IsA("RemoteEvent") then
                            remote:FireServer()
                        end
                    else
                        Library:Notify("⛔ Trade dari " .. plr.Name .. " ditolak")
                    end
                end
            end)
        end
    end
    
    -- Untuk player yang join setelah script dijalankan
    game.Players.PlayerAdded:Connect(function(newPlr)
        newPlr.ChildAdded:Connect(function(child)
            if autoAcceptActive and child.Name:find("TradeRequest") then
                if IsPlayerAllowed(newPlr.Name) then
                    Library:Notify("✅ Auto Accept trade dari " .. newPlr.Name)
                    local remote = child:FindFirstChild("Accept")
                    if remote and remote:IsA("RemoteEvent") then
                        remote:FireServer()
                    end
                end
            end
        end)
    end)
end

-- Jalankan semua method detection
SetupTradeDetection()
SetupGuiDetection()
SetupPlayerDetection()

-- Update status setiap detik
spawn(function()
    while wait(1) do
        AcceptStatus:Set("Auto Accept: " .. (autoAcceptActive and "ON ✅" or "OFF ❌"))
        if #filterList > 0 then
            AcceptStatus:Set(AcceptStatus.Text .. " (Filter: " .. #filterList .. " pemain)")
        end
    end
end)

-- =================== TAB DUPE ===================
local DupeTab = MainWindow:AddTab("Dupe")
local DupeSection = DupeTab:AddLeftGroupbox("⚡ DUPE BRAINROTS")

DupeSection:AddLabel("Metode dupe untuk Brainrot")

-- Toggle Dupe Mode
local DupeToggle = DupeSection:AddToggle("Dupe Mode", {
    Text = "🔄 Aktifkan Dupe Mode",
    Default = false,
    Callback = function(state)
        dupeActive = state
        Library:Notify(state and "Dupe Mode ON" or "Dupe Mode OFF")
    end
})

-- Fungsi untuk mendapatkan daftar Brainrot
local function GetPlayerBrainrots()
    local items = {}
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:find("Brainrot") then
                table.insert(items, item.Name)
            end
        end
    end
    
    local base = player:FindFirstChild("Base") or player:FindFirstChild("Inventory")
    if base then
        for _, item in ipairs(base:GetChildren()) do
            if item.Name:find("Brainrot") then
                table.insert(items, item.Name)
            end
        end
    end
    
    return items
end

-- Dropdown untuk pilih item
local itemDropdown = DupeSection:AddDropdown("Pilih Brainrot", {
    Values = #GetPlayerBrainrots() > 0 and GetPlayerBrainrots() or {"Tidak ada Brainrot"},
    Default = 1,
    Multi = false,
    Text = "Pilih item"
})

-- Tombol Refresh
DupeSection:AddButton({
    Text = "🔄 Refresh Item List",
    Func = function()
        local newItems = GetPlayerBrainrots()
        if #newItems > 0 then
            itemDropdown:SetValues(newItems)
            Library:Notify("✅ Daftar item diperbarui!")
        else
            itemDropdown:SetValues({"Tidak ada Brainrot"})
            Library:Notify("❌ Tidak ada Brainrot ditemukan")
        end
    end
})

-- Method Dupe
DupeSection:AddButton({
    Text = "🔁 DUPE (Clone Method)",
    Func = function()
        if not dupeActive then
            Library:Notify("❌ Aktifkan Dupe Mode dulu!")
            return
        end
        
        local selectedItem = itemDropdown.Value
        if not selectedItem or selectedItem == "Tidak ada Brainrot" then
            Library:Notify("❌ Pilih item terlebih dahulu!")
            return
        end
        
        Library:Notify("⏳ Mendupe " .. selectedItem .. "...")
        
        local success = false
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name == selectedItem then
                    local clone = item:Clone()
                    clone.Parent = player.Backpack
                    Library:Notify("✅ Berhasil dupe! (Backpack)")
                    success = true
                    break
                end
            end
        end
        
        if not success then
            local base = player:FindFirstChild("Base") or player:FindFirstChild("Inventory")
            if base then
                for _, item in ipairs(base:GetChildren()) do
                    if item.Name == selectedItem then
                        local clone = item:Clone()
                        clone.Parent = base
                        Library:Notify("✅ Berhasil dupe! (Base)")
                        success = true
                        break
                    end
                end
            end
        end
        
        if not success then
            Library:Notify("❌ Gagal dupe! Item tidak ditemukan")
        end
    end
})

-- =================== GOD MODE TSUNAMI ===================
local GodSection = MainTab:AddRightGroupbox("God Mode Tsunami")

-- Toggle God Mode
local GodToggle = GodSection:AddToggle("God Mode", {
    Text = "🌊 Anti Tsunami",
    Default = false,
    Callback = function(state)
        tsunamigod = state
        Library:Notify(state and "God Mode ON - Tsunami cannot kill you" or "God Mode OFF")
    end
})

-- =================== TSUNAMI PROTECTION ===================
spawn(function()
    while wait(0.1) do
        if tsunamigod then
            local tsunami = workspace:FindFirstChild("Tsunami") or workspace:FindFirstChild("Wave")
            if tsunami then
                pcall(function()
                    tsunami.CFrame = CFrame.new(0, -1000, 0)
                end)
            end
            
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
            
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name:lower():find("water") then
                    pcall(function()
                        v.Transparency = 1
                    end)
                end
            end
        end
    end
end)

-- =================== STATUS ===================
local StatusSection = MainTab:AddRightGroupbox("Status")

local GodStatus = StatusSection:AddLabel("God Mode: OFF")
local DupeStatus = StatusSection:AddLabel("Dupe Mode: OFF")
local TradeStatus = StatusSection:AddLabel("Auto Accept: OFF")
local TokenStatus = StatusSection:AddLabel("Current Tokens: 0")

-- Update status
spawn(function()
    while wait(1) do
        GodStatus:Set("God Mode: " .. (tsunamigod and "ON 🌊" or "OFF"))
        DupeStatus:Set("Dupe Mode: " .. (dupeActive and "ON 🔄" or "OFF"))
        TradeStatus:Set("Auto Accept: " .. (autoAcceptActive and "ON ✅" or "OFF ❌"))
        
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local tokens = leaderstats:FindFirstChild("Tokens") or 
                          leaderstats:FindFirstChild("TradeToken") or
                          leaderstats:FindFirstChild("Money")
            if tokens then
                TokenStatus:Set("Current Tokens: " .. tokens.Value)
            end
        end
    end
end)

-- =================== EXTRA FEATURES ===================
local ExtraTab = MainWindow:AddTab("Extras")
local ExtraSection = ExtraTab:AddLeftGroupbox("Utilities")

-- Speed Boost
ExtraSection:AddToggle("Speed Boost", {
    Text = "⚡ Speed Boost",
    Default = false,
    Callback = function(state)
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = state and 150 or 16
        end
    end
})

-- Infinite Jump
ExtraSection:AddToggle("Infinite Jump", {
    Text = "🦘 Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.infinitejump = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.infinitejump then
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Anti Void
ExtraSection:AddToggle("Anti Void", {
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

-- Info
local CreditSection = ExtraTab:AddRightGroupbox("Info")
CreditSection:AddLabel("Escape Tsunami For Brainrot")
CreditSection:AddLabel("Card Menu + Dupe + Auto Accept")
CreditSection:AddLabel("📌 Tekan Insert untuk buka/tutup")
CreditSection:AddLabel("Auto Accept bisa dimatikan!")

Library:Notify("✅ Script + AUTO ACCEPT Loaded! Tekan Insert untuk buka GUI")
