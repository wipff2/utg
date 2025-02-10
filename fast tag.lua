-- Script Anti Cooldown
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Menonaktifkan cooldown pada `shared.cooldowns`
if ReplicatedStorage:FindFirstChild("shared") then
    local shared = ReplicatedStorage.shared
    if shared:FindFirstChild("cooldowns") then
        shared.cooldowns:Destroy() -- Menghapus objek cooldown jika ditemukan
        print("Cooldown berhasil dihapus!")
    end
end

-- Menonaktifkan fungsi `InCooldown`
local success, err = pcall(function()
    local Utils = require(game.ReplicatedFirst:FindFirstChild("Utils"))
    if Utils and typeof(Utils.InCooldown) == "function" then
        hookfunction(Utils.InCooldown, function(action)
            return false -- Cooldown selalu mati
        end)
        print("Hook fungsi InCooldown berhasil!")
    end
end)

if not success then
    warn("Gagal menghapus cooldown:", err)
end
