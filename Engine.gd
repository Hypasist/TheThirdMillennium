extends AnimatedSprite
class_name EngineType

var minPower = 0 # kN
var maxPower = 0 # kN
var mass = 0 # T; mass of engine
var thrustAngle = 0 # rad; PI/2 to the left; -PI/2 to the right; 0 to the center
var thrustApplication = 0 # [0 - 100]; 0 linear; 100 rotational
var massCenter = 0 #

func _init(maxP, m, tAngle, tApplication, mCenter):
    maxPower = maxP
    mass = m
    thrustAngle = tAngle
    thrustApplication = tApplication
    massCenter = mCenter

# -------- animation
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
        position = Vector2(pos, -135)
        scale = Vector2(0.4, sca)
        show()

#engines.append(["ui_forward", EngineType.new(15200, 400, 0, 0, [-100, -100])]) # back left
#engines.append(["ui_forward", EngineType.new(15200, 400, 0, 0, [-100, 100])]) # back right
#engines.append(["ui_right", EngineType.new(4800, 400, 0, 0, [0, -50])]) # middle left
#engines.append(["ui_left", EngineType.new(4800, 400, 0, 0, [0, 50])]) # middle right
#engines.append(["ui_turn_right", EngineType.new(4800, 400, 0, 0, [100, -150])]) # front left
#engines.append(["ui_back", EngineType.new(4800, 400, 0, 0, [100, 0])]) # front center
#engines.append(["ui_turn_left", EngineType.new(4800, 400, 0, 0, [100, 150])]) # front right
    
