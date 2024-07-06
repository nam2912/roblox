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
_G.HighlightColor = Color3.fromRGB(255, 80, 10)
_G.OutlineColor = Color3.fromRGB(0, 0, 0)
_G.FillTransparency = 0.5
_G.OutlineTransparency = 0

_G.DisableKey = Enum.KeyCode.Q

local function createHighlightForPlayer(player)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.FillColor = _G.HighlightColor
    highlight.OutlineColor = _G.OutlineColor
    highlight.FillTransparency = _G.FillTransparency
    highlight.OutlineTransparency = _G.OutlineTransparency
    highlight.Enabled = _G.ESPVisible
    highlight.Parent = player.Character

    local function updateHighlight()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if _G.TeamCheck then
                highlight.Enabled = Players.LocalPlayer.Team ~= player.Team and _G.ESPVisible
            else
                highlight.Enabled = _G.ESPVisible
            end
        else
            highlight.Enabled = false
        end
    end

    RunService.RenderStepped:Connect(updateHighlight)

    player.CharacterRemoving:Connect(function()
        highlight:Destroy()
    end)
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function()
        createHighlightForPlayer(player)
    end)
    if player.Character then
        createHighlightForPlayer(player)
    end
end

if _G.DefaultSettings then
    _G.TeamCheck = false
    _G.ESPVisible = true
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
