--// Nocturne.Lua (Nightly subscript hub)
--// Supposed to be for Alternate but got bored and discontinued the project.
--// For Blade Ball go skid, skid baby
--// This probably doesnt work anymore, but maybe you can modify it :P
--// I ain't sharing the real anti curve shi, but here's the first version of what we made.

local Nocturne = {}

local Debug = true

function Nocturne:Services()
    return {
        NocturneRunService = game:GetService("RunService"),
        NocturneWorkspace = game:GetService("Workspace")
    }
end

Nocturne.Services = Nocturne:Services()

Nocturne.NocturneBalls = {}
Nocturne.NocturneBalls.__index = Nocturne.NocturneBalls

function Nocturne.NocturneBalls.new(NocturneBall)
    local NocturneSelf = setmetatable({}, Nocturne.NocturneBalls)
    NocturneSelf.NocturneBall = NocturneBall
    NocturneSelf.NocturnePreviousPosition = NocturneBall.Position
    NocturneSelf.NocturneHeartbeatConnection = Nocturne.Services.NocturneRunService.Heartbeat:Connect(function()
        NocturneSelf:MaintainVelocity()
    end)

    return NocturneSelf
end

function Nocturne.NocturneBalls:MaintainVelocity()
    local NocturneCurrentPosition = self.NocturneBall.Position
    local NocturneVelocity = self.NocturneBall.Velocity

    if (NocturneCurrentPosition - self.NocturnePreviousPosition).Magnitude > 0.1 and NocturneVelocity.Magnitude > 0 then
        self.NocturneBall.Velocity = (NocturneCurrentPosition - self.NocturnePreviousPosition).Unit * NocturneVelocity.Magnitude
    end

    self.NocturnePreviousPosition = NocturneCurrentPosition
end

function Nocturne.NocturneBalls:Destroy()
    if self.NocturneHeartbeatConnection then
        self.NocturneHeartbeatConnection:Disconnect()
        self.NocturneHeartbeatConnection = nil
    end
end

--// This is for real useless but don't remove
function Nocturne:UselessShit()
    return "Nocturne"
end

function Nocturne:InitializeUselessThing()
    local uselessthing = self:UselessShit()
    assert(uselessthing == "Nocturne", "Hi, I have Alzheimer and I have no idea what the fuck is this shit")
end

Nocturne.HKBalls = {}
Nocturne.HKBalls.__index = Nocturne.HKBalls

--// Thanks bb HK 😘
function Nocturne.HKBalls.new()
    local NocturneSelf = setmetatable({}, Nocturne.HKBalls)
    NocturneSelf.NocturneBallManagers = {}

    Nocturne.Services.NocturneWorkspace.Balls.ChildAdded:Connect(function(NocturneBall)
        NocturneSelf:OnBallAdded(NocturneBall)
    end)

    NocturneSelf:InitializeExistingBalls()

    Nocturne:InitializeUselessThing()

    return NocturneSelf
end

function Nocturne.HKBalls:OnBallAdded(NocturneBall)
    if NocturneBall:IsA("BasePart") and NocturneBall.Name == "Ball" then
        local NocturneBallManager = Nocturne.NocturneBalls.new(NocturneBall)
        self.NocturneBallManagers[NocturneBall] = NocturneBallManager

        NocturneBall.Destroyed:Connect(function()
            NocturneBallManager:Destroy()
            self.NocturneBallManagers[NocturneBall] = nil
        end)

        if Debug then
            print("Ball added: " .. NocturneBall.Name) -- doesn't work probably 
        end
    end
end

function Nocturne.HKBalls:InitializeExistingBalls()
    local NocturneBallsFolder = Nocturne.Services.NocturneWorkspace:WaitForChild("Balls")
    for _, NocturneBall in ipairs(NocturneBallsFolder:GetChildren()) do
        self:OnBallAdded(NocturneBall)
    end
end

Nocturne.HKBallsInstance = Nocturne.HKBalls.new()

Nocturne.Services.NocturneRunService.Heartbeat:Connect(function()
    for _, NocturneBallManager in pairs(Nocturne.HKBallsInstance.NocturneBallManagers) do
        NocturneBallManager:MaintainVelocity()
    end
end)
