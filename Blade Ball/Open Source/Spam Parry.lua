--// Nocturne.Lua (Nightly subscript hub)
--// Supposed to be for Alternate but got bored and discontinued the project.
--// For Blade Ball go skid, skid baby

local Nocturne = {}

local debug = true

function Nocturne:Services()
    return {
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        RunService = game:GetService("RunService"),
        Players = game:GetService("Players")
    }
end

Nocturne.Services = Nocturne:Services()
Nocturne.LocalPlayer = Nocturne.Services.Players.LocalPlayer

--// thanks to a guy named hk for this <3

Nocturne.RemoteEventHandler = {
    Event = nil,

    Initialize = function(self)
        for _, NocturneInstance in next, game:GetDescendants() do
            if NocturneInstance:IsA("RemoteEvent") and NocturneInstance.Name:find("\n") then
                self.Event = NocturneInstance
                
                if debug then
                    print("Remote found: " .. NocturneInstance.Name .. " | " .. NocturneInstance.ClassName)
                    debug = false -- ends output once remote found
                end
                
                break
            end
        end
        assert(self.Event, "No RemoteEvent found matching the criteria, yikes.")
    end
}

Nocturne.RemoteEventHandler:Initialize()

Nocturne.SpamRates = 8
Nocturne.Configuration = {
    CFrameOffsets = {},

    GenerateCFrameOffsets = function(self)
        for i = 1, 4 do
            local x = -math.random(200, i == 4 and 600 or 500)
            local y = math.random(0, (i <= 2 and 40 or 80))
            local z = -math.random(70, 120)
            table.insert(self.CFrameOffsets, CFrame.new(x, y, z))
        end
    end
}

Nocturne.Configuration:GenerateCFrameOffsets()


--// thanks to a guy named hk for this again <3
Nocturne.PlayerPositionManager = {
    GetClosestPlayer = function(self)
        local NocturneNearestPlayer, NocturneMinDistance = nil, math.huge

        for _, NocturnePlayer in next, Nocturne.Services.Players:GetPlayers() do
            if NocturnePlayer ~= Nocturne.LocalPlayer and NocturnePlayer.Character and NocturnePlayer.Character:IsDescendantOf(Nocturne.Services.Players) then
                local NocturneHumanoid = NocturnePlayer.Character:FindFirstChildOfClass("Humanoid")
                if NocturneHumanoid and NocturneHumanoid.Health > 0 then
                    local NocturnePrimaryPart = NocturnePlayer.Character.PrimaryPart
                    if NocturnePrimaryPart then
                        local NocturneDistance = Nocturne.LocalPlayer:DistanceFromCharacter(NocturnePrimaryPart.Position)
                        if NocturneDistance < NocturneMinDistance then
                            NocturneMinDistance = NocturneDistance
                            NocturneNearestPlayer = NocturnePlayer
                        end
                    end
                end
            end
        end

        return NocturneNearestPlayer
    end,

    GetAllPlayerPositions = function(self)
        local NocturnePositions = {}

        for _, NocturnePlayer in next, Nocturne.Services.Players:GetPlayers() do
            if NocturnePlayer.Character and NocturnePlayer.Character:IsDescendantOf(Nocturne.Services.Players) then
                local NocturnePrimaryPart = NocturnePlayer.Character.PrimaryPart
                if NocturnePrimaryPart then
                    NocturnePositions[NocturnePlayer.Name] = NocturnePrimaryPart.Position + Vector3.new(10, 10, 10)
                end
            end
        end

        return NocturnePositions
    end
}

Nocturne.Randomizer = {
    GetRandomCFrame = function(self)
        return Nocturne.Configuration.CFrameOffsets[math.random(1, #Nocturne.Configuration.CFrameOffsets)]
    end
}

Nocturne.DelayManager = {
    DelayTime = 0.05,
    IsDelayActive = false,

    StartDelay = function(self, NocturneCallback)
        if not self.IsDelayActive then
            self.IsDelayActive = true
            delay(self.DelayTime, function()
                self.IsDelayActive = false
                if NocturneCallback then NocturneCallback() end
            end)
        end
    end
}

Nocturne.RemoteCasesManager = {
    Generate = function(self)
        return {
            Delay = 0.5,
            CFrame = Nocturne.Randomizer:GetRandomCFrame(),
            PlayerPositions = self:GetPlayerPositions(),
            RandomParams = {math.random(200, 500), math.random(100, 200)},
            BooleanFlag = false
        }
    end,

    GetPlayerPositions = function(self)
        local NocturneTargetPlayer = Nocturne.PlayerPositionManager:GetClosestPlayer()
        return NocturneTargetPlayer and {[NocturneTargetPlayer.Name] = NocturneTargetPlayer.Character.PrimaryPart.Position} or Nocturne.PlayerPositionManager:GetAllPlayerPositions()
    end
}

Nocturne.EventManager = {
    TriggerRemote = function(self)
        if Nocturne.DelayManager.IsDelayActive then return end
        Nocturne.DelayManager:StartDelay(function()
            for _ = 1, Nocturne.SpamRates do
                local NocturneRemoteCases = Nocturne.RemoteCasesManager:Generate()
                local success, errorMessage = pcall(function()
                    Nocturne.RemoteEventHandler.Event:FireServer(
                        NocturneRemoteCases.Delay,
                        NocturneRemoteCases.CFrame,
                        NocturneRemoteCases.PlayerPositions,
                        NocturneRemoteCases.RandomParams,
                        NocturneRemoteCases.BooleanFlag
                    )
                end)

                if not success then
                    warn("Failed to fire remote: " .. errorMessage)
                end
            end
        end)
    end
}

Nocturne.Services.RunService.Heartbeat:Connect(function()
    Nocturne.EventManager:TriggerRemote()
end)
