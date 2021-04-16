extends playerControl

func gather_and_distribute_input():
    if controlledObject && gatherInput:
        var inputs = []
        var scrollValue = Vector2(0, 0)
        
        if Input.is_action_pressed("ui_forward"): # cons.BUILDER_UP
            scrollValue.y -= 1
        if Input.is_action_pressed("ui_back"): # cons.BUILDER_DOWN
            scrollValue.y += 1
        if Input.is_action_pressed("ui_right"): # cons.BUILDER_RIGHT
            scrollValue.x += 1
        if Input.is_action_pressed("ui_left"): # cons.BUILDER_LEFT
            scrollValue.x -= 1
            
        if Input.is_action_just_pressed("ui_turn_left"):
            inputs.append(cons.BUILDER_ROTATE_LEFT)
        if Input.is_action_just_pressed("ui_turn_right"):
            inputs.append(cons.BUILDER_ROTATE_RIGHT)
        if Input.is_action_pressed("ui_confirm"):
            inputs.append(cons.BUILDER_ACCEPT)
        if Input.is_action_just_pressed("ui_abort"):
            inputs.append(cons.BUILDER_CANCEL)
        if Input.is_action_just_pressed("ui_cancel"):
            get_tree().quit()
            
        controlledObject.passBuilderInputs(inputs)
        assignedCamera.slideCamera(scrollValue.normalized())
    
