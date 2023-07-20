# Title: Quick & Simple Script - Send Players To Lobby
# Subtitle: This Verse Device Needs to be linked to a trigger and In order to send a player to The Lobby Make Sure the player sends an instigation to that trigger
# Author: MinebloFN [ /community/profile/rBMz4/Mineblo ]
# Created: Tue Apr 25 2023 05:35:48 GMT+0000 (Coordinated Universal Time)
# Last Updated: Tue Apr 25 2023 05:35:48 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/dP7/fortnite-quick-simple-script-send-players-to-lobby
# ------

# None
# Note: None

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/FortPlayerUtilities }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.


KickPlayer := class(creative_device):

    @editable
    Trigger : trigger_device = trigger_device{}

    OnBegin<override>()<suspends>:void=
        Trigger.TriggeredEvent.Subscribe(PlayerCounted)

    PlayerCounted(Agent : ?agent) : void =
        if(InPlayer := player[Agent?]):
            InPlayer.SendToLobby()
