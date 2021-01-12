extends Ship

func _ready():
    position = Vector2(600, 600)
    rotation_degrees = -180
    kinematic.setPositionAll(position, rotation_degrees)

    
func custom_physics_process(delta):
    .custom_physics_process(delta)
    #$Hull.animate_ship(Vector3(100 * currVelocity_relative.x/maxVelocity.x, 100 * currVelocity_relative.y/maxVelocity.y, 100 * currVelocity_relative.z/maxVelocity.z))
    
    
func getShipInfo():
    var velRel = kinematic.getVelocityAbsolute()
    var velRot = kinematic.getVelocityRotational()
    var momRel = kinematic.getMomentumAbsolute()
    var momRot = kinematic.getMomentumRotational()
    return "Pos: x:%4.2f  y:%4.2f  a:%4.2f\nVel: x:%4.2f  y:%4.2f  a:%4.2f\nMom: x:%4.2f  y:%4.2f  a:%4.2f\n" \
    % [position.x, position.y, rotation_degrees, velRel.x, velRel.y, velRot, momRel.x, momRel.y, momRot]
    
