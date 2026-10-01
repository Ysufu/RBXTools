--[[
    ═══════════════════════════════════════════════════════════════
    🔍 YUSZX SEARCH — Professional Edition
    ═══════════════════════════════════════════════════════════════
    ✅ Modern clean UI
    ✅ Smooth animations
    ✅ Better typography
    ✅ Loading states
    ✅ Empty states
    ✅ Hover effects
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

-- ============================================
-- CONFIG
-- ============================================
local ENGINE_URL = "https://html.duckduckgo.com/html/?q="
local MAX_RESULTS = 20

-- ============================================
-- COLOR PALETTE (Modern Dark)
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
}

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
MainFrame.Size = UDim2.new(0, 540, 0, 620)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -310)
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

-- Subtle top gradient glow
local TopGlow = Instance.new("Frame")
TopGlow.Size = UDim2.new(1, 0, 0, 2)
TopGlow.Position = UDim2.new(0, 0, 0, 0)
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

-- Animate top glow
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
Header.Position = UDim2.new(0, 0, 0, 2)
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

-- Logo
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 40, 0, 40)
LogoFrame.Position = UDim2.new(0, 0, 0, 0)
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

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -160, 0, 20)
TitleLabel.Position = UDim2.new(0, 54, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Yuszx Search"
TitleLabel.TextColor3 = C.TEXT
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Subtitle
local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(1, -160, 0, 16)
SubtitleLabel.Position = UDim2.new(0, 54, 0, 22)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "Powered by DuckDuckGo"
SubtitleLabel.TextColor3 = C.TEXT_DIM
SubtitleLabel.Font = Enum.Font.GothamMedium
SubtitleLabel.TextSize = 10
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.Parent = Header

-- Close button
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
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(80, 20, 30)
    }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 20, 28)
    }):Play()
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
SearchIcon.Position = UDim2.new(0, 0, 0, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextSize = 14
SearchIcon.TextColor3 = C.TEXT_SUB
SearchIcon.Parent = SearchContainer

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -110, 1, 0)
SearchBox.Position = UDim2.new(0, 28, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Cari apa aja di internet..."
SearchBox.PlaceholderColor3 = C.TEXT_DIM
SearchBox.TextColor3 = C.TEXT
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextSize = 13
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchContainer

local SearchBtn = Instance.new("TextButton")
SearchBtn.Size = UDim2.new(0, 90, 1, 0)
SearchBtn.Position = UDim2.new(1, -90, 0, 0)
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

-- ============================================
-- SEARCH BAR FOCUS ANIMATIONS
-- ============================================
SearchBox.Focused:Connect(function()
    TweenService:Create(SCStroke, TweenInfo.new(0.2), {
        Color = C.ACCENT,
        Transparency = 0
    }):Play()
    TweenService:Create(SearchContainer, TweenInfo.new(0.2), {
        BackgroundColor3 = C.BG_CARD
    }):Play()
end)

SearchBox.FocusLost:Connect(function(enter)
    TweenService:Create(SCStroke, TweenInfo.new(0.2), {
        Color = C.BORDER,
        Transparency = 0
    }):Play()
    TweenService:Create(SearchContainer, TweenInfo.new(0.2), {
        BackgroundColor3 = C.BG_ELEV
    }):Play()
    if enter then
        performSearch(SearchBox.Text)
    end
end)

SearchBtn.MouseEnter:Connect(function()
    TweenService:Create(SearchBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = C.ACCENT_HOVER
    }):Play()
end)
SearchBtn.MouseLeave:Connect(function()
    TweenService:Create(SearchBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = C.ACCENT
    }):Play()
end)

-- ============================================
-- INFO BAR (Status + Count)
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

-- ============================================
-- DIVIDER
-- ============================================
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -32, 0, 1)
Divider.Position = UDim2.new(0, 16, 0, 162)
Divider.BackgroundColor3 = C.BORDER
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- ============================================
-- RESULTS CONTAINER
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

-- ============================================
-- EMPTY STATE
-- ============================================
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
EmptySubText = Instance.new("TextLabel")
EmptySubText.Size = UDim2.new(1, 0, 0, 20)
EmptySubText.Position = UDim2.new(0, 0, 0.3, 74)
EmptySubText.BackgroundTransparency = 1
EmptySubText.Text = "Ketik keyword di atas, tekan Enter"
EmptySubText.TextColor3 = C.TEXT_DIM
EmptySubText.Font = Enum.Font.GothamMedium
EmptySubText.TextSize = 11
EmptySubText.Parent = EmptyState

-- ============================================
-- SEARCH LOGIC
-- ============================================
local isSearching = false

local function clearResults()
    for _, child in ipairs(ResultsScroll:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

local function decodeHTML(str)
    if not str then return "" end
    str = str:gsub("&amp;", "&")
    str = str:gsub("&lt;", "<")
    str = str:gsub("&gt;", ">")
    str = str:gsub("&quot;", '"')
    str = str:gsub("&#x27;", "'")
    str = str:gsub("&#39;", "'")
    str = str:gsub("&nbsp;", " ")
    str = str:gsub("&hellip;", "...")
    str = str:gsub("&#x2F;", "/")
    str = str:gsub("&#x3D;", "=")
    return str
end

local function stripTags(str)
    if not str then return "" end
    str = str:gsub("<[^>]+>", "")
    return decodeHTML(str)
end

local function fetch(url)
    local methods = {
        function() return game:HttpGet(url, true) end,
        function() return request({ Url = url, Method = "GET" }).Body end,
        function() return http_request({ Url = url, Method = "GET" }).Body end,
    }
    for _, method in ipairs(methods) do
        local ok, result = pcall(method)
        if ok and result and #result > 0 then return result end
    end
    return nil
end

-- Get domain from URL
local function getDomain(url)
    if not url then return "" end
    local domain = url:match("^https?://([^/]+)")
    if domain then
        domain = domain:gsub("^www%.", "")
        return domain
    end
    return url
end

-- Show loading skeleton
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
        
        local skCorner = Instance.new("UICorner")
        skCorner.CornerRadius = UDim.new(0, 10)
        skCorner.Parent = skeleton
        
        -- Shimmer
        local shimmer = Instance.new("Frame")
        shimmer.Size = UDim2.new(0, 200, 1, 0)
        shimmer.BackgroundColor3 = C.BG_CARD
        shimmer.BorderSizePixel = 0
        shimmer.Parent = skeleton
        
        local shimmerCorner = Instance.new("UICorner")
        shimmerCorner.CornerRadius = UDim.new(0, 10)
        shimmerCorner.Parent = shimmer
        
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

-- Create result card
local function createResultCard(num, title, url, snippet)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = C.BG_ELEV
    card.Text = ""
    card.BorderSizePixel = 0
    card.AutoButtonColor = false
    card.LayoutOrder = num
    card.Parent = ResultsScroll
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card
    
    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = C.BORDER
    cardStroke.Thickness = 1
    cardStroke.Transparency = 0.5
    cardStroke.Parent = card
    
    local cardPad = Instance.new("UIPadding")
    cardPad.PaddingTop = UDim.new(0, 10)
    cardPad.PaddingBottom = UDim.new(0, 10)
    cardPad.PaddingLeft = UDim.new(0, 14)
    cardPad.PaddingRight = UDim.new(0, 14)
    cardPad.Parent = card
    
    local cardLayout = Instance.new("UIListLayout")
    cardLayout.Padding = UDim.new(0, 4)
    cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cardLayout.Parent = card
    
    -- Row 1: Number + Domain
    local row1 = Instance.new("Frame")
    row1.Size = UDim2.new(1, 0, 0, 18)
    row1.BackgroundTransparency = 1
    row1.LayoutOrder = 1
    row1.Parent = card
    
    local numLabel = Instance.new("TextLabel")
    numLabel.Size = UDim2.new(0, 22, 1, 0)
    numLabel.Position = UDim2.new(0, 0, 0, 0)
    numLabel.BackgroundColor3 = C.ACCENT
    numLabel.Text = tostring(num)
    numLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    numLabel.Font = Enum.Font.GothamBold
    numLabel.TextSize = 10
    numLabel.Parent = row1
    
    local numCorner = Instance.new("UICorner")
    numCorner.CornerRadius = UDim.new(0, 4)
    numCorner.Parent = numLabel
    
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
    
    -- Row 2: Title
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
    
    -- Row 3: Snippet
    if snippet and #snippet > 5 then
        local snippetLabel = Instance.new("TextLabel")
        snippetLabel.Size = UDim2.new(1, 0, 0, 0)
        snippetLabel.AutomaticSize = Enum.AutomaticSize.Y
        snippetLabel.BackgroundTransparency = 1
        snippetLabel.Text = snippet
        snippetLabel.TextColor3 = C.TEXT_SUB
        snippetLabel.Font = Enum.Font.GothamMedium
        snippetLabel.TextSize = 11
        snippetLabel.TextXAlignment = Enum.TextXAlignment.Left
        snippetLabel.TextWrapped = true
        snippetLabel.LayoutOrder = 3
        snippetLabel.Parent = card
    end
    
    -- Row 4: Action hint
    local actionHint = Instance.new("TextLabel")
    actionHint.Size = UDim2.new(1, 0, 0, 14)
    actionHint.BackgroundTransparency = 1
    actionHint.Text = "📋 Tap untuk copy link"
    actionHint.TextColor3 = C.TEXT_DIM
    actionHint.Font = Enum.Font.GothamMedium
    actionHint.TextSize = 9
    actionHint.TextXAlignment = Enum.TextXAlignment.Left
    actionHint.LayoutOrder = 4
    actionHint.Parent = card
    
    -- Hover
    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {
            BackgroundColor3 = C.BG_CARD_HOVER
        }):Play()
        TweenService:Create(cardStroke, TweenInfo.new(0.15), {
            Color = C.ACCENT,
            Transparency = 0.3
        }):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {
            BackgroundColor3 = C.BG_ELEV
        }):Play()
        TweenService:Create(cardStroke, TweenInfo.new(0.15), {
            Color = C.BORDER,
            Transparency = 0.5
        }):Play()
    end)
    
    -- Click to copy
    card.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(url)
            StatusLabel.Text = "✅ Link dicopy ke clipboard!"
            StatusLabel.TextColor3 = C.GREEN
            
            TweenService:Create(card, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 80, 50)
            }):Play()
            task.wait(0.4)
            TweenService:Create(card, TweenInfo.new(0.2), {
                BackgroundColor3 = C.BG_ELEV
            }):Play()
        else
            StatusLabel.Text = "❌ setclipboard gak support"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    return card
end

-- ============================================
-- PERFORM SEARCH
-- ============================================
function performSearch(query)
    if isSearching then return end
    if query == "" or query:match("^%s*$") then
        StatusLabel.Text = "⚠️ Ketik keyword dulu!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        return
    end
    
    isSearching = true
    CountLabel.Text = ""
    StatusLabel.Text = "Mencari..."
    StatusLabel.TextColor3 = C.ACCENT
    StatusDot.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    
    showLoading()
    
    task.spawn(function()
        local url = ENGINE_URL .. HttpService:UrlEncode(query)
        local response = fetch(url)
        
        if not response then
            clearResults()
            EmptyState.Visible = true
            StatusLabel.Text = "❌ Gagal akses. Cek koneksi internet."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            StatusDot.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            isSearching = false
            return
        end
        
        clearResults()
        
        local count = 0
        local results = {}
        
        -- Parse results
        for link, title in response:gmatch('<a[^>]*class="result__a"[^>]*href="([^"]+)"[^>]*>(.-)</a>') do
            if count >= MAX_RESULTS then break end
            
            title = stripTags(title)
            
            -- Decode URL
            if link:find("uddg=") then
                local decoded = link:match("uddg=([^&]+)")
                if decoded then link = HttpService:UrlDecode(decoded) end
            end
            if link:find("^//") then link = "https:" .. link end
            
            -- Try to find snippet near this link
            local snippet = ""
            local linkPos = response:find(link:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"), 1, true)
            
            if link and title and #title > 3 and link:find("^https?://") then
                count = count + 1
                table.insert(results, {
                    num = count,
                    title = title,
                    url = link,
                    snippet = snippet
                })
            end
        end
        
        if count == 0 then
            EmptyState.Visible = true
            StatusLabel.Text = "❌ Gak ada hasil. Coba keyword lain."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
            StatusDot.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        else
            for _, r in ipairs(results) do
                createResultCard(r.num, r.title, r.url, r.snippet)
            end
            
            StatusLabel.Text = "Hasil untuk: " .. query
            StatusLabel.TextColor3 = C.TEXT_SUB
            StatusDot.BackgroundColor3 = C.GREEN
            CountLabel.Text = count .. " hasil"
            
            task.wait(0.1)
            ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, ResultsLayout.AbsoluteContentSize.Y + 20)
        end
        
        isSearching = false
    end)
end

-- ============================================
-- EVENT HANDLERS
-- ============================================
SearchBtn.MouseButton1Click:Connect(function()
    performSearch(SearchBox.Text)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Auto focus search box
task.wait(0.3)
pcall(function() SearchBox:CaptureFocus() end)

print("[Yuszx] 🔍 Professional Search loaded!")
