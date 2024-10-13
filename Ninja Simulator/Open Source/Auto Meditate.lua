--// Nocturne.lua | Open Source | Ninja Simulator 
--// Go skid now

--// ©️ NOCTURNE
local Nocturne = {}

--// Services

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Vars

local Player = Players.LocalPlayer
local PlayerCharacter = Player.Character or Player.CharacterAdded:Wait()

--// Toggle for the main stuff

Nocturne.AutoMeditate = true --// set to false to NOT run

--// Handler/Checks

local isMeditateEquipped = false
local hasPrintedMessage = false

--// Main Func
function AutoMeditate()
  Nocturne.Remote1 = PlayerCharacter:FindFirstChild("Meditate"):FindFirstChild("LocalScript")
  ReplicatedStorage.Remotes.Metitate:InvokeServer(Nocturne.Remote1)
end

--// this thing basically listens if the plr equipped the tool
PlayerCharacter.ChildAdded:Connect(function(nig)
    if nig:IsA("Tool") and nig.Name == "Meditate" then 
        print("Check: True")
        isMeditateEquipped = true
        hasPrintedMessage = false
    end
end)

--// this thing basically listens if the plr unequipped the tool
PlayerCharacter.ChildRemoved:Connect(function(ger)
    if ger:IsA("Tool") and ger.Name == "Meditate" then
        isMeditateEquipped = false
    end
end)

RunService.RenderStepped:Connect(function() --// Main Handler bby
    if Nocturne.AutoMeditate then
        if isMeditateEquipped then
            AutoMeditate()
        else
            if not hasPrintedMessage then
                print("shit")
                hasPrintedMessage = true
            end
        end
    end
end)
