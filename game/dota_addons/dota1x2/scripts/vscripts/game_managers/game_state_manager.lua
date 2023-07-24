GameStateManager = GameStateManager or class({})

function GameStateManager:constructor()
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameStateManager, 'OnGameStateChange'), self)
end

function GameStateManager:OnGameStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
        self:OnStrategyTime()
    elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self:OnGameInProgress()
    elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
        self:OnHeroSelection()
    end
end

function GameStateManager:OnGameInProgress()
    TomeOfKnowledgeSpawnTick():Start()
    BagOfGoldSpawnTick():Start()
    HeroesTick():Start()
end

function GameStateManager:OnStrategyTime()
    for player_id = 0, (PlayerResource:GetPlayerCount() - 1) do
        local player = PlayerResource:GetPlayer(player_id)
        if not PlayerResource:HasSelectedHero(player_id) then
            player:MakeRandomHeroSelection()
        end
    end
end

function GameStateManager:OnHeroSelection()
    GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered(true)

    local teams_heroes = {
        { team = DOTA_TEAM_BADGUYS, allowed_heroes = ALLOWED_BAD_HEROES },
        { team = DOTA_TEAM_GOODGUYS, allowed_heroes = ALLOWED_GOOD_HEROES }
    }

    for _, team_heroes in pairs(teams_heroes) do
        for i = 1, PlayerResource:GetPlayerCountForTeam(team_heroes.team) do
            local player = PlayerResource:GetNthPlayerIDOnTeam(team_heroes.team, i)
            GameRules:ClearPlayerHeroAvailability(player)
            for _, hero_name in ipairs(team_heroes.allowed_heroes) do
                GameRules:AddHeroToPlayerAvailability(player, DOTAGameManager:GetHeroIDByName(hero_name))
            end
        end
    end
end