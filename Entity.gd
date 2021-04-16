class_name Entity
extends KinematicBody2D

var cons = preload("res://Data/Utils/Constants.gd")
var utils = preload("res://Data/Utils/Utils.gd")

var movementPaused = false
var gatheredInputs = []


func passInputs(inputs:Array):
    gatheredInputs = inputs

func pauseMovement():
    movementPaused = true
    
func unpauseMovement():
    movementPaused = false
