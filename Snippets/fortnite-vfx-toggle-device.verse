# Title: VFX Toggle Device
# Subtitle: A detailed snippet tutorial for beginners that lays out the structure of how to create a VFX device that toggles on and off with the press of a button using Verse. Includes links to resource materials.
# Author: BLZE.DRAGON [ /community/profile/KQ4LP/BLZE.DRAGON1 ]
# Created: Thu Apr 13 2023 12:54:21 GMT+0000 (Coordinated Universal Time)
# Last Updated: Thu Apr 13 2023 12:54:21 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/ekv/fortnite-vfx-toggle-device
# ------

# VFX Toggle Device
# Note: A detailed snippet tutorial for beginners that lays out the structure of how to create a VFX device that toggles on and off with the press of a button using Verse. Includes links to resource materials.

Say Hi : Youtube/Twitter @Yo_Its_Dragon
#VFX TOGGLE ON AND OFF DEVICE
#Full Tutorial Snippet
#Author: Dragon (SAC BLZE.DRAGON)
#This Snippet is best for Beginner Verse Users
#If used in a project, please provide credit and share this snippet with others 
#if it helped you.

# - - - - - - - - - - DEVICES YOU NEED - - - - - - - - - - - # 

#Player Spawn Pad
#VFX Creator Device
#Button

# - - - - - - - - - - LET'S BEGIN - - - - - - - - - - - # 

#Code will not run without proper references
#Below are the current reference this code is using
#This should always appear at the top of the script.

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# - - - - - - - - - - HELLO - - - - - - - - - - - # 

#Hello to you! 
#This device will allow players to press a button to toggle (turn a vfx effect on and off)
#I have made sure to document this Verse script to help you in your journey!
#You can use it as a learning tool or even in your next Verse Project! 

# - - - - - - - - - - DEVICE NAME- - - - - - - - - - - # 

#Devicename goes below (this is automatically present when you create your device)
button_vfx_device := class(creative_device):

# - - - - - - - - - - BUILDING YOUR CODE STRUCTURE - - - - - - - - - - - # 

        #Verse is very sensitive to {structure} and is {case-sensitive}
        #Below your #devicename you will want to put editable devices and variables

# - - - - - - - - - - WHAT ARE EDITABLE DEVICES? - - - - - - - - - - - # 
        #When you make a device editable or @editable, it exposes a Verse-authored device 
        #to the editor, thus making it an editable property! 

        #The common syntax structre for editable devices is:

        #@editable
        #PropertyName : type = DefaultValue
        
        #Here is the breakdown of the active syntax below (in blue) .

        #@editable - this is an {attribute} in Verse that makes a device property editable. Its value
        #will be able to be changed by the user in the editor. To simplify, the 'Button' property is being
        #marked as editable.

        #Button - This is the PropertyName and defines the type.

        #button_device - This is the type or in other words a predefined type in Verse that represents
        #clickable button. 

        #= button_device{} - This initializes the button PropertyName with a new instance of the button_device
        #class. The curly braces creates an archetype instantiation, which is a process of creating an instance or class
        #that is fully defined with values for its fields in a class. 

        #Please review the two active editable syntaxes for our code below and
        #add more of your own to practice!
        #If you entered in your code correctly,there will be no red errors on the screen.

        #BIND YOUR DEVICES 
        #This is very important, you must bind your devices, so they are connected properly. 
        #Here are some steps on how to do this.

        #After you are done writing in your @editables:
        #1. Save this file
        #2. Go to Unreal Editor
        #3. Run your Verse code
        #4. View your Details tab (make sure your new device is selected)
        #5. And See your new editables!
        #6. Every device that you set to be @editable should be listed there
        #7. Just like we do in event binding, select the empty dropdown menu and bind your device to the 
        #device in your outliner.


# - - - - - - - - - - ACTIVE EDITABLE DEVICES - - - - - - - - - - - # 

        @editable
        Button:button_device = button_device{}

        @editable
        VFXCreator:vfx_creator_device = vfx_creator_device{}

# - - - - - - - - - - WHAT ARE VARIABLES? - - - - - - - - - - - # 
        #Variables(if Any would go below editable devices) 

        #A Variable is a value that can be changed while a program is running. It's called a variable
        #because it can vary or even be set to vary! You will see variables most commonly used when 
        #creating UI or even for creating elements that are needed to be positioned or moved on the
        #screen. There are many other amazing uses too! 

        #There are no variables needed for this device so we will leave this space
        #empty. 

# - - - - - - - - - - ACTIVE VARIABLES - - - - - - - - - - - #

        #if no variables to enter - leave empty=void{}
         

# - - - - - - - - - - RUNNING THE CODE - - - - - - - - - - - #     

        #Here you will find all the elements that allows your Verse Code 
        #to run in your game! Lets call it Code Runner!

        #You will see in areas we use the Print Syntax to send a message to the log
        #that our code is healthy and running well! It can also allow you to keep track of 
        #processes in the order that you wish them to run! 

        #The Print Syntax looks like this 
        #Print("Hello, world!")
        #See if you can find it used below!

    #CodeRunner Begins Here!

    #this means the code will run when the game begins!
    
    OnBegin<override>()<suspends>:void=

        #This disables the VFX Device at Game Start so it isnt viewable to the player.
        VFXCreator.Disable()
        Print("VFX Hidden!")

        #Let's make the button interactable so that it connects to the vfx creator device!
        #Also it is important that all code that you plan to run is properly nested.

        #This event allows the button to be interactable or clickable
       Button.InteractedWithEvent.Subscribe(OnButtonIntertactedWith)
       Print("Button Interactable!")

       #This event allows the VFX to toggle on and off when the player presses the button.
 OnButtonIntertactedWith(InPlayer:agent):void= 

        #This will enable the device as soon as the button is pressed 
        #with a print message to log!

        VFXCreator.Enable()
        Print("Button Ready!")
        
        #This will toggle the VFXCreator on and off with a Print message showing each time to Log!
        VFXCreator.Toggle()

        #This will print everytime the button is pressed, so you can see that the code
        #is running properly. Adding a Print note is optional!

        Print("VFX Toggle Ready") #optional 


        #Congrats you just learned how to create a new device in Verse that toggles an effect
        #and off! 
# - - - - - - - - - - CONNECT WITH ME - - - - - - - - - - - # 

        #If this Code Snippet helped you, please let me know!
        #Don't forget to say Hi! 
        #I will send you a warm hello back!

        #Twitter: https://twitter.com/yo_its_dragon
        #Youtube: https://youtube.com/yo_its_dragon

        #MyFNCCreativeTeam
        #TeamProdigy : https://discord.gg/teampro 

        #Recommended Creative Communities
        #FCHQ : https://fortnitecreativehq.com
        #TheCreativeBlok : https://thecreativeblok.com
        #TeamProdigy Discord : https://discord.gg/teampro 
        #DirectingPete Discord : https://discord.gg/Zu5Ugkdu


# - - - - - - - - - - RESOURCES - - - - - - - - - - - # 
        #Continue learning with these resources 
        #All VFX CREATOR Device Functions 
        #https://dev.epicgames.com/documentation/en-us/uefn/verse-api/fortnitedotcom/devices/vfx_creator_device
        #How To Create a Device Using Verse (Learn how to Spawn a Gold Coin)
        #https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

