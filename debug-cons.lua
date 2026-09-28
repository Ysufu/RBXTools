--[[
    ═══════════════════════════════════════════════════════════════
    📋 YUSZX MINI IDE — Split Console
    ═══════════════════════════════════════════════════════════════
    Layout:
    ┌─────────────────────────────────────────┐
    │ 📋 Yuszx Mini IDE              ✕        │
    ├─────────────────────────────────────────┤
    │ [TextBox — tempat nulis/paste kode]     │
    │                                          │
    │                                          │
    ├─────────────────────────────────────────┤
    │ ▶ Execute  📋 Copy  🗑️ Clear           │
    ├─────────────────────────────────────────┤
    │ [Output Console — nampilin log]         │
    │ [11:23:45] [INFO] Hallo                 │
    │ [11:23:46] [WARN] Warning!              │
    │ ...                                      │
    └─────────────────────────────────────────┘
    ═══════════════════════════════════════════════════════════════
]]

-- ============================================
-- LOG STORAGE
-- ============================================
local logs = {}
local MAX_LINES = 500

local function addLog(level, ...)
    local args = {...}
    local parts = {}
    for i, v in ipairs(args) do
        parts[i] = tostring(v)
    end
    local msg = table.concat(parts, " ")
    local timestamp = os.date("%H:%M:%S")
    table.insert(logs, "[" .. timestamp .. "] [" .. level .. "] " .. msg)
    if #logs > MAX_LINES then table.remove(logs, 1) end
end

-- ============================================
-- UI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuszxMiniIDE"
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
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

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 80, 80)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "📋 Yuszx Mini IDE"
Title.TextColor3 = Color3.fromRGB(200, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

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

-- ========== ATAS: INPUT AREA ==========
local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(1, -20, 0, 20)
InputLabel.Position = UDim2.new(0, 10, 0, 52)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "▶ CODE EDITOR"
InputLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
InputLabel.Font = Enum.Font.GothamBold
InputLabel.TextSize = 11
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = MainFrame

local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(1, -20, 0, 220)
InputFrame.Position = UDim2.new(0, 10, 0, 74)
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
CodeBox.PlaceholderText = "-- Paste / ketik kode debug kamu di sini...\n-- Terus klik ▶ EXECUTE di bawah"
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

-- ========== TOMBOL ==========
local BtnFrame = Instance.new("Frame")
BtnFrame.Size = UDim2.new(1, -20, 0, 40)
BtnFrame.Position = UDim2.new(0, 10, 0, 300)
BtnFrame.BackgroundTransparency = 1
BtnFrame.Parent = MainFrame

local BtnLayout = Instance.new("UIListLayout")
BtnLayout.FillDirection = Enum.FillDirection.Horizontal
BtnLayout.Padding = UDim.new(0, 6)
BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
BtnLayout.Parent = BtnFrame

local function makeBtn(text, width, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 0, 36)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 60, 100)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = BtnFrame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ========== BAWAH: OUTPUT AREA ==========
local OutputLabel = Instance.new("TextLabel")
OutputLabel.Size = UDim2.new(1, -20, 0, 20)
OutputLabel.Position = UDim2.new(0, 10, 0, 346)
OutputLabel.BackgroundTransparency = 1
OutputLabel.Text = "▼ OUTPUT"
OutputLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
OutputLabel.Font = Enum.Font.GothamBold
OutputLabel.TextSize = 11
OutputLabel.TextXAlignment = Enum.TextXAlignment.Left
OutputLabel.Parent = MainFrame

local OutputFrame = Instance.new("ScrollingFrame")
OutputFrame.Size = UDim2.new(1, -20, 1, -390)
OutputFrame.Position = UDim2.new(0, 10, 0, 368)
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
-- FUNGSI OUTPUT
-- ============================================
local function refreshOutput()
    local text = table.concat(logs, "\n")
    OutputText.Text = text
    task.wait(0.02)
    OutputText.Size = UDim2.new(1, 0, 0, OutputText.TextBounds.Y + 10)
    OutputFrame.CanvasSize = UDim2.new(0, 0, 0, OutputText.TextBounds.Y + 20)
    OutputFrame.CanvasPosition = Vector2.new(0, OutputFrame.CanvasSize.Y.Offset)
end

-- Override print & warn (hanya untuk kode yang di-execute dari IDE)
local oldPrint = print
local oldWarn = warn

local function capturePrint(...)
    addLog("INFO", ...)
    refreshOutput()
    oldPrint(...)
end

local function captureWarn(...)
    addLog("WARN", ...)
    refreshOutput()
    oldWarn(...)
end

-- ============================================
-- BUTTONS
-- ============================================

-- EXECUTE
makeBtn("▶ EXECUTE", 110, function()
    local code = CodeBox.Text
    if code == "" or code:match("^%s*$") then
        addLog("WARN", "Kode kosong! Paste dulu.")
        refreshOutput()
        return
    end
    
    addLog("INFO", "══════ EXECUTING CODE ══════")
    refreshOutput()
    
    -- Ganti global print & warn sementara
    _G.print = capturePrint
    _G.warn = captureWarn
    
    task.spawn(function()
        local fn, err = loadstring(code)
        if not fn then
            addLog("ERROR", "Syntax error: " .. tostring(err))
        else
            local ok, runErr = pcall(fn)
            if not ok then
                addLog("ERROR", "Runtime error: " .. tostring(runErr))
            end
        end
        addLog("INFO", "══════ EXECUTION DONE ══════")
        refreshOutput()
        
        -- Balikin print & warn asli
        _G.print = oldPrint
        _G.warn = oldWarn
    end)
end, Color3.fromRGB(30, 100, 60))

-- COPY OUTPUT
makeBtn("📋 COPY", 90, function()
    local text = table.concat(logs, "\n")
    if setclipboard then
        setclipboard(text)
        addLog("INFO", "✅ Output dicopy! (" .. #logs .. " baris)")
    else
        addLog("WARN", "❌ setclipboard gak support")
    end
    refreshOutput()
end, Color3.fromRGB(30, 80, 130))

-- CLEAR OUTPUT
makeBtn("🗑️ CLEAR", 90, function()
    logs = {}
    OutputText.Text = ""
    OutputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    addLog("INFO", "🗑️ Output di-clear")
    refreshOutput()
end, Color3.fromRGB(100, 40, 40))

-- CLEAR CODE
makeBtn("✏️ CLEAR CODE", 110, function()
    CodeBox.Text = ""
    addLog("INFO", "✏️ Code editor di-clear")
    refreshOutput()
end, Color3.fromRGB(80, 60, 30))

-- SAVE LOG
makeBtn("💾 SAVE", 80, function()
    if writefile then
        local fname = "YuszxLog_" .. os.time() .. ".txt"
        pcall(function()
            writefile(fname, table.concat(logs, "\n"))
            addLog("INFO", "💾 Disimpan: " .. fname)
        end)
    else
        addLog("WARN", "❌ writefile gak support")
    end
    refreshOutput()
end, Color3.fromRGB(60, 40, 90))

-- ============================================
-- DRAG SUPPORT (Resize)
-- ============================================
-- Buat handle resize di tengah antara input & output
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(1, -20, 0, 6)
ResizeHandle.Position = UDim2.new(0, 10, 0, 342)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ResizeHandle.Text = ""
ResizeHandle.BorderSizePixel = 0
ResizeHandle.AutoButtonColor = false
ResizeHandle.Parent = MainFrame

local HandleCorner = Instance.new("UICorner")
HandleCorner.CornerRadius = UDim.new(1, 0)
HandleCorner.Parent = ResizeHandle

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
addLog("INFO", "📋 Yuszx Mini IDE loaded!")
addLog("INFO", "1. Paste kode di atas")
addLog("INFO", "2. Klik ▶ EXECUTE")
addLog("INFO", "3. Liat output di bawah")
addLog("INFO", "4. Klik 📋 COPY buat copy hasil")
addLog("INFO", "═══════════════════════════════════")
refreshOutput()

print("[Yuszx] 📋 Mini IDE aktif! Paste kode di UI.")
