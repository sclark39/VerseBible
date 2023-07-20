# Title: Trigger a barrier with a time limit
# Subtitle: Trigger -> TimerStart -> BarrierDown + Button -> BarrierUp -> TimerStart -> BarrierDown
# Author: Hourences [ /community/profile/BE8/Hourences ]
# Created: Wed Jul 20 2022 15:26:31 GMT+0000 (Coordinated Universal Time)
# Last Updated: Wed Jul 20 2022 15:26:31 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/Evp/fortnite-trigger-a-barrier-with-a-time-limit
# ------

# None
# Note: The Verse way to set this up
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }

barrier_timer := class<concrete>(creative_device):
    @editable
    Barrier:barrier_device = barrier_device{}
    @editable
    Trigger:trigger_device = trigger_device{}
    @editable
    BarrierButton:button_device = button_device{}
    @editable
    Timer:timer_device = timer_device{}

    OnBegin<override>()<suspends>:void=
       BarrierButton.InteractedWithEvent.Subscribe(OnButtonInteractedWith) 
       Trigger.TriggeredEvent.Subscribe(OnTriggerTriggered)
       Timer.SuccessEvent.Subscribe(DisableBarrier)

    OnButtonInteractedWith(Player:player):void=
        Barrier.Enable()
        Timer.Begin(Player)

    OnTriggerTriggered(Player:player):void=
        Timer.Begin(Player)

    DisableBarrier(Player:player):void=
        Barrier.Disable()

