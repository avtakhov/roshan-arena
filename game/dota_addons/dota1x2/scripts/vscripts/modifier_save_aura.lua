LinkLuaModifier("modifier_save_aura", "modifier_save_aura.lua", LUA_MODIFIER_MOTION_NONE)

---@type CDOTA_Modifier_Lua
modifier_save_aura = modifier_save_aura or class({})

function modifier_save_aura:IsHidden()
    return false
end

function modifier_save_aura:OnCreated()
    if not IsServer() then
        return
    end
end

function modifier_save_aura:IsDebuff()
    return false
end

function modifier_save_aura:IsPurgable()
    return false
end

function modifier_save_aura:GetTexture()
    return "save_aura"
end
