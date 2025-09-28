lua
-- Load Haspers library
local Haspers = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zuelessx/Haspers-lib/main/Haspers.lua"))()
local HaspersUI = Haspers.new()
HaspersUI:load()

-- Define tabs
local BlatantTab = HaspersUI:create_tab("Blatant", "rbxassetid://76499042599127")
local PlayerTab = HaspersUI:create_tab("Player", "rbxassetid://126017907477623")
local WorldTab = HaspersUI:create_tab("World", "rbxassetid://7733964126")
local MicTab = HaspersUI:create_tab("Misc", "rbxassetid://10723424838")

-- Define skybox data (replace placeholder IDs with real rbxassetid:// values)
local skyboxData = {
    Default = {0, 0, 0, 0, 0, 0},
    Vaporwave = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    Redshift = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    Desert = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    DaBaby = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    Minecraft = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    SpongeBob = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    Skibidi = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    Blaze = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    ["Pussy Cat"] = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    ["Among Us"] = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    ["Space Wave"] = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    ["Space Wave2"] = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    ["Turquoise Wave"] = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    ["Dark Night"] = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    ["Bright Pink"] = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    ["White Galaxy"] = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789},
    ["Blue Galaxy"] = {123456789, 123456789, 123456789, 123456789, 123456789, 123456789}
}
local skyen = false
local selectedSky = "Default"

-- Define applySkybox function
local function applySkybox(skyName)
    local Lighting = game:GetService("Lighting")
    local Sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    local faces = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}
    local skyData = skyboxData[skyName] or skyboxData.Default
    for i, face in ipairs(faces) do
        Sky[face] = "rbxassetid://" .. skyData[i]
    end
    Lighting.GlobalShadows = not skyen
end

-- Original script content from 67.txt
local Players = game:GetService('Players')
local Player = Players.LocalPlayer
local ContextActionService = game:GetService('ContextActionService')
local Phantom = false

local function BlockMovement(actionName, inputState, inputObject)
    return Enum.ContextActionResult.Sink
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
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Tornado_Time = tick()
local UserInputService = game:GetService('UserInputService')
local Last_Input = UserInputService:GetLastInputType()
local Debris = game:GetService('Debris')
local RunService = game:GetService('RunService')
local Vector2_Mouse_Location = nil
local Grab_Parry = nil
local Remotes = {}
local Parry_Key = nil
local Speed_Divisor_Multiplier = 1.1
local LobbyAP_Speed_Divisor_Multiplier = 1.1
local firstParryFired = false
local ParryThreshold = 2.5
local firstParryType = 'F_Key'
local Previous_Positions = {}
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualInputService = game:GetService("VirtualInputManager")
local GuiService = game:GetService('GuiService')

local function performFirstPress(parryType)
    if parryType == 'F_Key' then
        VirtualInputService:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
    elseif parryType == 'Left_Click' then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    elseif parryType == 'Navigation' then
        local button = Players.LocalPlayer.PlayerGui.Hotbar.Block
        updateNavigation(button)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.01)
        updateNavigation(nil)
    end
end

if not LPH_OBFUSCATED then
    function LPH_JIT(Function) return Function end
    function LPH_JIT_MAX(Function) return Function end
    function LPH_NO_VIRTUALIZE(Function) return Function end
end

local PropertyChangeOrder = {}
local HashOne, HashTwo, HashThree

LPH_NO_VIRTUALIZE(function()
    for Index, Value in next, getgc() do
        if rawequal(typeof(Value), "function") and islclosure(Value) and getrenv().debug.info(Value, "s"):find("SwordsController") then
            if rawequal(getrenv().debug.info(Value, "l"), 276) then
                HashOne = getconstant(Value, 62)
                HashTwo = getconstant(Value, 64)
                HashThree = getconstant(Value, 65)
            end
        end 
    end
end)()

LPH_NO_VIRTUALIZE(function()
    for Index, Object in next, game:GetDescendants() do
        if Object:IsA("RemoteEvent") and string.find(Object.Name, "\n") then
            Object.Changed:Once(function()
                table.insert(PropertyChangeOrder, Object)
            end)
        end
    end
end)()

repeat
    task.wait()
until #PropertyChangeOrder == 3

local ShouldPlayerJump = PropertyChangeOrder[1]
local MainRemote = PropertyChangeOrder[2]
local GetOpponentPosition = PropertyChangeOrder[3]

local Parry_Key
for Index, Value in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Hotbar.Block.Activated)) do
    if Value and Value.Function and not iscclosure(Value.Function) then
        for Index2, Value2 in pairs(getupvalues(Value.Function)) do
            if type(Value2) == "function" then
                Parry_Key = getupvalue(getupvalue(Value2, 2), 17)
            end
        end
    end
end

local function Parry(...)
    ShouldPlayerJump:FireServer(HashOne, Parry_Key, ...)
    MainRemote:FireServer(HashTwo, Parry_Key, ...)
    GetOpponentPosition:FireServer(HashThree, Parry_Key, ...)
end

local Parries = 0

function create_animation(object, info, value)
    local animation = game:GetService('TweenService'):Create(object, info, value)
    animation:Play()
    task.wait(info.Time)
    Debris:AddItem(animation, 0)
    animation:Destroy()
    animation = nil
end

local Animation = {}
Animation.storage = {}
Animation.current = nil
Animation.track = nil

for _, v in pairs(game:GetService("ReplicatedStorage").Misc.Emotes:GetChildren()) do
    if v:IsA("Animation") and v:GetAttribute("EmoteName") then
        local Emote_Name = v:GetAttribute("EmoteName")
        Animation.storage[Emote_Name] = v
    end
end

local Emotes_Data = {}
for Object in pairs(Animation.storage) do
    table.insert(Emotes_Data, Object)
end
table.sort(Emotes_Data)

local Auto_Parry = {}

function Auto_Parry.Parry_Animation()
    local Parry_Animation = game:GetService("ReplicatedStorage").Shared.SwordAPI.Collection.Default:FindFirstChild('GrabParry')
    local Current_Sword = Player.Character:GetAttribute('CurrentlyEquippedSword')
    if not Current_Sword then
        return
    end
    if not Parry_Animation then
        return
    end
    local Sword_Data = game:GetService("ReplicatedStorage").Shared.ReplicatedInstances.Swords.GetSword:Invoke(Current_Sword)
    if not Sword_Data or not Sword_Data['AnimationType'] then
        return
    end
    for _, object in pairs(game:GetService('ReplicatedStorage').Shared.SwordAPI.Collection:GetChildren()) do
        if object.Name == Sword_Data['AnimationType'] then
            if object:FindFirstChild('GrabParry') or object:FindFirstChild('Grab') then
                local sword_animation_type = 'GrabParry'
                if object:FindFirstChild('Grab') then
                    sword_animation_type = 'Grab'
                end
                Parry_Animation = object[sword_animation_type]
            end
        end
    end
    Grab_Parry = Player.Character.Humanoid.Animator:LoadAnimation(Parry_Animation)
    Grab_Parry:Play()
end

function Auto_Parry.Play_Animation(v)
    local Animations = Animation.storage[v]
    if not Animations then
        return false
    end
    local Animator = Player.Character.Humanoid.Animator
    if Animation.track then
        Animation.track:Stop()
    end
    Animation.track = Animator:LoadAnimation(Animations)
    Animation.track:Play()
    Animation.current = v
end

function Auto_Parry.Get_Balls()
    local Balls = {}
    for _, Instance in pairs(workspace.Balls:GetChildren()) do
        if Instance:GetAttribute('realBall') then
            Instance.CanCollide = false
            table.insert(Balls, Instance)
        end
    end
    return Balls
end

function Auto_Parry.Get_Ball()
    for _, Instance in pairs(workspace.Balls:GetChildren()) do
        if Instance:GetAttribute('realBall') then
            Instance.CanCollide = false
            return Instance
        end
    end
end

function Auto_Parry.Lobby_Balls()
    for _, Instance in pairs(workspace.TrainingBalls:GetChildren()) do
        if Instance:GetAttribute("realBall") then
            return Instance
        end
    end
end

local Closest_Entity = nil

function Auto_Parry.Closest_Player()
    local Max_Distance = math.huge
    local Found_Entity = nil
    for _, Entity in pairs(workspace.Alive:GetChildren()) do
        if tostring(Entity) ~= tostring(Player) then
            if Entity.PrimaryPart then
                local Distance = Player:DistanceFromCharacter(Entity.PrimaryPart.Position)
                if Distance < Max_Distance then
                    Max_Distance = Distance
                    Found_Entity = Entity
                end
            end
        end
    end
    Closest_Entity = Found_Entity
    return Found_Entity
end

function Auto_Parry:Get_Entity_Properties()
    Auto_Parry.Closest_Player()
    if not Closest_Entity then
        return false
    end
    local Entity_Velocity = Closest_Entity.PrimaryPart.Velocity
    local Entity_Direction = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit
    local Entity_Distance = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
    return {
        Velocity = Entity_Velocity,
        Direction = Entity_Direction,
        Distance = Entity_Distance
    }
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

function Auto_Parry.Parry_Data(Parry_Type)
    Auto_Parry.Closest_Player()
    local Events = {}
    local Camera = workspace.CurrentCamera
    local Vector2_Mouse_Location
    if Last_Input == Enum.UserInputType.MouseButton1 or (Enum.UserInputType.MouseButton2 or Last_Input == Enum.UserInputType.Keyboard) then
        local Mouse_Location = UserInputService:GetMouseLocation()
        Vector2_Mouse_Location = {Mouse_Location.X, Mouse_Location.Y}
    else
        Vector2_Mouse_Location = {Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2}
    end
    if isMobile then
        Vector2_Mouse_Location = {Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2}
    end
    local Players_Screen_Positions = {}
    for _, v in pairs(workspace.Alive:GetChildren()) do
        if v ~= Player.Character then
            local worldPos = v.PrimaryPart.Position
            local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)
            if isOnScreen then
                Players_Screen_Positions[v] = Vector2.new(screenPos.X, screenPos.Y)
            end
            Events[tostring(v)] = screenPos
        end
    end
    if Parry_Type == 'Camera' then
        return {0, Camera.CFrame, Events, Vector2_Mouse_Location}
    end
    if Parry_Type == 'Backwards' then
        local Backwards_Direction = Camera.CFrame.LookVector * -10000
        Backwards_Direction = Vector3.new(Backwards_Direction.X, 0, Backwards_Direction.Z)
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Backwards_Direction), Events, Vector2_Mouse_Location}
    end
    if Parry_Type == 'Straight' then
        local Aimed_Player = nil
        local Closest_Distance = math.huge
        local Mouse_Vector = Vector2.new(Vector2_Mouse_Location[1], Vector2_Mouse_Location[2])
        for _, v in pairs(workspace.Alive:GetChildren()) do
            if v ~= Player.Character then
                local worldPos = v.PrimaryPart.Position
                local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)
                if isOnScreen then
                    local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (Mouse_Vector - playerScreenPos).Magnitude
                    if distance < Closest_Distance then
                        Closest_Distance = distance
                        Aimed_Player = v
                    end
                end
            end
        end
        if Aimed_Player then
            return {0, CFrame.new(Player.Character.PrimaryPart.Position, Aimed_Player.PrimaryPart.Position), Events, Vector2_Mouse_Location}
        else
            return {0, CFrame.new(Player.Character.PrimaryPart.Position, Closest_Entity.PrimaryPart.Position), Events, Vector2_Mouse_Location}
        end
    end
    if Parry_Type == 'Random' then
        return {0, CFrame.new(Camera.CFrame.Position, Vector3.new(math.random(-4000, 4000), math.random(-4000, 4000), math.random(-4000, 4000))), Events, Vector2_Mouse_Location}
    end
    if Parry_Type == 'High' then
        local High_Direction = Camera.CFrame.UpVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + High_Direction), Events, Vector2_Mouse_Location}
    end
    if Parry_Type == 'Left' then
        local Left_Direction = Camera.CFrame.RightVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position - Left_Direction), Events, Vector2_Mouse_Location}
    end
    if Parry_Type == 'Right' then
        local Right_Direction = Camera.CFrame.RightVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Right_Direction), Events, Vector2_Mouse_Location}
    end
    if Parry_Type == 'RandomTarget' then
        local candidates = {}
        for _, v in pairs(workspace.Alive:GetChildren()) do
            if v ~= Player.Character and v.PrimaryPart then
                local screenPos, isOnScreen = Camera:WorldToScreenPoint(v.PrimaryPart.Position)
                if isOnScreen then
                    table.insert(candidates, {
                        character = v,
                        screenXY = { screenPos.X, screenPos.Y }
                    })
                end
            end
        end
        if #candidates > 0 then
            local pick = candidates[math.random(1, #candidates)]
            local lookCFrame = CFrame.new(Player.Character.PrimaryPart.Position, pick.character.PrimaryPart.Position)
            return {0, lookCFrame, Events, pick.screenXY}
        else
            return {0, Camera.CFrame, Events, { Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2 }}
        end
    end
    return Parry_Type
end

function Auto_Parry.Parry(Parry_Type)
    local Parry_Data = Auto_Parry.Parry_Data(Parry_Type)
    if not firstParryFired then
        performFirstPress(firstParryType)
        firstParryFired = true
    else
        Parry(Parry_Data[1], Parry_Data[2], Parry_Data[3], Parry_Data[4])
    end
    if Parries > 7 then
        return false
    end
    Parries += 1
    task.delay(0.5, function()
        if Parries > 0 then
            Parries -= 1
        end
    end)
end

local Lerp_Radians = 0
local Last_Warping = tick()

function Auto_Parry.Linear_Interpolation(a, b, time_volume)
    return a + (b - a) * time_volume
end

local Previous_Velocity = {}
local Curving = tick()
local Runtime = workspace.Runtime

function Auto_Parry.Is_Curved()
    local Ball = Auto_Parry.Get_Ball()
    if not Ball then
        return false
    end
    local Zoomies = Ball:FindFirstChild('zoomies')
    if not Zoomies then
        return false
    end
    local Velocity = Zoomies.VectorVelocity
    local Ball_Direction = Velocity.Unit
    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball_Direction)
    local Speed = Velocity.Magnitude
    local Speed_Threshold = math.min(Speed / 100, 40)
    local Direction_Difference = (Ball_Direction - Velocity).Unit
    local Direction_Similarity = Direction:Dot(Direction_Difference)
    local Dot_Difference = Dot - Direction_Similarity
    local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Pings = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
    local Dot_Threshold = 0.5 - (Pings / 1000)
    local Reach_Time = Distance / Speed - (Pings / 1000)
    local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Speed_Threshold
    local Clamped_Dot = math.clamp(Dot, -1, 1)
    local Radians = math.rad(math.asin(Clamped_Dot))
    Lerp_Radians = Auto_Parry.Linear_Interpolation(Lerp_Radians, Radians, 0.8)
    if Speed > 100 and Reach_Time > Pings / 10 then
        Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
    end
    if Distance < Ball_Distance_Threshold then
        return false
    end
    if Dot_Difference < Dot_Threshold then
        return true
    end
    if Lerp_Radians < 0.018 then
        Last_Warping = tick()
    end
    if (tick() - Last_Warping) < (Reach_Time / 1.5) then
        return true
    end
    if (tick() - Curving) < (Reach_Time / 1.5) then
        return true
    end
    return Dot < Dot_Threshold
end

function Auto_Parry:Get_Ball_Properties()
    local Ball = Auto_Parry.Get_Ball()
    local Ball_Velocity = Vector3.zero
    local Ball_Origin = Ball
    local Ball_Direction = (Player.Character.PrimaryPart.Position - Ball_Origin.Position).Unit
    local Ball_Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Ball_Dot = Ball_Direction:Dot(Ball_Velocity.Unit)
    return {
        Velocity = Ball_Velocity,
        Direction = Ball_Direction,
        Distance = Ball_Distance,
        Dot = Ball_Dot
    }
end

function Auto_Parry.Spam_Service(self)
    local Ball = Auto_Parry.Get_Ball()
    local Entity = Auto_Parry.Closest_Player()
    if not Ball or not Entity then
        return false
    end
    local BallProps = Auto_Parry:Get_Ball_Properties()
    if not BallProps then
        return false
    end
    local Distance = BallProps.Distance
    local Dot = BallProps.Dot
    local Speed = BallProps.Velocity.Magnitude
    local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue() / 1000
    local ReachTime = Distance / Speed - Ping
    if Distance < 15 or (Dot > 0.5 and ReachTime < 0.5) then
        Auto_Parry.Parry("Camera")
        Auto_Parry.Parry_Animation()
        return true
    end
    return false
end

-- Custom Sky Module
local SkyModule = WorldTab:create_module({
    title = "Custom Sky",
    description = "Changes Sky",
    section = "left",
    flag = "change_sky",
    callback = function(state)
        local Lighting = game:GetService("Lighting")
        local Sky = Lighting:FindFirstChildOfClass("Sky")
        if state then
            print("[ Debug ] Custom Sky Enabled")
            skyen = true
            if not Sky then
                Sky = Instance.new("Sky", Lighting)
            end
            while task.wait(1) and state do
                applySkybox(selectedSky)
            end
        else
            print("[ Debug ] Custom Sky Disabled")
            if Sky then
                Sky:Destroy()
            end
            skyen = false
            Lighting.GlobalShadows = true
        end
    end
})

SkyModule:create_dropdown({
    title = "Selected Sky",
    flag = "select_sky",
    options = {"Default", "Vaporwave", "Redshift", "Desert", "DaBaby", "Minecraft", "SpongeBob", "Skibidi", "Blaze", "Pussy Cat", "Among Us", "Space Wave", "Space Wave2", "Turquoise Wave", "Dark Night", "Bright Pink", "White Galaxy", "Blue Galaxy"},
    maximum_options = 18,
    multi_dropdown = false,
    callback = function(option)
        selectedSky = option
        print("[ Debug ] Selected Sky: " .. option)
        applySkybox(option)
    end
})

-- Lookat Ball Module
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer
local lookAtBallToggle = false
local parryLookType = "Camera"
local playerConn, cameraConn = nil, nil

local function GetBall()
    for _, Ball in ipairs(workspace.Balls:GetChildren()) do
        if Ball:GetAttribute("realBall") then
            return Ball
        end
    end
end

local function EnableLookAt()
    if parryLookType == "Character" then
        playerConn = RunService.Stepped:Connect(function()
            local Ball = GetBall()
            local Character = Player.Character
            if not Ball or not Character then return end
            local HRP = Character:FindFirstChild("HumanoidRootPart")
            if not HRP then return end
            local lookPos = Vector3.new(Ball.Position.X, HRP.Position.Y, Ball.Position.Z)
            HRP.CFrame = CFrame.lookAt(HRP.Position, lookPos)
        end)
    elseif parryLookType == "Camera" then
        cameraConn = RunService.RenderStepped:Connect(function()
            local Ball = GetBall()
            if not Ball then return end
            local camPos = Camera.CFrame.Position
            Camera.CFrame = CFrame.lookAt(camPos, Ball.Position)
        end)
    end
end

local function DisableLookAt()
    if playerConn then playerConn:Disconnect() playerConn = nil end
    if cameraConn then cameraConn:Disconnect() cameraConn = nil end
end

local LookatModule = WorldTab:create_module({
    title = "Lookat Ball",
    description = "Look The Ball",
    section = "right",
    flag = "look_ball",
    callback = function(value)
        lookAtBallToggle = value
        if value then
            EnableLookAt()
        else
            DisableLookAt()
        end
    end
})

LookatModule:create_dropdown({
    title = "Look Type",
    flag = "look_type",
    options = {"Camera", "Character"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(value)
        parryLookType = value
        if lookAtBallToggle then
            DisableLookAt()
            EnableLookAt()
        end
    end
})

-- Skin Changer Module
local enabled = false
local swordName = ""
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local swords = require(rs:WaitForChild("Shared", 9e9):WaitForChild("ReplicatedInstances", 9e9):WaitForChild("Swords", 9e9))
local ctrl, playFx, lastParry = nil, nil, 0
local function getSlash(name)
    local s = swords:GetSword(name)
    return (s and s.SlashName) or "SlashEffect"
end
local function setSword()
    if not enabled then return end
    setupvalue(rawget(swords, "EquipSwordTo"), 2, false)
    swords:EquipSwordTo(p.Character, swordName)
    ctrl:SetSword(swordName)
end
updateSword = function()
    setSword()
end
while task.wait() and not ctrl do
    for _, v in getconnections(rs.Remotes.FireSwordInfo.OnClientEvent) do
        if v.Function and islclosure(v.Function) then
            local u = getupvalues(v.Function)
            if #u == 1 and type(u[1]) == "table" then
                ctrl = u[1]
                break
            end
        end
    end
end
local parryConnA, parryConnB
while task.wait() and not parryConnA do
    for _, v in getconnections(rs.Remotes.ParrySuccessAll.OnClientEvent) do
        if v.Function and getinfo(v.Function).name == "parrySuccessAll" then
            parryConnA, playFx = v, v.Function
            v:Disable()
            break
        end
    end
end
while task.wait() and not parryConnB do
    for _, v in getconnections(rs.Remotes.ParrySuccessClient.Event) do
        if v.Function and getinfo(v.Function).name == "parrySuccessAll" then
            parryConnB = v
            v:Disable()
            break
        end
    end
end
rs.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(...)
    setthreadidentity(2)
    local args = {...}
    if tostring(args[4]) ~= p.Name then
        lastParry = tick()
    elseif enabled then
        args[1] = getSlash(swordName)
        args[3] = swordName
    end
    return playFx(unpack(args))
end)
task.spawn(function()
    while task.wait(1) do
        if enabled and swordName ~= "" then
            local c = p.Character or p.CharacterAdded:Wait()
            if p:GetAttribute("CurrentlyEquippedSword") ~= swordName or not c:FindFirstChild(swordName) then
                setSword()
            end
            for _, m in pairs(c:GetChildren()) do
                if m:IsA("Model") and m.Name ~= swordName then
                    m:Destroy()
                end
                task.wait()
            end
        end
    end
end)

local SkinChangerModule = MicTab:create_module({
    title = "Skin Changer",
    description = "Change Sword Skin",
    section = "left",
    flag = "skin_changer",
    callback = function(state)
        enabled = state
    end
})

SkinChangerModule:create_textbox({
    title = "↓ Skin Name [Case Sensitive] ↓",
    placeholder = "Enter Sword Name...",
    flag = "skin_input",
    callback = function(value)
        swordName = value
    end
})

-- Auto Play Module
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local targetDistance = 30
local autoPlayConnection = nil
local lastTargetTime = 0
local targetDuration = 0

local AutoPlayModule = MicTab:create_module({
    title = "Auto Play",
    description = "Use AI To Play Automatically",
    section = "right",
    flag = "auto_play",
    callback = function(enabled)
        if enabled then
            autoPlayConnection = RunService.RenderStepped:Connect(function()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                rootPart = player.Character.HumanoidRootPart
                local ball
                for _, b in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
                    if b:GetAttribute("realBall") then
                        ball = b
                        break
                    end
                end
                if not ball then return end
                local dir = (ball.Position - rootPart.Position).Unit
                local dist = (ball.Position - rootPart.Position).Magnitude
                local speed = ball.Velocity.Magnitude
                local currentTime = tick()
                local ballTarget = ball:GetAttribute("target")
                if ballTarget == player.Name then
                    if currentTime - lastTargetTime < 0.2 then
                        targetDuration += RunService.RenderStepped:Wait()
                    else
                        targetDuration = 0
                    end
                    lastTargetTime = currentTime
                else
                    targetDuration = 0
                end
                for _, key in pairs({"W", "A", "S", "D"}) do
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end
                if dist < targetDistance or targetDuration > 0.5 then
                    local backDir = -dir
                    local backPos = rootPart.Position + backDir * 6
                    local safeToBack = true
                    for _, other in ipairs(Players:GetPlayers()) do
                        if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                            local otherHRP = other.Character.HumanoidRootPart
                            if (otherHRP.Position - backPos).Magnitude < 5 then
                                safeToBack = false
                                break
                            end
                        end
                    end
                    if safeToBack then
                        VirtualInputManager:SendKeyEvent(true, "S", false, game)
                    else
                        local sideKey = math.random(1, 2) == 1 and "A" or "D"
                        VirtualInputManager:SendKeyEvent(true, sideKey, false, game)
                    end
                    return
                end
                local buffer = 5
                if dist > targetDistance + buffer then
                    VirtualInputManager:SendKeyEvent(true, "W", false, game)
                elseif speed > 120 then
                    local dodgeKey = math.random(1, 2) == 1 and "A" or "D"
                    VirtualInputManager:SendKeyEvent(true, dodgeKey, false, game)
                elseif math.random() < 0.01 then
                    VirtualInputManager:SendKeyEvent(true, "W", false, game)
                end
            end)
        else
            if autoPlayConnection then
                autoPlayConnection:Disconnect()
                autoPlayConnection = nil
            end
            for _, key in pairs({"W", "A", "S", "D"}) do
                VirtualInputManager:SendKeyEvent(false, key, false, game)
            end
        end
    end
})

AutoPlayModule:create_checkbox({
    title = "Anti AFK",
    flag = "anti_afk",
    callback = function(value)
    end
})

AutoPlayModule:create_checkbox({
    title = "Enable Jumping [soon]",
    flag = "enable_jump",
    callback = function(state)
    end
})

AutoPlayModule:create_checkbox({
    title = "Notify",
    flag = "notify5",
    callback = function(value)
    end
})

AutoPlayModule:create_divider({
    showtopic = true,
    title = "",
    disableline = false
})

AutoPlayModule:create_slider({
    title = "Distance From Ball",
    flag = "1",
    minimum_value = 1,
    maximum_value = 100,
    value = 30,
    round_number = true,
    callback = function(value)
        targetDistance = value
    end
})

AutoPlayModule:create_slider({
    title = "Speed Multiplier",
    flag = "2",
    minimum_value = 1,
    maximum_value = 100,
    value = 70,
    round_number = true,
    callback = function(value)
    end
})

AutoPlayModule:create_slider({
    title = "Transversing",
    flag = "3",
    minimum_value = 10,
    maximum_value = 150,
    value = 25,
    round_number = true,
    callback = function(value)
    end
})

AutoPlayModule:create_slider({
    title = "Direction",
    flag = "4",
    minimum_value = 0.1,
    maximum_value = 1,
    value = 1,
    round_number = false,
    callback = function(value)
    end
})

AutoPlayModule:create_slider({
    title = "Offset Factor",
    flag = "5",
    minimum_value = 1,
    maximum_value = 5,
    value = 2,
    round_number = true,
    callback = function(value)
    end
})

AutoPlayModule:create_slider({
    title = "Movement Duration",
    flag = "6",
    minimum_value = 1,
    maximum_value = 8,
    value = 6,
    round_number = true,
    callback = function(value)
    end
})

AutoPlayModule:create_slider({
    title = "Generation Threshold",
    flag = "7",
    minimum_value = 1,
    maximum_value = 10,
    value = 2,
    round_number = true,
    callback = function(value)
    end
})

AutoPlayModule:create_slider({
    title = "Jump Chance [soon]",
    flag = "8",
    minimum_value = 1,
    maximum_value = 50,
    value = 50,
    round_number = true,
    callback = function(value)
    end
})

AutoPlayModule:create_slider({
    title = "Double Jump Chance [soon]",
    flag = "9",
    minimum_value = 1,
    maximum_value = 50,
    value = 50,
    round_number = true,
    callback = function(value)
    end
})

-- Ball Stats Module
local statsGui = nil
local statsConnection = nil

local StatModule = MicTab:create_module({
    title = "Ball Stats",
    description = "Show Ball Index",
    section = "left",
    flag = "ball_stats",
    callback = function(value)
        if value then
            local player = Players.LocalPlayer
            statsGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
            statsGui.Name = "BallStatsUI"
            statsGui.ResetOnSpawn = false
            local frame = Instance.new("Frame", statsGui)
            frame.Size = UDim2.new(0, 180, 0, 80)
            frame.Position = UDim2.new(1, -200, 0, 100)
            frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
            frame.BackgroundTransparency = 0.2
            frame.BorderSizePixel = 0
            frame.Active = true
            frame.Draggable = true
            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1, -10, 1, -10)
            label.Position = UDim2.new(0, 5, 0, 5)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextYAlignment = Enum.TextYAlignment.Top
            label.Text = "Loading..."
            statsConnection = RunService.RenderStepped:Connect(function()
                local function GetBall()
                    for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
                        if Ball:GetAttribute("realBall") then
                            return Ball
                        end
                    end
                end
                local ball = GetBall()
                if not ball then
                    label.Text = "No ball found"
                    return
                end
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local speed = math.floor(ball.Velocity.Magnitude)
                local distance = math.floor((ball.Position - hrp.Position).Magnitude)
                local target = ball:GetAttribute("target") or "N/A"
                local status = speed < 3 and "Idle" or "Flying"
                label.Text = string.format(
                    "⚽ Ball Stats | Zeryx\nSpeed: %s\nDistance: %s\nTarget: %s",
                    speed, distance, target
                )
            end)
        else
            if statsConnection then
                statsConnection:Disconnect()
                statsConnection = nil
            end
            if statsGui then
                statsGui:Destroy()
                statsGui = nil
            end
        end
    end
})

-- Visualize Module
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local fieldPart = nil
local visualizeConnection = nil

local VisualizeModule = MicTab:create_module({
    title = "Visualize",
    description = "Show Visualize",
    section = "right",
    flag = "visu_alize",
    callback = function(value)
        if value then
            if not fieldPart then
                fieldPart = Instance.new("Part")
                fieldPart.Anchored = true
                fieldPart.CanCollide = false
                fieldPart.Transparency = 0.5
                fieldPart.Shape = Enum.PartType.Ball
                fieldPart.Material = Enum.Material.ForceField
                fieldPart.CastShadow = false
                fieldPart.Color = Color3.fromRGB(88, 131, 202)
                fieldPart.Name = "VisualField"
                fieldPart.Parent = workspace
            end
            visualizeConnection = RunService.RenderStepped:Connect(function()
                local function GetBall()
                    for _, Ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
                        if Ball:GetAttribute("realBall") then
                            return Ball
                        end
                    end
                end
                local ball = GetBall()
                if not ball then return end
                local ballVel = ball.AssemblyLinearVelocity
                local speed = ballVel.Magnitude
                local size = math.clamp(speed, 25, 250)
                fieldPart.Position = root.Position
                fieldPart.Size = Vector3.new(size, size, size)
            end)
        else
            if visualizeConnection then
                visualizeConnection:Disconnect()
                visualizeConnection = nil
            end
            if fieldPart then
                fieldPart:Destroy()
                fieldPart = nil
            end
        end
    end
})
