extends CustomCamera

var shipSpeed2cameraPosition = 0.017

func _ready():
    zoom = Vector2(0.3, 0.3)
    minZoom = Vector2(0.05, 0.05)
    maxZoom = Vector2(1.0, 1.0)
    zoomJump = Vector2(0.15, 0.15)

func custom_camera_process(delta):
    if (followedEntity):
        # Conclude zoom changes and start tween
        zoomSlide()
        
        # Calculate camera presumed position and rotation
        var targetRotation = followedEntity.currentShip.rotation_degrees
        var targetPosition = followedEntity.position.rotated(deg2rad(followedEntity.currentShip.rotation_degrees)) \
                             + followedEntity.currentShip.position
        
        # Apply corrections caused by entity's velocity
        targetPosition -= shipSpeed2cameraPosition * followedEntity.currentShip.kinematic.getVelocityRelative()
        
        # Peek feature
        var peek = (get_viewport().get_mouse_position() - halfScreenResolution)
        var peekRange = peek.length()
        if peekRange > maxPeekLength:
            peek *= maxPeekLength / peekRange
        if peekRange < minPeekLength:
            targetPosition += peek.rotated(deg2rad(rotation_degrees)) * zoom \
                              * sin((PI/2) * peekRange / minPeekLength)
        else:
            targetPosition += peek.rotated(deg2rad(rotation_degrees)) * zoom
            
        # Set final position and rotation
        rotation_degrees = targetRotation
        position = targetPosition

# TODO
# CORRECTION IS NOT VALID WHILE SPINNING
# MOZE KOREKCJA PREDYKTYWNA BAZUJACA NA POPRZEDNICH INPUTACH?
