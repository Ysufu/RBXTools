--[[
    ═══════════════════════════════════════════════════════════════
    🔍 YUSZX SEARCH — Full Fix Edition
    ═══════════════════════════════════════════════════════════════
    ✅ Responsive (auto-adjust layar + rotasi)
    ✅ Multi-fetch method (request / http_request / game:HttpGet)
    ✅ Multi search engine (DDG → Bing → SearX)
    ✅ Better error handling
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
if not uiParent then warn("[Search] Gak bisa dapet UI parent!") return end

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

-- ============================================
-- 🎯 RESPONSIVE
-- ============================================
local function getOptimalSize()
    local vp = Camera.ViewportSize
    local w = math.min(vp.X * 0.92, 540)
    local h = math.min(vp.Y * 0.85, 620)
    w = math.max(w, 300)
    h = math.max(h, 400)
    return math.floor(w), math.floor(h)
end

local initW, initH = getOptimalSize()

-- ============================================
-- SEARCH ENGINES (Multi-fallback)
-- ============================================
local ENGINES = {
    {
        name = "DuckDuckGo",
        url = "https://html.duckduckgo.com/html/?q=",
        parsePattern = '<a[^>]*class="result__a"[^>]*href="([^"]+)"[^>]*>(.-)</a>',
        decodeURL = true,
    },
    {
        name = "Bing",
        url = "https://www.bing.com/search?q=",
        parsePattern = '<h2><a[^>]*href="([^"]+)"[^>]*>(.-)</a></h2>',
        decodeURL = false,
    },
    {
        name = "SearX",
        url = "https://searx.be/search?q=",
        parsePattern = '<a[^>]*href="([^"]+)"[^>]*class="url"[^>]*>(.-)</a>',
        decodeURL = false,
    },
}

local MAX_RESULTS = 20

-- ============================================
-- COLORS
-- ============================================
local C = {
    BG = Color3.fromRGB(15, 15, 20),
    BG_ELEV = Color3.fromRGB(22, 22, 30),
    BG_CARD = Color3.fromRGB(28, 28, 38),
    BG_CARD_HOVER = Color3.fromRGB(38, 38, 50),
    BORDER = Color3.fromRGB(45, 45, 60),
    TEXT = Color3.fromRGB(240, 240, 245),
    TEXT_SUB = Color3.fromRGB(150, 150, 170),
    TEXT_DIM = Color3.fromRGB(100, 100, 120),
    ACCENT = Color3.fromRGB(0, 180, 255),
    ACCENT_HOVER = Color3.fromRGB(50, 200, 255),
    GREEN = Color3.fromRGB(80, 220, 120),
    PURPLE = Color3.fromRGB(150, 80, 255),
    RED = Color3.fromRGB(255, 100, 100),
    YELLOW = Color3.fromRGB(255, 200, 100),
}

-- ============================================
-- 🚀 FETCH (Multi-method)
-- ============================================
local function fetchURL(url)
    -- Method 1: request()
    if request then
        local ok, res = pcall(request, { Url = url, Method = "GET" })
        if ok and res and res.Body and #res.Body > 0 then
            return res.Body, "request"
        end
    end
    
    -- Method 2: http_request()
    if http_request then
        local ok, res = pcall(http_request, { Url = url, Method = "GET" })
        if ok and res and res.Body and #res.Body > 0 then
            return res.Body, "http_request"
        end
    end
    
    -- Method 3: syn.request (Synapse)
    if syn and syn.request then
        local ok, res = pcall(syn.request, { Url = url, Method = "GET" })
        if ok and res and res.Body and #res.Body > 0 then
            return res.Body, "syn.request"
        end
    end
    
    -- Method 4: http.get (older executor)
    if http and http.get then
        local ok, res = pcall(http.get, url)
        if ok and res and #res > 0 then
            return res, "http.get"
        end
    end
    
    -- Method 5: game:HttpGet (fallback)
    local ok, res = pcall(game.HttpGet, game, url, true)
    if ok and res and #res > 0 then
        return res, "game:HttpGet"
    end
    
    return nil, "all methods failed"
end

-- ============================================
-- ROOT FRAME
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuszxSearch_" .. math.random(1000, 9999)
ScreenGui.Parent = uiParent
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, initW, 0, initH)
MainFrame.Position = UDim2.new(0.5, -initW/2, 0.5, -initH/2)
MainFrame.BackgroundColor3 = C.BG
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = C.BORDER
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Top glow
local TopGlow = Instance.new("Frame")
TopGlow.Size = UDim2.new(1, 0, 0, 2)
TopGlow.BackgroundColor3 = C.ACCENT
TopGlow.BorderSizePixel = 0
TopGlow.Parent = MainFrame

local TopGlowCorner = Instance.new("UICorner")
TopGlowCorner.CornerRadius = UDim.new(0, 16)
TopGlowCorner.Parent = TopGlow

local TopGlowGrad = Instance.new("UIGradient")
TopGlowGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, C.ACCENT),
    ColorSequenceKeypoint.new(0.50, C.PURPLE),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 80, 150)),
})
TopGlowGrad.Parent = TopGlow

task.spawn(function()
    while MainFrame.Parent do
        for i = 0, 360, 20 do
            if not MainFrame.Parent then break end
            pcall(function() TopGlowGrad.Rotation = i end)
            task.wait(0.05)
        end
    end
end)

-- ============================================
-- HEADER
-- ============================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = C.BG
Header.BackgroundTransparency = 0.5
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local HeaderPadding = Instance.new("UIPadding")
HeaderPadding.PaddingLeft = UDim.new(0, 20)
HeaderPadding.PaddingRight = UDim.new(0, 16)
HeaderPadding.PaddingTop = UDim.new(0, 10)
HeaderPadding.Parent = Header

local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 40, 0, 40)
LogoFrame.BackgroundColor3 = C.BG_CARD
LogoFrame.BorderSizePixel = 0
LogoFrame.Parent = Header

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 10)
LogoCorner.Parent = LogoFrame

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = C.ACCENT
LogoStroke.Thickness = 1
LogoStroke.Transparency = 0.4
LogoStroke.Parent = LogoFrame

local LogoIcon = Instance.new("TextLabel")
LogoIcon.Size = UDim2.new(1, 0, 1, 0)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Text = "🔍"
LogoIcon.TextSize = 20
LogoIcon.Parent = LogoFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -100, 0, 20)
TitleLabel.Position = UDim2.new(0, 54, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Yuszx Search"
TitleLabel.TextColor3 = C.TEXT
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(1, -100, 0, 16)
SubtitleLabel.Position = UDim2.new(0, 54, 0, 22)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "Multi-engine search"
SubtitleLabel.TextColor3 = C.TEXT_DIM
SubtitleLabel.Font = Enum.Font.GothamMedium
SubtitleLabel.TextSize = 10
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -34, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 28)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 140, 140)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(80, 20, 30) }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(40, 20, 28) }):Play()
end)

-- ============================================
-- SEARCH BAR
-- ============================================
local SearchContainer = Instance.new("Frame")
SearchContainer.Size = UDim2.new(1, -32, 0, 52)
SearchContainer.Position = UDim2.new(0, 16, 0, 74)
SearchContainer.BackgroundColor3 = C.BG_ELEV
SearchContainer.BorderSizePixel = 0
SearchContainer.Parent = MainFrame

local SCCorner = Instance.new("UICorner")
SCCorner.CornerRadius = UDim.new(0, 12)
SCCorner.Parent = SearchContainer

local SCStroke = Instance.new("UIStroke")
SCStroke.Color = C.BORDER
SCStroke.Thickness = 1
SCStroke.Parent = SearchContainer

local SCPadding = Instance.new("UIPadding")
SCPadding.PaddingLeft = UDim.new(0, 14)
SCPadding.PaddingRight = UDim.new(0, 6)
SCPadding.PaddingTop = UDim.new(0, 6)
SCPadding.PaddingBottom = UDim.new(0, 6)
SCPadding.Parent = SearchContainer

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 20, 1, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextSize = 14
SearchIcon.TextColor3 = C.TEXT_SUB
SearchIcon.Parent = SearchContainer

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -120, 1, 0)
SearchBox.Position = UDim2.new(0, 28, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Cari apa aja..."
SearchBox.PlaceholderColor3 = C.TEXT_DIM
SearchBox.TextColor3 = C.TEXT
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextSize = 13
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchContainer

local SearchBtn = Instance.new("TextButton")
SearchBtn.Size = UDim2.new(0, 80, 1, 0)
SearchBtn.Position = UDim2.new(1, -80, 0, 0)
SearchBtn.BackgroundColor3 = C.ACCENT
SearchBtn.Text = "Cari"
SearchBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
SearchBtn.Font = Enum.Font.GothamBold
SearchBtn.TextSize = 12
SearchBtn.BorderSizePixel = 0
SearchBtn.AutoButtonColor = false
SearchBtn.Parent = SearchContainer

local SBCorner = Instance.new("UICorner")
SBCorner.CornerRadius = UDim.new(0, 8)
SBCorner.Parent = SearchBtn

SearchBox.Focused:Connect(function()
    TweenService:Create(SCStroke, TweenInfo.new(0.2), { Color = C.ACCENT, Transparency = 0 }):Play()
    TweenService:Create(SearchContainer, TweenInfo.new(0.2), { BackgroundColor3 = C.BG_CARD }):Play()
end)

SearchBox.FocusLost:Connect(function(enter)
    TweenService:Create(SCStroke, TweenInfo.new(0.2), { Color = C.BORDER, Transparency = 0 }):Play()
    TweenService:Create(SearchContainer, TweenInfo.new(0.2), { BackgroundColor3 = C.BG_ELEV }):Play()
    if enter then performSearch(SearchBox.Text) end
end)

SearchBtn.MouseEnter:Connect(function()
    TweenService:Create(SearchBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.ACCENT_HOVER }):Play()
end)
SearchBtn.MouseLeave:Connect(function()
    TweenService:Create(SearchBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.ACCENT }):Play()
end)

-- ============================================
-- INFO BAR
-- ============================================
local InfoBar = Instance.new("Frame")
InfoBar.Size = UDim2.new(1, -32, 0, 24)
InfoBar.Position = UDim2.new(0, 16, 0, 134)
InfoBar.BackgroundTransparency = 1
InfoBar.Parent = MainFrame

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 6, 0, 6)
StatusDot.Position = UDim2.new(0, 0, 0, 9)
StatusDot.BackgroundColor3 = C.GREEN
StatusDot.BorderSizePixel = 0
StatusDot.Parent = InfoBar

local StatusDotCorner = Instance.new("UICorner")
StatusDotCorner.CornerRadius = UDim.new(1, 0)
StatusDotCorner.Parent = StatusDot

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -100, 1, 0)
StatusLabel.Position = UDim2.new(0, 14, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready to search"
StatusLabel.TextColor3 = C.TEXT_SUB
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextTruncate = Enum.TextTruncate.AtEnd
StatusLabel.Parent = InfoBar

local CountLabel = Instance.new("TextLabel")
CountLabel.Size = UDim2.new(0, 80, 1, 0)
CountLabel.Position = UDim2.new(1, -80, 0, 0)
CountLabel.BackgroundTransparency = 1
CountLabel.Text = ""
CountLabel.TextColor3 = C.ACCENT
CountLabel.Font = Enum.Font.GothamBold
CountLabel.TextSize = 11
CountLabel.TextXAlignment = Enum.TextXAlignment.Right
CountLabel.Parent = InfoBar

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -32, 0, 1)
Divider.Position = UDim2.new(0, 16, 0, 162)
Divider.BackgroundColor3 = C.BORDER
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- ============================================
-- RESULTS
-- ============================================
local ResultsScroll = Instance.new("ScrollingFrame")
ResultsScroll.Size = UDim2.new(1, -32, 1, -230)
ResultsScroll.Position = UDim2.new(0, 16, 0, 172)
ResultsScroll.BackgroundTransparency = 1
ResultsScroll.BorderSizePixel = 0
ResultsScroll.ScrollBarThickness = 4
ResultsScroll.ScrollBarImageColor3 = C.BORDER
ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ResultsScroll.Parent = MainFrame

local ResultsLayout = Instance.new("UIListLayout")
ResultsLayout.Padding = UDim.new(0, 8)
ResultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ResultsLayout.Parent = ResultsScroll

-- Empty state
local EmptyState = Instance.new("Frame")
EmptyState.Size = UDim2.new(1, 0, 1, 0)
EmptyState.BackgroundTransparency = 1
EmptyState.Parent = ResultsScroll

local EmptyIcon = Instance.new("TextLabel")
EmptyIcon.Size = UDim2.new(1, 0, 0, 80)
EmptyIcon.Position = UDim2.new(0, 0, 0.3, -40)
EmptyIcon.BackgroundTransparency = 1
EmptyIcon.Text = "🔍"
EmptyIcon.TextSize = 60
EmptyIcon.TextTransparency = 0.5
EmptyIcon.Parent = EmptyState

local EmptyText = Instance.new("TextLabel")
EmptyText.Size = UDim2.new(1, 0, 0, 24)
EmptyText.Position = UDim2.new(0, 0, 0.3, 50)
EmptyText.BackgroundTransparency = 1
EmptyText.Text = "Mulai cari sesuatu"
EmptyText.TextColor3 = C.TEXT_SUB
EmptyText.Font = Enum.Font.GothamBold
EmptyText.TextSize = 14
EmptyText.Parent = EmptyState

local EmptySubtext = Instance.new("TextLabel")
EmptySubtext.Size = UDim2.new(1, 0, 0, 20)
EmptySubtext.Position = UDim2.new(0, 0, 0.3, 74)
EmptySubtext.BackgroundTransparency = 1
EmptySubtext.Text = "Ketik keyword di atas, tekan Enter"
EmptySubtext.TextColor3 = C.TEXT_DIM
EmptySubtext.Font = Enum.Font.GothamMedium
EmptySubtext.TextSize = 11
EmptySubtext.Parent = EmptyState

-- ============================================
-- HELPERS
-- ============================================
local isSearching = false

local function clearResults()
    for _, child in ipairs(ResultsScroll:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
end

local function decodeHTML(str)
    if not str then return "" end
    str = str:gsub("&amp;", "&"):gsub("&lt;", "<"):gsub("&gt;", ">")
    str = str:gsub("&quot;", '"'):gsub("&#x27;", "'"):gsub("&#39;", "'")
    str = str:gsub("&nbsp;", " "):gsub("&hellip;", "...")
    str = str:gsub("&#x2F;", "/"):gsub("&#x3D;", "=")
    return str
end

local function stripTags(str)
    if not str then return "" end
    return decodeHTML(str:gsub("<[^>]+>", ""))
end

local function getDomain(url)
    if not url then return "" end
    local d = url:match("^https?://([^/]+)")
    if d then return d:gsub("^www%.", "") end
    return url
end

local function showLoading()
    clearResults()
    EmptyState.Visible = false
    for i = 1, 5 do
        local skeleton = Instance.new("Frame")
        skeleton.Size = UDim2.new(1, 0, 0, 66)
        skeleton.BackgroundColor3 = C.BG_ELEV
        skeleton.BorderSizePixel = 0
        skeleton.LayoutOrder = i
        skeleton.Parent = ResultsScroll
        local skc = Instance.new("UICorner")
        skc.CornerRadius = UDim.new(0, 10)
        skc.Parent = skeleton
        local shimmer = Instance.new("Frame")
        shimmer.Size = UDim2.new(0, 200, 1, 0)
        shimmer.BackgroundColor3 = C.BG_CARD
        shimmer.BorderSizePixel = 0
        shimmer.Parent = skeleton
        local shc = Instance.new("UICorner")
        shc.CornerRadius = UDim.new(0, 10)
        shc.Parent = shimmer
        task.spawn(function()
            while shimmer.Parent do
                for x = -1, 1, 0.02 do
                    if not shimmer.Parent then break end
                    shimmer.Position = UDim2.new(x, 0, 0, 0)
                    task.wait(0.015)
                end
            end
        end)
    end
end

local function createResultCard(num, title, url)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = C.BG_ELEV
    card.Text = ""
    card.BorderSizePixel = 0
    card.AutoButtonColor = false
    card.LayoutOrder = num
    card.Parent = ResultsScroll

    local c1 = Instance.new("UICorner")
    c1.CornerRadius = UDim.new(0, 10)
    c1.Parent = card

    local c2 = Instance.new("UIStroke")
    c2.Color = C.BORDER
    c2.Thickness = 1
    c2.Transparency = 0.5
    c2.Parent = card

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 14)
    pad.PaddingRight = UDim.new(0, 14)
    pad.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = card

    local row1 = Instance.new("Frame")
    row1.Size = UDim2.new(1, 0, 0, 18)
    row1.BackgroundTransparency = 1
    row1.LayoutOrder = 1
    row1.Parent = card

    local numLabel = Instance.new("TextLabel")
    numLabel.Size = UDim2.new(0, 22, 1, 0)
    numLabel.BackgroundColor3 = C.ACCENT
    numLabel.Text = tostring(num)
    numLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    numLabel.Font = Enum.Font.GothamBold
    numLabel.TextSize = 10
    numLabel.Parent = row1

    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 4)
    nc.Parent = numLabel

    local domainLabel = Instance.new("TextLabel")
    domainLabel.Size = UDim2.new(1, -30, 1, 0)
    domainLabel.Position = UDim2.new(0, 28, 0, 0)
    domainLabel.BackgroundTransparency = 1
    domainLabel.Text = getDomain(url)
    domainLabel.TextColor3 = C.GREEN
    domainLabel.Font = Enum.Font.GothamMedium
    domainLabel.TextSize = 10
    domainLabel.TextXAlignment = Enum.TextXAlignment.Left
    domainLabel.Parent = row1

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 0)
    titleLabel.AutomaticSize = Enum.AutomaticSize.Y
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = C.TEXT
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextWrapped = true
    titleLabel.LayoutOrder = 2
    titleLabel.Parent = card

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, 0, 0, 14)
    hint.BackgroundTransparency = 1
    hint.Text = "📋 Tap untuk copy link"
    hint.TextColor3 = C.TEXT_DIM
    hint.Font = Enum.Font.GothamMedium
    hint.TextSize = 9
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.LayoutOrder = 3
    hint.Parent = card

    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = C.BG_CARD_HOVER }):Play()
        TweenService:Create(c2, TweenInfo.new(0.15), { Color = C.ACCENT, Transparency = 0.3 }):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = C.BG_ELEV }):Play()
        TweenService:Create(c2, TweenInfo.new(0.15), { Color = C.BORDER, Transparency = 0.5 }):Play()
    end)

    card.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(url)
            StatusLabel.Text = "✅ Link dicopy!"
            StatusLabel.TextColor3 = C.GREEN
            TweenService:Create(card, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(0, 80, 50) }):Play()
            task.wait(0.4)
            TweenService:Create(card, TweenInfo.new(0.2), { BackgroundColor3 = C.BG_ELEV }):Play()
        else
            StatusLabel.Text = "❌ setclipboard gak support"
            StatusLabel.TextColor3 = C.RED
        end
    end)
end

-- ============================================
-- 🚀 PERFORM SEARCH
-- ============================================
function performSearch(query)
    if isSearching then return end
    if query == "" or query:match("^%s*$") then
        StatusLabel.Text = "⚠️ Ketik keyword dulu!"
        StatusLabel.TextColor3 = C.YELLOW
        StatusDot.BackgroundColor3 = C.YELLOW
        return
    end

    isSearching = true
    CountLabel.Text = ""
    StatusLabel.Text = "Mencari..."
    StatusLabel.TextColor3 = C.ACCENT
    StatusDot.BackgroundColor3 = C.YELLOW

    showLoading()

    task.spawn(function()
        local encodedQuery = HttpService:UrlEncode(query)
        local results = {}
        local usedEngine = nil
        local lastError = ""

        -- Coba setiap engine satu-satu
        for _, engine in ipairs(ENGINES) do
            StatusLabel.Text = "🔍 Coba " .. engine.name .. "..."
            
            local url = engine.url .. encodedQuery
            local response, method = fetchURL(url)
            
            if response and #response > 100 then
                -- Parse results
                local tempResults = {}
                for link, title in response:gmatch(engine.parsePattern) do
                    if #tempResults >= MAX_RESULTS then break end
                    title = stripTags(title)
                    
                    -- Decode URL kalau perlu
                    if engine.decodeURL and link:find("uddg=") then
                        local d = link:match("uddg=([^&]+)")
                        if d then link = HttpService:UrlDecode(d) end
                    end
                    
                    if link:find("^//") then link = "https:" .. link end
                    
                    if link and title and #title > 3 and link:find("^https?://") then
                        table.insert(tempResults, { title = title, url = link })
                    end
                end
                
                if #tempResults > 0 then
                    results = tempResults
                    usedEngine = engine.name .. " (" .. method .. ")"
                    break
                else
                    lastError = engine.name .. ": 0 hasil"
                end
            else
                lastError = engine.name .. ": gagal fetch (" .. method .. ")"
            end
        end

        clearResults()

        if #results == 0 then
            EmptyState.Visible = true
            StatusLabel.Text = "❌ Gagal. " .. (lastError or "Semua engine failed")
            StatusLabel.TextColor3 = C.RED
            StatusDot.BackgroundColor3 = C.RED
            isSearching = false
            return
        end

        for i, r in ipairs(results) do
            createResultCard(i, r.title, r.url)
        end

        StatusLabel.Text = "✅ " .. #results .. " hasil • " .. (usedEngine or "")
        StatusLabel.TextColor3 = C.TEXT_SUB
        StatusDot.BackgroundColor3 = C.GREEN
        CountLabel.Text = #results .. " hasil"

        task.wait(0.1)
        ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, ResultsLayout.AbsoluteContentSize.Y + 20)
        isSearching = false
    end)
end

-- Events
SearchBtn.MouseButton1Click:Connect(function() performSearch(SearchBox.Text) end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ============================================
-- AUTO-RESPONSIVE
-- ============================================
local lastVP = Camera.ViewportSize

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local vp = Camera.ViewportSize
    if vp == lastVP then return end
    lastVP = vp
    task.wait(0.1)
    local w, h = getOptimalSize()
    MainFrame.Size = UDim2.new(0, w, 0, h)
    MainFrame.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
end)

-- Auto focus
task.wait(0.3)
pcall(function() SearchBox:CaptureFocus() end)

print("[Yuszx] 🔍 Full Fix Search loaded!")
