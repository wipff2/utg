local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window =
    Rayfield:CreateWindow(
    {
        Name = "Window",
        Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
        LoadingTitle = "Rayfield Interface Suite",
        LoadingSubtitle = "by",
        Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
        DisableRayfieldPrompts = false,
        DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil, -- Create a custom folder for your hub/game
            FileName = "Big Hub"
        },
        Discord = {
            Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
            Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
            RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },
        KeySystem = false, -- Set this to true to use our key system
        KeySettings = {
            Title = "Untitled",
            Subtitle = "Key System",
            Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
            FileName = "Key",
            SaveKey = true,
            GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
            Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
        }
    }
)

---------- taging

local Tab = Window:CreateTab("MAIN", 4483362458) -- Title, Image
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
    Tagger = {"Neutral", "Frozen", "Runner"},
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


---------- Esp

local Section = Tab:CreateSection("Player")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

local espEnabled = false
local espNameEnabled = false
local espRoleEnabled = false
local espNeutralEnabled = false
local teamCheck = false
local espObjects = {}

local ToggleESP =
    Tab:CreateToggle(
    {
        Name = "ESP Toggle",
        CurrentValue = false,
        Flag = "ESPEnabled",
        Callback = function(Value)
            espEnabled = Value
            if not Value then
                for _, obj in pairs(espObjects) do
                    obj:Destroy()
                end
                espObjects = {}
            end
        end
    }
)

local ToggleESPName =
    Tab:CreateToggle(
    {
        Name = "ESP Show Name",
        CurrentValue = false,
        Flag = "ESPName",
        Callback = function(Value)
            espNameEnabled = Value
        end
    }
)

local ToggleESPRole =
    Tab:CreateToggle(
    {
        Name = "ESP Show Role",
        CurrentValue = false,
        Flag = "ESPRole",
        Callback = function(Value)
            espRoleEnabled = Value
        end
    }
)

local ToggleESPTeamCheck =
    Tab:CreateToggle(
    {
        Name = "ESP Team Check",
        CurrentValue = false,
        Flag = "ESPTeamCheck",
        Callback = function(Value)
            teamCheck = Value
        end
    }
)

local roleColors = {
    Runner = Color3.fromRGB(0, 0, 255),
    Crown = Color3.fromRGB(255, 215, 0),
    SoloCrown = Color3.fromRGB(255, 215, 0),
    Neutral = Color3.fromRGB(128, 128, 128),
    Chiller = Color3.fromRGB(0, 255, 255),
    Frozen = Color3.fromRGB(0, 0, 255),
    Freezer = Color3.fromRGB(0, 0, 139),
    Dead = Color3.fromRGB(255, 255, 255),
    Infected = Color3.fromRGB(0, 255, 0),
    Sick = Color3.fromRGB(144, 238, 144),
    PatientZero = Color3.fromRGB(128, 0, 128),
    Patientzero = Color3.fromRGB(128, 0, 128),
    Medic = Color3.fromRGB(0, 100, 0),
    Bomb = Color3.fromRGB(255, 165, 0),
    bomb = Color3.fromRGB(255, 165, 0),
    Tagger = Color3.fromRGB(255, 0, 0) -- Merah untuk Tagger
}

-- Fungsi untuk mendapatkan warna berdasarkan nama role
local function getRoleColor(roleName)
    if not roleName then
        return Color3.fromRGB(255, 255, 255) -- Default putih jika tidak ada role
    end
    
    -- Cek apakah role ada di roleColors
    local color = roleColors[roleName]
    if color then
        return color
    end

    -- Konversi roleName menjadi huruf kecil untuk pencarian lebih mudah
    local lowerRole = string.lower(roleName)

    -- Cek apakah role mengandung kata "red", "blue", "green", atau "yellow"
    if string.find(lowerRole, "red") then
        return Color3.fromRGB(255, 0, 0) -- Merah
    elseif string.find(lowerRole, "blue") then
        return Color3.fromRGB(0, 0, 255) -- Biru
    elseif string.find(lowerRole, "green") then
        return Color3.fromRGB(0, 255, 0) -- Hijau
    elseif string.find(lowerRole, "yellow") then
        return Color3.fromRGB(255, 255, 0) -- Kuning
    end

    return Color3.fromRGB(255, 255, 255) -- Default putih jika tidak ada warna spesifik
end

local espSize = 6
local SliderESPSize =
    Tab:CreateSlider(
    {
        Name = "ESP Size",
        Range = {2, 30},
        Increment = 1,
        Suffix = " Size",
        CurrentValue = espSize,
        Flag = "ESPSize",
        Callback = function(Value)
            espSize = Value
            for _, obj in pairs(espObjects) do
                if obj:IsA("BillboardGui") then
                    obj.Size = UDim2.new(espSize, 0, espSize / 4, 0)
                end
            end
        end
    }
)

local function createESP(player)    
    if player == localPlayer then    
        return    
    end    

    local character = player.Character    
    if not character then    
        return    
    end    

    local hrp = character:FindFirstChild("HumanoidRootPart")    
    local playerRole = player:FindFirstChild("PlayerRole")    
    local localRole = localPlayer:FindFirstChild("PlayerRole")    

    -- Cek apakah role adalah "Dead", jika ya maka return    
    if playerRole and playerRole.Value == "Dead" then    
        return    
    end    

    if teamCheck and localRole and playerRole and localRole.Value == playerRole.Value then    
        return    
    end    

    if hrp then    
        local billboard = Instance.new("BillboardGui")    
        billboard.Size = UDim2.new(espSize, 0, espSize / 4, 0)    
        billboard.StudsOffset = Vector3.new(0, 3, 0)    
        billboard.Adornee = hrp    
        billboard.AlwaysOnTop = true    
        billboard.Parent = CoreGui    

        local textLabel = Instance.new("TextLabel", billboard)    
        textLabel.Size = UDim2.new(1, 0, 1, 0)    
        textLabel.BackgroundTransparency = 1    
        textLabel.TextStrokeTransparency = 0.5    
        textLabel.TextScaled = true    
        textLabel.Font = Enum.Font.SourceSans    

        espObjects[player] = billboard    

        RunService.RenderStepped:Connect(function()    
            if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then    
                billboard:Destroy()    
                espObjects[player] = nil    
                return    
            end    

            -- Pastikan kembali bahwa peran tidak "Dead" saat ESP diperbarui
            if playerRole and playerRole.Value == "Dead" then
                billboard:Destroy()
                espObjects[player] = nil
                return
            end

            local displayText = ""    
            if espNameEnabled then    
                displayText = player.Name    
            end    
            if espRoleEnabled and playerRole then    
                if displayText ~= "" then    
                    displayText = displayText .. "\n"    
                end    
                displayText = displayText .. string.lower(playerRole.Value)    
            end    

            textLabel.Text = displayText    
            textLabel.TextColor3 = getRoleColor(playerRole and playerRole.Value)    
        end)    
    end    
end
RunService.RenderStepped:Connect(
    function()
        if not espEnabled then
            return
        end
        for _, player in pairs(Players:GetPlayers()) do
            if not espObjects[player] then
                createESP(player)
            end
        end
    end
)

---------- player

local Section = Tab:CreateSection("localPlayer")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local infJumpEnabled = false
local noclipEnabled = false
local infJump

local ToggleInfJump =
    Tab:CreateToggle(
    {
        Name = "Infinite Jump",
        CurrentValue = false,
        Flag = "InfJump",
        Callback = function(Value)
            infJumpEnabled = Value
            if infJump then
                infJump:Disconnect()
                infJump = nil
            end
            if Value then
                infJump =
                    UserInputService.JumpRequest:Connect(
                    function()
                        if localPlayer.Character and localPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
                            localPlayer.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(
                                Enum.HumanoidStateType.Jumping
                            )
                        end
                    end
                )
            end
        end
    }
)

local ToggleNoclip =
    Tab:CreateToggle(
    {
        Name = "Noclip",
        CurrentValue = false,
        Flag = "Noclip",
        Callback = function(Value)
            noclipEnabled = Value
        end
    }
)

RunService.Stepped:Connect(
    function()
        local character = localPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if noclipEnabled then
                        part.CanCollide = false
                    else
                        if part.Name == "Head" or part.Name == "Torso" then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
)
