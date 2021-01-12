extends AnimatedSprite

var min_pos_x = -245
var max_pos_x = -385
var min_sca_x = 0.1
var max_sca_x = 0.9

func _ready():
    set_power(0)

func set_power(power):
    var multiplier = clamp(power / 10, 0, 10)
    var pos =  min_pos_x + ((max_pos_x - min_pos_x) / 10 ) * multiplier
    var sca =  min_sca_x + ((max_sca_x - min_sca_x) / 10 ) * multiplier
    
    if(power == 0):
        hide()
    else:
        position = Vector2(pos, 135)
        scale = Vector2(0.4, sca)
        show()
