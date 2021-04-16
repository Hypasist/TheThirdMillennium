class_name WeaponSlotsContainer
extends Node

onready var projectileContainer = get_tree().get_root().get_node("./GAME/Projectiles")

func getShipKinematicInfo():
    return get_parent().getKinematicInfo()

func _ready():
    pass

# TODO
# projectiles should be armed after 'BODY LEFT" signal

func shootWeapons():
    $LeftSlot.shoot(projectileContainer);
    $RightSlot.shoot(projectileContainer);
