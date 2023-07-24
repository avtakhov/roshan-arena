require("game_settings")

XpFilter = XpFilter or class({})

function XpFilter:constructor()
    GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(XpFilter, "OnXpReceived"), self)
end

function XpFilter:OnXpReceived(event)
    if event.reason_const == DOTA_ModifyXP_HeroKill then
        event.experience = HERO_KILL_XP_AMOUNT
    end

    return true
end