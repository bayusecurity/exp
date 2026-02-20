-- Import necessary modules
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Define brainrot types and their multipliers (SUPER OP)
local brainrotTypes = {
    Common = 100,
    Uncommon = 500,
    Rare = 1000,
    Epic = 5000,
    Legendary = 10000,
    Mythic = 50000,
    Rahasia = 100000,
    Ilahi = 500000,
    Divine = 1000000,
    Infinity = 10000000
}

-- Variables
local player = Players.LocalPlayer
local brainrotAmount = 0
local tokenAmount = 0
local autoGenerate = false
local autoToken = false
local connection = nil

-- Create Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "EscapeTsunamiGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Background with blur effect
local background = Instance.new("Frame")
background.Name = "Background"
background.Parent = gui
background.Size = UDim2.new(0, 400, 0, 500)
background.Position = UDim2.new(0.5, -200, 0.5, -250)
background.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
background.BackgroundTransparency = 0.1
background.BorderSizePixel = 0
background.Active = true
background.Draggable = true

-- Add shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Parent = background
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ZIndex = -1

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = background
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = titleBar
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ JEMBOT ESCAPE TSUNAMI ⚡"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = titleBar
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.BorderSizePixel = 0

local minimized = false
local originalSize = background.Size
local originalContent = {}

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        background.Size = UDim2.new(0, 400, 0, 35)
        for _, v in pairs(background:GetChildren()) do
            if v.Name ~= "TitleBar" and v.Name ~= "Shadow" then
                v.Visible = false
                table.insert(originalContent, v)
            end
        end
        minimizeButton.Text = "□"
    else
        background.Size = originalSize
        for _, v in pairs(originalContent) do
            v.Visible = true
        end
        originalContent = {}
        minimizeButton.Text = "-"
    end
end)

-- Main Content
local content = Instance.new("Frame")
content.Name = "Content"
content.Parent = background
content.Size = UDim2.new(1, -20, 1, -45)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1

-- Tab Buttons
local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Parent = content
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.BackgroundTransparency = 1

local brainrotTab = Instance.new("TextButton")
brainrotTab.Name = "BrainrotTab"
brainrotTab.Parent = tabFrame
brainrotTab.Size = UDim2.new(0.5, -5, 1, 0)
brainrotTab.Position = UDim2.new(0, 0, 0, 0)
brainrotTab.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
brainrotTab.Text = "BRAINROT"
brainrotTab.TextColor3 = Color3.fromRGB(255, 255, 255)
brainrotTab.TextSize = 14
brainrotTab.Font = Enum.Font.GothamBold
brainrotTab.BorderSizePixel = 0

local tokenTab = Instance.new("TextButton")
tokenTab.Name = "TokenTab"
tokenTab.Parent = tabFrame
tokenTab.Size = UDim2.new(0.5, -5, 1, 0)
tokenTab.Position = UDim2.new(0.5, 5, 0, 0)
tokenTab.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
tokenTab.Text = "TOKEN"
tokenTab.TextColor3 = Color3.fromRGB(255, 255, 255)
tokenTab.TextSize = 14
tokenTab.Font = Enum.Font.GothamBold
tokenTab.BorderSizePixel = 0

-- Brainrot Panel
local brainrotPanel = Instance.new("ScrollingFrame")
brainrotPanel.Name = "BrainrotPanel"
brainrotPanel.Parent = content
brainrotPanel.Size = UDim2.new(1, 0, 1, -40)
brainrotPanel.Position = UDim2.new(0, 0, 0, 40)
brainrotPanel.BackgroundTransparency = 1
brainrotPanel.ScrollBarThickness = 5
brainrotPanel.CanvasSize = UDim2.new(0, 0, 0, 350)
brainrotPanel.Visible = true

-- Token Panel
local tokenPanel = Instance.new("ScrollingFrame")
tokenPanel.Name = "TokenPanel"
tokenPanel.Parent = content
tokenPanel.Size = UDim2.new(1, 0, 1, -40)
tokenPanel.Position = UDim2.new(0, 0, 0, 40)
tokenPanel.BackgroundTransparency = 1
tokenPanel.ScrollBarThickness = 5
tokenPanel.CanvasSize = UDim2.new(0, 0, 0, 250)
tokenPanel.Visible = false

-- Tab switching
brainrotTab.MouseButton1Click:Connect(function()
    brainrotPanel.Visible = true
    tokenPanel.Visible = false
    brainrotTab.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    tokenTab.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

tokenTab.MouseButton1Click:Connect(function()
    brainrotPanel.Visible = false
    tokenPanel.Visible = true
    brainrotTab.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    tokenTab.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
end)

-- BRAINROT PANEL CONTENT
-- Title
local brainrotTitle = Instance.new("TextLabel")
brainrotTitle.Name = "BrainrotTitle"
brainrotTitle.Parent = brainrotPanel
brainrotTitle.Size = UDim2.new(1, -20, 0, 30)
brainrotTitle.Position = UDim2.new(0, 10, 0, 10)
brainrotTitle.BackgroundTransparency = 1
brainrotTitle.Text = "BRAINROT GENERATOR"
brainrotTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
brainrotTitle.TextSize = 18
brainrotTitle.Font = Enum.Font.GothamBold

-- Dropdown Label
local dropdownLabel = Instance.new("TextLabel")
dropdownLabel.Name = "DropdownLabel"
dropdownLabel.Parent = brainrotPanel
dropdownLabel.Size = UDim2.new(1, -20, 0, 20)
dropdownLabel.Position = UDim2.new(0, 10, 0, 50)
dropdownLabel.BackgroundTransparency = 1
dropdownLabel.Text = "Pilih Type Brainrot:"
dropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
dropdownLabel.TextSize = 14
dropdownLabel.Font = Enum.Font.Gotham
dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Dropdown Frame
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Name = "DropdownFrame"
dropdownFrame.Parent = brainrotPanel
dropdownFrame.Size = UDim2.new(1, -20, 0, 35)
dropdownFrame.Position = UDim2.new(0, 10, 0, 75)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
dropdownFrame.BorderSizePixel = 0

local dropdownButton = Instance.new("TextButton")
dropdownButton.Name = "DropdownButton"
dropdownButton.Parent = dropdownFrame
dropdownButton.Size = UDim2.new(1, 0, 1, 0)
dropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
dropdownButton.Text = "Pilih Type ▼"
dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownButton.TextSize = 14
dropdownButton.Font = Enum.Font.Gotham

local dropdownList = Instance.new("ScrollingFrame")
dropdownList.Name = "DropdownList"
dropdownList.Parent = dropdownFrame
dropdownList.Size = UDim2.new(1, 0, 0, 200)
dropdownList.Position = UDim2.new(0, 0, 1, 5)
dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
dropdownList.BorderSizePixel = 0
dropdownList.Visible = false
dropdownList.ZIndex = 10
dropdownList.CanvasSize = UDim2.new(0, 0, 0, #brainrotTypes * 30)

local selectedType = "Infinity"

-- Populate dropdown
local yPos = 0
for typeName, multiplier in pairs(brainrotTypes) do
    local option = Instance.new("TextButton")
    option.Name = typeName
    option.Parent = dropdownList
    option.Size = UDim2.new(1, 0, 0, 30)
    option.Position = UDim2.new(0, 0, 0, yPos)
    option.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    option.Text = typeName .. " (x" .. tostring(multiplier) .. ")"
    option.TextColor3 = Color3.fromRGB(255, 255, 255)
    option.TextSize = 12
    option.Font = Enum.Font.Gotham
    option.BorderSizePixel = 0
    option.ZIndex = 11
    
    option.MouseButton1Click:Connect(function()
        selectedType = typeName
        dropdownButton.Text = typeName .. " ▼"
        dropdownList.Visible = false
    end)
    
    option.MouseEnter:Connect(function()
        option.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    end)
    
    option.MouseLeave:Connect(function()
        option.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end)
    
    yPos = yPos + 30
end

dropdownButton.MouseButton1Click:Connect(function()
    dropdownList.Visible = not dropdownList.Visible
end)

-- Auto Generate Toggle
local autoGenFrame = Instance.new("Frame")
autoGenFrame.Name = "AutoGenFrame"
autoGenFrame.Parent = brainrotPanel
autoGenFrame.Size = UDim2.new(1, -20, 0, 40)
autoGenFrame.Position = UDim2.new(0, 10, 0, 130)
autoGenFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
autoGenFrame.BorderSizePixel = 0

local autoGenLabel = Instance.new("TextLabel")
autoGenLabel.Name = "AutoGenLabel"
autoGenLabel.Parent = autoGenFrame
autoGenLabel.Size = UDim2.new(0.7, -10, 1, 0)
autoGenLabel.Position = UDim2.new(0, 10, 0, 0)
autoGenLabel.BackgroundTransparency = 1
autoGenLabel.Text = "Auto Generate Brainrot"
autoGenLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGenLabel.TextSize = 14
autoGenLabel.Font = Enum.Font.Gotham
autoGenLabel.TextXAlignment = Enum.TextXAlignment.Left

local autoGenToggle = Instance.new("TextButton")
autoGenToggle.Name = "AutoGenToggle"
autoGenToggle.Parent = autoGenFrame
autoGenToggle.Size = UDim2.new(0, 50, 0, 30)
autoGenToggle.Position = UDim2.new(1, -60, 0, 5)
autoGenToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
autoGenToggle.Text = "OFF"
autoGenToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGenToggle.TextSize = 12
autoGenToggle.Font = Enum.Font.GothamBold
autoGenToggle.BorderSizePixel = 0

-- Generate Button
local generateButton = Instance.new("TextButton")
generateButton.Name = "GenerateButton"
generateButton.Parent = brainrotPanel
generateButton.Size = UDim2.new(1, -20, 0, 45)
generateButton.Position = UDim2.new(0, 10, 0, 190)
generateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
generateButton.Text = "GENERATE BRAINROT"
generateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
generateButton.TextSize = 16
generateButton.Font = Enum.Font.GothamBold
generateButton.BorderSizePixel = 0

-- Display
local brainrotDisplay = Instance.new("TextLabel")
brainrotDisplay.Name = "BrainrotDisplay"
brainrotDisplay.Parent = brainrotPanel
brainrotDisplay.Size = UDim2.new(1, -20, 0, 60)
brainrotDisplay.Position = UDim2.new(0, 10, 0, 250)
brainrotDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
brainrotDisplay.BorderSizePixel = 0
brainrotDisplay.Text = "BRAINROT: 0"
brainrotDisplay.TextColor3 = Color3.fromRGB(50, 255, 50)
brainrotDisplay.TextSize = 24
brainrotDisplay.Font = Enum.Font.GothamBold

-- TOKEN PANEL CONTENT
-- Title
local tokenTitle = Instance.new("TextLabel")
tokenTitle.Name = "TokenTitle"
tokenTitle.Parent = tokenPanel
tokenTitle.Size = UDim2.new(1, -20, 0, 30)
tokenTitle.Position = UDim2.new(0, 10, 0, 10)
tokenTitle.BackgroundTransparency = 1
tokenTitle.Text = "TOKEN GENERATOR"
tokenTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
tokenTitle.TextSize = 18
tokenTitle.Font = Enum.Font.GothamBold

-- Input Label
local inputLabel = Instance.new("TextLabel")
inputLabel.Name = "InputLabel"
inputLabel.Parent = tokenPanel
inputLabel.Size = UDim2.new(1, -20, 0, 20)
inputLabel.Position = UDim2.new(0, 10, 0, 50)
inputLabel.BackgroundTransparency = 1
inputLabel.Text = "Jumlah Token (1 - 10.000):"
inputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
inputLabel.TextSize = 14
inputLabel.Font = Enum.Font.Gotham
inputLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Input Box
local tokenInput = Instance.new("TextBox")
tokenInput.Name = "TokenInput"
tokenInput.Parent = tokenPanel
tokenInput.Size = UDim2.new(1, -20, 0, 40)
tokenInput.Position = UDim2.new(0, 10, 0, 75)
tokenInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
tokenInput.BorderSizePixel = 0
tokenInput.Text = "1000"
tokenInput.TextColor3 = Color3.fromRGB(255, 255, 255)
tokenInput.TextSize = 16
tokenInput.Font = Enum.Font.Gotham
tokenInput.PlaceholderText = "Masukkan angka 1-10000"
tokenInput.ClearTextOnFocus = false

-- Quick amount buttons
local quickFrame = Instance.new("Frame")
quickFrame.Name = "QuickFrame"
quickFrame.Parent = tokenPanel
quickFrame.Size = UDim2.new(1, -20, 0, 40)
quickFrame.Position = UDim2.new(0, 10, 0, 125)
quickFrame.BackgroundTransparency = 1

local quickButtons = {100, 500, 1000, 5000, 10000}
local xPos = 0
for i, amount in ipairs(quickButtons) do
    local btn = Instance.new("TextButton")
    btn.Name = "Quick" .. amount
    btn.Parent = quickFrame
    btn.Size = UDim2.new(0.18, 0, 1, -10)
    btn.Position = UDim2.new(0, xPos, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    btn.Text = tostring(amount)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    btn.MouseButton1Click:Connect(function()
        tokenInput.Text = tostring(amount)
    end)
    
    xPos = xPos + (0.18 * 400) + 5
end

-- Auto Token Toggle
local autoTokenFrame = Instance.new("Frame")
autoTokenFrame.Name = "AutoTokenFrame"
autoTokenFrame.Parent = tokenPanel
autoTokenFrame.Size = UDim2.new(1, -20, 0, 40)
autoTokenFrame.Position = UDim2.new(0, 10, 0, 175)
autoTokenFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
autoTokenFrame.BorderSizePixel = 0

local autoTokenLabel = Instance.new("TextLabel")
autoTokenLabel.Name = "AutoTokenLabel"
autoTokenLabel.Parent = autoTokenFrame
autoTokenLabel.Size = UDim2.new(0.7, -10, 1, 0)
autoTokenLabel.Position = UDim2.new(0, 10, 0, 0)
autoTokenLabel.BackgroundTransparency = 1
autoTokenLabel.Text = "Auto Generate Token"
autoTokenLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoTokenLabel.TextSize = 14
autoTokenLabel.Font = Enum.Font.Gotham
autoTokenLabel.TextXAlignment = Enum.TextXAlignment.Left

local autoTokenToggle = Instance.new("TextButton")
autoTokenToggle.Name = "AutoTokenToggle"
autoTokenToggle.Parent = autoTokenFrame
autoTokenToggle.Size = UDim2.new(0, 50, 0, 30)
autoTokenToggle.Position = UDim2.new(1, -60, 0, 5)
autoTokenToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
autoTokenToggle.Text = "OFF"
autoTokenToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoTokenToggle.TextSize = 12
autoTokenToggle.Font = Enum.Font.GothamBold
autoTokenToggle.BorderSizePixel = 0

-- Generate Token Button
local generateTokenBtn = Instance.new("TextButton")
generateTokenBtn.Name = "GenerateTokenBtn"
generateTokenBtn.Parent = tokenPanel
generateTokenBtn.Size = UDim2.new(1, -20, 0, 45)
generateTokenBtn.Position = UDim2.new(0, 10, 0, 235)
generateTokenBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
generateTokenBtn.Text = "GENERATE TOKEN"
generateTokenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
generateTokenBtn.TextSize = 16
generateTokenBtn.Font = Enum.Font.GothamBold
generateTokenBtn.BorderSizePixel = 0

-- Token Display
local tokenDisplay = Instance.new("TextLabel")
tokenDisplay.Name = "TokenDisplay"
tokenDisplay.Parent = tokenPanel
tokenDisplay.Size = UDim2.new(1, -20, 0, 60)
tokenDisplay.Position = UDim2.new(0, 10, 0, 295)
tokenDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tokenDisplay.BorderSizePixel = 0
tokenDisplay.Text = "TOKEN: 0"
tokenDisplay.TextColor3 = Color3.fromRGB(255, 255, 50)
tokenDisplay.TextSize = 24
tokenDisplay.Font = Enum.Font.GodthBold

-- FUNCTIONS
local function generateBrainrot()
    local multiplier = brainrotTypes[selectedType] or 1
    brainrotAmount = brainrotAmount + multiplier
    brainrotDisplay.Text = "BRAINROT: " .. tostring(brainrotAmount)
    
    -- Animasi
    generateButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    wait(0.1)
    generateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
end

local function generateToken(amount)
    local input = amount or tonumber(tokenInput.Text)
    if input and input >= 1 and input <= 10000 then
        tokenAmount = tokenAmount + input
        tokenDisplay.Text = "TOKEN: " .. tostring(tokenAmount)
        
        -- Animasi
        generateTokenBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        wait(0.1)
        generateTokenBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        tokenInput.Text = "1000"
        warn("Invalid token amount, using default 1000")
    end
end

-- Auto generate logic
autoGenToggle.MouseButton1Click:Connect(function()
    autoGenerate = not autoGenerate
    if autoGenerate then
        autoGenToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        autoGenToggle.Text = "ON"
        
        -- Start auto generate loop
        spawn(function()
            while autoGenerate do
                generateBrainrot()
                wait(0.1) -- Super fast generation
            end
        end)
    else
        autoGenToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        autoGenToggle.Text = "OFF"
    end
end)

autoTokenToggle.MouseButton1Click:Connect(function()
    autoToken = not autoToken
    if autoToken then
        autoTokenToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        autoTokenToggle.Text = "ON"
        
        -- Start auto token loop
        spawn(function()
            while autoToken do
                generateToken(1000) -- Generate 1000 token setiap kali
                wait(1)
            end
        end)
    else
        autoTokenToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        autoTokenToggle.Text = "OFF"
    end
end)

-- Manual generate
generateButton.MouseButton1Click:Connect(generateBrainrot)
generateTokenBtn.MouseButton1Click:Connect(function()
    generateToken()
end)

-- Anti-AFK
local function antiAfk()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end
antiAfk()

-- Save/Load data (simulated)
local function saveData()
    -- Simpan ke server (jika memungkinkan)
end

-- Notifikasi
local function notify(msg)
    local notification = Instance.new("TextLabel")
    notification.Parent = gui
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(0.5, -150, 0, 20)
    notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notification.BackgroundTransparency = 0.5
    notification.Text = msg
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextSize = 14
    notification.Font = Enum.Font.GothamBold
    notification.BorderSizePixel = 0
    
    -- Animasi fade out
    wait(2)
    for i = 0, 1, 0.1 do
        notification.BackgroundTransparency = i
        notification.TextTransparency = i
        wait(0.05)
    end
    notification:Destroy()
end

-- Welcome message
notify("✅ Jembot Escape Tsunami Loaded! ✅")

-- Anti-cheat bypass (simulasi)
local function antiCheatBypass()
    -- Ini hanya simulasi, untuk game asli perlu metode yang lebih kompleks
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "FireServer" and tostring(args[1]) == "AntiCheat" then
            return nil
        end
        return old(...)
    end)
    setreadonly(mt, true)
end

-- Unload function
local function unload()
    if connection then
        connection:Disconnect()
    end
    gui:Destroy()
end

-- Close handling
player.OnTeleport:Connect(unload)

print("✅ Script Jembot Escape Tsunami berhasil dimuat!")
print("⚡ Fitur: Brainrot Generator (Common s/d Infinity) + Token Generator (1-10000)")
