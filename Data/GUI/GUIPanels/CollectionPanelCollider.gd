extends Area2D


func doesCollisionShapeContain(point: Vector2):
    var shape = $CollisionPolygon2D.get_polygon()
    if(shape[5].x <= point.x && point.x <= shape[0].x):
        var localY = (shape[6].y - shape[5].y)/(shape[6].x - shape[5].x) * (point.x - shape[5].x) 
        if shape[5].y + localY <= point.y && point.y <= shape[4].y:
            return true
    if(shape[0].x <= point.x && point.x <= shape[1].x):
        var localY = (shape[1].y - shape[0].y)/(shape[1].x - shape[0].x) * (point.x - shape[0].x)
        if shape[0].y + localY <= point.y && point.y <= shape[4].y:
            return true
    if(shape[1].x <= point.x && point.x <= shape[2].x):
        if(shape[2].y <= point.y && point.y <= shape[3].y):
            return true
    return false


func setNewCollisionShape(parentSize:Vector2):
    var shape = $CollisionPolygon2D.get_polygon()
    shape[0] = Vector2(15, 45)
    shape[1] = Vector2(65, 0)
    shape[2] = Vector2(parentSize.x, 0)
    shape[3] = Vector2(parentSize.x, parentSize.y)
    shape[4] = Vector2(0, parentSize.y)
    shape[5] = Vector2(0, parentSize.y - 90)
    shape[6] = Vector2(15, parentSize.y - 105)
    $CollisionPolygon2D.set_polygon(shape)
