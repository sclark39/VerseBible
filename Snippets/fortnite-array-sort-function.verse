# Title: Array Sort Function
# Subtitle: A basic parametric/generic implementation of quicksort for arrays in Verse. I've included a CompareInt() function, but you can write your own function for whichever types you want to compare.
Usage: `SortedItems := Sort(Items, true, CompareInts)`
# Author: MattRix [ /community/profile/bpoG6/MattRix ]
# Created: Fri Apr 28 2023 21:44:13 GMT+0000 (Coordinated Universal Time)
# Last Updated: Fri Apr 28 2023 21:44:13 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/l0X/fortnite-array-sort-function
# ------

# None
# Note: None
Sort(Items : []t, IsAscending : logic, Comparer: type{_(:t, :t)<computes> : int} where t : type)<computes> : []t = 
    if (Items.Length > 1, Pivot := Items[Floor(Items.Length/2)]):
        Left := for(Item : Items, Comparer(Item, Pivot) < 0) do Item 
        Middle := for(Item : Items, Comparer(Item, Pivot) = 0) do Item
        Right := for(Item : Items, Comparer(Item, Pivot) > 0) do Item
        if(IsAscending?):
            Sort(Left, IsAscending, Comparer) + Middle + Sort(Right, IsAscending, Comparer)
        else: 
            Sort(Right, IsAscending, Comparer) + Middle + Sort(Left, IsAscending, Comparer)
    else:    
        Items 

CompareInts(A : int, B : int)<computes>: int = 
    if(A < B) then -1
    else if(A > B) then 1
    else 0

#How to use it:
SortedItems := Sort(Items, true, CompareInts)
