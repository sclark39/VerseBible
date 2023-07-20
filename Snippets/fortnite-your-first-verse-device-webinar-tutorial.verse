# Title: Your First Verse Device - Webinar Tutorial
# Subtitle: This snippet was used in the FREE Webinar Tutorial "Your First Verse Device" By Clevelike Studios
The quest is to have the player fix a fuze box that will turn on the power to a set of doors and a light in a tunnel. See the Video for the full tutorial.
# Author: Cleverlike Studios [ /community/profile/zDElE/Cleverlike_Studios ]
# Created: Fri Apr 28 2023 15:45:28 GMT+0000 (Coordinated Universal Time)
# Last Updated: Fri Apr 28 2023 15:45:28 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/P1V/fortnite-your-first-verse-device-webinar-tutorial
# ------

# Your First Verse Device
# Note: None

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors/NamedColors }                                                 # Needed to use ?Duration and ?Color on line 42


my_first_verse_device := class(creative_device):

    # This device was used in the FREE "Coding with Verse tutorial" Webinar by Clevelike Studios

    ############### Game Designer Devices ##########################
    @editable Fuzebox : button_device = button_device{}                                 # player fixes fuze box

    @editable DoorsAnim : cinematic_sequence_device = cinematic_sequence_device{}       # Doors Open

    @editable MotionDetector : mutator_zone_device = mutator_zone_device{}              # Motion Sensor that turns on the light

    @editable TunnelLight : customizable_light_device = customizable_light_device{}     # Light in tunnel that turns on with motion sensor
    
    @editable FixFuzeboxMessage : hud_message_device = hud_message_device{}             # Tells player to fix the Fuzebox

    ############### Variables ######################################
    var FuzeFixed : logic = false                                                       # Has Fuze Been fixed?

    ############### Functions ######################################
    OnBegin<override>()<suspends>:void=
        Fuzebox.InteractedWithEvent.Subscribe(OpenDoors)                                # Button will open door
        MotionDetector.AgentEntersEvent.Subscribe(TurnLightOn)                          # Motion Dector will turn on light

    OpenDoors(Agent:agent):void=                                                        # Opens doors then fuze box is fixed BUT ONLY ONE TIME,
        if (FuzeFixed = false):                                     
            DoorsAnim.Play()                                        
        set FuzeFixed = true                                                            # Set that the fuze box is fixed

    TurnLightOn(Agent:agent):void=                                                      # Turns On Light IF fuse box is fixed
        if (FuzeFixed = true):
            TunnelLight.TurnOn()
        else:                                                                           # If fuse box is not fixed, tell player to fix fuze box
            Print("Fix FuzeBox", ?Duration:=3.2, ?Color:=Yellow)
            FixFuzeboxMessage.Show()

    
