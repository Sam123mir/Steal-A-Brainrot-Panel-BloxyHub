--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║               TITANIUM ULTIMATE: ORCHESTRATOR-X              ║
    ║           Engineered for Steal a Brainrot (Pro)              ║
    ║        Professional Modular Loader | WindUI | KeySystem      ║
    ╚══════════════════════════════════════════════════════════════╝
    Status: Modular Edition (Highest Professionalism)
]]

-- [ MOBILE-SAFE NOTIFY ]
local function Status(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 6
        })
    end)
    print("[TITANIUM] " .. title .. ": " .. text)
end

Status("BOOTING", "Titanium Modular Loader v2")

-- [ LOADER CONFIG ]
local GITHUB_USER = "Sam123mir"
local GITHUB_REPO = "Steal-A-Brainrot-Panel-BloxyHub"
local GITHUB_BRANCH = "main"

-- Set to 'false' if you already uploaded your files to GitHub!
-- Set to 'true' if you have the 'src' folder in your executor's workspace.
local USE_LOCAL = false 
local BASE_PATH = "src/" 

-- [ VIRTUAL MODULE LOADER ]
local function Import(path)
    local success, result
    if USE_LOCAL then
        local full_path = BASE_PATH .. path
        if not isfile(full_path) then
            Status("MISSING FILE", "Local path not found: " .. path)
            return nil
        end
        success, result = pcall(function() return loadstring(readfile(full_path))() end)
    else
        -- Cloud Loader with explicit 404 detection
        local cloud_url = string.format("https://raw.githubusercontent.com/%s/%s/%s/src/%s", GITHUB_USER, GITHUB_REPO, GITHUB_BRANCH, path)
        local http_success, content = pcall(function() return game:HttpGet(cloud_url) end)
        
        if not http_success or not content or content:find("404") or content:len() < 10 then
            Status("REPO ERROR", "File NOT FOUND on GitHub: " .. path)
            error("404 Error: " .. path .. " is missing from your repository.")
        end

        success, result = pcall(function() return loadstring(content)() end)
    end
    
    if not success or result == nil then
        Status("SYNTAX ERROR", "Check code in: " .. path)
        error("Module " .. path .. " has a syntax error: " .. tostring(result))
    end
    
    return result
end

-- [ MASTER BOOT SEQUENCE ]
local run_status, run_error = pcall(function()
    -- 1. Fetch Interface Engine (WindUI)
    Status("CORE", "Fetching UI Engine...")
    local ui_get = game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
    local WindUI = loadstring(ui_get)()
    if not WindUI then error("WindUI API Offline or Invalid.") end

    -- 2. Load Modular Infrastructure
    Status("SYMPHONY", "Syncing Core Modules...")
    local Globals = Import("core/globals.lua")
    local Security = Import("core/security.lua")
    
    -- [ TIER-0: EARLY PROTECTION ] 
    -- We activate this BEFORE the Key System to stop server hops immediately.
    if Security and Globals then 
        Security.Initialize(Globals) 
        Status("SHIELD", "Teleport Guard & Anti-Kick Active.")
    end

    local Movement = Import("modules/movement.lua")
    local Farming = Import("modules/farming.lua")
    local Interface = Import("ui/interface.lua")
    local KeySystem = Import("ui/keysystem.lua")

    if not Globals or not KeySystem then
        error("Critical System Components Missing. Check GitHub folder names (src/core, src/ui, etc.)")
    end

    -- 3. Professional Initialization Logic
    local function BootMain()
        Status("TIER-1", "Initializing Physics Engines...")
        if Movement then Movement.Initialize(Globals) end
        
        Status("TIER-2", "Activating Farming Engines...")
        if Farming then Farming.Initialize(Globals) end
        
        Status("FINAL", "Rendering Driver-X Interface...")
        if Interface then Interface.Initialize(Globals, WindUI) end
        
        Status("SUCCESS", "Titanium Ultimate Fully Active.")
    end

    -- 4. Entry Gate (Key System)
    local CORRECT_KEY = "TITANIUM-ELITE-FREE"
    KeySystem.Initialize(WindUI, CORRECT_KEY, BootMain)
end)

if not run_status then
    Status("FATAL CRASH", "Kernel Failure. Check Console (F9).")
    warn("[TITANIUM CRITICAL] " .. tostring(run_error))
end
