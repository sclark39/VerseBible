# Title: Flashback Ability
# Subtitle: Sets location in map to teleport back to the recorded location, using one teleporter total for all players.  Requires a creative_prop to attach a teleporter device to.
# Author: Thomas Burns / Twin [ /community/profile/BE9bO/Twin01 ]
# Created: Sat May 06 2023 22:22:33 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat May 06 2023 22:22:33 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/AWK/fortnite-flashback-ability
# ------

# None
# Note: None

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Fortnite.com/FortPlayerUtilities }

flashback_device := class(creative_device):

    @editable
    RemoteManager : signal_remote_manager_device = signal_remote_manager_device{}

    var AgentMap : [agent]transform = map{}

    OnBegin<override>()<suspends>:void=

        RemoteManager.PrimarySignalEvent.Subscribe(UseFlashback)
        RemoteManager.SecondarySignalEvent.Subscribe(SetLocation)

    UseFlashback(Agent : agent):void=
        if {Agent.Respawn(AgentMap[Agent].Translation, AgentMap[Agent].Rotation)}

    SetLocation(Agent : agent):void=
        if:
            FortCharacter := Agent.GetFortCharacter[]
            set AgentMap[Agent] = FortCharacter.GetTransform()
        then:
            Print("Location Set:  {FortCharacter.GetTransform().Translation} {FortCharacter.GetTransform().Rotation}")
