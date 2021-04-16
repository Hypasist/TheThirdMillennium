class_name Weapon
extends Node2D
var LASER = load("res://LASER.tscn") 
onready var space = get_tree().get_root().get_node("GAME")

var projectileBaseSpeed = 600
var projectileBaseLifetime = 3.0
var cannonMaxAngle = 70
var cannonRotationSpeed = 100

func getWeaponKinematicInfo():
    var slotKinematicInfo = get_parent().getSlotKinematicInfo()
    slotKinematicInfo["positionAbs"] += position.rotated(deg2rad(slotKinematicInfo["rotationAbs"]))
    slotKinematicInfo["rotationAbs"] += rotation_degrees
    return slotKinematicInfo


func _ready():
    pass

func getBarrelAngle():
    return $Barrel.rotation_degrees

func setBarrelAngle(f:float):
    $Barrel.rotation_degrees = f


func _process(delta):
    var weaponKinematicInfo = getWeaponKinematicInfo()
    var currentAngleAbsolute = rad2deg((space.get_global_mouse_position() - weaponKinematicInfo["positionAbs"]).angle())
    var currentAngleRelative = getBarrelAngle()
    var targetAngleRelative = clamp(fmod(currentAngleAbsolute - weaponKinematicInfo["rotationAbs"] + 540, 360) - 180, -cannonMaxAngle, cannonMaxAngle)
    var diffAngle = clamp(fmod(targetAngleRelative - currentAngleRelative + 540, 360) - 180, -delta*cannonRotationSpeed, delta*cannonRotationSpeed)
    setBarrelAngle(getBarrelAngle() + diffAngle)
    
func shoot(container):
    var weaponKinematicInfo = getWeaponKinematicInfo()
    weaponKinematicInfo["rotationAbs"] += getBarrelAngle()
    weaponKinematicInfo["velocityAbs"] += Vector2(projectileBaseSpeed, 0).rotated(deg2rad(weaponKinematicInfo["rotationAbs"]))
    weaponKinematicInfo["velocityAbs"] += (weaponKinematicInfo["massCenterEhWhat"] - weaponKinematicInfo["positionAbs"]) * weaponKinematicInfo["velocityRot"]
    
    var projectile = LASER.instance()
    projectile.setup(weaponKinematicInfo["positionAbs"], weaponKinematicInfo["rotationAbs"], weaponKinematicInfo["velocityAbs"], projectileBaseLifetime)
    container.add_child(projectile)
