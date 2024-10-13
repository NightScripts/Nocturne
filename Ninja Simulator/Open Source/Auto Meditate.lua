--// Nocturne.lua | Open Source | Ninja Simulator 
--// Go skid now

--// ©️ NOCTURNE
local Nocturne = {}
local ch = "true" --// does all the work, rel

--// Services

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Vars

local Player = Players.LocalPlayer
local PlayerCharacter = Player.Characted or Player.CharacterAdded:Wait()

--// Toggle for the main stuff

Nocturne.AutoMeditate = true --// set to false to NOT run

--// Main Func
function AutoMeditate()
  Nocturne.RemoteMed = PlayerCharacter:FindFirstChild("Meditate"):FindFirstChild("LocalScript")
  ReplicatedStorage.Remotes.Metitate:InvokeServer(Nocturne.RemoteMed)
end

--// Handler/Checks

local MeditateEquipped = false
local Printed = false

PlayerCharacter.ChildAdded:Connect(function(shit) --// this thing basically listens if the plr equipped the tool
    if shit:IsA("Tool") and shit.Name == "Meditate" then
      print("Check: True | EQUIPPED")
      MeditatedEquipped = true
      Printed = false
    end
end)

PlayerCharacter.ChildRemoved:Connect(function(ass) --// this thing basically listens if the plr unequipped the tool
    if ass:IsA("Tool") and ass.Name == "Meditate" then
        MeditateEquipped = false
    end
end)

RunService.RenderStepped:Connect(function() --// the end woooooooooooooowowowowowow
    if Nocturne.AutoMeditate then
        if MeditateEquipped then
            AutoMeditate()
        else
            if not Printed then
                print(ch)
                Printed = true
            end
        end
    end
end)
