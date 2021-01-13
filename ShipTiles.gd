extends Node2D
var cons = preload("res://Data/Utils/Constants.gd")
onready var ship = get_parent()

onready var operationalTilemaps = $OperationalTilemap
onready var containerTilemaps = [$FloorTilemap, $WallsTilemap, $InteractableTilemap]
onready var tileBase = [\
  { "tileName": cons.WALL,          "tileType": cons.WALL_TYPE,     "tileId": 0,        "tileSize": Vector2(1,1),       "tileMap": $WallsTilemap,           "tileNode": null}, \
  { "tileName": cons.FLOOR,         "tileType": cons.FLOOR_TYPE,    "tileId": 4,        "tileSize": Vector2(1,1),       "tileMap": $FloorTilemap,           "tileNode": null}, \
  { "tileName": cons.WEAPON_PANEL,  "tileType": cons.PANEL_TYPE,    "tileId": 8,        "tileSize": Vector2(2,2),       "tileMap": $InteractableTilemap,    "tileNode": preload("res://Data/ShipInteractables/WeaponPanel.tscn")}, \
  { "tileName": cons.PILOT_PANEL,   "tileType": cons.PANEL_TYPE,    "tileId": 7,        "tileSize": Vector2(2,4),       "tileMap": $InteractableTilemap,    "tileNode": preload("res://Data/ShipInteractables/PilotPanel.tscn")}, \
]

func getTileRecordByName(tileName):
    for tileRecord in tileBase:
        if tileRecord["tileName"] == tileName:
            return tileRecord

func getTileRecordsByType(tileType):
    if tileType == cons.ANY_TYPE:
        return tileBase

    var recordArray = []
    for tileRecord in tileBase:
        if tileType == cons.NON_FLOOR_TYPE && tileRecord["tileType"] != cons.FLOOR_TYPE:
            recordArray.append(tileRecord)
        if tileType == tileRecord["tileType"]:
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

func _ready():
    for tileMap in containerTilemaps:
        tileMap.setup() 

    var shipSize = Rect2(0, 0, 0, 0)
    var recordArray = getTileRecordsByType(cons.ANY_TYPE)
    for tileRecord in recordArray:
        shipSize = shipSize.merge(tileRecord["tileMap"].get_used_rect())
    

export (Color, RGBA) var red
export (Color, RGBA) var green
var builderMode = true
var tilemapFocused = false

var lastTileId = null
var lastTilePosition = null
var lastTileTransformation = null
var tileColor = green
var buildLegal = false

var currentTileName = cons.PILOT_PANEL
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
        currentTileRecord = getTileRecordByName(currentTileName)
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
    else:
        operationalTilemaps.clear()
        lastTileId = null
        lastTilePosition = null
        lastTileTransformation = null
