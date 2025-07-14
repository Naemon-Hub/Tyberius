-- Naemon Hub | Grow a Garden Script
-- Features: Pet Spawner, Seed Spawner, Auto Collect, Speed, Teleport, UI

-- UI Library (simple)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NaemonHubUI"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local function createButton(text, posY, callback)
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0, 280, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, posY)
    Button.Text = text
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 16
    Button.MouseButton1Click:Connect(callback)
end

-- 🐾 Pet Spawner
function spawnPet()
    local petModule = game:GetService("ReplicatedStorage"):WaitForChild("PetModules"):GetChildren()
    for _, pet in pairs(petModule) do
        game:GetService("ReplicatedStorage").Remotes.SpawnPet:FireServer(pet.Name)
    end
end

-- 🌱 Seed Spawner
function spawnSeed()
    local seeds = game:GetService("ReplicatedStorage"):WaitForChild("SeedModules"):GetChildren()
    for _, seed in pairs(seeds) do
        game:GetService("ReplicatedStorage").Remotes.SpawnSeed:FireServer(seed.Name)
    end
end

-- ⚡ Auto Collect
_G.autoCollecting = false
function autoCollect()
    _G.autoCollecting = not _G.autoCollecting
    while _G.autoCollecting do
        task.wait(1)
        pcall(function()
            for _, item in pairs(workspace.Collectibles:GetChildren()) do
                item.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end)
    end
end

-- 🚀 WalkSpeed Changer
function changeSpeed()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
    end
end

-- 📍 Teleport to Zone
function teleportToZone()
    local zone = workspace:FindFirstChild("Zone3") -- Change this to actual zone name if needed
    if zone then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zone.CFrame
    end
end

-- UI Buttons
createButton("🐾 Spawn All Pets", 10, spawnPet)
createButton("🌱 Spawn All Seeds", 60, spawnSeed)
createButton("⚡ Toggle Auto Collect", 110, autoCollect)
createButton("🚀 Speed x5", 160, changeSpeed)
createButton("📍 Teleport to Zone 3", 210, teleportToZone)

-- Credits
local credits = Instance.new("TextLabel", Frame)
credits.Size = UDim2.new(1, 0, 0, 30)
credits.Position = UDim2.new(0, 0, 1, -30)
credits.Text = "Naemon Hub by ChatGPT"
credits.BackgroundTransparency = 1
credits.TextColor3 = Color3.new(1,1,1)
credits.Font = Enum.Font.Code
credits.TextSize = 14
