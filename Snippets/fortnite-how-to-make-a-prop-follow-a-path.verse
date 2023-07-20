# Title: How To make a prop follow a path
# Subtitle: This snippet will let you move a prop (like a car or a boat) to follow a path of other props (like flags).
# Author: rukyno [ /community/profile/3wXqq/rukyno ]
# Created: Thu May 25 2023 19:34:43 GMT+0000 (Coordinated Universal Time)
# Last Updated: Thu May 25 2023 19:34:43 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/gQm/fortnite-how-to-make-a-prop-follow-a-path
# ------

# None
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }



prop_movement_controller := class(creative_device):

    @editable
    PropToMove: creative_prop := creative_prop{} #this can be a prop like a boat or car
    @editable
    SpeedOfProp : float := 700.0
    var currentTravelPoint : int = 1
    @editable
    travelPoints : []creative_prop := array{} #this is the path, can be made up for example of flags
    var travelPointsTransform : [int]transform := map{}
    
    OnBegin<override>()<suspends>:void=
        if (set travelPointsTransform[0] = PropToMove.GetTransform()):
            Print("{travelPointsTransform.Length}")
        for(Index := 0.. travelPoints.Length):
            if (point := travelPoints[Index]):
                if (set travelPointsTransform[Index+1] = point.GetTransform() ):
                    point.Dispose()
       MoveToNextPoint()

    MoveToNextPoint()<suspends>:void=
        if (point := travelPointsTransform[currentTravelPoint]):
            travelTime := Distance(PropToMove.GetTransform().Translation,  point.Translation) / SpeedOfProp
            reuslt := PropToMove.MoveTo(point ,travelTime)
            if (  reuslt = move_to_result.DestinationReached ):
                set currentTravelPoint += 1
                if (currentTravelPoint >= travelPointsTransform.Length):
                    set currentTravelPoint = 0
                MoveToNextPoint()
