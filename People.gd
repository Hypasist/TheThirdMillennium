extends Node

var peopleLists = []

func _ready():
    for i in get_child_count():
        peopleLists.append(get_child(i))

func resolve_people_physics_process(delta):
    for i in peopleLists.size():
        peopleLists[i].custom_physics_process(delta)
