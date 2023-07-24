require("hero_features/base_feature")
require("utils")

Nevermore = Nevermore or class({}, {}, BaseFeature)

function Nevermore:constructor()
    BaseFeature.constructor(self)
    self.interval = 5
end

function Nevermore:GetHeroName()
    return "npc_dota_hero_nevermore"
end

function Nevermore:OnHeroFirstSpawned(hero)
    GameRules:GetGameModeEntity():SetThink(
        function()
            return self:OnThink(hero)
        end,
        nil,
        self:GetHeroName(),
        self.interval
    )
end

function Nevermore:OnThink(hero)
    if IsGameEnded() then
        return nil
    end

    if not hero:IsAlive() then
        return self.interval
    end

    local modifier = hero:FindModifierByName("modifier_nevermore_necromastery")

    if modifier == nil then
        return self.interval
    end

    local max_souls

    if modifier:GetParent():HasScepter() then
        max_souls = modifier:GetAbility():GetSpecialValueFor("necromastery_max_souls_scepter")
    else
        max_souls = modifier:GetAbility():GetSpecialValueFor("necromastery_max_souls")
    end

    modifier:SetStackCount(math.min(max_souls, 1 + modifier:GetStackCount()))

    return self.interval
end
