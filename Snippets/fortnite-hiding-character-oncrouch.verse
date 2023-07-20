# Title: Hiding Character OnCrouch
# Subtitle: An example to demonstrate subscribing to player events (like crouch) as well as the character Hide and Show methods.
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Sat Jun 10 2023 21:57:28 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jun 10 2023 21:57:28 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/Aeym/fortnite-hiding-character-oncrouch
# ------

# hello_crouch_device.verse
# Note: Note: the crouched event sends along a logic state for crouched or not-crouched.
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
hello_crouch_device := class(creative_device):
    OnCrouch(MyChar:fort_character,Logic:logic):void=
        if(Logic?):
            Print("Hide")
            MyChar.Hide()
        else:
            MyChar.Show()
            Print("show")
    OnBegin<override>()<suspends>:void=
        Playspace: fort_playspace = GetPlayspace()
        AllPlayers: []player = Playspace.GetPlayers()
        if (FirstPlayer : player = AllPlayers[0]):
            if (FortniteCharacter : fort_character = FirstPlayer.GetFortCharacter[]):
                FortniteCharacter.CrouchedEvent().Subscribe(OnCrouch)
                Print("Try crouching")
