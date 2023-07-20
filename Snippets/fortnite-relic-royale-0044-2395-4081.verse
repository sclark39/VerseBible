# Title: Relic Royale - 0044-2395-4081
# Subtitle: Everybody spawns as Initiates. First to grab the Relic becomes the Chosen One. Only the Chosen One can score points for eliminating Initiates. A gold beacon slowly follows the Chosen One, healing them on contact but also revealing their general location.
# Author: spilth [ /community/profile/AqXp9/spilth ]
# Created: Sun May 14 2023 16:42:31 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sun May 14 2023 16:42:31 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/pvO/fortnite-relic-royale-0044-2395-4081
# ------

# spawn_location_randomizer_device.verse
# Note: A device for managing multiple potential spawn locations for the Relic
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary }
using { /UnrealEngine.com/Temporary/Diagnostics }

spawn_location_randomizer_log:=class(log_channel){}

spawn_location_randomizer_device := class(creative_device):
    Logger:log = log{Channel:=spawn_location_randomizer_log}

    @editable
    IntroSequence:cinematic_sequence_device = cinematic_sequence_device{}

    @editable
    FirstSpawnTimer:timer_device = timer_device{}

    @editable
    ASelector:class_and_team_selector_device = class_and_team_selector_device{}

    @editable
    BTracker:tracker_device = tracker_device{}

    @editable
    BDescription:hud_message_device = hud_message_device{}

    @editable
    GameStartAnnouncer:hud_message_device = hud_message_device{}

    # ItemReturnedEvent does not currently fire correctly in Verse code,
    # so I'm using a Trigger to act as a Proxy for that Event in UEFN
    @editable
    ItemReturnedTrigger:trigger_device = trigger_device{}

    @editable
    SpawnedAnnouncer:hud_message_device = hud_message_device{}

    @editable
    SpawnLocations:[]spawn_location = array{}

    @editable
    ChosenMarker<public> : chosen_marker = chosen_marker{}

    var ActiveSpawnLocation:spawn_location = spawn_location{}

    OnBegin<override>()<suspends>:void=
        ChosenMarker.Unfollow()
        EnableAllSpawnLocations()

        FirstSpawnTimer.SuccessEvent.Subscribe(OnFirstSpawnTimerSuccess)
        IntroSequence.StoppedEvent.Subscribe(OnIntroSequenceStopped)
        ItemReturnedTrigger.TriggeredEvent.Subscribe(OnItemReturned)

        for(SpawnLocation : SpawnLocations):
            SpawnLocation.Spawner.ItemPickedUpEvent.Subscribe(OnItemPickedUp)
            SpawnLocation.Spawner.ItemDroppedEvent.Subscribe(OnItemDropped)

        # We need to sleep before putting players in statis in OnBegin
        Sleep(0.1)
        FreezeAllPlayers()

    OnIntroSequenceStopped<private>():void=
        DisableAllSpawnLocations()
        UnfreezeAllPlayers()
        FirstSpawnTimer.Start()
        GameStartAnnouncer.Show()

    OnFirstSpawnTimerSuccess<private>(Agent : ?agent):void =
        EnableRandomSpawner()

    OnItemPickedUp<private>(Agent : agent):void=
        ActiveSpawnLocation.DisableAudioVisuals()
        BTracker.SetDescriptionText(PickedUpTrackerMessage())
        BDescription.Hide()
        BDescription.SetText(PickedUpTrackerMessage())
        BDescription.Show()
        ASelector.ChangeTeam(Agent)

        spawn { ChosenMarker.Follow(Agent) }

    OnItemDropped<private>(Agent : agent):void=
        ChosenMarker.Unfollow()
        EliminatePlayer(Agent)
        BTracker.SetDescriptionText(DroppedTrackerMessage())
        BDescription.Hide()
        BDescription.SetText(DroppedTrackerMessage())
        BDescription.Show()
    
    OnItemReturned<private>(Agent : ?agent):void=
        ChosenMarker.Unfollow()
        EnableRandomSpawner()

    EnableRandomSpawner<private>():void=
        RandomIndex := GetRandomInt(0, SpawnLocations.Length - 1)

        for(Index := 0..SpawnLocations.Length - 1):
            if(SpawnLocation := SpawnLocations[Index]):
                if (Index = RandomIndex):
                    SpawnLocation.Enable()
                    BTracker.SetDescriptionText(TrackerMessage(SpawnLocation.Name))
                    BDescription.Hide()
                    BDescription.SetText(TrackerMessage(SpawnLocation.Name))
                    BDescription.Show()
                    SpawnedAnnouncer.SetText(SpawnedMessage(SpawnLocation.Name))
                    SpawnedAnnouncer.Show()
                    set ActiveSpawnLocation = SpawnLocation
                else:
                    SpawnLocation.Disable()

    EnableAllSpawnLocations<private>():void=
        for(SpawnLocation : SpawnLocations):
            SpawnLocation.Enable()

    DisableAllSpawnLocations<private>():void=
        for(SpawnLocation : SpawnLocations):
            SpawnLocation.Disable()

    EliminatePlayer<private>(Agent :agent):void=
        if (FortniteCharacter:= Agent.GetFortCharacter[]):
            FortniteCharacter.Damage(999.0)

    FreezeAllPlayers<private>():void=
        for (Player : GetPlayspace().GetPlayers()):
            if (Character := Player.GetFortCharacter[]):
                Character.PutInStasis(stasis_args{})
                Character.Hide()

    UnfreezeAllPlayers<private>():void=
        for (Player : GetPlayspace().GetPlayers()):
            if (Character := Player.GetFortCharacter[]):
                Character.ReleaseFromStasis()
                Character.Show()

