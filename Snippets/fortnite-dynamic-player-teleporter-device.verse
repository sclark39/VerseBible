# Title: Dynamic Player Teleporter Device
# Subtitle: To use this device, create a prop and attach a teleporter device to it. Ensure the teleport device has zero local position and rotation. Assign the prop and teleporter device to the editable properties and then call `TeleportAgentTo`.
# Author: Rift9 [ /community/profile/KQDbl/le-8g7e ]
# Created: Sat Jul 08 2023 21:48:23 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Jul 08 2023 21:48:23 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/1WAo/fortnite-dynamic-player-teleporter-device
# ------

# dynamic_player_teleporter_device
# Note: Allows you to easily teleport players around the world with only translations and rotation values in Verse.
using { /Fortnite.com/Devices }

using { /Verse.org/Simulation }

using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# To use this device, create a prop and attach a teleporter device to it. Ensure the teleport device
# has zero local position and rotation. Assign the prop and teleporter device to the editable
# properties and then call `TeleportAgentTo`.

dynamic_player_teleporter_device_log := class(log_channel){}

dynamic_player_teleporter_device := class(creative_device):

    Logger : log = log{Channel:=dynamic_player_teleporter_device_log}

    @editable
    TeleporterDevice: teleporter_device = teleporter_device{}

    @editable
    TeleporterRoot: creative_prop = creative_prop{}

    # Teleports an agent to a given translation and rotation. Note, only the yaw axis is used
    # on rotation by setting the teleporter rotation (if you configure your teleporter to use set player rotation)
    TeleportAgentTo(Agent: agent, Translation: vector3, Rotation: rotation):void =

        if(TeleporterRoot.TeleportTo[Translation, Rotation]):

            Logger.Print("Teleporting agent to {Translation}", ?Level:=log_level.Verbose)

            TeleporterDevice.Teleport(Agent)

        else. Logger.Print("Failed to move dynamic teleporter prop!", ?Level:=log_level.Error)

