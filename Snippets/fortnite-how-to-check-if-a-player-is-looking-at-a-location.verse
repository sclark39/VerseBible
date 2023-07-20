# Title: How to check if a player is looking at a location
# Subtitle: Shows how to check if a player is looking at a location and draw debug line/cone
# Author: amar0k [ /community/profile/mjErz/amar0k ]
# Created: Thu Jul 20 2023 13:34:04 GMT+0000 (Coordinated Universal Time)
# Last Updated: Thu Jul 20 2023 13:34:04 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/mwza/fortnite-how-to-check-if-a-player-is-looking-at-a-location
# ------

# Is Looking at Location
# Note: Shows how to get view direction and debug lines
using { /Fortnite.com/Devices }
using { /Verse.org/Native }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Verse.org }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation/Tags }
using { /Fortnite.com/Game }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Diagnostics }

building_manager_device := class(creative_device):

IsLookingAtLocation(Character:fort_character, LocationToCheck: vector3, Threshold: float):logic=
         # Get the character's view location
        ViewLocation := Character.GetViewLocation()
         # Get the character's view rotation
        ViewRotation := Character.GetViewRotation()
        # Create a direction vector from the view location to the target vecto
        DirectionVector := Normalize(LocationToCheck - ViewLocation)
         # Convert the view rotation to a direction vector
        ViewDirection := ViewRotation.GetLocalForward()
        DrawDebugCone(Character.GetTransform().Translation, ViewDirection)
        DrawDebugLine(Character.GetTransform().Translation, Character.GetTransform().Translation + ViewDirection * 1000.0)
        # Compare the direction vector and the view direction
        # Use a dot product to find the cosine of the angle between the two vectors.
        # If it's close to 1, then the vectors are nearly parallel, so the character is looking at the target.
        CosAngle := DotProduct(ViewDirection, DirectionVector)
        if(IsFacing := CosAngle > Threshold):
            return true
        return false

    Magnitude(v1:vector3):float=
        return Sqrt(Pow(v1.X, 2.0) + Pow(v1.Y, 2.0) + Pow(v1.Z, 2.0))

    Normalize(v1:vector3):vector3=
        Mag := Magnitude(v1)
        return vector3{X := v1.X/Mag, Y := v1.Y/Mag, Z:= v1.Z/Mag}

    RotationToDirection(r1:rotation):vector3=
        # Assuming the rotation is Euler angles (pitch, yaw, roll)
        Pitch := r1.GetAxis().X
        Yaw := r1.GetAxis().Y
        
        # Convert angles from degrees to radians if necessary
        PitchRad := DegreesToRadians(Pitch)
        YawRad := DegreesToRadians(Yaw)

        # Convert rotation to direction vector
        Direction := vector3{X:= Cos(Pitch) * Cos(Yaw), Y:= Sin(Pitch), Z:= Cos(Pitch) * Sin(Yaw)}
        return Direction

    DrawDebugLine(LineStart : vector3, LineEnd : vector3):void=
        Drawer := debug_draw{}
        Drawer.DrawLine(
            Start := LineStart,
            End := LineEnd,
            ?Color:= Colors.NamedColors.Red,
            ?Thickness:= float(4.0),
            ?DrawDurationPolicy := debug_draw_duration_policy.FiniteDuration,
            ?Duration:= float(5.0)
        )

    DrawDebugCone(ConeOrigin: vector3, ViewDirection : vector3):void=
        # Draw a cone at the character's view location, in the direction they are facing
        Drawer := debug_draw{}
        Drawer.DrawCone(Origin := ConeOrigin, 
        Direction := ViewDirection, 
        ?NumSides:= 6,
        ?Height := float(50.0), 
        ?AngleWidthRadians := float(0.3), 
        ?AngleHeightRadians:= float(0.3),
        ?Color:= Colors.NamedColors.Red,
        ?Thickness:= float(2.0),
        ?DrawDurationPolicy := debug_draw_duration_policy.FiniteDuration, 
        ?Duration:= float(5.0) )
