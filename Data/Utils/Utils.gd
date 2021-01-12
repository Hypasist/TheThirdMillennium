class_name Utils

static func vectorDecomposition(vector: Vector2, angle: float):
    var vx = Vector2(vector.x, vector.y) * cos(angle)
    var vy = Vector2(vector.x, vector.y) * sin(angle)
    return  [vx.rotated(-angle), vy.rotated(PI/2 - angle)]

static func calcQuadraticEq(a, b, c):
    var d = b*b - 4*a*c
    if (d < 0):
        breakpoint
    d = sqrt(d)
    var x1 = (-b + d)/2/a
    var x2 = (-b - d)/2/a
    return [x1, x2]
    
static func sqrt2_keepSign(vector: Vector2):
    var ret = Vector2(0,0)
    ret.x = -sqrt(-vector.x) if (vector.x < 0) else sqrt(vector.x)
    ret.y = -sqrt(-vector.y) if (vector.y < 0) else sqrt(vector.y)
    return ret

static func sqrt_keepSign(value: float):
    return -sqrt(-value) if (value < 0) else sqrt(value)
    
static func clamp2(V: Vector2, minV: Vector2, maxV: Vector2):
    V.x = clamp(V.x, minV.x, maxV.x)
    V.y = clamp(V.y, minV.y, maxV.y)
    return V
    
static func reparent(child: Node, new_parent: Node):
    var old_parent = child.get_parent()
    old_parent.remove_child(child)
    new_parent.add_child(child)
