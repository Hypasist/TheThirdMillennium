extends Node

var tilesetDatabase = null

func setTilesetDatabase(_tilesetDatabase:Dictionary):
    tilesetDatabase = _tilesetDatabase

func resolve_ships_physics_process(delta):
    for i in get_child_count():
        get_child(i).custom_physics_process(delta)

func addShip():
    var ship = preload("res://Data/Ships/Ship.tscn").instance()
    ship.setup(tilesetDatabase, Vector2(600, 600), -180)
    add_child(ship)
    return ship
