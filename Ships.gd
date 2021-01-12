extends Node

var shipLists = []

func _ready():
    for i in get_child_count():
        shipLists.append(get_child(i))

func resolve_ships_physics_process(delta):
    for i in shipLists.size():
        shipLists[i].custom_physics_process(delta)
