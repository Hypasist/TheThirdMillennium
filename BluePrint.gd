tool
extends Sprite

func calculate_aspect_ratio():
    material.set_shader_param("aspect_ratio", scale.y / scale.x)

func _ready():
    var windowSize = OS.get_window_size()
    var tileSize = Vector2(64,64)
    var imageSize = texture.get_size()
    var tilesInImage = Vector2(4,4)
    var count = Vector2(windowSize/imageSize)
    material.set_shader_param("tiled_factor", count)
    
    var scale = Vector2(tileSize*tilesInImage*count/imageSize)
    #print(scale)
    set_scale(scale)
    material.set_shader_param("aspect_ratio", scale.y / scale.x)
