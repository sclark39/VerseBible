# Title: Procedurally Animated Conveyor Belt
# Subtitle: This snippet iterates through an array of props to move props from the start to the end. The last element in the array of props is recycled back to the front of the line and repeats infinitely.
# Author: unopenboardgames [ /community/profile/67ekP/unopenboardgames ]
# Created: Mon Mar 06 2023 20:26:29 GMT+0000 (Coordinated Universal Time)
# Last Updated: Mon Mar 06 2023 20:26:29 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/LVB/fortnite-procedurally-animated-conveyor-belt
# ------

# None
# Note: None

using { /Fortnite.com/Devices }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Fortnite.com/Game }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }

# Makes a scalar value go back to 0.0 if it exceeds 1.0
(Number : float).WrapAroundScalar<public>() : float =
    if(Result := Number - (Floor[Number] * 1.0)) then return Result else return Number

# Helper extension function to convert an int to float
(Input : int).ToFloat<public>()<computes> : float = Input * 1.0

ConveyorBelt := class(creative_device):

    @editable
    Planks : []creative_prop = array{}

    # Store the first and last locations in the array of planks
    var StartConveyor : vector3 = vector3{}
    var EndConveyor : vector3 = vector3{}

    # Set the constants for the procedural animation
    @editable
    TotalMoveTime : float = 30.0
    RefreshRate : float = 1.0 / 30.0

    OnBegin<override>()<suspends>:void =
        InitializeStartPositions()
        MovePlanks()

    InitializeStartPositions():void =
        if (StartPlank := Planks[0], EndPlank := Planks[Planks.Length-1]):
            set StartConveyor = StartPlank.GetTransform().Translation
            set EndConveyor = EndPlank.GetTransform().Translation
        else:
            Print("InitializeStartPositions: Error initializing planks. Make sure your Planks array is setup.")

    # In order to move the planks, the last plank needs to move first to make room for the other planks. To do this,
    # the index will be inverted (e.g. the last index is converted to be the first.) Each plank individually travels from the beginning to the end
    # with an offset of the previous planks.

    # The movement will be done incrementally by using a Lerp function (aka Linear Interpolation). Lerp functions take two points in space and
    # calculate the position between them based on a scalar. A scalar of 0.5 is exactly half way between the 2 points, 0 is at the start, and 1 is at the end.

    MovePlanks()<suspends>:void =
        # Calculate how much to increment the scalar per distance refresh
        ScalarTimeDelta : float = RefreshRate / TotalMoveTime
        PlanksCount : int = Planks.Length

        # The scalar is used to calculate the Lerp between points
        var ScalarStart : float = 0.0
        ScalarPositionDelta : float  = 1.0 / PlanksCount.ToFloat()
        MaxIndex : int = Planks.Length-1

        loop: 
            for:
                Index := 0..MaxIndex
                InverseIndex: int = MaxIndex - Index
                Plank := Planks[InverseIndex]  
            do:
                # Move the last piece first or the next piece will overlap.
                Rotation := Plank.GetTransform().Rotation
                Scalar := (ScalarStart + (ScalarPositionDelta * InverseIndex)).WrapAroundScalar()
                NewPosition := Lerp(StartConveyor, EndConveyor, Scalar)
                
                if(Plank.TeleportTo[NewPosition, Rotation]) {}
                    
            # Increment and Wrap the scalar value for the next loop
            set ScalarStart += ScalarTimeDelta
            set ScalarStart = ScalarStart.WrapAroundScalar()
            Sleep(RefreshRate)
     
