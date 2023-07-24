roshan_penalty = class({})

function roshan_penalty:OnSpellStart()
    if not IsServer() then
        return
    end
    local stack_number = self:GetSpecialValueFor("stack_number")
    for i = 1, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) do
        local player_id = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
        local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()

        local pos = hero:GetAbsOrigin()
        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
        ParticleManager:SetParticleControl(fx, 0, Vector(pos.x, pos.y, pos.z + hero:GetBoundingMaxs().z))
        ParticleManager:SetParticleControl(fx, 1, Vector(pos.x, pos.y, 2000))
        ParticleManager:SetParticleControl(fx, 2, Vector(pos.x, pos.y, pos.z + hero:GetBoundingMaxs().z))

        EmitGlobalSound("Hero_Zuus.GodsWrath")

        hero:AddNewModifier(
            self:GetCaster(),
            nil,
            "modifier_roshan_accumulate_damage_debuff",
            { duration = -1 }
        )   :SetStackCount(stack_number)

    end
end
