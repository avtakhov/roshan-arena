LinkLuaModifier("modifier_wukongs_command", "additional_abilities/wukongs_command", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wukongs_command_solider", "additional_abilities/wukongs_command", LUA_MODIFIER_MOTION_NONE)

wukongs_command = wukongs_command or class({})

function wukongs_command:GetIntrinsicModifierName()
    return "modifier_wukongs_command"
end

modifier_wukongs_command = modifier_wukongs_command or class({})

function modifier_wukongs_command:IsHidden()
    return true
end

function modifier_wukongs_command:IsPurgable()
    return false
end

function modifier_wukongs_command:OnCreated()
    if not IsServer() then
        return
    end

    self:StartIntervalThink(6.)
end

function modifier_wukongs_command:OnIntervalThink()
    local unit = self:GetCaster()
    CreateUnitByNameAsync(
        unit:GetUnitName(),
        unit:GetAbsOrigin() + RandomVector(100),
        true,
        nil,
        unit,
        unit:GetTeamNumber(),
        function(new_unit)
            self:OnUnitCreated(unit, new_unit)
        end
    )
end

function modifier_wukongs_command:OnUnitCreated(unit, new_unit)
    new_unit:AddNewModifier(new_unit, nil, "modifier_wukongs_command_solider", { duration = 12. })

    USEFUL_SLOTS = {
        DOTA_ITEM_SLOT_1,
        DOTA_ITEM_SLOT_2,
        DOTA_ITEM_SLOT_3,
        DOTA_ITEM_SLOT_4,
        DOTA_ITEM_SLOT_5,
        DOTA_ITEM_SLOT_6,
        DOTA_ITEM_NEUTRAL_SLOT
    }

    for _, slot in ipairs(USEFUL_SLOTS) do
        local item = unit:GetItemInSlot(slot)
        if item ~= nil then
            new_unit:AddItemByName(item:GetName())
        end
    end

    while new_unit:GetLevel() < unit:GetLevel() do
        new_unit:HeroLevelUp(false)
    end

    new_unit:MoveToPositionAggressive(unit:GetAbsOrigin())
end

modifier_wukongs_command_solider = class({})

function modifier_wukongs_command_solider:IsPurgable()
    return false
end

function modifier_wukongs_command_solider:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
    }
end

function modifier_wukongs_command_solider:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_FINISHED,
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE
    }
end

function modifier_wukongs_command_solider:GetModifierMoveSpeedOverride()
    return 140
end

function modifier_wukongs_command_solider:OnAttackFinished(event)
    if event.attacker == self:GetParent() then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_disarmed", { duration = 1.2 })
    end
end

function modifier_wukongs_command_solider:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveSelf()
    end
end
