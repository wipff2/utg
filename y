local Section = Tab:CreateSection("Tagging")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local tagEventPath = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("game") and ReplicatedStorage.Events.game:FindFirstChild("tags") and ReplicatedStorage.Events.game.tags:FindFirstChild("TagPlayer")

if not tagEventPath then
    warn("[ERROR] TagPlayer event not found! Check ReplicatedStorage structure.")
    return
end

local lastTagTime = {}
local tagAuraRange = UserInputService.TouchEnabled and 7 or 9
local tagEnabled = false
local filterDead = false
local teamCheck = false
local legitTag = false
local roleFilterEnabled = false

local roleTagRules = {
    Crown = {"Neutral", "Frozen"},
    SoloCrown = {"Neutral", "Frozen"},
    Frozen = {"Freezer"},
    Runner = {"Crown", "SoloCrown", "Frozen", "Neutral"},
    Tagger = {"Neutral", "Frozen"},
    Dead = {"Crown", "SoloCrown"},
    Infect = {"Runner", "Juggernauts"},
    Infected = {"Runner", "Juggernauts"},
    Freezer = {"Frozen", "Runner", "Neutral"},
    Hunter = {"Juggernaut"},
    PatientZero = {"Juggernaut", "Neutral", "Runner"},
    Chiller = {"Neutral", "Runner"},
    Juggernaut = {"Runner", "Infected", "Neutral"},
    Slasher = {"Juggernauts", "Runner", "Neutral"},
    DisguisedTagger = {"Runner"},
    Knight = {"Runner"},
    Medic = {"Sick"},
    Headless = {"Neutral"}
}

local ToggleTag = Tab:CreateToggle({
    Name = "Silent Tag",
    CurrentValue = false,
    Flag = "AutoTag",
    Callback = function(Value)
        tagEnabled = Value
    end,
})

local ToggleFilterDead = Tab:CreateToggle({
    Name = "Ignore Dead",
    CurrentValue = false,
    Flag = "FilterDead",
    Callback = function(Value)
        filterDead = Value
    end,
})

local ToggleTeamCheck = Tab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "TeamCheck",
    Callback = function(Value)
        teamCheck = Value
    end,
})

local ToggleLegitTag = Tab:CreateToggle({
    Name = "Legit Tag",
    CurrentValue = false,
    Flag = "LegitTag",
    Callback = function(Value)
        legitTag = Value
    end,
})

local ToggleRoleFilter = Tab:CreateToggle({
    Name = "Useless Role Filter",
    CurrentValue = false,
    Flag = "RoleFilter",
    Callback = function(Value)
        roleFilterEnabled = Value
    end,
})

local function canTag(player)
    if not roleFilterEnabled then return true end
    
    local localRole = localPlayer:FindFirstChild("PlayerRole")
    local targetRole = player:FindFirstChild("PlayerRole")
    
    if not localRole or not targetRole then return false end
    
    local allowedRoles = roleTagRules[localRole.Value]
    
    -- Jika role tidak ditemukan di roleTagRules, izinkan tagging ke siapa pun
    if not allowedRoles then return true end
    
    return table.find(allowedRoles, targetRole.Value) ~= nil
end

local function isValidTarget(player)
    if not player or player == localPlayer then return false end
    
    local character = player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local targetHRP = character:FindFirstChild("HumanoidRootPart")
    local playerRole = player:FindFirstChild("PlayerRole")

    if filterDead and playerRole and playerRole:IsA("StringValue") and playerRole.Value == "Dead" then
        return false
    end

    if teamCheck then
        local localRole = localPlayer:FindFirstChild("PlayerRole")
        if localRole and playerRole and localRole.Value == playerRole.Value then
            return false
        end
    end

    return humanoid and humanoid.Health > 0 and targetHRP and canTag(player)
end

local function tagPlayer(player)
    if not tagEnabled or not isValidTarget(player) then return end
    
    local currentTime = tick()
    if lastTagTime[player] and currentTime - lastTagTime[player] < 0.5 then return end
    
    local localCharacter = localPlayer.Character
    local targetCharacter = player.Character
    if not localCharacter or not targetCharacter then return end
    
    local localHRP = localCharacter:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
    
    if not localHRP or not targetHRP or not targetHumanoid then return end
    
    if (localHRP.Position - targetHRP.Position).Magnitude > tagAuraRange then return end
    
    local args = {
        [1] = targetHumanoid,
        [2] = targetHRP.Position
    }
    
    local success, response = pcall(function()
        return tagEventPath:InvokeServer(unpack(args))
    end)
    
    if success then
        print("[INFO] Target hit @", tick())
        lastTagTime[player] = currentTime
        
        if legitTag then
            local animFolder = ReplicatedStorage:FindFirstChild("Animations") and ReplicatedStorage.Animations:FindFirstChild("Base")
            if animFolder then
                local tagAnim = animFolder:FindFirstChild("Tag1") or animFolder:FindFirstChild("Tag2")
                if tagAnim then
                    local animator = localCharacter:FindFirstChild("Humanoid") and localCharacter.Humanoid:FindFirstChild("Animator")
                    if animator then
                        local animation = animator:LoadAnimation(tagAnim)
                        animation:Play()
                    end
                end
            end
        end
    else
        warn("[ERROR] Failed tag")
    end
end

RunService.Heartbeat:Connect(function()
    if not tagEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if tagEnabled then tagPlayer(player) end
    end
end)
