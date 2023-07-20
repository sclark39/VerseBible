# Title: MapRangeUnclamped & MapRangeClamped
# Subtitle: Functions for mapping ranges
# Author: Rift9 [ /community/profile/KQDbl/le-8g7e ]
# Created: Sun Jun 18 2023 10:21:48 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sun Jun 18 2023 10:21:48 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/dLLd/fortnite-maprangeunclamped-maprangeclamped
# ------

# None
# Note: None
# Map range unclamped
# - Value: a floating point number
# - From: a tuple of two floating point numbers representing the original range
# - To: a tuple of two floating point numbers representing the target range
MapRangeUnclamped(Value: float, From: tuple(float,float), To: tuple(float,float)): float =

    # If the two values in the 'From' range are the same, there's no range to map from.
    if(From(0) = From(1)). Err("Error mapping range - From range cannot be equal.")

    # Calculate the ratio of the difference between the 'Value' and the first value of the 'From' range,
    # to the difference between the second and the first value of the 'From' range.
    Ratio := (Value - From(0)) / (From(1) - From(0))

    # Scale the ratio by the difference between the 'To' range values,
    # and add the first value of the 'To' range to get the final mapped value.
    return Ratio * (To(1) - To(0)) + To(0)


# Map range clamped
# - Value: a floating point number
# - From: a tuple of two floating point numbers representing the original range
# - To: a tuple of two floating point numbers representing the target range
MapRangeClamped(Value: float, From: tuple(float,float), To: tuple(float,float)): float =

    return MapRangeUnclamped(Clamp(Value, From(0), From(1)), From, To)
