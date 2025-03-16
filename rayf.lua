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
local tagAura = false
local tagAuraMode = "Closest"
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
   CurrentValue = true,
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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local tagPlayerEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("game"):WaitForChild("tags"):WaitForChild("TagPlayer")

local lastTagTime = {}
local tagAuraRange = 10 -- Bisa diubah sesuai kebutuhan

local function randomTagDelay()
    return math.random(120, 350) / 100 + math.random() / 2 -- Delay antara 1.2 dan 3.7 detik dengan tambahan acak
end

local function isValidTarget(player)
    if not player or player == localPlayer then return false end

    local character = player.Character
    if not character then return false end

    local humanoid = character:FindFirstChild("Humanoid")
    local targetHRP = character:FindFirstChild("HumanoidRootPart")

    if humanoid and humanoid.Health > 0 and targetHRP then
        return true
    end
    return false
end

local function tagPlayer(player)
    if not isValidTarget(player) then return end

    local currentTime = os.clock()
    if lastTagTime[player] and currentTime - lastTagTime[player] < (1.2 + math.random() * 0.8) then return end -- Cooldown dengan sedikit randomisasi

    local localCharacter = localPlayer.Character
    if not localCharacter then return end

    local localHRP = localCharacter:FindFirstChild("HumanoidRootPart")
    local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")

    if not localHRP or not targetHRP then return end

    local distance = (localHRP.Position - targetHRP.Position).Magnitude
    if distance <= 2 or distance > tagAuraRange then return end -- Batasi jarak tagging

    task.defer(function()
        task.wait(randomTagDelay())

        if math.random(1, 5) <= 2 then return end -- Random skip untuk menghindari pola tagging

        local success, response = pcall(function()
            return tagPlayerEvent:InvokeServer(
                player.Character:FindFirstChild("Humanoid"),
                targetHRP.Position + Vector3.new(math.random(-3, 3), math.random(-1.5, 1.5), math.random(-3, 3)) -- Lebih banyak jitter posisi tagging
            )
        end)

        if success and response then
            if math.random(1, 6) == 1 then -- Random log untuk menghindari pola
                print("[INFO]", string.char(math.random(65, 90)) .. " Target @" .. os.time())
            end
            lastTagTime[player] = os.clock()
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if math.random(1, 4) == 1 then return end -- Random skip tambahan

    local shuffledPlayers = Players:GetPlayers()
    for i = #shuffledPlayers, 2, -1 do
        local j = math.random(1, i)
        shuffledPlayers[i], shuffledPlayers[j] = shuffledPlayers[j], shuffledPlayers[i] -- Shuffle daftar pemain untuk menghindari urutan tetap
    end

    for _, player in ipairs(shuffledPlayers) do
        tagPlayer(player)
    end
end)

print("System Ready:", math.random(1000, 9999)) -- Random output untuk menyamarkan pola
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
    Name = "Noclip(risk)",
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
