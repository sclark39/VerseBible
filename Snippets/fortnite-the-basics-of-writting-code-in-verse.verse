# Title: The basics of writting code in verse
# Subtitle: From Unreal Editor for Fortnite Documentation, Lesson 1 on basic code writing;  this snippet expands the algorithm to show that the player starts with five gold coins, receives a coin for every mouse caught, and loses a coin for every mouse that gets away.
# Author: Mastrd [ /community/profile/086B/Mastrd ]
# Created: Thu Apr 27 2023 20:11:06 GMT+0000 (Coordinated Universal Time)
# Last Updated: Thu Apr 27 2023 20:11:06 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/7aA/fortnite-the-basics-of-writting-code-in-verse
# ------

# None
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

# A Verse-authored creative device that can be placed in a level
hello_world_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code

        
        # Welcome to the game of mice and coins! Let's start with 5 gold coins.
        var goldcoins: int = 5

        # Display the starting amount of gold coins to the player with a witty message.
        Print("Welcome to the game of mice and coins! You're starting with {goldcoins} shiny gold pieces!")

        # Now, let's set up the variables for the game: the number of mice caught and the additional gold pieces they're worth.
        var micecaught: int = 0
        var additionalgold: int = 1

        # If the player catches a mouse, they get additional gold coins. If not, they lose some. Simple, right?
        if (micecaught > 0):
            set goldcoins = goldcoins + additionalgold
            Print("You caught a mouse! Congrats! You now have {goldcoins} gold coins! Keep it up!")
        else:
            set goldcoins = goldcoins - additionalgold
            Print("Oh no, a mouse escaped! You now have {goldcoins} gold coins. Better luck next time, champ!")
