extends CustomTileMap

export (Color, RGBA) var red
export (Color, RGBA) var green

var lastTileRecord = null
var lastTilePosition = null
var lastTileTransformation = null
var lastBuildLegal = false

func tryTile(tileRecord, tilePosition, tileTransformation, isBuildLegal):
    if lastTileRecord != tileRecord || lastTilePosition != tilePosition || lastTileTransformation != tileTransformation:
        if lastTileRecord: set_cellv(lastTilePosition, -1)
        lastTileRecord = tileRecord
        lastTilePosition = tilePosition
        lastTileTransformation = tileTransformation
        if isBuildLegal:
            material.set_shader_param('currentColour', green)
        else:
            material.set_shader_param('currentColour', red)
            
        set_cellv(tilePosition, lastTileRecord["tileId"], tileTransformation[1], tileTransformation[2], tileTransformation[0])
    
    return true
