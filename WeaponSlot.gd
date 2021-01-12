class_name WeaponSlot
extends Node2D

func getSlotKinematicInfo():
    var shipKinematicInfo = get_parent().getShipKinematicInfo()
    shipKinematicInfo[0] += position.rotated(deg2rad(shipKinematicInfo[1]))
    shipKinematicInfo[1] += rotation_degrees
    return shipKinematicInfo
    
func _ready():
    pass # Replace with function body.

func shoot(projectileContainer):
    $Cannon.shoot(projectileContainer)
