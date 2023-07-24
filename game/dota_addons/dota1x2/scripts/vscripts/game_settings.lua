GPM_XPM_BY_TEAM = {}

GPM_XPM_BY_TEAM[DOTA_TEAM_GOODGUYS] = {
    gpm = 1100,
    xpm = 200
}

GPM_XPM_BY_TEAM[DOTA_TEAM_BADGUYS] = {
    gpm = 1550,
    xpm = 220
}

LEVELS = {
    0,
    100,
    200,
    300,
    400,
    500, -- 6
    600,
    700,
    800,
    900,
    950,
    1000, -- 12
    1050,
    1100,
    1150,
    1200,
    1250,
    1350, -- 18
    1400,
    1500, -- 20
    1600,
    1700,
    1800,
    1900,
    2000, -- 25
    2100,
    2200,
    2300,
    2400,
    2500  -- 30
}

GOLD_OF_BAG_SPAWNER_POINTS = {
    Vector(-2513, -953, 300),
    Vector(3169, 3225, 16)
}

TOME_OF_KNOWLEDGE_SPAWNER_POINTS = {
    Vector(-2520, -2795, 128)
}
ITEM_DROP_DISPERSION = 100.

GOLD_BAG_AMOUNT = 250
TOME_OF_KNOWLEDGE_XP_AMOUNT = 75

PREGAME_TIME = 8.
HERO_SELECTION_TIME = 30.
HERO_SELECT_PENALTY_TIME = 0.
RESPAWN_TIME = 8.

ALLOWED_GOOD_HEROES = {
    "npc_dota_hero_crystal_maiden",
    "npc_dota_hero_witch_doctor",
    "npc_dota_hero_phantom_assassin",
    "npc_dota_hero_bloodseeker",
    "npc_dota_hero_phoenix",
    "npc_dota_hero_mirana",
    "npc_dota_hero_hoodwink",
    "npc_dota_hero_pugna",
    "npc_dota_hero_techies",
    "npc_dota_hero_snapfire",
    "npc_dota_hero_nevermore",
    "npc_dota_hero_skywrath_mage"
}

ALLOWED_BAD_HEROES = {
    "npc_dota_hero_night_stalker",
    "npc_dota_hero_undying",
    "npc_dota_hero_pudge",
    "npc_dota_hero_tiny",
    "npc_dota_hero_tusk",
    "npc_dota_hero_primal_beast",
    "npc_dota_hero_spirit_breaker"
}

HERO_KILL_GOLD_AMOUNT = 100
HERO_KILL_XP_AMOUNT = 50

INITIAL_LEVEL = {}

INITIAL_LEVEL[DOTA_TEAM_GOODGUYS] = 1
INITIAL_LEVEL[DOTA_TEAM_BADGUYS] = 2
