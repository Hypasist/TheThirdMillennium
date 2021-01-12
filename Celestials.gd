extends Node

var celestialLists = []

func _ready():
    for i in get_child_count():
        celestialLists.append(get_child(i))

func custom_physics_process_content(delta):
    for i in celestialLists.size():
        celestialLists[i].custom_physics_process(delta)
