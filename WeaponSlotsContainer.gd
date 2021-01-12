class_name WeaponSlotsContainer
extends Node

onready var projectileContainer = get_tree().get_root().get_node("./GAME/Projectiles")

func getShipKinematicInfo():
    var ship:Ship = get_parent()
    return [ship.position, ship.rotation_degrees, ship.kinematic.getVelocityAbsolute(), ship.kinematic.getVelocityRotational(), ship.kinematic.getMassCenter() + ship.position]

func _ready():
    pass

# TODO
# projectiles should be armed after 'BODY LEFT" signal

func shootWeapons():
    $LeftSlot.shoot(projectileContainer);
    $RightSlot.shoot(projectileContainer);
