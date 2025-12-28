--[[
    TITANIUM ULTIMATE: SECURITY LAYER
    Hardened Metatable Hooks and Anti-Kill safeguards.
]]

local Security = {}

function Security.Initialize(Globals)
    Globals.Logger:Log("Hardening Security Meta-Layers...", "SECURITY")
    
    local function CheckCap(cap, name)
        if not cap then Globals.Logger:Log("Missing capability: " .. name, "WARN") return false end
        return true
    end

    if CheckCap(getrawmetatable, "getrawmetatable") and CheckCap(setreadonly, "setreadonly") then
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        local oldIndex = mt.__index
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (method == "Kick" or method == "kick") then
                Globals.Logger:Log("Blocked Anti-Cheat Kick Attempt", "PROTECT")
                return nil
            end
            return oldNamecall(self, ...)
        end)
        
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() then
                if key == "Kick" or key == "kick" then
                    return function() end
                elseif key == "Health" and self:IsA("Humanoid") and Globals.Config.GodMode then
                    return 100
                end
            end
            return oldIndex(self, key)
        end)
        setreadonly(mt, true)
    end
    
    if CheckCap(hookfunction, "hookfunction") then
        pcall(function()
            local oldBreak
            oldBreak = hookfunction(game.BreakJoints, newcclosure(function(self)
                if not checkcaller() and Globals.Config.GodMode and self == Globals.LocalPlayer.Character then
                    Globals.Logger:Log("Blocked Instance Death Request", "PROTECT")
                    return nil
                end
                return oldBreak(self)
            end))
        end)

        -- [ COMPLETE TELEPORT GUARD ]
        local TeleportService = game:GetService("TeleportService")
        local methods = {"Teleport", "TeleportToPlaceInstance", "TeleportToSpawn", "TeleportToPrivateServer", "TeleportAsync"}
        
        for _, method in ipairs(methods) do
            local old
            old = hookfunction(TeleportService[method], newcclosure(function(self, ...)
                if not checkcaller() then
                    Globals.Logger:Log("Blocked Critical Teleport Attempt: " .. method, "SECURITY")
                    return nil
                end
                return old(self, ...)
            end))
        end
    end
end

return Security
