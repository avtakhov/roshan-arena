require("utils")
require("errors")
require("hero_features/nevermore")

HeroFeaturesManager = HeroFeaturesManager or class({})

function HeroFeaturesManager:constructor()
    self.hero_features = {}
    self:AddFeature(Nevermore())
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(HeroFeaturesManager, "OnNPCSpawned"), self)
end

function HeroFeaturesManager:OnNPCSpawned(event)
    local unit = EntIndexToHScript(event.entindex)
    local feature = self.hero_features[unit:GetUnitName()]
    if unit:IsHero() and feature ~= nil then
        feature:OnHeroFirstSpawned(unit)
        self.hero_features[unit:GetUnitName()] = nil
    end
end

function HeroFeaturesManager:AddFeature(feature)
    self.hero_features[feature:GetHeroName()] = feature
    return self
end
