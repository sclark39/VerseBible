# Title: Throw an error
# Subtitle: Halts the Verse runtime with error `Message`.
# Author: Rift9 [ /community/profile/KQDbl/le-8g7e ]
# Created: Sun Jun 18 2023 09:50:01 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sun Jun 18 2023 09:50:01 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/eee2/fortnite-throw-an-error
# ------

# None
# Note: None
MaybeInt: ?int = false
MyInt: int = MaybeInt? or Err("expected MaybeInt to be set")
