class_name WeaponSlot
extends Node2D

func getSlotKinematicInfo():
    var shipKinematicInfo = get_parent().getShipKinematicInfo()
    shipKinematicInfo["positionAbs"] += position.rotated(deg2rad(shipKinematicInfo["rotationAbs"]))
    shipKinematicInfo["rotationAbs"] += rotation_degrees
    return shipKinematicInfo
    
func _ready():
    pass # Replace with function body.

func shoot(projectileContainer):
    $Cannon.shoot(projectileContainer)
