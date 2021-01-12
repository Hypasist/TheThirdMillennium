extends playerControl

func gather_and_distribute_input():
    if controlledObject && gatherInput:
        var inputs = []
        
        if Input.is_action_pressed("ui_forward"):
            inputs.append(cons.PLAYER_MOVE_FORWARD)
        if Input.is_action_pressed("ui_back"):
            inputs.append(cons.PLAYER_MOVE_BACKWARD)
        if Input.is_action_pressed("ui_right"):
            inputs.append(cons.PLAYER_MOVE_RIGHT)
        if Input.is_action_pressed("ui_left"):
            inputs.append(cons.PLAYER_MOVE_LEFT)
        if Input.is_action_just_pressed("ui_use_object"):
            inputs.append(cons.PLAYER_USE)
        
        controlledObject.passInputs(inputs)
