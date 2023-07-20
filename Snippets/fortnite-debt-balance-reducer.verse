# Title: Debt balance reducer
# Subtitle: Are you tired of drowning in debt? Well, have no fear because there is a new debt balance reducer also known as (DBR) tool to save the day!
# Author: Mastrd [ /community/profile/086B/Mastrd ]
# Created: Fri Apr 28 2023 08:19:39 GMT+0000 (Coordinated Universal Time)
# Last Updated: Fri Apr 28 2023 08:19:39 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/wyX/fortnite-debt-balance-reducer
# ------

# None
# Note: You can now play your way to financial freedom in your island, where you can slash your debt with every move. Let's get playing and start crushing those debt card balances!
# A Verse-authored creative device that can be placed in a level
hello_world_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        MinimumPayment : float = 20.0
        ExtraPayment : float = 10.0
        var Balance : float = 1000.0

        BalanceStatusText : string = "Your balance now "
        var EffectOnBalanceText: string = "increased "
    
        set Balance = Balance - MinimumPayment
        Print("Your balance has {EffectOnBalanceText + ToString(MinimumPayment)}")
        Print("{BalanceStatusText + ToString(Balance)}")
    
        set Balance = Balance - ExtraPayment
        set EffectOnBalanceText = "decreased "
        Print("Your balance has {EffectOnBalanceText + ToString(ExtraPayment)}")
        Print("{BalanceStatusText + ToString(Balance)}")
