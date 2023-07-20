# Title: Check map value doesn't exist
# Subtitle: None
# Author: Rift9 [ /community/profile/KQDbl/le-8g7e ]
# Created: Tue Jun 20 2023 23:27:42 GMT+0000 (Coordinated Universal Time)
# Last Updated: Tue Jun 20 2023 23:27:42 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/oYYd/fortnite-check-map-value-doesn-t-exist
# ------

# None
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

game_device := class(creative_device):

    Map: [int]int = map{}

    OnBegin<override>()<suspends>:void=

        if(not Map[0]). Print("No value")
