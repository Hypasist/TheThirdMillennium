tool
extends Node2D
var cons = preload("res://Data/Utils/Constants.gd")
onready var ship = get_parent()

onready var operationalTilemaps = $OperationalTilemap

var tilesetDatabase = null

func getTileRecordByID(tileID):
    for key in tilesetDatabase.keys():
        var tileRecord = tilesetDatabase[key]
        if tileRecord["TileID"] == tileID:
            return tileRecord

func getTileRecordsByGroup(tileGroup):
    if tileGroup == cons.ANY_GROUP:
        return tilesetDatabase

    var recordArray = []
    for tileRecord in tilesetDatabase:
        if tileGroup == cons.NON_FLOOR_GROUP && tileRecord["tileGroup"] != cons.FLOOR_GROUP:
            recordArray.append(tileRecord)
        if tileGroup == tileRecord["tileGroup"]:
            recordArray.append(tileRecord)
    return recordArray

func startBuilder():
    builderMode = true
    operationalTilemaps.show()

func stopBuilder():
    builderMode = false
    operationalTilemaps.hide()

func setTilemapFocused(value:bool):
    tilemapFocused = value

func isActive():
    return builderMode && tilemapFocused

    
func isLegalToBuild(tileRecord, tilePosition, tileTransformation):
    return $FloorTilemap.doesCoverFully(tileRecord, tilePosition, tileTransformation) && \
    $WallsTilemap.doesNotCover(tileRecord, tilePosition, tileTransformation) && \
    $InteractableTilemap.doesNotCover(tileRecord, tilePosition, tileTransformation)
           

func transformationRotateLeft():
    if !currentTileTransformation[0] && !currentTileTransformation[1] && !currentTileTransformation[2]: # 0
        currentTileTransformation = [1, 0, 1]
    elif  currentTileTransformation[0] &&  currentTileTransformation[1] && !currentTileTransformation[2]: # 90
        currentTileTransformation = [0, 0, 0]
    elif !currentTileTransformation[0] &&  currentTileTransformation[1] &&  currentTileTransformation[2]: # 180
        currentTileTransformation = [1, 1, 0]
    elif  currentTileTransformation[0] && !currentTileTransformation[1] &&  currentTileTransformation[2]: # 270
        currentTileTransformation = [0, 1, 1]

func transformationRotateRight():
    if !currentTileTransformation[0] && !currentTileTransformation[1] && !currentTileTransformation[2]: # 0
        currentTileTransformation = [1, 1, 0]
    elif  currentTileTransformation[0] &&  currentTileTransformation[1] && !currentTileTransformation[2]: # 90
        currentTileTransformation = [0, 1, 1]
    elif !currentTileTransformation[0] &&  currentTileTransformation[1] &&  currentTileTransformation[2]: # 180
        currentTileTransformation = [1, 0, 1]
    elif  currentTileTransformation[0] && !currentTileTransformation[1] &&  currentTileTransformation[2]: # 270
        currentTileTransformation = [0, 0, 0]

func setup(_tilesetDatabase:Dictionary):
    tilesetDatabase = _tilesetDatabase

    var containerTilemaps = [$FloorTilemap, $WallsTilemap, $InteractableTilemap]
    for tileMap in containerTilemaps:
        tileMap.setup() 
        
#    var shipSize = Rect2(0, 0, 0, 0)
#    var recordArray = getTileRecordsByGroup(cons.ANY_GROUP)
#    for tileRecord in recordArray:
#        shipSize = shipSize.merge(tileRecord["tileMap"].get_used_rect())
    

var builderMode = true
var tilemapFocused = false

var lastTileId = null
var lastTilePosition = null
var lastTileTransformation = null
var buildLegal = false

var currentTileID = cons.INVALID_TILE_ID
var currentTileRecord = null
var currentTileTransformation = [0, 0, 0]

var gatheredBuilderInputs = []
enum {PLACE_TILE, REMOVE_TILE, TRY_TILE}

func custom_physics_process():
    if isActive():
        var action = TRY_TILE
        while !gatheredBuilderInputs.empty():
            match gatheredBuilderInputs.front():
                cons.BUILDER_ACCEPT:
                    action = PLACE_TILE
                cons.BUILDER_CANCEL:
                    action = REMOVE_TILE
                cons.BUILDER_ROTATE_LEFT:
                    transformationRotateLeft()
                cons.BUILDER_ROTATE_RIGHT:
                    transformationRotateRight()
                _:
                    print(gatheredBuilderInputs.front(), " !"); breakpoint
            gatheredBuilderInputs.pop_front()


        # Calculate camera presumed position and rotation
        currentTileRecord = getTileRecordByID(currentTileID)
        if (currentTileRecord):
            var tileSize = operationalTilemaps.concludeTileSize(currentTileRecord, currentTileTransformation)
            var mousePosition = (get_global_mouse_position() - ship.position).rotated(deg2rad(-ship.rotation_degrees)) / scale
            var mousePositionOffset = (Vector2(operationalTilemaps.get_cell_size().x * tileSize.x, operationalTilemaps.get_cell_size().y * tileSize.y) / 2 ) - \
                                                operationalTilemaps.get_cell_size() / 2
            var currentTilePosition = operationalTilemaps.world_to_map(mousePosition)
            var currentTilePositionOffsetted = operationalTilemaps.world_to_map(mousePosition - mousePositionOffset)
            
            match action:
                PLACE_TILE:
                    print("PLACE_TILE")
                    if isLegalToBuild(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation):
                        currentTileRecord["tileMap"].addElement(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation)
                REMOVE_TILE:
                    print("REMOVE_TILE")
                    currentTileRecord["tileMap"].removeElement(currentTilePosition)
                TRY_TILE:
                    buildLegal = operationalTilemaps.tryTile(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation, isLegalToBuild(currentTileRecord, currentTilePositionOffsetted, currentTileTransformation))
            return
    # else
    operationalTilemaps.clear()
    lastTileId = null
    lastTilePosition = null
    lastTileTransformation = null
        

func saveConfiguration(configurationName):
    var configurationFileName = "res://ShipConfigs/" + configurationName + ".sc"
    var saveFile = File.new()
    saveFile.open(configurationFileName, File.WRITE)
    
    var consideredTilemaps = []
    var configuration = {}
    for node in get_children():
        if node.is_in_group("saveable_tilemaps"):
            consideredTilemaps.append(node)
    
    for key in tilesetDatabase:
        var id = tilesetDatabase[key]["TileID"]
        var coordsArray = []
        for tilemap in consideredTilemaps:
            var tmpCoordsArray = tilemap.get_used_cells_by_id(id)
            for coords in tmpCoordsArray:
                if key == "HertigDoublePilotPanel": print(coords, " -- ", tilemap.getTileTransformCompound(coords))
                coordsArray.append([coords.x, coords.y, tilemap.getTileTransformCompound(coords)])
        configuration[key] = coordsArray
        
    saveFile.store_line(to_json(configuration))
    saveFile.close()


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
