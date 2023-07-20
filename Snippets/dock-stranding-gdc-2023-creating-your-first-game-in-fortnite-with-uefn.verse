# Title: Dock Stranding - GDC 2023 Creating Your First Game in Fortnite With UEFN
# Subtitle: Snippet for the GDC 2023 Dock Stranding demo.
In this game, players take turns jumping between crumbling platforms to escape on a boat.
# Author: DiG [ /community/profile/Axe3/DiG3 ]
# Created: Wed Mar 22 2023 23:08:08 GMT+0000 (Coordinated Universal Time)
# Last Updated: Wed Mar 22 2023 23:08:08 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/rjo/dock-stranding-gdc-2023-creating-your-first-game-in-fortnite-with-uefn
# ------

# Dock Stranding
# Note: None
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities}
using { /Fortnite.com/Game }
using { /Fortnite.com/Teams }
using { /Fortnite.com/UI }
using { /Verse.org/Concurrency }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

dock_run_log_channel := class(log_channel):

dock := struct<concrete>:
    @editable
    DockProp:creative_prop = creative_prop{}
    @editable
    Trigger:trigger_device = trigger_device{}
    @editable
    VFX:vfx_spawner_device = vfx_spawner_device{}

docks_row := struct<concrete>:
    @editable
    Docks:[]dock = array{}

dock_run_device := class(creative_device):
    DockLog:log = log{Channel := dock_run_log_channel, DefaultLevel := log_level.Normal}

    var DocksRows:[]docks_row = array{}

    @editable
    DocksRow1:[]creative_prop = array{}
    @editable
    DocksRow2:[]creative_prop = array{}
    @editable
    DocksRow3:[]creative_prop = array{}
    @editable
    DocksRow4:[]creative_prop = array{}
    @editable
    DocksRow5:[]creative_prop = array{}
    @editable
    DocksRow6:[]creative_prop = array{}
    @editable
    TriggersRow1:[]trigger_device = array{}
    @editable
    TriggersRow2:[]trigger_device = array{}
    @editable
    TriggersRow3:[]trigger_device = array{}
    @editable
    TriggersRow4:[]trigger_device = array{}
    @editable
    TriggersRow5:[]trigger_device = array{}
    @editable
    TriggersRow6:[]trigger_device = array{}
    @editable
    DockVFXRow1:[]vfx_spawner_device = array{}
    @editable
    DockVFXRow2:[]vfx_spawner_device = array{}
    @editable
    DockVFXRow3:[]vfx_spawner_device = array{}
    @editable
    DockVFXRow4:[]vfx_spawner_device = array{}
    @editable
    DockVFXRow5:[]vfx_spawner_device = array{}
    @editable
    DockVFXRow6:[]vfx_spawner_device = array{}

    @editable
    EliminationZone:damage_volume_device = damage_volume_device{}
    @editable
    SecondsBeforeElimination:float = 0.88
    @editable
    EndZone:trigger_device = trigger_device{}
    @editable
    EndGameDevice:end_game_device = end_game_device{}
    @editable
    WinSequence:cinematic_sequence_device = cinematic_sequence_device{}

    # Seconds to wait before ending the game after the end zone is reached. This is to give the players time to see the win sequence.
    @editable
    SecondsBeforeEndGame:float = 10.0

    # Seconds to wait before showing the win/loss message on game end.
    @editable
    SecondsBeforeShowEndMessage:float = 3.0
    @editable
    RespawnPad:player_spawner_device = player_spawner_device{}
    @editable
    WaitingZonePad:player_spawner_device = player_spawner_device{}
    @editable
    HudTurnMessage:hud_message_device = hud_message_device {}
    @editable
    HudWaitMessage:hud_message_device = hud_message_device {}
    @editable
    HudWinMessage:hud_message_device = hud_message_device {}
    @editable
    HudLossMessage:hud_message_device = hud_message_device {}

    PlayerEliminatedEvent:event(player) = event(player){}

    var Players:[]player = array{}
    var TurnOwnerIndex:int = 0
    var TrapDockIndexSequence:[]int = array{}
    var SpectatorsTeamOpt:?team = false
    var RunnerTeamOpt:?team = false

    MakeDocksRows():void=
        AllDocksRows := array{DocksRow1, DocksRow2, DocksRow3, DocksRow4, DocksRow5, DocksRow6}
        AllTriggersRows := array{TriggersRow1, TriggersRow2, TriggersRow3, TriggersRow4, TriggersRow5, TriggersRow6}
        AllVFXRows := array{DockVFXRow1, DockVFXRow2, DockVFXRow3, DockVFXRow4, DockVFXRow5, DockVFXRow6}
        set DocksRows =
            for (X := 0..5, Row := (AllDocksRows[X], AllTriggersRows[X], AllVFXRows[X])):
                docks_row:
                    Docks := for (Y := 0..Row(0).Length, NewDock := dock{DockProp := Row(0)[Y], Trigger := Row(1)[Y], VFX := Row(2)[Y]}):
                        NewDock

    # Makes a random sequence for the indices of the docks that should break (trap docks).
    MakeTrapDockIndexSequence(Rows:[]docks_row)<varies>:[]int=
        for (Row:Rows):
            GetRandomInt(0, Row.Docks.Length-1)
                    
    OnBegin<override>()<suspends>:void=
        MakeDocksRows()

        # We expect the first team to be the runner and the second team to be the spectators.
        FortTeams := GetPlayspace().GetTeamCollection()
        set RunnerTeamOpt = option{FortTeams.GetTeams()[0]}
        set SpectatorsTeamOpt = option{FortTeams.GetTeams()[1]}
        DockLog.Print("Number of teams: {GetPlayspace().GetTeamCollection().GetTeams().Length}", ?Level:=log_level.Warning)
        if (not (RunnerTeamOpt? and SpectatorsTeamOpt?)):
            DockLog.Print("Dock Run: Failed to get the runner and spectators teams. Make sure to set up two teams. Team1 = Runner, Team2 = Spectators", ?Level:=log_level.Error)
       
        EliminationZone.AgentEntersEvent.Subscribe(OnEliminationZoneEntered)
        
        # Detect when a player enters the game so they can be added to the list of players.
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)
        # Detect when a player leaves the game to handle the turn owner leaving and to adjust the TurnOwnerIndex.
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)

        set Players = Shuffle(GetPlayspace().GetPlayers()) 
        
        for (Player:Players, PlayerUI := GetPlayerUI[Player], Character := Player.GetFortCharacter[]):
            if (FortTeams.IsOnTeam[Player, RunnerTeamOpt?]):
                DockLog.Print("Player is on Runner team", ?Level:=log_level.Warning)
            else:
                DockLog.Print("Player is on Spectator team", ?Level:=log_level.Warning)

            # This will just start each player but the first turn owner as spectators.
            EndTurn(Player)
            PlayerUI.HideHUDElements(array{player_hud_identifier_all{}, creative_hud_identifier_all{}})

        set TrapDockIndexSequence = MakeTrapDockIndexSequence(DocksRows) 
        DockLog.Print("TrapDockSequence: {IntsToSeparatedString(TrapDockIndexSequence, ?Separator := "-")}", ?Level:=log_level.Verbose)
            
        # The first player could be in the spectators team; StartTurn will move them to the runner team.
        if (FirstPlayer := Players[0]):
            StartTurn(FirstPlayer)
            
        race:
            GameLoop()
            
             # End the game when the end zone is reached.
            OnEndZoneTriggered(EndZone.TriggeredEvent.Await())

    AwaitTrapDockTriggered(InDock:dock, SharedEvent:event(dock))<suspends>:void= 
        InDock.Trigger.TriggeredEvent.Await()
        SharedEvent.Signal(InDock)

    # Returns an event that's signaled when any trap dock trigger is touched.
    # The event's payload contains the dock that was touched.
    GetTrapDockTouchedEvent()<suspends>:event(dock)= 

        # This filters events based on the Trigger being for a trap,
        # which is based on the index of the dock in the row from the TrapDockIndexSequence.
        TrapEvent:event(dock) = event(dock){}
        DockLog.Print("Creating trap docks events...")
        for (RowIndex -> Row:DocksRows, TrapIndex := TrapDockIndexSequence[RowIndex], TrapDock := Row.Docks[TrapIndex]):
            DockLog.Print("Creating handler for trap dock {TrapIndex} in row {RowIndex}...", ?Level := log_level.Debug)
            spawn{AwaitTrapDockTriggered(TrapDock, TrapEvent)}
        TrapEvent

    GameLoop()<suspends>:void =

        # Bundle all events from the trap docks under a single event we can repeatedly await on.
        TrapDockTouchedEvent := GetTrapDockTouchedEvent()
        
        # Player advances row by row until they are eliminated.
        loop:

            # Race between a trap dock triggered and the PlayerEliminatedEvent.
            race:

                # Trap dock, destroy the prop.
                block:
                    TrapDock := TrapDockTouchedEvent.Await()
                    if (TrapDock.DockProp.IsValid[]):

                        # Destroy the dock.
                        TrapDock.DockProp.Dispose()

                        # We can disable the Trigger since it's not needed anymore.
                        TrapDock.Trigger.Disable()
                        
                        # Trigger the VFX.
                        TrapDock.VFX.Enable()

                PlayerEliminatedEvent.Await()

    EndGame(AgentOpt:?agent)<suspends>:void=
        if (Agent := AgentOpt?):

            # We branch a coroutine to show the Win/Loss message.
            # The branch starts executing its inner scope;
            # the code following the branch starts executing as soon as the first
            # <suspends> call happens. 
            branch:

                # The expressions after the branch start executing as soon as Sleep is called.
                Sleep(SecondsBeforeShowEndMessage)
                for (Player:Players):

                    # Show the win message for the player that won and the loss message for everyone else.
                    if (Player = Agent):
                        HudWinMessage.Show(Player)
                    else:
                        HudLossMessage.Show(Player)

            Sleep(SecondsBeforeEndGame)
            EndGameDevice.Activate(Agent)

    OnEndZoneTriggered(AgentOpt:?agent):void=

        # When the EndZone is triggered and the game ends, we disable the
        # EliminationZone so the end game can't be disrupted by the winning player
        # jumping into the water.
        EliminationZone.Disable()
        WinSequence.Play()
        DockLog.Print("End Zone Triggered", ?Level := log_level.Verbose)
        spawn{EndGame(AgentOpt)}
        
    OnPlayerAdded(Player:player):void=

        # Find the correct index to insert the player at.
        # We insert the Player so that they don't take precedence over players that were already in the game.
        # This means inserting the new player in the position before the current turn owner,
        # so they have to wait for all other players, including the current turn owner, to take their turn.
        # We insert the new player where the turn owner is, shifting the turn owner to the "right". 
        # We must wrap the insertion in a failure context.
        if (set Players = Players.Insert[TurnOwnerIndex, array{Player}]):
            
            # We must also increment the TurnOwnerIndex to account for the new player.
            set TurnOwnerIndex += 1        
            
        # Finally, we EndTurn for the new player, so they're placed in spectator mode.
        EndTurn(Player)
        
    OnPlayerRemoved(Player:player):void=
        
        # First, we find the index of the player that left.
        if (LeavingPlayerIndex := Players.Find[Player]):
            
            # When the turn owner leaves the game, we must advance the turn so the spectators
            # aren't left stuck waiting.
            # Save it for later since we might change the TurnOwnerIndex,
            # making LeavingPlayerIndex = TurnOwnerIndex false when it isn't.
            ShouldAdvanceTurn:logic = if (LeavingPlayerIndex = TurnOwnerIndex) then true else false

            # If the player that left is before or at the turn owner position in the list of players,
            # we must decrement the TurnOwnerIndex to account for the player that left.
            if (LeavingPlayerIndex <= TurnOwnerIndex):
                set TurnOwnerIndex -= 1

            # We remove the player that left from the list of players.
            if (set Players = Players.Remove[LeavingPlayerIndex, LeavingPlayerIndex + 1]):
                if: 
                    ShouldAdvanceTurn?
                    set TurnOwnerIndex = Mod[(TurnOwnerIndex + 1), Players.Length]
                    NextTurnOwner := Players[TurnOwnerIndex]
                then:

                    # We just need to StartTurn for the NextTurnOwner as there's no need to EndTurn for
                    # the Player that left.
                    DockLog.Print("OnPlayerRemoved: Automatically advancing turn due to turn owner leaving the game.", ?Level := log_level.Verbose)
                    StartTurn(NextTurnOwner)
            else:
                DockLog.Print("OnPlayerRemoved: Couldn't remove leaving Player from Players list.", ?Level := log_level.Error)
        else:
            DockLog.Print("OnPlayerRemoved: Leaving Player not found in Players list", ?Level := log_level.Error)

    OnEliminationZoneEntered(Agent:agent):void=

        # We spawn the asynchronous routine AdvanceTurn
        # because device event handlers can't be <suspends>,
        # but we want to wait (Sleep) for SecondsBeforeElimination before ending the player's turn.
        spawn{AdvanceTurn(Agent)}

    AdvanceTurn(Agent:agent)<suspends>:void=
        if:
            Player := player[Agent]
            PreviousTurnOwner := Players[TurnOwnerIndex]
            PreviousTurnOwner = Player
            set TurnOwnerIndex = Mod[(TurnOwnerIndex + 1), Players.Length]
            NextTurnOwner := Players[TurnOwnerIndex]
        then:
            Sleep(SecondsBeforeElimination)
            StartTurn(NextTurnOwner)
            EndTurn(PreviousTurnOwner)
            PlayerEliminatedEvent.Signal(PreviousTurnOwner)

    EndTurn<private>(Player:player):void=
        if:
            NextPlayer := Players[TurnOwnerIndex]

            # It doesn't make sense to spectate yourself. In this case don't end the turn. This should only happen if there's only one player.
            NextPlayer <> Player
        then:
            HudWaitMessage.Show(Player)
            FortTeams := GetPlayspace().GetTeamCollection()
            if (SpectatorsTeam := SpectatorsTeamOpt?):
                if (FortTeams.AddToTeam[Player, SpectatorsTeam]):
                    DockLog.Print("EndTurn: Added player to SpectatorsTeam.", ?Level := log_level.Verbose)

                    # Respawn player to the wait location
                    Transform := WaitingZonePad.GetTransform()
                    Player.Respawn(Transform.Translation, Transform.Rotation)
                else:
                    DockLog.Print("EndTurn: Error adding player to SpectatorsTeam.", ?Level := log_level.Error)
            else:
                DockLog.Print("EndTurn: SpectatorsTeam not found.", ?Level := log_level.Error)
        else:
            DockLog.Print("EndTurn: Not ending turn for current player. They would spectate themselves.", ?Level := log_level.Verbose)

    StartTurn<private>(Player:player):void=
        FortTeams := GetPlayspace().GetTeamCollection()
        HudTurnMessage.Show(Player)
        if (FortTeams.AddToTeam[Player, RunnerTeamOpt?]):
            DockLog.Print("StartTurn: Added player to RunnerTeam.", ?Level := log_level.Verbose)

            # Respawn player to the active turn location
            Transform := RespawnPad.GetTransform()
            DockLog.Print("StartTurn: Respawning Player", ?Level := log_level.Debug)
            Player.Respawn(Transform.Translation, Transform.Rotation)
        else:
            DockLog.Print("StartTurn: Error adding player to RunnerTeam.", ?Level := log_level.Error)
