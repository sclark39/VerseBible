# Title: Reverse array
# Subtitle: An extension function I made to reverse an array.
# Author: Jaren [ /community/profile/da2W/ProfessionalBot ]
# Created: Sat Apr 22 2023 14:48:52 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Apr 22 2023 14:48:52 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/Bgm/fortnite-reverse-array
# ------

# None
# Note: None
(Input:[]t where t:type).Reverse()<computes>:[]t=
    for (Index -> Unused : Input, Element := Input[Input.Length - Index - 1]). Element
