LinkLuaModifier("modifier_shadow_dance", "additional_abilities/shadow_dance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shadow_dance_buff", "additional_abilities/shadow_dance", LUA_MODIFIER_MOTION_NONE)

shadow_dance = {}

function shadow_dance:GetIntrinsicModifierName()
    return "modifier_shadow_dance"
end

SHADOW_DANCE_STATE_OK = 0
SHADOW_DANCE_STATE_NEUTRAL_DISABLE = 1

modifier_shadow_dance = modifier_shadow_dance or class({})

function modifier_shadow_dance:IsHidden()
    return true
end

function modifier_shadow_dance:IsPurgable()
    return false
end

function modifier_shadow_dance:OnCreated(_)
    if not IsServer() then
        return
    end

    self.state = SHADOW_DANCE_STATE_OK
    self.activation_delay = self:GetAbility():GetSpecialValueFor("activation_delay")

    GameRules:GetGameModeEntity():SetThink(
        "OnThink",
        self,
        self:GetCaster():GetUnitName() .. "$" .. self:GetName(),
        0
    )
end

function modifier_shadow_dance:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_shadow_dance:OnTakeDamage(params)
    if params.unit ~= self:GetAbility():GetCaster() then
        return
    end

    if params.attacker:IsNeutralUnitType() or params.attacker:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
        self.state = SHADOW_DANCE_STATE_NEUTRAL_DISABLE
        params.unit:RemoveModifierByName("modifier_shadow_dance_buff")
        GameRules:GetGameModeEntity():SetThink(function()
            self.state = SHADOW_DANCE_STATE_OK
        end, nil, 2.0)
    end
end

function modifier_shadow_dance:OnThink()
    local unit = self:GetCaster()
    if unit:CanBeSeenByAnyOpposingTeam() then
        unit:RemoveModifierByName("modifier_shadow_dance_buff")
    elseif self.state == SHADOW_DANCE_STATE_OK then
        unit:AddNewModifier(
            unit,
            self:GetAbility(),
            "modifier_shadow_dance_buff",
            { duration = -1 }
        )
    end

    return self.activation_delay
end

modifier_shadow_dance_buff = modifier_shadow_dance_buff or {}

function modifier_shadow_dance_buff:IsHidden()
    return false
end

function modifier_shadow_dance_buff:IsPurgable()
    return false
end

function modifier_shadow_dance_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_shadow_dance_buff:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("bonus_regen")
end

function modifier_shadow_dance_buff:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end
