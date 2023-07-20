# Title: Character Transforms and Rotations
# Subtitle: A simple example showing how to pull the character transform or the view location and rotation, if needed.
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Sat Jun 10 2023 21:50:27 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jun 10 2023 21:50:27 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/NpLo/fortnite-character-transforms-and-rotations
# ------

# hello_transform_device.verse
# Note: None
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
hello_transform_device := class(creative_device):
    OnBegin<override>()<suspends>:void=
        Playspace: fort_playspace = GetPlayspace()
        AllPlayers: []player = Playspace.GetPlayers()
        if (FirstPlayer : player = AllPlayers[0]):
            if (FortniteCharacter : fort_character = FirstPlayer.GetFortCharacter[]):
                MyTransform : transform = FortniteCharacter.GetTransform()
                Print("Transform: {MyTransform.Scale}, {MyTransform.Translation}, {MyTransform.Rotation}")
                Print("GetViewRotation: {FortniteCharacter.GetViewRotation()}")
                Print("GetViewLocation: {FortniteCharacter.GetViewLocation()}")
