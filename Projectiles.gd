extends Node

func resolve_projectiles_physics_process(delta):
    for i in get_child_count():
        get_child(i).custom_physics_process(delta)
