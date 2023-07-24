require("game_settings")

GoldFilter = GoldFilter or class({})

function GoldFilter:constructor()
    GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GoldFilter, "OnGoldReceived"), self)
end

function GoldFilter:OnGoldReceived(event)
    if event.reason_const == DOTA_ModifyGold_HeroKill then
        event.gold = HERO_KILL_GOLD_AMOUNT
    end

    return true
end