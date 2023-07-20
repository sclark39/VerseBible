# Title: Team Selection and counting devices that reference spawn points and teleporters.
# Subtitle: This is a pair of fairly simple devices that enable selection of teams via teleporters.
# Author: Nooberling [ /community/profile/rEZlv/Nooberling ]
# Created: Sun Jun 18 2023 20:04:11 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sun Jun 18 2023 20:04:11 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/7NN4/fortnite-team-selection-and-counting-devices-that-reference-spawn-points-and-teleporters
# ------

# Team Management Device
# Note: A device that does team management. Combined with the player counter it will allow players to use teleporters for team selection.
# Team Management Device

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
team_management_device := class(creative_device):
    @editable TeamChoiceTeleporter : teleporter_device = teleporter_device{}
    @editable TeamPlayerCounter : team_player_counter_device = team_player_counter_device{}
    @editable var TeamID : int = 1

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        TeamChoiceTeleporter.EnterEvent.Subscribe(ChooseTeam)
        return

    ChooseTeam(AgentIn : agent) : void =
        Print("Team Chosen.")
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams : []team = TeamCollection.GetTeams()
        TeamPlayerCounter.DecrementAgentTeamCount(AgentIn)
        if (TeamCollection.AddToTeam[AgentIn, Teams[TeamID-1]]):
            TeamPlayerCounter.IncrementAgentTeamCount(AgentIn)


