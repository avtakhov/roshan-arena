require("game_settings")
require("ticks/base_tick")
require("utils")

HeroesTick = HeroesTick or class({}, {}, BaseTick)

function HeroesTick:constructor()
    BaseTick.constructor(self, 1, 0)
end

function HeroesTick:GetName()
    return "HeroesTick"
end

function HeroesTick:OnTick()
    for player_id = 0, (PlayerResource:GetPlayerCount() - 1) do
        local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
        if hero ~= nil and hero:IsHero() then
            AddGoldXpToHero(hero)
            OutOfMapPenalty(hero)
        end

    end
end

function RandomDivision(a, b)
    local result, rem = math.modf(a / b)
    if RandomFloat(0, 1) > rem then
        return result + 1
    else
        return result
    end
end

function AddGoldXpToHero(hero)
    local team_stats = GPM_XPM_BY_TEAM[hero:GetTeamNumber()]

    local gold = RandomDivision(team_stats.gpm, 60)
    PlayerResource:ModifyGold(hero:GetPlayerOwnerID(), gold, true, DOTA_ModifyGold_GameTick)

    local xp = RandomDivision(team_stats.xpm, 60)
    hero:AddExperience(xp, DOTA_ModifyXP_Unspecified, false, false)
end

function OutOfMapPenalty(hero)
    local current_pos = hero:GetCenter()
    if current_pos.x <= -4096 or current_pos.x >= 4096 or current_pos.y <= -4096 or current_pos.y >= 4096 then
        ApplyDamage({
            victim = hero,
            attacker = hero,
            damage = hero:GetLevel() * 50,
            damage_type = DAMAGE_TYPE_PURE,
            ability = nil,
        })
    end
end
