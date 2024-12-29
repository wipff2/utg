local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "utg", HidePremium = false, SaveConfig = true, ConfigFolder = "Orion_utg", IntroText = "2utg"})
OrionLib:MakeNotification({
	Name = "Welcome",
	Content = "new untittled tag game sc",
	Image = "rbxassetid://4483345998",
	Time = 5
})
local Tab = Window:MakeTab({
	Name = "Tab 1",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "player"
})
Tab:AddButton({
	Name = "infjump",
	Callback = function()
      		print("button pressed")
  	end    
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local isActive = false -- Status toggle
local toggleConnection

Tab:AddToggle({
	Name = "Click & Move",
	Default = false,
	Callback = function(Value)
		isActive = Value

		if isActive then
			local startTime = tick()
			toggleConnection = game:GetService("RunService").Heartbeat:Connect(function()
				if tick() - startTime >= 16 then
					-- Hentikan setelah 16 detik
					isActive = false
					if toggleConnection then
						toggleConnection:Disconnect()
						toggleConnection = nil
					end
					humanoid:Move(Vector3.new(0, 0, 0), true)
					return
				end

				-- Klik kiri pada layar dua kali
				VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, nil, 0) -- Klik kiri turun
				VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, nil, 0) -- Lepas klik kiri
				wait(0.1) -- jeda antara klik
				VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, nil, 0) -- Klik kiri turun
				VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, nil, 0) -- Lepas klik kiri

				-- Jalan maju
				humanoid:Move(Vector3.new(0, 0, -1), true)
				wait(1) -- waktu berjalan maju

				-- Jalan mundur
				humanoid:Move(Vector3.new(0, 0, 1), true)
				wait(1) -- waktu berjalan mundur
			end)
		else
			-- Nonaktifkan jika toggle dimatikan
			if toggleConnection then
				toggleConnection:Disconnect()
				toggleConnection = nil
			end
			humanoid:Move(Vector3.new(0, 0, 0), true)
		end
	end
})


OrionLib:Init()