"use strict";

function OnAbilitySelected(abilityId) {
    const data = {
        player_id: Players.GetLocalPlayer(),
        ability_id: abilityId
    };
    GameEvents.SendCustomGameEventToServer("ability_chosen", data);
    $.GetContextPanel().DeleteAsync(0)
}

function CreateAbility(ability_id, ability_name) {
    const container = $.CreatePanel("Panel", $.GetContextPanel(), "");
    container.BLoadLayoutSnippet("ClickableAbility");

    const image = container.FindChild("abilityImage");
    image.abilityname = ability_name

    container.SetPanelEvent("onactivate", function () {
        OnAbilitySelected(ability_id);
    });
}

function SubscribeButton(button) {

}

function Setup() {
    $.Msg("Setup()")

    GameEvents.Subscribe("additional_abilities", data => {
        Object.entries(data)
            .forEach(ability => CreateAbility(...ability))
    })

    const data = {
        player_id: Players.GetLocalPlayer()
    }
    GameEvents.SendCustomGameEventToServer("player_loaded", data);
}

Setup();
