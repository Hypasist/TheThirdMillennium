extends CustomTileMap
#
#var knownPanelTypes = [[2, preload("res://ShipInteractables/WeaponPanel.tscn")], \
#                       [3, preload("res://ShipInteractables/PilotPanel.tscn")]]
                    

func _ready():
    allowedTileTypes = [cons.WALL_TYPE]
