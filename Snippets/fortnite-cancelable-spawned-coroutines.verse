# Title: Cancelable Spawned Coroutines
# Subtitle: This allows you to spawn unstructured "concurrent expressions" (aka coroutines) that you can cancel later on from outside the coroutine itself. Usage: `MyRoutine := SpawnRoutine(MyTask)` and then later `MyRoutine.Cancel()`
# Author: MattRix [ /community/profile/bpoG6/MattRix ]
# Created: Sat Apr 22 2023 14:40:30 GMT+0000 (Coordinated Universal Time)
# Last Updated: Sat Apr 22 2023 14:40:30 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/4dl/fortnite-cancelable-spawned-coroutines
# ------

# routine.verse
# Note: Note: you can get the task using `MyRoutine.GetTask[]` and check if it's still running using `MyRoutine.IsRunning[]`
using { /Verse.org/Concurrency }

SpawnRoutine<public>(Func : type{_()<suspends>:void}):routine = 
    Routine := routine{Func := Func}
    Routine.Start()
    return Routine

routine<public> := class():
    Func<public> : type{_()<suspends>:void} 
    Event<protected> : event() = event(){}
    var MaybeTask<protected> : ?task(void) = false 
    var _IsRunning<protected> : logic = false

    Start<internal>():void = 
        Task := spawn {RunRoutine()}
        set MaybeTask = option {Task}

    RunRoutine<protected>()<suspends>: void = 
        set _IsRunning = true
        race:
            Func()
            Event.Await()
        set _IsRunning = false

    Cancel<public>():void = Event.Signal()

    GetTask<public>()<decides><transacts>:task(void) = MaybeTask?

    IsRunning<public>()<decides><transacts>:void = _IsRunning?
