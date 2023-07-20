# Title: Wanted Level Script
# Subtitle: None
# Author: [h1] Cubed [ /community/profile/jAWe/xCUBDd ]
# Created: Thu Dec 15 2022 22:37:05 GMT+0000 (Coordinated Universal Time)
# Last Updated: Thu Dec 15 2022 22:37:05 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/GEN/fortnite-wanted-level-script
# ------

# None
# Note: None
<## DESCRIPTION ## =================##  
            ##WANTED LEVEL##                                                                                                                   
By: GitHub.com/Cubed | Twitter: @itsUnreleased                                                                                       
Version: 1.0
Published: 12.14.2022                                                                                                             
Revised On: 12.14.2022     

----
With inspiration from:
    AxelCapek
    Ray Benefield
----
## DESCRIPTION ## ==================##>

using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Native }
using { /Verse.org/Simulation}
using { /EpicGames.com/Temporary/Diagnostics }
using { /EpicGames.com/Temporary/UI}
using { /EpicGames.com/Temporary/SpatialMath }

wanted_level_device := class(creative_device):

    #Editable properties in Verse Device.
    #This is used to play music when wanted level sequence begins.
    @editable
    AudioPlayer:audio_player_device = audio_player_device{}
    #This is used to track the score and would be implemented so that when an enemy is eliminated, it increases wanted level.
    @editable
    Tracking:tracker_device = tracker_device{}
    @editable
    #I don't remember why I implemented this. I'm still learning Creative mode devices.
    CheckingKill:team_settings_and_inventory_device = team_settings_and_inventory_device{}
    #Proof of concept. Use button to show increase in wanted level. Once multiplayer for UEFN is implemented, we can use tracker.
    @editable
    Button:button_device = button_device{}
    #Not yet implemented.
    @editable
    var maxWantedLevel : int = 5
    #This is for debugging purposes. Increase to activate wanted sequence on level start.
    @editable
    var numKills : int = 0
    #Not yet implemented. Set how many kills to be eligible for level wanted.
    @editable
    var lvlOneKillEligible : int = 0
    #Not yet implemented. Set how many kills to be eligible for level wanted.
    @editable
    var lvlTwoKillEligible : int = 0
    #Not yet implemented. Set how many kills to be eligible for level wanted.
    @editable
    var lvlThreeKillEligible : int = 0
    #Not yet implemented. Set how many kills to be eligible for level wanted.
    @editable
    var lvlFourKillEligible : int = 0
    #Not yet implemented. Set how many kills to be eligible for level wanted.
    @editable
    var lvlFullKillEligible : int = 0

    #Variables
    var Canvas :? canvas = false
    var isWanted : logic = false
    

    #Begin
    OnBegin<override>()<suspends>:void = {
        #For testing purposes at the moment. On button press, increase wanted level.
        Button.InteractedWithEvent.Subscribe(WantedLevelSequence)
    }      
    
    
    WantedLevelSequenceBegin(Player:player):void = {
    #If player already has a Canvas, remove it and set from options.
        if (PlayerUI := GetPlayerUI[Player]) {
            if (ExistingCanvas := Canvas?) {
                PlayerUI.RemoveWidget(ExistingCanvas)
                set Canvas = false
                if (isWanted?){
                
                case(numKills):
                    1 =>
                        NewCanvas := WantedOne()
                        PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                        set Canvas = option{NewCanvas}
                    2 =>
                        NewCanvas := WantedTwo()
                        PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                        set Canvas = option{NewCanvas}
                    3=>
                        NewCanvas := WantedThree()
                        PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                        set Canvas = option{NewCanvas}
                    4 =>
                        NewCanvas := WantedFour()
                        PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                        set Canvas = option{NewCanvas}
                    5 =>
                        NewCanvas := WantedFull()
                        PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                        set Canvas = option{NewCanvas}                       
                    _ =>
                        NewCanvas := WantedFull()
                        PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                        set Canvas = option{NewCanvas}
            }

        }
            
            
            else {
    #If player doesn't canvas, set from options.
                if (isWanted?){
                    case(numKills):
                        1 =>
                            NewCanvas := WantedOne()
                            PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                            set Canvas = option{NewCanvas}
                        2 =>
                            NewCanvas := WantedTwo()
                            PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                            set Canvas = option{NewCanvas}
                        3=>
                            NewCanvas := WantedThree()
                            PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                            set Canvas = option{NewCanvas}
                        4 =>
                            NewCanvas := WantedFour()
                            PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                            set Canvas = option{NewCanvas}
                        5 =>
                            NewCanvas := WantedFull()
                            PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                            set Canvas = option{NewCanvas}                       
                        _ =>
                            NewCanvas := WantedFull()
                            PlayerUI.AddWidget(NewCanvas, player_ui_slot{ InputMode := ui_input_mode.None })
                            set Canvas = option{NewCanvas}
                }
            }
        }
    }

    #Not entirely sure if this is the best way of doing this. I'd like the canvas to change dynamically if possible.
    WantedFull():canvas = {
        WantedLevel:text_block= text_block { DefaultText := "⭐⭐⭐⭐⭐" }
        YouAreWanted:text_block = text_block { DefaultText := "YOU ARE WANTED: "}
        NewCanvas := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{ Maximum:= vector2{X:=1.0, Y:=1.0} }
                    Offsets := margin{ Top:=100.0, Left:= 1200.0, Right:=700.0, Bottom := 100.0 }
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Left
                                VerticalAlignment := vertical_alignment.Top
                                Widget := YouAreWanted
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Right
                                VerticalAlignment := vertical_alignment.Top
                                Widget := WantedLevel
        return NewCanvas
    }

    WantedFour():canvas = {
        WantedLevel:text_block= text_block { DefaultText := "⭐⭐⭐⭐ " }
        YouAreWanted:text_block = text_block { DefaultText := "YOU ARE WANTED: "}
        NewCanvas := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{ Maximum:= vector2{X:=1.0, Y:=1.0} }
                    Offsets := margin{ Top:=100.0, Left:= 1200.0, Right:=700.0, Bottom := 100.0 }
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Left
                                VerticalAlignment := vertical_alignment.Top
                                Widget := YouAreWanted
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Right
                                VerticalAlignment := vertical_alignment.Top
                                Widget := WantedLevel
        return NewCanvas
    }
    WantedThree():canvas = {
        WantedLevel:text_block= text_block { DefaultText := "⭐⭐⭐  " }
        YouAreWanted:text_block = text_block { DefaultText := "YOU ARE WANTED: "}
        NewCanvas := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{ Maximum:= vector2{X:=1.0, Y:=1.0} }
                    Offsets := margin{ Top:=100.0, Left:= 1200.0, Right:=700.0, Bottom := 100.0 }
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Left
                                VerticalAlignment := vertical_alignment.Top
                                Widget := YouAreWanted
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Right
                                VerticalAlignment := vertical_alignment.Top
                                Widget := WantedLevel
        return NewCanvas
    }
    WantedTwo():canvas = {
        WantedLevel:text_block= text_block { DefaultText := "⭐⭐   " }
        YouAreWanted:text_block = text_block { DefaultText := "YOU ARE WANTED: "}
        NewCanvas := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{ Maximum:= vector2{X:=1.0, Y:=1.0} }
                    Offsets := margin{ Top:=100.0, Left:= 1200.0, Right:=700.0, Bottom := 100.0 }
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Left
                                VerticalAlignment := vertical_alignment.Top
                                Widget := YouAreWanted
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Right
                                VerticalAlignment := vertical_alignment.Top
                                Widget := WantedLevel
        return NewCanvas
    }
    WantedOne():canvas = {
        WantedLevel:text_block= text_block { DefaultText := "⭐    " }
        YouAreWanted:text_block = text_block { DefaultText := "YOU ARE WANTED: "}
        NewCanvas := canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{ Maximum:= vector2{X:=1.0, Y:=1.0} }
                    Offsets := margin{ Top:=100.0, Left:= 1200.0, Right:=700.0, Bottom := 100.0 }
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Left
                                VerticalAlignment := vertical_alignment.Top
                                Widget := YouAreWanted
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Right
                                VerticalAlignment := vertical_alignment.Top
                                Widget := WantedLevel
        return NewCanvas
    }

    
    #On kill detected, the numKills gets increased and AudioPlayer is activated and isWanted is set true. Then LevelSequenceBeings.
    WantedLevelSequence(Player:player) : void = {
        Print("DEBUG: Wanted Level Sequence Activated!")
        set numKills += 1
        Print("DEBUG: You currently have {numKills} kills!")
        if (numKills >= 1) {
            set isWanted = true
            AudioPlayer.Activate()
            
        }
        WantedLevelSequenceBegin(Player)
    }

    WantedLevelSequenceEnd(Player:player) : void = {
        Print("Debug: NOT YET IMPLEMENTED")
    }

    #TODO: Create music device that plays music during this event. Plays different music per wanted level (using music stems from previous Fortnite event).

