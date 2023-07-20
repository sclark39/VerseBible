# Title: Awaiting Custom Event
# Subtitle: Demonstrates how you can subscribe to an event by calling Await(), as well as publishing an event using Signal().
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Tue Jun 20 2023 12:55:08 GMT+0000 (Coordinated Universal Time)
# Last Updated: Tue Jun 20 2023 12:55:08 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/DeKg/fortnite-awaiting-custom-event
# ------

# Test Event Devices (event_device.verse)
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
event_tag := class(tag){}
event_device := class(creative_device):
    Event<public>:event() = event(){}
    Emit<public>():void=
        Event.Signal()
pub_sub_device := class(creative_device):
    #@editable # alternative to using event_tag:
    #Emits:event_device = event_device{}
    Subscribe(TaggedDevice:event_device)<suspends>:void=
        TaggedDevice.Event.Await()
        spawn{Subscribe(TaggedDevice)} #if retriggerable
        Print("Hello, event")
    OnBegin<override>()<suspends>:void=
        All := GetCreativeObjectsWithTag(event_tag{})
        for (Tagged : All, TaggedDevice := event_device[Tagged]):
            spawn{Subscribe(TaggedDevice)} # subscribe example
            TaggedDevice.Emit()            # publish example
