# Title: approximate your float to a specific decimal places
# Subtitle: a function to approximate your float to a specific decimal places
# Author: D4G [ /community/profile/DEBW6/D4G_fnc ]
# Created: Sun Jul 09 2023 13:36:24 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sun Jul 09 2023 13:36:24 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/eeOB/fortnite-approximate-your-float-to-a-specific-decimal-places
# ------

# None
# Note: None
approximateFloat(Value : float , decimalplace : float): float =
        factor := Pow(10.0,decimalplace)
        if(Rounded := Int[Value*factor]*1.0/factor):
            return Rounded
        else:
            return 0.0

