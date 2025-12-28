--[[
    TITANIUM ULTIMATE: KEY SYSTEM
    Professional verification interface.
]]

local KeySystem = {}

function KeySystem.Initialize(WindUI, CorrectKey, OnSuccess)
    local KeyWindow = WindUI:CreateWindow({
        Title = "TITANIUM ACCESS",
        Icon = "key",
        Author = "Security Check",
        Folder = "Titanium_Keys",
        Size = UDim2.fromOffset(400, 310),
        Transparent = true,
        Theme = "Dark"
    })
    
    local Tab = KeyWindow:Tab({ Title = "Verification", Icon = "shield-check" })
    
    Tab:Paragraph({ Title = "Identity Verification", Desc = "Please enter your access key to continue using the Ultimate Edition." })
    
    local KeyInput = ""
    Tab:Input({
        Title = "Enter Access Key",
        Placeholder = "XXXX-XXXX-XXXX",
        Callback = function(v) KeyInput = v end
    })
    
    Tab:Button({
        Title = "Check Access Key",
        Callback = function()
            if KeyInput == CorrectKey then
                WindUI:Notify({ Title = "Access Granted", Desc = "Welcome to Titanium. Loading modules...", Duration = 3 })
                -- [ UI STABILITY PATCH ]
                -- Adding a small delay to allow Window:Destroy() to finish properly before building the new UI.
                task.spawn(function()
                    task.wait(0.5)
                    local ok, err = pcall(OnSuccess)
                    if not ok then
                        warn("[TITANIUM BOOT ERROR] " .. tostring(err))
                        WindUI:Notify({ Title = "Load Error", Desc = "Check Console for details.", Duration = 10 })
                    end
                end)
            else
                WindUI:Notify({ Title = "Access Denied", Desc = "Invalid or expired key.", Duration = 3 })
            end
        end
    })
    
    Tab:Button({
        Title = "Get Free Key",
        Callback = function()
            setclipboard(CorrectKey)
            WindUI:Notify({ Title = "Clipboard", Desc = "Key copied to clipboard! (TITANIUM-ELITE-FREE)", Duration = 3 })
        end
    })
    
    Tab:Select()
end

return KeySystem
