# Title: Hello Variable
# Subtitle: An explicit example of a member variable for clarity.
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Sat Jun 10 2023 22:02:34 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jun 10 2023 22:02:34 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/YDYr/fortnite-hello-variable
# ------

# hello_var_device.verse
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
hello_var_device := class(creative_device):
    var MyScore : int = 0
    OnBegin<override>()<suspends>:void=
        set MyScore = MyScore + 1
        Print("Score:{MyScore}")
