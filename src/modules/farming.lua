--[[
    TITANIUM ULTIMATE: FARMING ENGINE
    Automation, Magnet, and Remote Scanning.
]]

local Farming = { RemoteCache = {} }

function Farming.Initialize(Globals)
    local HRP
    local function Bind(char) HRP = char:WaitForChild("HumanoidRootPart", 15) end
    if Globals.LocalPlayer.Character then Bind(Globals.LocalPlayer.Character) end
    Globals.LocalPlayer.CharacterAdded:Connect(Bind)

    -- [ REMOTE SCANNER ]
    local function GetRemote(key)
        if Farming.RemoteCache[key] then return Farming.RemoteCache[key] end
        local keywords = {"Steal", "Slap", "Hit", "Rebirth", "Buy", "Hatch", "Claim"}
        for _, item in pairs(Globals.ReplicatedStorage:GetDescendants()) do
            if item:IsA("RemoteEvent") or item:IsA("RemoteFunction") then
                for _, k in ipairs(keywords) do
                    if item.Name:lower():find(k:lower()) and k == key then
                        Farming.RemoteCache[key] = item
                        return item
                    end
                end
            end
        end
    end

    -- [ FARM LOOP ]
    task.spawn(function()
        while true do
            pcall(function()
                if Globals.Config.AutoFarm and HRP then
                    local rem = GetRemote("Steal") or GetRemote("Slap")
                    if rem then
                        local targets = {}
                        for _, p in pairs(Globals.Players:GetPlayers()) do
                            if p ~= Globals.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                if (HRP.Position - p.Character.HumanoidRootPart.Position).Magnitude <= Globals.Config.Distance then
                                    table.insert(targets, p)
                                    if not Globals.Config.MassSteal then break end
                                end
                            end
                        end
                        for _, t in pairs(targets) do rem:FireServer(t) task.wait(0.01) end
                    end
                end
                
                if Globals.Config.AutoCollect and HRP then
                    for _, o in pairs(game.Workspace:GetChildren()) do
                        if o.Name:lower():find("brain") and o:IsA("BasePart") then o.CFrame = HRP.CFrame end
                    end
                end
                
                if Globals.Config.AutoRebirth then
                    local rb = GetRemote("Rebirth")
                    if rb then rb:FireServer() end
                end
            end)
            task.wait(0.15)
        end
    end)
end

return Farming
