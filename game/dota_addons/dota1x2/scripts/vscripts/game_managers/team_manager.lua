require("utils")

TeamManager = TeamManager or class({})

function TeamManager:constructor()
    ListenToGameEvent("npc_spawned", function(event)
        return self:OnNPCSpawned(event)
    end, nil)

    self.filters = {
        GoldFilter(),
        XpFilter()
    }
end

function TeamManager:OnNPCSpawned(event)
    local unit = EntIndexToHScript(event.entindex)
    if not IsGameEnded() and unit ~= nil and unit:IsHero() and unit:IsRealHero() then
        local tp = unit:FindItemInInventory("item_tpscroll")
        if tp ~= nil then
            UTIL_Remove(tp)
        end

        unit:RemoveModifierByName("modifier_fountain_invulnerability")

        if unit.team_manager == nil then
            unit.team_manager = {}
            self:OnHeroFirstSpawned(unit)
        end
    end
end

function TeamManager:OnHeroFirstSpawned(hero)
    for _ = 1, INITIAL_LEVEL[hero:GetTeamNumber()] - 1 do
        hero:HeroLevelUp(false)
    end
end