BaseFeature = BaseFeature or class({})

function BaseFeature:constructor()
end

-- abstract
function BaseFeature:GetHeroName()
    error(Unimplemented("BaseFeature", "GetHeroName"))
end

-- abstract
function BaseFeature:OnHeroFirstSpawned(hero)
    error(Unimplemented("BaseFeature", "OnHeroSpawned"))
end
