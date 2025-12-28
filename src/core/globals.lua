--[[
    TITANIUM ULTIMATE: GLOBALS & SERVICES
    Centralized configuration and Roblox services.
]]

local Globals = {}

-- [ SERVICES ]
Globals.Services = setmetatable({}, {
    __index = function(self, key)
        local s = game:GetService(key)
        if s then self[key] = s return s end
    end
})

-- [ PLAYER DATA ]
Globals.Players = Globals.Services.Players
Globals.LocalPlayer = Globals.Players.LocalPlayer
Globals.RunService = Globals.Services.RunService
Globals.ReplicatedStorage = Globals.Services.ReplicatedStorage
Globals.UserInputService = Globals.Services.UserInputService

-- [ SHARED CONFIG ]
Globals.Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    Invisible = false,
    GodMode = false,
    InfiniteJump = false,
    AutoFarm = false,
    MassSteal = false,
    Distance = 25,
    AutoCollect = false,
    AutoRebirth = false
}

-- [ SHARED LOGGER ]
Globals.Logger = { Logs = {}, Instance = nil }
function Globals.Logger:Log(msg, type)
    type = type or "INFO"
    local timestamp = os.date("%H:%M:%S")
    local formatted = string.format("[%s] [%s] %s", timestamp, type, msg)
    table.insert(self.Logs, formatted)
    if #self.Logs > 100 then table.remove(self.Logs, 1) end
    if self.Instance then
        local current = self.Instance:GetContent()
        self.Instance:SetContent(current .. "\n" .. formatted)
    end
    print("[TITANIUM] " .. msg)
end

return Globals
