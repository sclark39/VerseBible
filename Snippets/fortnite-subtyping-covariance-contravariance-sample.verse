# Title: Subtyping(covariance&contravariance) Sample
# Subtitle: None
# Author: t.tutiya [ /community/profile/9vEJ7/t.tutiya ]
# Created: Sat Apr 29 2023 01:20:34 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Apr 29 2023 01:20:34 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/Nyr/fortnite-subtyping-covariance-contravariance-sample
# ------

# None
# Note: None
#Subtyping Sample Code

#type
#Cat <: Animal (tuple isn't subclass of []int, but it's subtype)
TypeCat    := tuple(int,int)
TypeAnimal := []int

#Function Type
TypeA2A := type{_(:TypeAnimal) : TypeAnimal}
TypeC2A := type{_(:TypeCat)    : TypeAnimal}

#Like Functor
FunctorA2A(X:TypeAnimal, Y:TypeA2A) : TypeAnimal = Y(X)  
FunctorC2A(X:TypeCat,    Y:TypeC2A) : TypeAnimal = Y(X)  

#Function
FuncA2A(X:TypeAnimal): TypeAnimal := X
FuncC2A(X:TypeCat   ): TypeAnimal := X
#Instantiate TypeCat because X(TypeAnimal) cannot cast to TypeCat
FuncA2C(X:TypeAnimal): TypeCat    := TypeCat(2, 3) 

my_first_device := class(creative_device):
    OnBegin<override>()<suspends>:void=
        ValCat    :TypeCat    = (0, 1)
        ValAnimal :TypeAnimal = (100, 200, 300, 400)

        #covariance
        #(Animal->Cat) <: (Animal->Animal)
        Result1 := FunctorA2A(ValAnimal, FuncA2A)
        Result2 := FunctorA2A(ValAnimal, FuncA2C)

        #contravariance
        #(Animal->Animal) <: (Cat->Animal)
        Result3 := FunctorC2A(ValCat,    FuncC2A)
        Result4 := FunctorC2A(ValCat,    FuncA2A)
