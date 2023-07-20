# Title: Top-Down View Support Device
# Subtitle: Code for using the camera in Top-Down View.
The rotation of the viewpoint occurs when the player jumps.
# Author: RingoGames [ /community/profile/5pBZE/RingoGames ]
# Created: Sat Apr 01 2023 22:36:12 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Apr 01 2023 22:36:12 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/xve/fortnite-top-down-view-support-device
# ------

# Top-Down View Support Device
# Note: Please refer to the following web page for detailed instructions.

https://ringogames.hatenablog.com/entry/2023/04/01/105527
https://ringogames.hatenablog.com/entry/2023/04/02/073146
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }

# A Verse-authored creative device that can be placed in a level
track_player_manager := class(creative_device):

    @editable
    _CameraRoot: creative_prop = creative_prop{}

    @editable
    _OtherRoot: creative_prop = creative_prop{}

    @editable
    _OffsetX : float = 0.0
    @editable
    _OffsetY : float = 0.0
    @editable
    _OffsetZ : float = 0.0

    var _CurrentRotation : rotation = rotation{}

    ### OnBegin
    OnBegin<override>()<suspends>:void=
        Offset:vector3 = vector3{X:=_OffsetX, Y:=_OffsetY, Z:=_OffsetZ}

        ## add jumped event 
        Players : []player = GetPlayspace().GetPlayers()
        if(Player : player = Players[0]):
            if(FortniteCharacter : fort_character = Player.GetFortCharacter[]):
                FortniteCharacter.JumpedEvent().Subscribe(OnPlayerJumped)

        UpdateRotationValue()

        ## start update loop
        spawn{UpdateTargetPosition(Offset)}

    ### process for jump
    OnPlayerJumped(the_player:fort_character):true= 
        UpdateRotationValue()

    ### update rotation value
    UpdateRotationValue():void=
        Players : []player = GetPlayspace().GetPlayers()
        if(Player : player = Players[0]):
            if(FortniteCharacter : fort_character = Player.GetFortCharacter[]):

                ### Not Good
                #var playerRotation : rotation = FortniteCharacter.GetTransform().Rotation
                
                ### Good
                var viewRotation : rotation = FortniteCharacter.GetViewRotation()

                var angles :[]float = viewRotation.GetYawPitchRollDegrees()
                if(angleYaw := angles[0]):
                    anglePitch := 0.0
                    angleRoll := 0.0
                    targetRotation := MakeRotationFromYawPitchRollDegrees(angleYaw, anglePitch, angleRoll)
                    set _CurrentRotation = _CurrentRotation.RotateBy(MakeShortestRotationBetween(_CurrentRotation, targetRotation))

    ### Loop Process
    UpdateTargetPosition(Offset:vector3)<suspends>:void=
        loop:
            ## get player and player position
            Players : []player = GetPlayspace().GetPlayers()
            if(Player : player = Players[0]):

                if(FortniteCharacter : fort_character = Player.GetFortCharacter[]):
                    PlayerPosition : vector3 = FortniteCharacter.GetTransform().Translation
                    ## add rotation
                    PlayerRotation : rotation = FortniteCharacter.GetTransform().Rotation

                    ## first rotation
                    TargetPositionX : float = PlayerPosition.X
                    TargetPositionY : float = PlayerPosition.Y
                    TargetPositionZ : float = PlayerPosition.Z

                    TargetPosition:vector3 = vector3{X:=TargetPositionX, Y:=TargetPositionY, Z:=TargetPositionZ} + Offset
                    
                    ## move target to player position
                    _CameraRoot.MoveTo(TargetPosition, _CurrentRotation, 0.5)
                    _OtherRoot.MoveTo(TargetPosition, IdentityRotation(), 0.5)
                    
                    # Not Good
                    # if(_CameraRoot.TeleportTo[TargetPosition, IdentityRotation()]):
                    #     void

            Sleep(0.5)

            # Not Good
            # Sleep(0.0)
