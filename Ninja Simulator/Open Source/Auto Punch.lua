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

Nocturne.PunchingBag = "Godly Punching Bag" --// {Options: Godly Punching Bag, Hidden Punching Dummy, Punching Bag, Punching Dummy}
Nocturne.AutoPunch = true --// set to false to NOT run

--// Main func
function AutoPunch()
  Nocturne.Remote2 = {
    [1] = Workspace:FindFirstChild(Nocturne.PunchingBag).Humanoid,
    [2] = "punch"
  }
  
  ReplicatedStorage.Remotes.Damage:InvokeServer(unpack(Nocturne.Remote2))
end

RunService.RenderStepped:Connect(function() --// Auto Punch
  if Nocturne.AutoPunch then
    AutoPunch()
  end
end)
