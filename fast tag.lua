local ReplicatedStorage = game:GetService("ReplicatedStorage")
if ReplicatedStorage:FindFirstChild("shared") then
    local shared = ReplicatedStorage.shared
    if shared:FindFirstChild("cooldowns") then
        shared.cooldowns:Destroy()
        print("SUCCES")
    end
end
local success, err = pcall(function()
    local Utils = require(game.ReplicatedFirst:FindFirstChild("Utils"))
    if Utils and typeof(Utils.InCooldown) == "function" then
        hookfunction(Utils.InCooldown, function(action)
            return false
        end)
        print("SUCCES")
    end
end)
if not success then
    warn("ERROR")
    return
end
