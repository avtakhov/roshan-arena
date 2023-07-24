roshan_accumulate_damage = {}

LinkLuaModifier("modifier_roshan_accumulate_damage", "roshan/ability_roshan_accumulate_damage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_accumulate_damage_debuff", "roshan/ability_roshan_accumulate_damage", LUA_MODIFIER_MOTION_NONE)

function roshan_accumulate_damage:GetIntrinsicModifierName()
    return "modifier_roshan_accumulate_damage"
end

---@type CDOTA_Modifier_Lua
modifier_roshan_accumulate_damage = {}

function modifier_roshan_accumulate_damage:IsHidden()
    return true
end

function modifier_roshan_accumulate_damage:IsDebuff()
    return false
end

function modifier_roshan_accumulate_damage:IsPurgable()
    return false
end

function modifier_roshan_accumulate_damage:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
    }
end

function modifier_roshan_accumulate_damage:GetModifierProcAttack_BonusDamage_Physical(params)
    if IsServer() then
        local target = params.target
        local modifier = target:FindModifierByName("modifier_roshan_accumulate_damage_debuff")
        if modifier == nil then
            modifier = target:AddNewModifier(
                self:GetAbility():GetCaster(),
                nil,
                "modifier_roshan_accumulate_damage_debuff",
                { duration = -1 }
            )
        end

        modifier:IncrementStackCount()

        return (modifier:GetStackCount() - 1) * self:GetAbility():GetSpecialValueFor("damage_per_stack")
    end
end

---@type CDOTA_Modifier_Lua
modifier_roshan_accumulate_damage_debuff = modifier_roshan_accumulate_damage_debuff or class({})

function modifier_roshan_accumulate_damage_debuff:IsHidden()
    return self:GetStackCount() == 0
end

function modifier_roshan_accumulate_damage_debuff:OnCreated()
    if not IsServer() then
        return
    end
    self:SetStackCount(0)
end

function modifier_roshan_accumulate_damage_debuff:IsDebuff()
    return true
end

function modifier_roshan_accumulate_damage_debuff:GetTexture()
    return "roshan_accumulate_damage"
end
