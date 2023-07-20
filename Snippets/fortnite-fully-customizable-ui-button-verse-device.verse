# Title: Fully customizable UI Button verse device
# Subtitle: The provided coding snippet features a versatile verse device designed to offer complete control over customizable clickable UI buttons. This includes: Position, size AND style!
# Author: DragonRage [ /community/profile/WbQ3w/DragonRage508 ]
# Created: Mon Jul 17 2023 16:33:22 GMT+0000 (Coordinated Universal Time)
# Last Updated: Mon Jul 17 2023 16:33:22 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/0pVb/fortnite-fully-customizable-ui-button-verse-device
# ------

# UI device
# Note: None
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

########  ########     ###     ######    #######  ##    ## ########     ###     ######   ######## 
##     ## ##     ##   ## ##   ##    ##  ##     ## ###   ## ##     ##   ## ##   ##    ##  ##       
##     ## ##     ##  ##   ##  ##        ##     ## ####  ## ##     ##  ##   ##  ##        ##       
##     ## ########  ##     ## ##   #### ##     ## ## ## ## ########  ##     ## ##   #### ######   
##     ## ##   ##   ######### ##    ##  ##     ## ##  #### ##   ##   ######### ##    ##  ##       
##     ## ##    ##  ##     ## ##    ##  ##     ## ##   ### ##    ##  ##     ## ##    ##  ##       
########  ##     ## ##     ##  ######    #######  ##    ## ##     ## ##     ##  ######   ######## 

# Locks the choice of button styles to the current three: {button_loud = 1, button_quiet = 2, button_regular = 3}
buttonchoice_int := type{_X : int where 1 <= _X, 3 >= _X}

menumanagerdevice := class(creative_device):

    # The trigger that will open up this ui menu
    @editable TriggerToShowUI : trigger_device = trigger_device{}

    # An array of button ui, configurable via the editor
    @editable var ButtonUI : []buttonui = array{}

    var MaybeMyUIPerPlayer : [player]?canvas = map{}

    StringToMessage<localizes>(String : string):message = "{String}"
    
    OnBegin<override>()<suspends>:void=
        InitButtonFunctions()
        TriggerToShowUI.TriggeredEvent.Subscribe(OpenUI)

    OpenUI(Agent : ?agent):void=
        if(ValidAgent := Agent?, Player := player[ValidAgent], PlayerUI := GetPlayerUI[Player]):
            if(MyUI := MaybeMyUIPerPlayer[Player]?):
                PlayerUI.RemoveWidget(MyUI)
                if(set MaybeMyUIPerPlayer[Player] = false) {}
            else:
                NewUI := CreateMyUI(ValidAgent)
                PlayerUI.AddWidget(NewUI, player_ui_slot{InputMode := ui_input_mode.All})
                if(set MaybeMyUIPerPlayer[Player] = option{NewUI}) {}

    CreateMyUI(Agent : agent) : canvas = 
        for(CurrButtonUI : ButtonUI):
            case(CurrButtonUI.ButtonStyle):
                1 => 
                    ThisButtonUI := button_loud{DefaultText := StringToMessage(CurrButtonUI.ButtonText)}
                    ThisButtonUI.OnClick().Subscribe(HandleSelectedUIButton)
                    if(set CurrButtonUI.ButtonWidgetPerPlayer[Agent] = ThisButtonUI){}
                2 =>
                    ThisButtonUI := button_quiet{DefaultText := StringToMessage(CurrButtonUI.ButtonText)}
                    ThisButtonUI.OnClick().Subscribe(HandleSelectedUIButton)
                    if(set CurrButtonUI.ButtonWidgetPerPlayer[Agent] = ThisButtonUI){}
                3 =>
                    ThisButtonUI := button_regular{DefaultText := StringToMessage(CurrButtonUI.ButtonText)}
                    ThisButtonUI.OnClick().Subscribe(HandleSelectedUIButton)
                    if(set CurrButtonUI.ButtonWidgetPerPlayer[Agent] = ThisButtonUI){}
                _ => 
                    Print("~ERROR: ButtonStyle integer over/under-flow")
        CanvasArray := ReturnCanvasSlots(Agent)
        MyInteractableButtons : canvas = canvas:
            Slots := CanvasArray
        return MyInteractableButtons

    ReturnCanvasSlots(Agent : agent):[]canvas_slot=
        var CanvasSlotArray : []canvas_slot = array{}
        for(ThisButtonUI : ButtonUI):
            if(ThisWidget := ThisButtonUI.ButtonWidgetPerPlayer[Agent]):
                Agent.LoadButtonState(ThisButtonUI)
                ThisSlot := canvas_slot:
                    Offsets := margin{Top := ThisButtonUI.ButtonPosition.Y, Left := ThisButtonUI.ButtonPosition.X, Bottom := ThisButtonUI.ButtonSize.Y, Right := ThisButtonUI.ButtonSize.X}
                    ZOrder := 0
                    SizeToContent := ThisButtonUI.SizeToContent
                    Widget := ThisWidget
                set CanvasSlotArray += array{ThisSlot}
        return CanvasSlotArray

    DeleteUI(Message : widget_message) : void=
        if(PlayerUI := GetPlayerUI[Message.Player], MyUI := MaybeMyUIPerPlayer[Message.Player]?):
            PlayerUI.RemoveWidget(MyUI)
            if(set MaybeMyUIPerPlayer[Message.Player] = false) {}
                
    HandleSelectedUIButton(Message : widget_message):void=
        if(PlayerUI := GetPlayerUI[Message.Player], MyUI := MaybeMyUIPerPlayer[Message.Player]?):
            Player := Message.Player
            ThisWidget := Message.Source
            StaleButtonUI := Player.FindButtonUI(ThisWidget)
            if(ThisButtonUI := StaleButtonUI?):
                if(ThisButtonUI.RemovesUIOnClick?):
                    DeleteUI(Message)
                ThisButtonUI.ActivateTrigger(Player)
            else:
                Print("~ERROR: No buttonui found!")
                
    (Agent : agent).FindButtonUI(ThisWidget : widget):?buttonui=
        for(ThisButtonUI : ButtonUI):
            if(StaleWidget := ThisButtonUI.ButtonWidgetPerPlayer[Agent]):
                if(ThisWidget = StaleWidget):
                    return option{ThisButtonUI}
        return false

    (ThisButtonUI : buttonui).ActivateTrigger(Player : player):void=
        ThisSignalDestination := ThisButtonUI.ButtonSignal_Send
        if(ThisSignalDestination.SendInstigator?):
            ThisSignalDestination.TriggerToActivate.Trigger(Player)
        ThisSignalDestination.TriggerToActivate.Trigger()

    # Loads all button states that have 'SaveButtonState' turned on
    (Agent : agent).LoadButtonState(ThisButtonUI : buttonui):void=
        if(ThisButtonUI.SaveButtonState?):
            if(ThisWidget := ThisButtonUI.ButtonWidgetPerPlayer[Agent]):
                if(ThisEnabledState := ThisButtonUI.EnabledStateMap[Agent]):
                    ThisWidget.SetEnabled(ThisEnabledState)
                if(ThisVisibleState := ThisButtonUI.VisibleStateMap[Agent]):
                    case(ThisVisibleState):
                        true => ThisWidget.SetVisibility(widget_visibility.Visible)
                        false => ThisWidget.SetVisibility(widget_visibility.Collapsed)
                        _ => Print("~ERROR: Failed to fetch 'ThisVisibleState")
            else:
                Print("~ERROR: Failed to fetch widget!")

    # Initializes the 'functions' tab for each button ui
    InitButtonFunctions():void=
        for(ThisButtonUI : ButtonUI):
            ThisButtonUI.ButtonSignal_Recieve.EnableButtonOnTrigger.TriggeredEvent.Subscribe(ThisButtonUI.EnableWidget) 
            ThisButtonUI.ButtonSignal_Recieve.DisableButtonOnTrigger.TriggeredEvent.Subscribe(ThisButtonUI.DisableWidget) 
            ThisButtonUI.ButtonSignal_Recieve.ShowButtonOnTrigger.TriggeredEvent.Subscribe(ThisButtonUI.ShowWidget)
            ThisButtonUI.ButtonSignal_Recieve.HideButtonOnTrigger.TriggeredEvent.Subscribe(ThisButtonUI.HideWidget)

buttonui := class<concrete>():

    @editable var ButtonText : string = ""
    @editable var ButtonPosition : vector2 = vector2{}
    @editable var ButtonSize : vector2 = vector2{X := 475.0, Y:= 80.0}

    # 'ButtonStyle' key: {button_loud = 1, button_quiet = 2, button_regular = 3}
    @editable var ButtonStyle : buttonchoice_int = 3

    @editable var RemovesUIOnClick : logic = true

    # Saves the state the button is in even after exiting. Example: Hiding a button, exiting the ui, and then opening the ui will still have that button hidden
    @editable SaveButtonState : logic = false
    
    @editable ButtonSignal_Recieve : ButtonUI_UserOptions_Functions = ButtonUI_UserOptions_Functions{}
    @editable ButtonSignal_Send : ButtonUI_UserOptions_Events = ButtonUI_UserOptions_Events{}

    var SizeToContent : logic = false

    var ButtonWidgetPerPlayer : [agent]widget = map{}

    var EnabledStateMap : [agent]logic = map{}
    var VisibleStateMap : [agent]logic = map{}

    EnableWidget(Agent : ?agent):void=
        if(ValidAgent := Agent?, ThisButtonWidget := ButtonWidgetPerPlayer[ValidAgent]):
            ThisButtonWidget.SetEnabled(true)
            if(SaveButtonState?):
                ValidAgent.SaveEnabledState(true)

    # Fades the button ui
    DisableWidget(Agent : ?agent):void=
        if(ValidAgent := Agent?, ThisButtonWidget := ButtonWidgetPerPlayer[ValidAgent]):
            ThisButtonWidget.SetEnabled(false)
            if(SaveButtonState?):
                ValidAgent.SaveEnabledState(false)

    # Saves the enabled state the button is currently in
    (Agent : agent).SaveEnabledState(State : logic):void=
        if(CurrentState := EnabledStateMap[Agent]):
            if(set EnabledStateMap[Agent] = State){}
        else:
            set EnabledStateMap = ConcatenateMaps(EnabledStateMap, map{Agent => State})

    ShowWidget(Agent : ?agent):void=
        if(ValidAgent := Agent?, ThisButtonWidget := ButtonWidgetPerPlayer[ValidAgent]):
            ThisButtonWidget.SetVisibility(widget_visibility.Visible)
            if(SaveButtonState?):
                ValidAgent.SaveVisibleState(true)

    # Completely removes the button ui
    HideWidget(Agent : ?agent):void=
        if(ValidAgent := Agent?, ThisButtonWidget := ButtonWidgetPerPlayer[ValidAgent]):
            ThisButtonWidget.SetVisibility(widget_visibility.Collapsed)
            if(SaveButtonState?):
                ValidAgent.SaveVisibleState(false)

    # Saves the visible state the button is currently in
    (Agent : agent).SaveVisibleState(State : logic):void=
        if(CurrentState := VisibleStateMap[Agent]):
            if(set VisibleStateMap[Agent] = State){}
        else:
            set VisibleStateMap = ConcatenateMaps(VisibleStateMap, map{Agent => State})

ButtonUI_UserOptions_Functions := class<concrete>():

    # The trigger that will enable this ui button, making it 'un-fade' and clickable
    @editable EnableButtonOnTrigger : trigger_device = trigger_device{}

    # The trigger that will disable this ui button, making it 'fade' and unclickable
    @editable DisableButtonOnTrigger : trigger_device = trigger_device{}

    # The trigger that will show this ui button, making it visible and clickable
    @editable ShowButtonOnTrigger : trigger_device = trigger_device{}

    # The trigger that will hide this ui button, making it not visible at all and therefore unclickable
    @editable HideButtonOnTrigger : trigger_device = trigger_device{}

ButtonUI_UserOptions_Events := class<concrete>():

    # The trigger/destination to activate
    @editable TriggerToActivate : trigger_device  = trigger_device{}

    # Do we send the instigator of the UI button?
    @editable SendInstigator : logic = true
