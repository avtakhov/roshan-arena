require("game_settings")

RoundManager = RoundManager or class({})

function RoundManager:constructor()
    self.score = {}
    self.score[DOTA_TEAM_GOODGUYS] = 0
    self.score[DOTA_TEAM_BADGUYS] = 0

    ListenToGameEvent("entity_killed", Dynamic_Wrap(RoundManager, "OnEntityKilled"), self)
end

function RoundManager:RoundRestart()
    for player_id = 0, (PlayerResource:GetPlayerCount() - 1) do
        local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
        if hero ~= nil and hero:IsAlive() then
            hero:ForceKill(false)
        end
        if hero:IsHero() and hero:IsConsideredHero() and hero:IsRealHero() then
            hero:RespawnHero(false, false)
        end
    end
end

function RoundManager:RoundEnd(winner_team)
    EmitGlobalSound("Hero_LegionCommander.Duel.Victory")
    for i = 1, PlayerResource:GetPlayerCountForTeam(winner_team) do
        local hero = PlayerResource:GetPlayer(PlayerResource:GetNthPlayerIDOnTeam(winner_team, i)):GetAssignedHero()
        if hero:IsHero() then
            hero:AddNewModifier(hero, nil, "modifier_invulnerable", { duration = RESPAWN_TIME })
            ParticleManager:CreateParticle(
                "particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf",
                PATTACH_ABSORIGIN_FOLLOW,
                hero
            )
        end
    end

    self.score[winner_team] = 1 + self.score[winner_team]
    self:UpdateTeamScore()

    if self.score[winner_team] == 2 then
        GameRules:SetGameWinner(winner_team)
        return
    end

    GameRules:GetGameModeEntity():SetThink(Dynamic_Wrap(RoundManager, "RoundRestart"), self, RESPAWN_TIME)
end

function RoundManager:OnEntityKilled(event)
    local killed = EntIndexToHScript(event.entindex_killed)
    if not killed:IsHero() or not killed:IsHero() then
        return
    end

    if not AnyAliveInTeam(killed:GetTeamNumber()) then
        self:RoundEnd(killed:GetTeamNumber() == DOTA_TEAM_GOODGUYS and DOTA_TEAM_BADGUYS or DOTA_TEAM_GOODGUYS)
    end
end

function RoundManager:UpdateTeamScore()
    GameRules:GetGameModeEntity():SetCustomDireScore(self.score[DOTA_TEAM_BADGUYS])
    GameRules:GetGameModeEntity():SetCustomRadiantScore(self.score[DOTA_TEAM_GOODGUYS])
end
