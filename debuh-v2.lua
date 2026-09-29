-- =====================================================
-- 🖥️  DEV CONSOLE v1.1 (with Copy Result)
-- Security testing tool untuk game sendiri
-- =====================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ===== CLEANUP =====
if _G.__devconsole_hooks then
    print = _G.__devconsole_hooks.print
    warn  = _G.__devconsole_hooks.warn
    _G.__devconsole_hooks = nil
end
local oldGui = CoreGui:FindFirstChild("DevConsole")
if oldGui then oldGui:Destroy() end

-- ===== ENV INFO =====
local envInfo = {
    placeName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown",
    placeId   = tostring(game.PlaceId),
    jobId     = tostring(game.JobId),
    player    = Players.LocalPlayer.Name,
    userId    = tostring(Players.LocalPlayer.UserId),
    exec      = (identifyexecutor and identifyexecutor()) or "Unknown",
    time      = os.date("%Y-%m-%d %H:%M:%S"),
}

-- ===== GUI ROOT =====
local gui = Instance.new("ScreenGui")
gui.Name = "DevConsole"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0.95, 0, 0.9, 0)
main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
main.BorderSizePixel = 0
main.Parent = gui

local sizeLimit = Instance.new("UISizeConstraint", main)
sizeLimit.MaxSize = Vector2.new(560, 700)

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(70, 70, 110)
stroke.Thickness = 1

-- ===== HEADER =====
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
header.BorderSizePixel = 0
header.Active = true
header.Draggable = true
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local headerLower = Instance.new("Frame")
headerLower.Size = UDim2.new(1, 0, 0, 14)
headerLower.Position = UDim2.new(0, 0, 1, -14)
headerLower.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
headerLower.BorderSizePixel = 0
headerLower.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -76, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.RichText = true
title.Text = "🖥️  DEV CONSOLE  <font color='#6060a0'>| v1.1</font>"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -64, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
minBtn.Text = "–"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.Parent = header
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 55, 55)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- ===== BODY =====
local body = Instance.new("Frame")
body.Size = UDim2.new(1, 0, 1, -38)
body.Position = UDim2.new(0, 0, 0, 38)
body.BackgroundTransparency = 1
body.ClipsDescendants = true
body.Parent = main

-- INPUT
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -16, 0, 100)
inputFrame.Position = UDim2.new(0, 8, 0, 8)
inputFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = body
Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 6)

local inputLbl = Instance.new("TextLabel")
inputLbl.Size = UDim2.new(1, -12, 0, 16)
inputLbl.Position = UDim2.new(0, 8, 0, 4)
inputLbl.BackgroundTransparency = 1
inputLbl.Text = "▸ LUA CODE INPUT"
inputLbl.TextColor3 = Color3.fromRGB(130, 140, 200)
inputLbl.Font = Enum.Font.GothamBold
inputLbl.TextSize = 10
inputLbl.TextXAlignment = Enum.TextXAlignment.Left
inputLbl.Parent = inputFrame

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, -12, 1, -28)
codeBox.Position = UDim2.new(0, 6, 0, 24)
codeBox.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
codeBox.TextColor3 = Color3.fromRGB(160, 255, 160)
codeBox.PlaceholderText = "-- print('test') / warn('cek') / error('boom')"
codeBox.PlaceholderColor3 = Color3.fromRGB(70, 70, 90)
codeBox.Text = ""
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 12
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.TextWrapped = true
codeBox.MultiLine = true
codeBox.ClearTextOnFocus = false
codeBox.Parent = inputFrame
Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0, 4)

local codePad = Instance.new("UIPadding", codeBox)
codePad.PaddingLeft = UDim.new(0, 6)
codePad.PaddingRight = UDim.new(0, 6)
codePad.PaddingTop = UDim.new(0, 6)
codePad.PaddingBottom = UDim.new(0, 6)

-- BUTTON AREA
local btnArea = Instance.new("Frame")
btnArea.Size = UDim2.new(1, -16, 0, 100)
btnArea.Position = UDim2.new(0, 8, 0, 112)
btnArea.BackgroundTransparency = 1
btnArea.Parent = body

local function makeRow(yPos)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.Position = UDim2.new(0, 0, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = btnArea
    local lay = Instance.new("UIListLayout", row)
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.Padding = UDim.new(0, 6)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    return row
end

local row1 = makeRow(0)
local row2 = makeRow(34)
local row3 = makeRow(68)

-- OUTPUT
local outputFrame = Instance.new("Frame")
outputFrame.Size = UDim2.new(1, -16, 1, -220)
outputFrame.Position = UDim2.new(0, 8, 0, 216)
outputFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
outputFrame.BorderSizePixel = 0
outputFrame.Parent = body
Instance.new("UICorner", outputFrame).CornerRadius = UDim.new(0, 6)

local outLbl = Instance.new("TextLabel")
outLbl.Size = UDim2.new(1, -12, 0, 16)
outLbl.Position = UDim2.new(0, 8, 0, 4)
outLbl.BackgroundTransparency = 1
outLbl.Text = "▸ OUTPUT LOG"
outLbl.TextColor3 = Color3.fromRGB(130, 140, 200)
outLbl.Font = Enum.Font.GothamBold
outLbl.TextSize = 10
outLbl.TextXAlignment = Enum.TextXAlignment.Left
outLbl.Parent = outputFrame

local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1, -8, 1, -28)
logScroll.Position = UDim2.new(0, 4, 0, 24)
logScroll.BackgroundTransparency = 1
logScroll.BorderSizePixel = 0
logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
logScroll.ScrollBarThickness = 3
logScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
logScroll.Parent = outputFrame

local logLayout = Instance.new("UIListLayout", logScroll)
logLayout.Padding = UDim.new(0, 2)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder

local logPad = Instance.new("UIPadding", logScroll)
logPad.PaddingLeft = UDim.new(0, 4)
logPad.PaddingRight = UDim.new(0, 4)
logPad.PaddingTop = UDim.new(0, 4)
logPad.PaddingBottom = UDim.new(0, 4)

-- ===== STATE =====
local MAX_LOGS = 300
local logHistory = {}
local filterLevel = "all"
local autoCopyError = false
local lastExecBlock = {}

local colors = {
    info    = Color3.fromRGB(180, 200, 220),
    warn    = Color3.fromRGB(255, 200, 80),
    error   = Color3.fromRGB(255, 100, 100),
    success = Color3.fromRGB(120, 255, 150),
    system  = Color3.fromRGB(130, 180, 255),
}
local icons = { info="•", warn="⚠", error="✖", success="✓", system="»" }

local function timestamp() return os.date("%H:%M:%S") end

local function buildLabel(level, time, msg)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 0, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1
    lbl.Text = "[" .. time .. "] " .. (icons[level] or "•") .. " " .. msg
    lbl.TextColor3 = colors[level] or colors.info
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.TextWrapped = true
    lbl.Parent = logScroll
    return lbl
end

local function scrollToBottom()
    task.defer(function()
        logScroll.CanvasPosition = Vector2.new(0, logScroll.AbsoluteCanvasSize.Y)
    end)
end

local function addLog(level, msg)
    local t = timestamp()
    local entry = {level=level, msg=msg, time=t}
    table.insert(logHistory, entry)
    if #logHistory > MAX_LOGS then
        table.remove(logHistory, 1)
        local first = logScroll:FindFirstChildOfClass("TextLabel")
        if first then first:Destroy() end
    end
    if filterLevel ~= "all" and level ~= filterLevel then return end
    buildLabel(level, t, msg)
    scrollToBottom()
end

local function rebuildLogVisual()
    for _, c in ipairs(logScroll:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    for _, e in ipairs(logHistory) do
        if filterLevel == "all" or e.level == filterLevel then
            buildLabel(e.level, e.time, e.msg)
        end
    end
    scrollToBottom()
end

-- ===== FORMATTING FOR COPY =====
local function headerText()
    return table.concat({
        "═══════════════════════════════════════",
        "  DEV CONSOLE REPORT",
        "═══════════════════════════════════════",
        "Place    : " .. envInfo.placeName,
        "PlaceId  : " .. envInfo.placeId,
        "JobId    : " .. envInfo.jobId:sub(1, 8) .. "...",
        "Player   : " .. envInfo.player .. " (ID: " .. envInfo.userId .. ")",
        "Exec     : " .. envInfo.exec,
        "Time     : " .. envInfo.time,
        "═══════════════════════════════════════",
        "",
    }, "\n")
end

local function entryText(e)
    return string.format("[%s][%s] %s", e.time, e.level, e.msg)
end

local function footerText(entries)
    local e, w = 0, 0
    for _, entry in ipairs(entries) do
        if entry.level == "error" then e = e + 1 end
        if entry.level == "warn"  then w = w + 1 end
    end
    return table.concat({
        "",
        "═══════════════════════════════════════",
        string.format("Total: %d entries | Errors: %d | Warnings: %d", #entries, e, w),
        "═══════════════════════════════════════",
    }, "\n")
end

local function buildReport(entries)
    local lines = {}
    for _, e in ipairs(entries) do
        table.insert(lines, entryText(e))
    end
    return headerText() .. table.concat(lines, "\n") .. footerText(entries)
end

local function doCopy(text, label)
    if #text == 0 then
        addLog("system", label .. ": kosong")
        return false
    end
    local ok = pcall(function() setclipboard(text) end)
    if ok then
        addLog("success", label .. " dicopy ke clipboard (" .. #text .. " chars)")
        return true
    else
        addLog("warn", "setclipboard() gak ada, coba writefile")
        local ok2 = pcall(function() writefile("devconsole_copy.txt", text) end)
        if ok2 then addLog("success", "Disimpan: devconsole_copy.txt") end
        return false
    end
end

-- ===== HOOKS =====
local oldPrint = print
local oldWarn  = warn
_G.__devconsole_hooks = {print = oldPrint, warn = oldWarn}

local function stringifyArgs(...)
    local t = {n = select("#", ...), ...}
    local parts = {}
    for i = 1, t.n do parts[i] = tostring(t[i]) end
    return table.concat(parts, " ")
end

print = function(...)
    addLog("info", stringifyArgs(...))
    oldPrint(...)
end

warn = function(...)
    addLog("warn", stringifyArgs(...))
    oldWarn(...)
end

-- ===== EXECUTE =====
local function execute()
    local code = codeBox.Text
    if code == "" or code:match("^%s*$") then
        addLog("system", "(kosong, gak ada yang dijalanin)")
        return
    end

    -- Track untuk "copy last"
    lastExecBlock = {}

    local preview = code:gsub("\n", " ⏎ ")
    if #preview > 80 then preview = preview:sub(1, 77) .. "..." end
    addLog("system", "> " .. preview)
    table.insert(lastExecBlock, logHistory[#logHistory])

    local loader = loadstring or load
    if not loader then addLog("error", "loadstring() gak tersedia") return end

    local fn, err = loader(code, "=devconsole")
    if not fn then
        addLog("error", "Compile error: " .. tostring(err))
        table.insert(lastExecBlock, logHistory[#logHistory])
        if autoCopyError then doCopy(buildReport(lastExecBlock), "Auto-copy error") end
        return
    end

    local t0 = os.clock()
    local ok, result = xpcall(fn, function(e)
        return tostring(e) .. "\n" .. debug.traceback("", 2)
    end)
    local elapsed = (os.clock() - t0) * 1000

    if ok then
        if result ~= nil then
            addLog("success", "← " .. tostring(result) .. string.format("  (%.2fms)", elapsed))
        else
            addLog("success", string.format("OK  (%.2fms)", elapsed))
        end
    else
        addLog("error", tostring(result))
        if autoCopyError then
            table.insert(lastExecBlock, logHistory[#logHistory])
            doCopy(buildReport(lastExecBlock), "Auto-copy error")
        end
    end
    table.insert(lastExecBlock, logHistory[#logHistory])
end

-- ===== BUTTONS =====
local function makeBtn(parent, text, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 0, 1, 0)
    b.AutomaticSize = Enum.AutomaticSize.X
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

    local p = Instance.new("UIPadding", b)
    p.PaddingLeft = UDim.new(0, 8)
    p.PaddingRight = UDim.new(0, 8)

    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback, b)
        if not ok then addLog("error", "Button error: " .. tostring(err)) end
    end)
    return b
end

-- ROW 1: Execute + Clear
makeBtn(row1, "▶ EXECUTE", Color3.fromRGB(45, 130, 70), execute)
makeBtn(row1, "🗑 Clear Log", Color3.fromRGB(90, 60, 90), function()
    table.clear(logHistory)
    for _, c in ipairs(logScroll:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    addLog("system", "Log dibersihin")
end)
makeBtn(row1, "✕ Clear Input", Color3.fromRGB(90, 60, 90), function()
    codeBox.Text = ""
    addLog("system", "Input dibersihin")
end)

-- ROW 2: COPY BUTTONS (yang lu minta)
makeBtn(row2, "📋 Copy All", Color3.fromRGB(55, 110, 170), function()
    if #logHistory == 0 then addLog("system", "Log kosong") return end
    doCopy(buildReport(logHistory), "Full report")
end)

makeBtn(row2, "📄 Copy Last", Color3.fromRGB(55, 130, 130), function()
    if #lastExecBlock == 0 then addLog("system", "Belum ada execute") return end
    doCopy(buildReport(lastExecBlock), "Last result")
end)

makeBtn(row2, "🔴 Copy Errors", Color3.fromRGB(150, 60, 60), function()
    local errs = {}
    for _, e in ipairs(logHistory) do
        if e.level == "error" or e.level == "warn" then
            table.insert(errs, e)
        end
    end
    if #errs == 0 then addLog("system", "Gak ada error/warning") return end
    doCopy(buildReport(errs), "Errors + warnings")
end)

-- ROW 3: Save + Filter + Auto-copy toggle
makeBtn(row3, "💾 Save File", Color3.fromRGB(55, 80, 130), function()
    local txt = buildReport(logHistory)
    local ok = pcall(function() writefile("devconsole_log.txt", txt) end)
    if ok then addLog("success", "Disimpan: devconsole_log.txt")
    else addLog("warn", "writefile() gak ada") end
end)

local filterOrder = {"all", "info", "warn", "error", "success", "system"}
local filterBtn
filterBtn = makeBtn(row3, "🔽 ALL", Color3.fromRGB(55, 80, 130), function(b)
    local idx = table.find(filterOrder, filterLevel) or 1
    idx = idx % #filterOrder + 1
    filterLevel = filterOrder[idx]
    b.Text = "🔽 " .. string.upper(filterLevel)
    rebuildLogVisual()
end)

local autoBtn
autoBtn = makeBtn(row3, "📦 Auto Error: OFF", Color3.fromRGB(60, 60, 80), function(b)
    autoCopyError = not autoCopyError
    b.Text = "📦 Auto Error: " .. (autoCopyError and "ON" or "OFF")
    b.BackgroundColor3 = autoCopyError and Color3.fromRGB(80, 130, 80) or Color3.fromRGB(60, 60, 80)
    addLog("system", "Auto-copy on error: " .. (autoCopyError and "ON" or "OFF"))
end)

-- ===== MINIMIZE / CLOSE =====
local savedSize = main.Size
minBtn.MouseButton1Click:Connect(function()
    body.Visible = not body.Visible
    if body.Visible then
        main.Size = savedSize
        minBtn.Text = "–"
    else
        savedSize = main.Size
        main.Size = UDim2.new(0, 520, 0, 38)
        minBtn.Text = "+"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    addLog("system", "Hidden. F4 buat munculin lagi.")
end)

-- ===== SHORTCUTS =====
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F4 then
        main.Visible = not main.Visible
    end
    if input.KeyCode == Enum.KeyCode.Return
    and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        execute()
    end
end)

-- ===== WELCOME =====
addLog("system", "Dev Console v1.1 ready")
addLog("system", "F4=toggle | Ctrl+Enter=execute")
addLog("system", "Copy buttons: 📋 All | 📄 Last | 🔴 Errors")
addLog("info", "Coba: print('hello') lalu tekan 📄 Copy Last")
