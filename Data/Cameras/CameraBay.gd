extends Node

func resolve_camera_process(delta):
    for i in get_child_count():
        get_child(i).custom_camera_process(delta)
