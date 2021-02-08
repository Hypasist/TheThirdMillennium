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
                    currentTileRecord = null
                    emit_signal("clearRecordSelected")
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
            var currentTilePositionOffsetted = calculateOffsettedPosition(currentTileRecord, currentTileTransformation)
            var isLegal = tilemapManager.isLegalToBuild(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation)
            
            tilemapManager.build(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation)
                
            if isLegal:
                tilemapManager.build(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation)
                currentTileRecord["tileMap"].addElement(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation)
        cons.BUILDER_REMOVE_TILE:
            print("REMOVE_TILE")
            var currentTilePosition = calculatePosition()
            currentTileRecord["tileMap"].removeElement(currentTilePosition)
        cons.BUILDER_TRY_TILE:
            var currentTilePositionOffsetted = calculateOffsettedPosition(currentTileRecord, currentTileTransformation)
            var isLegal = tilemapManager.isLegalToBuild(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation)
            currentBuildLegal = operationalTilemap.tryTile(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation, isLegal)

func clear():
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

func calculateOffsettedPosition(record, transformation):
    var tileSize = operationalTilemap.concludeTileSize(record, transformation)
    var mousePosition = (operationalTilemap.get_global_mouse_position() - assignedShip.position).rotated(deg2rad(-assignedShip.rotation_degrees)) / tilemapManager.scale
    var mousePositionOffset = (Vector2(operationalTilemap.get_cell_size().x * tileSize.x, operationalTilemap.get_cell_size().y * tileSize.y) / 2 ) - \
                                        operationalTilemap.get_cell_size() / 2
    return operationalTilemap.world_to_map(mousePosition - mousePositionOffset)
       
func decompoundTransformation(current):
    var flipped_x = 0
    var flipped_y = 0
    var transposed = 0
    
    if current >= cons.TILE_TRANSFORM_TRANSPOSED:
        current -= cons.TILE_TRANSFORM_TRANSPOSED
        transposed = 1
    if current >= cons.TILE_TRANSFORM_FLIPPED_Y:
        current -= cons.TILE_TRANSFORM_FLIPPED_Y
        flipped_y = 1
    if current >= cons.TILE_TRANSFORM_FLIPPED_X:
        current -= cons.TILE_TRANSFORM_FLIPPED_X
        flipped_x = 1
    return [flipped_x, flipped_y, transposed]

func compoundTransformation(current):
    var sum = 0
    if current[0]: sum += cons.TILE_TRANSFORM_FLIPPED_X
    if current[1]: sum += cons.TILE_TRANSFORM_FLIPPED_Y
    if current[2]: sum += cons.TILE_TRANSFORM_TRANSPOSED
    return sum


# --- SIGNAL ------------------------------------------------------------------
signal clearRecordSelected

func _on_CollectionPanel_newRecordSelected(record):
    currentTileRecord = record


# --- CONFIGURATION -----------------------------------------------------------
func _on_ConfigurationPanel_configurationSave(configurationName, shipName):
    var configurationFileName = "res://ShipConfigs/" + configurationName + ".sc"
    var saveFile = File.new()
    saveFile.open(configurationFileName, File.WRITE_READ)
    
    var save = {"shipName": shipName}
    var configuration = {}
    for key in tilesetDatabase:
        var record = tilesetDatabase[key]
        var cells  = []
        for node in tilemapManager.get_children():
            if node.is_in_group("saveable_tilemaps"):
                var tmpCells = node.get_used_cells_by_id(record["TileID"])
                for tmpCell in tmpCells:
                    cells.append([tmpCell[0], tmpCell[1], compoundTransformation(node.getTileTransform(tmpCell))])
                    
        configuration[key] = cells
    save["shipConfiguration"] = configuration
    saveFile.store_string(to_json(save))
    saveFile.close()


func _on_ConfigurationPanel_configurationLoad(configurationName):
    var configurationFileName = "res://ShipConfigs/" + configurationName + ".sc"
    var saveFile = File.new()
    if !saveFile.file_exists(configurationFileName):
        print("File not found! ", configurationFileName)
        breakpoint
        
    saveFile.open(configurationFileName, File.READ)
    var result = JSON.parse(saveFile.get_as_text()).result
    var shipName = result["shipName"]
    var configuration = result["shipConfiguration"]
    
    for key in configuration:
        if !tilesetDatabase.has(key):
            print("Unrecognized configuration tileID! ", key)
            breakpoint
            continue
        
        var record = tilesetDatabase[key]
        var coordsArray = configuration[key]
        for coords in coordsArray:
            tilemapManager.build(record, Vector2(coords[0], coords[1]), decompoundTransformation(coords[2]))

        
    for node in tilemapManager.get_children():
        if node.is_in_group("saveable_tilemaps"):
            node.update_bitmask_region()
    saveFile.close()
