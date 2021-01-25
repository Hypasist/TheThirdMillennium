class_name CustomTileMap
extends TileMap
var cons = preload("res://Data/Utils/Constants.gd")
var ship = get_parent()

var assignedElements = []
var allowedTileGroups = []

func setup():
    for tileGroup in allowedTileGroups:
        var tileRecords = get_parent().getTileRecordsByGroup(tileGroup)
        for tileRecord in tileRecords:
            var elementsArray = get_used_cells_by_id(tileRecord["tileId"])
            for elementPosition in elementsArray:
                var elementTransformation = [is_cell_transposed(elementPosition.x, elementPosition.y), is_cell_x_flipped(elementPosition.x, elementPosition.y), is_cell_y_flipped(elementPosition.x, elementPosition.y)]
                assignedElements.append({"tilePosition": elementPosition, "tileRecord": tileRecord, "tileTransformation": elementTransformation})


func addElement(elementRecord, elementPosition, elementTransformation):
    assignedElements.append({"tilePosition": elementPosition, "tileRecord": elementRecord, "tileTransformation": elementTransformation})
    set_cellv(elementPosition, elementRecord["TileID"], elementTransformation[1], elementTransformation[2], elementTransformation[0])

func addElementCompound(elementRecord, elementPosition, elementTransformation):
    var transposed = 0
    var flipped_x = 0
    var flipped_y = 0
    
    if elementTransformation >= cons.TILE_TRANSFORM_FLIPPED_Y:
        elementTransformation -= cons.TILE_TRANSFORM_FLIPPED_Y
        flipped_y = 1
    if elementTransformation >= cons.TILE_TRANSFORM_FLIPPED_X:
        elementTransformation -= cons.TILE_TRANSFORM_FLIPPED_X
        flipped_x = 1
    if elementTransformation >= cons.TILE_TRANSFORM_TRANSPOSED:
        elementTransformation -= cons.TILE_TRANSFORM_TRANSPOSED
        transposed = 1
        
    assignedElements.append({"tilePosition": elementPosition, "tileRecord": elementRecord, "tileTransformation": elementTransformation})
    set_cellv(elementPosition, elementRecord["TileID"], flipped_x, flipped_y, transposed)


func doesIntersect(rect1:Rect2, rect2:Rect2):
    rect1.size -= Vector2(1,1)
    rect2.size -= Vector2(1,1)
    return rect1.intersects(rect2, true)

func doesEnclose(rect1:Rect2, rect2:Rect2):
    rect1.size -= Vector2(1,1)
    rect2.size -= Vector2(1,1)
    return rect1.encloses(rect2)

func doesContain(rect1:Rect2, tile:Vector2):
    if rect1.position.x <= tile.x && tile.x <= rect1.position.x + rect1.size.x && \
       rect1.position.y <= tile.y && tile.y <= rect1.position.y + rect1.size.y:
        return true
    else:
        return false

func concludeTileSize(tileRecord, tileTransformation):
    if tileTransformation[0]:
        return Vector2(tileRecord["TileSize"].y, tileRecord["TileSize"].x)
    else:
        return tileRecord["TileSize"]

func pinpointElement(elementPosition):
    var targetElement = Rect2(elementPosition, Vector2(1,1))
    for element in assignedElements:
        if doesIntersect(targetElement,  Rect2(element["tilePosition"], concludeTileSize(element["tileRecord"], element["tileTransformation"]))):
            return element
    return null

func removeElement(elementPosition):
    var element = pinpointElement(elementPosition)
    if element:
        print("Removing: ", elementPosition, " found in: ", element)
        set_cellv(element["tilePosition"], -1)
        assignedElements.erase(element)
    
    
func doesNotCover(elementRecord, elementPosition, elementTrasformation):
    var rect = Rect2(elementPosition, concludeTileSize(elementRecord, elementTrasformation))
    for element in assignedElements:
        if doesIntersect(rect, Rect2(element["tilePosition"], concludeTileSize(element["tileRecord"], element["tileTransformation"]))):
            return false
    return true
                
func doesCoverAtAll(elementRecord, elementPosition):
    pass
    
func doesCoverFully(elementRecord, elementPosition, elementTransformation):
    var elementTileSize = concludeTileSize(elementRecord, elementTransformation)
    for x in elementTileSize.x:
        for y in elementTileSize.y:
            var subtileCovered = false
            for element in assignedElements:
                if doesContain(Rect2(element["tilePosition"], concludeTileSize(element["tileRecord"], element["tileTransformation"])), Vector2(x,y)+elementPosition):
                    subtileCovered = true
                    break
            if !subtileCovered:
                return false
    return true

# TRANSFORM GETTERS
func getTileTransform(tile):
    return [is_cell_transposed(tile.x, tile.y), \
    is_cell_x_flipped(tile.x, tile.y), is_cell_y_flipped(tile.x, tile.y)]

func getTileTransformCompound(tile):
    var sum = 0
    if is_cell_transposed(tile.x, tile.y): sum += cons.TILE_TRANSFORM_TRANSPOSED
    if is_cell_x_flipped(tile.x, tile.y): sum += cons.TILE_TRANSFORM_FLIPPED_X
    if is_cell_y_flipped(tile.x, tile.y): sum += cons.TILE_TRANSFORM_FLIPPED_Y
    return sum
