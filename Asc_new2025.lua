local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window =
    Rayfield:CreateWindow(
    {
        Name = "Keyless UTG",
        Icon = "circle-user-round", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
        LoadingTitle = "Its Loading",
        LoadingSubtitle = "Please Wait",
        Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
        DisableRayfieldPrompts = true,
        DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
        ConfigurationSaving = {
            Enabled = true,
            FolderName = Xcz, -- Create a custom folder for your hub/game
            FileName = "Lolultra"
        },
        Discord = {
            Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
            Invite = "-", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
            RememberJoins = false -- Set this to false to make them join the discord every time they load it up
        },
        KeySystem = false, -- Set this to true to use our key system
        KeySettings = {
            Title = "Untitled",
            Subtitle = "Keey gg",
            Note = "Nnoo methd", -- Use this to tell the user how to get a key
            FileName = "Thiskeey",
            SaveKey = false,
            GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
            Key = {"dude hell nah"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
        }
    }
)

-------------------- taging --------------------
local Tab = Window:CreateTab("MAIN", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Taging")
------------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local tagEventPath =
    ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("game") and
    ReplicatedStorage.Events.game:FindFirstChild("tags") and
    ReplicatedStorage.Events.game.tags:FindFirstChild("TagPlayer")

if not tagEventPath then
    warn("[ERROR] TagPlayer event not found!.")
    return
end
local lastTagTime = {}
local tagAuraRange = UserInputService.TouchEnabled and 8 or 9
local tagEnabled = false
local filterDead = false
local teamCheck = false
local legitTag = false
local roleFilterEnabled = false
local stopDuringVoting = false

-- POV Circle Settings
local povCircleEnabled = false
local showPOVCircle = false
local povCircleRadius = 1.5 -- 0.5-0.9 (relative to screen)
local povCircleThickness = 1 -- pixels
local povCircleColor = Color3.fromRGB(255, 50, 50)
local povCircleTransparency = 1
local rainbowColorEnabled = true
local rainbowColorSpeed = 1

local roleTagRules = {
    Crown = {"Neutral", "Frozen"},
    SoloCrown = {"Neutral", "Frozen"},
    Frozen = {"Freezer", "Chiller", "Infected", "Slasher", "Juggernaut", "Tagger"},
    RedFrozen = {"Freezer", "Chiller", "Infected", "Slasher", "Juggernaut", "Tagger"},
    BlueFrozen = {"Freezer", "Chiller", "Infected", "Slasher", "Juggernaut", "Tagger"},
    Runner = {"Crown", "SoloCrown", "Frozen", "Neutral", "OnFire", "King"},
    Tagger = {"Neutral", "Frozen", "Runner", "Neutral"},
    Dead = {"Crown", "SoloCrown", "Headless"},
    Infect = {"Runner", "Juggernauts", "Neutral"},
    Infected = {"Runner", "Juggernauts", "Frozen", "Neutral"},
    Freezer = {"Frozen", "Runner", "Neutral"},
    Hunter = {"Juggernaut", "Neutral", "Survivor"},
    PatientZero = {"Juggernaut", "Neutral", "Runner"},
    Chiller = {"Neutral", "Runner", "Runners", "runner", "Frozen"},
    Juggernaut = {"Runner", "Infected", "Neutral", "Frozen", "Hunter", "Survivor"},
    Slasher = {"Juggernauts", "Runner", "Neutral", "Frozen"},
    DisguisedTagger = {"Runner", "Neutral"},
    Knight = {"Runner", "Peasent", "Peasant"},
    Medic = {"Sick", "Peasent", "Infect", "Infected"},
    Headless = {"Neutral", "Witch"},
    Peasent = {"Knight", "Crown", "SoloCrown", "Headless"},
    Alone = {"Alone", "Neutral", "Runner"},
    hallows2024_frozen = {"Survivor", "Captured"},
    hallows2024_saint = {"Survivor", "Captured"},
    BabyZombie = {"Runner"},
    BruteZombie = {"Runner"},
    Captured = {"hallows2024_saint", "Saint"},
    CloakedZombie = {"Runner"},
    HiddenSlasher = {"Survivor"},
    Witch = {"Peasant"},
    Survivor = {"Slasher", "Captured"},
    DiaguisedTagger = {"Runner"},
    DyingTagger = {"Runner"},
    Hotpotato = {"Runner"},
    Peasant = {"Crown", "SoloCrown"},
    Peasant = {"Crown", "SoloCrown"},
    Sick = {"Runner", "Medic"},
    SprinterZombie = {"Runner"},
    Toxic = {"Runner"},
    Arsonist = {"Runner", "OnFire"},
    BlueTeam = {"YellowTeam", "RedTeam", "OrangeTeam", "GreenTeam", "PurpleTeam"},
    YellowTeam = {"BlueTeam", "RedTeam", "PurpleTeam", "OrangeTeam"},
    RedTeam = {"BlueTeam", "YellowTeam", "PurpleTeam", "OrangeTeam"},
    OrangeTeam = {"BlueTeam", "YellowTeam", "PurpleTeam", "RedTeam"}
}
local Paragraph =
    Tab:CreateParagraph(
    {Title = "get ban?", Content = "1.bad executor ,2.you get ban before ,in you device,3.script outdate"}
)
local Paragraph =
    Tab:CreateParagraph(
    {Title = "warning", Content = "Please use it at your own discretion."}
)
local Paragraph =
    Tab:CreateParagraph(
    {Title = "warning2", Content = "use good executor like delta."}
)
local ToggleTag =
    Tab:CreateToggle(
    {
        Name = "Silent Tag ",
        CurrentValue = false,
        Flag = "AutoTag",
        Callback = function(Value)
            tagEnabled = Value
        end
    }
)

local ToggleFilterDead =
    Tab:CreateToggle(
    {
        Name = "Ignore Dead",
        CurrentValue = false,
        Flag = "FilterDead",
        Callback = function(Value)
            filterDead = Value
        end
    }
)

local ToggleTeamCheck =
    Tab:CreateToggle(
    {
        Name = "Team Check",
        CurrentValue = false,
        Flag = "TeamCheck",
        Callback = function(Value)
            teamCheck = Value
        end
    }
)

local ToggleLegitTag =
    Tab:CreateToggle(
    {
        Name = "Legit Tag (lagging)",
        CurrentValue = false,
        Flag = "LegitTag",
        Callback = function(Value)
            legitTag = Value
        end
    }
)

local ToggleRoleFilter =
    Tab:CreateToggle(
    {
        Name = "Useless Role Filter",
        CurrentValue = false,
        Flag = "RoleFilter",
        Callback = function(Value)
            roleFilterEnabled = Value
        end
    }
)

local ToggleStopVoting =
    Tab:CreateToggle(
    {
        Name = "Stop During Voting",
        CurrentValue = false,
        Flag = "StopDuringVoting",
        Callback = function(Value)
            stopDuringVoting = Value
        end
    }
)
local SliderTagRange =
    Tab:CreateSlider(
    {
        Name = "Tag Distance (Don't change for safe)",
        Range = {1, 20}, -- Atur sesuai kebutuhan
        Increment = 1,
        Suffix = " studs",
        CurrentValue = tagAuraRange,
        Flag = "TagRangeSlider",
        Callback = function(Value)
            tagAuraRange = Value
        end
    }
)
SliderTagRange:Set(tagAuraRange)
local Button =
    Tab:CreateButton(
    {
        Name = "Unlimited tag (can't turn off)",
        Callback = function()
            local success, result =
                pcall(
                function()
                    return loadstring(
                        game:HttpGet("https://raw.githubusercontent.com/nAlwspa/Into/refs/heads/main/AllNew_Tag")
                    )()
                end
            )

            if not success then
                warn("[ERROR] Failed to load:", result)
            end
        end
    }
)
-- Drawing objects
local circleBorder, centerDot

-- POV Circle Functions
local function createPOVCircle()
    if circleBorder then
        circleBorder:Remove()
    end
    if centerDot then
        centerDot:Remove()
    end

    if not (povCircleEnabled and showPOVCircle) then
        return
    end

    -- Create circle border
    circleBorder = Drawing.new("Circle")
    circleBorder.Visible = true
    circleBorder.Thickness = povCircleThickness
    circleBorder.Color = povCircleColor
    circleBorder.Transparency = povCircleTransparency
    circleBorder.Filled = false
    circleBorder.NumSides = 64

    -- Center dot
    centerDot = Drawing.new("Circle")
    centerDot.Visible = true
    centerDot.Filled = true
    centerDot.Color = Color3.new(1, 1, 1)
    centerDot.Transparency = 0.5
    centerDot.Radius = 2
end

-- Update the POV circle update function
local function updatePOVCircle()
    if not (povCircleEnabled and showPOVCircle) then
        if circleBorder then
            circleBorder.Visible = false
        end
        if centerDot then
            centerDot.Visible = false
        end
        return
    end

    if not circleBorder then
        createPOVCircle()
    end

    local camera = workspace.CurrentCamera
    local viewportSize = camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local radius = math.min(viewportSize.X, viewportSize.Y) / 2 * povCircleRadius

    -- Rainbow color effect
    if rainbowColorEnabled and circleBorder then
        local hue = (tick() * rainbowColorSpeed) % 1
        circleBorder.Color = Color3.fromHSV(hue, 1, 1)
    end

    circleBorder.Position = center
    circleBorder.Radius = radius
    circleBorder.Visible = true

    if centerDot then
        centerDot.Position = center
        centerDot.Visible = true
    end
end

local function isPlayerInCenter(player)
    if not player or not player.Character then
        return false
    end

    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return false
    end

    -- First check physical distance
    local localChar = localPlayer.Character
    if not localChar then
        return false
    end

    local localHRP = localChar:FindFirstChild("HumanoidRootPart")
    if not localHRP then
        return false
    end

    local distance = (localHRP.Position - rootPart.Position).Magnitude
    if distance > tagAuraRange then
        return false
    end

    -- Then check screen position
    local camera = workspace.CurrentCamera
    local screenPoint, onScreen = camera:WorldToViewportPoint(rootPart.Position)
    if not onScreen then
        return false
    end

    local viewportSize = camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local playerPos = Vector2.new(screenPoint.X, screenPoint.Y)
    local distanceFromCenter = (playerPos - center).Magnitude

    local safeZoneRadius = math.min(viewportSize.X, viewportSize.Y) / 2 * povCircleRadius
    return distanceFromCenter <= safeZoneRadius
end

-- Core Tagging Functions
local function shouldStopTagging()
    if not stopDuringVoting then
        return false
    end

    local values = ReplicatedStorage:FindFirstChild("Values")
    if not values then
        return false
    end

    local gameModeValue = values:FindFirstChild("Gamemode")
    local timeValue = values:FindFirstChild("Time")

    if gameModeValue and (gameModeValue.Value == "Voting" or gameModeValue.Value == "Intermission") then
        return true
    end

    if timeValue and (timeValue.Value == 0 or timeValue.Value == 0.88) then
        return true
    end

    return false
end

local function canTag(player)
    local values = ReplicatedStorage:FindFirstChild("Values")
    local gameModeValue = values and values:FindFirstChild("Gamemode")

    if gameModeValue and gameModeValue.Value == "MutantInfected" then
        return true
    end

    if not roleFilterEnabled then
        return true
    end

    local localRole = localPlayer:FindFirstChild("PlayerRole")
    local targetRole = player:FindFirstChild("PlayerRole")

    if not localRole or not targetRole then
        return false
    end

    local allowedRoles = roleTagRules[localRole.Value]
    if not allowedRoles then
        return true
    end

    return table.find(allowedRoles, targetRole.Value) ~= nil
end

local function isValidTarget(player)
    if not player or player == localPlayer then
        return false
    end

    if player:GetAttribute("NoTagBack") then
        return false
    end

    local character = player.Character
    if not character then
        return false
    end

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
local function getLowestHealthTarget()
    local lowestHealth = math.huge
    local targetPlayer = nil

    for _, player in ipairs(game.Players:GetPlayers()) do
        if isValidTarget(player) then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            local targetHRP = character and character:FindFirstChild("HumanoidRootPart")
            local localHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoid and targetHRP and localHRP then
                local distance = (localHRP.Position - targetHRP.Position).Magnitude
                if distance <= tagAuraRange and humanoid.Health < lowestHealth then
                    lowestHealth = humanoid.Health
                    targetPlayer = player
                end
            end
        end
    end

    return targetPlayer
end
local function tagPlayer(player)
    if not tagEnabled or not isValidTarget(player) or shouldStopTagging() then
        return
    end

    -- POV Circle check (only when enabled)
    if povCircleEnabled and not isPlayerInCenter(player) then
        return
    end

    if player:GetAttribute("NoTagBack") then
        return
    end

    local currentTime = tick()
    if lastTagTime[player] and currentTime - lastTagTime[player] < 0.5 then
        return
    end

    local localCharacter = localPlayer.Character
    local targetCharacter = player.Character
    if not localCharacter or not targetCharacter then
        return
    end

    local localHRP = localCharacter:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")

    if not localHRP or not targetHRP or not targetHumanoid then
        return
    end

    local distance = (localHRP.Position - targetHRP.Position).Magnitude
    if distance > tagAuraRange then
        return
    end

    local args = {
        [1] = targetHumanoid,
        [2] = targetHRP.Position
    }

    local success, response =
        pcall(
        function()
            return tagEventPath:InvokeServer(unpack(args))
        end
    )

    if success then
        lastTagTime[player] = currentTime
        if legitTag then
            local animFolder =
                ReplicatedStorage:FindFirstChild("Animations") and ReplicatedStorage.Animations:FindFirstChild("Base")
            if animFolder then
                local tagAnim = animFolder:FindFirstChild("Tag1") or animFolder:FindFirstChild("Tag2")
                if tagAnim then
                    local animator =
                        localCharacter:FindFirstChild("Humanoid") and localCharacter.Humanoid:FindFirstChild("Animator")
                    if animator then
                        local animation = animator:LoadAnimation(tagAnim)
                        local isPlaying = false
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            if track.Animation == tagAnim then
                                isPlaying = true
                                break
                            end
                        end
                        if not isPlaying then
                            animation:Play()
                        end
                    end
                end
            end
        end
    else
        warn("Error tagging:", response)
    end
end
local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(
    function()
        if tagEnabled and not shouldStopTagging() then
            local target = getLowestHealthTarget()
            if target then
                tagPlayer(target)
            end
        end

        updatePOVCircle()
    end
)

local Section = Tab:CreateSection("Pov")
-- UI Elements
local TogglePOVCircleEnabled =
    Tab:CreateToggle(
    {
        Name = "Enable POV Circle Tagging",
        CurrentValue = false,
        Flag = "POVCircleEnabled",
        Callback = function(Value)
            povCircleEnabled = Value
            updatePOVCircle()
        end
    }
)

local ToggleShowPOVCircle =
    Tab:CreateToggle(
    {
        Name = "Show POV Circle Border",
        CurrentValue = false,
        Flag = "ShowPOVCircle",
        Callback = function(Value)
            showPOVCircle = Value
            updatePOVCircle()
        end
    }
)

local SliderPOVCircleSize =
    Tab:CreateSlider(
    {
        Name = "Circle Border Size",
        Range = {0.5, 2},
        Increment = 0.05,
        Suffix = "",
        CurrentValue = povCircleRadius,
        Flag = "POVCircleSize",
        Callback = function(Value)
            povCircleRadius = Value
            updatePOVCircle()
        end
    }
)

local SliderPOVCircleThickness =
    Tab:CreateSlider(
    {
        Name = "Border Thickness",
        Range = {1, 10},
        Increment = 1,
        Suffix = "px",
        CurrentValue = povCircleThickness,
        Flag = "POVCircleThickness",
        Callback = function(Value)
            povCircleThickness = Value
            createPOVCircle() -- Recreate for thickness changes
            updatePOVCircle()
        end
    }
)
local Section = Tab:CreateSection("Color pov")
local ColorPickerPOVCircle =
    Tab:CreateColorPicker(
    {
        Name = "Border Color",
        Color = povCircleColor,
        Flag = "POVCircleColor",
        Callback = function(Value)
            povCircleColor = Value
            if circleBorder then
                circleBorder.Color = Value
            end
        end
    }
)

-- Add this to your UI creation section
local ToggleRainbowColor =
    Tab:CreateToggle(
    {
        Name = "Rainbow Color Effect",
        CurrentValue = false,
        Flag = "RainbowColor",
        Callback = function(Value)
            rainbowColorEnabled = Value
        end
    }
)

local SliderRainbowSpeed =
    Tab:CreateSlider(
    {
        Name = "Rainbow Speed",
        Range = {0.1, 3},
        Increment = 0.1,
        Suffix = "x",
        CurrentValue = rainbowColorSpeed,
        Flag = "RainbowSpeed",
        Callback = function(Value)
            rainbowColorSpeed = Value
        end
    }
)
-- Initialize
createPOVCircle()

-- Main loop
RunService.Heartbeat:Connect(
    function()
        updatePOVCircle()

        if not tagEnabled or shouldStopTagging() then
            return
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                tagPlayer(player)
            end
        end
    end
)

-- Cleanup
game:GetService("Players").PlayerRemoving:Connect(
    function(player)
        if player == localPlayer then
            if circleBorder then
                circleBorder:Remove()
            end
            if centerDot then
                centerDot:Remove()
            end
        end
    end
)
-------------------- Esp --------------------
local Tab = Window:CreateTab("Esp", 4483362458)
local Section = Tab:CreateSection("Esp (Lag)")
------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

-- ESP Configuration
local espConfig = {
    enabled = false,
    showName = false,
    showRole = false,
    teamCheck = false,
    ignoreDead = false,
    size = 20,
    updateInterval = 0.05,
    showNeutralOnly = false,
    showCrownOnly = false,
    showRunnerOnly = false
}

-- Tracer Configuration
local tracerConfig = {
    enabled = false,
    teamCheck = false,
    ignoreDead = false,
    thickness = 0.4,
    transparency = 0.7,
    showNeutralOnly = false,
    showCrownOnly = false,
    showRunnerOnly = false
}

-- Color Configuration
local colorConfig = {
    useCustomColor = false,
    rainbowMode = false,
    rainbowSpeed = 1,
    customColors = {
        Default = Color3.fromRGB(255, 255, 255)
    }
}

-- Role colors configuration
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
    infect = Color3.fromRGB(0, 255, 0),
    Infect = Color3.fromRGB(0, 255, 0),
    Sick = Color3.fromRGB(144, 238, 144),
    PatientZero = Color3.fromRGB(128, 0, 128),
    Patientzero = Color3.fromRGB(128, 0, 128),
    Medic = Color3.fromRGB(0, 100, 0),
    Bomb = Color3.fromRGB(255, 165, 0),
    HotBomb = Color3.fromRGB(255, 165, 0),
    bomb = Color3.fromRGB(255, 165, 0),
    Tagger = Color3.fromRGB(255, 0, 0),
    Slasher = Color3.fromRGB(139, 0, 0),
    Juggernaut = Color3.fromRGB(75, 0, 130),
    Hunter = Color3.fromRGB(0, 128, 0),
    Survivor = Color3.fromRGB(255, 255, 0),
    Alone = Color3.fromRGB(255, 0, 0),
    FFATagger = Color3.fromRGB(255, 0, 0),
    RunnerTagger = Color3.fromRGB(255, 0, 0)
}

-- ESP Objects
-- Changed from CoreGui to PlayerGui
local espFolder = Instance.new("Folder")
espFolder.Name = "ESPFolder_" .. math.random(10000, 99999) -- Added random suffix
espFolder.Parent = localPlayer:WaitForChild("PlayerGui") -- Changed parent
local espObjects = {}
local tracerObjects = {}
local connections = {}
local updateQueue = {}
local updatePending = false
local lastUpdateTime = 0
-- Instant update queue
local updateQueue = {}

-- Color functions
local function getRainbowColor(hue)
    local r = math.sin(hue * math.pi * 2) * 0.5 + 0.5
    local g = math.sin((hue + 1 / 3) * math.pi * 2) * 0.5 + 0.5
    local b = math.sin((hue + 2 / 3) * math.pi * 2) * 0.5 + 0.5
    return Color3.new(r, g, b)
end

local function getRoleColor(roleValue)
    if colorConfig.rainbowMode then
        return getRainbowColor((tick() * colorConfig.rainbowSpeed) % 1)
    end
    if colorConfig.useCustomColor then
        return colorConfig.customColors[roleValue] or colorConfig.customColors["Default"]
    end
    return roleColors[roleValue] or Color3.fromRGB(255, 255, 255)
end
local function shouldShowESP(player)
    if player == localPlayer then
        return false
    end
    if not player.Character then
        return false
    end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return false
    end

    -- Check for dead state (health or state) and Dead role
    local isDead =
        humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead or
        (player:FindFirstChild("PlayerRole") and player.PlayerRole.Value == "Dead")

    -- Ignore dead players if the toggle is on
    if espConfig.ignoreDead and isDead then
        return false
    end

    -- Role filters
    if espConfig.showNeutralOnly and roleValue ~= "Neutral" then
        return false
    end
    if espConfig.showCrownOnly and not (roleValue == "Crown" or roleValue == "SoloCrown") then
        return false
    end
    if espConfig.showRunnerOnly and roleValue ~= "Runner" then
        return false
    end

    -- Team check
    if espConfig.teamCheck then
        local roleValue = player:FindFirstChild("PlayerRole") and player.PlayerRole.Value
        local localRoleValue = localPlayer:FindFirstChild("PlayerRole") and localPlayer.PlayerRole.Value
        if roleValue and localRoleValue and roleValue == localRoleValue then
            return false
        end
    end

    return true
end
local function cleanUpPlayerESP(player)
    if espObjects[player] then
        if espObjects[player].gui then
            espObjects[player].gui:Destroy()
        end
        espObjects[player] = nil -- Clear reference
    end
end

local function cleanUpTracer(player)
    if tracerObjects[player] then
        for _, tracer in pairs(tracerObjects[player]) do
            if tracer then
                tracer:Remove()
            end
        end
        tracerObjects[player] = nil -- Clear reference
    end
end
local function cleanupDeadPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local isDead = false
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    isDead = humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead
                end
            end

            local playerRole = player:FindFirstChild("PlayerRole")
            if playerRole and playerRole.Value == "Dead" then
                isDead = true
            end

            if isDead then
                cleanUpPlayerESP(player)
                cleanUpTracer(player)
            end
        end
    end
end
local function shouldShowTracer(player)
    if player == localPlayer then
        return false
    end
    if not player.Character then
        return false
    end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return false
    end

    -- Dead check (both role and state)
    local isDead =
        humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead or
        (player:FindFirstChild("PlayerRole") and player.PlayerRole.Value == "Dead")

    if tracerConfig.ignoreDead and isDead then
        return false
    end

    -- Team check
    if tracerConfig.teamCheck then
        local playerRole = player:FindFirstChild("PlayerRole")
        local localRole = localPlayer:FindFirstChild("PlayerRole")
        if playerRole and localRole and playerRole.Value == localRole.Value then
            return false
        end
    end

    return true
end
-- ESP Creation and Update
local function updateESPDisplay(player)
    if not espConfig.enabled or not espObjects[player] then
        return
    end

    local character = player.Character
    if not character then
        return
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

    local playerRole = player:FindFirstChild("PlayerRole")
    local roleValue = playerRole and playerRole.Value or nil

    local displayText = ""
    if espConfig.showName then
        displayText = player.Name
    end
    if espConfig.showRole and roleValue then
        displayText = displayText ~= "" and (displayText .. "\n" .. roleValue) or roleValue
    end

    if espObjects[player] and espObjects[player].label then
        espObjects[player].label.Text = displayText
        espObjects[player].label.TextColor3 = getRoleColor(roleValue)
        espObjects[player].gui.Size = UDim2.new(espConfig.size, 0, espConfig.size / 4, 0)
        espObjects[player].gui.Adornee = hrp
    end
end
-- Improved queueUpdate function
local function queueUpdate(player)
    -- Mark player for update
    updateQueue[player] = true

    -- Start update process if not already running
    if not updatePending then
        updatePending = true
        task.spawn(
            function()
                -- Wait until next allowed update time
                local timeToWait = lastUpdateTime + espConfig.updateInterval - tick()
                if timeToWait > 0 then
                    task.wait(timeToWait)
                end

                -- Process all queued updates
                local playersToUpdate = {}
                for queuedPlayer in pairs(updateQueue) do
                    if queuedPlayer and queuedPlayer.Parent then -- Only update valid players
                        table.insert(playersToUpdate, queuedPlayer)
                    end
                    updateQueue[queuedPlayer] = nil
                end

                -- Perform updates
                for _, playerToUpdate in ipairs(playersToUpdate) do
                    if espObjects[playerToUpdate] then -- Only if ESP exists for player
                        updateESPDisplay(playerToUpdate)
                    end
                end

                lastUpdateTime = tick()
                updatePending = false
            end
        )
    end
end

local function createESP(player)
    if not espConfig.enabled or player == localPlayer then
        return
    end
    cleanUpPlayerESP(player)
    local character = player.Character
    if not character then
        return
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

    -- Create ESP GUI
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(espConfig.size, 0, espConfig.size / 4, 0)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = hrp
    billboard.Parent = espFolder

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSans
    textLabel.Parent = billboard

    -- Store ESP data
    espObjects[player] = {
        gui = billboard,
        label = textLabel,
        connections = {}
    }

    -- Set up event connections
    local function onRoleChanged()
        queueUpdate(player)
    end

    local function onCharacterAdded(player, newCharacter)
        local humanoid = newCharacter:WaitForChild("Humanoid")

        -- Clean up old connection
        if espObjects[player] and espObjects[player].humanoidDiedConn then
            espObjects[player].humanoidDiedConn:Disconnect()
        end

        -- Only connect death event if ignoreDead is enabled
        if espConfig.ignoreDead or tracerConfig.ignoreDead then
            espObjects[player].humanoidDiedConn =
                humanoid.Died:Connect(
                function()
                    -- Immediate update when player dies
                    if espConfig.enabled then
                        updateESPDisplay(player)
                    end
                    if tracerConfig.enabled then
                        cleanUpTracer(player) -- Remove tracer immediately
                    end
                end
            )
        end

        -- Initial update
        if espConfig.enabled then
            updateESPDisplay(player)
        end
        if tracerConfig.enabled then
            createTracer(player)
        end
    end

    -- Connect role change event
    local role = player:FindFirstChild("PlayerRole")
    if role then
        espObjects[player].roleChangedConn = role.Changed:Connect(onRoleChanged)
        table.insert(espObjects[player].connections, espObjects[player].roleChangedConn)
    end

    -- Connect character added event
    espObjects[player].characterAddedConn = player.CharacterAdded:Connect(onCharacterAdded)
    table.insert(espObjects[player].connections, espObjects[player].characterAddedConn)

    -- Initial update
    updateESPDisplay(player)
end

local function createTracer(player)
    if not tracerConfig.enabled or player == localPlayer then
        return
    end
    cleanUpTracer(player)
    local character = player.Character
    if not character then
        return
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

    -- Create tracer
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = tracerConfig.thickness
    tracer.Transparency = tracerConfig.transparency

    if not tracerObjects[player] then
        tracerObjects[player] = {}
    end
    table.insert(tracerObjects[player], tracer)
end

local function updateTracers()
    if not tracerConfig.enabled then
        return
    end

    local localChar = localPlayer.Character
    if not localChar then
        return
    end

    local localHrp = localChar:FindFirstChild("HumanoidRootPart")
    if not localHrp then
        return
    end

    -- First handle cleanup of dead players if ignoreDead is enabled
    if tracerConfig.ignoreDead then
        for player, tracers in pairs(tracerObjects) do
            if player and player.Parent then
                local shouldRemove = false

                -- Check if player has Dead role
                local playerRole = player:FindFirstChild("PlayerRole")
                if playerRole and playerRole.Value == "Dead" then
                    shouldRemove = true
                end

                -- Check if player's character is dead
                if player.Character then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and (humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead) then
                        shouldRemove = true
                    end
                end

                if shouldRemove then
                    cleanUpTracer(player)
                end
            end
        end
    end

    -- Now update visible tracers
    for player, tracers in pairs(tracerObjects) do
        if player and player.Parent then
            local character = player.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Check if we should show this tracer
                    local shouldShow = true

                    if tracerConfig.ignoreDead then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid and (humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead) then
                            shouldShow = false
                        end

                        local playerRole = player:FindFirstChild("PlayerRole")
                        if playerRole and playerRole.Value == "Dead" then
                            shouldShow = false
                        end
                    end

                    -- Apply team check if enabled
                    if shouldShow and tracerConfig.teamCheck then
                        local playerRole = player:FindFirstChild("PlayerRole")
                        local localRole = localPlayer:FindFirstChild("PlayerRole")

                        if playerRole and localRole and playerRole.Value == localRole.Value then
                            shouldShow = false
                        end
                    end

                    -- Update all tracers for this player
                    for _, tracer in ipairs(tracers) do
                        if tracer then
                            if shouldShow then
                                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                                local localScreenPos = workspace.CurrentCamera:WorldToViewportPoint(localHrp.Position)

                                if onScreen then
                                    tracer.From = Vector2.new(localScreenPos.X, localScreenPos.Y)
                                    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                                    tracer.Visible = true

                                    -- Update appearance
                                    local playerRole = player:FindFirstChild("PlayerRole")
                                    local roleValue = playerRole and playerRole.Value or nil
                                    tracer.Color = getRoleColor(roleValue)
                                    tracer.Thickness = tracerConfig.thickness
                                    tracer.Transparency = tracerConfig.transparency
                                else
                                    tracer.Visible = false
                                end
                            else
                                tracer.Visible = false
                            end
                        end
                    end
                end
            end
        else
            cleanUpTracer(player)
        end
    end

    -- Create tracers for new valid players
    if tracerConfig.enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and not tracerObjects[player] then
                if shouldShowTracer(player) then
                    createTracer(player)
                end
            end
        end
    end
end
local function startUpdateLoop()
    local heartbeatConnection
    local lastUpdate = 0

    local function updateAll()
        -- Throttle updates based on updateInterval
        local now = tick()
        if now - lastUpdate < espConfig.updateInterval then
            return
        end
        lastUpdate = now

        -- Update all players
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                -- ESP Update
                if espConfig.enabled and shouldShowESP(player) then
                    if not espObjects[player] then
                        createESP(player)
                    else
                        updateESPDisplay(player)
                    end
                else
                    cleanUpPlayerESP(player)
                end

                -- Tracer Update
                if tracerConfig.enabled and shouldShowTracer(player) then
                    if not tracerObjects[player] then
                        createTracer(player)
                    end
                else
                    cleanUpTracer(player)
                end
            end
        end

        -- Continuous tracer updates
        updateTracers()
    end

    heartbeatConnection = RunService.Heartbeat:Connect(updateAll)

    return function()
        heartbeatConnection:Disconnect()
    end
end
local function updatePlayerESP(player)
    -- Handle ESP
    if espConfig.enabled then
        if shouldShowESP(player) then
            if not espObjects[player] then
                createESP(player)
            else
                updateESPDisplay(player)
            end
        else
            cleanUpPlayerESP(player)
        end
    else
        cleanUpPlayerESP(player)
    end

    -- Handle Tracer
    if tracerConfig.enabled then
        if shouldShowTracer(player) then
            if not tracerObjects[player] then
                createTracer(player)
            end
        else
            cleanUpTracer(player)
        end
    else
        cleanUpTracer(player)
    end
end
local function onCharacterAdded(player, newCharacter)
    local humanoid = newCharacter:WaitForChild("Humanoid")

    -- Initialize player entry in espObjects if not exists
    if not espObjects[player] then
        espObjects[player] = {}
    end

    -- Clean up old connection if it exists
    if espObjects[player].humanoidDiedConn then
        espObjects[player].humanoidDiedConn:Disconnect()
        espObjects[player].humanoidDiedConn = nil
    end

    -- Only connect death event if ignoreDead is enabled
    if espConfig.ignoreDead or tracerConfig.ignoreDead then
        espObjects[player].humanoidDiedConn =
            humanoid.Died:Connect(
            function()
                -- Immediate update when player dies
                if espConfig.enabled then
                    updateESPDisplay(player)
                end
                if tracerConfig.enabled then
                    cleanUpTracer(player) -- Remove tracer immediately
                end
            end
        )
    end

    -- Initial update
    if espConfig.enabled then
        updateESPDisplay(player)
    end
    if tracerConfig.enabled then
        createTracer(player)
    end
end
local function setupPlayerEvents()
    -- Player Added
    table.insert(
        connections,
        Players.PlayerAdded:Connect(
            function(player)
                -- Character Added
                table.insert(
                    connections,
                    player.CharacterAdded:Connect(
                        function(character)
                            task.wait(0.5) -- Small delay to allow character to fully load
                            onCharacterAdded(player, character)
                        end
                    )
                )

                -- Role Changed
                local role = player:FindFirstChild("PlayerRole")
                if role then
                    table.insert(
                        connections,
                        role.Changed:Connect(
                            function()
                                if espConfig.enabled or tracerConfig.enabled then
                                    updatePlayerESP(player)
                                end
                            end
                        )
                    )
                end

                -- Initial Setup if character already exists
                if player.Character then
                    onCharacterAdded(player, player.Character)
                end
            end
        )
    )

    -- Player Removing
    table.insert(
        connections,
        Players.PlayerRemoving:Connect(
            function(player)
                cleanUpPlayerESP(player)
                cleanUpTracer(player)
            end
        )
    )
end
local function clearAllESP()
    for player in pairs(espObjects) do
        cleanUpPlayerESP(player)
    end
    for player in pairs(tracerObjects) do
        cleanUpTracer(player)
    end
    espObjects = {}
    tracerObjects = {}
end
-- Added this new initialization function to replace the old setup
local stopUpdateLoop
local function initializeESP()
    -- Cleanup previous instances
    if stopUpdateLoop then
        stopUpdateLoop()
    end
    clearAllESP()

    -- Setup new instances
    setupPlayerEvents()

    -- Start update loop if needed
    if espConfig.enabled or tracerConfig.enabled then
        stopUpdateLoop = startUpdateLoop()
    end

    -- Initial update
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            updatePlayerESP(player)
        end
    end
end
local function forceFullUpdate()
    for _, player in ipairs(Players:GetPlayers()) do
        updatePlayerESP(player)
    end
end
-- Initialize ESP for all players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        updatePlayerESP(player)
    end
end
-- Added proper character added handling
table.insert(
    connections,
    Players.PlayerAdded:Connect(
        function(player)
            player.CharacterAdded:Connect(
                function()
                    updatePlayerESP(player)
                end
            )
            updatePlayerESP(player)
        end
    )
)
table.insert(
    connections,
    Players.PlayerRemoving:Connect(
        function(player)
            cleanUpPlayerESP(player)
            cleanUpTracer(player)
        end
    )
)

-- Connect local player role changes
local localRole = localPlayer:FindFirstChild("PlayerRole")
if localRole then
    table.insert(
        connections,
        localRole.Changed:Connect(
            function()
                if espConfig.teamCheck or tracerConfig.teamCheck then
                    forceFullUpdate()
                end
            end
        )
    )
end

-- Removed complex queue system
table.insert(
    connections,
    RunService.RenderStepped:Connect(
        function()
            updateTracers() -- Just update tracers each frame
        end
    )
)

local function fullCleanup()
    -- Stop the update loop
    if stopUpdateLoop then
        stopUpdateLoop()
        stopUpdateLoop = nil
    end

    -- Clear all ESP objects
    for player, espData in pairs(espObjects) do
        if espData then
            -- Clean up GUI
            if espData.gui then
                pcall(
                    function()
                        espData.gui:Destroy()
                    end
                )
            end

            -- Disconnect all events
            if espData.connections then
                for _, conn in pairs(espData.connections) do
                    pcall(
                        function()
                            conn:Disconnect()
                        end
                    )
                end
            end
        end
    end
    espObjects = {}

    -- Clear all trackers/lines
    for player, tracers in pairs(tracerObjects) do
        if tracers then
            for _, tracer in ipairs(tracers) do
                pcall(
                    function()
                        if tracer then
                            tracer.Visible = false
                            tracer:Remove()
                        end
                    end
                )
            end
        end
    end
    tracerObjects = {}

    -- Clear the ESP folder
    if espFolder then
        pcall(
            function()
                espFolder:Destroy()
            end
        )
    end
end

-- Teleport handler
local teleportConnection
teleportConnection =
    localPlayer.OnTeleport:Connect(
    function(state)
        if state == Enum.TeleportState.Started then
            -- Disconnect all other connections first
            for _, conn in ipairs(connections) do
                pcall(
                    function()
                        conn:Disconnect()
                    end
                )
            end

            -- Perform full cleanup
            fullCleanup()

            -- Disconnect this connection last
            teleportConnection:Disconnect()
        end
    end
)
table.insert(connections, teleportConnection)

-- Player leaving handler (for normal disconnects)
local playerRemovingConnection
playerRemovingConnection =
    Players.PlayerRemoving:Connect(
    function(player)
        if player == localPlayer then
            fullCleanup()
            playerRemovingConnection:Disconnect()
        end
    end
)
table.insert(connections, playerRemovingConnection)
-- Modified toggle callbacks to use new initialization
local ToggleEsp =
    Tab:CreateToggle(
    {
        Name = "ESP Toggle",
        CurrentValue = espConfig.enabled,
        Callback = function(Value)
            espConfig.enabled = Value
            initializeESP()
        end
    }
)
Tab:CreateToggle(
    {
        Name = "Show Role",
        CurrentValue = espConfig.showRole,
        Flag = "ESPRole",
        Callback = function(Value)
            espConfig.showRole = Value
            forceFullUpdate()
        end
    }
)

Tab:CreateToggle(
    {
        Name = "Show Name",
        CurrentValue = espConfig.showName,
        Flag = "ESPName",
        Callback = function(Value)
            espConfig.showName = Value
            forceFullUpdate()
        end
    }
)

Tab:CreateToggle(
    {
        Name = "Ignore Dead",
        CurrentValue = espConfig.ignoreDead,
        Flag = "IgnoreDead",
        Callback = function(Value)
            espConfig.ignoreDead = Value
            if Value then
                cleanupDeadPlayers()
            else
                forceFullUpdate()
            end
        end
    }
)

Tab:CreateToggle(
    {
        Name = "Team Check",
        CurrentValue = espConfig.teamCheck,
        Flag = "TeamCheck",
        Callback = function(Value)
            espConfig.teamCheck = Value
            forceFullUpdate()
        end
    }
)

Tab:CreateSlider(
    {
        Name = "Size",
        Range = {1, 40},
        Increment = 1,
        Suffix = " Size",
        CurrentValue = espConfig.size,
        Flag = "ESPSize",
        Callback = function(Value)
            espConfig.size = Value
            forceFullUpdate()
        end
    }
)
local Section = Tab:CreateSection("Line esp(Lag)")
local ToggleLine =
    Tab:CreateToggle(
    {
        Name = "Line on/off",
        CurrentValue = tracerConfig.enabled,
        Callback = function(Value)
            tracerConfig.enabled = Value
            initializeESP() -- Full reinitialization when toggled
        end
    }
)

Tab:CreateToggle(
    {
        Name = "Line Team Check",
        CurrentValue = tracerConfig.teamCheck,
        Flag = "TracerTeamCheck",
        Callback = function(Value)
            tracerConfig.teamCheck = Value
            forceFullUpdate()
        end
    }
)

-- Update the ignoreDead toggle to handle role changes
Tab:CreateToggle(
    {
        Name = "Line Ignore Dead",
        CurrentValue = tracerConfig.ignoreDead,
        Callback = function(Value)
            tracerConfig.ignoreDead = Value

            -- Immediate cleanup if toggled on
            if Value then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer then
                        local shouldClean = false

                        -- Check health/death state
                        if player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                shouldClean = humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead
                            end
                        end

                        -- Check for Dead role
                        local playerRole = player:FindFirstChild("PlayerRole")
                        if playerRole and playerRole.Value == "Dead" then
                            shouldClean = true
                        end

                        if shouldClean then
                            cleanUpTracer(player)
                        end
                    end
                end
            else
                -- If toggled off, recreate tracers for valid players
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and shouldShowTracer(player) then
                        createTracer(player)
                    end
                end
            end
        end
    }
)

Tab:CreateSlider(
    {
        Name = "Line Thickness",
        Range = {0.1, 5},
        Increment = 0.1,
        Suffix = "px",
        CurrentValue = tracerConfig.thickness,
        Flag = "TracerThickness",
        Callback = function(Value)
            tracerConfig.thickness = Value
        end
    }
)

Tab:CreateSlider(
    {
        Name = "Line Transparency",
        Range = {0, 1},
        Increment = 0.05,
        Suffix = "",
        CurrentValue = tracerConfig.transparency,
        Flag = "TracerTransparency",
        Callback = function(Value)
            tracerConfig.transparency = Value
        end
    }
)

-- Color Controls
Tab:CreateToggle(
    {
        Name = "Custom Colors",
        CurrentValue = colorConfig.useCustomColor,
        Flag = "UseCustomColors",
        Callback = function(Value)
            colorConfig.useCustomColor = Value
            forceFullUpdate()
        end
    }
)

Tab:CreateToggle(
    {
        Name = "raimbow Mode",
        CurrentValue = colorConfig.rainbowMode,
        Flag = "RainbowMode",
        Callback = function(Value)
            colorConfig.rainbowMode = Value
            forceFullUpdate()
        end
    }
)

Tab:CreateSlider(
    {
        Name = "raimbow Speed",
        Range = {0.1, 5},
        Increment = 0.1,
        Suffix = "x",
        CurrentValue = colorConfig.rainbowSpeed,
        Flag = "RainbowSpeed",
        Callback = function(Value)
            colorConfig.rainbowSpeed = Value
        end
    }
)

Tab:CreateColorPicker(
    {
        Name = "costom Color set",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "DefaultTracerColor",
        Callback = function(Value)
            colorConfig.customColors["Default"] = Value
            if colorConfig.useCustomColor then
                forceFullUpdate()
            end
        end
    }
)
-------------------- player --------------------
local Tab = Window:CreateTab("localPlayer", 4483362458)
local Section = Tab:CreateSection("localPlayer")
------------------------------------------------------------
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
local Section = Tab:CreateSection("Speed")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local tpwalking = false
local walktpSpeed = 1 -- Default speed = 1

-- Toggle
Tab:CreateToggle(
    {
        Name = "Speed Boost",
        CurrentValue = false,
        Flag = "TPWalkToggle",
        Callback = function(Value)
            tpwalking = Value
            if Value then
                task.spawn(
                    function()
                        local chr = LocalPlayer.Character
                        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        while tpwalking and chr and hum and hum.Parent do
                            local delta = RunService.Heartbeat:Wait()
                            if hum.MoveDirection.Magnitude > 0 then
                                chr:TranslateBy(hum.MoveDirection * walktpSpeed * delta)
                            end
                            chr = LocalPlayer.Character
                            hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        end
                    end
                )
            end
        end
    }
)

-- Slider
Tab:CreateSlider(
    {
        Name = "Speed Boost amount",
        Range = {1, 100},
        Increment = 1,
        Suffix = "Speed",
        CurrentValue = 1, -- Default 1
        Flag = "TPWalkSpeedSlider",
        Callback = function(Value)
            walktpSpeed = Value
        end
    }
)
local Section = Tab:CreateSection("Fling")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local walkflinging = false

local function getRoot(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function startWalkFling()
    if walkflinging then
        return
    end
    walkflinging = true

    -- Aktifkan noclip (jika ada sistem ToggleNoclip)
    if ToggleNoclip then
        ToggleNoclip:Set(true)
    end

    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        humanoid.Died:Connect(
            function()
                stopWalkFling()
            end
        )
    end

    task.spawn(
        function()
            local movel = 0.1
            repeat
                local character = LocalPlayer.Character
                local root = getRoot(character)
                local vel

                while not (character and character.Parent and root and root.Parent) do
                    task.wait()
                    character = LocalPlayer.Character
                    root = getRoot(character)
                end

                vel = root.Velocity
                root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

                RunService.RenderStepped:Wait()
                if character and character.Parent and root and root.Parent then
                    root.Velocity = vel
                end

                RunService.Stepped:Wait()
                if character and character.Parent and root and root.Parent then
                    root.Velocity = vel + Vector3.new(0, movel, 0)
                    movel = -movel
                end

                task.wait()
            until not walkflinging
        end
    )
end

function stopWalkFling()
    walkflinging = false
    if ToggleNoclip then
        ToggleNoclip:Set(false)
    end
end

-- Toggle GUI
Tab:CreateToggle(
    {
        Name = "Walk Fling",
        CurrentValue = false,
        Flag = "WalkFling",
        Callback = function(Value)
            if Value then
                startWalkFling()
            else
                stopWalkFling()
            end
        end
    }
)
-------------------- Tool --------------------
local Tab = Window:CreateTab("Tool", 4483362458)
------------------------------------------------------------
local Section = Tab:CreateSection("Gun")
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local toggle = false
local function getNearestInfected()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local myPosition = character.HumanoidRootPart.Position
    for _, target in pairs(game:GetService("Players"):GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetRole = target:FindFirstChild("PlayerRole")
            if targetRole and targetRole.Value == "Infected" then
                local distance = (target.Character.HumanoidRootPart.Position - myPosition).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = target
                end
            end
        end
    end
    return nearestPlayer
end
local function autoShoot()
    while toggle do
        local tool = player.Character and player.Character:FindFirstChild("PaintballGun")
        if tool and tool:FindFirstChild("DoGun") then
            local nearest = getNearestInfected()
            if nearest and nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart") then
                local args = {tool, nearest.Character.HumanoidRootPart.Position}
                tool.DoGun:InvokeServer(unpack(args))
            end
        end
        task.wait(0.4) -- Delay agar tidak spam terlalu cepat
    end
end
local Toggle =
    Tab:CreateToggle(
    {
        Name = "silent aim gun",
        CurrentValue = false,
        Flag = "AutoShootToggle",
        Callback = function(Value)
            toggle = Value
            if toggle then
                print("Auto Shoot ON")
                task.spawn(autoShoot) -- Gunakan task.spawn agar tidak freeze UI
            else
                print("Auto Shoot OFF")
            end
        end
    }
)

-------------------- Misc --------------------
local Tab = Window:CreateTab("Misc", 4483362458)
------------------------------------------------------------
local Section = Tab:CreateSection("Close Rayfield ui")
local Button =
    Tab:CreateButton(
    {
        Name = "Permanent Close ui",
        Callback = function()
            Rayfield:Destroy()
        end
    }
)
local Section = Tab:CreateSection("Code")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RedeemEvent = ReplicatedStorage.Events.game.ui.RedeemCode
local DELAY_BETWEEN_REDEEMS = 1.7

-- Fungsi untuk redeem kode dengan berbagai format
local function redeemCode(code)
    local formats = {
        code, -- Format asli
        code:gsub("%%20", " "), -- Ganti %20 dengan spasi
        code:gsub(" ", "%%20") -- Ganti spasi dengan %20
    }

    for _, fmt in ipairs(formats) do
        local success, result =
            pcall(
            function()
                return RedeemEvent:InvokeServer(fmt)
            end
        )

        if success then
            return true
        end
    end

    return false
end

-- Fungsi untuk load kode dari GitHub
local function loadCodes()
    local githubUrl = "https://raw.githubusercontent.com/nAlwspa/Into/main/Codex.txt"

    local httpMethods = {
        -- Metode standar Roblox
        function()
            if game:GetService("HttpService"):GetHttpEnabled() then
                return game:GetService("HttpService"):GetAsync(githubUrl)
            end
        end,
        -- Metode untuk Synapse X
        function()
            if syn and syn.request then
                local response =
                    syn.request(
                    {
                        Url = githubUrl,
                        Method = "GET"
                    }
                )
                return response.Body
            end
        end,
        -- Metode untuk KRNL/Fluxus
        function()
            if request then
                local response =
                    request(
                    {
                        url = githubUrl,
                        method = "GET"
                    }
                )
                return response.body
            end
        end,
        -- Metode umum lainnya
        function()
            if http_request then
                local response =
                    http_request(
                    {
                        Url = githubUrl,
                        Method = "GET"
                    }
                )
                return response.Body
            end
        end
    }

    for _, method in ipairs(httpMethods) do
        local success, response = pcall(method)
        if success and response then
            if type(response) == "string" then
                local codes = {}
                for line in response:gmatch("[^\r\n]+") do
                    if not line:match("^%s*#") and #line > 0 then
                        table.insert(codes, line:match("^%s*(.-)%s*$"))
                    end
                end
                return codes
            end
        end
    end

    return nil
end

-- Fungsi utama untuk redeem semua kode
local function redeemAllCodes()
    Rayfield:Notify(
        {
            Title = "Redeeming Codes",
            Content = "Starting to redeem all codes...",
            Duration = 3,
            Image = 4483362458
        }
    )

    local codes = loadCodes()
    if not codes or #codes == 0 then
        Rayfield:Notify(
            {
                Title = "Error",
                Content = "No codes found to redeem",
                Duration = 3,
                Image = 4483362458
            }
        )
        return
    end

    for i, code in ipairs(codes) do
        if redeemCode(code) then
            Rayfield:Notify(
                {
                    Title = "Success",
                    Content = string.format("Redeemed code: %s (%d/%d)", code, i, #codes),
                    Duration = 1,
                    Image = 4483362458
                }
            )
        else
            Rayfield:Notify(
                {
                    Title = "Failed",
                    Content = string.format("Failed to redeem code: %s (%d/%d)", code, i, #codes),
                    Duration = 3,
                    Image = 4483362458
                }
            )
        end
        task.wait(DELAY_BETWEEN_REDEEMS)
    end

    Rayfield:Notify(
        {
            Title = "Completed",
            Content = string.format("Successfully redeemed %d codes", #codes),
            Duration = 1,
            Image = 4483362458
        }
    )
end

-- UI Button
local Button =
    Tab:CreateButton(
    {
        Name = "Auto Redeem code",
        Callback = redeemAllCodes,
        Tooltip = "Redeem all available codes"
    }
)
local Section = Tab:CreateSection("Req")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local WebhookURL =
    "https://discord.com/api/webhooks/1251060163398467625/zLMibUZzFIdx_ZsAr-dBT1DFbp3K4w1Q0qFvrunDzlsiuEzbE-tlmqoync5eh_Qhjl9h"
local cooldownTime = 10
local cooldownFilePath = "cld/cld_path"
local lastSendTime = 0
local function readCooldown()
    if isfile and isfile(cooldownFilePath) then
        local contents = readfile(cooldownFilePath)
        local number = tonumber(contents)
        if number then
            return number
        end
    end
    return 0
end
local function saveCooldown(timeRemaining)
    if writefile then
        writefile(cooldownFilePath, tostring(timeRemaining))
    end
end
lastSendTime = tick() - (cooldownTime - readCooldown())
local function GetExecutorName()
    if identifyexecutor then
        return identifyexecutor()
    elseif syn and syn.request then
        return "Synapse X"
    elseif request then
        return "Script-Ware or Fluxus"
    else
        return "Unknown Executor"
    end
end
local function SendToWebhook(text)
    if tick() - lastSendTime < cooldownTime then
        local timeLeft = math.ceil(cooldownTime - (tick() - lastSendTime))
        Rayfield:Notify(
            {
                Title = "Cooldown Active",
                Content = "Please wait " .. timeLeft .. "s before sending again.",
                Duration = 2,
                Image = 4483362458
            }
        )
        return
    end

    lastSendTime = tick()
    saveCooldown(cooldownTime)

    if #text > 999 then
        text = string.sub(text, 1, 999)
    end

    local data = {
        content = "**New Input Sent**",
        embeds = {
            {
                title = "User Input Data",
                color = 16711680,
                fields = {
                    {name = "Player Name", value = LocalPlayer.Name, inline = true},
                    {name = "User ID", value = tostring(LocalPlayer.UserId), inline = true},
                    {name = "Executor", value = GetExecutorName(), inline = true},
                    {name = "Input Text", value = text, inline = false}
                }
            }
        }
    }
    local jsonData = HttpService:JSONEncode(data)
    local headers = {["Content-Type"] = "application/json"}
    local requestFunction = request or syn and syn.request or http and http.request
    if requestFunction then
        Rayfield:Notify(
            {
                Title = "Success",
                Content = "Text sent to Discord webhook!",
                Duration = 2,
                Image = 4483362458
            }
        )

        requestFunction(
            {
                Url = WebhookURL,
                Method = "POST",
                Headers = headers,
                Body = jsonData
            }
        )
    else
        warn("GO GET BETTER EXECUTOR DUDE")
    end
end
if writefile then
    task.spawn(
        function()
            while true do
                task.wait(1)
                local timeLeft = math.max(0, cooldownTime - (tick() - lastSendTime))
                saveCooldown(math.ceil(timeLeft))
            end
        end
    )
end
local Label =
    Tab:CreateLabel(
    "Sending will include max 999 characters. Cooldown: 10 seconds.",
    "hourglass",
    Color3.fromRGB(0, 0, 0),
    false
)
local Input =
    Tab:CreateInput(
    {
        Name = "Enter Text",
        CurrentValue = "",
        PlaceholderText = "Type something...",
        RemoveTextAfterFocusLost = false,
        Flag = "Input11",
        Callback = function(Text)
        end
    }
)
local Button =
    Tab:CreateButton(
    {
        Name = "Send",
        Callback = function()
            SendToWebhook(Input.CurrentValue)
        end
    }
)
local Section = Tab:CreateSection("EdgeIY")
local Button =
    Tab:CreateButton(
    {
        Name = "Infinite Yield ", -- Nama tombol yang lebih deskriptif
        Callback = function()
            -- Jalankan script Infinite Yield
            local success, err =
                pcall(
                function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
                end
            )

            if not success then
                warn("Failed to load IY:", err)
            end
        end
    }
)
local Button =
    Tab:CreateButton(
    {
        Name = "Clear Cache",
        Callback = function()
            -- Membersihkan semua ESP
            for player, espData in pairs(espObjects) do
                if espData and espData.gui then
                    espData.gui:Destroy()
                end
            end
            espObjects = {}

            -- Membersihkan semua Line (tracer)
            for player, tracers in pairs(tracerObjects) do
                if tracers then
                    for _, tracer in ipairs(tracers) do
                        if tracer then
                            tracer:Remove()
                        end
                    end
                end
            end
            tracerObjects = {}

            -- Membersihkan folder ESP
            if espFolder then
                espFolder:Destroy()
                -- Membuat folder baru
                espFolder = Instance.new("Folder")
                espFolder.Name = "ESPFolder_" .. math.random(10000, 99999)
                espFolder.Parent = localPlayer:WaitForChild("PlayerGui")
            end

            -- Memutuskan semua koneksi event
            for _, conn in ipairs(connections) do
                pcall(
                    function()
                        conn:Disconnect()
                    end
                )
            end
            connections = {}

            -- Menghentikan update loop jika ada
            if stopUpdateLoop then
                stopUpdateLoop()
                stopUpdateLoop = nil
            end

            -- Menginisialisasi ulang ESP jika sedang aktif
            if espConfig.enabled or tracerConfig.enabled then
                initializeESP()
            end

            print("[SUCCESS] cleared!")
        end
    }
)
local Tab = Window:CreateTab("Credit", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Profile")
local Label = Tab:CreateLabel("Youtube:Rof_r", "contact-round", Color3.fromRGB(0, 0, 255), false)
local Section = Tab:CreateSection("Sosial Media")
local Paragraph = Tab:CreateParagraph({Title = "Youtube Channel", Content = "youtube.com/@Rof_R"})
local Paragraph = Tab:CreateParagraph({Title = "Discord Invite Link", Content = "discord.gg/gNyn7Gpn"})
local Paragraph = Tab:CreateParagraph({Title = "Tiktok Profile", Content = "-"})
local Label = Tab:CreateLabel("Last Update:22/07/2025", "flag", Color3.fromRGB(0, 0, 0), false)
------------------------------------------------------------
------------------------------------------------------------
--------------------Panic Mode --------------------
local Section = Tab:CreateSection("Emergency")
local Button =
    Tab:CreateButton(
    {
        Name = "PANIC (Turn off all features)",
        Callback = function()
            -- Turn off all toggles
            if ToggleTag then
                ToggleTag:Set(false)
            end
            if ToggleFilterDead then
                ToggleFilterDead:Set(false)
            end
            if ToggleTeamCheck then
                ToggleTeamCheck:Set(false)
            end
            if ToggleLegitTag then
                ToggleLegitTag:Set(false)
            end
            if ToggleRoleFilter then
                ToggleRoleFilter:Set(false)
            end
            if ToggleStopVoting then
                ToggleStopVoting:Set(false)
            end
            if TogglePOVCircleEnabled then
                TogglePOVCircleEnabled:Set(false)
            end
            if ToggleShowPOVCircle then
                ToggleShowPOVCircle:Set(false)
            end
            if ToggleInfJump then
                ToggleInfJump:Set(false)
            end
            if ToggleNoclip then
                ToggleNoclip:Set(false)
            end
            if ToggleRainbowColor then
                ToggleRainbowColor:Set(false)
            end
            if ToggleEsp then
                ToggleEsp:Set(false)
            end
            if ToggleLine then
                ToggleLine:Set(false)
            end

            -- Clear ESP and other visual elements
            for player, espData in pairs(espObjects) do
                if espData and espData.gui then
                    espData.gui:Destroy()
                end
            end
            espObjects = {}

            for player, tracers in pairs(tracerObjects) do
                if tracers then
                    for _, tracer in ipairs(tracers) do
                        if tracer then
                            tracer:Remove()
                        end
                    end
                end
            end
            tracerObjects = {}

            -- Stop any active processes
            if infJump then
                infJump:Disconnect()
                infJump = nil
            end

            -- Stop walk fling if active
            walkflinging = false

            -- Stop tag aura
            tagEnabled = false

            -- Notify user
            Rayfield:Notify(
                {
                    Title = "PANIC Activated",
                    Content = "All features have been turned off",
                    Duration = 6.5,
                    Image = 4483362458
                }
            )
        end
    }
)
