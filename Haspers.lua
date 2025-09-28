lua
getgenv().GG = {
    tweenTime = 0.3,
    tweenInTime = 0.2,
    tweenOutTime = 0.2,
    enabled = true,
    toggleKey = Enum.KeyCode.Insert
}

local Haspers = {version = "1.0.0"}
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
screenGui.Enabled = GG.enabled

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true

local dragFrame = Instance.new("Frame")
dragFrame.Size = UDim2.new(1, 0, 0, 30)
dragFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dragFrame.BorderSizePixel = 0
dragFrame.Parent = mainFrame

local clientName = Instance.new("TextLabel")
clientName.Size = UDim2.new(0, 200, 1, 0)
clientName.Position = UDim2.new(0, 10, 0, 0)
clientName.BackgroundTransparency = 1
clientName.Text = "Haspers"
clientName.TextColor3 = Color3.fromRGB(255, 255, 255)
clientName.TextSize = 16
clientName.Font = Enum.Font.SourceSansBold
clientName.TextXAlignment = Enum.TextXAlignment.Left
clientName.Parent = dragFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = dragFrame

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(0, 150, 1, -30)
tabContainer.Position = UDim2.new(0, 0, 0, 30)
tabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Vertical
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, 5)
tabList.Parent = tabContainer

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -150, 1, -30)
contentFrame.Position = UDim2.new(0, 150, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame
contentFrame.ClipsDescendants = true

local dragging, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

dragFrame.InputBegan:Connect(function(input)
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

dragFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            updateDrag(input)
        end
    end
end)

local tabs = {}
local currentTab = nil

function Haspers.new()
    local ui = {}
    
    function ui:load()
        screenGui.Enabled = GG.enabled
    end
    
    function ui:create_tab(name, icon)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Position = UDim2.new(0, 5, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tabButton.BorderSizePixel = 0
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Parent = tabContainer
        if icon then
            local tabIcon = Instance.new("ImageLabel")
            tabIcon.Size = UDim2.new(0, 20, 0, 20)
            tabIcon.Position = UDim2.new(0, 5, 0.5, -10)
            tabIcon.BackgroundTransparency = 1
            tabIcon.Image = icon
            tabIcon.Parent = tabButton
            tabButton.TextXAlignment = Enum.TextXAlignment.Left
            tabButton.Text = "  " .. name
        end
        
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Parent = contentFrame
        tabContent.Visible = false
        
        local leftSection = Instance.new("Frame")
        leftSection.Size = UDim2.new(0.5, -5, 1, 0)
        leftSection.Position = UDim2.new(0, 0, 0, 0)
        leftSection.BackgroundTransparency = 1
        leftSection.Parent = tabContent
        local leftList = Instance.new("UIListLayout")
        leftList.FillDirection = Enum.FillDirection.Vertical
        leftList.SortOrder = Enum.SortOrder.LayoutOrder
        leftList.Padding = UDim.new(0, 5)
        leftList.Parent = leftSection
        
        local rightSection = Instance.new("Frame")
        rightSection.Size = UDim2.new(0.5, -5, 1, 0)
        rightSection.Position = UDim2.new(0.5, 5, 0, 0)
        rightSection.BackgroundTransparency = 1
        rightSection.Parent = tabContent
        local rightList = Instance.new("UIListLayout")
        rightList.FillDirection = Enum.FillDirection.Vertical
        rightList.SortOrder = Enum.SortOrder.LayoutOrder
        rightList.Padding = UDim.new(0, 5)
        rightList.Parent = rightSection
        
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.content.Visible = false
                currentTab.button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            currentTab = tab
        end)
        
        tab.button = tabButton
        tab.content = tabContent
        tab.leftSection = leftSection
        tab.rightSection = rightSection
        
        function tab:create_module(options)
            local module = {}
            local moduleFrame = Instance.new("Frame")
            moduleFrame.Size = UDim2.new(1, -10, 0, 100)
            moduleFrame.Position = UDim2.new(0, 5, 0, 0)
            moduleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            moduleFrame.BorderSizePixel = 0
            moduleFrame.Parent = options.section == "left" and leftSection or rightSection
            
            local moduleTitle = Instance.new("TextLabel")
            moduleTitle.Size = UDim2.new(1, -10, 0, 20)
            moduleTitle.Position = UDim2.new(0, 5, 0, 5)
            moduleTitle.BackgroundTransparency = 1
            moduleTitle.Text = options.title
            moduleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            moduleTitle.TextSize = 14
            moduleTitle.Font = Enum.Font.SourceSansBold
            moduleTitle.TextXAlignment = Enum.TextXAlignment.Left
            moduleTitle.Parent = moduleFrame
            
            local moduleDescription = Instance.new("TextLabel")
            moduleDescription.Size = UDim2.new(1, -10, 0, 20)
            moduleDescription.Position = UDim2.new(0, 5, 0, 25)
            moduleDescription.BackgroundTransparency = 1
            moduleDescription.Text = options.description or ""
            moduleDescription.TextColor3 = Color3.fromRGB(200, 200, 200)
            moduleDescription.TextSize = 12
            moduleDescription.Font = Enum.Font.SourceSans
            moduleDescription.TextXAlignment = Enum.TextXAlignment.Left
            moduleDescription.Parent = moduleFrame
            
            function module:create_checkbox(checkOptions)
                local checkbox = Instance.new("TextButton")
                checkbox.Size = UDim2.new(0, 20, 0, 20)
                checkbox.Position = UDim2.new(0, 5, 0, 50)
                checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                checkbox.BorderSizePixel = 1
                checkbox.Text = ""
                checkbox.Parent = moduleFrame
                local checkLabel = Instance.new("TextLabel")
                checkLabel.Size = UDim2.new(0, 100, 0, 20)
                checkLabel.Position = UDim2.new(0, 30, 0, 50)
                checkLabel.BackgroundTransparency = 1
                checkLabel.Text = checkOptions.title
                checkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                checkLabel.TextSize = 12
                checkLabel.Font = Enum.Font.SourceSans
                checkLabel.TextXAlignment = Enum.TextXAlignment.Left
                checkLabel.Parent = moduleFrame
                local checked = false
                checkbox.MouseButton1Click:Connect(function()
                    checked = not checked
                    checkbox.BackgroundColor3 = checked and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
                    if checkOptions.callback then
                        checkOptions.callback(checked)
                    end
                end)
            end
            
            function module:create_dropdown(dropOptions)
                local dropdown = Instance.new("Frame")
                dropdown.Size = UDim2.new(1, -10, 0, 30)
                dropdown.Position = UDim2.new(0, 5, 0, 50)
                dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                dropdown.Parent = moduleFrame
                local dropButton = Instance.new("TextButton")
                dropButton.Size = UDim2.new(1, -30, 1, 0)
                dropButton.BackgroundTransparency = 1
                dropButton.Text = dropOptions.title
                dropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropButton.TextSize = 12
                dropButton.Font = Enum.Font.SourceSans
                dropButton.TextXAlignment = Enum.TextXAlignment.Left
                dropButton.Parent = dropdown
                local dropArrow = Instance.new("TextLabel")
                dropArrow.Size = UDim2.new(0, 30, 1, 0)
                dropArrow.Position = UDim2.new(1, -30, 0, 0)
                dropArrow.BackgroundTransparency = 1
                dropArrow.Text = "▼"
                dropArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropArrow.TextSize = 12
                dropArrow.Parent = dropdown
                local dropList = Instance.new("Frame")
                dropList.Size = UDim2.new(1, 0, 0, 0)
                dropList.Position = UDim2.new(0, 0, 1, 0)
                dropList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                dropList.BorderSizePixel = 0
                dropList.ClipsDescendants = true
                dropList.Visible = false
                dropList.Parent = dropdown
                local dropListLayout = Instance.new("UIListLayout")
                dropListLayout.FillDirection = Enum.FillDirection.Vertical
                dropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                dropListLayout.Parent = dropList
                local dropOptions = dropOptions.options
                for i, option in ipairs(dropOptions.options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Size = UDim2.new(1, 0, 0, 30)
                    optionButton.BackgroundTransparency = 1
                    optionButton.Text = option
                    optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    optionButton.TextSize = 12
                    optionButton.Font = Enum.Font.SourceSans
                    optionButton.Parent = dropList
                    optionButton.MouseButton1Click:Connect(function()
                        dropButton.Text = option
                        dropList.Visible = false
                        if dropOptions.callback then
                            dropOptions.callback(option)
                        end
                    end)
                    dropList.Size = UDim2.new(1, 0, 0, i * 30)
                end
                dropButton.MouseButton1Click:Connect(function()
                    dropList.Visible = not dropList.Visible
                end)
            end
            
            function module:create_textbox(textOptions)
                local textbox = Instance.rnew("TextBox")
                textbox.Size = UDim2.new(1, -10, 0, 30)
                textbox.Position = UDim2.new(0, 5, 0, 50)
                textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                textbox.BorderSizePixel = 1
                textbox.Text = textOptions.placeholder or ""
                textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                textbox.TextSize = 12
                textbox.Font = Enum.Font.SourceSans
                textbox.Parent = moduleFrame
                textbox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and textOptions.callback then
                        textOptions.callback(textbox.Text)
                    end
                end)
            end
            
            function module:create_slider(sliderOptions)
                local slider = Instance.new("Frame")
                slider.Size = UDim2.new(1, -10, 0, 50)
                slider.Position = UDim2.new(0, 5, 0, 50)
                slider.BackgroundTransparency = 1
                slider.Parent = moduleFrame
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Size = UDim2.new(1, 0, 0, 20)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = sliderOptions.title .. ": " .. sliderOptions.value
                sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                sliderLabel.TextSize = 12
                sliderLabel.Font = Enum.Font.SourceSans
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Parent = slider
                local sliderBar = Instance.new("Frame")
                sliderBar.Size = UDim2.new(1, -10, 0, 10)
                sliderBar.Position = UDim2.new(0, 5, 0, 25)
                sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                sliderBar.BorderSizePixel = 1
                sliderBar.Parent = slider
                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new(0, 0, 1, 0)
                sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                sliderFill.BorderSizePixel = 0
                sliderFill.Parent = sliderBar
                local sliderButton = Instance.new("TextButton")
                sliderButton.Size = UDim2.new(0, 10, 0, 10)
                sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderButton.BorderSizePixel = 0
                sliderButton.Text = ""
                sliderButton.Parent = sliderBar
                local minValue = sliderOptions.minimum_value
                local maxValue = sliderOptions.maximum_value
                local currentValue = sliderOptions.value
                local function updateSlider(input)
                    local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    currentValue = minValue + (maxValue - minValue) * relativeX
                    if sliderOptions.round_number then
                        currentValue = math.floor(currentValue)
                    end
                    sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    sliderButton.Position = UDim2.new(relativeX, -5, 0, 0)
                    sliderLabel.Text = sliderOptions.title .. ": " .. currentValue
                    if sliderOptions.callback then
                        sliderOptions.callback(currentValue)
                    end
                end
                sliderButton.MouseButton1Down:Connect(function()
                    local connection
                    connection = userInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                            updateSlider(input)
                        end
                    end)
                    userInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            connection:Disconnect()
                        end
                    end)
                end)
            end
            
            function module:create_divider(dividerOptions)
                local divider = Instance.new("Frame")
                divider.Size = UDim2.new(1, -10, 0, dividerOptions.disableline and 20 or 10)
                divider.Position = UDim2.new(0, 5, 0, 50)
                divider.BackgroundColor3 = dividerOptions.disableline and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(100, 100, 100)
                divider.BorderSizePixel = 0
                divider.Parent = moduleFrame
                if dividerOptions.showtopic and dividerOptions.title then
                    local dividerLabel = Instance.new("TextLabel")
                    dividerLabel.Size = UDim2.new(1, 0, 0, 20)
                    dividerLabel.BackgroundTransparency = 1
                    dividerLabel.Text = dividerOptions.title
                    dividerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    dividerLabel.TextSize = 12
                    dividerLabel.Font = Enum.Font.SourceSans
                    dividerLabel.TextXAlignment = Enum.TextXAlignment.Left
                    dividerLabel.Parent = divider
                end
            end
            
            return module
        end
        
        table.insert(tabs, tab)
        if #tabs == 1 then
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            tabContent.Visible = true
            currentTab = tab
        end
        return tab
    end
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)
    
    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == GG.toggleKey then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)
    
    return ui
end

return Haspers
