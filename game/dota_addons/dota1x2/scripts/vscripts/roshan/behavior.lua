require("game_settings")
require("utils")

NEUTRAL_STATE_ON_SPAWN = 0
NEUTRAL_STATE_ATTACK = 1

function Spawn(_)
    if not IsServer() then
        return
    end

    thisEntity.spawned_at = thisEntity:GetAbsOrigin()
    thisEntity.state = NEUTRAL_STATE_ON_SPAWN
    thisEntity:SetContextThink("NeutralThink", NeutralThink, 0.)
    ListenToGameEvent("entity_killed", OnEntityKilled, nil)
end

function NeutralThink()
    if GameRules:IsGamePaused() or thisEntity:IsChanneling() or not thisEntity:IsAlive() or thisEntity:IsPlayerController() then
        return 1
    end

    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        GoHome()
        return 1
    end

    local enemies = FindUnitsInRadius(
        thisEntity:GetTeamNumber(),
        thisEntity:GetAbsOrigin(), --местоположение юнита
        nil,
        FIND_UNITS_EVERYWHERE, --радиус поиска
        DOTA_UNIT_TARGET_TEAM_ENEMY, -- юнитов чьей команды ищем вражеской/дружественной
        DOTA_UNIT_TARGET_ALL, --юнитов какого типа ищем
        DOTA_UNIT_TARGET_FLAG_NONE, --поиск по флагам
        FIND_CLOSEST, --сортировка от ближнего к дальнему
        false)

    local nearest = nil
    for _, enemy in pairs(enemies) do
        if #enemy:FindAllModifiersByName("modifier_save_aura") == 0 then
            nearest = enemy
            break
        end
    end

    if nearest ~= nil then
        Attack(nearest)
        thisEntity.state = NEUTRAL_STATE_ATTACK
        return 1
    end

    GoHome()
    thisEntity.state = NEUTRAL_STATE_ON_SPAWN

    return 1
end

function GoHome()
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = thisEntity.spawned_at
    })
end

function Attack(enemy)
    if not thisEntity:IsAttackingEntity(enemy) then
        thisEntity:Stop()
        thisEntity:MoveToTargetToAttack(enemy)
    end
end

function CastPenalty()
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
        AbilityIndex = thisEntity:FindAbilityByName("roshan_penalty"):entindex(),
        Queue = false,
    })
end

function OnEntityKilled(event)
    local killed = EntIndexToHScript(event.entindex_killed)
    if killed:IsHero() and killed:GetTeamNumber() == DOTA_TEAM_GOODGUYS and AnyAliveInTeam(DOTA_TEAM_GOODGUYS) then
        CastPenalty()
    end
end
