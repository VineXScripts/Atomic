local Bind = {
    Silent = {
        ["Enabled"] = false,
        ["Hit Part"] = "Head",
        FOV = {
            ["Enabled"] = false,
            Size = {
                X = 25
            },
            ["Weapons Configuration"] = {
                ["Enabled"] = false,
                Shotguns = {
                    X = 15
                },
                Pistols = {
                    X = 8
                }
            }
        },
        Prediction = {
            X = 0.131,
            Y = 0.131,
            Z = 0.131
        },
        ["Closest Point"] = {
            ["Point Scale"] = 1.0
        },
        ["Client Bullet Redirection"] = {
            ["Enabled"] = true,
            Prediction = {
                X = 0.131,
                Y = 0.131,
                Z = 0.131
            },
            Weapons = {
                "M4A1",
                "AK47"
            }
        }
    },
    Cam = {
        ["Enabled"] = false,
        ["XPrediction"] = 0.13,
        ["YPrediction"] = 0.13,
        ["Part"] = "Head",
        ["Keybind"] = "c",
        ["UseShake"] = false,
        ["ShakeMultiplyer"] = 1,
        ["ShakeValue"] = 40,
        ["UseSmoothing"] = false,
        ["SmoothingAmount"] = 0.02,
        ["EasingStyle"] = Enum.EasingStyle.Linear,
        ["EasingDirection"] = Enum.EasingDirection.In,
        ["Resolver"] = false,
        ["ResolverTune"] = 0.13,
        ["UseCircleRadius"] = false,
        ["UnlockOnTargetDeath"] = false,
        ["UnlockOnOwnDeath"] = false,
        FieldOfView = {
            ["Visible"] = false,
            ["Filled"] = false,
            ["Color"] = Color3.fromRGB(74, 253, 3),
            ["Transparency"] = 1,
            ["Radius"] = 30,
        },
    },
    Both = {
        ["Notifications"] = false,
        ["Duration"] = 3,
        ["VisibleCheck"] = false,
        ["FriendCheck"] = false,
        ["CrewCheck"] = false,
        ["TeamCheck"] = false,
    },
    Misc = {
        ["WalkSpeedEnabled"] = false,
        ["WalkSpeedKey"] = "v",
        ["WalkSpeedValue"] = 40,
        ["RapidFireEnabled"] = false,
        ["FireRate"] = 0,
    },
}

-- hookfunction security
local exe_name, exe_version = identifyexecutor()
local function home999() end
local function home888() end

if exe_name ~= "Wave Windows" then
    hookfunction(home888, home999)
    if isfunctionhooked(home888) == false then
        game.Players.LocalPlayer:Destroy()
        return LPH_CRASH()
    end
end 

local function check_env(env)
    for _, func in env do
        if type(func) ~= "function" then
            continue
        end

        local functionhook = isfunctionhooked(func)

        if functionhook then
            game.Players.LocalPlayer:Destroy()
            return LPH_CRASH()
        end
    end
end

check_env(getgenv())
check_env(getrenv())

local Lua_Fetch_Connections = getconnections
local Lua_Fetch_Upvalues = getupvalues
local Lua_Hook = hookfunction 
local Lua_Hook_Method = hookmetamethod
local Lua_Unhook = restorefunction
local Lua_Replace_Function = replaceclosure
local Lua_Set_Upvalue = setupvalue
local Lua_Clone_Function = clonefunction

local Game_RunService = game:GetService("RunService")
local Game_LogService = game:GetService("LogService")
local Game_LogService_MessageOut = Game_LogService.MessageOut

local String_Lower = string.lower
local Table_Find = table.find
local Get_Type = type

local Current_Connections = {};
local Hooked_Connections = {};

local function Test_Table(Table, Return_Type)
    for TABLE_INDEX, TABLE_VALUE in Table do
        if type(TABLE_VALUE) == String_Lower(Return_Type) then
            return TABLE_VALUE, TABLE_INDEX
        end
        continue
    end
end

local function Print_Table(Table)
    table.foreach(Table, print)
end

if getgenv().DEBUG then
    print("[auth.injected.live] Waiting...")
end

local good_check = 0

function auth_heart()
    return true, true
end

function Lua_Common_Intercept(old, ...)
    print(...)
    return old(...)
end

function XVNP_L(CONNECTION)
    local s, e = pcall(function()
        local OPENAC_TABLE = Lua_Fetch_Upvalues(CONNECTION.Function)[9]
        local OPENAC_FUNCTION = OPENAC_TABLE[1]
        local IGNORED_INDEX = {3, 12, 1, 11, 15, 8, 20, 18, 22}

        Lua_Set_Upvalue(OPENAC_FUNCTION, 14, function(...)
            return function(...)
                local args = {...}
                if type(args[1]) == "table" and args[1][1] then
                    pcall(function()
                        if type(args[1][1]) == "userdata" then
                            args[1][1]:Disconnect()
                            args[1][2]:Disconnect()
                            args[1][3]:Disconnect()
                            args[1][4]:Disconnect()
                        end
                    end)
                end 
            end
        end)

        Lua_Set_Upvalue(OPENAC_FUNCTION, 1, function(...)
            task.wait(200)
        end)

        hookfunction(OPENAC_FUNCTION, function(...)
            return {}
        end)
    end)
end

local XVNP_LASTUPDATE = 0
local XVNP_UPDATEINTERVAL = 5

local XVNP_CONNECTIONSNIFFER;

XVNP_CONNECTIONSNIFFER = Game_RunService.RenderStepped:Connect(function()
    if #Lua_Fetch_Connections(Game_LogService_MessageOut) >= 2 then
        XVNP_CONNECTIONSNIFFER:Disconnect()
    end

    if tick() - XVNP_LASTUPDATE >= XVNP_UPDATEINTERVAL then
        XVNP_LASTUPDATE = tick() 
        local OpenAc_Connections = Lua_Fetch_Connections(Game_LogService_MessageOut)
        for _, CONNECTION in OpenAc_Connections do
            if not table.find(Current_Connections, CONNECTION) then
                table.insert(Current_Connections, CONNECTION)
                table.insert(Hooked_Connections, CONNECTION)
                XVNP_L(CONNECTION)
            end
        end
    end
end)

local last_beat = 0
Game_RunService.RenderStepped:Connect(function()
    if last_beat + 1 < tick() then
        last_beat = tick() + 1 
        local what, are = auth_heart()
        if not are or not what then
            if good_check <= 0 then
                game.Players.LocalPlayer:Destroy()
                return LPH_CRASH()
            else
                good_check -=1
            end
        else
            good_check += 1
        end
    end
end)

if getgenv().DEBUG then
    print("[auth.injected.live] Started Emulation Thread")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local lastMousePos = Vector2.new(0, 0)
local cachedTarget = nil

local hojixvz
local MrChosenOne
local CamLocking
local hojixv = Drawing.new("Circle")

local CamCircleFOV = Drawing.new("Circle")
CamCircleFOV.Color = Bind.Cam.FieldOfView.Color
CamCircleFOV.Thickness = 1
CamCircleFOV.NumSides = 9e9
CamCircleFOV.Radius = Bind.Cam.FieldOfView.Radius*3
CamCircleFOV.Transparency = Bind.Cam.FieldOfView.Transparency
CamCircleFOV.Visible = Bind.Cam.FieldOfView.Visible
CamCircleFOV.Filled = Bind.Cam.FieldOfView.Filled

game:GetService("RunService").heartbeat:Connect(function()
    CamCircleFOV.Position = Vector2.new(Mouse.X, Mouse.Y+35)
    task.wait()
end)

local libary = loadstring(game:HttpGet("https://raw.githubusercontent.com/imagoodpersond/puppyware/main/lib"))()
local NotifyLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/imagoodpersond/puppyware/main/notify"))()
local Notify = NotifyLibrary.Notify
makefolder("Example")

local Window = libary:new({name = "Atomic Ware | Beta", accent = Color3.fromRGB(74, 253, 3), textsize = 13})
local Main = Window:page({name = "Legit"})
local MiscTab = Window:page({name = "Rage"})

local Silentaim = Main:section({name = "Silent", side = "left", size = 320})
local Camlock = Main:section({name = "Camlock", side = "right", size = 520})
local ChecksSection = Main:section({name = "Checks", side = "left", size = 190})

local WalkSpeedSection = MiscTab:section({name = "WalkSpeed", side = "left", size = 120})
local FeaturesSection = MiscTab:section({name = "Features", side = "right", size = 120})

WalkSpeedSection:toggle({name = "Enabled", def = Bind.Misc.WalkSpeedEnabled, callback = function(Boolean)
    Bind.Misc.WalkSpeedEnabled = Boolean
    if Bind.Both.Notifications then
        Notify(Boolean and "WalkSpeed Enabled" or "WalkSpeed Disabled")
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if Bind.Misc.WalkSpeedEnabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = Bind.Misc.WalkSpeedValue
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end})

WalkSpeedSection:textbox({name = "Key", def = Bind.Misc.WalkSpeedKey, callback = function(Value)
    Bind.Misc.WalkSpeedKey = Value:sub(1, 1):lower()
end})

WalkSpeedSection:slider({name = "Speed", def = Bind.Misc.WalkSpeedValue, max = 1000, min = 16, rounding = false, callback = function(Value)
    Bind.Misc.WalkSpeedValue = Value
    if Bind.Misc.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Value
        if Bind.Both.Notifications then
            Notify("WalkSpeed Set to: " .. Value)
        end
    end
end})

local function applySpeed()
    if Bind.Misc.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Bind.Misc.WalkSpeedValue
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid", 5)
    wait(0.1)
    applySpeed()
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode[Bind.Misc.WalkSpeedKey:upper()] then
        Bind.Misc.WalkSpeedEnabled = not Bind.Misc.WalkSpeedEnabled
        if Bind.Misc.WalkSpeedEnabled then
            applySpeed()
            if Bind.Both.Notifications then
                Notify("WalkSpeed Enabled: " .. Bind.Misc.WalkSpeedValue)
            end
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
                if Bind.Both.Notifications then
                    Notify("WalkSpeed Disabled")
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Bind.Misc.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.WalkSpeed ~= Bind.Misc.WalkSpeedValue then
            LocalPlayer.Character.Humanoid.WalkSpeed = Bind.Misc.WalkSpeedValue
        end
    end
end)

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local holding = false
local tool = nil

local function findTool()
    tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
end

local function rapidFire()
    while holding and Bind.Misc.RapidFireEnabled do
        if tool then
            tool:Activate()
        end
        wait(Bind.Misc.FireRate)
    end
end

uis.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Bind.Misc.RapidFireEnabled then
        findTool()
        if tool then
            holding = true
            rapidFire()
        end
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        holding = false
    end
end)

FeaturesSection:toggle({name = "Rapid Fire", def = Bind.Misc.RapidFireEnabled, callback = function(Boolean)
    Bind.Misc.RapidFireEnabled = Boolean
    if Bind.Both.Notifications then
        Notify(Boolean and "Rapid Fire Enabled" or "Rapid Fire Disabled")
    end
end})

FeaturesSection:slider({name = "Fire Rate", def = Bind.Misc.FireRate, max = 10, min = 0, rounding = false, callback = function(Value)
    Bind.Misc.FireRate = Value
end})

Silentaim:toggle({name = "Enabled", def = Bind.Silent.Enabled, callback = function(Boolean)
    Bind.Silent.Enabled = Boolean
end})

Silentaim:toggle({name = "Show FOV", def = Bind.Silent.FOV.Enabled, callback = function(Boolean)
    Bind.Silent.FOV.Enabled = Boolean
    hojixv.Visible = Boolean
end})

Silentaim:dropdown({name = "Hit Part", def = Bind.Silent["Hit Part"], max = 2, options = {"Head", "Closest Point"}, callback = function(part)
    Bind.Silent["Hit Part"] = part
end})

Silentaim:slider({name = "FOV Radius", def = Bind.Silent.FOV.Size.X, max = 250, min = 1, rounding = true, callback = function(Value)
    Bind.Silent.FOV.Size.X = Value
    hojixv.Radius = Value * 5
end})

Silentaim:slider({name = "Point Scale", def = Bind.Silent["Closest Point"]["Point Scale"], max = 2.0, min = 0.1, rounding = false, callback = function(Value)
    Bind.Silent["Closest Point"]["Point Scale"] = Value
end})

Silentaim:textbox({name = "Prediction X", def = tostring(Bind.Silent.Prediction.X), callback = function(Value)
    Bind.Silent.Prediction.X = tonumber(Value) or 0.131
end})

Silentaim:textbox({name = "Prediction Y", def = tostring(Bind.Silent.Prediction.Y), callback = function(Value)
    Bind.Silent.Prediction.Y = tonumber(Value) or 0.131
end})

Silentaim:textbox({name = "Prediction Z", def = tostring(Bind.Silent.Prediction.Z), callback = function(Value)
    Bind.Silent.Prediction.Z = tonumber(Value) or 0.131
end})

Silentaim:colorpicker({name = "FOV Color", def = Bind.Silent.FOV.Color or Color3.fromRGB(74, 253, 3), callback = function(Color)
    Bind.Silent.FOV.Color = Color
    hojixv.Color = Color
end})

Camlock:toggle({name = "Enabled", def = Bind.Cam.Enabled, callback = function(Boolean)
    Bind.Cam.Enabled = Boolean
end})

Camlock:toggle({name = "Smooth", def = Bind.Cam.UseSmoothing, callback = function(Boolean)
    Bind.Cam.UseSmoothing = Boolean
end})

Camlock:toggle({name = "Shake", def = Bind.Cam.UseShake, callback = function(Boolean)
    Bind.Cam.UseShake = Boolean
end})

Camlock:toggle({name = "Show FOV", def = Bind.Cam.FieldOfView.Visible, callback = function(Boolean)
    Bind.Cam.FieldOfView.Visible = Boolean
    CamCircleFOV.Visible = Boolean
end})

Camlock:toggle({name = "Use Radius", def = Bind.Cam.UseCircleRadius, callback = function(Boolean)
    Bind.Cam.UseCircleRadius = Boolean
end})

Camlock:toggle({name = "Resolver", def = Bind.Cam.Resolver, callback = function(Boolean)
    Bind.Cam.Resolver = Boolean
end})

Camlock:toggle({name = "Unlock Target", def = Bind.Cam.UnlockOnTargetDeath, callback = function(Boolean)
    Bind.Cam.UnlockOnTargetDeath = Boolean
end})

Camlock:toggle({name = "Unlock Own", def = Bind.Cam.UnlockOnOwnDeath, callback = function(Boolean)
    Bind.Cam.UnlockOnOwnDeath = Boolean
end})

Camlock:textbox({name = "X Pred", def = tostring(Bind.Cam.XPrediction), callback = function(Value)
    Bind.Cam.XPrediction = tonumber(Value) or 0.13
end})

Camlock:textbox({name = "Y Pred", def = tostring(Bind.Cam.YPrediction), callback = function(Value)
    Bind.Cam.YPrediction = tonumber(Value) or 0.13
end})

Camlock:slider({name = "Smooth Amount", def = Bind.Cam.SmoothingAmount, max = 1, min = 0.001, rounding = false, callback = function(Value)
    Bind.Cam.SmoothingAmount = Value
end})

Camlock:slider({name = "Shake Value", def = Bind.Cam.ShakeValue, max = 100, min = 1, rounding = false, callback = function(Value)
    Bind.Cam.ShakeValue = Value
end})

Camlock:slider({name = "Shake Multiplier", def = Bind.Cam.ShakeMultiplyer, max = 10, min = 1, rounding = false, callback = function(Value)
    Bind.Cam.ShakeMultiplyer = Value
end})

Camlock:slider({name = "Resolver Tune", def = Bind.Cam.ResolverTune, max = 0.2, min = 0.1, rounding = false, callback = function(Value)
    Bind.Cam.ResolverTune = Value
end})

Camlock:slider({name = "Radius", def = Bind.Cam.FieldOfView.Radius, max = 250, min = 1, rounding = false, callback = function(Value)
    Bind.Cam.FieldOfView.Radius = Value
    CamCircleFOV.Radius = Value*3
end})

Camlock:dropdown({name = "Part", def = Bind.Cam.Part, max = 4, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, callback = function(part)
    Bind.Cam.Part = part
end})

Camlock:textbox({name = "Key", def = Bind.Cam.Keybind, callback = function(Value)
    Bind.Cam.Keybind = Value:sub(1, 1):lower()
end})

Camlock:colorpicker({name = "FOV Color", def = Bind.Cam.FieldOfView.Color, callback = function(Color)
    Bind.Cam.FieldOfView.Color = Color
    CamCircleFOV.Color = Color
end})

ChecksSection:toggle({name = "Visible", def = Bind.Both.VisibleCheck, callback = function(Boolean)
    Bind.Both.VisibleCheck = Boolean
end})

ChecksSection:toggle({name = "Friend", def = Bind.Both.FriendCheck, callback = function(Boolean)
    Bind.Both.FriendCheck = Boolean
end})

ChecksSection:toggle({name = "Crew", def = Bind.Both.CrewCheck, callback = function(Boolean)
    Bind.Both.CrewCheck = Boolean
end})

ChecksSection:toggle({name = "Team", def = Bind.Both.TeamCheck, callback = function(Boolean)
    Bind.Both.TeamCheck = Boolean
end})

function Notify(Text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Bind",
        Text = Text,
        Duration = Bind.Both.Duration,
    })
end

function ClosestPlayer()
    local NearestPlayer = nil
    local shortestDistance = 300
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= game.Players.LocalPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local otherPlayerPosition = otherPlayer.Character.HumanoidRootPart.Position
            local pos = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(otherPlayerPosition)
            local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)).Magnitude
            if distance < shortestDistance then
                if Bind.Cam.UseCircleRadius and distance < CamCircleFOV.Radius then
                    NearestPlayer = otherPlayer
                    shortestDistance = distance
                else
                    NearestPlayer = otherPlayer
                    shortestDistance = distance
                end
            end
        end
    end
    return NearestPlayer
end

local function getClosestPart(player)
    local bestPart, bestDist = nil, math.huge
    local pointScale = Bind.Silent["Closest Point"]["Point Scale"] or 1.0
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local partPos = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (lastMousePos - partPos).Magnitude * pointScale
                    if dist < bestDist then
                        bestPart, bestDist = part, dist
                    end
                end
            end
        end
    end
    return bestPart
end

hojixv.Color = Bind.Silent.FOV.Color or Color3.fromRGB(74, 253, 3)
hojixv.Thickness = 1
hojixv.NumSides = 100
hojixv.Radius = Bind.Silent.FOV.Size.X * 5
hojixv.Transparency = 1
hojixv.Visible = Bind.Silent.FOV.Enabled
hojixv.Filled = false

local function updateFOV()
    local mouse = game.Players.LocalPlayer:GetMouse()
    local mousePos = Vector2.new(mouse.X, mouse.Y + 36)
    lastMousePos = mousePos

    local fovConfig = Bind.Silent.FOV
    local currentTool = nil

    if LocalPlayer.Character then
        currentTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    end

    local radius = fovConfig.Size.X * 5
    if fovConfig["Weapons Configuration"] and fovConfig["Weapons Configuration"].Enabled and currentTool then
        local weaponName = string.lower(currentTool.Name or "")
        if string.find(weaponName, "shotgun") then
            radius = fovConfig["Weapons Configuration"].Shotguns.X * 5
        elseif string.find(weaponName, "pistol") then
            radius = fovConfig["Weapons Configuration"].Pistols.X * 5
        end
    end

    hojixv.Radius = radius
    hojixv.Position = mousePos
    hojixv.Visible = Bind.Silent.FOV.Enabled
    hojixv.Filled = false
    hojixv.Color = Bind.Silent.FOV.Color or Color3.fromRGB(74, 253, 3)

    local bestPart, bestDist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local part = nil
            if Bind.Silent["Hit Part"] == "Closest Point" then
                part = getClosestPart(player)
            else
                part = player.Character:FindFirstChild("Head")
            end
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local partPos = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (mousePos - partPos).Magnitude
                    if dist < bestDist and dist <= radius then
                        local validTarget = true
                        if Bind.Both.VisibleCheck then
                            if player.Character.Head.Transparency > 0.5 then
                                validTarget = false
                            end
                        end
                        if Bind.Both.CrewCheck then
                            if player.DataFolder and player.DataFolder.Information:FindFirstChild("Crew") and LocalPlayer.DataFolder and LocalPlayer.DataFolder.Information:FindFirstChild("Crew") then
                                if player.DataFolder.Information.Crew.Value == LocalPlayer.DataFolder.Information.Crew.Value then
                                    validTarget = false
                                end
                            end
                        end
                        if Bind.Both.FriendCheck then
                            if LocalPlayer:IsFriendsWith(player.UserId) then
                                validTarget = false
                            end
                        end
                        if Bind.Both.TeamCheck then
                            if player.Team == LocalPlayer.Team then
                                validTarget = false
                            end
                        end
                        if validTarget then
                            bestPart, bestDist = part, dist
                        end
                    end
                end
            end
        end
    end

    cachedTarget = bestPart
end

RunService.RenderStepped:Connect(updateFOV)

local function applyPrediction(cf, offset)
    return cf * CFrame.new(offset.X, offset.Y, offset.Z)
end

local function isTargetValid(target)
    if not target or not target.Parent or not target.Parent.Parent then return false end
    local player = Players:GetPlayerFromCharacter(target.Parent)
    if not player then return false end

    local valid = true
    if Bind.Both.VisibleCheck then
        if target.Parent.Head.Transparency > 0.5 then
            valid = false
        end
    end
    if Bind.Both.CrewCheck then
        if player.DataFolder and player.DataFolder.Information:FindFirstChild("Crew") and LocalPlayer.DataFolder and LocalPlayer.DataFolder.Information:FindFirstChild("Crew") then
            if player.DataFolder.Information.Crew.Value == LocalPlayer.DataFolder.Information.Crew.Value then
                valid = false
            end
        end
    end
    if Bind.Both.FriendCheck then
        if LocalPlayer:IsFriendsWith(player.UserId) then
            valid = false
        end
    end
    if Bind.Both.TeamCheck then
        if player.Team == LocalPlayer.Team then
            valid = false
        end
    end
    return valid
end

local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index
mt.__index = newcclosure(function(obj, prop)
    if obj:IsA("Mouse") and (prop == "Hit" or prop == "Target") and Bind.Silent.Enabled then
        local target = cachedTarget
        if target and isTargetValid(target) then
            local prediction = Bind.Silent.Prediction
            local redir = Bind.Silent["Client Bullet Redirection"]
            local currentTool = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")) or nil
            if redir.Enabled and currentTool then
                local toolName = tostring(currentTool.Name)
                for _, weapon in ipairs(redir.Weapons) do
                    if string.find(string.lower(toolName), string.lower(weapon)) then
                        prediction = redir.Prediction
                        break
                    end
                end
            end
            local predMultiplier = Vector3.new(prediction.X, prediction.Y, prediction.Z)
            local offset = target.Velocity * predMultiplier
            if prop == "Hit" then
                return applyPrediction(target.CFrame, offset)
            else
                return target
            end
        end
    end
    return oldIndex(obj, prop)
end)

RunService.Heartbeat:Connect(function()
    if not Bind.Silent.Enabled then return end
    local target = cachedTarget
    local currentTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if target and currentTool and currentTool:FindFirstChild("Activate") and isTargetValid(target) then
        currentTool:Activate()
    end
end)

CamKeybind = false

Mouse.KeyDown:Connect(function(ChosenKey)
    if ChosenKey == Bind.Cam.Keybind and Bind.Cam.Enabled then
        if CamKeybind == false then
            CamKeybind = true
            MrChosenOne = ClosestPlayer()
            if Bind.Both.Notifications then
                Notify("Locked Onto "..MrChosenOne.DisplayName)
            end
        elseif CamKeybind == true then
            CamKeybind = false
            if Bind.Both.Notifications then
                Notify("No Longer Locked On")
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait()
        if CamKeybind then
            if CamKeybind and MrChosenOne and MrChosenOne.Parent then
                local Opp = MrChosenOne.Character[Bind.Cam.Part].Position + Vector3.new(
                    MrChosenOne.Character[Bind.Cam.Part].Velocity.X * Bind.Cam.XPrediction,
                    MrChosenOne.Character[Bind.Cam.Part].Velocity.Y * Bind.Cam.YPrediction,
                    0
                )
                local Mop = MrChosenOne.Character.Humanoid.MoveDirection
                if Bind.Cam.Resolver and CamKeybind and MrChosenOne then
                    Mop = Mop * 16
                    Opp = MrChosenOne.Character[Bind.Cam.Part].Position + Mop * Bind.Cam.ResolverTune
                end
                if Bind.Cam.UseSmoothing == true then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.p, Opp), Bind.Cam.SmoothingAmount, Bind.Cam.EasingStyle, Bind.Cam.EasingDirection)
                    if Bind.Cam.UseShake then
                        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.p, Opp + Vector3.new(math.random(-Bind.Cam.ShakeValue,Bind.Cam.ShakeValue),math.random(-Bind.Cam.ShakeValue,Bind.Cam.ShakeValue),math.random(-Bind.Cam.ShakeValue,Bind.Cam.ShakeValue)) * Bind.Cam.ShakeMultiplyer), Bind.Cam.SmoothingAmount, Bind.Cam.EasingStyle, Bind.Cam.EasingDirection)
                    end
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.p, Opp)
                    if Bind.Cam.UseShake then
                        Camera.CFrame = CFrame.new(Camera.CFrame.p, Opp + Vector3.new(math.random(-Bind.Cam.ShakeValue,Bind.Cam.ShakeValue),math.random(-Bind.Cam.ShakeValue,Bind.Cam.ShakeValue),math.random(-Bind.Cam.ShakeValue,Bind.Cam.ShakeValue)) * Bind.Cam.ShakeMultiplyer)
                    end
                end
                if Bind.Cam.UnlockOnTargetDeath then
                    if MrChosenOne.Character.BodyEffects["K.O"].Value then
                        CamKeybind = false
                        if Bind.Both.Notifications then
                            Notify("No Longer Attached")
                        end
                    end
                end 
                if Bind.Cam.UnlockOnOwnDeath then
                    if game.Players.LocalPlayer.Character.BodyEffects["K.O"].Value then
                        CamKeybind = false
                        if Bind.Both.Notifications then
                            Notify("No Longer Attached")
                        end
                    end
                end 
                if Bind.Both.VisibleCheck then
                    if MrChosenOne.Character.Head.Transparency > 0.5 then
                        CamKeybind = false
                        if Bind.Both.Notifications then
                            Notify("No Longer Attached")
                        end
                    end
                end
                if Bind.Both.CrewCheck then
                    if MrChosenOne.DataFolder.Information:FindFirstChild("Crew").Value == game.Players.LocalPlayer.DataFolder.Information:FindFirstChild("Crew").Value then
                        CamKeybind = false
                        if Bind.Both.Notifications then
                            Notify("No Longer Attached")
                        end
                    end
                end
                if Bind.Both.FriendCheck then
                    if game.Players.LocalPlayer:IsFriendsWith(MrChosenOne.UserId) then
                        CamKeybind = false
                        if Bind.Both.Notifications then
                            Notify("No Longer Attached")
                        end
                    end
                end
                if Bind.Both.TeamCheck then
                    if MrChosenOne.Team == game.Players.LocalPlayer.Team then
                        CamKeybind = false
                        if Bind.Both.Notifications then
                            Notify("No Longer Attached")
                        end
                    end
                end
            end
        end
    end
end)

for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if v:IsA("Script") and v.Name ~= "Health" and v.Name ~= "Sound" and v:FindFirstChild("LocalScript") then
        v:Destroy()
    end
end
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    repeat
        wait()
    until game.Players.LocalPlayer.Character
    char.ChildAdded:Connect(function(child)
        if child:IsA("Script") then 
            wait(0.1)
            if child:FindFirstChild("LocalScript") then
                child.LocalScript:FireServer()
            end
        end
    end)
end)

for _, con in next, getconnections(workspace.CurrentCamera.Changed) do
    task.wait()
    con:Disable()
end
for _, con in next, getconnections(workspace.CurrentCamera:GetPropertyChangedSignal("CFrame")) do
    task.wait()
    con:Disable()
end

for _, key in next, getgc(true) do 
    local function changeKey(instanceType)
        if pcall(function() return rawget(key, instanceType) end) and typeof(rawget(key, instanceType)) == 'table' and (rawget(key, instanceType))[1] == 'kick' then
            key.tvk = {
                'kick',
                function() 
                    return game.Workspace:WaitForChild('')
                end
            }
        end
    end
    changeKey('indexInstance')
    changeKey('namecallInstance')
end
