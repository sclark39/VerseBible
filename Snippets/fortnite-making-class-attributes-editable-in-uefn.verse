# Title: Making Class attributes editable in UEFN
# Subtitle: Figuring which types can be made @editable for UEFN
# Author: spilth [ /community/profile/AqXp9/spilth ]
# Created: Mon Mar 27 2023 01:21:23 GMT+0000 (Coordinated Universal Time)
# Last Updated: Mon Mar 27 2023 01:21:23 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/zW2/fortnite-making-class-attributes-editable-in-uefn
# ------

# None
# Note: None
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

direction := enum{Up, Down, Left, Right}

coordinates := struct<concrete>:
    @editable
    X : float = 0.0

    @editable
    Y : float = 0.0

animal := class<concrete>:
    @editable
    Name : string = "Fido"

    @editable
    Sound : string = "Woof!"

rideable := interface():
    Mount()<decides> : void
    Dismount()<decides> : void

exploratory_device<public> := class<concrete>(creative_device):
    # String
    @editable
    String:string = "Default"

    # Array of Strings
    @editable
    Strings:[]string = array{"One", "Two", "Three"}

    # Logic
    @editable
    Logic:logic = true

    # Array of Logic
    @editable
    Logics:[]logic = array{true, false, true}

    # Integer
    @editable
    Integer:int = 42

    # Array of Integers
    @editable
    Integers:[]int = array{1,2,3}

    # Float
    @editable
    Float:float = 42.0

    # Array of Floats
    @editable
    Floats:[]float = array{1.0, 2.0, 3.0}

    # Creative Device
    @editable
    CreativeDevice:creative_device = creative_device{}

    # Array of Creative Devices
    @editable
    CreativeDevices:[]creative_device = array{}

    # Specific Creative Device
    @editable
    PlayerSpawnDevice:player_spawner_device = player_spawner_device{}

    # Array of Specific Creative Devices
    @editable
    PlayerSpawnDevices:[]player_spawner_device = array{}

    # Enumerations
    @editable
    Direction:direction = direction.Up

    # Classes - must be concrete, have default values and editable fields
    @editable
    Animal:animal = animal{}

    # Transforms - These have weird field names, must include SpatialMath
    @editable
    Transform:transform = transform{}

    # Vector2 - These have weird field names
    @editable
    Vector2:vector2 = vector2{}

    # Structs - must be concrete and have default values
    @editable
    Enumeration:coordinates = coordinates{X := 1.0, Y := 1.0}

    # The editable attribute is not supported for data definitions of these types:
    # 
    # @editable
    # Char:char = "a"
    #
    # @editable
    # Char32:char32 = "a"
    #
    # @editable
    # MaybeANumber:?int = option{42}
    #
    # @editable
    # WordCount:[string]int = map{"apple" => 11, "pear" => 7}
    #
    # @editable
    # Tuple:tuple(string, int, float) = ("One", 1, 1.0)
    #
    # @editable
    # Interface:rideable = interface(rideable)
    
    OnBegin<override>()<suspends>:void=
        Print("Hello, world!")

