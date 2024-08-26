local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local WeaponUnequipTime = 0.6 -- Adjustable delay

local function GetFrontPlayer()
    local frontRay = Ray.new(HumanoidRootPart.Position, HumanoidRootPart.CFrame.LookVector * 10)
    local hit, pos = workspace:FindPartOnRay(frontRay, Character)
    
    if hit and hit.Parent:FindFirstChild("Humanoid") then
        return hit.Parent
    end
    return nil
end

local function HandleParry()
    local equippedWeapon = Character:FindFirstChildWhichIsA("Tool")
    if equippedWeapon then
        local weaponName = equippedWeapon.Name
        equippedWeapon.Parent = LocalPlayer.Backpack
        
        task.wait(WeaponUnequipTime)
        
        local weaponToEquip = LocalPlayer.Backpack:FindFirstChild(weaponName)
        if weaponToEquip then
            weaponToEquip.Parent = Character
        end
    end
end

local function CheckParry()
    local frontPlayer = GetFrontPlayer()
    if frontPlayer then
        local playerModel = workspace.PlayerCharacters:FindFirstChild(frontPlayer.Name)
        if playerModel and playerModel:FindFirstChild("Default") then
            local defaultModel = playerModel.Default
            if defaultModel:GetAttribute("Toggle") then
                HandleParry()
            end
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(CheckParry)