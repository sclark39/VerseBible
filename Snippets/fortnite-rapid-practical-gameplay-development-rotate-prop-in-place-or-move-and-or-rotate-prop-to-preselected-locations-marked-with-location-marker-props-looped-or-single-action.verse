# Title: Rapid Practical Gameplay Development - Rotate prop in place, or move and/or rotate prop to preselected locations marked with location marker props(looped or single action)
# Subtitle: Use Location Marker props to move a moveable prop to multiple locations using an array.
# Author: TheClicketyBoom [ /community/profile/mL2OB/dmac921 ]
# Created: Mon Apr 10 2023 09:36:26 GMT+0000 (Coordinated Universal Time)
# Last Updated: Mon Apr 10 2023 09:36:26 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/4Dl/fortnite-rapid-practical-gameplay-development-rotate-prop-in-place-or-move-and-or-rotate-prop-to-preselected-locations-marked-with-location-marker-props-looped-or-single-action
# ------

# Verse Prop Manipulator
# Note: Can easily be duplicated for rapid development of obstacle course type games or other.
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }


verse_prop_manipulator := class(creative_device):

    @editable MovableProp : creative_prop = creative_prop { }
    @editable var LocationMarker : []creative_prop = array { }
    @editable Rotate : float = 0.0
    @editable Time : float = 3.0
    @editable Looping : logic = false

    var ThisMarker : int = 0
    var NumberOfMarkers : int = 0
    var SelectedLocationMarker : creative_prop = creative_prop { }


    OnBegin<override>()<suspends>:void=

        #Array operations must be inside of a failable expression(true of false)
        if(MarkerTest := LocationMarker[ThisMarker], PropTest := MovableProp):
            set NumberOfMarkers = LocationMarker.Length  
              
            SelectMarker()

    SelectMarker()<suspends> : void=
            
        if(Element := LocationMarker[ThisMarker]): 
            set SelectedLocationMarker = Element
            PrepPosition(SelectedLocationMarker)


    PrepPosition(Prop : creative_prop) : void= #Prop is LocationMarker

        Transform := Prop.GetTransform()
        Position := Transform.Translation
        
        spawn:
            MoveProp(MovableProp, Position)
        

    MoveProp<private>(Prop : creative_prop, Translation : vector3)<suspends> : void= #Prop is MovableProp

        Transform := Prop.GetTransform()
        Position := Translation
        Rotation := Transform.Rotation
        Scale := Transform.Scale
        NewRotation := Rotation.ApplyYaw(Rotate)
        MoveResult := Prop.MoveTo(Position, NewRotation, Time) #This suspends the method for Time seconds
        if(MoveResult = move_to_result.DestinationReached):
            if (Looping = true):

                if (ThisMarker < NumberOfMarkers):
                    set ThisMarker = ThisMarker + 1   

                if (ThisMarker > NumberOfMarkers-1):
                    set ThisMarker = 0

                Sleep(0.1)
                SelectMarker()
        

