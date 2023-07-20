# Title: Voting System
# Subtitle: A simple voting system built in Verse. There's an explanatory tutorial that goes with it on YouTube.

Note: If someone deletes this snippet, please send me a message as to why.
# Author: Nooberling [ /community/profile/rEZlv/Nooberling ]
# Created: Wed Jun 28 2023 14:01:34 GMT+0000 (Coordinated Universal Time)
# Last Updated: Wed Jun 28 2023 14:01:34 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/2rrO/fortnite-voting-system
# ------

# Vote Manager Device
# Note: A management device that interacts with an array of vote class option devices to manage a voting system.

using { /Fortnite.com/Devices }
using {/Fortnite.com/Playspaces}
using {/Fortnite.com/Characters}
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
vote_manager_device := class(creative_device):

    var CurrentClassVotes : [player]int = map{}
    @editable TotalClassCount : int = 4
    @editable VoteClassOptionDevices : []vote_class_option_device = array{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        return

    GetWinnerAndSetClass(): void =
        WinningClass := GetWinningClass()
        SelectWinningClassAndSend(WinningClass)

    VoteForClass(AgentIn : agent, ClassIn : int):void =
        if (Player := player[AgentIn]):
            var NewMap : [player]int = map{}
            if (CurrentClassVotes[Player]):
                for (Key -> Value : CurrentClassVotes, Key <> Player):
                    if {set NewMap[Key] = Value}
                if {set NewMap[Player] = ClassIn}
                set CurrentClassVotes = NewMap
            else:
                if {set CurrentClassVotes[Player] = ClassIn}
        return

    GetVotesForClassID (ClassIDIn : int) : int =
        var CurrentCount : int = 0
        for (Key->Value : CurrentClassVotes):
            if (Value = ClassIDIn):
                set CurrentCount = CurrentCount + 1
        return CurrentCount

    GetWinningClass () : int =
        var intWinningClass : int = 0
        var intCurrentHighestCount : int = 0
        for(Value := 1..TotalClassCount ):
            var intCurrentCount : int = GetVotesForClassID(Value)
            if (intCurrentCount > intCurrentHighestCount):
                set intCurrentHighestCount = intCurrentCount
                set intWinningClass = Value 
        Print("Winning Class: {intWinningClass}")
        return intWinningClass

    SelectWinningClassAndSend(ClassIDIn : int) : void =
        for(currentVoteClassOptionDevice : VoteClassOptionDevices) :
            var currentClassID : int = currentVoteClassOptionDevice.GetClassID()
            if (currentClassID = ClassIDIn):
                currentVoteClassOptionDevice.SetAllPlayersToClass()
        return

    UpdateOptionBillboards() : void =
        for(Device : VoteClassOptionDevices):
                Device.UpdateBillboard()
