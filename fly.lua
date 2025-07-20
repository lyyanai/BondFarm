local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

FLYING = true
local iyflyspeed = 50

local velocityHandlerName = "VelocityHandler"
local gyroHandlerName = "GyroHandler"
local mfly1
local mfly2

local function enableFlying()
    local root = HumanoidRootPart
    local camera = workspace.CurrentCamera
    local v3inf = Vector3.new(9e9, 9e9, 9e9)

    local controlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    local bv = Instance.new("BodyVelocity")
    bv.Name = velocityHandlerName
    bv.Parent = root
    bv.MaxForce = v3inf
    bv.Velocity = Vector3.new()

    local bg = Instance.new("BodyGyro")
    bg.Name = gyroHandlerName
    bg.Parent = root
    bg.MaxTorque = v3inf
    bg.P = 1000
    bg.D = 50

    mfly1 = LocalPlayer.CharacterAdded:Connect(function()
        bv.Parent = HumanoidRootPart
        bg.Parent = HumanoidRootPart
    end)

    mfly2 = RunService.RenderStepped:Connect(function()
        if FLYING then
            local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            local VelocityHandler = root:FindFirstChild(velocityHandlerName)
            local GyroHandler = root:FindFirstChild(gyroHandlerName)

            if humanoid and VelocityHandler and GyroHandler then
                GyroHandler.CFrame = camera.CoordinateFrame
                local direction = controlModule:GetMoveVector()

                VelocityHandler.Velocity = 
                    (camera.CFrame.RightVector * direction.X * iyflyspeed) +
                    (-camera.CFrame.LookVector * direction.Z * iyflyspeed)
            end
        end
    end)
end

enableFlying()
