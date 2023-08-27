roshan_gift = {}

ITEMS_DROP = {
    "item_cheese",
    "item_ultimate_scepter_roshan",
    "item_aegis",
    "item_refresher_shard"
}

function roshan_gift:OnUpgrade()
    local item_name = ITEMS_DROP[RandomInt(1, #ITEMS_DROP)]
    self:GetCaster():AddItemByName(item_name)
end
