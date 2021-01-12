extends KinematicBody2D

var KinematicType = preload("res://Kinematic.gd")
var utils = preload("res://Utils.gd")
var kinematic = null
var debug = null

func _init():    
    kinematic = KinematicType.new(20, 1, Vector2(0, 0), 0.85)
    
func _ready():
    #rotation_degrees = -30
    kinematic.setPositionAll(position.x, position.y, rotation_degrees)
    kinematic.setMomentumRelative(Vector2(20, 0))
    
    debug = get_parent().get_node("debugLines")
    $ping.position = kinematic.massCenter
    $ping.rotation_degrees = kinematic.angle

func _process(delta):
    var positionDeltaObject = kinematic.processMovement(delta)
    rotation_degrees = positionDeltaObject[1]
    var collision = move_and_collide(positionDeltaObject[0], true, true, false )
    
    if(collision != null):
        var velocityVectorObject = kinematic.getVelocityAbsoluteLinear()
        var collisionAngleObject = velocityVectorObject.angle() - collision.normal.angle()
        var decomposedVectorsObject = utils.vectorDecomposition(velocityVectorObject, collisionAngleObject)
        
        var collider = collision.collider
        var velocityVectorCollider = collider.kinematic.getVelocityAbsoluteLinear()
        var collisionAngleCollider = velocityVectorCollider.angle() - collision.normal.angle()
        var decomposedVectorsCollider = utils.vectorDecomposition(velocityVectorCollider, collisionAngleCollider)
        
#        debug.addLines(collision.position, velocityVectorObject, Color.red, 3.0, false)
#        debug.addLines(collision.position, decomposedVectorsObject[0], Color.red, 1.0, false)
#        debug.addLines(collision.position, decomposedVectorsObject[1], Color.blue, 1.0, false)
#        debug.addLines(collision.position, velocityVectorCollider, Color.green, 3.0, false)
#        debug.addLines(collision.position, decomposedVectorsCollider[0], Color.green, 1.0, false)
#        debug.addLines(collision.position, decomposedVectorsCollider[1], Color.yellow, 1.0, false)
        
        #y
        var v1 = decomposedVectorsObject[0]
        var m1 = kinematic.mass
        var v2 = decomposedVectorsCollider[0]
        var m2 = collider.kinematic.mass
        var n = kinematic.restitution * collider.kinematic.restitution
        #n = 1
        
        var y1 = (m1*v1 + m2*v2 + m2*n*(v2-v1))/(m1+m2)
        var y2 = (m1*v1 + m2*v2 + m1*n*(v1-v2))/(m1+m2)
        
        var c1 = y1 - decomposedVectorsObject[0]
        var c2 = y2 - decomposedVectorsCollider[0]
        debug.addLines(collision.position, c1, Color.blueviolet, 1.0, false)
        debug.addLines(collision.position, c2, Color.orange, 1.0, false)

        var fForce = c1.length()/delta; ## !!!!!
        
        v1 = decomposedVectorsObject[1]
        v2 = decomposedVectorsCollider[1]
        var T = kinematic.smoothness * collider.kinematic.smoothness
        
        var x1 = (m1*v1 + m2*v2 + m2*T*(v2-v1))/(m1+m2)
        var x2 = (m1*v1 + m2*v2 + m1*T*(v1-v2))/(m1+m2)
        
        c1 = x1 - decomposedVectorsObject[1]
        c2 = x2 - decomposedVectorsCollider[1]
        debug.addLines(collision.position, c1, Color.blue, 1.0, false)
        debug.addLines(collision.position, c2, Color.yellow, 1.0, false)
        #x
        var t1 = x1 + y1
        var t2 = x2 + y2
        
        kinematic.setMomentumAbsolute(Vector2(t1.x*m1, t1.y*m1))
        collider.kinematic.setMomentumAbsolute(Vector2(t2.x*m2, t2.y*m2))
                
        #kinematic.collisionInelastic(collision)
        #kinematic.collideWithObject(collision)
#        self.queue_free()

    
