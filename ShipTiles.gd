tool
extends Sprite
var cons = preload("res://Data/Utils/Constants.gd")
onready var ship = get_parent()

# --- TOOL SCRIPTS ------------------------------------------------------------
export var tilemapsScale = 0.6 setget setTilemapsScale
func setTilemapsScale(scale):
    tilemapsScale = scale
    for node in get_children():
        node.set_scale(Vector2(scale, scale))

# --- SETUP -------------------------------------------------------------------
var tilesetDatabase = null
func setup(_tilesetDatabase:Dictionary):
    tilesetDatabase = _tilesetDatabase
    var containerTilemaps = [$FloorTilemap, $WallsTilemap, $InteractableTilemap]
    for tileMap in containerTilemaps:
        tileMap.setup(tilesetDatabase) 
        
        
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
           
func build(tileRecord, tilePosition, tileTransformation):
    match tileRecord["TileGroup"]:
        cons.PANEL_GROUP:
            $InteractableTilemap.addElement(tileRecord, tilePosition, tileTransformation)
        cons.WALL_GROUP:
            $WallsTilemap.addElement(tileRecord, tilePosition, tileTransformation)
        cons.FLOOR_GROUP:
            $FloorTilemap.addElement(tileRecord, tilePosition, tileTransformation)
        _:
            print("Unrecognized TileGroup! ", tileRecord["TileGroup"])
            breakpoint                    
  

func getOperationalTilemap():
    return $OperationalTilemap

func setNewModel(shipRecord):
    var image = Image.new()
    var err = image.load(shipRecord["ShipGraphic"])
    if err != OK:
        print("Couldn't load the texture! ", shipRecord["ShipGraphic"])
        breakpoint
    var texture = ImageTexture.new()
    texture.create_from_image(image, 0)
    set_texture(texture)

func showInterior():
    for node in get_children():
        node.show()
    get_material().set_shader_param("greyout", true)
    
func hideInterior():
    for node in get_children():
        node.hide()
    get_material().set_shader_param("greyout", false)
