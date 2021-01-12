class_name KinematicType
var utils = preload("res://Data/Utils/Utils.gd")
var solver = preload("res://Data/Utils/Solver.gd")

# fundamental data
var mass = 0.0 # T
var inertia = 0.0
var massCenter = Vector2(0.0, 0.0)
var restitution = 1.0    # how much energy is preserved during collision
                         # 1 - full bounce; 0 - total merge
var smoothness = 0.25    # how much force is preserved during friction process
                         # 1 - no friction; 0 - total merge

# dynamic data

var powerRotational = 0.0
var momentumRotational = 0.0
var velocityRotational = 0.0
var angle = 0.0

var momentumAbsolute = Vector2(0.0, 0.0)
var velocityAbsolute = Vector2(0.0, 0.0)

var powerRelative = Vector2(0.0, 0.0)
var momentumRelative = Vector2(0.0, 0.0)
var velocityRelative = Vector2(0.0, 0.0)

var position = Vector2(0.0, 0.0)

# auxilary data
var brakeAccelerationMultiplier = 0.5

func rel2abs(vector):
    return vector.rotated(angle)

func abs2rel(vector):
    return vector.rotated(-angle)

func _ready():
    pass

func _init(m:float, I:float, mC:Vector2, rC:float):
    if (m != null):
        mass = m
    if (I != null):
        inertia = I
    if (mC != null):
        massCenter = mC
    if (rC != null):
        restitution = rC
    showme()

func showme():
    print("Kinematic: %4.2f %4.2f %4.2f %4.2f" % [mass, inertia, massCenter.x, massCenter.y])

## PARAMETERS

#func setMassMassCenter(m, mC):
#    if (m != null):
#        mass = m
#    if (mC != null):
#        massCenter = mC

func addMass(m:float, mC:Vector2):
    if (m != null):
        if (mC != null):
            massCenter = (m*mC + mass*massCenter) / (m + mass)
            mass += m
        else:
            mass += m
    else: #if no mass is given, reset parameters
        mass = null
        massCenter = null

#func getMass():
#    return mass

func getMassCenter():
    return massCenter


## POSITION & ANGLE


func setPositionAll(p:Vector2, f:float):
    if (p != null):
        position = p
    if (f != null):
        angle = deg2rad(f)

func setPosition(p:Vector2):
    if (p != null):
        position = p

func setAngle(f:float):
    if (f != null):
        angle = deg2rad(f)

func getAngle():
    return angle

## VELOCITY AND MOMENTUM LINEAR

func setVelocityRelative(v:Vector2):
    if (v != null):
        momentumRelative = v * mass
    momentumAbsolute = rel2abs(momentumRelative)

func setMomentumRelative(v:Vector2):
    momentumRelative = abs2rel(momentumAbsolute)
    if (v != null):
        momentumRelative = v
    momentumAbsolute = rel2abs(momentumRelative)

func setPowerRelative(v:Vector2):
    if (v != null):
        powerRelative = v

func setVelocityAbsolute(v:Vector2):
    if (v != null):
        momentumAbsolute = v * mass

func setMomentumAbsolute(v:Vector2):
    if (v != null):
        momentumAbsolute = v

func getVelocityAbsolute():
    return velocityAbsolute

func getVelocityRelative():
    return velocityRelative

func getVelocityRotational():
    return velocityRotational

func getMomentumRelative():
    return abs2rel(momentumAbsolute)

func getMomentumAbsolute():
    return momentumAbsolute

func getMomentumRotational():
    return momentumRotational

## VELOCITY AND MOMENTUM ROTATIONAL


func setVelocityRotational(f):
    if (f != null):
        velocityRotational = f

func setMomentumRotational(f):
    if (f != null):
        momentumRotational = f

func setPowerRotational(f):
    if (f != null):
        powerRotational = f


## ADVANCED FUNCTIONS


func processMovement(delta):
    # friction needed

    velocityRelative = abs2rel(momentumAbsolute / mass) + utils.sqrt2_keepSign(delta * powerRelative / mass)
    velocityAbsolute = rel2abs(velocityRelative)

    velocityRotational = (momentumRotational / inertia) + utils.sqrt_keepSign(delta * powerRotational / inertia)
    angle = fmod(angle + velocityRotational * delta, 2*PI)

    # update
    momentumAbsolute = velocityAbsolute * mass
    momentumRotational = velocityRotational * inertia

    return [velocityAbsolute * delta, rad2deg(angle)]


func dampMomentum(dampMultiplier, cutOffValueLinear, cutOffValueRotational):
    # -- to do: import cutOffValues here
    # -- to do: (probably) modify 'dampMultiplier' into 'dampValue' related to positional engines
    # --        maybe even calculate it outside?
    momentumAbsolute *= dampMultiplier
    momentumAbsolute.x = 0 if (momentumAbsolute.x <= cutOffValueLinear && momentumAbsolute.x >= -cutOffValueLinear) else momentumAbsolute.x
    momentumAbsolute.y = 0 if (momentumAbsolute.y <= cutOffValueLinear && momentumAbsolute.y >= -cutOffValueLinear) else momentumAbsolute.y

    momentumRotational *= dampMultiplier
    momentumRotational = 0 if (momentumRotational <= cutOffValueRotational && momentumRotational >= -cutOffValueRotational) else momentumRotational


func collisionTest(object, collider, collisionPosition, normal):
    var kPri = object.kinematic
    var kSec = collider.kinematic
    var aRel = -normal.angle()
    var dPri = (object.position - collisionPosition).rotated(aRel)
    var dSec = (collider.position - collisionPosition).rotated(aRel)
    var vPri = kPri.getMomentumAbsolute().rotated(aRel) / kPri.mass
    var vSec = kSec.getMomentumAbsolute().rotated(aRel) / kSec.mass
    var vFriction = abs(2*atan((vPri.x - vSec.x)/(vPri.y - vSec.y))/PI)
    var vPriRot = dPri.tangent().normalized() * (kPri.getMomentumRotational() * dPri.length() / kPri.inertia)
    var vSecRot = dSec.tangent().normalized() * (kSec.getMomentumRotational() * dSec.length() / kSec.inertia)
    # ---------------- #
    var vAN = vPri.x
    var vATF = vPri.y * vFriction
    var vATr = vPri.y * (1-vFriction)
    var vRAN = vPriRot.x
    var vRATF = vPriRot.y * vFriction
    var vRATr = vPriRot.y * (1-vFriction)
    var vBN = vSec.x
    var vBTF = vSec.y * vFriction
    var vBTr = vSec.y * (1-vFriction)
    var vRBN = vSecRot.x
    var vRBTF = vSecRot.y * vFriction
    var vRBTr = vSecRot.y * (1-vFriction)

    var nvPriMom = Vector2(vAN, vATF)
    var aAN = nvPriMom.angle_to(Vector2(1, 0))   # x=cos // y=sin
    var aAD = nvPriMom.angle_to(dSec)            # sin

    var nvPriMomRot = Vector2(vRAN, vRATF)
    var aRAD = nvPriMomRot.angle_to(dSec)        # sin

    var nvSecMom = Vector2(vBN, vBTF)
    var aBN = nvSecMom.angle_to(Vector2(1, 0))   # x=cos // y=sin
    var aBD = nvSecMom.angle_to(dPri)            # sin

    var nvSecMomRot = Vector2(vRBN, vRBTF)
    var aRBD = nvSecMomRot.angle_to(dPri)        # sin

    var A = [ kPri.mass, kSec.mass, kPri.inertia, kSec.inertia, dPri.length(), dSec.length(), aAD, aRAD, aBD, aRBD ]
    var B = [ nvPriMom.length(), nvSecMom.length(), nvPriMomRot.length(), nvSecMomRot.length() ]
    var F = funcref(self, "calc_F1")
    var J = funcref(self, "calc_J1")
    var C = solver.solve_nonlinear(A, B, F, J, -6)
    var uRA = C[2][0]
    var uRB = C[3][0]
    A = [ kPri.mass, kSec.mass, kPri.inertia, kSec.inertia, dPri.length(), dSec.length(), uRA, nvPriMomRot.length(), aAD, aRAD, uRB, nvSecMomRot.length(), aBD, aRBD ]
    B = [ cos(aAN)*nvPriMom.length(), sin(aAN)*nvPriMom.length(), cos(aBN)*nvSecMom.length(), sin(aBN)*nvSecMom.length() ]
    F = funcref(self, "calc_F2")
    J = funcref(self, "calc_J2")
    C = solver.solve_nonlinear(A, B, F, J, -6)
    vPri = Vector2(C[0][0], C[1][0] + vATr)
    vSec = Vector2(C[2][0], C[3][0] + vBTr)
    vPriRot = uRA + (Vector2(0, vRATr).project(dPri.tangent())).length()
    vSecRot = uRB + (Vector2(0, vRBTr).project(dSec.tangent())).length()
    object.kinematic.setMomentumAbsolute(vPri.rotated(-aRel) * kPri.mass)
    collider.kinematic.setMomentumAbsolute(vSec.rotated(-aRel) * kSec.mass)
    object.kinematic.setMomentumRotational(vPriRot * kPri.inertia / dPri.length())
    collider.kinematic.setMomentumRotational(vSecRot * kPri.inertia / dPri.length())


func calc_F1(A, B, C):          #6         #8
    #A: mA, mB, IA, IB, dA, dB, aAD, aRAD, aBD, aRBD
    #B: vA, vB, vRA, vRB
    #C: uA, uB, uRA, uRB
    var tmp = []
#   mA(uA-vA) + mB(uB-vB) = 0
    tmp.append([ A[0]*(C[0][0]-B[0]) + A[1]*(C[1][0]-B[1]) ])
#   mA(uA^2 - vA^2) + mB(uB^2 - vB^2) + IA(uRA^2 - vRA^2)/dA^2 + IB(uRB^2 - vRB^2)/dB^2 = 0
    tmp.append([ A[0]*(C[0][0]*C[0][0] - B[0]*B[0]) + A[1]*(C[1][0]*C[1][0] - B[1]*B[1]) + A[2]*(C[2][0]*C[2][0] - B[2]*B[2])/(A[4]*A[4]) + A[3]*(C[3][0]*C[3][0] - B[3]*B[3])/(A[5]*A[5]) ])
#   IA*(uRA-vRA)/dA - mB(uBD-vBD)/dA + IB*(uRBD-vRBD)/dB = 0
    tmp.append([ A[2]*(C[2][0]-B[2])/A[4] + A[1]*sin(A[8])*(C[1][0]-B[1])/A[4] + A[3]*sin(A[9])*(C[3][0]-B[3])/A[5] ])
#   IB*(uRB-vRB)/dB - mA(uAD-vAD)/dB + IA*(uRAD-vRAD)/dA = 0
    tmp.append([ A[3]*(C[3][0]-B[3])/A[5] + A[0]*sin(A[6])*(C[0][0]-B[0])/A[5] + A[2]*sin(A[7])*(C[2][0]-B[2])/A[4] ])
    return tmp

func calc_J1(A, B, C):
    var tmp = []
#   tmp.append([ A[0]*(C[0][0]-B[0]) + A[1]*(C[1][0]-B[1]) ])
    tmp.append([ A[0], A[1], 0, 0 ])
#   tmp.append([ A[0]*(C[0][0]*C[0][0] - B[0]*B[0]) + A[1]*(C[1][0]*C[1][0] - B[1]*B[1]) + A[2]*(C[2][0]*C[2][0] - B[2]*B[2])/(A[4]*A[4]) + A[3]*(C[3][0]*C[3][0] - B[3]*B[3])/(A[5]*A[5]) ])
    tmp.append([ 2*A[0]*C[0][0], 2*A[1]*C[1][0], 2*A[2]*C[2][0]/(A[4]*A[4]), 2*A[3]*C[3][0]/(A[5]*A[5]) ])
#   tmp.append([ A[2]*(C[2][0]-B[2])/A[4] + A[1]*sin(A[8])*(C[1][0]-B[1])/A[4] + A[3]*sin(A[9])*(C[3][0]-B[3])/A[5] ])
    tmp.append([ 0, -A[1]*sin(A[8])/A[4], A[2]/A[4], -A[3]*sin(A[9])/A[5] ])
#   tmp.append([ A[3]*(C[3][0]-B[3])/A[5] + A[0]*sin(A[6])*(C[0][0]-B[0])/A[5] + A[2]*sin(A[7])*(C[2][0]-B[2])/A[4] ])
    tmp.append([ -A[0]*sin(A[6])/A[5], 0, -A[2]*sin(A[7])/A[4], A[3]/A[5] ])
    return tmp

func calc_F2(A, B, C):          #6                    #10
    #A: mA, mB, IA, IB, dA, dB, uRA, vRA, aAND, aRAD, uRB, vRB, aBND, aRBD,
    #B: vAN, vATF, vBN, vBTF,
    #C: uAN, uATF, uBN, uBTF,
    var tmp = []
#   mA(uAN-vAN) + mB(uBN-vBN) = 0
    tmp.append([ A[0]*(C[0][0]-B[0]) + A[1]*(C[2][0]-B[2]) ])
#   mA(uATF-vATF) + mB(uBTF-vBTF) = 0
    tmp.append([ A[0]*(C[1][0]-B[1]) + A[1]*(C[3][0]-B[3]) ])
#   IA*(uRA-vRA)/dA + mB((uBND-vBND) + (uBTFD-vBTFD))/dA + IB*(uRBD-vRBD)/dB = 0
    tmp.append([ A[2]*(A[6]-A[7])/A[4] - A[1]*(sin(A[12])*(C[2][0]-B[2]) - cos(A[12])*(C[3][0]-B[3]))/A[4] - A[3]*sin(A[13])*(A[10]-A[11])/A[5] ])
#   IB*(uRB-vRB)/dB + mA((uAND-vAND) + (uATFD-vATFD))/dB + IA*(uRAD-vRAD)/dA = 0
    tmp.append([ A[3]*(A[10]-A[11])/A[5] - A[0]*(sin(A[8])*(C[0][0]-B[0]) - cos(A[8])*(C[1][0]-B[1]))/A[5] - A[2]*sin(A[9])*(A[6]-A[7])/A[4] ])
    return tmp

func calc_J2(A, B, C):
    var tmp = []
#   tmp.append([ A[0]*(C[0][0]-B[0]) + A[1]*(C[2][0]-B[2]) ])
    tmp.append([ A[0], 0, A[1], 0 ])
#   tmp.append([ A[0]*(C[1][0]-B[1]) + A[1]*(C[3][0]-B[3]) ])
    tmp.append([ 0, A[0], 0, A[1] ])
#   tmp.append([ A[2]*(A[6]-A[7])/A[4] + A[1]*(sin(A[12])*(C[2][0]-B[2]) - cos(A[12])*(C[3][0]-B[3]))/A[4] + A[3]*sin(A[13])*(A[10]-A[11])/A[5] ])
    tmp.append([ 0, 0, -A[1]*sin(A[12])/A[4], A[1]*cos(A[12])/A[4] ])
#   tmp.append([ A[3]*(A[10]-A[11])/A[5] + A[0]*(sin(A[8])*(C[0][0]-B[0]) - cos(A[8])*(C[1][0]-B[1]))/A[5] + A[2]*sin(A[9])*(A[6]-A[7])/A[4] ])
    tmp.append([ -A[0]*sin(A[8])/A[5], A[0]*cos(A[8])/A[5], 0, 0 ])
    return tmp

func collideWithObject(object, delta):
    breakpoint
    pass

