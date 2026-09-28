--[[
    ═══════════════════════════════════════════════════════════════
    📋 YUSZX IDE v4 — Resizable + Animated Border
    ═══════════════════════════════════════════════════════════════
    ✅ Universal
    ✅ Animated border glow (muter pelangi)
    ✅ Resize handle di pojok kanan bawah
    ✅ Minimize (−) & Close (✕)
    ✅ Copy output ke clipboard
    ═══════════════════════════════════════════════════════════════
]]

-- ============================================
-- UNIVERSAL HELPER
-- ============================================
local function getSafeParent()
    local parents = {}
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then table.insert(parents, hui) end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then table.insert(parents, cg) end
    local plr = game:GetService("Players").LocalPlayer
    if plr then
        local pg = plr:FindFirstChild("PlayerGui")
        if pg then table.insert(parents, pg) end
    end
    for _, p in ipairs(parents) do
        local test = Instance.new("ScreenGui")
        local success = pcall(function() test.Parent = p end)
        if success and test.Parent then
            test:Destroy()
            return p
        end
        pcall(function() test:Destroy() end)
    end
    return nil
end

local uiParent = getSafeParent()
if not uiParent then
    warn("[Yuszx] Gak bisa dapet UI parent!")
    return
end

-- ============================================
-- SERVICES & CONFIG
-- ============================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local MIN_WIDTH = 320
local MIN_HEIGHT = 280
local MAX_WIDTH = 900
local MAX_HEIGHT = 800

-- ============================================
-- LOG STORAGE
-- ============================================
local logs = {}
local MAX_LINES = 500

local function addLog(level, ...)
    local args = {...}
    local parts = {}
    for i, v in ipairs(args) do parts[i] = tostring(v) end
    local msg = table.concat(parts, " ")
    local ts = os.date("%H:%M:%S")
    table.insert(logs, "[" .. ts .. "] [" .. level .. "] " .. msg)
    if #logs > MAX_LINES then table.remove(logs, 1) end
end

-- ============================================
-- UI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuszxIDE_" .. tostring(math.random(1000,9999))
ScreenGui.Parent = uiParent
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 620)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -310)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- ========== ANIMATED BORDER GLOW ==========
local BorderStroke = Instance.new("UIStroke")
BorderStroke.Color = Color3.fromRGB(0, 200, 255)
BorderStroke.Thickness = 2.5
BorderStroke.Transparency = 0
BorderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BorderStroke.Parent = MainFrame

local BorderGradient = Instance.new("UIGradient")
BorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.20, Color3.fromRGB(150, 50, 255)),
    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(255, 50, 150)),
    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(255, 200, 50)),
    ColorSequenceKeypoint.new(0.80, Color3.fromRGB(50, 255, 150)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 200, 255)),
})
BorderGradient.Rotation = 0
BorderGradient.Parent = BorderStroke

task.spawn(function()
    while MainFrame.Parent and BorderStroke.Parent do
        for i = 0, 360, 10 do
            if not MainFrame.Parent or not BorderStroke.Parent then break end
            pcall(function() BorderGradient.Rotation = i end)
            task.wait(0.03)
        end
    end
end)

-- Glow layer
local GlowStroke = Instance.new("UIStroke")
GlowStroke.Color = Color3.fromRGB(0, 200, 255)
GlowStroke.Thickness = 6
GlowStroke.Transparency = 0.75
GlowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GlowStroke.Parent = MainFrame

local GlowGradient = Instance.new("UIGradient")
GlowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(150, 50, 255)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 50, 150)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 200, 255)),
})
GlowGradient.Rotation = 0
GlowGradient.Parent = GlowStroke

task.spawn(function()
    while MainFrame.Parent and GlowStroke.Parent do
        for i = 360, 0, -10 do
            if not MainFrame.Parent or not GlowStroke.Parent then break end
            pcall(function() GlowGradient.Rotation = i end)
            task.wait(0.03)
        end
    end
end)

-- ============================================
-- HEADER
-- ============================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "📋 Yuszx IDE"
Title.TextColor3 = Color3.fromRGB(200, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Title pulse
task.spawn(function()
    while Title.Parent do
        task.wait(0.05)
        pcall(function()
            local t = tick() * 2
            local r = (math.sin(t) + 1) / 2
            local g = (math.sin(t + 2) + 1) / 2
            local b = (math.sin(t + 4) + 1) / 2
            Title.TextColor3 = Color3.new(0.6 + r * 0.4, 0.7 + g * 0.3, 0.9 + b * 0.1)
        end)
    end
end)

-- Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -76, 0, 6)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(150, 200, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.BorderSizePixel = 0
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- ============================================
-- CONTENT (pakai Scale biar auto-adjust)
-- ============================================
-- Input label — 8% dari atas
local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(1, -20, 0, 20)
InputLabel.Position = UDim2.new(0, 10, 0, 54)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "▶ CODE EDITOR"
InputLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
InputLabel.Font = Enum.Font.GothamBold
InputLabel.TextSize = 11
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = MainFrame

-- InputFrame — dari y=76 sampai 50% tinggi
local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(1, -20, 0.35, -20)
InputFrame.Position = UDim2.new(0, 10, 0, 76)
InputFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
InputFrame.BorderSizePixel = 0
InputFrame.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputFrame

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(0, 100, 150)
InputStroke.Thickness = 1
InputStroke.Parent = InputFrame

local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(1, -16, 1, -16)
CodeBox.Position = UDim2.new(0, 8, 0, 8)
CodeBox.BackgroundTransparency = 1
CodeBox.Text = ""
CodeBox.PlaceholderText = "-- Paste kode debug di sini...\n-- Terus klik ▶ RUN"
CodeBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
CodeBox.TextColor3 = Color3.fromRGB(200, 255, 200)
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 12
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.TextWrapped = true
CodeBox.ClearTextOnFocus = false
CodeBox.MultiLine = true
CodeBox.Parent = InputFrame

-- Buttons — di 47% tinggi
local BtnFrame = Instance.new("Frame")
BtnFrame.Size = UDim2.new(1, -20, 0, 40)
BtnFrame.Position = UDim2.new(0, 10, 0.47, 0)
BtnFrame.BackgroundTransparency = 1
BtnFrame.Parent = MainFrame

local BtnLayout = Instance.new("UIListLayout")
BtnLayout.FillDirection = Enum.FillDirection.Horizontal
BtnLayout.Padding = UDim.new(0, 5)
BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
BtnLayout.Parent = BtnFrame

local function makeBtn(text, width, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 0, 36)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 60, 100)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = BtnFrame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Output label — di 57% tinggi
local OutputLabel = Instance.new("TextLabel")
OutputLabel.Size = UDim2.new(1, -20, 0, 20)
OutputLabel.Position = UDim2.new(0, 10, 0.57, 0)
OutputLabel.BackgroundTransparency = 1
OutputLabel.Text = "▼ OUTPUT"
OutputLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
OutputLabel.Font = Enum.Font.GothamBold
OutputLabel.TextSize = 11
OutputLabel.TextXAlignment = Enum.TextXAlignment.Left
OutputLabel.Parent = MainFrame

-- OutputFrame — dari 61% sampai bawah
local OutputFrame = Instance.new("ScrollingFrame")
OutputFrame.Size = UDim2.new(1, -20, 0.37, -20)
OutputFrame.Position = UDim2.new(0, 10, 0.61, 0)
OutputFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
OutputFrame.BorderSizePixel = 0
OutputFrame.ScrollBarThickness = 4
OutputFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
OutputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
OutputFrame.Parent = MainFrame

local OutputCorner = Instance.new("UICorner")
OutputCorner.CornerRadius = UDim.new(0, 8)
OutputCorner.Parent = OutputFrame

local OutputStroke = Instance.new("UIStroke")
OutputStroke.Color = Color3.fromRGB(0, 100, 50)
OutputStroke.Thickness = 1
OutputStroke.Parent = OutputFrame

local OutputPadding = Instance.new("UIPadding")
OutputPadding.PaddingTop = UDim.new(0, 6)
OutputPadding.PaddingLeft = UDim.new(0, 8)
OutputPadding.PaddingRight = UDim.new(0, 8)
OutputPadding.PaddingBottom = UDim.new(0, 6)
OutputPadding.Parent = OutputFrame

local OutputText = Instance.new("TextLabel")
OutputText.Size = UDim2.new(1, 0, 0, 0)
OutputText.BackgroundTransparency = 1
OutputText.Text = ""
OutputText.TextColor3 = Color3.fromRGB(180, 255, 180)
OutputText.Font = Enum.Font.Code
OutputText.TextSize = 11
OutputText.TextXAlignment = Enum.TextXAlignment.Left
OutputText.TextYAlignment = Enum.TextYAlignment.Top
OutputText.TextWrapped = true
OutputText.Parent = OutputFrame

-- ============================================
-- RESIZE HANDLE (Pojok Kanan Bawah)
-- ============================================
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 22, 0, 22)
ResizeHandle.Position = UDim2.new(1, -24, 1, -24)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ResizeHandle.BackgroundTransparency = 0.5
ResizeHandle.Text = "◢"
ResizeHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
ResizeHandle.TextSize = 16
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.BorderSizePixel = 0
ResizeHandle.AutoButtonColor = false
ResizeHandle.ZIndex = 10
ResizeHandle.Parent = MainFrame

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 6)
ResizeCorner.Parent = ResizeHandle

-- Hover effect
ResizeHandle.MouseEnter:Connect(function()
    ResizeHandle.BackgroundTransparency = 0.2
    ResizeHandle.TextColor3 = Color3.fromRGB(0, 255, 200)
end)
ResizeHandle.MouseLeave:Connect(function()
    if not ResizeHandle:GetAttribute("Dragging") then
        ResizeHandle.BackgroundTransparency = 0.5
        ResizeHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- ============================================
-- RESIZE LOGIC
-- ============================================
local isResizing = false
local startMousePos = nil
local startSize = nil
local startPos = nil

local function beginResize(input)
    isResizing = true
    ResizeHandle:SetAttribute("Dragging", true)
    startMousePos = Vector2.new(input.Position.X, input.Position.Y)
    startSize = Vector2.new(MainFrame.AbsoluteSize.X, MainFrame.AbsoluteSize.Y)
    startPos = Vector2.new(MainFrame.AbsolutePosition.X, MainFrame.AbsolutePosition.Y)
    ResizeHandle.BackgroundTransparency = 0.2
end

local function updateResize(input)
    if not isResizing then return end
    if not startMousePos or not startSize then return end
    
    local currentMouse = Vector2.new(input.Position.X, input.Position.Y)
    local delta = currentMouse - startMousePos
    
    local newW = math.clamp(startSize.X + delta.X, MIN_WIDTH, MAX_WIDTH)
    local newH = math.clamp(startSize.Y + delta.Y, MIN_HEIGHT, MAX_HEIGHT)
    
    MainFrame.Size = UDim2.new(0, newW, 0, newH)
end

local function endResize()
    isResizing = false
    ResizeHandle:SetAttribute("Dragging", false)
    ResizeHandle.BackgroundTransparency = 0.5
    ResizeHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
end

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
       or input.UserInputType == Enum.UserInputType.Touch then
        beginResize(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not isResizing then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement 
       or input.UserInputType == Enum.UserInputType.Touch then
        updateResize(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
       or input.UserInputType == Enum.UserInputType.Touch then
        if isResizing then endResize() end
    end
end)

-- ============================================
-- MINIMIZE TOGGLE
-- ============================================
local isMinimized = false
local allElements = {InputLabel, InputFrame, BtnFrame, OutputLabel, OutputFrame, ResizeHandle}

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 44)
        MinBtn.Text = "□"
        for _, el in ipairs(allElements) do el.Visible = false end
    else
        MainFrame.Size = UDim2.new(0, 520, 0, 620)
        MinBtn.Text = "−"
        for _, el in ipairs(allElements) do el.Visible = true end
    end
end)

-- ============================================
-- OUTPUT REFRESH
-- ============================================
local function refreshOutput()
    OutputText.Text = table.concat(logs, "\n")
    task.wait(0.02)
    pcall(function()
        OutputText.Size = UDim2.new(1, 0, 0, OutputText.TextBounds.Y + 10)
        OutputFrame.CanvasSize = UDim2.new(0, 0, 0, OutputText.TextBounds.Y + 20)
        OutputFrame.CanvasPosition = Vector2.new(0, OutputFrame.CanvasSize.Y.Offset)
    end)
end

-- ============================================
-- PRINT/WARN CAPTURE
-- ============================================
local oldPrint = print
local oldWarn = warn

local function capturedPrint(...)
    addLog("INFO", ...)
    refreshOutput()
    pcall(oldPrint, ...)
end

local function capturedWarn(...)
    addLog("WARN", ...)
    refreshOutput()
    pcall(oldWarn, ...)
end

-- ============================================
-- BUTTONS
-- ============================================
makeBtn("▶ RUN", 75, function()
    local code = CodeBox.Text
    if code == "" or code:match("^%s*$") then
        addLog("WARN", "Kode kosong!")
        refreshOutput()
        return
    end
    
    addLog("INFO", "══════ EXECUTING ══════")
    refreshOutput()
    
    _G.print = capturedPrint
    _G.warn = capturedWarn
    
    task.spawn(function()
        local fn, err = loadstring(code)
        if not fn then
            addLog("ERROR", "Syntax error: " .. tostring(err))
        else
            local ok, runErr = pcall(fn)
            if not ok then
                addLog("ERROR", "Runtime: " .. tostring(runErr))
            end
        end
        addLog("INFO", "══════ DONE ══════")
        refreshOutput()
        _G.print = oldPrint
        _G.warn = oldWarn
    end)
end, Color3.fromRGB(30, 100, 60))

makeBtn("📋 COPY", 70, function()
    if setclipboard then
        pcall(function()
            setclipboard(table.concat(logs, "\n"))
            addLog("INFO", "✅ Dicopy! (" .. #logs .. " baris)")
        end)
    else
        addLog("WARN", "❌ setclipboard gak support")
    end
    refreshOutput()
end, Color3.fromRGB(30, 80, 130))

makeBtn("🗑️ CLEAR", 70, function()
    logs = {}
    OutputText.Text = ""
    OutputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    addLog("INFO", "🗑️ Output clear")
    refreshOutput()
end, Color3.fromRGB(100, 40, 40))

makeBtn("✏️ CLR CODE", 90, function()
    CodeBox.Text = ""
    addLog("INFO", "✏️ Code clear")
    refreshOutput()
end, Color3.fromRGB(80, 60, 30))

makeBtn("💾 SAVE", 70, function()
    if writefile then
        local fname = "YuszxLog_" .. os.time() .. ".txt"
        pcall(function()
            writefile(fname, table.concat(logs, "\n"))
            addLog("INFO", "💾 Saved: " .. fname)
        end)
    else
        addLog("WARN", "❌ writefile gak support")
    end
    refreshOutput()
end, Color3.fromRGB(60, 40, 90))

-- ============================================
-- CLOSE
-- ============================================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ============================================
-- INIT
-- ============================================
addLog("INFO", "═══════════════════════════════════")
addLog("INFO", "📋 Yuszx IDE v4 loaded!")
addLog("INFO", "✨ Resizable — drag pojok kanan bawah")
addLog("INFO", "✨ Animated border glow aktif")
addLog("INFO", "Parent: " .. tostring(uiParent and uiParent.Name or "?"))
addLog("INFO", "Player: " .. game.Players.LocalPlayer.Name)
addLog("INFO", "Place: " .. game.PlaceId)
addLog("INFO", "═══════════════════════════════════")
refreshOutput()

print("[Yuszx] 📋 IDE v4 — Resizable + Animated Border")
