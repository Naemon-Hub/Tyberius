
--[[ 
  🌿 Naemon Hub - Grow a Garden v3
  Created by: @Naemon-Hub
  Features: Customizable Pet/Seed/Egg Spawner, WalkSpeed, AutoFarm, AutoCollect
--]]

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NaemonHub"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.3, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🌿 Naemon Hub - Grow a Garden"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

function createButton(txt, func)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.Text = txt
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.BorderSizePixel = 0
	btn.MouseButton1Click:Connect(func)
	return btn
end

function fireRemote(remoteName, arg)
	local remote = RS:FindFirstChild(remoteName)
	if remote and remote:IsA("RemoteEvent") then
		remote:FireServer(arg)
		warn("Fired:", remoteName, "Arg:", arg)
	else
		warn("[Naemon Hub] Remote not found:", remoteName)
	end
end

-- ✨ CUSTOM INPUT PROMPT
function promptInput(promptText, defaultText, callback)
	local inputGui = Instance.new("TextBox")
	inputGui.PlaceholderText = defaultText or ""
	inputGui.Text = ""
	inputGui.Size = UDim2.new(1, -10, 0, 30)
	inputGui.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	inputGui.TextColor3 = Color3.new(1, 1, 1)
	inputGui.Font = Enum.Font.Gotham
	inputGui.TextSize = 14
	inputGui.ClearTextOnFocus = false
	inputGui.Parent = frame

	inputGui.FocusLost:Connect(function(enterPressed)
		if enterPressed and inputGui.Text ~= "" then
			callback(inputGui.Text)
			inputGui:Destroy()
		end
	end)
end

-- === SPAWNERS ===
createButton("🐣 Spawn Egg (Custom)", function()
	promptInput("Egg Name", "Example: CommonEgg", function(eggName)
		fireRemote("EggSpawner", eggName)
	end)
end)

createButton("🌱 Spawn Seed (Custom)", function()
	promptInput("Seed Name", "Example: BasicSeed", function(seedName)
		fireRemote("SeedSpawner", seedName)
	end)
end)

createButton("🐾 Spawn Pet (Custom)", function()
	promptInput("Pet Name", "Example: DogPet", function(petName)
		fireRemote("PetSpawner", petName)
	end)
end)

-- === MOVEMENT ===
createButton("⚡ WalkSpeed: 100", function()
	Humanoid.WalkSpeed = 100
end)

createButton("🦘 JumpPower: 120", function()
	Humanoid.JumpPower = 120
end)

-- === AUTO COLLECT ===
local autoCollect = false
createButton("💎 Toggle Auto Collect", function()
	autoCollect = not autoCollect
	if autoCollect then
		warn("Auto Collect ON")
		task.spawn(function()
			while autoCollect do
				for _, drop in ipairs(WS:GetDescendants()) do
					if drop:IsA("Part") and (drop.Name:lower():find("coin") or drop.Name:lower():find("gem")) then
						if (drop.Position - HRP.Position).Magnitude < 20 then
							drop.CFrame = HRP.CFrame + Vector3.new(0, 2, 0)
						end
					end
				end
				wait(0.5)
			end
		end)
	else
		warn("Auto Collect OFF")
	end
end)

-- === AUTO HARVEST ===
local autoFarm = false
createButton("🌾 Toggle Auto Farm", function()
	autoFarm = not autoFarm
	if autoFarm then
		warn("Auto Harvest ON")
		task.spawn(function()
			while autoFarm do
				for _, obj in pairs(WS:GetDescendants()) do
					if obj:IsA("ClickDetector") and obj.Parent:FindFirstChild("ReadyToHarvest") then
						pcall(function()
							fireclickdetector(obj)
						end)
					end
				end
				wait(1)
			end
		end)
	else
		warn("Auto Harvest OFF")
	end
end)

-- Close Button (optional)
createButton("❌ Close Naemon Hub", function()
	gui:Destroy()
end)
