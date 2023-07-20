# Title: Hello Button
# Subtitle: Here are three examples of using conditional buttons with increasing levels of futility answering how to enable buttons on start. Conditional buttons were chosen because they have an activate method, like a trigger, but unlike the standard button.
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Sat Jun 10 2023 22:20:00 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jun 10 2023 22:20:00 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/aAk0/fortnite-hello-button
# ------

# hello_button_device.verse
# Note: The item required count is set from the default assignable of >1 to zero enabling the button on start.
using {/Fortnite.com/Devices}
using {/UnrealEngine.com/Temporary/Diagnostics}
using {/Verse.org/Simulation}
hello_button_device:=class<concrete>(creative_device):
    @editable
    Button:conditional_button_device=conditional_button_device{}
    OnBegin<override>()<suspends>:void=
        Button.SetItemCountRequired(0,0)
        Button.ActivatedEvent.Subscribe(OnButtonInteractedWith)
    OnButtonInteractedWith(InPlayer:agent):void=

