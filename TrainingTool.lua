-- Training Tool for Roblox Shooters (e.g., Gunfight Arena)
-- Author: DFDev (STD1432)
-- License: MIT
-- Description: A tool to help players improve aim and track performance in Roblox shooters.
-- GitHub: https://github.com/qwdhjchg/RobloxTrainingTool

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrainingToolGui"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

local Indicator = Instance.new("Frame")
Indicator.Size = UDim2.new(0, 30, 0, 30)
Indicator.BackgroundColor3 = Color3.new(0, 1, 0)
Indicator.Position = UDim2.new(0.5, -15, 0.5, -15)
Indicator.Parent = ScreenGui

local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(0, 200, 0, 180)
StatsFrame.Position = UDim2.new(0, 10, 0, 10)
StatsFrame.BackgroundColor3 = Color3.new(0, 0, 0)
StatsFrame.BackgroundTransparency = 0.5
StatsFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Text = "Training Tool by DFDev"
TitleLabel.Parent = StatsFrame

local KillsLabel = Instance.new("TextLabel")
KillsLabel.Size = UDim2.new(1, 0, 0, 30)
KillsLabel.Position = UDim2.new(0, 0, 0, 30)
KillsLabel.BackgroundTransparency = 1
KillsLabel.TextColor3 = Color3.new(1, 1, 1)
KillsLabel.Text = "Kills: 0"
KillsLabel.Parent = StatsFrame

local DeathsLabel = Instance.new("TextLabel")
DeathsLabel.Size = UDim2.new(1, 0, 0, 30)
DeathsLabel.Position = UDim2.new(0, 0, 0, 60)
DeathsLabel.BackgroundTransparency = 1
DeathsLabel.TextColor3 = Color3.new(1, 1, 1)
DeathsLabel.Text = "Deaths: 0"
DeathsLabel.Parent = StatsFrame

local KDLabel = Instance.new("TextLabel")
KDLabel.Size = UDim2.new(1, 0, 0, 30)
KDLabel.Position = UDim2.new(0, 0, 0, 90)
KDLabel.BackgroundTransparency = 1
KDLabel.TextColor3 = Color3.new(1, 1, 1)
KDLabel.Text = "K/D: 0"
KDLabel.Parent = StatsFrame

local TipLabel = Instance.new("TextLabel")
TipLabel.Size = UDim2.new(1, 0, 0, 60)
TipLabel.Position = UDim2.new(0, 0, 0, 120)
TipLabel.BackgroundTransparency = 1
TipLabel.TextColor3 = Color3.new(1, 1, 0)
TipLabel.Text = "Tip: Move often!"
TipLabel.TextWrapped = true
TipLabel.Parent = StatsFrame

local kills = 0
local deaths = 0
local kd = 0
local tips = {
    "Tip: Move often to avoid ambushes!",
    "Tip: Use headphones to hear footsteps!",
    "Tip: Control map corners for better positioning!",
    "Tip: Try weapons with high accuracy, like M4A1!",
    "Tip: Play with friends for better coordination!",
    "Tip: On Downtown, hold rooftops for better vision!",
    "Tip: Use SCAR-L for long-range fights!",
    "Tip: Avoid staying in open areas too long!",
    "Tip: Practice in Aim Trainer before matches!",
    "Tip: Check your flanks every 10 seconds!",
    "Tip: Use Desert Eagle for quick follow-up shots!",
    "Tip: Strafe while shooting to dodge enemy fire!",
    "Tip: On Downtown, use crates for cover!",
    "Tip: Set mouse sensitivity to 0.4 for better aim!",
    "Tip: Take breaks after losing 2 matches in a row!",
    "Tip: Use AWP for sniping on Downtown rooftops!",
    "Tip: Play Gun Only to boost your ELO faster!",
    "Tip: Disable mouse acceleration in Windows!",
    "Tip: Focus on one enemy at a time!",
    "Tip: Watch YouTube guides for new strategies!"
}

-- Функция для обновления интерфейса
local function updateStats()
    kd = deaths > 0 and kills / deaths or kills
    KillsLabel.Text = "Kills: " .. kills
    DeathsLabel.Text = "Deaths: " .. deaths
    KDLabel.Text = "K/D: " .. string.format("%.2f", kd)
end

-- Отслеживание киллов через leaderstats
LocalPlayer:WaitForChild("leaderstats")
local killsStat = LocalPlayer.leaderstats:FindFirstChild("Kills")
if killsStat then
    kills = killsStat.Value
    killsStat:GetPropertyChangedSignal("Value"):Connect(function()
        kills = killsStat.Value
        updateStats()
    end)
end

-- Отслеживание смертей через leaderstats
local deathsStat = LocalPlayer.leaderstats:FindFirstChild("Deaths")
if deathsStat then
    deaths = deathsStat.Value
    deathsStat:GetPropertyChangedSignal("Value"):Connect(function()
        deaths = deathsStat.Value
        updateStats()
    end)
end

-- Отслеживание смертей через персонажа (если leaderstats не работает)
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        deaths = deaths + 1
        updateStats()
    end)
end)

-- Отслеживание прицела (для визуального индикатора)
RunService.RenderStepped:Connect(function()
    local mouse = LocalPlayer:GetMouse()
    local closestPlayer, closestDistance = nil, math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = game:GetService("Workspace").CurrentCamera:WorldToScreenPoint(humanoidRootPart.Position)
            if onScreen then
                local mousePos = Vector2.new(mouse.X, mouse.Y)
                local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                local distance = (mousePos - targetPos).Magnitude

                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    if closestPlayer and closestDistance < 50 then
        Indicator.BackgroundColor3 = Color3.new(1, 0, 0)
    else
        Indicator.BackgroundColor3 = Color3.new(0, 1, 0)
    end
end)

-- Даём случайный совет каждые 15 секунд
while true do
    TipLabel.Text = tips[math.random(1, #tips)]
    wait(15)
end
