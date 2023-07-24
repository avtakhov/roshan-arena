LinkLuaModifier("modifier_gold_tick", "additional_abilities/gold_tick", LUA_MODIFIER_MOTION_NONE)

gold_tick = {}

function gold_tick:OnCreated()
end

function gold_tick:GetIntrinsicModifierName()
    return "modifier_gold_tick"
end

modifier_gold_tick = {}

function modifier_gold_tick:IsHidden()
    return false
end

function modifier_gold_tick:IsPurgable()
    return false
end

function modifier_gold_tick:OnCreated(_)
    if not IsServer() then
        return
    end

    self:StartIntervalThink(1.)
end

function modifier_gold_tick:OnIntervalThink()
    PlayerResource:ModifyGold(
        self:GetCaster():GetPlayerOwnerID(),
        self:GetAbility():GetSpecialValueFor("gold_per_second"),
        true,
        DOTA_ModifyGold_GameTick
    )

end