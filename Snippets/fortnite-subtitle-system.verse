# Title: Subtitle system
# Subtitle: Hi, I have done a subtitle system using Verse.
If you have any questions, comments, or feedback to improve it, please do not hesitate to share it here.
# Author: HugoMeta4 [ /community/profile/GVnoV/HugoMeta4 ]
# Created: Tue Jan 31 2023 16:04:21 GMT+0000 (Coordinated Universal Time)
# Last Updated: Tue Jan 31 2023 16:04:21 GMT+0000 (Coordinated Universal Time)
# Snippet Link: https://dev.epicgames.com//community/snippets/yA9/fortnite-subtitle-system
# ------

# None
# Note: None
<## ABOUT ## ===========================================================================================================================##
    Subtitle is a tool to integrate trigger-based subtitles in your game.
    This system uses the UEFN UI verse system and displays only 2 lines of subtitles                                                                                                                
                                                                                                                                           
           By: Hugo Lagarde (Meta4) | Slack : @Hugo Lagarde | Discord : Testa#5064 | hlagarde@xa.epicgames.com                                                                                        
           Version: 1.3
           First Published:  12/13/2022                                                                                                                
           Last Updated:     01/30/2023                                                                                                 
                                                                                                                                         
## ABOUT ## ===========================================================================================================================##> 
using { /Fortnite.com/Devices }
using { /Fortnite.com/Playspaces}
using { /Fortnite.com/UI }
using { /Verse.org/Native }
using { /Verse.org/Simulation }
using { /Verse.org/Verse}
using { /EpicGames.com/Temporary/Diagnostics }
using { /EpicGames.com/Temporary/UI }
using { /EpicGames.com/Temporary/SpatialMath }
using { /Verse.org/Colors}
using { /Verse.org}
log_Subtitle := class(log_channel){}
# Subtitle Data list =======================================================================
task_<public>:= struct<concrete>:
    @editable
    line1List: []string = array{}
    @editable
    line2List: []string = array{}
    @editable
    time_array: []float = array{}
    @editable
    canInterrup:logic = true
    @editable
    canPlayAfter:logic = false
    @editable
    InstigatorOnly:logic = false
# End Subtitle Data list ===================================================================
Subtitle := class(creative_device):
    Logger:log = log{Channel:=log_Subtitle}
    # Device List and associate trigger  =======================================================
    @editable
    playerSpawnerRef: []player_spawner_device = array{}
    
    @editable
    TestTrigger : mutator_zone_device = mutator_zone_device {}

    # End Device List and associate trigger  ===================================================
    # Subtitle list  ===========================================================================

    @editable
    TestTriggerSubtitle:task_ = task_{}
    
    # End Subtitle list  =======================================================================
    # Subtitle system  =========================================================================

    var TaskList : []task_ = array{} 
    var currentTask : task_ = task_{}
    var currentLine : int = 0
    var checkText :string = ""
    var Canvas:?canvas = false
    str<localizes>(newStr:string):message = "{newStr}" 
    var Line1:text_block = text_block{  DefaultJustification := text_justification.Center, DefaultTextColor := Colors.MakeColorFromSRGBValues(255,255,255), DefaultShadowColor := Colors.MakeColorFromSRGBValues(0,0,0)}
    var Line2:text_block = text_block { DefaultJustification := text_justification.Center, DefaultTextColor := Colors.MakeColorFromSRGBValues(255,255,255), DefaultShadowColor := Colors.MakeColorFromSRGBValues(0,0,0)}
    var playerRef :[]player = array{}
    # End Subtitle system  =====================================================================
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void={

        Line1.SetText(str(""))
        Line2.SetText(str(""))

        for(p:playerSpawnerRef){
            p.SpawnedEvent.Subscribe(SpawnUI)
        }

        TestTrigger.AgentEntersEvent.Subscribe(TestTriggerSubtitleTrigger)
        
    }
    # TriggerEvent Function  ====================================================================
    TestTriggerSubtitleTrigger(Player:agent):void={ UpdateNewTaskList(Player, TestTriggerSubtitle) }

    UpdateNewTaskList(Player:agent, newTask: task_):void={
        if(newTask.InstigatorOnly = false){
            set TaskList += array{newTask}
            RunTaskList()
        }
        else{
            if(Player = playerRef[0]){
                set TaskList += array{newTask}
                RunTaskList()
            }
        }
    }
    # End TriggerEvent Function  ===============================================================
    # Run SubtitleSystem Function  ============================================================
    #Current Task is always the first task in the list
    GetCurrentTask()<decides><transacts>:task_ ={ return TaskList[0] }
    UpdateTextToTest()<decides><transacts>:void={ set checkText= currentTask.line1List[currentLine]}
    RunTaskList():void={     
        #Update current Task
        if(set currentTask = GetCurrentTask[]){}
        if(lastTrigger := TaskList.Length -1 >= 0 ){
            
            #Check if there is only one task
            if(TaskList.Length = 1)
            {
                set currentLine = 0
                RunText(currentLine)
            }
            else if (TaskList.Length > 1){
                #Check if the last task trigger can Interrup
                if(TaskList[lastTrigger].canInterrup = false){
                    #Check if the last task trigger can be add in the queue
                    if(TaskList[lastTrigger].canPlayAfter = false){
                        if:
                            set TaskList = TaskList.RemoveElement[TaskList.Length-1]
                    }
                }
                else{
                    EndVoiceLine()
                }
            }  
        }
    }
    RunText(Index:int):void={ 
        #Update the Text to test for the can Interrupt option 
        if(UpdateTextToTest[]){}
        #Update the Text Block
        if(currentStr := currentTask.line1List[Index]){ Line1.SetText(str(currentStr)) }
        if(currentStr := currentTask.line2List[Index]){ Line2.SetText(str(currentStr)) }
        #Check if it's the last voice line
        if(currentTask.time_array.Length = currentLine){
            if(timer := currentTask.time_array[currentLine - 1]){ EndVoiceLine() }
        }
        else{
            if(timer := currentTask.time_array[Index]){ spawn{ CheckNextText(timer, Index, checkText) } }
        }    
    }
    
    EndVoiceLine():void={
        #Remove the task from the task list when the task is completed and resets values
        if:
            set TaskList = TaskList.RemoveElement[0]
            if(set currentTask = GetCurrentTask[]){}
        
        set currentLine = 0
        #Reset the value of the 2 text blocks
        Line1.SetText(str(""))
        Line2.SetText(str(""))
        #Is there is a other task in the task list run the next one
        if(TaskList.Length > 0 ){
            RunTaskList()
        }
    }
    
    CheckNextText(timer:float, Index: int, currentText:string)<suspends>:void={
        #Update the line to check
        set currentLine += 1
        #Time before skip to the next text
        Sleep(timer)
        # Check if we still in the same task
        if(checkText = currentText){
            RunText(Index + 1)    
        }
    }  
    # End Run SubtitleSystem Function  =================================================
    
    # UI Settings  =====================================================================
    SpawnUI(Player:agent):void={
        if(ActualPlayer := player[Player]){
            set playerRef += array{ActualPlayer}
            if(myPlayerUI := GetPlayerUI[ActualPlayer]){
                if(TmpCanvas := Canvas?){
                    myPlayerUI.RemoveWidget(TmpCanvas)
                    set Canvas = false
                }
                else {
                    NewCanvas := MakeCanvas()
                    myPlayerUI.AddWidget(NewCanvas, player_ui_slot{InputMode := ui_input_mode.None})
                    set Canvas = option{NewCanvas}
                }
            }
        }
    }
    
    MakeCanvas():canvas={
            
        NewCanvas := canvas {
            Slots := array{
                canvas_slot : 
                    Anchors := anchors{ Maximum:= vector2{X:=1.0, Y:=1.0} }
                    Offsets := margin{ Top:=825.0, Left:= 0.0, Right:=0.0, Bottom := 100.0 }
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Left
                                VerticalAlignment := vertical_alignment.Bottom
                                Distribution := option{0.25}
                                Widget := text_block{DefaultText:= str("")}
                            
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Fill
                                VerticalAlignment := vertical_alignment.Fill
                                Distribution := option{0.5}
                                Widget := stack_box:
                                    Orientation := orientation.Vertical
                                    Slots := array:
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Center
                                            Widget := Line1
                                             
                                        stack_box_slot:
                                            Widget := Line2
                                            HorizontalAlignment := horizontal_alignment.Center
                            
                            stack_box_slot: 
                                HorizontalAlignment := horizontal_alignment.Fill
                                VerticalAlignment := vertical_alignment.Fill
                                Distribution := option{0.25}
                                Widget := text_block{DefaultText:= str("")}
                }  
        }
        return NewCanvas
    }
    
    RemoveMyWidget(Message: widget_message):void={
        if(TmpPlayerUI := GetPlayerUI[Message.Player], TmpCanvas := Canvas? ){
            TmpPlayerUI.RemoveWidget(TmpCanvas)
            set Canvas = false
        }
    }
    # End UI Settings  ==================================================================
