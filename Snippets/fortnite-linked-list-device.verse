# Title: Linked List Device
# Subtitle: Using a generic creative device type you can avoid circular class definitions using a cast, to create a recursive type list this, sort of, Listed List Device.
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Fri Jun 30 2023 02:31:37 GMT+0000 (Coordinated Universal Time)
# Last Updated: Fri Jun 30 2023 02:31:37 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/dLLJ/fortnite-linked-list-device
# ------

# linked.verse
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
delay_trigger_link := class(linked):
    @editable
    DelaySeconds:float = 1.0
    @editable
    Trigger:trigger_device = trigger_device{}
    Activate<override>():void=
        if(DelaySeconds=0.0):
            Print("Delay bypassed.")
            if(not Root?):
                Trigger.Trigger()
            (super:)Activate()
        else:
            spawn. DelayedActivation()
    DelayedActivation()<suspends>:void=
        Sleep(DelaySeconds)
        #do something
        if(not Root?):
            Trigger.Trigger()
        if(LinkedNext:=linked[Next]):
            LinkedNext.Activate()
    Triggered(A:?agent):void=
        Activate()
    OnBegin<override>()<suspends>:void=
        if(Root?):
            Trigger.TriggeredEvent.Subscribe(Triggered)
delay_link := class(linked):
    @editable
    DelaySeconds:float = 1.0
    Activate<override>():void=
        if(DelaySeconds=0.0):
            #do something
            (super:)Activate()
        else:
            spawn. DelayedActivation()
    DelayedActivation()<suspends>:void=
        Sleep(DelaySeconds)
        #do the thing again
        if(LinkedNext:=linked[Next]):
            LinkedNext.Activate()
trigger_link := class(linked):
    @editable
    Trigger:trigger_device = trigger_device{}
    Activate<override>():void=
        if(not Root?):
            Trigger.Trigger()
        (super:)Activate()
    Triggered(A:?agent):void=
        Activate()
    OnBegin<override>()<suspends>:void=
        if(Root?):
            Trigger.TriggeredEvent.Subscribe(Triggered)
linked := class(creative_device):
    @editable
    Root:logic = false
    @editable
    Next:creative_device = creative_device{}
    Activate<public>():void=
        #do something
        if(LinkedNext:=linked[Next]):
            LinkedNext.Activate()
    OnBegin<override>()<suspends>:void=
        if(Root?):
            Activate()
