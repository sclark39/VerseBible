# Title: Perception Trigger Device
# Subtitle: Given a reference to a perception trigger device and a given item granter, enables the granter when in players' sight and after a cancel-able delay.
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Sat Jun 10 2023 22:25:19 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jun 10 2023 22:25:19 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/gzlm/fortnite-perception-trigger-device
# ------

# see_grant_device.verse
# Note: None
using {/Fortnite.com/Devices}
using {/UnrealEngine.com/Temporary/Diagnostics}
using {/Verse.org/Simulation}
see_grant_device:=class<concrete>(creative_device):
    var Cancel:logic = false
    @editable
    Sensor:perception_trigger_device=perception_trigger_device{}
    @editable
    Spawner:item_spawner_device=item_spawner_device{}
    OnBegin<override>()<suspends>:void=
        Spawner.Enable()
        Sensor.AgentLooksAtDeviceEvent.Subscribe(OnLookAt)
        Sensor.AgentLooksAwayFromDeviceEvent.Subscribe(OnLookAway)
    OnAtTimeout()<suspends> : void =
        if(not (Cancel?)):
            Sleep(1.125)
            if(not (Cancel?)):
                Spawner.Enable()
    OnLookAway(Agent:agent):void=
        Spawner.Disable()
        set Cancel = true
    OnLookAt(Agent:agent):void=
        set Cancel=false
        spawn{OnAtTimeout()}
