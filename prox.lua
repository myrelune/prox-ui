local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PROX"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ProxUI = {}

ProxUI._configFolder = nil
ProxUI._configFile = nil
ProxUI._configData = {}

local function makeConfigKey(str)
    return str:gsub("[^%w_]", ""):lower()
end

local function tryGetHui()
    local success, result = pcall(function()
        -- Check if gethui exists and returns a valid instance
        local hui = gethui and gethui()
        return hui and hui:IsA("Instance") and hui
    end)
    return success and result or nil
end

local hui = tryGetHui()
local screenGui.Parent = hui or playerGui

function ProxUI:CreateWindow(title)
    local self = {}

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = UDim2.new(0, 720, 0, 500)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = mainFrame

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.85
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame

    mainFrame.ZIndex = 1

    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Text = title or "Window"
    titleBar.TextSize = 14
    titleBar.Font = Enum.Font.SourceSansBold
    titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.Parent = mainFrame

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -28, 0, 3)
    closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "X"
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = mainFrame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton

    local collapsedButton = Instance.new("TextButton")
    collapsedButton.Name = "CollapsedButton"
    collapsedButton.Size = UDim2.new(0, 100, 0, 30)
    collapsedButton.Position = UDim2.new(0, 10, 1, -40)
    collapsedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    collapsedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    collapsedButton.Text = "Open UI"
    collapsedButton.TextSize = 14
    collapsedButton.Font = Enum.Font.SourceSansBold
    collapsedButton.BorderSizePixel = 0
    collapsedButton.Visible = false
    collapsedButton.Parent = screenGui

    local collapsedCorner = Instance.new("UICorner")
    collapsedCorner.CornerRadius = UDim.new(0, 6)
    collapsedCorner.Parent = collapsedButton

    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        collapsedButton.Visible = true
    end)

    collapsedButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        collapsedButton.Visible = false
    end)

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == Enum.KeyCode.U then
            local visible = not mainFrame.Visible
            mainFrame.Visible = visible
            collapsedButton.Visible = not visible
        end
    end)

    local dragging = false
    local dragStart, startPos

    local function update(input)
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(update)

    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.Position = UDim2.new(0, 0, 0, 30)
    tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabBar.BorderSizePixel = 0
    tabBar.ScrollBarThickness = 4
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBar.ScrollingDirection = Enum.ScrollingDirection.X
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBar.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabBar

    local dividerLeft = Instance.new("Frame")
    dividerLeft.Name = "DividerLeft"
    dividerLeft.Size = UDim2.new(1, 0, 0, 2)
    dividerLeft.Position = UDim2.new(0, 0, 0, 60)
    dividerLeft.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    dividerLeft.BorderSizePixel = 0
    dividerLeft.Parent = mainFrame

    local dividerRight = Instance.new("Frame")
    dividerRight.Name = "DividerRight"
    dividerRight.Size = UDim2.new(1, 0, 0, 2)
    dividerRight.Position = UDim2.new(0, 0, 0, 60)
    dividerRight.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    dividerRight.BorderSizePixel = 0
    dividerRight.Parent = mainFrame

    local selectionBorder = Instance.new("Frame")
    selectionBorder.Name = "SelectionBorder"
    selectionBorder.BackgroundTransparency = 1
    selectionBorder.Size = UDim2.new(0, 0, 0, 0)
    selectionBorder.Position = UDim2.new(0, 0, 0, 0)
    selectionBorder.Parent = mainFrame

    local leftLine = Instance.new("Frame")
    leftLine.Size = UDim2.new(0, 1, 1, 2)
    leftLine.Position = UDim2.new(0, 0, 0, -1)
    leftLine.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    leftLine.BorderSizePixel = 0
    leftLine.Parent = selectionBorder

    local topLine = Instance.new("Frame")
    topLine.Size = UDim2.new(1, 0, 0, 1)
    topLine.Position = UDim2.new(0, 0, 0, 0)
    topLine.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    topLine.BorderSizePixel = 0
    topLine.Parent = selectionBorder

    local rightLine = Instance.new("Frame")
    rightLine.Size = UDim2.new(0, 1, 1, 2)
    rightLine.Position = UDim2.new(1, -1, 0, -1)
    rightLine.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    rightLine.BorderSizePixel = 0
    rightLine.Parent = selectionBorder

    selectionBorder.Visible = false

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, 0, 1, -62)
    tabContent.Position = UDim2.new(0, 0, 0, 62)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 6
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.ScrollingDirection = Enum.ScrollingDirection.Y
    tabContent.ClipsDescendants = true
    tabContent.Parent = mainFrame

    local tabs = {}
    local activeTab = nil

    function self:AddTab(name)
        local tab = {}

        local button = Instance.new("TextButton")
        button.Name = name .. "_Button"
        button.Size = UDim2.new(0, 100, 1, 0)
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.SourceSans
        button.Text = name
        button.BorderSizePixel = 0
        button.AutoButtonColor = false
        button.Parent = tabBar
        button.TextWrapped = true
        button.TextScaled = false
        button.TextYAlignment = Enum.TextYAlignment.Center
        button.ClipsDescendants = true

        button.MouseEnter:Connect(function()
            if activeTab == nil or activeTab.Button ~= button then
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end)

        button.MouseLeave:Connect(function()
            if activeTab == nil or activeTab.Button ~= button then
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
        end)

        local content = Instance.new("Frame")
        content.Name = name .. "_Content"
        content.Size = UDim2.new(1, 0, 1, 0)
        content.Position = UDim2.new(0, 0, 0, 0)
        content.BackgroundTransparency = 1
        content.Visible = false
        content.Parent = tabContent

        local layoutContainer = Instance.new("Frame")
        layoutContainer.Name = "LayoutContainer"
        layoutContainer.Size = UDim2.new(1, 0, 1, 0)
        layoutContainer.BackgroundTransparency = 1
        layoutContainer.BorderSizePixel = 0
        layoutContainer.AutomaticSize = Enum.AutomaticSize.Y
        layoutContainer.Parent = content

        local verticalLayout = Instance.new("UIListLayout")
        verticalLayout.SortOrder = Enum.SortOrder.LayoutOrder
        verticalLayout.Padding = UDim.new(0, 8)
        verticalLayout.Parent = layoutContainer

        tab.Frame = content
        tab.Button = button
        tab._pendingHalf = nil

        function tab:CreateHalf()
            local container = tab._pendingHalf
        
            if not container then
                container = Instance.new("Frame")
                container.Size = UDim2.new(1, -24, 0, 0)
                container.Position = UDim2.new(0, 12, 0, 0)
                container.BackgroundTransparency = 1
                container.AutomaticSize = Enum.AutomaticSize.Y
                container.BorderSizePixel = 0
                container.Parent = layoutContainer
        
                local rowLayout = Instance.new("UIListLayout")
                rowLayout.FillDirection = Enum.FillDirection.Horizontal
                rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
                rowLayout.Padding = UDim.new(0, 12)
                rowLayout.Parent = container
        
                tab._pendingHalf = container
            end
        
            local element = Instance.new("Frame")
            element.Size = UDim2.new(0.5, -6, 0, 0)
            element.AutomaticSize = Enum.AutomaticSize.Y
            element.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            element.BorderSizePixel = 0
            element.Parent = container
        
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = element
        
            local contentFrame = Instance.new("Frame")
            contentFrame.Size = UDim2.new(1, -24, 0, 0)
            contentFrame.Position = UDim2.new(0, 12, 0, 0)
            contentFrame.BackgroundTransparency = 1
            contentFrame.AutomaticSize = Enum.AutomaticSize.Y
            contentFrame.Parent = element
        
            local gridFrame = Instance.new("Frame")
            gridFrame.Size = UDim2.new(1, 0, 0, 0)
            gridFrame.AutomaticSize = Enum.AutomaticSize.Y
            gridFrame.BackgroundTransparency = 1
            gridFrame.Parent = contentFrame
        
            local gridLayout = Instance.new("UIGridLayout")
            gridLayout.CellSize = UDim2.new(1, 0, 0, 28)
            gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
            gridLayout.FillDirection = Enum.FillDirection.Vertical
            gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
            gridLayout.Parent = gridFrame
        
            local padding = Instance.new("UIPadding")
            padding.PaddingTop = UDim.new(0, 12)
            padding.PaddingBottom = UDim.new(0, 12)
            padding.PaddingLeft = UDim.new(0, 12)
            padding.PaddingRight = UDim.new(0, 12)
            padding.Parent = contentFrame
        
            local count = 0
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Frame") then count += 1 end
            end
            if count >= 2 then
                tab._pendingHalf = nil
            
                local divider = Instance.new("Frame")
                divider.Size = UDim2.new(1, -24, 0, 1)
                divider.Position = UDim2.new(0, 12, 0, 0)
                divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                divider.BackgroundTransparency = 0.5
                divider.BorderSizePixel = 0
                divider.Parent = layoutContainer
            end
        
            local api = {}
        
            function api:AddToggle(text, callback)
                return tab:AddToggle(text, callback, gridFrame)
            end
        
            function api:AddButton(text, callback)
                return tab:AddButton(text, callback, gridFrame)
            end
        
            function api:AddValueBox(label, min, max, callback)
                return tab:AddValueBox(label, min, max, callback, gridFrame)
            end

            function api:AddDropdown(title, options, callback, multiSelect)
                return tab:AddDropdown(title, options, callback, multiSelect, gridFrame)
            end
        
            return api
        end

        function tab:CreateFull()
            tab._pendingHalf = nil
        
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -24, 0, 0)
            container.Position = UDim2.new(0, 12, 0, 0)
            container.BackgroundTransparency = 1
            container.AutomaticSize = Enum.AutomaticSize.Y
            container.BorderSizePixel = 0
            container.Parent = layoutContainer
        
            local element = Instance.new("Frame")
            element.Size = UDim2.new(1, 0, 0, 0)
            element.AutomaticSize = Enum.AutomaticSize.Y
            element.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            element.BorderSizePixel = 0
            element.Parent = container
        
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = element
        
            local contentFrame = Instance.new("Frame")
            contentFrame.Size = UDim2.new(1, -24, 0, 0)
            contentFrame.Position = UDim2.new(0, 12, 0, 0)
            contentFrame.BackgroundTransparency = 1
            contentFrame.AutomaticSize = Enum.AutomaticSize.Y
            contentFrame.Parent = element
        
            local gridFrame = Instance.new("Frame")
            gridFrame.Size = UDim2.new(1, 0, 0, 0)
            gridFrame.AutomaticSize = Enum.AutomaticSize.Y
            gridFrame.BackgroundTransparency = 1

            local paddedFrame = Instance.new("Frame")
            paddedFrame.Size = UDim2.new(1, 0, 0, 0)
            paddedFrame.AutomaticSize = Enum.AutomaticSize.Y
            paddedFrame.BackgroundTransparency = 1
            paddedFrame.Parent = contentFrame

            local innerPadding = Instance.new("UIPadding")
            innerPadding.PaddingLeft = UDim.new(0, 12)
            innerPadding.PaddingRight = UDim.new(0, 12)
            innerPadding.Parent = paddedFrame

            gridFrame.Parent = paddedFrame
        
            local gridLayout = Instance.new("UIGridLayout")
            gridLayout.CellSize = UDim2.new(1/3, -28, 0, 28)
            gridLayout.CellPadding = UDim2.new(0, 28, 0, 12)
            gridLayout.FillDirection = Enum.FillDirection.Horizontal
            gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            gridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
            gridLayout.Parent = gridFrame
        
            local padding = Instance.new("UIPadding")
            padding.PaddingTop = UDim.new(0, 12)
            padding.PaddingBottom = UDim.new(0, 12)
            padding.PaddingLeft = UDim.new(0, 12)
            padding.PaddingRight = UDim.new(0, 12)
            padding.Parent = contentFrame
        
            local api = {}
        
            function api:AddToggle(text, callback)
                return tab:AddToggle(text, callback, gridFrame)
            end
        
            function api:AddButton(text, callback)
                return tab:AddButton(text, callback, gridFrame)
            end
        
            function api:AddValueBox(label, min, max, callback)
                return tab:AddValueBox(label, min, max, callback, gridFrame)
            end

            function api:AddDropdown(title, options, callback, multiSelect)
                return tab:AddDropdown(title, options, callback, multiSelect, gridFrame)
            end

            local divider = Instance.new("Frame")
            divider.Size = UDim2.new(1, -24, 0, 1)
            divider.Position = UDim2.new(0, 12, 0, 0)
            divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            divider.BorderSizePixel = 0
            divider.BackgroundTransparency = 0.5
            divider.Parent = layoutContainer
        
            return api
        end

        function tab:AddToggle(text, callback, target)
            local parent = target or layoutContainer
        
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 28)
            container.BackgroundTransparency = 1
            container.Parent = parent
        
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, -10, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.SourceSans
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = container
            label.TextWrapped = true
            label.TextScaled = false
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.ClipsDescendants = true
        
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(0, 36, 0, 18)
            toggle.Position = UDim2.new(1, -40, 0.5, -9)
            toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggle.Text = ""
            toggle.AutoButtonColor = false
            toggle.Parent = container
        
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggle
        
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(100, 100, 100)
            stroke.Thickness = 1
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = toggle
        
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = UDim2.new(0, 0, 0, 1)
            knob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            knob.Parent = toggle
        
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob
        
            local stateKey = makeConfigKey(text)

            local state = false
            if ProxUI._configData and typeof(ProxUI._configData[stateKey]) == "boolean" then
                state = ProxUI._configData[stateKey]
            end
        
            local onColor = Color3.fromRGB(145, 150, 180)
            local offColor = Color3.fromRGB(50, 50, 50)
        
            local function updateVisual()
                TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                    Position = state and UDim2.new(1, -17, 0, 1) or UDim2.new(0, 1, 0, 1)
                }):Play()
        
                TweenService:Create(toggle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = state and onColor or offColor
                }):Play()
            end
        
            local function set(val)
                state = val
                updateVisual()
                if callback then callback(val) end
        
                if ProxUI._configData then
                    ProxUI._configData[stateKey] = state
                    ProxUI:_SaveConfig()
                end
            end
        
            toggle.MouseButton1Click:Connect(function()
                set(not state)
            end)
        
            set(state)
        
            return {
                Get = function() return state end,
                Set = set
            }
        end

        function tab:AddButton(text, callback, target)
            local parent = target or layoutContainer
        
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 28)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            button.TextColor3 = Color3.fromRGB(220, 220, 220)
            button.Font = Enum.Font.SourceSans
            button.TextSize = 14
            button.Text = text
            button.TextXAlignment = Enum.TextXAlignment.Left
            button.AutoButtonColor = true
            button.TextWrapped = true
            button.TextScaled = false
            button.TextYAlignment = Enum.TextYAlignment.Center
            button.ClipsDescendants = true
            button.Parent = parent
        
            local padding = Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, 8)
            padding.Parent = button
        
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = button
        
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(100, 100, 100)
            stroke.Thickness = 1
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = button
        
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -20, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "→"
            arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
            arrow.TextSize = 14
            arrow.Font = Enum.Font.SourceSans
            arrow.Parent = button
        
            button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
        
            return button
        end

        function tab:AddValueBox(title, min, max, callback, target)
            local parent = target or layoutContainer
        
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 28)
            container.BackgroundTransparency = 1
            container.Parent = parent
        
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, -12, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.SourceSans
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = title
            label.Parent = container
            label.TextWrapped = true
            label.TextScaled = false
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.ClipsDescendants = true
        
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0.5, 0, 1, 0)
            box.Position = UDim2.new(0.5, 0, 0, 0)
            box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.Font = Enum.Font.SourceSans
            box.TextSize = 14
            box.ClearTextOnFocus = true
            box.Parent = container
        
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = box
        
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(100, 100, 100)
            stroke.Thickness = 1
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = box
        
            local stateKey = makeConfigKey(title)
            local value = nil
            
            if ProxUI._configData and typeof(ProxUI._configData[stateKey]) == "number" then
                value = math.clamp(ProxUI._configData[stateKey], min, max)
                box.Text = tostring(value)
                if callback then callback(value) end
            else
                box.Text = tostring(min) .. " - " .. tostring(max)
            end
        
            box.FocusLost:Connect(function(enterPressed)
                if not enterPressed then return end
                local n = tonumber(box.Text)
                if n then
                    n = math.clamp(n, min, max)
                    value = n
                    box.Text = tostring(value)
                    if callback then callback(value) end
        
                    if ProxUI._configData then
                        ProxUI._configData[stateKey] = value
                        ProxUI:_SaveConfig()
                    end
                else
                    box.Text = tostring(min) .. " - " .. tostring(max)
                end
            end)
        
            return {
                Get = function() return value end,
                Set = function(v)
                    value = math.clamp(v, min, max)
                    box.Text = tostring(value)
                    if callback then callback(value) end
        
                    if ProxUI._configData then
                        ProxUI._configData[stateKey] = value
                        ProxUI:_SaveConfig()
                    end
                end
            }
        end

        function tab:AddDropdown(title, options, callback, multiSelect, target)
            local parent = target or layoutContainer
            
            local selected = {}
            local isOpen = false
            local isAnimating = false
        
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 28)
            container.BackgroundTransparency = 1
            container.Parent = parent
        
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 28)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            button.TextColor3 = Color3.fromRGB(220, 220, 220)
            button.Text = title
            button.Font = Enum.Font.SourceSans
            button.TextSize = 14
            button.TextXAlignment = Enum.TextXAlignment.Left
            button.AutoButtonColor = false
            button.ClipsDescendants = true
            button.Parent = container
        
            local padding = Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, 8)
            padding.Parent = button
        
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -20, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
            arrow.TextSize = 14
            arrow.Font = Enum.Font.SourceSans
            arrow.Parent = button
        
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = button
        
            local dropdownHolder = Instance.new("Frame")
            dropdownHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            dropdownHolder.BorderSizePixel = 0
            dropdownHolder.Size = UDim2.new(1, 0, 0, 0)
            dropdownHolder.Position = UDim2.new(0, 0, 1, 0)
            dropdownHolder.ClipsDescendants = false
            dropdownHolder.Visible = false
            dropdownHolder.ZIndex = 100
            dropdownHolder.Parent = container
        
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 6)
            dropdownCorner.Parent = dropdownHolder
        
            local dropdownLayout = Instance.new("UIListLayout")
            dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownLayout.Padding = UDim.new(0, 4)
            dropdownLayout.Parent = dropdownHolder
        
            local dropdownPadding = Instance.new("UIPadding")
            dropdownPadding.PaddingLeft = UDim.new(0, 8)
            dropdownPadding.PaddingRight = UDim.new(0, 8)
            dropdownPadding.PaddingTop = UDim.new(0, 4)
            dropdownPadding.Parent = dropdownHolder
        
            local stateKey = makeConfigKey(title)
        
            -- Load from config
            if ProxUI._configData then
                local saved = ProxUI._configData[stateKey]
                if multiSelect and typeof(saved) == "table" then
                    selected = saved
                elseif not multiSelect and typeof(saved) == "string" then
                    selected = {saved}
                end
            end
        
            local function updateText()
                if #selected == 0 then
                    button.Text = title
                elseif #selected > 1 then
                    button.Text = "Selected " .. tostring(#selected) .. " Options"
                else
                    button.Text = selected[1]
                end
            end
        
            local function saveToConfig()
                if ProxUI._configData then
                    ProxUI._configData[stateKey] = multiSelect and selected or selected[1]
                    ProxUI:_SaveConfig()
                end
            end
        
            local function refreshChecks()
                for _, child in ipairs(dropdownHolder:GetChildren()) do
                    if child:IsA("TextButton") then
                        local mark = child:FindFirstChild("Check")
                        if mark then
                            mark.Visible = table.find(selected, child.Name) ~= nil
                        end
                    end
                end
            end
        
            local function toggleOption(opt, item)
                if table.find(selected, opt) then
                    table.remove(selected, table.find(selected, opt))
                elseif not multiSelect then
                    selected = {opt}
                else
                    table.insert(selected, opt)
                end
        
                refreshChecks()
                updateText()
                saveToConfig()
        
                if callback then
                    callback(multiSelect and selected or selected[1])
                end
            end
        
            for _, opt in ipairs(options) do
                local item = Instance.new("TextButton")
                item.Size = UDim2.new(1, -8, 0, 24)
                item.Position = UDim2.new(0, 4, 0, 0)
                item.Text = opt
                item.Name = opt
                item.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                item.TextColor3 = Color3.fromRGB(255, 255, 255)
                item.Font = Enum.Font.SourceSans
                item.TextSize = 14
                item.AutoButtonColor = false
                item.TextXAlignment = Enum.TextXAlignment.Left
                item.ZIndex = 101
                item.Parent = dropdownHolder
        
                local itemPadding = Instance.new("UIPadding")
                itemPadding.PaddingLeft = UDim.new(0, 8)
                itemPadding.PaddingRight = UDim.new(0, 8)
                itemPadding.Parent = item
        
                local itemCorner = Instance.new("UICorner")
                itemCorner.CornerRadius = UDim.new(0, 4)
                itemCorner.Parent = item
        
                local check = Instance.new("TextLabel")
                check.Name = "Check"
                check.Size = UDim2.new(0, 20, 1, 0)
                check.Position = UDim2.new(1, -20, 0, 0)
                check.BackgroundTransparency = 1
                check.Text = "✔"
                check.TextColor3 = Color3.fromRGB(220, 220, 220)
                check.TextSize = 14
                check.Font = Enum.Font.SourceSans
                check.Visible = table.find(selected, opt) ~= nil
                check.ZIndex = 102
                check.Parent = item
        
                item.MouseButton1Click:Connect(function()
                    toggleOption(opt, item)
                end)
            end
        
            updateText()
        
            button.MouseButton1Click:Connect(function()
                if isAnimating then return end
        
                isAnimating = true
                isOpen = not isOpen
        
                dropdownHolder.Visible = true
        
                local targetHeight = isOpen and (#options * 28 + 4) or 0
        
                for _, child in ipairs(dropdownHolder:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.Visible = isOpen
                    end
                end
        
                local tween = TweenService:Create(dropdownHolder, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(1, 0, 0, targetHeight)
                })
        
                tween:Play()
        
                tween.Completed:Connect(function()
                    dropdownHolder.Visible = isOpen
                    isAnimating = false
                end)
            end)
        
            return {
                Get = function()
                    return multiSelect and selected or selected[1]
                end,
                Set = function(val)
                    selected = multiSelect and val or {val}
                    updateText()
                    refreshChecks()
                    saveToConfig()
                end
            }
        end        
        
        local sectionPadding = Instance.new("UIPadding")
        sectionPadding.PaddingTop = UDim.new(0, 12)
        sectionPadding.PaddingBottom = UDim.new(0, 12)
        sectionPadding.PaddingLeft = UDim.new(0, 12)
        sectionPadding.PaddingRight = UDim.new(0, 12)
        sectionPadding.Parent = layoutContainer

        local sectionList = Instance.new("UIListLayout")
        sectionList.Padding = UDim.new(0, 8)
        sectionList.Parent = layoutContainer
        
        tabContent.Size = UDim2.new(1, 0, 1, -62)
        tabContent.Position = UDim2.new(0, 0, 0, 62)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        tabContent.ClipsDescendants = true
        tabContent.ScrollingEnabled = true
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.CanvasSize = UDim2.new(1, 0, 2, 0)

        
        local tabContainerList = Instance.new("UIListLayout")
        tabContainerList.SortOrder = Enum.SortOrder.LayoutOrder
        tabContainerList.Parent = tabContent

        
        layoutContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(1, 0, 0, layoutContainer.AbsoluteSize.Y + 24)
        end)

        button.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                if t.Frame then
                    t.Frame.Visible = false
                end
                if t.Button then
                    t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                end
            end

            content.Visible = true
            activeTab = tab

            tabContent.CanvasPosition = Vector2.new(0, 0)

            selectionBorder.Visible = true
            selectionBorder.Position = UDim2.new(0, button.AbsolutePosition.X - tabBar.AbsolutePosition.X, 0, 30)
            selectionBorder.Size = UDim2.new(0, button.AbsoluteSize.X, 0, 30)

            dividerLeft.Size = UDim2.new(0, button.AbsolutePosition.X - tabBar.AbsolutePosition.X, 0, 2)
            dividerRight.Position = UDim2.new(0, button.AbsolutePosition.X - tabBar.AbsolutePosition.X + button.AbsoluteSize.X, 0, 60)
            dividerRight.Size = UDim2.new(1, -(button.AbsolutePosition.X - tabBar.AbsolutePosition.X + button.AbsoluteSize.X), 0, 2)
        end)

        if not activeTab then
            content.Visible = true
            activeTab = tab

            selectionBorder.Visible = true
            selectionBorder.Position = UDim2.new(0, button.AbsolutePosition.X - tabBar.AbsolutePosition.X, 0, 30)
            selectionBorder.Size = UDim2.new(0, button.AbsoluteSize.X, 0, 30)

            dividerLeft.Size = UDim2.new(0, button.AbsolutePosition.X - tabBar.AbsolutePosition.X, 0, 2)
            dividerRight.Position = UDim2.new(0, button.AbsolutePosition.X - tabBar.AbsolutePosition.X + button.AbsoluteSize.X, 0, 60)
            dividerRight.Size = UDim2.new(1, -(button.AbsolutePosition.X - tabBar.AbsolutePosition.X + button.AbsoluteSize.X), 0, 2)
        end

        table.insert(tabs, tab)
        return tab
    end

    return self
end

function ProxUI:SetConfig(folderName, fileName)
    local folder = folderName or "Prox UI"
    local file = fileName or "config.json"

    if not isfolder(folder) then makefolder(folder) end
    local path = folder .. "/" .. file

    self._configFolder = folder
    self._configFile = file

    if isfile(path) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if success and typeof(result) == "table" then
            self._configData = result
        else
            warn("Prox / Failed to load config:", result)
            self._configData = {}
        end
    else
        self._configData = {}
    end
end

function ProxUI:ClearConfig()
    if self._configFolder and self._configFile then
        local path = self._configFolder .. "/" .. self._configFile
        if isfile(path) then pcall(delfile, path) end
    end
    self._configData = {}
end

function ProxUI:_SaveConfig()
    if not self._configFolder or not self._configFile then return end
    local path = self._configFolder .. "/" .. self._configFile
    local json = HttpService:JSONEncode(self._configData)
    pcall(writefile, path, json)
end

return ProxUI
