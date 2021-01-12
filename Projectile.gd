class_name Projectile
extends Entity

var KinematicType = preload("res://Kinematic.gd")
var kinematic = null
var lifeTimer:Timer = null

func setup(pos:Vector2, rot:float, speed:Vector2, lifetime:float):
    position = pos
    rotation_degrees = rot
    kinematic = KinematicType.new(1, 1, Vector2(0, 0), 0.85)
    kinematic.setPositionAll(position, rotation_degrees)
    kinematic.setVelocityAbsolute(speed)
    lifeTimer = Timer.new()
    add_child(lifeTimer)
    lifeTimer.set_wait_time(lifetime)
    var error = lifeTimer.connect("timeout", self, "_on_lifetime_timeout")
    if error:
        print(error, "!")
        breakpoint
    
func _ready():
    lifeTimer.start()
    
func custom_physics_process(delta):
    var objectMovement = kinematic.processMovement(delta)
    rotation_degrees = objectMovement[1]
    var collision = move_and_collide(objectMovement[0], true, true, false)

func _on_lifetime_timeout():
    queue_free()
