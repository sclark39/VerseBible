# Title: Logic ToString extension
# Subtitle: Sometimes it can be useful to cast a logic value to a string
# Author: Alonix [ /community/profile/GQ0YE/Alonix ]
# Created: Mon Apr 10 2023 19:30:08 GMT+0000 (Coordinated Universal Time)
# Last Updated: Mon Apr 10 2023 19:30:08 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/M7z/fortnite-logic-tostring-extension
# ------

# ToString logic extension
# Note: None
(Value : logic).ToString<public>() : string =
    if (Value?):
        return "true"
    return "false"

# usage

IsVisible := false
Print("{IsVisible.ToString()}")
