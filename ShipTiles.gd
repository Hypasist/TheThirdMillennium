tool
extends Node2D
var cons = preload("res://Data/Utils/Constants.gd")
onready var ship = get_parent()

# --- SETUP -------------------------------------------------------------------
var tilesetDatabase = null
func setup(_tilesetDatabase:Dictionary):
    tilesetDatabase = _tilesetDatabase
    var containerTilemaps = [$FloorTilemap, $WallsTilemap, $InteractableTilemap]
    for tileMap in containerTilemaps:
        tileMap.setup() 
        
        
        
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


    
func isLegalToBuild(tileRecord, tilePosition, tileTransformation):
    return $FloorTilemap.doesCoverFully(tileRecord, tilePosition, tileTransformation) && \
    $WallsTilemap.doesNotCover(tileRecord, tilePosition, tileTransformation) && \
    $InteractableTilemap.doesNotCover(tileRecord, tilePosition, tileTransformation)
           

    
func getOperationalTilemap():
    return $OperationalTilemap
