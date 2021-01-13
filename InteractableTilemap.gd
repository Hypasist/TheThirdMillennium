extends CustomTileMap

var knownPanelTypes = [[2, preload("res://Data/ShipInteractables/WeaponPanel.tscn")], \
                       [3, preload("res://Data/ShipInteractables/PilotPanel.tscn")]]

                
func getTileTransform(tile):
    return [is_cell_transposed(tile.x, tile.y), \
    is_cell_x_flipped(tile.x, tile.y), is_cell_y_flipped(tile.x, tile.y)]

func _ready():
    allowedTileTypes = [cons.PANEL_TYPE]
    
    for panelType in knownPanelTypes:
        var panelTiles = get_used_cells_by_id(panelType[0])
        for tile in panelTiles:
            var panelInstance = panelType[1].instance()
            panelInstance.setup(getTileTransform(tile), cell_size, tile)
            panelInstance.position = map_to_world(tile)
            add_child(panelInstance)
            
            # Connecting + error handling
            var error = panelInstance.connect("body_entered", self, "onPlayerEnter", [panelInstance])
            if error: print("body_enter ", panelInstance.name, " : ", error)
            error = panelInstance.connect("body_exited", self, "onPlayerExit", [panelInstance])
            if error: print("body_exit ", panelInstance.name, " : ", error)

#var w2m = world_to_map(weaponPanel[0])
#var cc = get_cell_autotile_coord(used_panels[0][0], used_panels[0][1])

func onPlayerEnter(body, panelInstance):
    body.addAvailableInteractable(panelInstance)

func onPlayerExit(body, panelInstance):
    body.removeAvailableInteractable(panelInstance)

