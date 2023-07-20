# Title: Customizable Height/Distance Tracker
# Subtitle: This snippet provides an easy to customize height/distance tracker. You can calculate the distance from one or more locations and customize the shown text based off of this information. The image shows 2 example configurations.
# Author: TheCreaitor [ /community/profile/k7AEO/TheCreaitor ]
# Created: Sat Jul 01 2023 15:39:17 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jul 01 2023 15:39:17 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/EKjd/fortnite-customizable-height-distance-tracker
# ------

# Distance Tracker Device
# Note: None

using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }

# Device that display the distance of a player to a certain point.
distance_tracker_device := class(creative_device):

    # The editables for the tracking.
    @editable       Tracking : tracking = tracking{}
    # The editables for the text style.
    @editable       TextStyle : text_style = text_style{}
    
    # The distance trackers assigned to a player.
    var HeightTrackers : [player]?distance_tracker = map{}

    # Function that runs on game start.
    OnBegin<override>()<suspends> : void =
        InitializePlayers()

    # Initialize the distance tracker for the players and make sure it works for players that join or leave.
    InitializePlayers() : void =
        for (Player : GetPlayspace().GetPlayers()):
            RunForPlayer(Player)

        GetPlayspace().PlayerAddedEvent().Subscribe(RunForPlayer)
        GetPlayspace().PlayerRemovedEvent().Subscribe(StopForPlayer)

    # Run a distance tracker for a player.
    RunForPlayer(Player : player) : void =
        HeightTracker := MakeDistanceTracker(Player, Self)
        if (set HeightTrackers[Player] = option{ HeightTracker }) {}
        spawn{ HeightTracker.Run() }

    # Stop the distance tracker for a player.
    StopForPlayer(Player : player) : void =
        if (HeightTracker := HeightTrackers[Player]?):
            set HeightTracker.Running = false

        if (set HeightTrackers[Player] = false) {}

# Tracking editables.
tracking := class<concrete>():
    # The locations to calculate the distance from.
    @editable       Locations : []location = array{}
    # Calculate X distance.
    @editable       CalculateXDistance : logic = false
    # Calculate Y distance.
    @editable       CalculateYDistance : logic = false
    # Calculate Z distance.
    @editable       CalculateZDistance : logic = true
    # How much time in between between updates in seconds.
    @editable       UpdateTime : float = 0.2

# Text style editables.
text_style := class<concrete>():
    # The X position of the text on the screen.
    @editable       PositionX : type{_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.5
    # The Y position of the text on the screen.
    @editable       PositionY : type{_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.8
    # Prefix text.
    @editable       PrefixText : string = "Height: "
    # Suffix text.
    @editable       SuffixText : string = " meters"
    # Text Color.
    @editable       TextHexColor : string = "FFFFFF"
    # Text Shadow Color.
    @editable       TextShadowHexColor : string = "000000"
    # Enable or disable shadow.
    @editable       EnableShadow : logic = true
    # Shadow opacity.
    @editable       ShadowOpacity : type{_X:float where 0.000000 <= _X, _X <= 1.000000} = 1.0

# Represents the height tracker for one player.
distance_tracker := class():

    # The player to track the height for.
    Player : player
    # The distance tracker device.
    DTD : distance_tracker_device
    # The canvas that is display to the player.
    var MaybeCanvas : ?canvas = false
    # The text block that has the height text.
    var MaybeTextBlock : ?text_block = false
    # Control if the height tracker should run or not.
    var Running : logic = false

    # Run the height tracker, can be cancelled by the running variable.
    Run()<suspends> : void =
        set Running = true
        loop:
            UpdateHeightMessage()

            if (not Running?):
                break
            
            Sleep(DTD.Tracking.UpdateTime)

    # Update the height message.
    UpdateHeightMessage() : void =
        if:
            PlayerUI := GetPlayerUI[Player]
            FortCharacter := Player.GetFortCharacter[]
            NearestLocation := GetNearestLocation(FortCharacter.GetTransform().Translation)
            DistanceInMeters := Floor[CalculateDistance(FortCharacter.GetTransform().Translation, NearestLocation.Vector)/100.0]
        then:
            Message := StringToMessage("{DTD.TextStyle.PrefixText.AnalyzeString(NearestLocation)}{DistanceInMeters}{DTD.TextStyle.SuffixText.AnalyzeString(NearestLocation)}")
            if:
                Canvas := MaybeCanvas?
                TextBlock := MaybeTextBlock?
            then:
                if (NearestLocation.ChangeTextColor?):
                    TextBlock.SetTextColor(MakeColorFromHex(NearestLocation.TextHexColor))
                else:
                    TextBlock.SetTextColor(MakeColorFromHex(DTD.TextStyle.TextHexColor))

                TextBlock.SetText(Message)
            else:
                var TextColor : color = NamedColors.White
                if (NearestLocation.ChangeTextColor?):
                    set TextColor = MakeColorFromHex(NearestLocation.TextHexColor)
                else:
                    set TextColor = MakeColorFromHex(DTD.TextStyle.TextHexColor)
                
                TextBlock := MakeTextBlock(Message, TextColor, 1.0, text_justification.Center, text_overflow_policy.Clip)

                if (DTD.TextStyle.EnableShadow?):
                    TextBlock.SetShadowOpacity(DTD.TextStyle.ShadowOpacity)
                    TextBlock.SetShadowOffset(option{vector2{X:=1.0,Y:=1.0}})
                    TextBlock.SetShadowColor(MakeColorFromHex(DTD.TextStyle.TextShadowHexColor))

                TextBlock.SetText(Message)
                set MaybeTextBlock = option{ TextBlock }
                Canvas := MakeCanvas(array{MakeCanvasSlot(DTD.TextStyle.PositionX, DTD.TextStyle.PositionY, DTD.TextStyle.PositionX, DTD.TextStyle.PositionY, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, true, 0, TextBlock)})
                PlayerUI.AddWidget(Canvas, player_ui_slot{InputMode := ui_input_mode.None})
                set MaybeCanvas = option{ Canvas }

    # Calculate the distance from two given points.
    CalculateDistance(PointA : vector3, PointB : vector3)<transacts> : float =
        var XDelta : float = 0.0
        var YDelta : float = 0.0
        var ZDelta : float = 0.0

        if (DTD.Tracking.CalculateXDistance?) then set XDelta = Abs(PointA.X - PointB.X)
        if (DTD.Tracking.CalculateYDistance?) then set YDelta = Abs(PointA.Y - PointB.Y)
        if (DTD.Tracking.CalculateZDistance?) then set ZDelta = Abs(PointA.Z - PointB.Z)

        return Sqrt(Pow(XDelta, 2.0) + Pow(YDelta, 2.0) + Pow(ZDelta, 2.0))

    # Get the nearest location from a specific point.
    GetNearestLocation(Point : vector3)<transacts> : location =
        var NearestLocation : location = location{}

        for (Index -> Location : DTD.Tracking.Locations):
            if (Index = 0):
                set NearestLocation = Location
            else if (Distance(Location.Vector, Point) < Distance(NearestLocation.Vector, Point)):
                set NearestLocation = Location
        return NearestLocation

    # Check if we need to replace a piece of the message with the location name.
    (String : string).AnalyzeString(Location : location) : string =
        var StartIndex : int = -1
        for (Index -> Char : String):
            if ("{Char}" = "["):
                set StartIndex = Index
        if: 
            StartIndex > 0
            CorrectedString := String.Slice[0, StartIndex] + Location.Name + String.Slice[StartIndex + 10, String.Length]
        then:
            return CorrectedString

        return String

# Constructor.
MakeDistanceTracker<constructor>(InPlayer : player, InDTD : distance_tracker_device) := distance_tracker:
    Player := InPlayer
    DTD := InDTD

# A location that we want to find the distance from.
location := class<concrete>():

    # Name of the location.
    @editable       Name : string = "Point A"
    # The vector value of the location.
    @editable       Vector : vector3 = vector3{}
    # If the location should change the color text color.
    @editable       ChangeTextColor : logic = false
    # What color to change the text to if it applies.
    @editable       TextHexColor : string = "FFFFFF"

# String to message.
StringToMessage<localizes>(value:string) : message = "{value}"

# Make a text block.
MakeTextBlock(DefaultText : message, DefaultTextColor : color, DefaultTextOpacity : type {_X:float where 0.000000 <= _X, _X <= 1.000000}, DefaultJustification : text_justification, DefaultOverflowPolicy : text_overflow_policy)<transacts> : text_block =
    return text_block{
        DefaultText := DefaultText, 
        DefaultTextColor := DefaultTextColor,
        DefaultTextOpacity := DefaultTextOpacity, 
        DefaultJustification := DefaultJustification, 
        DefaultOverflowPolicy := DefaultOverflowPolicy
    }

# Make a canvas.
MakeCanvas(CanvasSlots : []canvas_slot)<transacts> : canvas =
    return canvas{
        Slots := CanvasSlots
    }

# Make a canvas slot.
MakeCanvasSlot(AnchorMinX : float, AnchorMinY : float, AnchorMaxX : float, AnchorMaxY : float, OffsetTop : float, OffsetLeft : float, OffsetRight : float, OffsetBottom : float, AlignmentX : float, AlignmentY : float, SizeToContent : logic, ZOrder: type{_X:int where 0 <= _X, _X <= 2147483647}, Widget : widget)<transacts> : canvas_slot =
    return canvas_slot{
        Anchors := anchors{Minimum := vector2{X := AnchorMinX, Y := AnchorMinY}, Maximum := vector2{X := AnchorMaxX, Y := AnchorMaxY}}
        Offsets := margin{Top := OffsetTop, Left := OffsetLeft, Right := OffsetRight, Bottom := OffsetBottom}
        Alignment := vector2{X := AlignmentX, Y := AlignmentY}
        SizeToContent := SizeToContent
        ZOrder := ZOrder
        Widget := Widget
    }
