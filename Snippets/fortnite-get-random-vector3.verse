# Title: Get random vector3
# Subtitle: Will get a random values for a vector 3
# Author: Cleverlike Studios [ /community/profile/zDElE/Cleverlike_Studios ]
# Created: Sat Apr 22 2023 14:47:00 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Apr 22 2023 14:47:00 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/57L/fortnite-get-random-vector3
# ------

# Random vector3
# Note: None
GetRandomVector3(Low : vector3, High : vector3) : vector3 =
    vector3:
        X := GetRandomFloat(Low.X, High.X)
        Y := GetRandomFloat(Low.Y, High.Y)
        Z := GetRandomFloat(Low.Z, High.Z)
