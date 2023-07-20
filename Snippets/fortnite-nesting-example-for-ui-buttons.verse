# Title: Nesting example for UI buttons
# Subtitle: None
# Author: mulletboy3000 [ /community/profile/x69XA/mulletboy3000 ]
# Created: Sat Jan 21 2023 22:06:24 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jan 21 2023 22:06:24 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/wWm/fortnite-nesting-example-for-ui-buttons
# ------

# None
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /EpicGames.com/Temporary/Diagnostics }
using { /Verse.org/Random }
using { /EpicGames.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /EpicGames.com/Temporary/SpatialMath }

log_learningstuff := class(log_channel){}


# A Verse-authored creative device that can be placed in a level
# 
# Getting started:
#     https://www.epicgames.com/fortnite/en-US/creative/docs/uefn/Verse/onboarding-guide-to-programming-with-verse-in-unreal-editor-for-fortnite
#
learningstuff := class(creative_device):
    Logger:log = log{Channel:=log_learningstuff}
   
        @editable
        MyButton : button_device = button_device{} 
        
       

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        MyButton.InteractedWithEvent.Subscribe(HandleInteractedWithEvent)


    # put all functions below this line
    HandleInteractedWithEvent(Player:player):void=
        if (PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(Widget)

   Widget : stack_box = stack_box:
        Orientation := orientation.Vertical
        Slots := array:
            stack_box_slot:
                Widget := stack_box:
                    Orientation := orientation.Horizontal
                    Slots := array:
                        stack_box_slot:
                            Widget := button_loud{DefaultText := "button1a"}
                        stack_box_slot:
                            Widget := button_loud{DefaultText := "button1b"}
            stack_box_slot:
                Widget := button_regular{DefaultText := "button2"}
            stack_box_slot:
                Widget := button_quiet{DefaultText := "button3"}
