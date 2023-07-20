# Title: Height Meter for OnlyUp style maps
# Subtitle: None
# Author: Thomas Burns / Twin [ /community/profile/BE9bO/Twin01 ]
# Created: Wed Jun 28 2023 04:27:29 GMT+0000 (Coordinated Universal Time)
# Last Updated: Wed Jun 28 2023 04:27:29 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/rmmj/fortnite-height-meter-for-onlyup-style-maps
# ------

# None
# Note: None

using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

height_display := class(creative_device):

    var AgentMap: [player]?int = map{}
    var DisplayMap: [player]?height_widget = map{}

    OnBegin<override>()<suspends>:void=
        
        CheckForPlayers()

    CheckForPlayers()<suspends>: void =
        loop:
            Sleep(1.0)
            AllPlayers := GetPlayspace().GetPlayers()
            for (Player : AllPlayers):
                HeightWidgetInstance := height_widget{VerseDevice := Self, InstancePlayer := Player}
                PlayerHeight := GetHeight(Player)
                if (set AgentMap[Player] = option{PlayerHeight}):
                    # Print("{PlayerHeight}")
                    if (not DisplayMap[Player], set DisplayMap[Player] = option{HeightWidgetInstance}):
                        HeightWidgetInstance.CreateUIForPlayer(PlayerHeight)
                        if (Agent := agent[Player]):
                            HeightWidgetInstance.ShowUI(Agent)

    GetHeight(Player: player): int =
        if (FortCharacter := Player.GetFortCharacter[]):
            PlayerLocation := FortCharacter.GetTransform().Translation
            PlayerHeight := PlayerLocation.Z
            if (HeightInt := Floor[PlayerHeight/100.00]):
                return HeightInt

        return 0

height_widget := class():

    var VerseDevice : height_display = height_display{}
    InstancePlayer: player

    HeightText<localizes>(Height: int) : message = "Height:  {Height} Meters"
    HeightWidget : button_quiet = button_quiet{}

    var UIPerPlayer : [player]?canvas = map{}

    CreateUIForPlayer(Height: int):canvas=
        
        HeightWidget.SetText(HeightText(Height))
        MyCanvas : canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.00, Y := 0.7}, Maximum := vector2{X := 0.2, Y := 0.0}}
                    Offsets := margin{Top := 100.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := false
                    Widget := HeightWidget

    ShowUI(Agent: agent): void =
        if (Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            if (MyUI := UIPerPlayer[Player]?):
                PlayerUI.RemoveWidget(MyUI)
                if {set UIPerPlayer[Player] = false}
            else:
                NewUI := CreateUIForPlayer(0)
                PlayerUI.AddWidget(NewUI, player_ui_slot{InputMode := ui_input_mode.None})
                if (set UIPerPlayer[Player] = option{NewUI}) {}
                spawn:
                    UpdateHeight()

    UpdateHeight()<suspends>: void =
        loop:
            Sleep(0.1)
            PlayerHeight := VerseDevice.GetHeight(InstancePlayer)
            HeightWidget.SetText(HeightText(PlayerHeight))
