extends CustomCamera

const offsetSpeed = 10
var builderOffset = Vector2(0,0)

func _ready():
    zoom = Vector2(0.7, 0.7)
    minZoom = Vector2(0.3, 0.3)
    maxZoom = Vector2(0.8, 0.8)
    zoomJump = Vector2(0.1, 0.1)

func custom_camera_process(delta):
    if (followedEntity):
        # Conclude zoom changes and start tween
        zoomSlide()
        
        # Set final position and rotation
        rotation_degrees = followedEntity.rotation_degrees
        position = followedEntity.position + builderOffset.rotated(deg2rad(rotation_degrees))


# TO DO -- dodaj wartosci krancowe, zeby nie wyjezdzac poza margines blueprinta
func slideCamera(offsetVelocityNormalized:Vector2):
    builderOffset += offsetVelocityNormalized * offsetSpeed
