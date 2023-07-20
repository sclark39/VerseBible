# Title: Change To Team Device
# Subtitle: Connect an event to a trigger and choose a team in the Verse device.
# Author: Thomas Burns / Twin [ /community/profile/BE9bO/Twin01 ]
# Created: Mon May 01 2023 06:56:55 GMT+0000 (Coordinated Universal Time)
# Last Updated: Mon May 01 2023 06:56:55 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/3YD/fortnite-change-to-team-device
# ------

# None
# Note: None
using { /Fortnite.com/Devices }
using { /Fortnite.com/Teams }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

add_to_team := class(creative_device):

    # Connect this trigger device to your event of choice
    @editable
    Trigger : trigger_device = trigger_device{} 

    # Choose the team to change to
    @editable
    var Team : int = 1

    OnBegin<override>()<suspends>:void=

        Trigger.TriggeredEvent.Subscribe(ChangeTeams)

    ChangeTeams(MaybeAgent : ?agent):void=
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams : []team = TeamCollection.GetTeams()
        if:
            Agent := MaybeAgent?
            TeamCollection.AddToTeam[Agent, Teams[Team-1]]
