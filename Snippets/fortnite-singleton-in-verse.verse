# Title: Singleton in Verse
# Subtitle: Singletons (global objects) in Verse. This is specifically a global device reference, but it works with any class. It looks weird, but Verse is pretty restrictive about what you can put in the global scope. WARNING: Epic may remove this loophole soon.
# Author: MattRix [ /community/profile/bpoG6/MattRix ]
# Created: Wed May 17 2023 22:13:10 GMT+0000 (Coordinated Universal Time)
# Last Updated: Wed May 17 2023 22:13:10 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/ojb/fortnite-singleton-in-verse
# ------

# singleton.verse
# Note: See the forum link below to learn more about how and why I did it this way... or to chastise me for my use of singletons ;)
#define the global class
global := class<varies><concrete>(): 
   var MaybeMainDevice : ?main_device = false

#create the global instance
Global : global = global{}

#function that makes it easier to access the device without checking if the option has a value
GetMainDevice():main_device = 
    if(MainDevice := Global.MaybeMainDevice?) then MainDevice else main_device{}


#in your device's OnBegin you need this line:
set Global.MaybeMainDevice = option{Self}

#when you want to use it, you call:
GetMainDevice() 

