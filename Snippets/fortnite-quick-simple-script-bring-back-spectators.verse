# Title: Quick & Simple Script - Bring Back Spectators
# Subtitle: This Device Requires a Player Counter to Be connected with and you're done. Just Send a Signal on the Connected Player Counter's (Transmit for All Counted Players) and then everyone who isn't spawned should be Spawned
# Author: MinebloFN [ /community/profile/rBMz4/Mineblo ]
# Created: Tue Apr 25 2023 02:49:58 GMT+0000 (Coordinated Universal Time)
# Last Updated: Tue Apr 25 2023 02:49:58 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/eYv/fortnite-quick-simple-script-bring-back-spectators
# ------

# Verse Code
# Note: None

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/FortPlayerUtilities }
using { /UnrealEngine.com/Temporary/SpatialMath }


RespawnDevice := class(creative_device):

    varvector :vector3= vector3{X := 0.0, Y := 0.0 ,Z := 0.0}
    @editable
    PlayerCounter : player_counter_device = player_counter_device{}

    OnBegin<override>()<suspends>:void=
        PlayerCounter.CountedEvent.Subscribe(PlayerCounted)

    PlayerCounted(Agent : agent) : void =
        if(InPlayer := player[Agent]):
            Agent.Respawn(varvector,rotation{})
