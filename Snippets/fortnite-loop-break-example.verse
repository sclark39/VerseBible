# Title: Loop Break Example
# Subtitle: In this example we can see one way you might break out of a for loop in verse, without a break or return.
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Tue Jul 11 2023 18:43:24 GMT+0000 (Coordinated Universal Time)
# Last Updated: Tue Jul 11 2023 18:43:24 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/J5gV/fortnite-loop-break-example
# ------

# hello_break_device.verse
# Note: Should print 0, 1, 2, 3, and not 4, or 5.
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
hello_break_device := class(creative_device):
    OnBegin<override>()<suspends>:void=
        var ExitFlag:logic = false;
        for(Index:=0..5,not ExitFlag?):
            if(Index = 3):
                set ExitFlag = true
            Print("{Index}")
