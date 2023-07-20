# Title: Wrapping Subscribe() to pass additional data to listeners
# Subtitle: This is for when you want to Subscribe() to a listenable but you want to pass along your own data. This works for callbacks that take `agent` and those that take an empty tuple, ie. `tuple()`. See the snippet for usage examples.
# Author: MattRix [ /community/profile/bpoG6/MattRix ]
# Created: Thu May 04 2023 21:25:36 GMT+0000 (Coordinated Universal Time)
# Last Updated: Thu May 04 2023 21:25:36 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/d8k/fortnite-wrapping-subscribe-to-pass-additional-data-to-listeners
# ------

# wrap_subscribe.verse
# Note: Note: You can pass along whatever you want as the second argument. A common usage would be passing along a reference to the device that triggered the event.
#usage example (when subscribing to an event that returns an agent)
ButtonDevice.InteractedWithEvent.SubscribeAgent(OnButtonInteract, "Hello!")

OnButtonInteract(Agent : agent, Text : string) : void =
    Print("Button interacted with {Text}!")
	
#usage example (when subscribing to an event that returns tuple(), aka an empty tuple)
CampfireDevice.CampfirePulseEvent.SubscribeEmpty(OnCampfirePulse, 90210)

OnCampfirePulse(Number : int) : void =
    Print("Campfire pulse had {Number}!")

#The important code is below. Put this in one of your verse files, perhaps utils.verse or something!

using { /Verse.org/Simulation }

(Listenable : listenable(agent)).SubscribeAgent(OutputFunc : tuple(agent, t)->void, ExtraData : t where t:type) : cancelable =
    Wrapper := wrapper_agent(t){ExtraData := ExtraData, OutputFunc := OutputFunc}
    Listenable.Subscribe(Wrapper.InputFunc)

wrapper_agent(t : type) := class():
    ExtraData : t;
    OutputFunc : tuple(agent, t) -> void
    InputFunc(Agent : agent):void = OutputFunc(Agent, ExtraData)

(Listenable : listenable(tuple())).SubscribeEmpty(OutputFunc : t -> void, ExtraData : t where t:type) : cancelable =
    Wrapper := wrapper_empty(t) {ExtraData := ExtraData, OutputFunc := OutputFunc}
    Listenable.Subscribe(Wrapper.InputFunc)

wrapper_empty(t : type) := class():
    ExtraData : t;
    OutputFunc : t -> void
    InputFunc():void = OutputFunc(ExtraData)
