function StartTouch(trigger)
    trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_save_aura", { duration = -1 })
end

function EndTouch(trigger)
    trigger.activator:RemoveModifierByName("modifier_save_aura")
end
