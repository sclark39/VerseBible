# Title: Remote Signal Function Switcher
# Subtitle: Remote signal function selector scipt. With the primary key you can call the selected function and with the secondary key you can cycle through the functions.
# Author: herbbert [ /community/profile/78AK6/herbbert ]
# Created: Mon May 29 2023 22:55:05 GMT+0000 (Coordinated Universal Time)
# Last Updated: Mon May 29 2023 22:55:05 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/W9G/fortnite-remote-signal-function-switcher
# ------

# Remote Signal Function Switcher
# Note: None
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

signal_system := class(creative_device):
    @editable RemoteSignal : signal_remote_manager_device = signal_remote_manager_device{}
    SignalFunctions:[]string = array{"TestFunc1","TestFunc2"}
    var SignalFunctionIndex:int = 0

    TextForTestFunc1<localizes> : message = "TestFunc1"
    TextForTestFunc2<localizes> : message = "TestFunc2"

    OnBegin<override>()<suspends>:void=
        RemoteSignal.PrimarySignalEvent.Subscribe(Primary)
        RemoteSignal.SecondarySignalEvent.Subscribe(Secondary)

    Primary(Agent:agent):void=
        if (stringVal := SignalFunctions[SignalFunctionIndex]):
            case(stringVal):
                "TestFunc1" =>
                    Print("TestFunc1")
                "TestFunc2" =>
                    Print("TestFunc2")
                _ =>
                    Print("Default")

    Secondary(Agent:agent):void=
        NextInArray()
        spawn{setUI(Agent)}

    setUI(Agent:agent)<suspends>:void=
        if (stringVal := SignalFunctions[SignalFunctionIndex]):
            if (InPlayer := player[Agent], PlayerUI := GetPlayerUI[InPlayer]):
                var newUI : canvas = canvas{} 
                case(stringVal):
                    "TestFunc1" =>
                        set newUI = CreateUI(text_block{DefaultText := TextForTestFunc1})
                    "TestFunc2" =>
                        set newUI = CreateUI(text_block{DefaultText := TextForTestFunc2})
                    _ =>
                        Print("Default")

                PlayerUI.AddWidget(newUI)
                Sleep(1.0)
                PlayerUI.RemoveWidget(newUI)

    CreateUI(TextForMyUI: text_block) : canvas =
        MyCanvas : canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := true
                    Widget := TextForMyUI
        return MyCanvas

    NextInArray():void=
        set SignalFunctionIndex += 1
        if (SignalFunctionIndex >= SignalFunctions.Length):
            set SignalFunctionIndex = 0


