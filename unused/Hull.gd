extends Sprite

func _ready():
    pass # Replace with function body.

func animate_ship(vector):
    $MainLeftEngine.set_power(vector.x)
    $MainRightEngine.set_power(vector.x)
    
