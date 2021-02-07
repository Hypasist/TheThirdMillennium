extends Node
var cons = preload("res://Data/Utils/Constants.gd")

# --- SETUP -------------------------------------------------------------------
var tilesetDatabase = null
func setup(_tilesetDatabase):
    tilesetDatabase = _tilesetDatabase

var assignedShip = null
var tilemapManager = null
var operationalTilemap = null
func assignShip(ship:Ship):
    assignedShip = ship
    tilemapManager = ship.getTilemapManager()
    operationalTilemap = tilemapManager.getOperationalTilemap()
    
# --- PROCESS -----------------------------------------------------------------
var currentTileRecord = null
var currentTilePosition = null
var currentTileTransformation = [0, 0, 0]
var currentBuildLegal = null

func custom_physics_process():
    if assignedShip == null:
        return
        
    var action = cons.BUILDER_NOTHING
    while !gatheredBuilderInputs.empty():
        match gatheredBuilderInputs.front():
            cons.BUILDER_ACCEPT:
                if(currentTileRecord):
                    action = cons.BUILDER_PLACE_TILE
            cons.BUILDER_CANCEL:
                if(currentTileRecord):
                    clear()
                else:
                    action = cons.BUILDER_REMOVE_TILE
            cons.BUILDER_ROTATE_LEFT:
                currentTileTransformation = transformationRotateLeft(currentTileTransformation)
            cons.BUILDER_ROTATE_RIGHT:
                currentTileTransformation = transformationRotateRight(currentTileTransformation)
            _:
                print(gatheredBuilderInputs.front(), " !"); breakpoint
        gatheredBuilderInputs.pop_front()
    if action == cons.BUILDER_NOTHING && currentTileRecord:
        action = cons.BUILDER_TRY_TILE


    match action:
        cons.BUILDER_PLACE_TILE:
            print("PLACE_TILE")
            var isLegal = tilemapManager.isLegalToBuild(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation)
            if isLegal:
                currentTileRecord["tileMap"].addElement(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation)
        cons.BUILDER_REMOVE_TILE:
            print("REMOVE_TILE")
            currentTileRecord["tileMap"].removeElement(currentTilePosition)
        cons.BUILDER_TRY_TILE:
            var isLegal = tilemapManager.isLegalToBuild(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation)
            currentBuildLegal = operationalTilemap.tryTile(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation, isLegal)

func clear():
    currentTileRecord = null
    operationalTilemap.clear()  

var gatheredBuilderInputs = []
func passBuilderInputs(input):
    gatheredBuilderInputs = input   


# --- SWITCH ------------------------------------------------------------------

# --_ UTILS -------------------------------------------------------------------
func transformationRotateLeft(current):
    if !current[0] && !current[1] && !current[2]: # 0
        return [1, 0, 1]
    elif  current[0] &&  current[1] && !current[2]: # 90
        return [0, 0, 0]
    elif !current[0] &&  current[1] &&  current[2]: # 180
        return [1, 1, 0]
    elif  current[0] && !current[1] &&  current[2]: # 270
        return [0, 1, 1]

func transformationRotateRight(current):
    if !current[0] && !current[1] && !current[2]: # 0
        return [1, 1, 0]
    elif  current[0] &&  current[1] && !current[2]: # 90
        return [0, 1, 1]
    elif !current[0] &&  current[1] &&  current[2]: # 180
        return [1, 0, 1]
    elif  current[0] && !current[1] &&  current[2]: # 270
        return [0, 0, 0]

func calculatePosition():
    var mousePosition = (operationalTilemap.get_global_mouse_position() - assignedShip.position).rotated(deg2rad(-assignedShip.rotation_degrees)) / tilemapManager.scale
    return operationalTilemap.world_to_map(mousePosition)

func calculateOffsettedPosition(tile, transformation):
    var tileSize = operationalTilemap.concludeTileSize(tile, transformation)
    var mousePosition = (operationalTilemap.get_global_mouse_position() - assignedShip.position).rotated(deg2rad(-assignedShip.rotation_degrees)) / tilemapManager.scale
    var mousePositionOffset = (Vector2(operationalTilemap.get_cell_size().x * tileSize.x, operationalTilemap.get_cell_size().y * tileSize.y) / 2 ) - \
                                        operationalTilemap.get_cell_size() / 2
    return operationalTilemap.world_to_map(mousePosition - mousePositionOffset)
       


# --- SIGNAL ------------------------------------------------------------------
func _on_CollectionPanel_newRecordSelected(record):
    currentTileRecord = record



# --- CONFIGURATION -----------------------------------------------------------

func loadConfiguration(configurationName):
    var configurationFileName = "res://ShipConfigs/" + configurationName + ".sc"
    var saveFile = File.new()
    if !saveFile.file_exists(configurationFileName):
        print("File not found! ", configurationFileName)
        breakpoint
        
    saveFile.open(configurationFileName, File.READ)
    var configuration = JSON.parse(saveFile.get_as_text()).result
    
    for key in configuration:
        if !tilesetDatabase.has(key):
            print("Unrecognized configuration tileID! ", key)
            breakpoint
            continue
        
        var record = tilesetDatabase[key]
        var coordsArray = configuration[key]
        for coords in coordsArray:
            match record["TileGroup"]:
                cons.FLOOR_GROUP:
                    $FloorTilemap.addElementCompound(record, Vector2(coords[0], coords[1]), coords[2])
                cons.WALL_GROUP:
                    $WallsTilemap.addElementCompound(record, Vector2(coords[0], coords[1]), coords[2])
                cons.PANEL_GROUP:
                    if key == "HertigDoublePilotPanel": print((Vector2(coords[0], coords[1])), " -- ", coords[2])
                    $InteractableTilemap.addElementCompound(record, Vector2(coords[0], coords[1]), coords[2])
                _:
                    print("Unrecognized TileGroup! ", record["TileGroup"])
                    breakpoint
                    continue
        
    for node in get_children():
        if node.is_in_group("saveable_tilemaps"):
            node.update_bitmask_region()
    saveFile.close()

