require("errors")
require("utils")

BaseTick = BaseTick or class({})

STOP_REPEATING = 0

function BaseTick:constructor(interval, delay)
    self.interval = interval
    self.delay = delay
end

function BaseTick:OnThink()
    if IsGameEnded() or self:OnTick() == STOP_REPEATING then
        return nil
    end

    return self.interval
end

function BaseTick:GetName()
    error(Unimplemented("BaseTick", "GetName"))
end

function BaseTick:OnTick()
    error(Unimplemented("BaseTick", "OnTick"))
end

function BaseTick:Start()
    GameRules:GetGameModeEntity():SetThink(
            function()
                return self:OnThink()
            end,
            nil,
            self:GetName(),
            self.delay
    )
end