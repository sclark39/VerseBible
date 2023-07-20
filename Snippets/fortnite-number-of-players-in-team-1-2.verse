# Title: Number of players in team 1 & 2
# Subtitle: This allows you to get the number of players in team 1 & 2.
# Author: MaplexMaker [ /community/profile/lMrmq/MaplexMaker ]
# Created: Sun May 21 2023 23:33:26 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sun May 21 2023 23:33:26 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/GJe/fortnite-number-of-players-in-team-1-2
# ------

# GetTeamSize()
# Note: None
    GetTeamSize() : void =
        AllPlayers := GetPlayspace().GetPlayers()
        for (Player : AllPlayers):
            if (FortCharacter := Player.GetFortCharacter[]):

                TeamCollection := GetPlayspace().GetTeamCollection()
                if:
                    Agent := FortCharacter.GetAgent[]
                    Team := TeamCollection.GetTeam[Agent]
                    TeamAgents := TeamCollection.GetAgents[Team]
                    TeamIndex := TeamCollection.GetTeams().Find[Team]
                    TeamIndex = 0
                then:
                    set NumberPlayerTeam1 = TeamAgents.Length
                    Print("The number of players in Team 1 is: {NumberPlayerTeam1}")
                else if:
                    Agent := FortCharacter.GetAgent[]
                    Team := TeamCollection.GetTeam[Agent]
                    TeamAgents := TeamCollection.GetAgents[Team]
                    TeamIndex := TeamCollection.GetTeams().Find[Team]
                    TeamIndex = 1
                then:
                    set NumberPlayerTeam2 = TeamAgents.Length
                    Print("The number of players in Team 2 is: {NumberPlayerTeam2}")
