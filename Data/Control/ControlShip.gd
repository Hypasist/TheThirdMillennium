extends playerControl

func gather_and_distribute_input():
    if controlledObject && gatherInput:
        var inputs = []
        
        if Input.is_action_pressed("ui_stop"):
            inputs.append(cons.SHIP_DAMP_MOVEMENT)
        if Input.is_action_pressed("ui_forward"):
            inputs.append(cons.SHIP_MOVE_FORWARD)
        if Input.is_action_pressed("ui_back"):
            inputs.append(cons.SHIP_MOVE_BACKWARD)
        if Input.is_action_pressed("ui_right"):
            inputs.append(cons.SHIP_MOVE_RIGHT)
        if Input.is_action_pressed("ui_left"):
            inputs.append(cons.SHIP_MOVE_LEFT)
        if Input.is_action_pressed("ui_turn_left"):
            inputs.append(cons.SHIP_ROTATE_LEFT)
        if Input.is_action_pressed("ui_turn_right"):
            inputs.append(cons.SHIP_ROTATE_RIGHT)
        if Input.is_action_just_pressed("ui_shoot"):
            inputs.append(cons.SHIP_SHOOT)
                
        controlledObject.passInputs(inputs)
