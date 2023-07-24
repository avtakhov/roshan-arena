require("game_settings")
require("utils")
require("game_managers/round_manager")
require("game_managers/game_state_manager")
require("game_managers/additional_abilities_manager")
require("game_managers/hero_features_manager")
require("game_managers/team_manager")
require("ticks/heroes")
require("ticks/bag_of_gold_spawn")
require("ticks/tome_of_knowledge_spawn")
require("filters/gold")
require("filters/xp")
require("modifier_save_aura")

if Dota1x2GameMode == nil then
    Dota1x2GameMode = class({})
end

function Precache(context)
    --[[
        Precache things we know we'll use.  Possible file types include (but not limited to):
            PrecacheResource( "model", "*.vmdl", context )
            PrecacheResource( "particle", "*.vpcf", context )
            PrecacheResource( "particle_folder", "particles/folder", context )
    ]]
    PrecacheResource("particle", "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
end

function Activate()
    GameRules.AddonTemplate = Dota1x2GameMode()
    GameRules.AddonTemplate:InitGameMode()
end

function Dota1x2GameMode:InitGameMode()
    GameRules:SetPreGameTime(PREGAME_TIME)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 2)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 1)
    GameRules:SetHeroSelectionTime(HERO_SELECTION_TIME)
    GameRules:SetHeroRespawnEnabled(false)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)
    GameRules:SetHeroSelectPenaltyTime(HERO_SELECT_PENALTY_TIME)
    GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
    GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(LEVELS)
    GameRules:GetGameModeEntity():SetHUDVisible(DOTA_HUD_VISIBILITY_HERO_SELECTION_TEAMS, false)
    GameRules:GetGameModeEntity():SetAllowNeutralItemDrops(false)
    GameRules:GetGameModeEntity():SetNeutralStashEnabled(false)
    GameRules:GetGameModeEntity():SetAnnouncerDisabled(true)
    GameRules:GetGameModeEntity():SetDaynightCycleDisabled(true)
    RoundManager()
    GameStateManager()
    AdditionalAbilitiesManager()
    HeroFeaturesManager()
    TeamManager()
end
