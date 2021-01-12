extends Node

func resolve_control_process():
    for i in get_child_count():
        get_child(i).gather_and_distribute_input()
