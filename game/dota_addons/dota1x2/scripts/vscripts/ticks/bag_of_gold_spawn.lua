require("game_settings")
require("ticks/base_tick")
require("utils")

BagOfGoldSpawnTick = BagOfGoldSpawnTick or class({}, {}, BaseTick)

function BagOfGoldSpawnTick:constructor()
    BaseTick.constructor(self, 60, 0)
    ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(BagOfGoldSpawnTick, "OnItemPickedUp"), self)
end

function BagOfGoldSpawnTick:GetName()
    return "BagOfGoldSpawnTick"
end

function BagOfGoldSpawnTick:OnTick()
    for _, pt in ipairs(GOLD_OF_BAG_SPAWNER_POINTS) do
        SpawnItem(pt + RandomVector(RandomFloat(0, ITEM_DROP_DISPERSION)), "item_bag_of_gold")
    end
end

function BagOfGoldSpawnTick:OnItemPickedUp(event)
    if event.itemname ~= "item_bag_of_gold" then
        return
    end

    local item = EntIndexToHScript(event.ItemEntityIndex)
    local owner = EntIndexToHScript(event.HeroEntityIndex)

    PlayerResource:ModifyGold(owner:GetPlayerID(), GOLD_BAG_AMOUNT, true, DOTA_ModifyGold_Unspecified)
    SendOverheadEventMessage(owner, OVERHEAD_ALERT_GOLD, owner, GOLD_BAG_AMOUNT, nil)
    UTIL_Remove(item)
end