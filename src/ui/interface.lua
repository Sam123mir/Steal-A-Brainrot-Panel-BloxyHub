--[[
    TITANIUM ULTIMATE: INTERFACE LAYER
    Main WindUI implementation.
]]

local Interface = {}

function Interface.Initialize(Globals, WindUI)
    Globals.Logger:Log("Initializing Main Interface...", "SYSTEM")
    
    local Window = WindUI:CreateWindow({
        Title = "TITANIUM ULTIMATE",
        Icon = "shield",
        Author = "by Bloxy Hub",
        Folder = "Titanium_Ultimate",
        Size = UDim2.fromOffset(580, 460),
        Transparent = true,
        Theme = "Dark",
        Keybind = Enum.KeyCode.RightControl
    })

    local Home = Window:Tab({ Title = "Dashboard", Icon = "layout" })
    local Farm = Window:Tab({ Title = "Auto Farm", Icon = "sword" })
    local Move = Window:Tab({ Title = "Movement", Icon = "zap" })
    local Ghost = Window:Tab({ Title = "Ghost Mode", Icon = "sparkles" })
    local Logs = Window:Tab({ Title = "System Logs", Icon = "scroll" })

    -- DASHBOARD
    local DashSec = Home:Section({ Title = "Session Metrics" })
    DashSec:Paragraph({ Title = "Security Status", Desc = "ACTIVE - Metatable Hooked" })
    local Metrics = DashSec:Paragraph({ Title = "Performance", Desc = "FPS: 60 | Ping: 0ms" })
    
    task.spawn(function()
        while true do
            local fps = math.floor(game:GetService("Stats").FrameRateManager.RenderAverage:GetValue())
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            Metrics:SetContent(string.format("FPS: %d | Ping: %dms", fps, ping), true)
            task.wait(1)
        end
    end)

    -- AUTO FARM
    local StealSec = Farm:Section({ Title = "Mass Steal Engine" })
    StealSec:Toggle({ Title = "Enable Auto Steal", Callback = function(v) Globals.Config.AutoFarm = v end })
    StealSec:Toggle({ Title = "Mass Steal (Multi-Target)", Callback = function(v) Globals.Config.MassSteal = v end })
    StealSec:Slider({ Title = "Range", Value = {Min = 5, Max = 100, Default = 25}, Callback = function(v) Globals.Config.Distance = v end })
    
    local AutoSec = Farm:Section({ Title = "Automation" })
    AutoSec:Toggle({ Title = "Magnet Brains", Callback = function(v) Globals.Config.AutoCollect = v end })
    AutoSec:Toggle({ Title = "Auto Rebirth", Callback = function(v) Globals.Config.AutoRebirth = v end })

    -- MOVEMENT
    local PhysSec = Move:Section({ Title = "Physics Manipulation" })
    PhysSec:Slider({ Title = "Walk Speed", Value = {Min = 16, Max = 500, Default = 16}, Callback = function(v) Globals.Config.WalkSpeed = v end })
    PhysSec:Slider({ Title = "Jump Power", Value = {Min = 50, Max = 500, Default = 50}, Callback = function(v) Globals.Config.JumpPower = v end })
    PhysSec:Toggle({ Title = "Infinite Jump", Callback = function(v) Globals.Config.InfiniteJump = v end })

    -- GHOST MODE
    local GhostSec = Ghost:Section({ Title = "Phase Powers" })
    GhostSec:Toggle({ Title = "Absolute Noclip", Callback = function(v) Globals.Config.Noclip = v end })
    GhostSec:Toggle({ Title = "FE Invisibility", Callback = function(v) 
        Globals.Config.Invisible = v 
        if not v and Globals.LocalPlayer.Character then
            for _, p in pairs(Globals.LocalPlayer.Character:GetDescendants()) do
                if (p:IsA("BasePart") or p:IsA("Decal")) and p.Name ~= "HumanoidRootPart" then p.LocalTransparencyModifier = 0 end
            end
        end
    end})
    GhostSec:Toggle({ Title = "God Mode (Untouchable)", Callback = function(v) Globals.Config.GodMode = v end })

    -- LOGS
    local LogCons = Logs:Paragraph({ Title = "📜 Console", Desc = "Script Initialized." })
    Globals.Logger.Instance = LogCons

    Home:Select()
    
    getgenv().TitaniumShutdown = function()
        Window:Destroy()
        getgenv().TitaniumActive = false
    end
end

return Interface
