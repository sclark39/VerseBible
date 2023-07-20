# Title: Button for Driftboard Spawner and Item Spawner
# Subtitle: On SpawnButton interaction, a signal is sent to the ItemSpawner and the DriftboardSpawner -> The ItemSpawner SpawnItem function is called and spawns an Apple -> The DriftboardSpawner RespawnVehicle function is called and spawns/resets a driftboard.
# Author: Hourences [ /community/profile/BE8/Hourences ]
# Created: Wed Jul 20 2022 15:13:40 GMT+0000 (Coordinated Universal Time)
# Last Updated: Wed Jul 20 2022 15:13:40 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/Vd0/fortnite-button-for-driftboard-spawner-and-item-spawner
# ------

# None
# Note: Verse way to set this up
using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }

button_spawner := class<concrete>(creative_device):
    @editable
    DrifboardSpawner:vehicle_spawner_device = vehicle_spawner_device{}
    @editable
    ItemSpawner:item_spawner_device = item_spawner_device{}
    @editable
    SpawnButton:button_device = button_device{}

    OnBegin<override>()<suspends>:void=
       SpawnButton.InteractedWithEvent.Subscribe(SpawnDriftboard) 
       SpawnButton.InteractedWithEvent.Subscribe(SpawnItem) 

    SpawnDriftboard(Player:player):void=
        DrifboardSpawner.RespawnVehicle()

    SpawnItem(Player:player):void=
        ItemSpawner.SpawnItem(Player)

