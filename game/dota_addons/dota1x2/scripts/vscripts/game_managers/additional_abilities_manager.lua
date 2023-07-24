require("utils")

AdditionalAbilitiesManager = AdditionalAbilitiesManager or class({})

ABILITIES = {
    "mind_breaker",
    "multicast",
    "shadow_dance",
    "gold_tick",
    "roshan_gift",
    "wukongs_command",
}

function AdditionalAbilitiesManager:constructor()
    self.player_abilities = {}
    CustomGameEventManager:RegisterListener(
        "ability_chosen",
        function(_, event)
            self:OnAbilityChosen(event)
        end
    )

    CustomGameEventManager:RegisterListener(
        "player_loaded",
        function(_, event)
            self:OnPlayerLoaded(event)
        end
    )
end

function AdditionalAbilitiesManager:GetAvailableAbilities()
    return GetRandomElements(ABILITIES, 2)
end

function AdditionalAbilitiesManager:OnAbilityChosen(event)
    local unit = PlayerResource:GetPlayer(event.player_id):GetAssignedHero()
    local ability_name = self.player_abilities[event.player_id][tonumber(event.ability_id)]
    local ability = unit:AddAbility(ability_name)
    if ability ~= nil then
        ability:SetLevel(ability:GetMaxLevel())
        self.player_abilities[event.player_id] = nil
    end
end

function AdditionalAbilitiesManager:OnPlayerLoaded(event)
    self.player_abilities[event.player_id] = GetRandomElements(ABILITIES, 2)
    CustomGameEventManager:Send_ServerToPlayer(
        PlayerResource:GetPlayer(event.player_id),
        "additional_abilities",
        self.player_abilities[event.player_id]
    )
end