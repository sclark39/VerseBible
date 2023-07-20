# Title: Multiple TriggerEvents Handler
# Subtitle: Process events from an array of TriggerDevices according to their respective indices.
# Author: RingoGames [ /community/profile/5pBZE/RingoGames ]
# Created: Fri Mar 31 2023 02:03:18 GMT+0000 (Coordinated Universal Time)
# Last Updated: Fri Mar 31 2023 02:03:18 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/1mM/fortnite-multiple-triggerevents-handler
# ------

# None
# Note: None

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


test_trigger_handler := class:
    Sender : trigger_device
    Index : int
    HUD : hud_message_device

    TriggerIndexMessage<localizes>(Value:int):message = "Trigger {Value}"

    HandleButtonInteractedWith(Agent:?agent):void=
        HUD.SetText(TriggerIndexMessage(Index))
        HUD.Show()

trigger_array_manager := class(creative_device):

    @editable 
    Triggers:[]trigger_device = array{}

    @editable
    HudMessageDevice : hud_message_device = hud_message_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        var Count :int = 0
        for(Trigger:Triggers):
            EventHandler:test_trigger_handler := test_trigger_handler{Sender := Trigger, Index := Count, HUD := HudMessageDevice}
            Trigger.TriggeredEvent.Subscribe(EventHandler.HandleButtonInteractedWith)
            set Count = Count + 1

