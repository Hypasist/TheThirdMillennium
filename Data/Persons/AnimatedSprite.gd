extends AnimatedSprite


func _ready():
    pass


func animate(velocityAbsolute):
    if(velocityAbsolute):
        set_animation("walk")
    else:
        set_animation("stand")
