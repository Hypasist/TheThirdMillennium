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
    #showme()
    
func showme():
    print("Engine %4.2f %4.2f %4.2f %4.2f [%4.2f %4.2f]" % [maxPower, mass, thrustAngle, thrustApplication, massCenter[0], massCenter[1]])
    
