# Title: Hello Function
# Subtitle: For those of us who can't just be told but have to see: an example of calling a member function.
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Sat Jun 10 2023 21:49:48 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jun 10 2023 21:49:48 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/PNDb/fortnite-hello-function
# ------

# hello_function_device.verse
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }   
hello_function_device := class(creative_device):
    MyFunction():void =
        Print("Hello World")
    OnBegin<override>()<suspends>:void=
        MyFunction()
