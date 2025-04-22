-- Training Tool for Roblox Shooters (e.g., Gunfight Arena)
-- Author: DFDev (STD1432)
-- License: MIT
-- Description: A tool to help players improve aim and track performance in Roblox shooters.
-- GitHub: https://github.com/qwdhjchgh/TrainingTool

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrainingToolGui"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Индикатор прицела (круг с градиентом)
local Indicator = Instance.new("Frame")
Indicator.Size = UDim2.new(0, 40, 0, 40)
Indicator.Position = UDim2.new(0.5, -20, 0.5, -20)
Indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Indicator.BorderSizePixel = 0
Indicator.BackgroundTransparency = 0.2
Indicator.Parent = ScreenGui

local IndicatorGradient = Instance.new("UIGradient")
IndicatorGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 0))
})
IndicatorGradient.Parent = Indicator

local IndicatorCorner = Instance.new("UICorner")
IndicatorCorner.CornerRadius = UDim.new(1, 0)
IndicatorCorner.Parent = Indicator

-- Основной фрейм статистики
local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(0, 220, 0, 200)
StatsFrame.Position = UDim2.new(0, 10, 0, 10)
StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
StatsFrame.BackgroundTransparency = 0.1
StatsFrame.BorderSizePixel = 2
StatsFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
StatsFrame.Parent = ScreenGui

local StatsGradient = Instance.new("UIGradient")
StatsGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 30, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
StatsGradient.Parent = StatsFrame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 10)
StatsCorner.Parent = StatsFrame

local StatsStroke = Instance.new("UIStroke")
StatsStroke.Color = Color3.fromRGB(255, 255, 255)
StatsStroke.Thickness = 1
StatsStroke.Transparency = 0.5
StatsStroke.Parent = StatsFrame

-- Плавное появление StatsFrame
StatsFrame.BackgroundTransparency = 1
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local tween = TweenService:Create(StatsFrame, tweenInfo, {BackgroundTransparency = 0.1})
tween:Play()

-- Заголовок
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
TitleLabel.Text = "Training Tool"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.Parent = StatsFrame

-- Киллы
local KillsLabel = Instance.new("TextLabel")
KillsLabel.Size = UDim2.new(1, 0, 0, 30)
KillsLabel.Position = UDim2.new(0, 0, 0, 40)
KillsLabel.BackgroundTransparency = 1
KillsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KillsLabel.Text = "Kills: 0"
KillsLabel.Font = Enum.Font.Gotham
KillsLabel.TextSize = 16
KillsLabel.Parent = StatsFrame

-- Смерти
local DeathsLabel = Instance.new("TextLabel")
DeathsLabel.Size = UDim2.new(1, 0, 0, 30)
DeathsLabel.Position = UDim2.new(0, 0, 0, 70)
DeathsLabel.BackgroundTransparency = 1
DeathsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DeathsLabel.Text = "Deaths: 0"
DeathsLabel.Font = Enum.Font.Gotham
DeathsLabel.TextSize = 16
DeathsLabel.Parent = StatsFrame

-- K/D
local KDLabel = Instance.new("TextLabel")
KDLabel.Size = UDim2.new(1, 0, 0, 30)
KDLabel.Position = UDim2.new(0, 0, 0, 100)
KDLabel.BackgroundTransparency = 1
KDLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KDLabel.Text = "K/D: 0"
KDLabel.Font = Enum.Font.Gotham
KDLabel.TextSize = 16
KDLabel.Parent = StatsFrame

-- Советы
local TipLabel = Instance.new("TextLabel")
TipLabel.Size = UDim2.new(1, -10, 0, 50)
TipLabel.Position = UDim2.new(0, 5, 0, 140)
TipLabel.BackgroundTransparency = 1
TipLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
TipLabel.Text = "Tip: Move often!"
TipLabel.TextWrapped = true
TipLabel.Font = Enum.Font.Gotham
TipLabel.TextSize = 14
TipLabel.Parent = StatsFrame

-- Анимация для TipLabel (пульсация)
local function pulseTipLabel()
    local pulseInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local pulse = TweenService:Create(TipLabel, pulseInfo, {TextTransparency = 0.3})
    pulse:Play()
end
pulseTipLabel()

-- Переменные
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
    -- Цвет K/D в зависимости от значения
    if kd > 1 then
        KDLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    elseif kd < 1 then
        KDLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    else
        KDLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Отслеживание киллов через leaderstats
LocalPlayer:WaitForChild("leaderstats", 10)
local killsStat = LocalPlayer.leaderstats and LocalPlayer.leaderstats:FindFirstChild("Kills")
if killsStat then
    kills = killsStat.Value
    killsStat:GetPropertyChangedSignal("Value"):Connect(function()
        kills = killsStat.Value
        updateStats()
    end)
else
    warn("Could not find leaderstats.Kills - kills tracking may not work.")
end

-- Отслеживание смертей через leaderstats
local deathsStat = LocalPlayer.leaderstats and LocalPlayer.leaderstats:FindFirstChild("Deaths")
if deathsStat then
    deaths = deathsStat.Value
    deathsStat:GetPropertyChangedSignal("Value"):Connect(function()
        deaths = deathsStat.Value
        updateStats()
    end)
else
    warn("Could not find leaderstats.Deaths - using character death tracking.")
end

-- Отслеживание смертей через персонажа
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        deaths = deaths + 1
        updateStats()
    end)
end)

if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            deaths = deaths + 1
            updateStats()
        end)
    end
end

-- Отслеживание прицела
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
        Indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        IndicatorGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
        })
    else
        Indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        IndicatorGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 0))
        })
    end
end)

-- Даём случайный совет каждые 15 секунд
while true do
    TipLabel.Text = tips[math.random(1, #tips)]
    wait(15)
end
