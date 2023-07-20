# Title: Cinematic Sequencer
# Subtitle: Example of a device that can be assigned a cinematic sequencer reference which the device plays for 30 seconds and stops.
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Sun Jun 11 2023 02:42:28 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sun Jun 11 2023 02:42:28 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/p8bD/fortnite-cinematic-sequencer
# ------

# hello_sequence_device.verse
# Note: None
using {/Fortnite.com/Devices}
using {/Verse.org/Simulation}
hello_sequence_device:=class<concrete>(creative_device):
    @editable
    MySequence:cinematic_sequence_device=cinematic_sequence_device{}
    OnBegin<override>()<suspends>:void=
        MySequence.Play()
        Sleep(30.0)
        MySequence.Stop()
