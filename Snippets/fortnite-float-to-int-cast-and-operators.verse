# Title: Float to int cast and +, -, / operators
# Subtitle: Atm only * operator is implemented in Verse, this script adds the rest. 
Also adds `Float(MyInt)`.
To truncate int to float use `Int(MyFloat)` from `using { /Verse.org/Verse }`
# Author: Kamyker [ /community/profile/pDOY/Kamyker ]
# Created: Mon Mar 27 2023 05:40:26 GMT+0000 (Coordinated Universal Time)
# Last Updated: Mon Mar 27 2023 05:40:26 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/1mD/fortnite-float-to-int-cast-and-operators
# ------

# math.verse
# Note: None
Float(Number : int)<varies>:float=
    return Number * 1.0

operator'+'(I:int, F:float):float=
    return I * 1.0 + F

operator'+'(F:float, I:int):float=
    return F + I * 1.0

operator'-'(I:int, F:float):float=
    return I * 1.0 - F

operator'-'(F:float, I:int):float=
    return F - I * 1.0

operator'/'(I:int, F:float):float=
    return I * 1.0 / F

operator'/'(F:float, I:int):float=
    return F / (I * 1.0)
