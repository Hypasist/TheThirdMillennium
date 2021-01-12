class_name CustomGUI
extends Control
var cons = preload("res://Data/Utils/Constants.gd")

var followedEntity = null

func assign2Entity(entity):
    followedEntity = entity
