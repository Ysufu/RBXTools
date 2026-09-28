--[[
    ═══════════════════════════════════════════════════════════════
    📋 YUSZX IDE v7 — RESPONSIVE (Auto-Adjust Layar)
    ═══════════════════════════════════════════════════════════════
    ✅ Auto-detect resolusi layar
    ✅ Auto-adjust pas rotasi (portrait ↔ landscape)
    ✅ Min/Max size berdasarkan viewport
    ✅ Resize handle tetap work
    ✅ Output capture masuk IDE (no screenshot)
    ═══════════════════════════════════════════════════════════════
]]

-- ============================================
-- UI PARENT
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
        if pcall(function() test.Parent = p end) and test.Parent then
            test:Destroy()
            return p
        end
        pcall(function() test:Destroy() end)
    end
end

local uiParent = getSafeParent()
if not uiParent then warn("[IDE] Gak bisa dapet parent!") return end

-- ============================================
-- 🎯 RESPONSIVE CONFIG
-- ============================================
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- Config default (dalam persen dari layar)
local SIZE_PERCENT = {
    width = 0.55,   -- 55% lebar layar
    height = 0.75,  -- 75% tinggi layar
}

-- Batas absolute (pixel)
local MIN_W, MIN_H = 280, 260
local MAX_W, MAX_H = 900, 1000

-- Hitung size optimal berdasarkan viewport
local function getOptimalSize()
    local vp = Camera.ViewportSize
    local w = math.clamp(vp.X * SIZE_PERCENT.width, MIN_W, MAX_W)
    local h = math.clamp(vp.Y * SIZE_PERCENT.height, MIN_H, MAX_H)
    return math.floor(w), math.floor(h)
end

-- ============================================
-- LOG STORAGE
-- ============================================
local logs = {}
local MAX_LINES = 500
local OutputText

local function addLog(level, ...)
    local args = {...}
    local parts = {}
    for i, v in ipairs(args) do parts[i] = tostring(v) end
    local ts = os.date("%H:%M:%S")
    table.insert(logs, "[" .. ts .. "] [" .. level .. "] " .. table.concat(parts, " "))
    if #logs > MAX_LINES then table.remove(logs, 1) end
end

-- ============================================
-- UI
-- ============================================
local initW, initH = getOptimalSize()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuszxIDE_" .. math.random(1000, 9999)
ScreenGui.Parent = uiParent
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, initW, 0, initH)
MainFrame.Position = UDim2.new(0.5, -initW/2, 0.5, -initH/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Animated border
local BorderStroke = Instance.new("UIStroke")
BorderStroke.Color = Color3.fromRGB(0, 200, 255)
BorderStroke.Thickness = 2.5
BorderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BorderStroke.Parent = MainFrame

local BorderGradient = Instance.new("UIGradient")
BorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(150, 50, 255)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 50, 150)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 200, 255)),
})
BorderGradient.Parent = BorderStroke

task.spawn(function()
    while MainFrame.Parent do
        for i = 0, 360, 15 do
            if not MainFrame.Parent then break end
            pcall(function() BorderGradient.Rotation = i end)
            task.wait(0.04)
        end
    end
end)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "📋 Yuszx IDE"
Title.TextColor3 = Color3.fromRGB(200, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -72, 0, 6)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(150, 200, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Input label (posisi fixed di bawah header)
local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(1, -20, 0, 18)
InputLabel.Position = UDim2.new(0, 10, 0, 52)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "▶ CODE EDITOR"
InputLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
InputLabel.Font = Enum.Font.GothamBold
InputLabel.TextSize = 11
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = MainFrame

-- Input frame (50% dari tinggi tersisa)
local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(1, -20, 0.38, 0)
InputFrame.Position = UDim2.new(0, 10, 0, 72)
InputFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
InputFrame.BorderSizePixel = 0
InputFrame.Parent = MainFrame
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 8)

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(0, 100, 150)
InputStroke.Thickness = 1
InputStroke.Parent = InputFrame

local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(1, -16, 1, -16)
CodeBox.Position = UDim2.new(0, 8, 0, 8)
CodeBox.BackgroundTransparency = 1
CodeBox.Text = ""
CodeBox.PlaceholderText = "-- Paste kode debug di sini..."
CodeBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
CodeBox.TextColor3 = Color3.fromRGB(200, 255, 200)
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 11
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.TextWrapped = true
CodeBox.ClearTextOnFocus = false
CodeBox.MultiLine = true
CodeBox.Parent = InputFrame

-- Buttons row (posisi pake scale)
local BtnFrame = Instance.new("Frame")
BtnFrame.Size = UDim2.new(1, -20, 0, 38)
BtnFrame.Position = UDim2.new(0, 10, 0.42, 8)
BtnFrame.BackgroundTransparency = 1
BtnFrame.Parent = MainFrame

local BtnLayout = Instance.new("UIListLayout")
BtnLayout.FillDirection = Enum.FillDirection.Horizontal
BtnLayout.Padding = UDim.new(0, 4)
BtnLayout.Parent = BtnFrame

local function makeBtn(text, width, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 1, 0)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 60, 100)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = BtnFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Output label
local OutputLabel = Instance.new("TextLabel")
OutputLabel.Size = UDim2.new(1, -20, 0, 18)
OutputLabel.Position = UDim2.new(0, 10, 0.5, 8)
OutputLabel.BackgroundTransparency = 1
OutputLabel.Text = "▼ OUTPUT"
OutputLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
OutputLabel.Font = Enum.Font.GothamBold
OutputLabel.TextSize = 11
OutputLabel.TextXAlignment = Enum.TextXAlignment.Left
OutputLabel.Parent = MainFrame

-- Output frame (sisa tinggi di bawah)
local OutputFrame = Instance.new("ScrollingFrame")
OutputFrame.Size = UDim2.new(1, -20, 0.45, -30)
OutputFrame.Position = UDim2.new(0, 10, 0.55, 0)
OutputFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
OutputFrame.BorderSizePixel = 0
OutputFrame.ScrollBarThickness = 4
OutputFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
OutputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
OutputFrame.Parent = MainFrame
Instance.new("UICorner", OutputFrame).CornerRadius = UDim.new(0, 8)

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

OutputText = Instance.new("TextLabel")
OutputText.Size = UDim2.new(1, 0, 0, 0)
OutputText.BackgroundTransparency = 1
OutputText.Text = ""
OutputText.TextColor3 = Color3.fromRGB(180, 255, 180)
OutputText.Font = Enum.Font.Code
OutputText.TextSize = 10
OutputText.TextXAlignment = Enum.TextXAlignment.Left
OutputText.TextYAlignment = Enum.TextYAlignment.Top
OutputText.TextWrapped = true
OutputText.Parent = OutputFrame

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
-- 🎯 CAPTURE (setfenv + fallback)
-- ============================================
local function customPrint(...)
    local args = {...}
    local parts = {}
    for i, v in ipairs(args) do parts[i] = tostring(v) end
    addLog("INFO", table.concat(parts, " "))
    refreshOutput()
end

local function customWarn(...)
    local args = {...}
    local parts = {}
    for i, v in ipairs(args) do parts[i] = tostring(v) end
    addLog("WARN", table.concat(parts, " "))
    refreshOutput()
end

-- ============================================
-- BUTTONS
-- ============================================
makeBtn("▶ RUN", 65, function()
    local code = CodeBox.Text
    if code == "" or code:match("^%s*$") then
        addLog("WARN", "⚠️ Kode kosong!")
        refreshOutput()
        return
    end
    
    addLog("INFO", "══════ EXECUTING ══════")
    refreshOutput()
    
    task.spawn(function()
        local fn, err = loadstring(code)
        if not fn then
            addLog("ERROR", "❌ Syntax: " .. tostring(err))
            refreshOutput()
            return
        end
        
        -- Multi-method capture
        local captured = false
        if setfenv then
            captured = pcall(function()
                setfenv(fn, setmetatable({
                    print = customPrint,
                    warn = customWarn,
                }, {__index = _G}))
            end)
        end
        if not captured and hookfunction then
            pcall(function()
                hookfunction(print, customPrint)
                hookfunction(warn, customWarn)
                captured = true
            end)
        end
        if not captured and getfenv then
            pcall(function()
                local env = getfenv(fn)
                env.print = customPrint
                env.warn = customWarn
                captured = true
            end)
        end
        
        local ok, runErr = pcall(fn)
        if not ok then
            addLog("ERROR", "❌ Runtime: " .. tostring(runErr))
        else
            addLog("INFO", "✅ Sukses!")
        end
        
        addLog("INFO", "══════ DONE ══════")
        refreshOutput()
    end)
end, Color3.fromRGB(30, 120, 60))

makeBtn("📋 COPY", 60, function()
    if setclipboard then
        pcall(function()
            setclipboard(table.concat(logs, "\n"))
            addLog("INFO", "✅ Copied! (" .. #logs .. ")")
        end)
    else
        addLog("WARN", "❌ setclipboard gak support")
    end
    refreshOutput()
end, Color3.fromRGB(30, 80, 130))

makeBtn("🗑️ CLR", 55, function()
    logs = {}
    OutputText.Text = ""
    OutputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    addLog("INFO", "🗑️ Clear")
    refreshOutput()
end, Color3.fromRGB(100, 40, 40))

makeBtn("✏️ CODE", 60, function()
    CodeBox.Text = ""
    refreshOutput()
end, Color3.fromRGB(80, 60, 30))

makeBtn("💾 SAVE", 55, function()
    if writefile then
        local fname = "YuszxLog_" .. os.time() .. ".txt"
        pcall(function()
            writefile(fname, table.concat(logs, "\n"))
            addLog("INFO", "💾 " .. fname)
        end)
    else
        addLog("WARN", "❌ writefile gak support")
    end
    refreshOutput()
end, Color3.fromRGB(60, 40, 90))

-- ============================================
-- RESIZE HANDLE
-- ============================================
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -22, 1, -22)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ResizeHandle.BackgroundTransparency = 0.5
ResizeHandle.Text = "◢"
ResizeHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
ResizeHandle.TextSize = 14
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.BorderSizePixel = 0
ResizeHandle.AutoButtonColor = false
ResizeHandle.ZIndex = 10
ResizeHandle.Parent = MainFrame
Instance.new("UICorner", ResizeHandle).CornerRadius = UDim.new(0, 5)

local isResizing = false
local startMousePos, startSize

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true
        startMousePos = Vector2.new(input.Position.X, input.Position.Y)
        startSize = Vector2.new(MainFrame.AbsoluteSize.X, MainFrame.AbsoluteSize.Y)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not isResizing then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = Vector2.new(input.Position.X, input.Position.Y) - startMousePos
    local newW = math.clamp(startSize.X + delta.X, MIN_W, MAX_W)
    local newH = math.clamp(startSize.Y + delta.Y, MIN_H, MAX_H)
    MainFrame.Size = UDim2.new(0, newW, 0, newH)
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
    end
end)

-- ============================================
-- 🎯 AUTO-RESPONSIVE (Rotasi & Resize Layar)
-- ============================================
local lastVP = Camera.ViewportSize

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local vp = Camera.ViewportSize
    if vp == lastVP then return end
    lastVP = vp
    
    task.wait(0.1)  -- tunggu rotasi selesai
    
    local w, h = getOptimalSize()
    
    -- Kalau UI gak di-resize manual sama user, auto-adjust
    if not MainFrame:GetAttribute("UserResized") then
        MainFrame.Size = UDim2.new(0, w, 0, h)
        MainFrame.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
        pcall(function()
            addLog("INFO", "🔄 Auto-resize: " .. w .. "x" .. h)
            refreshOutput()
        end)
    end
end)

-- Tandai kalau user resize manual
ResizeHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        task.wait(0.1)
        MainFrame:SetAttribute("UserResized", true)
    end
end)

-- ============================================
-- MINIMIZE
-- ============================================
local isMinimized = false
local allElements = {InputLabel, InputFrame, BtnFrame, OutputLabel, OutputFrame, ResizeHandle}

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 42)
        MinBtn.Text = "□"
        for _, el in ipairs(allElements) do el.Visible = false end
    else
        local w, h = getOptimalSize()
        MainFrame.Size = UDim2.new(0, w, 0, h)
        MinBtn.Text = "−"
        for _, el in ipairs(allElements) do el.Visible = true end
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ============================================
-- INIT
-- ============================================
local vp = Camera.ViewportSize
addLog("INFO", "═══════════════════════════════════")
addLog("INFO", "📋 IDE v7 — RESPONSIVE loaded!")
addLog("INFO", "Layar: " .. vp.X .. " x " .. vp.Y)
addLog("INFO", "UI: " .. initW .. " x " .. initH)
addLog("INFO", "Player: " .. game.Players.LocalPlayer.Name)
addLog("INFO", "═══════════════════════════════════")
addLog("INFO", "✅ Auto-adjust pas rotasi layar")
addLog("INFO", "✅ Output masuk IDE (no screenshot)")
addLog("INFO", "═══════════════════════════════════")
refreshOutput()

print("[Yuszx] IDE v7 — Responsive loaded")
