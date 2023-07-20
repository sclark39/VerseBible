# Title: Minecraft-Styled Building Mechanic
# Subtitle: This is rough code for a version of a Minecraft-styled single-player building game. However, due to limitations with the SpawnProp function, you can only place 100 Blocks.
# Author: Poket328 [ /community/profile/0208r/Poket328 ]
# Created: Wed Jul 19 2023 18:06:56 GMT+0000 (Coordinated Universal Time)
# Last Updated: Wed Jul 19 2023 18:06:56 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/VglD/fortnite-minecraft-styled-building-mechanic
# ------

# Open-Ended Building Game
# Note: Note that this includes code for the entire 100 Blocks game (9301-1540-6329) and not just the building mechanic, which is primarily in the functions CalculateBlockLocation() and DisplayBlockLocation().
# Code by Poket for 100 Blocks Island tech demo (7/19/23)

using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }

# Device for overall game management and block system
construction_device := class(creative_device):
    @editable # Device to manage signal remote used for blocks
    MyRemote : signal_remote_manager_device = signal_remote_manager_device{}
    @editable # Asset used for the blue block
    BlueBlock : creative_prop_asset = DefaultCreativePropAsset
    @editable # Asset used for the red block
    RedBlock : creative_prop_asset = DefaultCreativePropAsset
    @editable # Prop used for the indicator of block placement
    HoloBlock : creative_prop = creative_prop{}
    @editable # Scale used to warp blue and red blocks to a cube-like shape
    BlockScale : vector3 = vector3{ X := 1.0, Y := 1.0, Z := 1.33333 }
    @editable # Detector button to check if signal remote is being held (not fully functional)
    HeldDetector : conditional_button_device = conditional_button_device{}
    @editable # Pop-up dialog to explain game at it's start
    StartPopup : popup_dialog_device = popup_dialog_device{}
    @editable # Integer to track how many blocks have been placed
    var BlockCount : int = 100
    @editable # Pop-up message to indicate when you've run out of blocks
    BlockCountPopup : hud_message_device = hud_message_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        StartPopup.Show() # Show the popup for the start of the game

        Playspace : fort_playspace = GetPlayspace() # Get the list of players
        PlayerList : []player = Playspace.GetPlayers()

        MyRemote.PrimarySignalEvent.Subscribe(Function_1) # Player can press button to trigger this function
        MyRemote.SecondarySignalEvent.Subscribe(Function_2) # Alternate function (red block)
        loop:
            if (BlockCount = 0): # If user has no blocks left
                BlockCountPopup.Show() # Show popup once
                set BlockCount = -1
            if (HeldDetector.IsHoldingItem[PlayerList[0]]): # If player is holding the device (not fully functional)
                DisplayBlockLocation() # Display a hologram to indicate where the block will be placed
            else:
                if (HoloBlock.TeleportTo[BlockScale, MakeRotation(BlockScale, 0.0)]): # If it's not being held, remove the block for now
                    Print("Hiding block placement")
            Sleep(0.1) # Keeps game from crashing

    Function_1(Agent:agent):void= # Create a blue block at the selected location
        CorrectedPosition : vector3 = CalculateBlockLocation() # Function to calculate ideal position
        ZeroRotation : rotation = MakeRotation(CorrectedPosition, 0.0) # Set rotation to zero (so they're all aligned)
        SpawnProp(BlueBlock, transform{Scale := BlockScale, Rotation := ZeroRotation, Translation := CorrectedPosition}) # Spawn the prop
        set BlockCount = BlockCount - 1 # Reduce block count by one
        Print("Built a blue block", ?Duration := 1.0)
    
    Function_2(Agent:agent):void= # Create a red block at the selected location
        CorrectedPosition : vector3 = CalculateBlockLocation() # Same code as Function_1 but with BlueBlock replaced with RedBlock
        ZeroRotation : rotation = MakeRotation(CorrectedPosition, 0.0)
        SpawnProp(RedBlock, transform{Scale := BlockScale, Rotation := ZeroRotation, Translation := CorrectedPosition})
        set BlockCount = BlockCount - 1
        Print("Built a red block", ?Duration := 1.0)

    DisplayBlockLocation():void= # Code to display the block placement when the trigger is held
        PotentialSpot : vector3 = CalculateBlockLocation() # Calculate the potential position
        if (HoloBlock.TeleportTo[PotentialSpot, MakeRotation(PotentialSpot, 0.0)]): # Move the indicator prop to this spot
            Print("Displaying block placement")

    CalculateBlockLocation():vector3= # Code to calculate the ideal position for a block based on player movement

        var CorrectedPosition : vector3 = vector3 {X := 0.0, Y := 0.0, Z := 0.0} # Placeholder coordinates
        Playspace : fort_playspace = GetPlayspace()
        PlayerList : []player = Playspace.GetPlayers() # Get player location data

        if (FirstPlayer : player = PlayerList[0]):
            if (FortniteCharacter : fort_character = FirstPlayer.GetFortCharacter[]):
                # Record player postition and rotation
                PlayerPosition : vector3 = FortniteCharacter.GetTransform().Translation
                PlayerRotation : rotation = FortniteCharacter.GetViewRotation()

                # Calculate which rotation is closest to the player
                CardinalsString : []string = array{"North", "Northeast", "East", "Southeast", "South", "Southwest", "West", "Northwest"}
                # CardinalsString is used solely for testing and can be removed

                PlayerAngle : float = RadiansToDegrees(PlayerRotation.GetAngle()) # Get player angle

                # These variables are used to edit the general alignment of the block grid in comparison to the player
                var FinalDirection : int = 0
                var BlockPosition : vector3 = vector3{ X := PlayerPosition.X + 50.0, Y := PlayerPosition.Y + 50.0, Z := PlayerPosition.Z - 100.0 }
                BlockRange : float = 500.0 

                # Depending on which cardinal direction the player is closest to, the block placement changes
                if (PlayerAngle < 22.5): # North
                    set BlockPosition = vector3{ X := BlockPosition.X + BlockRange, Y := BlockPosition.Y, Z := BlockPosition.Z}
                    set FinalDirection = 0
                else if (PlayerAngle < 67.5): # Northeast
                    set BlockPosition = vector3{ X := BlockPosition.X + (BlockRange / 2.0), Y := BlockPosition.Y - (BlockRange / 2.0), Z := BlockPosition.Z}
                    set FinalDirection = 1
                else if (PlayerAngle < 112.5): # East
                    set BlockPosition = vector3{ X := BlockPosition.X, Y := BlockPosition.Y - BlockRange, Z := BlockPosition.Z}
                    set FinalDirection = 2
                else if (PlayerAngle < 157.5): # Southeast
                    set BlockPosition = vector3{ X := BlockPosition.X - (BlockRange / 2.0), Y := BlockPosition.Y - (BlockRange / 2.0), Z := BlockPosition.Z}
                    set FinalDirection = 3
                else if (PlayerAngle < 202.5): # South
                    set BlockPosition = vector3{ X := BlockPosition.X - BlockRange, Y := BlockPosition.Y, Z := BlockPosition.Z}
                    set FinalDirection = 4
                else if (PlayerAngle < 247.5): # Southwest
                    set BlockPosition = vector3{ X := BlockPosition.X - (BlockRange / 2.0), Y := BlockPosition.Y + (BlockRange / 2.0), Z := BlockPosition.Z}
                    set FinalDirection = 5
                else if (PlayerAngle < 292.5): # West
                    set BlockPosition = vector3{ X := BlockPosition.X, Y := BlockPosition.Y + BlockRange, Z := BlockPosition.Z}
                    set FinalDirection = 6
                else if (PlayerAngle < 337.5): # Northwest
                    set BlockPosition = vector3{ X := BlockPosition.X + (BlockRange / 2.0), Y := BlockPosition.Y + (BlockRange / 2.0), Z := BlockPosition.Z}
                    set FinalDirection = 7
                else: # North
                    set BlockPosition = vector3{ X := BlockPosition.X + BlockRange, Y := BlockPosition.Y, Z := BlockPosition.Z}
                    set FinalDirection = 0

                # Solely for testing purposes, can be removed
                if (Element := CardinalsString[FinalDirection]):
                    Print("{Element}")

                # Calculate block's position on the grid
                var BlockIntX : int = 0
                var BlockRemainderX : int = 0
                var BlockIntY : int = 0
                var BlockRemainderY : int = 0
                var BlockIntZ : int = 0
                var BlockRemainderZ : int = 0

                # Using the ideal location, a spot for the block that fits on the grid (128x128 blocks) is calculated
                if (set BlockIntX = Int[BlockPosition.X]):
                    if (set BlockRemainderX = Mod[BlockIntX, 128]):
                        if (BlockRemainderX > 64): # If the remainder of BlockPosition.X divided by 128 is more than 64
                            set BlockIntX = BlockIntX - BlockRemainderX + 128 # Snap to the next highest block spot
                        else:
                            set BlockIntX = BlockIntX - BlockRemainderX # Snap to the next lowest block spot
                
                # Repeat same code for Y and Z coordinates
                if (set BlockIntY = Int[BlockPosition.Y]):
                    if (set BlockRemainderY = Mod[BlockIntY, 128]):
                        if (BlockRemainderY > 64):
                            set BlockIntY = BlockIntY - BlockRemainderY + 128
                        else:
                            set BlockIntY = BlockIntY - BlockRemainderY

                if (set BlockIntZ = Int[BlockPosition.Z]):
                    if (set BlockRemainderZ = Mod[BlockIntZ, 128]):
                        if (BlockRemainderZ > 64):
                            set BlockIntZ = BlockIntZ - BlockRemainderZ + 128
                        else:
                            set BlockIntZ = BlockIntZ - BlockRemainderZ
                
                # Final position is calculated, note that integers must be converted into float values
                set CorrectedPosition = vector3{ X := BlockIntX * 1.0, Y := BlockIntY * 1.0, Z := BlockIntZ * 1.0 }

        # Return vector
        CorrectedPosition
            

