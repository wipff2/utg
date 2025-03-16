local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
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
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

Rayfield:Notify({
   Title = "Notification",
   Content = "Load..",
   Duration = 5,
   Image = "rewind",
})

local Tab = Window:CreateTab("OP", "home")

-- Button Copy Discord
Tab:CreateButton({
    Name = "Copy Link Discord",
    Callback = function()
        setclipboard('https://discord.gg/gewBfTSm') 
        print('Copied')
    end,
})

-- Button Copy Loadstring
Tab:CreateButton({
    Name = "Copy Loader/Loadstring keyless",
    Callback = function()
        setclipboard("loadstring(game:HttpGet('https://raw.githubusercontent.com/nAlwspa/rayfield/refs/heads/main/fef.lua'))()") 
        print('Copied')
    end,
})

local Section = Tab:CreateSection("Tagging")
local ignoreDead = true
local teamCheck = false
local tagAura = true
local tagAuraMode = "Closest"
local tagAuraRange = 7
local tagCooldowns = {}

Tab:CreateToggle({
   Name = "Tagging Auto",
   CurrentValue = false,
   Flag = "TagAura",
   Callback = function(Value)
       tagAura = Value
       print("Tagging Auto toggled:", Value)
   end,
})

Tab:CreateDropdown({
   Name = "Tagging Mode",
   Options = {"Closest", "Multi Target"},
   CurrentOption = "Closest",
   MultipleOptions = false,
   Flag = "TagAuraMode",
   Callback = function(Option)
       tagAuraMode = Option
       print("Tagging Mode set to:", Option)
   end,
})

Tab:CreateSlider({
   Name = "Tagging Range",
   Range = {0, 15},
   Increment = 1,
   CurrentValue = 7,
   Flag = "TagAuraRange",
   Callback = function(Value)
       tagAuraRange = Value
       print("Tagging Range set to:", Value)
   end,
})

Tab:CreateToggle({
   Name = "Ignore Dead",
   CurrentValue = false,
   Flag = "IgnoreDead",
   Callback = function(Value)
       ignoreDead = Value
       print("Ignore Dead toggled:", Value)
   end,
})

Tab:CreateToggle({
   Name = "Team Check",
   CurrentValue = false,
   Flag = "TeamCheck",
   Callback = function(Value)
       teamCheck = Value
       print("Team Check toggled:", Value)
   end,
})

local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tagPlayerEvent = replicatedStorage:WaitForChild("Events"):WaitForChild("game"):WaitForChild("tags"):WaitForChild("TagPlayer")
local runService = game:GetService("RunService")

local function moveMouseGradually(targetPosition)
    local camera = workspace.CurrentCamera
    local viewportPoint = camera:WorldToViewportPoint(targetPosition)
    local targetX = viewportPoint.X - (camera.ViewportSize.X / 2)
    local targetY = viewportPoint.Y - (camera.ViewportSize.Y / 2)

    local steps = math.clamp(math.floor(math.abs(targetX + targetY) / 10), 5, 15)

    for i = 1, steps do
        mousemoverel(targetX / steps, targetY / steps)
        task.wait(0.015 + (math.random() * 0.01))
    end
end

local function isPlayerValid(player)
    if not player.Character then return false end
    local localPlayer = players.LocalPlayer
    local localRole = localPlayer:FindFirstChild("PlayerRole") and localPlayer.PlayerRole.Value
    local targetRole = player:FindFirstChild("PlayerRole") and player.PlayerRole.Value

    if ignoreDead and targetRole == "Dead" then return false end

    if teamCheck then
        if localRole == "Crown" or localRole == "SoloCrown" then
            if targetRole ~= "Neutral" then return false end
        else
            if targetRole == localRole then return false end
        end
    end
    return true
end

local function tagPlayer(player, distance)
    local currentTime = os.clock()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        local targetHRP = character:FindFirstChild("HumanoidRootPart")

        if humanoid and targetHRP then
            if distance <= 2 or distance > tagAuraRange then return end -- Batasi jarak valid

            print("Preparing to tag:", player.Name, "| Distance:", distance)

            moveMouseGradually(targetHRP.Position)
            
            task.wait(math.random(0.7, 0.9))
            local adjustedDistance = math.clamp(distance - 2, 2, tagAuraRange)

            print("Tagging player:", player.Name, "| Adjusted Distance:", adjustedDistance, "| Time:", os.time())
            tagPlayerEvent:InvokeServer(humanoid, targetHRP.Position + Vector3.new(0, 0, -adjustedDistance))
            tagCooldowns[player] = currentTime
            task.wait(math.random(0.7, 0.9))
        end
    end
end

local tagAuraConnection -- Variabel untuk menyimpan koneksi heartbeat

local function onHeartbeat()
    if not tagAura then return end

    local localPlayer = players.LocalPlayer
    local localCharacter = localPlayer.Character
    local humanoidRootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

    if not humanoidRootPart then return end

    local localPosition = humanoidRootPart.Position
    local currentTime = os.clock()
    local validPlayers = {}

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and isPlayerValid(player) then
            local character = player.Character
            local targetHRP = character and character:FindFirstChild("HumanoidRootPart")

            if targetHRP then
                local distance = (targetHRP.Position - localPosition).Magnitude
                if distance > 2 and distance <= tagAuraRange then
                    table.insert(validPlayers, {player = player, distance = distance})
                end
            end
        end
    end

    if #validPlayers > 0 then
        print("Valid players detected:", #validPlayers)
    end

    if tagAuraMode == "Closest" then
        table.sort(validPlayers, function(a, b) return a.distance < b.distance end)

        if validPlayers[1] then
            local target = validPlayers[1]
            if not tagCooldowns[target.player] or currentTime - tagCooldowns[target.player] > 1.2 then
                print("Tagging closest:", target.player.Name, "| Distance:", target.distance)
                tagPlayer(target.player, target.distance)
                task.wait(math.random(0.5, 1.2))
            end
        end
    elseif tagAuraMode == "Multi Target" then
        local maxTags = math.random(2, 4)
        local taggedCount = 0

        for _, target in ipairs(validPlayers) do
            if taggedCount >= maxTags then break end
            if not tagCooldowns[target.player] or currentTime - tagCooldowns[target.player] > 1.5 then
                print("Tagging multi:", target.player.Name, "| Distance:", target.distance)
                tagPlayer(target.player, target.distance)
                taggedCount = taggedCount + 1
                task.wait(math.random(0.6, 1.5))
            end
        end
    end
end
runService.Heartbeat:Connect(onHeartbeat)
-- abcddddddddddddddddddddddddd
local Section = Tab:CreateSection("Players")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Infinite Jump
local infJump
local infJumpDebounce = false

local function setInfJump(enabled)
    if enabled then
        if infJump then infJump:Disconnect() end
        infJump = UserInputService.JumpRequest:Connect(function()
            if not infJumpDebounce then
                infJumpDebounce = true
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                task.wait()
                infJumpDebounce = false
            end
        end)
    else
        if infJump then
            infJump:Disconnect()
            infJump = nil
        end
    end
end

local ToggleInfJump = Tab:CreateToggle({
    Name = "Infjump",
    CurrentValue = false,
    Flag = "Infjump",
    Callback = function(Value)
        setInfJump(Value)
    end
})

-- Noclip
local Noclipping
local Clip = true

local function NoclipLoop()
    if not Clip and character then
        for _, child in pairs(character:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide then
                child.CanCollide = false
            end
        end
    end
end

local ToggleNoclip = Tab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        if Value then
            Clip = false
            task.wait(0.1)
            if not Noclipping then
                Noclipping = RunService.Stepped:Connect(NoclipLoop)
            end
        else
            Clip = true
            if Noclipping then
                Noclipping:Disconnect()
                Noclipping = nil
            end
            -- Set all parts back to CanCollide true
            for _, child in pairs(character:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CanCollide = true
                end
            end
        end
    end
})
local Section = Tab:CreateSection("Section Example")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local espLoops = {}

local function createESP(player, role, color)
    if player == localPlayer then return end -- Hindari ESP pada diri sendiri

    local character = player.Character
    if character and not character:FindFirstChild(role .. "ESP") then
        local head = character:FindFirstChild("Head")
        if head then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = role .. "ESP"
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 1.5, 0)
            billboard.Adornee = head
            billboard.Parent = character
            billboard.AlwaysOnTop = true

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextScaled = true
            nameLabel.Text = player.Name
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.Parent = billboard

            local roleLabel = Instance.new("TextLabel")
            roleLabel.Size = UDim2.new(1, 0, 0.5, 0)
            roleLabel.Position = UDim2.new(0, 0, 0.5, 0)
            roleLabel.BackgroundTransparency = 1
            roleLabel.TextColor3 = color
            roleLabel.TextScaled = true
            roleLabel.Text = role
            roleLabel.Font = Enum.Font.SourceSansBold
            roleLabel.Parent = billboard
        end
    end
end

local function removeESP(player, role)
    if player and player.Character then
        local billboard = player.Character:FindFirstChild(role .. "ESP")
        if billboard then
            billboard:Destroy()
        end
    end
end

local function updateESP(role, color, validRoles)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local roleValue = player:FindFirstChild("PlayerRole")
            if roleValue and table.find(validRoles, roleValue.Value) then
                createESP(player, role, color)
            else
                removeESP(player, role)
            end
        end
    end
end

local ToggleNeutral = Tab:CreateToggle({
   Name = "ESP Neutral Team",
   CurrentValue = false,
   Flag = "EspNeutral", 
   Callback = function(Value)
       if Value then
           espLoops["Neutral"] = RunService.Heartbeat:Connect(function()
               updateESP("Neutral", Color3.fromRGB(255, 255, 0), {"Neutral"})
           end)
           updateESP("Neutral", Color3.fromRGB(255, 255, 0), {"Neutral"})
       else
           if espLoops["Neutral"] then
               espLoops["Neutral"]:Disconnect()
               espLoops["Neutral"] = nil
           end
           for _, player in ipairs(Players:GetPlayers()) do
               removeESP(player, "Neutral")
           end
       end
   end
})

local ToggleCrown = Tab:CreateToggle({
   Name = "Crown ESP",
   CurrentValue = false,
   Flag = "EspCrown", 
   Callback = function(Value)
       if Value then
           espLoops["Crown"] = RunService.Heartbeat:Connect(function()
               updateESP("Crown", Color3.fromRGB(255, 215, 0), {"Crown", "SoloCrown"})
           end)
           updateESP("Crown", Color3.fromRGB(255, 215, 0), {"Crown", "SoloCrown"})
       else
           if espLoops["Crown"] then
               espLoops["Crown"]:Disconnect()
               espLoops["Crown"] = nil
           end
           for _, player in ipairs(Players:GetPlayers()) do
               removeESP(player, "Crown")
           end
       end
   end
})

local ToggleRunner = Tab:CreateToggle({
   Name = "Runner ESP",
   CurrentValue = false,
   Flag = "EspRunner", 
   Callback = function(Value)
       if Value then
           espLoops["Runner"] = RunService.Heartbeat:Connect(function()
               updateESP("Runner", Color3.fromRGB(0, 0, 255), {"Runner", "Runners"})
           end)
           updateESP("Runner", Color3.fromRGB(0, 0, 255), {"Runner", "Runners"})
       else
           if espLoops["Runner"] then
               espLoops["Runner"]:Disconnect()
               espLoops["Runner"] = nil
           end
           for _, player in ipairs(Players:GetPlayers()) do
               removeESP(player, "Runner")
           end
       end
   end
})
