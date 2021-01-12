extends CustomCamera

func _ready():
    zoom = Vector2(4.0, 4.0)
    minZoom = Vector2(0.5, 0.5)
    maxZoom = Vector2(8.0, 8.0)
    zoomJump = Vector2(0.5, 0.5)
    

func custom_camera_process(delta):
    if (followedEntity):
        # Conclude zoom changes and start tween
        zoomSlide()
        
        # Calculate camera presumed position
        var targetPosition = followedEntity.position
        
        # Peek feature
        var peek = (get_viewport().get_mouse_position() - halfScreenResolution)
        var peekRange = peek.length()
        
        if peekRange > maxPeekLength:
            peek *= maxPeekLength / peekRange # Hold at maxRange
            
        if peekRange < minPeekLength:
            targetPosition += peek * zoom * sin((PI/2) * peekRange / minPeekLength)
        else:
            targetPosition += peek * zoom
            
        # Set final position
        position = targetPosition 
