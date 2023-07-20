# Title: Organizing code into modules
# Subtitle: The documentation isn't very clear on how to use modules to organize your code, and the error message is wrong. 
"Did you forget to specify using { /localhost/... }" since using that format also throws an error. Here is how.
# Author: Megaspace [ /community/profile/3w5zv/Megaspace ]
# Created: Thu May 18 2023 16:53:00 GMT+0000 (Coordinated Universal Time)
# Last Updated: Thu May 18 2023 16:53:00 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/dxk/fortnite-organizing-code-into-modules
# ------

# Making modules
# Note: None
# You have a sub-folder called Helpers, and a class you want
# to reference called math_util.
# In the files using math_util add the following:
using { Helpers }

# In math_util, make sure any methods, variables or constants
# you want to expose are public, since default is internal (module only)

math_util<public> := class():

    PI<public> := 3.141592654
    SQRT_2<public> := 1.41421356
    
    method_a<public>() : void =
        Print("method_a")



