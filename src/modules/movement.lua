--[[
    TITANIUM ULTIMATE: MOVEMENT ENGINE
    Physics manipulation, Noclip, and Speed/Jump enforcement.
]]

local Movement = {}

function Movement.Initialize(Globals)
    local Character, Humanoid, HRP
    
    local function Bind(char)
        Character = char
        Humanoid = char:WaitForChild("Humanoid", 15)
        HRP = char:WaitForChild("HumanoidRootPart", 15)
    end
    if Globals.LocalPlayer.Character then Bind(Globals.LocalPlayer.Character) end
    Globals.LocalPlayer.CharacterAdded:Connect(Bind)

    Globals.RunService.Stepped:Connect(function()
        if Character then
            if Globals.Config.Noclip then
                for _, v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
            
            if Globals.Config.GodMode then
                for _, v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanTouch = false end
                end
            end
            
            if Globals.Config.Invisible then
                for _, v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("Decal") then
                        if v.Name ~= "HumanoidRootPart" then v.LocalTransparencyModifier = 1 end
                    end
                end
            end
            
            -- Speed/Jump Enforcement
            if Humanoid then
                if Humanoid.WalkSpeed ~= Globals.Config.WalkSpeed then
                    Humanoid.WalkSpeed = Globals.Config.WalkSpeed
                end
                if Humanoid.JumpPower ~= Globals.Config.JumpPower then
                    Humanoid.JumpPower = Globals.Config.JumpPower
                    Humanoid.UseJumpPower = true
                end
            end
        end
    end)

    Globals.UserInputService.JumpRequest:Connect(function()
        if Globals.Config.InfiniteJump and HRP then
            HRP.Velocity = Vector3.new(HRP.Velocity.X, Globals.Config.JumpPower, HRP.Velocity.Z)
        end
    end)
end

return Movement
