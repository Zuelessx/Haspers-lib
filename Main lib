getgenv().GG = {
    Language = {
        CheckboxEnabled = "Enabled",
        CheckboxDisabled = "Disabled",
        SliderValue = "Value",
        DropdownSelect = "Select",
        DropdownNone = "None",
        DropdownSelected = "Selected",
        ButtonClick = "Click",
        TextboxEnter = "Enter",
        ModuleEnabled = "Enabled",
        ModuleDisabled = "Disabled",
        TabGeneral = "General",
        TabSettings = "Settings",
        Loading = "Loading...",
        Error = "Error",
        Success = "Success"
    }
}

-- Replace the SelectedLanguage with a reference to GG.Language
local SelectedLanguage = GG.Language

function convertStringToTable(inputString)
    local result = {}
    for value in string.gmatch(inputString, "([^,]+)") do
        local trimmedValue = value:match("^%s*(.-)%s*$")
        table.insert(result, trimmedValue)
    end
    return result
end

function convertTableToString(inputTable)
    return table.concat(inputTable, ", ")
end

local UserInputService = cloneref(game:GetService('UserInputService'))
local ContentProvider = cloneref(game:GetService('ContentProvider'))
local TweenService = cloneref(game:GetService('TweenService'))
local HttpService = cloneref(game:GetService('HttpService'))
local TextService = cloneref(game:GetService('TextService'))
local RunService = cloneref(game:GetService('RunService'))
local Lighting = cloneref(game:GetService('Lighting'))
local Players = cloneref(game:GetService('Players'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Debris = cloneref(game:GetService('Debris'))

local mouse = Players.LocalPlayer:GetMouse()
local old_March = CoreGui:FindFirstChild('March')

if old_March then
    Debris:AddItem(old_March, 0)
end

if not isfolder("March") then
    makefolder("March")
end

local Connections = setmetatable({
    disconnect = function(self, connection)
        if not self[connection] then
            return
        end
        self[connection]:Disconnect()
        self[connection] = nil
    end,
    disconnect_all = function(self)
        for _, value in self do
            if typeof(value) == 'function' then
                continue
            end
            value:Disconnect()
        end
    end
}, {__index = Connections})

local Util = setmetatable({
    map = function(self, value, in_minimum, in_maximum, out_minimum, out_maximum)
        return (value - in_minimum) * (out_maximum - out_minimum) / (in_maximum - in_minimum) + out_minimum
    end,
    viewport_point_to_world = function(self, location, distance)
        local unit_ray = workspace.CurrentCamera:ScreenPointToRay(location.X, location.Y)
        return unit_ray.Origin + unit_ray.Direction * distance
    end,
    get_offset = function(self)
        local viewport_size_Y = workspace.CurrentCamera.ViewportSize.Y
        return self:map(viewport_size_Y, 0, 2560, 8, 56)
    end
}, {__index = Util})

local AcrylicBlur = {}
AcrylicBlur.__index = AcrylicBlur

function AcrylicBlur.new(object)
    local self = setmetatable({
        _object = object,
        _folder = nil,
        _frame = nil,
        _root = nil
    }, AcrylicBlur)
    self:setup()
    return self
end

function AcrylicBlur:create_folder()
    local old_folder = workspace.CurrentCamera:FindFirstChild('AcrylicBlur')
    if old_folder then
        Debris:AddItem(old_folder, 0)
    end
    local folder = Instance.new('Folder')
    folder.Name = 'AcrylicBlur'
    folder.Parent = workspace.CurrentCamera
    self._folder = folder
end

function AcrylicBlur:create_depth_of_fields()
    local depth_of_fields = Lighting:FindFirstChild('AcrylicBlur') or Instance.new('DepthOfFieldEffect')
    depth_of_fields.FarIntensity = 0
    depth_of_fields.FocusDistance = 0.05
    depth_of_fields.InFocusRadius = 0.1
    depth_of_fields.NearIntensity = 1
    depth_of_fields.Name = 'AcrylicBlur'
    depth_of_fields.Parent = Lighting
    for _, object in Lighting:GetChildren() do
        if not object:IsA('DepthOfFieldEffect') then
            continue
        end
        if object == depth_of_fields then
            continue
        end
        Connections[object] = object:GetPropertyChangedSignal('FarIntensity'):Connect(function()
            object.FarIntensity = 0
        end)
        object.FarIntensity = 0
    end
end

function AcrylicBlur:create_frame()
    local frame = Instance.new('Frame')
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 1
    frame.Parent = self._object
    self._frame = frame
end

function AcrylicBlur:create_root()
    local part = Instance.new('Part')
    part.Name = 'Root'
    part.Color = Color3.new(0, 0, 0)
    part.Material = Enum.Material.Glass
    part.Size = Vector3.new(1, 1, 0)
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.Locked = true
    part.CastShadow = false
    part.Transparency = 0.98
    part.Parent = self._folder
    local specialMesh = Instance.new('SpecialMesh')
    specialMesh.MeshType = Enum.MeshType.Brick
    specialMesh.Offset = Vector3.new(0, 0, -0.000001)
    specialMesh.Parent = part
    self._root = part
end

function AcrylicBlur:setup()
    self:create_depth_of_fields()
    self:create_folder()
    self:create_root()
    self:create_frame()
    self:render(0.001)
    self:check_quality_level()
end

function AcrylicBlur:render(distance)
    local positions = {
        top_left = Vector2.new(),
        top_right = Vector2.new(),
        bottom_right = Vector2.new(),
    }
    local function update_positions(size, position)
        positions.top_left = position
        positions.top_right = position + Vector2.new(size.X, 0)
        positions.bottom_right = position + size
    end
    local function update()
        local top_left = positions.top_left
        local top_right = positions.top_right
        local bottom_right = positions.bottom_right
        local top_left3D = Util:viewport_point_to_world(top_left, distance)
        local top_right3D = Util:viewport_point_to_world(top_right, distance)
        local bottom_right3D = Util:viewport_point_to_world(bottom_right, distance)
        local width = (top_right3D - top_left3D).Magnitude
        local height = (top_right3D - bottom_right3D).Magnitude
        if not self._root then
            return
        end
        self._root.CFrame = CFrame.fromMatrix((top_left3D + bottom_right3D) / 2, workspace.CurrentCamera.CFrame.XVector, workspace.CurrentCamera.CFrame.YVector, workspace.CurrentCamera.CFrame.ZVector)
        self._root.Mesh.Scale = Vector3.new(width, height, 0)
    end
    local function on_change()
        local offset = Util:get_offset()
        local size = self._frame.AbsoluteSize - Vector2.new(offset, offset)
        local position = self._frame.AbsolutePosition + Vector2.new(offset / 2, offset / 2)
        update_positions(size, position)
        task.spawn(update)
    end
    Connections['cframe_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(update)
    Connections['viewport_size_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(update)
    Connections['field_of_view_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('FieldOfView'):Connect(update)
    Connections['frame_absolute_position'] = self._frame:GetPropertyChangedSignal('AbsolutePosition'):Connect(on_change)
    Connections['frame_absolute_size'] = self._frame:GetPropertyChangedSignal('AbsoluteSize'):Connect(on_change)
    task.spawn(update)
end

function AcrylicBlur:check_quality_level()
    local game_settings = UserSettings().GameSettings
    local quality_level = game_settings.SavedQualityLevel.Value
    if quality_level < 8 then
        self:change_visiblity(false)
    end
    Connections['quality_level'] = game_settings:GetPropertyChangedSignal('SavedQualityLevel'):Connect(function()
        local game_settings = UserSettings().GameSettings
        local quality_level = game_settings.SavedQualityLevel.Value
        self:change_visiblity(quality_level >= 8)
    end)
end

function AcrylicBlur:change_visiblity(state)
    self._root.Transparency = state and 0.98 or 1
end

local Config = setmetatable({
    save = function(self, file_name, config)
        local success_save, result = pcall(function()
            local flags = HttpService:JSONEncode(config)
            writefile('March/'..file_name..'.json', flags)
        end)
        if not success_save then
            warn('failed to save config', result)
        end
    end,
    load = function(self, file_name, config)
        local success_load, result = pcall(function()
            if not isfile('March/'..file_name..'.json') then
                self:save(file_name, config)
                return
            end
            local flags = readfile('March/'..file_name..'.json')
            if not flags then
                self:save(file_name, config)
                return
            end
            return HttpService:JSONDecode(flags)
        end)
        if not success_load then
            warn('failed to load config', result)
        end
        if not result then
            result = {
                _flags = {},
                _keybinds = {},
                _library = {}
            }
        end
        return result
    end
}, {__index = Config})

local Haspers = {
    _config = Config:load(game.GameId),
    _choosing_keybind = false,
    _device = nil,
    _ui_open = true,
    _ui_scale = 1,
    _ui_loaded = false,
    _ui = nil,
    _dragging = false,
    _drag_start = nil,
    _container_position = nil
}
Haspers.__index = Haspers

function Haspers.new()
    local self = setmetatable({
        _loaded = false,
        _tab = 0,
    }, Haspers)
    self:create_ui()
    return self
end

-- Create Notification Container
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "RobloxCoreGuis"
NotificationContainer.Size = UDim2.new(0, 300, 0, 0)
NotificationContainer.Position = UDim2.new(0.8, 0, 0, 10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.ClipsDescendants = false
NotificationContainer.Parent = game:GetService("CoreGui").RobloxGui:FindFirstChild("RobloxCoreGuis") or Instance.new("ScreenGui", game:GetService("CoreGui").RobloxGui)
NotificationContainer.AutomaticSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = NotificationContainer

function Haspers.SendNotification(settings)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 60)
    Notification.BackgroundTransparency = 1
    Notification.BorderSizePixel = 0
    Notification.Name = "Notification"
    Notification.Parent = NotificationContainer
    Notification.AutomaticSize = Enum.AutomaticSize.Y
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Notification
    local InnerFrame = Instance.new("Frame")
    InnerFrame.Size = UDim2.new(1, 0, 0, 60)
    InnerFrame.Position = UDim2.new(0, 0, 0, 0)
    InnerFrame.BackgroundColor3 = Color3.fromRGB(32, 38, 51)
    InnerFrame.BackgroundTransparency = 0.1
    InnerFrame.BorderSizePixel = 0
    InnerFrame.Name = "InnerFrame"
    InnerFrame.Parent = Notification
    InnerFrame.AutomaticSize = Enum.AutomaticSize.Y
    local InnerUICorner = Instance.new("UICorner")
    InnerUICorner.CornerRadius = UDim.new(0, 4)
    InnerUICorner.Parent = InnerFrame
    local Title = Instance.new("TextLabel")
    Title.Text = settings.title or "Notification Title"
    Title.TextColor3 = Color3.fromRGB(210, 210, 210)
    Title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Title.TextSize = 14
    Title.Size = UDim2.new(1, -10, 0, 20)
    Title.Position = UDim2.new(0, 5, 0, 5)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.TextWrapped = true
    Title.AutomaticSize = Enum.AutomaticSize.Y
    Title.Parent = InnerFrame
    local Body = Instance.new("TextLabel")
    Body.Text = settings.text or "This is the body of the notification."
    Body.TextColor3 = Color3.fromRGB(180, 180, 180)
    Body.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Body.TextSize = 12
    Body.Size = UDim2.new(1, -10, 0, 30)
    Body.Position = UDim2.new(0, 5, 0, 25)
    Body.BackgroundTransparency = 1
    Body.TextXAlignment = Enum.TextXAlignment.Left
    Body.TextYAlignment = Enum.TextYAlignment.Top
    Body.TextWrapped = true
    Body.AutomaticSize = Enum.AutomaticSize.Y
    Body.Parent = InnerFrame
    task.spawn(function()
        wait(0.1)
        local totalHeight = Title.TextBounds.Y + Body.TextBounds.Y + 10
        InnerFrame.Size = UDim2.new(1, 0, 0, totalHeight)
    end)
    task.spawn(function()
        local tweenIn = TweenService:Create(InnerFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 10 + NotificationContainer.Size.Y.Offset)
        })
        tweenIn:Play()
        local duration = settings.duration or 5
        wait(duration)
        local tweenOut = TweenService:Create(InnerFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 310, 0, 10 + NotificationContainer.Size.Y.Offset)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            Notification:Destroy()
        end)
    end)
end

function Haspers:get_screen_scale()
    local viewport_size_x = workspace.CurrentCamera.ViewportSize.X
    self._ui_scale = viewport_size_x / 1400
end

function Haspers:get_device()
    local device = 'Unknown'
    if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        device = 'PC'
    elseif UserInputService.TouchEnabled then
        device = 'Mobile'
    elseif UserInputService.GamepadEnabled then
        device = 'Console'
    end
    self._device = device
end

function Haspers:removed(action)
    self._ui.AncestryChanged:Once(action)
end

function Haspers:flag_type(flag, flag_type)
    if not Haspers._config._flags[flag] then
        return
    end
    return typeof(Haspers._config._flags[flag]) == flag_type
end

function Haspers:remove_table_value(__table, table_value)
    for index, value in __table do
        if value ~= table_value then
            continue
        end
        table.remove(__table, index)
    end
end

function Haspers:create_ui()
    local old_March = CoreGui:FindFirstChild('March')
    if old_March then
        Debris:AddItem(old_March, 0)
    end
    local March = Instance.new('ScreenGui')
    March.ResetOnSpawn = false
    March.Name = 'March'
    March.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    March.Parent = CoreGui
    local Container = Instance.new('Frame')
    Container.ClipsDescendants = true
    Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Name = 'Container'
    Container.BackgroundTransparency = 0.05000000074505806
    Container.BackgroundColor3 = Color3.fromRGB(12, 13, 15)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 0, 0, 0)
    Container.Active = true
    Container.BorderSizePixel = 0
    Container.Parent = March
    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Container
    local UIStroke = Instance.new('UIStroke')
    UIStroke.Color = Color3.fromRGB(52, 66, 89)
    UIStroke.Transparency = 0.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Container
    local Handler = Instance.new('Frame')
    Handler.BackgroundTransparency = 1
    Handler.Name = 'Handler'
    Handler.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Handler.Size = UDim2.new(0, 698, 0, 479)
    Handler.BorderSizePixel = 0
    Handler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Handler.Parent = Container
    local Tabs = Instance.new('ScrollingFrame')
    Tabs.ScrollBarImageTransparency = 1
    Tabs.ScrollBarThickness = 0
    Tabs.Name = 'Tabs'
    Tabs.Size = UDim2.new(0, 129, 0, 401)
    Tabs.Selectable = false
    Tabs.AutomaticCanvasSize = Enum.AutomaticSize.XY
    Tabs.BackgroundTransparency = 1
    Tabs.Position = UDim2.new(0.026097271591424942, 0, 0.1111111119389534, 0)
    Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Tabs.BorderSizePixel = 0
    Tabs.CanvasSize = UDim2.new(0, 0, 0.5, 0)
    Tabs.Parent = Handler
    local UIListLayout = Instance.new('UIListLayout')
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Tabs
    local ClientName = Instance.new('TextLabel')
    ClientName.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    ClientName.TextColor3 = Color3.fromRGB(152, 181, 255)
    ClientName.TextTransparency = 0.20000000298023224
    ClientName.Text = 'Haspers'
    ClientName.Name = 'ClientName'
    ClientName.Size = UDim2.new(0, 31, 0, 13)
    ClientName.AnchorPoint = Vector2.new(0, 0.5)
    ClientName.Position = UDim2.new(0.0560000017285347, 0, 0.054999999701976776, 0)
    ClientName.BackgroundTransparency = 1
    ClientName.TextXAlignment = Enum.TextXAlignment.Left
    ClientName.BorderSizePixel = 0
    ClientName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ClientName.TextSize = 13
    ClientName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClientName.Parent = Handler
    local UIGradient = Instance.new('UIGradient')
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 155, 155)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    UIGradient.Parent = ClientName
    local Pin = Instance.new('Frame')
    Pin.Name = 'Pin'
    Pin.Position = UDim2.new(0.026000000536441803, 0, 0.13600000739097595, 0)
    Pin.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Pin.Size = UDim2.new(0, 2, 0, 16)
    Pin.BorderSizePixel = 0
    Pin.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
    Pin.Parent = Handler
    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Pin
    local Icon = Instance.new('ImageLabel')
    Icon.ImageColor3 = Color3.fromRGB(152, 181, 255)
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.Image = 'rbxassetid://107819132007001'
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0.02500000037252903, 0, 0.054999999701976776, 0)
    Icon.Name = 'Icon'
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.BorderSizePixel = 0
    Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Icon.Parent = Handler
    local Divider = Instance.new('Frame')
    Divider.Name = 'Divider'
    Divider.BackgroundTransparency = 0.5
    Divider.Position = UDim2.new(0.23499999940395355, 0, 0, 0)
    Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Divider.Size = UDim2.new(0, 1, 0, 479)
    Divider.BorderSizePixel = 0
    Divider.BackgroundColor3 = Color3.fromRGB(52, 66, 89)
    Divider.Parent = Handler
    local Sections = Instance.new('Folder')
    Sections.Name = 'Sections'
    Sections.Parent = Handler
    local Minimize = Instance.new('TextButton')
    Minimize.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
    Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Minimize.Text = ''
    Minimize.AutoButtonColor = false
    Minimize.Name = 'Minimize'
    Minimize.BackgroundTransparency = 1
    Minimize.Position = UDim2.new(0.020057305693626404, 0, 0.02922755666077137, 0)
    Minimize.Size = UDim2.new(0, 24, 0, 24)
    Minimize.BorderSizePixel = 0
    Minimize.TextSize = 14
    Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.Parent = Handler
    local UIScale = Instance.new('UIScale')
    UIScale.Parent = Container
    self._ui = March
    local function on_drag(input, process)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            self._dragging = true
            self._drag_start = input.Position
            self._container_position = Container.Position
            Connections['container_input_ended'] = input.Changed:Connect(function()
                if input.UserInputState ~= Enum.UserInputState.End then
                    return
                end
                Connections:disconnect('container_input_ended')
                self._dragging = false
            end)
        end
    end
    local function update_drag(input)
        local delta = input.Position - self._drag_start
        local position = UDim2.new(self._container_position.X.Scale, self._container_position.X.Offset + delta.X, self._container_position.Y.Scale, self._container_position.Y.Offset + delta.Y)
        TweenService:Create(Container, TweenInfo.new(0.2), {
            Position = position
        }):Play()
    end
    local function drag(input, process)
        if not self._dragging then
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            update_drag(input)
        end
    end
    Connections['container_input_began'] = Container.InputBegan:Connect(on_drag)
    Connections['input_changed'] = UserInputService.InputChanged:Connect(drag)
    self:removed(function()
        self._ui = nil
        Connections:disconnect_all()
    end)
    function self:Update1Run(a)
        if a == "nil" then
            Container.BackgroundTransparency = 0.05000000074505806
        else
            pcall(function()
                Container.BackgroundTransparency = tonumber(a)
            end)
        end
    end
    function self:UIVisiblity()
        March.Enabled = not March.Enabled
    end
    function self:change_visiblity(state)
        if state then
            TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(698, 479)
            }):Play()
        else
            TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(104.5, 52)
            }):Play()
        end
    end
    function self:load()
        local content = {}
        for _, object in March:GetDescendants() do
            if not object:IsA('ImageLabel') then
                continue
            end
            table.insert(content, object)
        end
        ContentProvider:PreloadAsync(content)
        self:get_device()
        if self._device == 'Mobile' or self._device == 'Unknown' then
            self:get_screen_scale()
            UIScale.Scale = self._ui_scale
            Connections['ui_scale'] = workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
                self:get_screen_scale()
                UIScale.Scale = self._ui_scale
            end)
        end
        TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(698, 479)
        }):Play()
        AcrylicBlur.new(Container)
        self._ui_loaded = true
    end
    function self:update_tabs(tab)
        for index, object in Tabs:GetChildren() do
            if object.Name ~= 'Tab' then
                continue
            end
            if object == tab then
                if object.BackgroundTransparency ~= 0.5 then
                    local offset = object.LayoutOrder * (0.113 / 1.3)
                    TweenService:Create(Pin, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Position = UDim2.fromScale(0.026, 0.135 + offset)
                    }):Play()
                    TweenService:Create(object, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.5
                    }):Play()
                    TweenService:Create(object.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        TextTransparency = 0
                    }):Play()
                end
            else
                TweenService:Create(object, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                }):Play()
                TweenService:Create(object.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    TextTransparency = 0.2
                }):Play()
            end
        end
    end
    function self:create_tab(settings)
        local TabManager = {
            _tab = nil,
            _size = 0,
            _multiplier = 0
        }
        function TabManager:create_module(settings)
            local ModuleManager = {
                _state = false,
                _size = 0,
                _multiplier = 0
            }
            local LayoutOrderModule = 0
            local Module = Instance.new('ScrollingFrame')
            Module.ScrollBarImageTransparency = 1
            Module.ScrollBarThickness = 0
            Module.Name = settings.section
            Module.Size = UDim2.fromOffset(241, 93)
            Module.BackgroundTransparency = 1
            Module.Position = UDim2.new(0.252149, 0, 0.111111, 0)
            Module.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Module.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Module.BorderSizePixel = 0
            Module.Visible = false
            Module.CanvasSize = UDim2.new(0, 0, 0.5, 0)
            Module.Parent = Sections
            local Options = Instance.new('Frame')
            Options.Name = 'Options'
            Options.Size = UDim2.fromOffset(241, 0)
            Options.BackgroundTransparency = 1
            Options.Position = UDim2.new(0, 0, 0.104167, 0)
            Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Options.BorderSizePixel = 0
            Options.Parent = Module
            local UIListLayout = Instance.new('UIListLayout')
            UIListLayout.Padding = UDim.new(0, 4)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = Options
            local Title = Instance.new('TextLabel')
            Title.Text = settings.title
            Title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            Title.TextColor3 = Color3.fromRGB(152, 181, 255)
            Title.TextTransparency = 0.20000000298023224
            Title.Size = UDim2.new(0, 207, 0, 13)
            Title.Position = UDim2.new(0.252149, 0, 0.054167, 0)
            Title.BackgroundTransparency = 1
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.BorderSizePixel = 0
            Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Title.TextSize = 13
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.Parent = Module
            local Description = Instance.new('TextLabel')
            Description.Text = settings.description
            Description.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            Description.TextColor3 = Color3.fromRGB(152, 181, 255)
            Description.TextTransparency = 0.6000000238418579
            Description.Size = UDim2.new(0, 207, 0, 24)
            Description.Position = UDim2.new(0.252149, 0, 0.104167, 0)
            Description.BackgroundTransparency = 1
            Description.TextXAlignment = Enum.TextXAlignment.Left
            Description.TextWrapped = true
            Description.BorderSizePixel = 0
            Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Description.TextSize = 10
            Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Description.Parent = Module
            function ModuleManager:create_divider(settings)
                local Divider = Instance.new('Frame')
                Divider.Name = 'Divider'
                Divider.BackgroundTransparency = settings.disableline and 1 or 0.5
                Divider.Position = UDim2.new(0, 0, 0.104167, 0)
                Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Divider.Size = UDim2.new(0, 207, 0, 1)
                Divider.BorderSizePixel = 0
                Divider.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                Divider.Parent = Options
                LayoutOrderModule = LayoutOrderModule + 1
                Divider.LayoutOrder = LayoutOrderModule
                if settings.showtopic then
                    local Topic = Instance.new('TextLabel')
                    Topic.Text = settings.title
                    Topic.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    Topic.TextColor3 = Color3.fromRGB(152, 181, 255)
                    Topic.TextTransparency = 0.20000000298023224
                    Topic.Size = UDim2.new(0, 207, 0, 13)
                    Topic.BackgroundTransparency = 1
                    Topic.TextXAlignment = Enum.TextXAlignment.Left
                    Topic.BorderSizePixel = 0
                    Topic.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Topic.TextSize = 13
                    Topic.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Topic.Parent = Divider
                end
                if ModuleManager._size == 0 then
                    ModuleManager._size = 11
                end
                ModuleManager._size += 20
                if ModuleManager._state then
                    Module.Size = UDim2.fromOffset(241, 93 + ModuleManager._size + ModuleManager._multiplier)
                end
                Options.Size = UDim2.fromOffset(241, ModuleManager._size)
                return Divider
            end
            function ModuleManager:create_slider(settings)
                local Slider = Instance.new('Frame')
                Slider.Size = UDim2.new(0, 207, 0, 39)
                Slider.BackgroundTransparency = 1
                Slider.Parent = Options
                LayoutOrderModule = LayoutOrderModule + 1
                Slider.LayoutOrder = LayoutOrderModule
                local Title = Instance.new('TextLabel')
                Title.Text = settings.title
                Title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextTransparency = 0.20000000298023224
                Title.Size = UDim2.new(0, 207, 0, 13)
                Title.BackgroundTransparency = 1
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BorderSizePixel = 0
                Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Title.TextSize = 11
                Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title.Parent = Slider
                local SliderBar = Instance.new('Frame')
                SliderBar.Name = 'SliderBar'
                SliderBar.BackgroundTransparency = 0.8999999761581421
                SliderBar.Position = UDim2.new(0, 0, 0.615385, 0)
                SliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderBar.Size = UDim2.new(0, 207, 0, 5)
                SliderBar.BorderSizePixel = 0
                SliderBar.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                SliderBar.Parent = Slider
                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 10)
                UICorner.Parent = SliderBar
                local Fill = Instance.new('Frame')
                Fill.Name = 'Fill'
                Fill.Position = UDim2.new(0, 0, 0, 0)
                Fill.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Fill.Size = UDim2.new(0, 0, 0, 5)
                Fill.BorderSizePixel = 0
                Fill.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                Fill.Parent = SliderBar
                local UICorner_2 = Instance.new('UICorner')
                UICorner_2.CornerRadius = UDim.new(0, 10)
                UICorner_2.Parent = Fill
                local SliderButton = Instance.new('TextButton')
                SliderButton.Text = ''
                SliderButton.AutoButtonColor = false
                SliderButton.Name = 'SliderButton'
                SliderButton.BackgroundTransparency = 1
                SliderButton.Position = UDim2.new(0, 0, 0, -5)
                SliderButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderButton.Size = UDim2.new(0, 207, 0, 15)
                SliderButton.BorderSizePixel = 0
                SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderButton.Parent = SliderBar
                local Value = Instance.new('TextLabel')
                Value.Text = tostring(settings.value) .. ' ' .. SelectedLanguage.SliderValue
                Value.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Value.TextColor3 = Color3.fromRGB(152, 181, 255)
                Value.TextTransparency = 0.20000000298023224
                Value.Size = UDim2.new(0, 207, 0, 11)
                Value.Position = UDim2.new(0, 0, 1.600000023841858, 0)
                Value.BackgroundTransparency = 1
                Value.TextXAlignment = Enum.TextXAlignment.Left
                Value.BorderSizePixel = 0
                Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Value.TextSize = 10
                Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Value.Parent = SliderBar
                if not Haspers._config._flags[settings.flag] then
                    Haspers._config._flags[settings.flag] = settings.value
                end
                local min = settings.minimum_value
                local max = settings.maximum_value
                local function updateSlider(value)
                    local percentage = (value - min) / (max - min)
                    Fill.Size = UDim2.new(percentage, 0, 0, 5)
                    Value.Text = (settings.round_number and math.floor(value)) or value .. ' ' .. SelectedLanguage.SliderValue
                    Haspers._config._flags[settings.flag] = value
                    Config:save(game.GameId, Haspers._config)
                    settings.callback(value)
                end
                updateSlider(Haspers._config._flags[settings.flag] or settings.value)
                local dragging = false
                SliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                            local mouseX = input.Position.X
                            local sliderX = SliderBar.AbsolutePosition.X
                            local sliderWidth = SliderBar.AbsoluteSize.X
                            local percentage = math.clamp((mouseX - sliderX) / sliderWidth, 0, 1)
                            local value = min + (max - min) * percentage
                            if settings.round_number then
                                value = math.floor(value)
                            end
                            updateSlider(value)
                        end
                    end)
                    local endConnection
                    endConnection = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                            connection:Disconnect()
                            endConnection:Disconnect()
                        end
                    end)
                end)
                if ModuleManager._size == 0 then
                    ModuleManager._size = 11
                end
                ModuleManager._size += 43
                if ModuleManager._state then
                    Module.Size = UDim2.fromOffset(241, 93 + ModuleManager._size + ModuleManager._multiplier)
                end
                Options.Size = UDim2.fromOffset(241, ModuleManager._size)
                return Slider
            end
            function ModuleManager:create_textbox(settings)
                local Textbox = Instance.new('Frame')
                Textbox.Size = UDim2.new(0, 207, 0, 39)
                Textbox.BackgroundTransparency = 1
                Textbox.Parent = Options
                LayoutOrderModule = LayoutOrderModule + 1
                Textbox.LayoutOrder = LayoutOrderModule
                local Title = Instance.new('TextLabel')
                Title.Text = settings.title
                Title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextTransparency = 0.20000000298023224
                Title.Size = UDim2.new(0, 207, 0, 13)
                Title.BackgroundTransparency = 1
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BorderSizePixel = 0
                Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Title.TextSize = 11
                Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title.Parent = Textbox
                local Box = Instance.new('TextBox')
                Box.Text = settings.placeholder or ''
                Box.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Box.TextColor3 = Color3.fromRGB(255, 255, 255)
                Box.TextTransparency = 0.20000000298023224
                Box.Size = UDim2.new(0, 207, 0, 22)
                Box.Position = UDim2.new(0, 0, 0.615385, 0)
                Box.BackgroundTransparency = 0.8999999761581421
                Box.TextXAlignment = Enum.TextXAlignment.Left
                Box.BorderSizePixel = 0
                Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Box.TextSize = 10
                Box.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                Box.Parent = Textbox
                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Box
                if not Haspers._config._flags[settings.flag] then
                    Haspers._config._flags[settings.flag] = settings.placeholder or ''
                end
                Box.Text = Haspers._config._flags[settings.flag]
                Box.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        Haspers._config._flags[settings.flag] = Box.Text
                        Config:save(game.GameId, Haspers._config)
                        settings.callback(Box.Text)
                    end
                end)
                if ModuleManager._size == 0 then
                    ModuleManager._size = 11
                end
                ModuleManager._size += 43
                if ModuleManager._state then
                    Module.Size = UDim2.fromOffset(241, 93 + ModuleManager._size + ModuleManager._multiplier)
                end
                Options.Size = UDim2.fromOffset(241, ModuleManager._size)
                return Textbox
            end
            function ModuleManager:create_checkbox(settings)
                local Checkbox = Instance.new('Frame')
                Checkbox.Size = UDim2.new(0, 207, 0, 16)
                Checkbox.BackgroundTransparency = 1
                Checkbox.Parent = Options
                LayoutOrderModule = LayoutOrderModule + 1
                Checkbox.LayoutOrder = LayoutOrderModule
                local Title = Instance.new('TextLabel')
                Title.Text = settings.title
                Title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.TextTransparency = 0.20000000298023224
                Title.Size = UDim2.new(0, 187, 0, 16)
                Title.BackgroundTransparency = 1
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BorderSizePixel = 0
                Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Title.TextSize = 11
                Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title.Parent = Checkbox
                local Check = Instance.new('TextButton')
                Check.Size = UDim2.new(0, 15, 0, 15)
                Check.Position = UDim2.new(0.903382, 0, 0, 0)
                Check.BackgroundColor3 = Haspers._config._flags[settings.flag] and Color3.fromRGB(152, 181, 255) or Color3.fromRGB(32, 38, 51)
                Check.Text = ''
                Check.BorderSizePixel = 0
                Check.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Check.BackgroundTransparency = 0
                Check.Parent = Checkbox
                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 3)
                UICorner.Parent = Check
                local UIStroke = Instance.new('UIStroke')
                UIStroke.Color = Color3.fromRGB(152, 181, 255)
                UIStroke.Thickness = 1
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke.Parent = Check
                if not Haspers._config._flags[settings.flag] then
                    Haspers._config._flags[settings.flag] = false
                end
                Check.MouseButton1Click:Connect(function()
                    Haspers._config._flags[settings.flag] = not Haspers._config._flags[settings.flag]
                    Check.BackgroundColor3 = Haspers._config._flags[settings.flag] and Color3.fromRGB(152, 181, 255) or Color3.fromRGB(32, 38, 51)
                    Config:save(game.GameId, Haspers._config)
                    settings.callback(Haspers._config._flags[settings.flag])
                end)
                settings.callback(Haspers._config._flags[settings.flag])
                if ModuleManager._size == 0 then
                    ModuleManager._size = 11
                end
                ModuleManager._size += 20
                if ModuleManager._state then
                    Module.Size = UDim2.fromOffset(241, 93 + ModuleManager._size + ModuleManager._multiplier)
                end
                Options.Size = UDim2.fromOffset(241, ModuleManager._size)
                return Checkbox
            end
            function ModuleManager:create_dropdown(settings)
                local DropdownManager = {
                    _state = false,
                    _size = 0
                }
                LayoutOrderModule = LayoutOrderModule + 1
                local Dropdown = Instance.new('TextButton')
                Dropdown.Text = ''
                Dropdown.AutoButtonColor = false
                Dropdown.Size = UDim2.new(0, 207, 0, 39)
                Dropdown.BackgroundTransparency = 1
                Dropdown.Parent = Options
                Dropdown.LayoutOrder = LayoutOrderModule
                local TextLabel = Instance.new('TextLabel')
                if SelectedLanguage == "th" then
                    TextLabel.FontFace = Font.new("rbxasset://fonts/families/NotoSansThai.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TextLabel.TextSize = 13
                else
                    TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TextLabel.TextSize = 11
                end
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextTransparency = 0.20000000298023224
                TextLabel.Text = settings.title
                TextLabel.Size = UDim2.new(0, 207, 0, 13)
                TextLabel.BackgroundTransparency = 1
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel.BorderSizePixel = 0
                TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.Parent = Dropdown
                local Box = Instance.new('Frame')
                Box.ClipsDescendants = true
                Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Box.AnchorPoint = Vector2.new(0.5, 0)
                Box.BackgroundTransparency = 0.8999999761581421
                Box.Position = UDim2.new(0.5, 0, 1.2000000476837158, 0)
                Box.Name = 'Box'
                Box.Size = UDim2.new(0, 207, 0, 22)
                Box.BorderSizePixel = 0
                Box.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                Box.Parent = TextLabel
                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Box
                local Header = Instance.new('Frame')
                Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Header.AnchorPoint = Vector2.new(0.5, 0)
                Header.BackgroundTransparency = 1
                Header.Position = UDim2.new(0.5, 0, 0, 0)
                Header.Name = 'Header'
                Header.Size = UDim2.new(0, 207, 0, 22)
                Header.BorderSizePixel = 0
                Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Header.Parent = Box
                local CurrentOption = Instance.new('TextLabel')
                CurrentOption.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                CurrentOption.TextColor3 = Color3.fromRGB(255, 255, 255)
                CurrentOption.TextTransparency = 0.20000000298023224
                CurrentOption.Name = 'CurrentOption'
                CurrentOption.Size = UDim2.new(0, 161, 0, 13)
                CurrentOption.AnchorPoint = Vector2.new(0, 0.5)
                CurrentOption.Position = UDim2.new(0.04999988153576851, 0, 0.5, 0)
                CurrentOption.BackgroundTransparency = 1
                CurrentOption.TextXAlignment = Enum.TextXAlignment.Left
                CurrentOption.BorderSizePixel = 0
                CurrentOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
                CurrentOption.TextSize = 10
                CurrentOption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                CurrentOption.Parent = Header
                local UIGradient = Instance.new('UIGradient')
                UIGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.704, 0),
                    NumberSequenceKeypoint.new(0.872, 0.36250001192092896),
                    NumberSequenceKeypoint.new(1, 1)
                }
                UIGradient.Parent = CurrentOption
                local Arrow = Instance.new('ImageLabel')
                Arrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Arrow.AnchorPoint = Vector2.new(0, 0.5)
                Arrow.Image = 'rbxassetid://84232453189324'
                Arrow.BackgroundTransparency = 1
                Arrow.Position = UDim2.new(0.9100000262260437, 0, 0.5, 0)
                Arrow.Name = 'Arrow'
                Arrow.Size = UDim2.new(0, 8, 0, 8)
                Arrow.BorderSizePixel = 0
                Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Arrow.Parent = Header
                local Options = Instance.new('ScrollingFrame')
                Options.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
                Options.Active = true
                Options.ScrollBarImageTransparency = 1
                Options.AutomaticCanvasSize = Enum.AutomaticSize.XY
                Options.ScrollBarThickness = 0
                Options.Name = 'Options'
                Options.Size = UDim2.new(0, 207, 0, 0)
                Options.BackgroundTransparency = 1
                Options.Position = UDim2.new(0, 0, 1, 0)
                Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Options.BorderSizePixel = 0
                Options.CanvasSize = UDim2.new(0, 0, 0.5, 0)
                Options.Parent = Box
                local UIListLayout = Instance.new('UIListLayout')
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Parent = Options
                local UIPadding = Instance.new('UIPadding')
                UIPadding.PaddingTop = UDim.new(0, -1)
                UIPadding.PaddingLeft = UDim.new(0, 10)
                UIPadding.Parent = Options
                local UIListLayout = Instance.new('UIListLayout')
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Parent = Box
                function DropdownManager:update(option)
                    if settings.multi_dropdown then
                        if not Haspers._config._flags[settings.flag] then
                            Haspers._config._flags[settings.flag] = {}
                        end
                        local CurrentTargetValue = nil
                        if #Haspers._config._flags[settings.flag] > 0 then
                            CurrentTargetValue = convertTableToString(Haspers._config._flags[settings.flag])
                        end
                        local selected = {}
                        if CurrentTargetValue then
                            for value in string.gmatch(CurrentTargetValue, "([^,]+)") do
                                local trimmedValue = value:match("^%s*(.-)%s*$")
                                if trimmedValue ~= "Label" then
                                    table.insert(selected, trimmedValue)
                                end
                            end
                        else
                            for value in string.gmatch(CurrentOption.Text, "([^,]+)") do
                                local trimmedValue = value:match("^%s*(.-)%s*$")
                                if trimmedValue ~= "Label" then
                                    table.insert(selected, trimmedValue)
                                end
                            end
                        end
                        local CurrentTextGet = convertStringToTable(CurrentOption.Text)
                        local optionSkibidi = "nil"
                        if typeof(option) ~= 'string' then
                            optionSkibidi = option.Name
                        else
                            optionSkibidi = option
                        end
                        local found = false
                        for i, v in pairs(CurrentTextGet) do
                            if v == optionSkibidi then
                                table.remove(CurrentTextGet, i)
                                break
                            end
                        end
                        CurrentOption.Text = table.concat(selected, ", ")
                        local OptionsChild = {}
                        for _, object in Options:GetChildren() do
                            if object.Name == "Option" then
                                table.insert(OptionsChild, object.Text)
                                if table.find(selected, object.Text) then
                                    object.TextTransparency = 0.2
                                else
                                    object.TextTransparency = 0.6
                                end
                            end
                        end
                        CurrentTargetValue = convertStringToTable(CurrentOption.Text)
                        for _, v in CurrentTargetValue do
                            if not table.find(OptionsChild, v) and table.find(selected, v) then
                                table.remove(selected, _)
                            end
                        end
                        CurrentOption.Text = table.concat(selected, ", ")
                        Haspers._config._flags[settings.flag] = convertStringToTable(CurrentOption.Text)
                    else
                        CurrentOption.Text = (typeof(option) == "string" and option) or option.Name
                        for _, object in Options:GetChildren() do
                            if object.Name == "Option" then
                                if object.Text == CurrentOption.Text then
                                    object.TextTransparency = 0.2
                                else
                                    object.TextTransparency = 0.6
                                end
                            end
                        end
                        Haspers._config._flags[settings.flag] = option
                    end
                    Config:save(game.GameId, Haspers._config)
                    settings.callback(option)
                end
                local CurrentDropSizeState = 0
                function DropdownManager:unfold_settings()
                    self._state = not self._state
                    if self._state then
                        ModuleManager._multiplier += self._size
                        CurrentDropSizeState = self._size
                        TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(241, 93 + ModuleManager._size + ModuleManager._multiplier)
                        }):Play()
                        TweenService:Create(Module.Options, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(241, ModuleManager._size + ModuleManager._multiplier)
                        }):Play()
                        TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(207, 39 + self._size)
                        }):Play()
                        TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(207, 22 + self._size)
                        }):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Rotation = 180
                        }):Play()
                    else
                        ModuleManager._multiplier -= self._size
                        CurrentDropSizeState = 0
                        TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(241, 93 + ModuleManager._size + ModuleManager._multiplier)
                        }):Play()
                        TweenService:Create(Module.Options, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(241, ModuleManager._size + ModuleManager._multiplier)
                        }):Play()
                        TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(207, 39)
                        }):Play()
                        TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(207, 22)
                        }):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Rotation = 0
                        }):Play()
                    end
                end
                if #settings.options > 0 then
                    DropdownManager._size = 3
                    for index, value in settings.options do
                        local Option = Instance.new('TextButton')
                        Option.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                        Option.Active = false
                        Option.TextTransparency = 0.6000000238418579
                        Option.AnchorPoint = Vector2.new(0, 0.5)
                        Option.TextSize = 10
                        Option.Size = UDim2.new(0, 186, 0, 16)
                        Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        Option.Text = (typeof(value) == "string" and value) or value.Name
                        Option.AutoButtonColor = false
                        Option.Name = 'Option'
                        Option.BackgroundTransparency = 1
                        Option.TextXAlignment = Enum.TextXAlignment.Left
                        Option.Selectable = false
                        Option.Position = UDim2.new(0.04999988153576851, 0, 0.34210526943206787, 0)
                        Option.BorderSizePixel = 0
                        Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        Option.Parent = Options
                        local UIGradient = Instance.new('UIGradient')
                        UIGradient.Transparency = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(0.704, 0),
                            NumberSequenceKeypoint.new(0.872, 0.36250001192092896),
                            NumberSequenceKeypoint.new(1, 1)
                        }
                        UIGradient.Parent = Option
                        Option.MouseButton1Click:Connect(function()
                            if not Haspers._config._flags[settings.flag] then
                                Haspers._config._flags[settings.flag] = {}
                            end
                            if settings.multi_dropdown then
                                if table.find(Haspers._config._flags[settings.flag], value) then
                                    Haspers:remove_table_value(Haspers._config._flags[settings.flag], value)
                                else
                                    table.insert(Haspers._config._flags[settings.flag], value)
                                end
                            end
                            DropdownManager:update(value)
                        end)
                        if index > settings.maximum_options then
                            continue
                        end
                        DropdownManager._size += 16
                        Options.Size = UDim2.fromOffset(207, DropdownManager._size)
                    end
                end
                function DropdownManager:New(value)
                    Dropdown:Destroy(true)
                    value.OrderValue = Dropdown.LayoutOrder
                    ModuleManager._multiplier -= CurrentDropSizeState
                    return ModuleManager:create_dropdown(value)
                end
                if Haspers:flag_type(settings.flag, 'string') then
                    DropdownManager:update(Haspers._config._flags[settings.flag])
                else
                    DropdownManager:update(settings.options[1])
                end
                Dropdown.MouseButton1Click:Connect(function()
                    DropdownManager:unfold_settings()
                end)
                return DropdownManager
            end
            function ModuleManager:create_feature(settings)
                local checked = false
                LayoutOrderModule = LayoutOrderModule + 1
                if ModuleManager._size == 0 then
                    ModuleManager._size = 11
                end
                ModuleManager._size += 20
                if ModuleManager._state then
                    Module.Size = UDim2.fromOffset(241, 93 + ModuleManager._size)
                end
                Options.Size = UDim2.fromOffset(241, ModuleManager._size)
                local FeatureContainer = Instance.new("Frame")
                FeatureContainer.Size = UDim2.new(0, 207, 0, 16)
                FeatureContainer.BackgroundTransparency = 1
                FeatureContainer.Parent = Options
                FeatureContainer.LayoutOrder = LayoutOrderModule
                local UIListLayout = Instance.new("UIListLayout")
                UIListLayout.FillDirection = Enum.FillDirection.Horizontal
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Parent = FeatureContainer
                local FeatureButton = Instance.new("TextButton")
                FeatureButton.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                FeatureButton.TextSize = 11
                FeatureButton.Size = UDim2.new(1, -35, 0, 16)
                FeatureButton.BackgroundColor3 = Color3.fromRGB(32, 38, 51)
                FeatureButton.TextColor3 = Color3.fromRGB(210, 210, 210)
                FeatureButton.Text = "    " .. settings.title or "    " .. "Feature"
                FeatureButton.AutoButtonColor = false
                FeatureButton.TextXAlignment = Enum.TextXAlignment.Left
                FeatureButton.TextTransparency = 0.2
                FeatureButton.Parent = FeatureContainer
                local RightContainer = Instance.new("Frame")
                RightContainer.Size = UDim2.new(0, 45, 0, 16)
                RightContainer.BackgroundTransparency = 1
                RightContainer.Parent = FeatureContainer
                local RightLayout = Instance.new("UIListLayout")
                RightLayout.Padding = UDim.new(0.1, 0)
                RightLayout.FillDirection = Enum.FillDirection.Horizontal
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.Parent = RightContainer
                local KeybindBox = Instance.new("TextLabel")
                KeybindBox.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                KeybindBox.Size = UDim2.new(0, 15, 0, 15)
                KeybindBox.BackgroundColor3 = Color3.fromRGB(152, 181, 255)
                KeybindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeybindBox.TextSize = 11
                KeybindBox.BackgroundTransparency = 1
                KeybindBox.LayoutOrder = 2
                KeybindBox.Parent = RightContainer
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Size = UDim2.new(1, 0, 1, 0)
                KeybindButton.BackgroundTransparency = 1
                KeybindButton.TextTransparency = 1
                KeybindButton.Parent = KeybindBox
                local CheckboxCorner = Instance.new("UICorner", KeybindBox)
                CheckboxCorner.CornerRadius = UDim.new(0, 3)
                local UIStroke = Instance.new("UIStroke", KeybindBox)
                UIStroke.Color = Color3.fromRGB(152, 181, 255)
                UIStroke.Thickness = 1
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                if not Haspers._config._flags then
                    Haspers._config._flags = {}
                end
                if not Haspers._config._flags[settings.flag] then
                    Haspers._config._flags[settings.flag] = {
                        checked = false,
                        BIND = settings.default or "Unknown"
                    }
                end
                checked = Haspers._config._flags[settings.flag].checked
                KeybindBox.Text = Haspers._config._flags[settings.flag].BIND
                if KeybindBox.Text == "Unknown" then
                    KeybindBox.Text = "..."
                end
                local UseF_Var = nil
                if not settings.disablecheck then
                    local Checkbox = Instance.new("TextButton")
                    Checkbox.Size = UDim2.new(0, 15, 0, 15)
                    Checkbox.BackgroundColor3 = checked and Color3.fromRGB(152, 181, 255) or Color3.fromRGB(32, 38, 51)
                    Checkbox.Text = ""
                    Checkbox.Parent = RightContainer
                    Checkbox.LayoutOrder = 1
                    local UIStroke = Instance.new("UIStroke", Checkbox)
                    UIStroke.Color = Color3.fromRGB(152, 181, 255)
                    UIStroke.Thickness = 1
                    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    local CheckboxCorner = Instance.new("UICorner")
                    CheckboxCorner.CornerRadius = UDim.new(0, 3)
                    CheckboxCorner.Parent = Checkbox
                    local function toggleState()
                        checked = not checked
                        Checkbox.BackgroundColor3 = checked and Color3.fromRGB(152, 181, 255) or Color3.fromRGB(32, 38, 51)
                        Haspers._config._flags[settings.flag].checked = checked
                        Config:save(game.GameId, Haspers._config)
                        if settings.callback then
                            settings.callback(checked)
                        end
                    end
                    UseF_Var = toggleState
                    Checkbox.MouseButton1Click:Connect(toggleState)
                else
                    UseF_Var = function()
                        settings.button_callback()
                    end
                end
                KeybindButton.MouseButton1Click:Connect(function()
                    KeybindBox.Text = "..."
                    local inputConnection
                    inputConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            local newKey = input.KeyCode.Name
                            Haspers._config._flags[settings.flag].BIND = newKey
                            if newKey ~= "Unknown" then
                                KeybindBox.Text = newKey
                            end
                            Config:save(game.GameId, Haspers._config)
                            inputConnection:Disconnect()
                        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                            Haspers._config._flags[settings.flag].BIND = "Unknown"
                            KeybindBox.Text = "..."
                            Config:save(game.GameId, Haspers._config)
                            inputConnection:Disconnect()
                        end
                    end)
                    Connections["keybind_input_" .. settings.flag] = inputConnection
                end)
                local keyPressConnection
                keyPressConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode.Name == Haspers._config._flags[settings.flag].BIND then
                            UseF_Var()
                        end
                    end
                end)
                Connections["keybind_press_" .. settings.flag] = keyPressConnection
                FeatureButton.MouseButton1Click:Connect(function()
                    if settings.button_callback then
