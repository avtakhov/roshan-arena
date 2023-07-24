LinkLuaModifier("modifier_multicast", "additional_abilities/multicast", LUA_MODIFIER_MOTION_NONE)

multicast = multicast or {}

function multicast:GetIntrinsicModifierName()
    return "modifier_multicast"
end

modifier_multicast = modifier_multicast or {}

function modifier_multicast:IsHidden()
    return true
end

function modifier_multicast:IsDebuff()
    return false
end

function modifier_multicast:IsPurgable()
    return false
end

function modifier_multicast:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ABILITY_FULLY_CAST }
end

function modifier_multicast:OnAbilityFullyCast(parameters)
    if parameters.unit ~= self:GetCaster() or parameters.ability == self:GetAbility()
        or self:GetCaster():PassivesDisabled() or parameters.ability:IsItem() or parameters.ability:IsHidden() then
        return
    end

    local behavior = parameters.ability:GetBehavior()
    local forbidden = DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING
    if bit.band(behavior, forbidden) ~= 0 then
        return
    end

    local multicast_4_times = self:GetAbility():GetSpecialValueFor("multicast_4_times")
    local multicast_3_times = self:GetAbility():GetSpecialValueFor("multicast_3_times")
    local multicast_2_times = self:GetAbility():GetSpecialValueFor("multicast_2_times")

    local random = RandomFloat(0, 100)
    local multicast_n_times
    if random < multicast_4_times then
        multicast_n_times = 4
    elseif random < multicast_3_times then
        multicast_n_times = 3
    elseif random < multicast_2_times then
        multicast_n_times = 2
    else
        return
    end

    MulticastThink(
        parameters.unit,
        parameters.ability,
        parameters.ability:GetCursorPosition(),
        parameters.target,
        multicast_n_times,
        self:GetAbility():GetSpecialValueFor("delay")
    )
end

MulticastThink = MulticastThink or class({})

function MulticastThink:constructor(caster, ability, position, target, multicast_n_times, delay)
    self.caster = caster
    self.ability = ability
    self.position = position
    self.target = target
    self.multicast_n_times = multicast_n_times
    self.delay = delay
    self.used_times = 1

    GameRules:GetGameModeEntity():SetThink(
        function()
            return self:OnThink()
        end,
        nil,
        caster:entindex() .. "$" .. ability:GetAbilityName(), -- interrupt current multicast of the same ability from the same hero
        delay
    )
end

function MulticastThink:OnThink()
    self.caster:SetCursorPosition(self.position)
    self.caster:SetCursorCastTarget(self.target)
    self.ability:OnSpellStart()
    self.used_times = self.used_times + 1
    local pfx = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf",
        PATTACH_OVERHEAD_FOLLOW,
        self.caster
    )
    ParticleManager:SetParticleControl(pfx, 1, Vector(self.used_times, 1, 0))

    if self.used_times < self.multicast_n_times then
        return self.delay
    else
        return nil
    end
end
