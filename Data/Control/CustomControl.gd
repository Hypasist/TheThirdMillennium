class_name playerControl
extends Node
const cons = preload("res://Data/Utils/Constants.gd")
const utils = preload("res://Data/Utils/Utils.gd")

var controlledObject: Node = null
var assignedCamera: Node = null
var gatherInput = false

func _input(event): # zoom counter event
    var zoomCounter = 0
    if(assignedCamera && gatherInput):
        if event is InputEventMouseButton and event.pressed:
            if event.button_index == BUTTON_WHEEL_UP: assignedCamera.zoomChange(-1)
            if event.button_index == BUTTON_WHEEL_DOWN: assignedCamera.zoomChange(1)


func startGatherInput():
    gatherInput = true
    
func stopGatherInput():
    gatherInput = false

func assignControlledObject(object: Node):
    controlledObject = object

func assignCamera(object: Node):
    assignedCamera = object
