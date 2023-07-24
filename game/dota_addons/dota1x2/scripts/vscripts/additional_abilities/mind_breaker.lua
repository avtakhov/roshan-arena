LinkLuaModifier("modifier_mind_breaker", "additional_abilities/mind_breaker", 0)
LinkLuaModifier("modifier_mind_breaker_debuff", "additional_abilities/mind_breaker", 0)

mind_breaker = mind_breaker or class({})

function mind_breaker:GetIntrinsicModifierName()
    return "modifier_mind_breaker"
end

modifier_mind_breaker = modifier_mind_breaker or class({})

function modifier_mind_breaker:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_mind_breaker:IsPurgable()
    return false
end

function modifier_mind_breaker:IsDebuff()
    return false
end

function modifier_mind_breaker:IsHidden()
    return self:GetStackCount() == 0
end

function modifier_mind_breaker:OnCreated()
    if not IsServer() then
        return
    end
    self:SetStackCount(0)
end

function modifier_mind_breaker:OnAttackLanded(params)
    local target = params.target
    if params.attacker == self:GetParent() and (target:IsHero() or target:IsCreep())
        and target:GetTeam() ~= params.attacker:GetTeam() then
        self:IncrementStackCount()
        if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("attack_count") then
            self:SetStackCount(0)
            target:AddNewModifier(
                self:GetCaster(),
                self:GetAbility(),
                "modifier_mind_breaker_debuff",
                { duration = self:GetAbility():GetSpecialValueFor("mute_duration") }
            )
        end
    end
end

modifier_mind_breaker_debuff = modifier_mind_breaker_debuff or class({})

function modifier_mind_breaker_debuff:IsPurgable()
    return false
end

function modifier_mind_breaker_debuff:IsDebuff()
    return true
end

function modifier_mind_breaker_debuff:IsHidden()
    return false
end

function modifier_mind_breaker_debuff:CheckState()
    return {
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end

function modifier_mind_breaker_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
    }
end

function modifier_mind_breaker_debuff:GetModifierMoveSpeedOverride()
    return 80
end

function modifier_mind_breaker_debuff:GetEffectName()
    return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf"
end
