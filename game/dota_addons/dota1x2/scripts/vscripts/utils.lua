function AnyAliveInTeam(team)
    for i = 1, PlayerResource:GetPlayerCountForTeam(team) do
        local player_id = PlayerResource:GetNthPlayerIDOnTeam(team, i)
        local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
        if hero:IsAlive() then
            return true
        end
    end

    return false
end

function SpawnItem(point, item_name)
    CreateItemOnPositionForLaunch(point, CreateItem(item_name, nil, nil))
end

function IsGameEnded()
    return GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME
end

function GetRandomElements(t, nCount)
    local shuffledCopy = ShuffledList(t)
    for _ = nCount + 1, #t do
        table.remove(shuffledCopy)
    end
    return shuffledCopy
end

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else
        -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function ShuffledList(orig_list)
    local list = shallowcopy(orig_list)
    ShuffleListInPlace(list)
    return list
end

function ShuffleListInPlace(list, hRandomStream)
    for i = 1, #list - 1 do
        local j
        if hRandomStream == nil then
            j = RandomInt(i, #list)
        else
            j = hRandomStream:RandomInt(i, #list)
        end
        list[i], list[j] = list[j], list[i]
    end
end
