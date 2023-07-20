# Title: Memory Sequence Device
# Subtitle: This device resembles the "Simon Says" game, where the player has to remember a random growing sequence of items and interact with them in the correct order.
# Author: DiG [ /community/profile/Axe3/DiG3 ]
# Created: Thu Mar 23 2023 00:36:31 GMT+0000 (Coordinated Universal Time)
# Last Updated: Thu Mar 23 2023 00:36:31 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/YjL/fortnite-memory-sequence-device
# ------

# Memory Sequence Device
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }

# This tag is used to identify devices that are part of the memory sequence.
memory_sequence_item_tag := class(tag){}

# We use a creative device to store and use both the "interaction" device and the "viewer" device in a single device
# that we can find via gameplay tags.
# We must do this since there must be a 1:1 relationship between the device the player interacts with and the device that
# is used to "show" the sequence.
# Retrieving devices with gameplay tags doesn't guarantee a specific order, which means that the nth interaction device might not
# match the nth viewer device. For example, the third button might not visually match the third cinematic sequence device.
memory_sequence_item := class(creative_device):
    # We use a button to detect the player interacting with the memory_sequence_item.
    # You can use any other device that works for your experience and modify how you signal ItemInteractedEvent accordingly.
    @editable
    Button:button_device = button_device{}
    # We use a cinematic_sequence_device to show the memory_sequence_item activation.
    # You can use any other device that works for your experience and modify Play accordingly.
    @editable
    Cinematic:cinematic_sequence_device = cinematic_sequence_device{}

    # This event is raised each time the device the player interacts with is used.
    # We use this instead of directly using the interactable device events to enable easier customization.
    # You just need to change how the ItemInteractedEvent is signaled and your interactable device type, without
    # further modifications to the code that uses the memory_sequence_item.
    ItemInteractedEvent:event(?agent) = event(?agent){}

    # Play/activates the device used to "show" this memory_sequence_item.
    # We StoppedEvent.Await() to let the sequence play until the end before resuming execution of the caller,
    # so the function <suspends>. In this case the caller can avoid being blocked by spawning this method (or branching).
    # Customize what your memory_sequence_item shows by modifying this method.
    Play<public>()<suspends>:void=
        Cinematic.Play()
        Cinematic.StoppedEvent.Await()

    SetInteractionEnabled(Enabled:logic):void=
        if (Enabled?) then Button.Enable() else Button.Disable()
    
    OnBegin<override>()<suspends>:void= 
        # This loop handles player (Agent) interactions with the button and signals the ItemInteractedEvent each time that happens.
        # You can modify this if you change your interactable device.
        loop:
            # For example, if you used a trigger_device, you'd write Agent:?agent := Trigger.TriggeredEvent.Await()
            Agent := Button.InteractedWithEvent.Await()
            ItemInteractedEvent.Signal(option{Agent}) # We're using an optional agent in case the device event we're using doesn't provide one.

# The memory_sequence_device is the main device that controls the memory sequence.
# It resembles the "Simon Says" game, where the player has to remember the sequence of items and interact with them in the correct order.
# You can customize the sequence length, the devices used to interact with the sequence and the devices used to "show" the sequence.
# It stores the sequence items and handles player interactions with the sequence.
# It provides public events (SequenceAdvancedEvent, SequenceCompletedEvent, SequenceErrorEvent) that can be used to control the flow of the experience.
# It uses gameplay tags to find the sequence items (memory_sequence_item) at runtime.
memory_sequence_device := class(creative_device):
    @editable
    SequenceLength<public>:int = 5
    # The button that starts the memory sequence.
    @editable
    StartButton:button_device = button_device{}
    @editable
    CorrectCinematic:cinematic_sequence_device = cinematic_sequence_device{}
    @editable
    ErrorCinematic:cinematic_sequence_device = cinematic_sequence_device{}
    @editable
    CompletedCinematic:cinematic_sequence_device = cinematic_sequence_device{}
    # This event is signaled when the player interacts correctly with all items in the current sequence and the sequence advances (increasing the number of items in the sequence).
    SequenceAdvancedEvent<public>:event() = event(){}
    # This event is signaled when the complete sequence has been interacted with in the correct order.
    SequenceCompletedEvent<public>:event() = event(){}
    # This event is signaled when the player interacts with the sequence in the wrong order.
    SequenceErrorEvent<public>:event() = event(){}

    var SequenceItems<private>:[]memory_sequence_item = array{}
    # Tracks which sequence item based on CorrectSequence the player should interact with next.
    var NextItemIndex<private>:int = 0 
    # Tracks the maximum sequence item the player has reached in the CorrectSequence.
    var ReachedItemIndex<private>:int = 0 
    var CorrectSequence<private>:[]int = array{}

    SetItemsInteractionEnabled(Enabled:logic):void=
        for (Item:SequenceItems) do Item.SetInteractionEnabled(Enabled)

    # Play the CorrectSequence from the start to the LastIndex.
    PlayCorrectSequenceToIndex<public>(LastIndex:int)<suspends>:void=
        for (X := 0..LastIndex, Item := SequenceItems[CorrectSequence[X]]):
            Item.Play()

    ResetSequence<public>():void=
        set NextItemIndex = 0
        set ReachedItemIndex = 0

    # Handles player interactions with the sequence items.
    # Either advances the sequence or resets it if the player interacts with the wrong sequence item.
    OnSequenceItemInteracted<private>(Item:memory_sequence_item, ItemIndex:int)<suspends>:void=
        loop:
            Item.ItemInteractedEvent.Await() # Wait for the player to interact with the sequence item.
            Print("Button {ItemIndex} interacted")

            SetItemsInteractionEnabled(false) # Disable item interactions while we're playing items from the sequence.
            Item.Play() # Play the item the player has interacted with to provide feedback.
            if (ItemIndex = CorrectSequence[NextItemIndex]):
                # The player interacted with the correct sequence item.
                # We advance what the next item should be.
                set NextItemIndex += 1
                Print("Correct item.")

                if (NextItemIndex = SequenceLength):
                    # When the NextItemIndex equals the SequenceLength, it means the player has completed the full sequence.
                    # For example, with a max SequenceLength of 3, when NextItemIndex = 3, it means the player has completed a sequence of item indices 0, 1 ,2 = 3 Length.
                    Print("Sequence completed")
                    SequenceCompletedEvent.Signal()
                    CompletedCinematic.StoppedEvent.Await() # Wait a bit so the player sees the completed light.
                    PlayCorrectSequenceToIndex(SequenceLength - 1) # Play a "victory-lap" of the whole sequence to show the player they've completed the sequence.
                    ResetSequence()
                else if (NextItemIndex > ReachedItemIndex):
                    # If the player has interacted with all sequence items up to the ReachedItemIndex in the correct order, advance the sequence.
                    Print("Advance sequence")
                    set ReachedItemIndex += 1
                    SequenceAdvancedEvent.Signal()
                    CorrectCinematic.StoppedEvent.Await() # Wait so the player sees the correct light.
                    set NextItemIndex = 0 # We've advanced the sequence, so the next item should be the first again
                    PlayCorrectSequenceToIndex(ReachedItemIndex) # Show the next sequence the player should replicate

            else:
                Print("Wrong item, sequence reset.")
                # The player interacted with the wrong sequence item.
                # Reset the sequence and play the first sequence item.
                SequenceErrorEvent.Signal()
                ResetSequence()
                ErrorCinematic.StoppedEvent.Await() # Wait so the player sees the error light.
                PlayCorrectSequenceToIndex(0)
            
            SetItemsInteractionEnabled(true) # Reenable items interactions after processing is done.

    OnStartButton(Agent:agent):void= 
        ResetSequence()
        # Create a random sequence of the indices of the SequenceItems array that the player must interact with in order.
        set CorrectSequence = for (X := 0..SequenceLength) do GetRandomInt(0, SequenceItems.Length - 1)
        
        # Start playing the sequence
        spawn{PlayCorrectSequenceToIndex(0)}
        
    OnBegin<override>()<suspends>:void=
        # Find all devices that have been tagged with memory_sequence_item_tag
        TaggedDevices := GetCreativeObjectsWithTag(memory_sequence_item_tag{})
        # Check which ones are memory_sequence_item by casting to that type. If the cast succeeds, we return the SequenceItem.
        # Recall that the last expression of a for loop yields its value and appends it to the array returned by the for.
        # In this case, we create an array of each value SequenceItem assumes: a reference to a memory_sequence_item -> []memory_sequence_item.
        set SequenceItems = for (FoundObject:TaggedDevices, SequenceItem := memory_sequence_item[FoundObject]) do SequenceItem

        # Spawn OnSequenceItemInteracted for each sequence item to handle player interactions.
        # We do it here instead of when finding the sequence items so that we can use the correct indices
        # in case other non-memory_sequence_item devices are tagged with memory_sequence_item_tag.
        for (ItemIndex -> Item:SequenceItems):
            Print("Spawning handler for Item {ItemIndex}")
            spawn{OnSequenceItemInteracted(Item, ItemIndex)}

        StartButton.InteractedWithEvent.Subscribe(OnStartButton)

        # This is how you could detect the memory_sequence_device events to respond to them.
        loop:
            race:
                block:
                    SequenceAdvancedEvent.Await()
                    CorrectCinematic.Play()
                    CorrectCinematic.StoppedEvent.Await()
                block:
                    SequenceErrorEvent.Await()
                    ErrorCinematic.Play()
                    ErrorCinematic.StoppedEvent.Await()
                block:
                    SequenceCompletedEvent.Await()
                    CompletedCinematic.Play()
                    CompletedCinematic.StoppedEvent.Await()
