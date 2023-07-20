# Title: Number Guesser Game
# Subtitle: None
# Author: Snownymous (XA / UEFN Alpha Account) [ /community/profile/l5LzO/SnowSoftServe ]
# Created: Sun Aug 28 2022 04:58:45 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sun Aug 28 2022 04:58:45 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/EBg/fortnite-number-guesser-game
# ------

# Random Number Game
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Native }
using { /EpicGames.com/Temporary/Diagnostics }
using { /Verse.org/Random }
using { /Verse.org/Simulation}

log_Number_Guessing:=class(log_channel){}

Number_Guessing := class<concrete>(creative_device):
    Logger:log = log{Channel:=log_Number_Guessing}

# Defines Devices =============================================================================================
    @editable
    Button_Pick_Num: button_device = button_device{}
    @editable
    ItemGranter_PickNum_to_HUD: item_granter_device = item_granter_device{}


# Guess #1 ====================================================================================================
    @editable
    Button_Num1: button_device = button_device{}
    @editable
    ItemGranter_Num1_to_HUD_Success: item_granter_device = item_granter_device{}
    @editable
    ItemGranter_Num1_to_HUD_Fail: item_granter_device = item_granter_device{}


# Guess #2 ====================================================================================================
    @editable
    Button_Num2: button_device = button_device{}
    @editable
    ItemGranter_Num2_to_HUD_Success: item_granter_device = item_granter_device{}
    @editable
    ItemGranter_Num2_to_HUD_Fail: item_granter_device = item_granter_device{}

# Guess #3 ====================================================================================================
    @editable
    Button_Num3: button_device = button_device{}
    @editable
    ItemGranter_Num3_to_HUD_Success: item_granter_device = item_granter_device{}
    @editable
    ItemGranter_Num3_to_HUD_Fail: item_granter_device = item_granter_device{}


    var RandomNumberVar: int = 0

    OnBegin<override>()<suspends>:void=
        Logger.Print("Verse device started!")

# Links functions to Devices =================================================================================
        Button_Pick_Num.InteractedWithEvent.Subscribe(ButtonInteractPick_Num)

        Button_Num1.InteractedWithEvent.Subscribe(ButtonInteractNum1)
        Button_Num2.InteractedWithEvent.Subscribe(ButtonInteractNum2)
        Button_Num3.InteractedWithEvent.Subscribe(ButtonInteractNum3)

# Action when Player Hits Pick_Num Button =================================================================================   
    ButtonInteractPick_Num(Player:player):void=
        RandomNum:int = GetRandomInt(1, 3)
        ItemGranter_PickNum_to_HUD.GrantItem(Player)
        Logger.Print("Picked Random Number. Number selected is {RandomNum}")
        set RandomNumberVar = RandomNum

# Action when Player Hits NUM_1 Button =================================================================================   
    ButtonInteractNum1(Player:player):void=
        Logger.Print("Button #1 Intracted")
        if (RandomNumberVar = 1):
            ItemGranter_Num1_to_HUD_Success.GrantItem(Player)
            Logger.Print("Correct! #1 was the Random Number")
        else:
            ItemGranter_Num1_to_HUD_Fail.GrantItem(Player)
            Logger.Print("Incorrect! #1 wasn't the Random Number")

# Action when Player Hits NUM_2 Button =================================================================================   
    ButtonInteractNum2(Player:player):void=
        Logger.Print("Button #2 Intracted")
        if (RandomNumberVar = 2):
            ItemGranter_Num2_to_HUD_Success.GrantItem(Player)
            Logger.Print("Correct! #2 was the Random Number")
        else:
            ItemGranter_Num2_to_HUD_Fail.GrantItem(Player)
            Logger.Print("Incorrect! #2 wasn't the Random Number")
# Action when Player Hits NUM_3 Button =================================================================================   
    ButtonInteractNum3(Player:player):void=
        Logger.Print("Button #3 Intracted")
        if (RandomNumberVar = 3):
            ItemGranter_Num3_to_HUD_Success.GrantItem(Player)
            Logger.Print("Correct! #3 was the Random Number")
        else:
            ItemGranter_Num3_to_HUD_Fail.GrantItem(Player)
            Logger.Print("Incorrect! #3 wasn't the Random Number")
