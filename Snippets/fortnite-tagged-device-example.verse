# Title: Tagged device example
# Subtitle: This example verse code defines a tag assignable in UEFN and a tag_device which looks for (tag assigned) siblings or itself and calls an example custom method.
# Author: jon4iffy.page [ /community/profile/l5pPO/jon4iffy.page ]
# Created: Sat Jun 10 2023 21:49:29 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jun 10 2023 21:49:29 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/rmP2/fortnite-tagged-device-example
# ------

# tag_device.verse
# Note: None

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
device_tag := class(tag){}
tag_device := class(creative_device):
    Custom<public>():void=
        Print("Hello, tagged")
    OnBegin<override>()<suspends>:void=
        All := GetCreativeObjectsWithTag(device_tag{})
        for (Tagged : All, TaggedDevice := tag_device[Tagged]):
            TaggedDevice.Custom()
