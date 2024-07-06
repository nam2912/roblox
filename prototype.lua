local function API_Check()
    if Drawing == nil then
        return "No"
    else
        return "Yes"
    end
end

local Find_Required = API_Check()

if Find_Required == "No" then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Exunys Developer";
        Text = "ESP script could not be loaded because your exploit is unsupported.";
        Duration = math.huge;
        Button1 = "OK"
    })
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local Typing = false

_G.SendNotifications = true
_G.DefaultSettings = false

_G.TeamCheck = false
_G.ESPVisible = true
_G.TextColor = Color3.fromRGB(255, 80, 10)
_G.TextSize = 14
_G.Center = true
_G.Outline = true
_G.OutlineColor = Color3.fromRGB(0, 0, 0)
_G.TextTransparency = 0.7
_G.TextFont = Drawing.Fonts.UI

_G.HighlightColor = Color3.fromRGB(255, 80, 10)
_G.OutlineColor = Color3.fromRGB(0, 0, 0)
_G.FillTransparency = 0.5
_G.OutlineTransparency = 0

_G.DisableKey = Enum.KeyCode.Q

local function createESPForPlayer(player)
    local ESP = Drawing.new("Text")
    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.FillColor = _G.HighlightColor
    highlight.OutlineColor = _G.OutlineColor
    highlight.FillTransparency = _G.FillTransparency
    highlight.OutlineTransparency = _G.OutlineTransparency
    highlight.Enabled = _G.ESPVisible
    highlight.Parent = player.Character

    local function updateESP()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local vector, onScreen = Camera:WorldToViewportPoint(head.Position)

                ESP.Size = _G.TextSize
                ESP.Center = _G.Center
                ESP.Outline = _G.Outline
                ESP.OutlineColor = _G.OutlineColor
                ESP.Color = _G.TextColor
                ESP.Transparency = _G.TextTransparency
                ESP.Font = _G.TextFont

                if onScreen then
                    local part1 = player.Character.HumanoidRootPart.Position
                    local part2 = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Players.LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
                    local dist = (part1 - part2).Magnitude
                    ESP.Position = Vector2.new(vector.X, vector.Y - 25)
                    ESP.Text = ("(" .. tostring(math.floor(dist)) .. ") " .. player.Name .. " [" .. math.floor(player.Character.Humanoid.Health) .. "]")
                    if _G.TeamCheck then
                        ESP.Visible = Players.LocalPlayer.Team ~= player.Team and _G.ESPVisible
                        highlight.Enabled = Players.LocalPlayer.Team ~= player.Team and _G.ESPVisible
                    else
                        ESP.Visible = _G.ESPVisible
                        highlight.Enabled = _G.ESPVisible
                    end
                else
                    ESP.Visible = false
                    highlight.Enabled = false
                end
            else
                ESP.Visible = false
                highlight.Enabled = false
            end
        else
            ESP.Visible = false
            highlight.Enabled = false
        end
    end

    RunService.RenderStepped:Connect(updateESP)

    player.CharacterRemoving:Connect(function()
        ESP:Remove()
        highlight:Destroy()
    end)
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function()
        createESPForPlayer(player)
    end)
    if player.Character then
        createESPForPlayer(player)
    end
end

if _G.DefaultSettings then
    _G.TeamCheck = false
    _G.ESPVisible = true
    _G.TextColor = Color3.fromRGB(40, 90, 255)
    _G.TextSize = 14
    _G.Center = true
    _G.Outline = false
    _G.OutlineColor = Color3.fromRGB(0, 0, 0)
    _G.TextTransparency = 0.75
    _G.HighlightColor = Color3.fromRGB(40, 90, 255)
    _G.OutlineColor = Color3.fromRGB(0, 0, 0)
    _G.FillTransparency = 0.5
    _G.OutlineTransparency = 0
    _G.DisableKey = Enum.KeyCode.Q
end

UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == _G.DisableKey and not Typing then
        _G.ESPVisible = not _G.ESPVisible
        if _G.SendNotifications then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Exunys Developer";
                Text = "The ESP's visibility is now set to " .. tostring(_G.ESPVisible) .. ".";
                Duration = 5;
            })
        end
    end
end)

local success, errored = pcall(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            onPlayerAdded(player)
        end
    end
    Players.PlayerAdded:Connect(onPlayerAdded)
end)

if success and not errored then
    if _G.SendNotifications then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Exunys Developer";
            Text = "ESP script has successfully loaded.";
            Duration = 5;
        })
    end
elseif errored and not success then
    if _G.SendNotifications then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Exunys Developer";
            Text = "ESP script has errored while loading, please check the developer console! (F9)";
            Duration = 5;
        })
    end
    warn("The ESP script has errored, please notify Exunys with the following information:")
    warn(errored)
    print("!! IF THE ERROR IS A FALSE POSITIVE (says that a player cannot be found) THEN DO NOT BOTHER !!")
end
