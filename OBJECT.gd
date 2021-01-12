extends Entity

var KinematicType = preload("res://Kinematic.gd")

var kinematic = null

func _init():
    kinematic = KinematicType.new(10.0, 150.0, Vector2(0, 0), 1.0)
    
func _ready():
    rotation_degrees = 90
    kinematic.setPositionAll(position, rotation_degrees)
    
    kinematic.setMomentumRelative(Vector2(0, 0))
    kinematic.setMomentumRotational(0)
    
    $ping.position = kinematic.massCenter
    $ping.rotation_degrees = kinematic.angle
    
func custom_physics_process(delta):
    var objectMovement = kinematic.processMovement(delta)
    rotation_degrees = objectMovement[1]
    var collision = move_and_collide(objectMovement[0], true, true, false )
#    if collision:
#        breakpoint
#    position.x = tmp[0]
#    position.y = tmp[1]
#    rotation_degrees = tmp[2]
