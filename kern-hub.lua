-- Load Fluent Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Script State
local ScriptState = {
    WalkSpeed = 16,
    JumpPower = 50,
    Flying = false,
    Noclip = false,
    ESP = false,
    Fullbright = false,
    InfiniteJump = false,
    FlySpeed = 50
}


-- Encrypt the Webhook URL (store encryption key securely, this is an example)
local HttpService = game:GetService("HttpService")

-- Encrypted Webhook (Base64 Encoding as an example of light obfuscation)
local EncodedWebhook = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ1MDYzNzI3NDA0Njc5NjAwNi9jSllaR2NGV3g4YUVvTmYzQUltXzBsdGNYdnI4aUMtQmhmSmtpNkxrZmIxRXRYODFycTJkMUkwQXQ2bUFrVkY0Z25X"

-- Decode function
local function DecodeUrl(encoded)
    return HttpService:UrlDecode(HttpService:Base64Decode(encoded))
end

-- Decoded URL retrieved dynamically
local WebhookURL = DecodeUrl(EncodedWebhook)

-- Create Window
local Window = Fluent:CreateWindow({
    Title = "kern Hub",
    SubTitle = "by snowf1 - @snowf1.",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Create Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" }),
    Hubs = Window:AddTab({ Title = "Hubs", Icon = "grid" }),
    GameHubs = Window:AddTab({ Title = "Game Hubs", Icon = "gamepad-2" })
}

-- Main Tab
local MainSection = Tabs.Main:AddSection("Character Modifications")

Tabs.Main:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Description = "Change your walk speed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        ScriptState.WalkSpeed = Value
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

Tabs.Main:AddSlider("JumpPower", {
    Title = "Jump Power",
    Description = "Change your jump power",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        ScriptState.JumpPower = Value
        if Humanoid then
            Humanoid.JumpPower = Value
        end
    end
})

Tabs.Main:AddToggle("InfiniteJump", {
    Title = "Infinite Jump",
    Description = "Jump infinitely",
    Default = false,
    Callback = function(Value)
        ScriptState.InfiniteJump = Value
    end
})

-- Feedback Section
local FeedbackSection = Tabs.Main:AddSection("Feedback & Support")

local FeedbackInput = Tabs.Main:AddInput("FeedbackInput", {
    Title = "Report/Suggestion",
    Description = "Enter your message here",
    Default = "",
    Placeholder = "Type your message...",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        -- Callback is optional for input
    end
})

Tabs.Main:AddButton({
    Title = "Send Report",
    Description = "Report a bug or issue",
    Callback = function()
        local message = FeedbackInput.Value
        if message == "" or message == "Type your message..." then
            Fluent:Notify({
                Title = "Error",
                Content = "Please enter a message first!",
                Duration = 3
            })
            return
        end
        
        local success = pcall(function()
            local http = game:GetService("HttpService")
            local data = {
                ["content"] = "",
                ["embeds"] = {{
                    ["title"] = "🐛 Bug Report",
                    ["description"] = message,
                    ["color"] = 15158332, -- Red color
                    ["fields"] = {
                        {
                            ["name"] = "Player",
                            ["value"] = LocalPlayer.Name,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "User ID",
                            ["value"] = tostring(LocalPlayer.UserId),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Game",
                            ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                            ["inline"] = false
                        }
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
                }}
            }
            
            local response = request({
                Url = WebhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = http:JSONEncode(data)
            })
        end)
        
        if success then
            Fluent:Notify({
                Title = "Report Sent!",
                Content = "Your bug report has been submitted.",
                Duration = 4
            })
            FeedbackInput:SetValue("")
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Failed to send report. Check webhook URL.",
                Duration = 4
            })
        end
    end
})

Tabs.Main:AddButton({
    Title = "Send Suggestion",
    Description = "Suggest a new feature",
    Callback = function()
        local message = FeedbackInput.Value
        if message == "" or message == "Type your message..." then
            Fluent:Notify({
                Title = "Error",
                Content = "Please enter a message first!",
                Duration = 3
            })
            return
        end
        
        local success = pcall(function()
            local http = game:GetService("HttpService")
            local data = {
                ["content"] = "",
                ["embeds"] = {{
                    ["title"] = "💡 Suggestion",
                    ["description"] = message,
                    ["color"] = 3447003, -- Blue color
                    ["fields"] = {
                        {
                            ["name"] = "Player",
                            ["value"] = LocalPlayer.Name,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "User ID",
                            ["value"] = tostring(LocalPlayer.UserId),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Game",
                            ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                            ["inline"] = false
                        }
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
                }}
            }
            
            local response = request({
                Url = WebhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = http:JSONEncode(data)
            })
        end)
        
        if success then
            Fluent:Notify({
                Title = "Suggestion Sent!",
                Content = "Your suggestion has been submitted.",
                Duration = 4
            })
            FeedbackInput:SetValue("")
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Failed to send suggestion. Check webhook URL.",
                Duration = 4
            })
        end
    end
})

-- Player Tab
local MovementSection = Tabs.Player:AddSection("Movement")

Tabs.Player:AddToggle("Fly", {
    Title = "Fly",
    Description = "Enable flying (E to go up, Q to go down)",
    Default = false,
    Callback = function(Value)
        ScriptState.Flying = Value
    end
})

Tabs.Player:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Description = "Change your fly speed",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        ScriptState.FlySpeed = Value
    end
})

Tabs.Player:AddToggle("Noclip", {
    Title = "Noclip",
    Description = "Walk through walls",
    Default = false,
    Callback = function(Value)
        ScriptState.Noclip = Value
    end
})

Tabs.Player:AddButton({
    Title = "Reset Character",
    Description = "Reset your character",
    Callback = function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end
})

-- Visual Tab
local VisualSection = Tabs.Visual:AddSection("Visual Effects")

Tabs.Visual:AddToggle("Fullbright", {
    Title = "Fullbright",
    Description = "See everything clearly",
    Default = false,
    Callback = function(Value)
        ScriptState.Fullbright = Value
        if Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        end
    end
})

Tabs.Visual:AddToggle("ESP", {
    Title = "Player ESP",
    Description = "See players through walls",
    Default = false,
    Callback = function(Value)
        ScriptState.ESP = Value
    end
})

-- Misc Tab
local MiscSection = Tabs.Misc:AddSection("Miscellaneous")

Tabs.Misc:AddButton({
    Title = "Rejoin Server",
    Description = "Rejoin the current server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

Tabs.Misc:AddButton({
    Title = "Server Hop",
    Description = "Join a different server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        TeleportService:Teleport(PlaceId, LocalPlayer)
    end
})

Tabs.Misc:AddParagraph({
    Title = "Script Info",
    Content = "kern Hub\nVersion 1.0\nby snowf1 - @snowf1."
})

-- Hubs Tab
local HubsSection = Tabs.Hubs:AddSection("Script Hubs")

Tabs.Hubs:AddButton({
    Title = "Load Infinite Yield",
    Description = "Universal admin commands",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})

Tabs.Hubs:AddButton({
    Title = "Load Dex Explorer",
    Description = "Game explorer tool",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
})

Tabs.Hubs:AddButton({
    Title = "Load Simple Spy",
    Description = "Remote spy tool",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()
    end
})

Tabs.Hubs:AddParagraph({
    Title = "About Hubs",
    Content = "Load popular script hubs and tools\nClick any button to execute the script"
})

-- Game Hubs Tab
local GameHubsSection = Tabs.GameHubs:AddSection("Game-Specific Scripts")

Tabs.GameHubs:AddButton({
    Title = "Blox Fruits Script",
    Description = "Advanced Blox Fruits hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
    end
})

Tabs.GameHubs:AddButton({
    Title = "Arsenal Script",
    Description = "Arsenal aimbot & ESP",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHubArsenal"))()
    end
})

Tabs.GameHubs:AddButton({
    Title = "Brookhaven Script",
    Description = "Brookhaven RP features",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMael/NewIceHub/main/Brookhaven"))()
    end
})

Tabs.GameHubs:AddButton({
    Title = "Adopt Me Script",
    Description = "Adopt Me automation",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1201for/V.G-Hub/main/V.Ghub"))()
    end
})

Tabs.GameHubs:AddParagraph({
    Title = "About Game Hubs",
    Content = "Game-specific scripts and hubs\nOnly works in their respective games"
})

-- Functions
local function UpdateCharacter()
    Character = LocalPlayer.Character
    if Character then
        Humanoid = Character:WaitForChild("Humanoid")
        RootPart = Character:WaitForChild("HumanoidRootPart")
    end
end

LocalPlayer.CharacterAdded:Connect(UpdateCharacter)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if ScriptState.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Flying System
local FlyBodyVelocity, FlyBodyGyro
local function StartFly()
    if not RootPart then return end
    
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVelocity.Parent = RootPart
    
    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyGyro.P = 9e4
    FlyBodyGyro.Parent = RootPart
end

local function StopFly()
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
end

-- Main Loop
RunService.Heartbeat:Connect(function()
    if not Character or not Humanoid or not RootPart then return end
    
    -- Maintain speeds
    Humanoid.WalkSpeed = ScriptState.WalkSpeed
    Humanoid.JumpPower = ScriptState.JumpPower
    
    -- Noclip
    if ScriptState.Noclip then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
    
    -- Flying
    if ScriptState.Flying then
        if not FlyBodyVelocity or not FlyBodyGyro then
            StartFly()
        end
        
        if FlyBodyVelocity and FlyBodyGyro then
            local Camera = workspace.CurrentCamera
            local MoveDirection = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                MoveDirection = MoveDirection + (Camera.CFrame.LookVector * ScriptState.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                MoveDirection = MoveDirection - (Camera.CFrame.LookVector * ScriptState.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                MoveDirection = MoveDirection - (Camera.CFrame.RightVector * ScriptState.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                MoveDirection = MoveDirection + (Camera.CFrame.RightVector * ScriptState.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                MoveDirection = MoveDirection + (Vector3.new(0, 1, 0) * ScriptState.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                MoveDirection = MoveDirection - (Vector3.new(0, 1, 0) * ScriptState.FlySpeed)
            end
            
            FlyBodyVelocity.Velocity = MoveDirection
            FlyBodyGyro.CFrame = Camera.CFrame
        end
    else
        if FlyBodyVelocity or FlyBodyGyro then
            StopFly()
        end
    end
end)

-- ESP System
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local function AddESP(char)
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = char
        
        table.insert(ESPObjects, highlight)
    end
    
    if player.Character then
        AddESP(player.Character)
    end
    
    player.CharacterAdded:Connect(function(char)
        if ScriptState.ESP then
            AddESP(char)
        end
    end)
end

local function RemoveAllESP()
    for _, obj in pairs(ESPObjects) do
        if obj then obj:Destroy() end
    end
    ESPObjects = {}
end

Players.PlayerAdded:Connect(function(player)
    if ScriptState.ESP then
        CreateESP(player)
    end
end)

RunService.Heartbeat:Connect(function()
    if ScriptState.ESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("ESP_Highlight") then
                CreateESP(player)
            end
        end
    else
        RemoveAllESP()
    end
end)

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Save Manager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:BuildConfigSection(Tabs.Misc)
InterfaceManager:BuildInterfaceSection(Tabs.Misc)

-- Notification
Fluent:Notify({
    Title = "Script Loaded",
    Content = "kern Hub loaded successfully!",
    Duration = 5
})
