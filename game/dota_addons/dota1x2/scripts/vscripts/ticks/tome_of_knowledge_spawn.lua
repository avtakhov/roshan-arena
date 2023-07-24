require("game_settings")
require("ticks/base_tick")
require("utils")

TomeOfKnowledgeSpawnTick = TomeOfKnowledgeSpawnTick or class({}, {}, BaseTick)

function TomeOfKnowledgeSpawnTick:constructor()
    BaseTick.constructor(self, 120, 60)
    ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(TomeOfKnowledgeSpawnTick, "OnItemPickedUp"), self)
end

function TomeOfKnowledgeSpawnTick:GetName()
    return "TomeOfKnowledgeSpawnTick"
end

function TomeOfKnowledgeSpawnTick:OnTick()
    for _, pt in ipairs(TOME_OF_KNOWLEDGE_SPAWNER_POINTS) do
        GameRules:ExecuteTeamPing(DOTA_TEAM_GOODGUYS, pt.x, pt.y, nil, 0)
        GameRules:ExecuteTeamPing(DOTA_TEAM_BADGUYS, pt.x, pt.y, nil, 0)
        SpawnItem(pt + RandomVector(RandomFloat(0, ITEM_DROP_DISPERSION)), "item_custom_tome_xp")
    end
end

function TomeOfKnowledgeSpawnTick:OnItemPickedUp(event)
    if event.itemname ~= "item_custom_tome_xp" then
        return
    end

    local owner = EntIndexToHScript(event.HeroEntityIndex)
    owner:AddExperience(TOME_OF_KNOWLEDGE_XP_AMOUNT, DOTA_ModifyXP_Unspecified, false, false)
    UTIL_Remove(EntIndexToHScript(event.ItemEntityIndex))
end