# Title: Verse - Automatic Sliding Door
# Subtitle: Basic usage of a custom verse device that utilizes a capture zone to act as a trigger to automatically open and close a door.
# Author: wasti [ /community/profile/n0JM/wasti ]
# Created: Sat Apr 15 2023 06:30:11 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Apr 15 2023 06:30:11 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/D08/fortnite-verse-automatic-sliding-door
# ------

# Instructions
# Note: None
Start by creating a new verse device named automatic_sliding_door_device and open it is Visual Studio Code, copy and paste the provided verse code and save. Back within UEFN, Ctrl+Shift+B to build verse code. 

Place down a Capture_Area_Device so that it overlaps with your door frame, and set the following options in the details panel:
Capture Radius 0.5 (this value is the overlap size that triggers our door)
Untick Visible During Game
Untick Item Visible in Game
Untick Consume Item on Scoring
Untick Consume Item On Scoring
Untick Display control VFX
Untick Display ownership change VFX
Untick Play Sounds Alerts
Untick Show Objective pulse (all 3 of them)
Clear the HUD Message

All of these options basically make the capture zone inert (it doesn't do anything) but it does still have overlap events that we will bind our code to.

Next, pick a suitable door prop from the available fortnite assets, and drag it into your level. In the details panel, untick Register with Structural Grid.

You will also need to drag in a Switch_Device.
Finally, place your automatic_sliding_door_device within your level, location of this device is irrelevant. In the details panel, select your door prop as the door Prop, you can either use the drop-down list, or use the eyedropper (and then just click on your door in the view-port). Do the same to select your capture area, and switch devices. Save all and launch a session, your door should now slide to the right when any player is within your capture zone area. If the door moves in the wrong direction, please take a look at the comments within the below verse code. 
