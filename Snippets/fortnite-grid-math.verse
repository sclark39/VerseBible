# Title: Grid Math
# Subtitle: Easy conversion between a 1d index and a 2d or 3d location
# Author: wasti [ /community/profile/n0JM/wasti ]
# Created: Tue May 02 2023 08:57:45 GMT+0000 (Coordinated Universal Time)
# Last Updated: Tue May 02 2023 08:57:45 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/lkW/fortnite-grid-math
# ------

# None
# Note: None

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Diagnostics }

vector3i := struct<concrete>:
    @editable
    X:int = 0
    @editable
    Y:int = 0
    @editable
    Z:int = 0


# This device allows for easy conversion between a 1d index and a 2d or 3d location
grid_device := class(creative_device):
    RowSize:int=10  <# How many tiles per row, Do not use 0! #>
    ColumnSize:int=10 <# How many tiles per column, only used for 3d grids, Do not use 0! #>
    GridSize:vector3=vector3{X:=512.0,Y:=512.0,Z:=384.0} <# The fortnite default grid size #>
    
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Grid Device Initialized!")
        Print("2d Grid Index 17: X = {IndexToGrid2D(17).X}  Y = {IndexToGrid2D(17).Y}")
        Print("3d Grid Index 37: X = {IndexToGrid3D(37).X}  Y = {IndexToGrid3D(37).Y}  Z = {IndexToGrid3D(37).Z}")
    
    IndexToGrid2D(InIndex:int):vector2i=
        if(Grid_X:int = Mod[InIndex,RowSize]):
            if(Grid_Y:int = Floor(InIndex/RowSize)):
                return vector2i{X:=Grid_X,Y:=Grid_Y}
        return  vector2i{X:=-1,Y:=-1}

    Grid2DToIndex(InPoint:vector2i):int=
        return (InPoint.X + (InPoint.Y * RowSize))

    Grid2DToLocation(InPoint:vector2i):vector3=
        return vector3{X:=(InPoint.X*GridSize.X),Y:=(InPoint.Y*GridSize.Y),Z:=0.0}
    
    IndexToGrid3D(InIndex:int):vector3i=
        LevelSize:int=RowSize*ColumnSize
        if(Grid_X:int = Mod[InIndex,RowSize]):
            if(Grid_Y:int = Floor(Mod[InIndex,LevelSize]/RowSize)):
                if(Grid_Z:int = Floor(InIndex/LevelSize)):
                    return vector3i{X:=Grid_X,Y:=Grid_Y,Z:=Grid_Z}
        return  vector3i{X:=-1,Y:=-1,Z:=-1}

    Grid3DToIndex(InPoint:vector3i):int=
        return (InPoint.X + (InPoint.Y * RowSize) + (InPoint.Z * (RowSize*ColumnSize)))
    
    Grid3DToLocation(InPoint:vector3i):vector3=
        return vector3{X:=(InPoint.X*GridSize.X),Y:=(InPoint.Y*GridSize.Y),Z:=(InPoint.Z*GridSize.Z)}
