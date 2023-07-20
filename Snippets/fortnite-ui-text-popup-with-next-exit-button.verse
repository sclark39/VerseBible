# Title: UI Text Popup with Next/Exit Button
# Subtitle: Displays text on a player's screen upon player interacting with a Button Device.  Next/Exit UI Button updates text to next lines in array or exits. Optional SFX and item granter. Edit UI text in the properties. Happy creating! Updated 4/1/23.
# Author: Fresnella (Formerly BlueClairy) [ /community/profile/P3jE/Fresnella ]
# Created: Sat Apr 22 2023 17:23:18 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Apr 22 2023 17:23:18 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/xP4/fortnite-ui-text-popup-with-next-exit-button
# ------

# UI Dialog Device
# Note: None
using { /Fortnite.com/Devices }                 
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Verse}
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }

    <# ===== 
    UI Dialog Device V2
    Author: BlueClairy (@BlueClairy on FN/YouTube/Twitter/Instagram)
    Inspired by RayBenefield and HugoMeta4 :) 
    Published 1/6/23        
    Updated 4/1/23
    =^..^=

    What this Verse Device does:
    - In property fields in device Details, dev can specify text strings for the UI dialog “Title”, arrays(lists) for Line 1 and Line 2 text, and text for the “Next” and “Exit” UI Buttons. Optional Item Granter and SFX.
    - Button Device interacted with ==> UI Canvas added to instigator's screen. Contains Widgets for text blocks and clickable button.
    - UI Button "Next" clicked ==> UI Text Lines update to next in array.
    - Last text lines in array shown ==> UI Button text updates to "Exit". 
    - UI Button "Exit" clicked ==> UI Canvas removed.
    ===== #>

ui_dialog_device := class(creative_device):

        # Exposed Properties Begin: (Edit in this Verse Device's details panel.) ===========================================
        
        #===== Devices =============================================================
        @editable ButtonDialogStarter: button_device = button_device {} # Necessary.
        @editable AudioUIAdd: audio_player_device = audio_player_device{} # Optional.
        @editable AudioUIRemove: audio_player_device = audio_player_device{} # Optional.
        @editable ItemGranter: item_granter_device = item_granter_device{} # Optional.

        #===== Text for UI ========================================================
        @editable TextButtonNext: string = ""
        @editable TextButtonExit: string = ""
        @editable TextTitle: string = ""
        @editable TextLine1List: []string = array{}
        @editable TextLine2List: []string = array{}

        StringToMessage<localizes>(value:string) : message = "{value}"

        # End Exposed Properties.
        # Variables Begin: (Data for this script to reference.) =====

        #===== Variables: Widgets for UI Canvas ====================================== 
        
        var WidgetLine1:text_block = text_block {DefaultTextColor := NamedColors.DarkOrchid} #Change the color of the text here
        var WidgetLine2:text_block = text_block {DefaultTextColor := NamedColors.DarkOrchid}
        var WidgetTitle:text_block = text_block {DefaultTextColor := NamedColors.RoyalBlue}
        var WidgetUIButton:button_regular=button_regular {}
 
        #==== Variables: Other ======================================================
        var MaybeMyUIPerPlayer : [player]?canvas = map{}
        var currentTextLine : int = 0 

        # End Variables.
        # Functions Begin: (Instructions to be triggered by events.) =========

        # ==== Runs when the device is started in a running game =====================
        OnBegin<override>()<suspends>:void=
            Print("UI Dialogue Device began")
            ButtonDialogStarter.InteractedWithEvent.Subscribe(HandleButtonUIAddInteraction)
            WidgetUIButton.OnClick().Subscribe(HandleUIButtonClick)
            # ^ "Subscribe" connects Button Device and UI Button to the Functions they call.
            WidgetTitle.SetText(StringToMessage(TextTitle))
            WidgetUIButton.SetText(StringToMessage(TextButtonNext))
        
        # ==== Runs when ButtonDialogStarter interacted with. ====================================
        HandleButtonUIAddInteraction(Agent:agent):void= 
            Print("Button Device interacted with")
            ButtonDialogStarter.Disable() # No other player can interact with Button Device.
            AddCanvas(Agent) 
            UpdateText(currentTextLine)
            AudioUIAdd.Play(Agent) # Optional. Plays Audio Cue
            # You could add other functions here too, like a Light, VFX, Cinematic Sequence, Switch, etc.
            

        <# === When UI Button clicked, check if currentTextline int equals index int of the last member of the TextLine1List array.
             (Aka "Is this the last part of dialog?"). If yes, call RemoveCanvas. If no, call UpdateText. #>
        HandleUIButtonClick(Message: widget_message):void= 
            Print("UI Button clicked")
            if (currentTextLine = TextLine1List.Length):
                RemoveCanvas(Message)
                set currentTextLine = 0
                WidgetUIButton.SetText(StringToMessage(TextButtonNext))
            
            else:  
                if (currentTextLine = TextLine1List.Length - 1):
                    WidgetUIButton.SetText(StringToMessage(TextButtonExit))
                    UpdateText(currentTextLine)     
            
        <# === Update text in WidgetLine1 and WidgetLine2 text blocks, ====================
            to the next members of the arrays.#>
        UpdateText(Index:int):void= 
            Print("Update text")
            if(currentStr := TextLine1List[Index]):
                WidgetLine1.SetText(StringToMessage(currentStr)) 
            if(currentStr := TextLine2List[Index]):
                WidgetLine2.SetText(StringToMessage(currentStr)) 
                set currentTextLine += 1
        
        # ==== Add UI Canvas to the instigating player's screen.===========================
        AddCanvas(Agent:agent):void=
            Print("Add canvas")
            if (InPlayer := player[Agent], PlayerUI := GetPlayerUI[InPlayer]):
                if (MyUI := MaybeMyUIPerPlayer[InPlayer]?):
                    PlayerUI.RemoveWidget(MyUI)
                    if (set MaybeMyUIPerPlayer[InPlayer] = false) {}
                else:
                    NewUI := CreateMyUI()
                    PlayerUI.AddWidget(NewUI, player_ui_slot{InputMode := ui_input_mode.All})
                    if (set MaybeMyUIPerPlayer[InPlayer] = option{NewUI}) {}
        
        # ==== Sets the formatting for the UI Canvas, and returns the canvas. You can edit the Offsets, Alignment, and Padding. =================
        # Canvas > Stack Box > Stack Box Slots > Widgets > Text.
        CreateMyUI():canvas=
            Print("Create UI")
            NewCanvas := canvas:
                Slots := array:
                    canvas_slot:
                        Anchors := anchors{ Maximum:= vector2{X:=1.0, Y:=1.0} }
                        Offsets := margin{ Top:=100.0, Left:= 600.0, Right:=600.0, Bottom := 850.0 } # Screen position of the UI canvas, measured in pixels from edges.
                        Widget := stack_box:
                            Orientation := orientation.Vertical
                            Slots := array:
                                stack_box_slot:
                                    HorizontalAlignment := horizontal_alignment.Left # Alignment of widget within slot.
                                    Padding := margin{ Bottom:= 20.0} # Empty space between Title and Lines, in pixels.
                                    Widget := WidgetTitle
                                stack_box_slot:
                                    HorizontalAlignment := horizontal_alignment.Left
                                    Padding := margin{ Left:= 50.0} # Empty space for left indent.(Optional)
                                    Widget := WidgetLine1 
                                stack_box_slot:
                                    HorizontalAlignment := horizontal_alignment.Left
                                    Padding := margin{ Left:= 50.0}
                                    Widget := WidgetLine2 
                                stack_box_slot:
                                    HorizontalAlignment := horizontal_alignment.Right
                                    Padding := margin{ Top:= 20.0} # Empty space between lines and button.
                                    Widget := WidgetUIButton
                                           
            return NewCanvas
        
        # ==== Remove UI Canvas from instigating player's screen. ============================================
        RemoveCanvas(Message: widget_message):void=
            if (PlayerUI := GetPlayerUI[Message.Player], MyUI := MaybeMyUIPerPlayer[Message.Player]?, SelectedButton := text_button_base[Message.Source]):
                Print("Remove Canvas")
                PlayerUI.RemoveWidget(MyUI)
                ButtonDialogStarter.Enable() 
                if (set MaybeMyUIPerPlayer[Message.Player] = false) {} # Make Button Device interactable again.
                    AudioUIRemove.Play(Message.Player)
                    ItemGranter.GrantItem(Message.Player) # Optional. Grants gift/reward to Player.
                    <# ^ Call (Message.Player) instead of (Player), because our function RemoveCanvas is widget_message type not Player type. 
                     Message.Player is a member of widget_message type. #>
                    #You could add other functions here too.
        
            
    <# That's it :) Happy building <3 <3 <3 
    - Leave feedback/questions on my UI Dialog Device Forum post: https://forums.unrealengine.com/t/ui-dialog-verse-device-with-next-exit-button-snippet/744022
    - Follow my Devlog for my UEFN game WIP, Sprigs: https://forums.unrealengine.com/t/sprigs-devlog-6-the-floor-is-lava-physical-material-experiments/657293 
    - Epic Docs webpage about Verse UI, for reference: https://dev.epicgames.com/documentation/en-us/uefn/creating-in-game-ui-in-verse                    IKB #>
