# Title: Using animation_controller + MoveTo
# Subtitle: None
# Author: Rift9 [ /community/profile/KQDbl/le-8g7e ]
# Created: Sat Jun 17 2023 19:54:52 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jun 17 2023 19:54:52 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/LNNr/fortnite-using-animation_controller-moveto
# ------

# Using animation_controller + MoveTo
# Note: None
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }

# Demonstrates using the animation controller to listen for events on and stop MoveTo animations
animation_controller_example_device := class(creative_device):

    @editable
    Prop: creative_prop = creative_prop{}

    OnBegin<override>()<suspends>:void=

        if(PropAnimationController := Prop.GetAnimationController[]):
            PropAnimationController.MovementCompleteEvent.Subscribe(HandleMovementComplete)
            PropAnimationController.StateChangedEvent.Subscribe(HandleStateChangedEvent)

    
    StartAndStopMoveToExample()<suspends>:void =

        # Starts an animation on the prop and changes animation_controller state
        spawn. Prop.MoveTo(transform{}, 1.0)

        # Wait until MoveTo is half complete
        Sleep(0.5)

        # Cancel the MoveTo with the animation_controller
        if(PropAnimationController := Prop.GetAnimationController[]):
            PropAnimationController.Stop()


    # Fires when prop animation controller state changes
    HandleStateChangedEvent():void = 

        if(PropAnimationController := Prop.GetAnimationController[]):
            AnimationState := PropAnimationController.GetState()


    # Fires once MoveTo is finished
    HandleMovementComplete():void = {}
